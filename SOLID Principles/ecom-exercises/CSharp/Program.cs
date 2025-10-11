using System;
using System.Collections.Generic;
using System.Data;
using Npgsql;

namespace EcomApp
{
    // VIOLATION: Single Responsibility Principle
    // This class handles products, database operations, cart management, order processing, invoice generation, email sending, logging, customer management, inventory management, and reporting
    public class EcommerceManager
    {
        private string connectionString = "Host=localhost;Username=postgres;Password=postgres123;Database=bounteous_ecom";
        private List<Product> products = new List<Product>();
        private List<Customer> customers = new List<Customer>();
        private List<Cart> carts = new List<Cart>();
        private List<Order> orders = new List<Order>();
        private List<Invoice> invoices = new List<Invoice>();

        // VIOLATION: Single Responsibility - Product management
        public List<Product> GetProducts()
        {
            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand("SELECT id, name, price, sku FROM products", conn);
            using var reader = cmd.ExecuteReader();
            products.Clear();
            while (reader.Read())
            {
                products.Add(new Product 
                { 
                    Id = reader.GetInt32(0), 
                    Name = reader.GetString(1), 
                    Price = reader.GetDecimal(2),
                    Sku = reader.GetString(3)
                });
            }
            return products;
        }

        // VIOLATION: Single Responsibility - Customer management
        public int CreateCustomer(string email, string firstName, string lastName, string phone, string address)
        {
            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand(
                "INSERT INTO customers (email, first_name, last_name, phone, address) VALUES (@email, @firstName, @lastName, @phone, @address) RETURNING id",
                conn);
            cmd.Parameters.AddWithValue("@email", email);
            cmd.Parameters.AddWithValue("@firstName", firstName);
            cmd.Parameters.AddWithValue("@lastName", lastName);
            cmd.Parameters.AddWithValue("@phone", phone);
            cmd.Parameters.AddWithValue("@address", address);
            var customerId = (int)cmd.ExecuteScalar();
            
            var customer = new Customer
            {
                Id = customerId,
                Email = email,
                FirstName = firstName,
                LastName = lastName,
                Phone = phone,
                Address = address
            };
            customers.Add(customer);
            
            Console.WriteLine($"Customer {firstName} {lastName} created successfully with ID {customerId}");
            return customerId;
        }

        public void UpdateCustomer(int customerId, string email, string firstName, string lastName, string phone, string address)
        {
            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand(
                "UPDATE customers SET email = @email, first_name = @firstName, last_name = @lastName, phone = @phone, address = @address WHERE id = @customerId",
                conn);
            cmd.Parameters.AddWithValue("@customerId", customerId);
            cmd.Parameters.AddWithValue("@email", email);
            cmd.Parameters.AddWithValue("@firstName", firstName);
            cmd.Parameters.AddWithValue("@lastName", lastName);
            cmd.Parameters.AddWithValue("@phone", phone);
            cmd.Parameters.AddWithValue("@address", address);
            cmd.ExecuteNonQuery();
            
            var customer = customers.Find(c => c.Id == customerId);
            if (customer != null)
            {
                customer.Email = email;
                customer.FirstName = firstName;
                customer.LastName = lastName;
                customer.Phone = phone;
                customer.Address = address;
            }
            
            Console.WriteLine($"Customer {customerId} updated successfully");
        }

        public void DeleteCustomer(int customerId)
        {
            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand("DELETE FROM customers WHERE id = @customerId", conn);
            cmd.Parameters.AddWithValue("@customerId", customerId);
            cmd.ExecuteNonQuery();
            
            customers.RemoveAll(c => c.Id == customerId);
            Console.WriteLine($"Customer {customerId} deleted successfully");
        }

        public Customer GetCustomer(int customerId)
        {
            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand("SELECT id, email, first_name, last_name, phone, address FROM customers WHERE id = @customerId", conn);
            cmd.Parameters.AddWithValue("@customerId", customerId);
            using var reader = cmd.ExecuteReader();
            
            if (reader.Read())
            {
                return new Customer
                {
                    Id = reader.GetInt32(0),
                    Email = reader.GetString(1),
                    FirstName = reader.GetString(2),
                    LastName = reader.GetString(3),
                    Phone = reader.IsDBNull(4) ? null : reader.GetString(4),
                    Address = reader.IsDBNull(5) ? null : reader.GetString(5)
                };
            }
            return null;
        }

