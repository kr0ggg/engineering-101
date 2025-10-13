import java.sql.*;
import java.util.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

// VIOLATION: Single Responsibility Principle
// This class handles products, database operations, cart management, order processing, invoice generation, email sending, logging, customer management, inventory management, and reporting
public class EcommerceManager {
    private String connectionString = "jdbc:postgresql://localhost:5432/bounteous_ecom";
    private String username = "postgres";
    private String password = "postgres123";
    private List<Product> products = new ArrayList<>();
    private List<Customer> customers = new ArrayList<>();
    private List<Cart> carts = new ArrayList<>();
    private List<Order> orders = new ArrayList<>();
    private List<Invoice> invoices = new ArrayList<>();

    // VIOLATION: Single Responsibility - Product management
    public List<Product> getProducts() throws SQLException {
        Connection conn = DriverManager.getConnection(connectionString, username, password);
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT id, name, price, sku FROM products");
        products.clear();
        while (rs.next()) {
            products.add(new Product(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getDouble("price"),
                rs.getString("sku")
            ));
        }
        conn.close();
        return products;
    }

    // VIOLATION: Single Responsibility - Customer management
    public int createCustomer(String email, String firstName, String lastName, String phone, String address) throws SQLException {
        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO customers (email, first_name, last_name, phone, address) VALUES (?, ?, ?, ?, ?)",
            Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, email);
        stmt.setString(2, firstName);
        stmt.setString(3, lastName);
        stmt.setString(4, phone);
        stmt.setString(5, address);
        stmt.executeUpdate();
        
        ResultSet generatedKeys = stmt.getGeneratedKeys();
        int customerId = 0;
        if (generatedKeys.next()) {
            customerId = generatedKeys.getInt(1);
        }
        
        Customer customer = new Customer(customerId, email, firstName, lastName, phone, address);
        customers.add(customer);
        