        // VIOLATION: Single Responsibility - Cart management
        public int CreateCart(int customerId)
        {
            // VIOLATION: Business logic mixed with data access
            var existingCart = GetCartByCustomerId(customerId);
            if (existingCart != null)
            {
                Console.WriteLine($"Customer {customerId} already has a cart with ID {existingCart.Id}");
                return existingCart.Id;
            }

            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand(
                "INSERT INTO carts (customer_id) VALUES (@customerId) RETURNING id",
                conn);
            cmd.Parameters.AddWithValue("@customerId", customerId);
            var cartId = (int)cmd.ExecuteScalar();
            
            var cart = new Cart
            {
                Id = cartId,
                CustomerId = customerId,
                Items = new List<CartItem>()
            };
            carts.Add(cart);
            
            Console.WriteLine($"Cart created successfully with ID {cartId} for customer {customerId}");
            return cartId;
        }

        public Cart GetCartByCustomerId(int customerId)
        {
            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand("SELECT id, customer_id FROM carts WHERE customer_id = @customerId", conn);
            cmd.Parameters.AddWithValue("@customerId", customerId);
            using var reader = cmd.ExecuteReader();
            
            if (reader.Read())
            {
                var cartId = reader.GetInt32(0);
                var cart = new Cart
                {
                    Id = cartId,
                    CustomerId = customerId,
                    Items = new List<CartItem>()
                };
                
                // Load cart items
                reader.Close();
                using var itemsCmd = new NpgsqlCommand(
                    "SELECT ci.id, ci.product_id, ci.quantity, ci.unit_price, ci.total_price, p.name " +
                    "FROM cart_items ci JOIN products p ON ci.product_id = p.id WHERE ci.cart_id = @cartId",
                    conn);
                itemsCmd.Parameters.AddWithValue("@cartId", cartId);
                using var itemsReader = itemsCmd.ExecuteReader();
                
                while (itemsReader.Read())
                {
                    cart.Items.Add(new CartItem
                    {
                        Id = itemsReader.GetInt32(0),
                        ProductId = itemsReader.GetInt32(1),
                        Quantity = itemsReader.GetInt32(2),
                        UnitPrice = itemsReader.GetDecimal(3),
                        TotalPrice = itemsReader.GetDecimal(4),
                        ProductName = itemsReader.GetString(5)
                    });
                }
                
                return cart;
            }
            return null;
        }

        public void AddToCart(int customerId, int productId, int quantity)
        {
            // VIOLATION: Business logic violation - cannot create cart unless customer exists
            var customer = GetCustomer(customerId);
            if (customer == null)
            {
                Console.WriteLine($"Cannot add to cart: Customer {customerId} does not exist!");
                return;
            }

            var cart = GetCartByCustomerId(customerId);
            if (cart == null)
            {
                Console.WriteLine($"Cannot add to cart: Customer {customerId} does not have a cart!");
                return;
            }

            var product = products.Find(p => p.Id == productId);
            if (product == null)
            {
                Console.WriteLine($"Product {productId} not found!");
                return;
            }

            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            
            // Check if item already exists in cart
            using var checkCmd = new NpgsqlCommand(
                "SELECT id, quantity FROM cart_items WHERE cart_id = @cartId AND product_id = @productId",
                conn);
            checkCmd.Parameters.AddWithValue("@cartId", cart.Id);
            checkCmd.Parameters.AddWithValue("@productId", productId);
            using var checkReader = checkCmd.ExecuteReader();
            
            if (checkReader.Read())
            {
                // Update existing item
                var existingId = checkReader.GetInt32(0);
                var existingQuantity = checkReader.GetInt32(1);
                checkReader.Close();
                
                var newQuantity = existingQuantity + quantity;
                var newTotalPrice = newQuantity * product.Price;
                
                using var updateCmd = new NpgsqlCommand(
                    "UPDATE cart_items SET quantity = @quantity, total_price = @totalPrice WHERE id = @id",
                    conn);
                updateCmd.Parameters.AddWithValue("@quantity", newQuantity);
                updateCmd.Parameters.AddWithValue("@totalPrice", newTotalPrice);
                updateCmd.Parameters.AddWithValue("@id", existingId);
                updateCmd.ExecuteNonQuery();
                
                Console.WriteLine($"Updated {product.Name} quantity to {newQuantity} in cart");
            }
            else
            {
                // Add new item
                checkReader.Close();
                using var insertCmd = new NpgsqlCommand(
                    "INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, total_price) VALUES (@cartId, @productId, @quantity, @unitPrice, @totalPrice)",
                    conn);
                insertCmd.Parameters.AddWithValue("@cartId", cart.Id);
                insertCmd.Parameters.AddWithValue("@productId", productId);
                insertCmd.Parameters.AddWithValue("@quantity", quantity);
                insertCmd.Parameters.AddWithValue("@unitPrice", product.Price);
                insertCmd.Parameters.AddWithValue("@totalPrice", product.Price * quantity);
                insertCmd.ExecuteNonQuery();
                
                Console.WriteLine($"Added {quantity} {product.Name} to cart");
            }
        }