        System.out.println("Customer " + firstName + " " + lastName + " created successfully with ID " + customerId);
        conn.close();
        return customerId;
    }

    public void updateCustomer(int customerId, String email, String firstName, String lastName, String phone, String address) throws SQLException {
        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement(
            "UPDATE customers SET email = ?, first_name = ?, last_name = ?, phone = ?, address = ? WHERE id = ?");
        stmt.setString(1, email);
        stmt.setString(2, firstName);
        stmt.setString(3, lastName);
        stmt.setString(4, phone);
        stmt.setString(5, address);
        stmt.setInt(6, customerId);
        stmt.executeUpdate();
        
        Customer customer = customers.stream()
            .filter(c -> c.getId() == customerId)
            .findFirst()
            .orElse(null);
        if (customer != null) {
            customer.setEmail(email);
            customer.setFirstName(firstName);
            customer.setLastName(lastName);
            customer.setPhone(phone);
            customer.setAddress(address);
        }
        
        System.out.println("Customer " + customerId + " updated successfully");
        conn.close();
    }

    public void deleteCustomer(int customerId) throws SQLException {
        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement("DELETE FROM customers WHERE id = ?");
        stmt.setInt(1, customerId);
        stmt.executeUpdate();
        
        customers.removeIf(c -> c.getId() == customerId);
        System.out.println("Customer " + customerId + " deleted successfully");
        conn.close();
    }

    public Customer getCustomer(int customerId) throws SQLException {
        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT id, email, first_name, last_name, phone, address FROM customers WHERE id = ?");
        stmt.setInt(1, customerId);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            Customer customer = new Customer(
                rs.getInt("id"),
                rs.getString("email"),
                rs.getString("first_name"),
                rs.getString("last_name"),
                rs.getString("phone"),
                rs.getString("address")
            );
            conn.close();
            return customer;
        }
        conn.close();
        return null;
    }

    // VIOLATION: Single Responsibility - Cart management
    public int createCart(int customerId) throws SQLException {
        // VIOLATION: Business logic mixed with data access
        Cart existingCart = getCartByCustomerId(customerId);
        if (existingCart != null) {
            System.out.println("Customer " + customerId + " already has a cart with ID " + existingCart.getId());
            return existingCart.getId();
        }

        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO carts (customer_id) VALUES (?)",
            Statement.RETURN_GENERATED_KEYS);
        stmt.setInt(1, customerId);
        stmt.executeUpdate();
        
        ResultSet generatedKeys = stmt.getGeneratedKeys();
        int cartId = 0;
        if (generatedKeys.next()) {
            cartId = generatedKeys.getInt(1);
        }
        
        Cart cart = new Cart(cartId, customerId, new ArrayList<>());
        carts.add(cart);
        
        System.out.println("Cart created successfully with ID " + cartId + " for customer " + customerId);
        conn.close();
        return cartId;
    }

    public Cart getCartByCustomerId(int customerId) throws SQLException {
        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT id, customer_id FROM carts WHERE customer_id = ?");
        stmt.setInt(1, customerId);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            int cartId = rs.getInt("id");
            Cart cart = new Cart(cartId, customerId, new ArrayList<>());
            
            // Load cart items
            PreparedStatement itemsStmt = conn.prepareStatement(
                "SELECT ci.id, ci.product_id, ci.quantity, ci.unit_price, ci.total_price, p.name " +
                "FROM cart_items ci JOIN products p ON ci.product_id = p.id WHERE ci.cart_id = ?");
            itemsStmt.setInt(1, cartId);
            ResultSet itemsRs = itemsStmt.executeQuery();
            
            while (itemsRs.next()) {
                cart.getItems().add(new CartItem(
                    itemsRs.getInt("id"),
                    itemsRs.getInt("product_id"),
                    itemsRs.getInt("quantity"),
                    itemsRs.getDouble("unit_price"),
                    itemsRs.getDouble("total_price"),
                    itemsRs.getString("name")
                ));
            }
            
            conn.close();
            return cart;
        }
        conn.close();
        return null;
    }

    public void addToCart(int customerId, int productId, int quantity) throws SQLException {
        // VIOLATION: Business logic violation - cannot create cart unless customer exists
        Customer customer = getCustomer(customerId);
        if (customer == null) {
            System.out.println("Cannot add to cart: Customer " + customerId + " does not exist!");
            return;
        }

        Cart cart = getCartByCustomerId(customerId);
        if (cart == null) {
            System.out.println("Cannot add to cart: Customer " + customerId + " does not have a cart!");
            return;
        }

        Product product = products.stream()
            .filter(p -> p.getId() == productId)
            .findFirst()
            .orElse(null);
        if (product == null) {
            System.out.println("Product " + productId + " not found!");
            return;
        }

        Connection conn = DriverManager.getConnection(connectionString, username, password);
        
        // Check if item already exists in cart
        PreparedStatement checkStmt = conn.prepareStatement(
            "SELECT id, quantity FROM cart_items WHERE cart_id = ? AND product_id = ?");
        checkStmt.setInt(1, cart.getId());
        checkStmt.setInt(2, productId);
        ResultSet checkRs = checkStmt.executeQuery();
        
        if (checkRs.next()) {
            // Update existing item
            int existingId = checkRs.getInt("id");
            int existingQuantity = checkRs.getInt("quantity");
            
            int newQuantity = existingQuantity + quantity;
            double newTotalPrice = newQuantity * product.getPrice();
            
            PreparedStatement updateStmt = conn.prepareStatement(
                "UPDATE cart_items SET quantity = ?, total_price = ? WHERE id = ?");
            updateStmt.setInt(1, newQuantity);
            updateStmt.setDouble(2, newTotalPrice);
            updateStmt.setInt(3, existingId);
            updateStmt.executeUpdate();
            
            System.out.println("Updated " + product.getName() + " quantity to " + newQuantity + " in cart");
        } else {
            // Add new item
            PreparedStatement insertStmt = conn.prepareStatement(
                "INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)");
            insertStmt.setInt(1, cart.getId());
            insertStmt.setInt(2, productId);
            insertStmt.setInt(3, quantity);
            insertStmt.setDouble(4, product.getPrice());
            insertStmt.setDouble(5, product.getPrice() * quantity);
            insertStmt.executeUpdate();
            
            System.out.println("Added " + quantity + " " + product.getName() + " to cart");
        }
        
        conn.close();
    }

    public void removeFromCart(int customerId, int productId) throws SQLException {
        Cart cart = getCartByCustomerId(customerId);
        if (cart == null) {
            System.out.println("Customer " + customerId + " does not have a cart!");
            return;
        }

        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement(
            "DELETE FROM cart_items WHERE cart_id = ? AND product_id = ?");
        stmt.setInt(1, cart.getId());
        stmt.setInt(2, productId);
        stmt.executeUpdate();
        
        System.out.println("Removed product " + productId + " from cart");
        conn.close();
    }

    public double calculateCartTotal(int customerId) throws SQLException {
        Cart cart = getCartByCustomerId(customerId);
        if (cart == null) return 0;

        return cart.getItems().stream()
            .mapToDouble(CartItem::getTotalPrice)
            .sum();
    }

    public void displayCart(int customerId) throws SQLException {
        Cart cart = getCartByCustomerId(customerId);
        if (cart == null) {
            System.out.println("Customer " + customerId + " does not have a cart!");
            return;
        }

        System.out.println("=== Shopping Cart for Customer " + customerId + " ===");
        for (CartItem item : cart.getItems()) {
            System.out.println(item.getProductName() + " x" + item.getQuantity() + 
                " - $" + item.getUnitPrice() + " each = $" + item.getTotalPrice());
        }
        System.out.println("Total: $" + calculateCartTotal(customerId));
    }

    // VIOLATION: Single Responsibility - Order processing
    public void processOrder(int customerId) throws SQLException {
        Cart cart = getCartByCustomerId(customerId);
        if (cart == null || cart.getItems().isEmpty()) {
            System.out.println("Cart is empty or does not exist!");
            return;
        }

        // Create order
        Order order = new Order();
        order.setId(orders.size() + 1);
        order.setCustomerId(customerId);
        order.setCartId(cart.getId());
        order.setOrderNumber("ORD-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "-" + String.format("%04d", orders.size() + 1));
        order.setItems(new ArrayList<>());
        order.setSubtotal(calculateCartTotal(customerId));
        order.setTaxAmount(calculateCartTotal(customerId) * 0.08); // 8% tax
        order.setShippingAmount(9.99);
        order.setTotalAmount(calculateCartTotal(customerId) + (calculateCartTotal(customerId) * 0.08) + 9.99);
        order.setStatus("Pending");
        order.setOrderDate(LocalDateTime.now());

        orders.add(order);

        // Save to database
        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO orders (customer_id, cart_id, order_number, status, subtotal, tax_amount, shipping_amount, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            Statement.RETURN_GENERATED_KEYS);
        stmt.setInt(1, order.getCustomerId());
        stmt.setInt(2, order.getCartId());
        stmt.setString(3, order.getOrderNumber());
        stmt.setString(4, order.getStatus());
        stmt.setDouble(5, order.getSubtotal());
        stmt.setDouble(6, order.getTaxAmount());
        stmt.setDouble(7, order.getShippingAmount());
        stmt.setDouble(8, order.getTotalAmount());
        stmt.executeUpdate();

        ResultSet generatedKeys = stmt.getGeneratedKeys();
        if (generatedKeys.next()) {
            order.setId(generatedKeys.getInt(1));
        }

        // Save order items
        for (CartItem cartItem : cart.getItems()) {
            PreparedStatement itemStmt = conn.prepareStatement(
                "INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?)");
            itemStmt.setInt(1, order.getId());
            itemStmt.setInt(2, cartItem.getProductId());
            itemStmt.setInt(3, cartItem.getQuantity());
            itemStmt.setDouble(4, cartItem.getUnitPrice());
            itemStmt.setDouble(5, cartItem.getTotalPrice());
            itemStmt.executeUpdate();
        }

        // Generate invoice
        generateInvoice(order);

        // Send confirmation email
        Customer customer = getCustomer(customerId);
        sendConfirmationEmail(customer.getEmail(), order);

        // Log the order
        logOrder(order);

        // Clear cart
        PreparedStatement clearStmt = conn.prepareStatement("DELETE FROM cart_items WHERE cart_id = ?");
        clearStmt.setInt(1, cart.getId());
        clearStmt.executeUpdate();

        System.out.println("Order " + order.getOrderNumber() + " processed successfully!");
        conn.close();
    }

    // VIOLATION: Single Responsibility - Invoice generation
    public void generateInvoice(Order order) throws SQLException {
        Invoice invoice = new Invoice();
        invoice.setId(invoices.size() + 1);
        invoice.setOrderId(order.getId());
        invoice.setInvoiceNumber("INV-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "-" + String.format("%04d", invoices.size() + 1));
        invoice.setAmount(order.getTotalAmount());
        invoice.setTaxAmount(order.getTaxAmount());
        invoice.setTotalAmount(order.getTotalAmount());
        invoice.setStatus("Pending");
        invoice.setDueDate(LocalDateTime.now().plusDays(30));
        invoice.setCreatedDate(LocalDateTime.now());

        invoices.add(invoice);

        // Save to database
        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement(
            "INSERT INTO invoices (order_id, invoice_number, status, amount, tax_amount, total_amount, due_date) VALUES (?, ?, ?, ?, ?, ?, ?)");
        stmt.setInt(1, invoice.getOrderId());
        stmt.setString(2, invoice.getInvoiceNumber());
        stmt.setString(3, invoice.getStatus());
        stmt.setDouble(4, invoice.getAmount());
        stmt.setDouble(5, invoice.getTaxAmount());
        stmt.setDouble(6, invoice.getTotalAmount());
        stmt.setDate(7, Date.valueOf(invoice.getDueDate().toLocalDate()));
        stmt.executeUpdate();

        // Generate PDF invoice (simulated)
        generatePDFInvoice(invoice);

        System.out.println("Invoice " + invoice.getInvoiceNumber() + " generated for order " + order.getOrderNumber());
        conn.close();
    }

    // VIOLATION: Single Responsibility - PDF generation
    private void generatePDFInvoice(Invoice invoice) {
        // Simulated PDF generation
        System.out.println("=== INVOICE " + invoice.getInvoiceNumber() + " ===");
        System.out.println("Amount: $" + invoice.getAmount());
        System.out.println("Tax: $" + invoice.getTaxAmount());
        System.out.println("Total: $" + invoice.getTotalAmount());
        System.out.println("Due Date: " + invoice.getDueDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        System.out.println("=== END INVOICE ===");
    }

    // VIOLATION: Single Responsibility - Email sending
    private void sendConfirmationEmail(String email, Order order) {
        // Simulated email sending
        System.out.println("Sending confirmation email to " + email);
        System.out.println("Subject: Order Confirmation - " + order.getOrderNumber());
        System.out.println("Body: Your order has been processed. Total: $" + order.getTotalAmount());
    }

    // VIOLATION: Single Responsibility - Logging
    private void logOrder(Order order) {
        // Simulated logging
        System.out.println("[LOG] Order processed: " + order.getOrderNumber() + ", Customer: " + order.getCustomerId() + ", Total: $" + order.getTotalAmount());
    }

    // VIOLATION: Single Responsibility - Inventory management
    public void updateProductStock(int productId, int newStock) throws SQLException {
        Connection conn = DriverManager.getConnection(connectionString, username, password);
        PreparedStatement stmt = conn.prepareStatement(
            "UPDATE products SET stock_quantity = ? WHERE id = ?");
        stmt.setInt(1, newStock);
        stmt.setInt(2, productId);
        stmt.executeUpdate();
        System.out.println("Updated stock for product " + productId + " to " + newStock);
        conn.close();
    }

    // VIOLATION: Single Responsibility - Reporting
    public void generateSalesReport() {
        double totalSales = orders.stream()
            .mapToDouble(Order::getTotalAmount)
            .sum();
        System.out.println("=== SALES REPORT ===");
        System.out.println("Total Orders: " + orders.size());
        System.out.println("Total Sales: $" + totalSales);
        System.out.println("Average Order Value: $" + (orders.size() > 0 ? totalSales / orders.size() : 0));
    }
}

// VIOLATION: Open/Closed Principle - Hard-coded classes that can't be extended
class Product {
    private int id;
    private String name;
    private double price;
    private String sku;

    public Product(int id, String name, double price, String sku) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.sku = sku;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
}

class Customer {
    private int id;
    private String email;
    private String firstName;
    private String lastName;
    private String phone;
    private String address;

    public Customer(int id, String email, String firstName, String lastName, String phone, String address) {
        this.id = id;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.phone = phone;
        this.address = address;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}

class Cart {
    private int id;
    private int customerId;
    private List<CartItem> items;

    public Cart(int id, int customerId, List<CartItem> items) {
        this.id = id;
        this.customerId = customerId;
        this.items = items;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public List<CartItem> getItems() { return items; }
    public void setItems(List<CartItem> items) { this.items = items; }
}

class CartItem {
    private int id;
    private int productId;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
    private String productName;

    public CartItem(int id, int productId, int quantity, double unitPrice, double totalPrice, String productName) {
        this.id = id;
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.productName = productName;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
}

class Order {
    private int id;
    private int customerId;
    private int cartId;
    private String orderNumber;
    private List<Product> items;
    private double subtotal;
    private double taxAmount;
    private double shippingAmount;
    private double totalAmount;
    private String status;
    private LocalDateTime orderDate;

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }
    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }
    public List<Product> getItems() { return items; }
    public void setItems(List<Product> items) { this.items = items; }
    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
    public double getTaxAmount() { return taxAmount; }
    public void setTaxAmount(double taxAmount) { this.taxAmount = taxAmount; }
    public double getShippingAmount() { return shippingAmount; }
    public void setShippingAmount(double shippingAmount) { this.shippingAmount = shippingAmount; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }
}

class Invoice {
    private int id;
    private int orderId;
    private String invoiceNumber;
    private double amount;
    private double taxAmount;
    private double totalAmount;
    private String status;
    private LocalDateTime dueDate;
    private LocalDateTime createdDate;

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public String getInvoiceNumber() { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    public double getTaxAmount() { return taxAmount; }
    public void setTaxAmount(double taxAmount) { this.taxAmount = taxAmount; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getDueDate() { return dueDate; }
    public void setDueDate(LocalDateTime dueDate) { this.dueDate = dueDate; }
    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }
}

public class Main {
    public static void main(String[] args) throws SQLException {
        EcommerceManager ecommerce = new EcommerceManager();
        
        System.out.println("=== E-commerce System (SOLID Violations Demo) ===");
        
        // Load products
        List<Product> products = ecommerce.getProducts();
        System.out.println("Available Products:");
        for (Product product : products) {
            System.out.println(product.getId() + ". " + product.getName() + " - $" + product.getPrice());
        }
        
        // Create a customer
        int customerId = ecommerce.createCustomer("john.doe@example.com", "John", "Doe", "555-0101", "123 Main St");
        
        // Create a cart for the customer
        int cartId = ecommerce.createCart(customerId);
        
        // Add items to cart
        ecommerce.addToCart(customerId, 1, 2); // Add 2 laptops
        ecommerce.addToCart(customerId, 2, 1); // Add 1 mouse
        
        // Display cart
        ecommerce.displayCart(customerId);
        
        // Process order
        ecommerce.processOrder(customerId);
        
        // Generate sales report
        ecommerce.generateSalesReport();
    }
}