        public void RemoveFromCart(int customerId, int productId)
        {
            var cart = GetCartByCustomerId(customerId);
            if (cart == null)
            {
                Console.WriteLine($"Customer {customerId} does not have a cart!");
                return;
            }

            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand(
                "DELETE FROM cart_items WHERE cart_id = @cartId AND product_id = @productId",
                conn);
            cmd.Parameters.AddWithValue("@cartId", cart.Id);
            cmd.Parameters.AddWithValue("@productId", productId);
            cmd.ExecuteNonQuery();
            
            Console.WriteLine($"Removed product {productId} from cart");
        }

        public decimal CalculateCartTotal(int customerId)
        {
            var cart = GetCartByCustomerId(customerId);
            if (cart == null) return 0;

            decimal total = 0;
            foreach (var item in cart.Items)
            {
                total += item.TotalPrice;
            }
            return total;
        }

        public void DisplayCart(int customerId)
        {
            var cart = GetCartByCustomerId(customerId);
            if (cart == null)
            {
                Console.WriteLine($"Customer {customerId} does not have a cart!");
                return;
            }

            Console.WriteLine($"=== Shopping Cart for Customer {customerId} ===");
            foreach (var item in cart.Items)
            {
                Console.WriteLine($"{item.ProductName} x{item.Quantity} - ${item.UnitPrice} each = ${item.TotalPrice}");
            }
            Console.WriteLine($"Total: ${CalculateCartTotal(customerId)}");
        }

        // VIOLATION: Single Responsibility - Order processing
        public void ProcessOrder(int customerId)
        {
            var cart = GetCartByCustomerId(customerId);
            if (cart == null || cart.Items.Count == 0)
            {
                Console.WriteLine("Cart is empty or does not exist!");
                return;
            }

            // Create order
            var order = new Order
            {
                Id = orders.Count + 1,
                CustomerId = customerId,
                CartId = cart.Id,
                OrderNumber = $"ORD-{DateTime.Now:yyyyMMdd}-{orders.Count + 1:D4}",
                Items = new List<Product>(),
                Subtotal = CalculateCartTotal(customerId),
                TaxAmount = CalculateCartTotal(customerId) * 0.08m, // 8% tax
                ShippingAmount = 9.99m,
                TotalAmount = CalculateCartTotal(customerId) + (CalculateCartTotal(customerId) * 0.08m) + 9.99m,
                Status = "Pending",
                OrderDate = DateTime.Now
            };

            orders.Add(order);

            // Save to database
            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand(
                "INSERT INTO orders (customer_id, cart_id, order_number, status, subtotal, tax_amount, shipping_amount, total_amount) VALUES (@customerId, @cartId, @orderNumber, @status, @subtotal, @taxAmount, @shippingAmount, @totalAmount) RETURNING id",
                conn);
            cmd.Parameters.AddWithValue("@customerId", order.CustomerId);
            cmd.Parameters.AddWithValue("@cartId", order.CartId);
            cmd.Parameters.AddWithValue("@orderNumber", order.OrderNumber);
            cmd.Parameters.AddWithValue("@status", order.Status);
            cmd.Parameters.AddWithValue("@subtotal", order.Subtotal);
            cmd.Parameters.AddWithValue("@taxAmount", order.TaxAmount);
            cmd.Parameters.AddWithValue("@shippingAmount", order.ShippingAmount);
            cmd.Parameters.AddWithValue("@totalAmount", order.TotalAmount);
            order.Id = (int)cmd.ExecuteScalar();

            // Save order items
            foreach (var cartItem in cart.Items)
            {
                using var itemCmd = new NpgsqlCommand(
                    "INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES (@orderId, @productId, @quantity, @unitPrice, @totalPrice)",
                    conn);
                itemCmd.Parameters.AddWithValue("@orderId", order.Id);
                itemCmd.Parameters.AddWithValue("@productId", cartItem.ProductId);
                itemCmd.Parameters.AddWithValue("@quantity", cartItem.Quantity);
                itemCmd.Parameters.AddWithValue("@unitPrice", cartItem.UnitPrice);
                itemCmd.Parameters.AddWithValue("@totalPrice", cartItem.TotalPrice);
                itemCmd.ExecuteNonQuery();
            }

            // Generate invoice
            GenerateInvoice(order);

            // Send confirmation email
            var customer = GetCustomer(customerId);
            SendConfirmationEmail(customer.Email, order);

            // Log the order
            LogOrder(order);

            // Clear cart
            using var clearCmd = new NpgsqlCommand("DELETE FROM cart_items WHERE cart_id = @cartId", conn);
            clearCmd.Parameters.AddWithValue("@cartId", cart.Id);
            clearCmd.ExecuteNonQuery();

            Console.WriteLine($"Order {order.OrderNumber} processed successfully!");
        }

        // VIOLATION: Single Responsibility - Invoice generation
        public void GenerateInvoice(Order order)
        {
            var invoice = new Invoice
            {
                Id = invoices.Count + 1,
                OrderId = order.Id,
                InvoiceNumber = $"INV-{DateTime.Now:yyyyMMdd}-{invoices.Count + 1:D4}",
                Amount = order.TotalAmount,
                TaxAmount = order.TaxAmount,
                TotalAmount = order.TotalAmount,
                Status = "Pending",
                DueDate = DateTime.Now.AddDays(30),
                CreatedDate = DateTime.Now
            };

            invoices.Add(invoice);

            // Save to database
            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand(
                "INSERT INTO invoices (order_id, invoice_number, status, amount, tax_amount, total_amount, due_date) VALUES (@orderId, @invoiceNumber, @status, @amount, @taxAmount, @totalAmount, @dueDate)",
                conn);
            cmd.Parameters.AddWithValue("@orderId", invoice.OrderId);
            cmd.Parameters.AddWithValue("@invoiceNumber", invoice.InvoiceNumber);
            cmd.Parameters.AddWithValue("@status", invoice.Status);
            cmd.Parameters.AddWithValue("@amount", invoice.Amount);
            cmd.Parameters.AddWithValue("@taxAmount", invoice.TaxAmount);
            cmd.Parameters.AddWithValue("@totalAmount", invoice.TotalAmount);
            cmd.Parameters.AddWithValue("@dueDate", invoice.DueDate);
            cmd.ExecuteNonQuery();

            // Generate PDF invoice (simulated)
            GeneratePDFInvoice(invoice);

            Console.WriteLine($"Invoice {invoice.InvoiceNumber} generated for order {order.OrderNumber}");
        }

        // VIOLATION: Single Responsibility - PDF generation
        private void GeneratePDFInvoice(Invoice invoice)
        {
            // Simulated PDF generation
            Console.WriteLine($"=== INVOICE {invoice.InvoiceNumber} ===");
            Console.WriteLine($"Amount: ${invoice.Amount}");
            Console.WriteLine($"Tax: ${invoice.TaxAmount}");
            Console.WriteLine($"Total: ${invoice.TotalAmount}");
            Console.WriteLine($"Due Date: {invoice.DueDate:yyyy-MM-dd}");
            Console.WriteLine("=== END INVOICE ===");
        }

        // VIOLATION: Single Responsibility - Email sending
        private void SendConfirmationEmail(string email, Order order)
        {
            // Simulated email sending
            Console.WriteLine($"Sending confirmation email to {email}");
            Console.WriteLine($"Subject: Order Confirmation - {order.OrderNumber}");
            Console.WriteLine($"Body: Your order has been processed. Total: ${order.TotalAmount}");
        }

        // VIOLATION: Single Responsibility - Logging
        private void LogOrder(Order order)
        {
            // Simulated logging
            Console.WriteLine($"[LOG] Order processed: {order.OrderNumber}, Customer: {order.CustomerId}, Total: ${order.TotalAmount}");
        }

        // VIOLATION: Single Responsibility - Inventory management
        public void UpdateProductStock(int productId, int newStock)
        {
            using var conn = new NpgsqlConnection(connectionString);
            conn.Open();
            using var cmd = new NpgsqlCommand(
                "UPDATE products SET stock_quantity = @stock WHERE id = @productId",
                conn);
            cmd.Parameters.AddWithValue("@stock", newStock);
            cmd.Parameters.AddWithValue("@productId", productId);
            cmd.ExecuteNonQuery();
            Console.WriteLine($"Updated stock for product {productId} to {newStock}");
        }

        // VIOLATION: Single Responsibility - Reporting
        public void GenerateSalesReport()
        {
            decimal totalSales = 0;
            foreach (var order in orders)
            {
                totalSales += order.TotalAmount;
            }
            Console.WriteLine($"=== SALES REPORT ===");
            Console.WriteLine($"Total Orders: {orders.Count}");
            Console.WriteLine($"Total Sales: ${totalSales}");
            Console.WriteLine($"Average Order Value: ${orders.Count > 0 ? totalSales / orders.Count : 0}");
        }
    }

    // VIOLATION: Open/Closed Principle - Hard-coded classes that can't be extended
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string Sku { get; set; }
    }

    public class Customer
    {
        public int Id { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Phone { get; set; }
        public string Address { get; set; }
    }

    public class Cart
    {
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public List<CartItem> Items { get; set; } = new List<CartItem>();
    }

    public class CartItem
    {
        public int Id { get; set; }
        public int ProductId { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal TotalPrice { get; set; }
        public string ProductName { get; set; }
    }

    public class Order
    {
        public int Id { get; set; }
        public int CustomerId { get; set; }
        public int CartId { get; set; }
        public string OrderNumber { get; set; }
        public List<Product> Items { get; set; }
        public decimal Subtotal { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal ShippingAmount { get; set; }
        public decimal TotalAmount { get; set; }
        public string Status { get; set; }
        public DateTime OrderDate { get; set; }
    }

    public class Invoice
    {
        public int Id { get; set; }
        public int OrderId { get; set; }
        public string InvoiceNumber { get; set; }
        public decimal Amount { get; set; }
        public decimal TaxAmount { get; set; }
        public decimal TotalAmount { get; set; }
        public string Status { get; set; }
        public DateTime DueDate { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    class Program
    {
        static void Main()
        {
            var ecommerce = new EcommerceManager();
            
            Console.WriteLine("=== E-commerce System (SOLID Violations Demo) ===");
            
            // Load products
            var products = ecommerce.GetProducts();
            Console.WriteLine("Available Products:");
            foreach (var product in products)
            {
                Console.WriteLine($"{product.Id}. {product.Name} - ${product.Price}");
            }
            
            // Create a customer
            var customerId = ecommerce.CreateCustomer("john.doe@example.com", "John", "Doe", "555-0101", "123 Main St");
            
            // Create a cart for the customer
            var cartId = ecommerce.CreateCart(customerId);
            
            // Add items to cart
            ecommerce.AddToCart(customerId, 1, 2); // Add 2 laptops
            ecommerce.AddToCart(customerId, 2, 1); // Add 1 mouse
            
            // Display cart
            ecommerce.DisplayCart(customerId);
            
            // Process order
            ecommerce.ProcessOrder(customerId);
            
            // Generate sales report
            ecommerce.GenerateSalesReport();
        }
    }
}