package com.bounteous.ecom;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.AfterEach;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

class EcommerceManagerTests {

    private EcommerceManager ecommerceManager;
    private static final String CONNECTION_STRING = "jdbc:postgresql://localhost:5432/bounteous_ecom";
    private static final String USERNAME = "postgres";
    private static final String PASSWORD = "postgres123";

    @BeforeEach
    void setUp() {
        ecommerceManager = new EcommerceManager();
    }

    @AfterEach
    void tearDown() {
        // Clean up test data after each test (except products table which is seeded)
        cleanupTestData();
    }

    private void cleanupTestData() {
        try (Connection connection = DriverManager.getConnection(CONNECTION_STRING, USERNAME, PASSWORD);
             Statement statement = connection.createStatement()) {
            
            // Clean up tables in reverse dependency order
            statement.executeUpdate("DELETE FROM invoices");
            statement.executeUpdate("DELETE FROM order_items");
            statement.executeUpdate("DELETE FROM orders");
            statement.executeUpdate("DELETE FROM cart_items");
            statement.executeUpdate("DELETE FROM carts");
            statement.executeUpdate("DELETE FROM customers");
            
        } catch (SQLException ex) {
            // Log cleanup errors but don't fail tests
            System.err.println("Cleanup error: " + ex.getMessage());
        }
    }

    @Test
    void getProducts_ShouldReturnListOfProducts() throws SQLException {
        // Act
        List<Product> result = ecommerceManager.getProducts();

        // Assert
        assertThat(result).isNotNull();
        assertThat(result).isInstanceOf(List.class);
        // Should have sample products from database initialization
        assertThat(result).hasSizeGreaterThan(0);
    }

    @Test
    void createCustomer_ShouldReturnCustomerId() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        String firstName = "John";
        String lastName = "Doe";
        String phone = "555-0101";
        String address = "123 Main St";

        // Act
        int result = ecommerceManager.createCustomer(email, firstName, lastName, phone, address);

        // Assert
        assertThat(result).isGreaterThan(0);
        
        // Verify customer was actually created by retrieving it
        Customer customer = ecommerceManager.getCustomer(result);
        assertThat(customer).isNotNull();
        assertThat(customer.getEmail()).isEqualTo(email);
        assertThat(customer.getFirstName()).isEqualTo(firstName);
        assertThat(customer.getLastName()).isEqualTo(lastName);
    }

    @Test
    void createCustomer_WithNullEmail_ShouldThrowException() {
        // Arrange
        String email = null;
        String firstName = "John";
        String lastName = "Doe";
        String phone = "555-0101";
        String address = "123 Main St";

        // Act & Assert
        assertThatThrownBy(() -> ecommerceManager.createCustomer(email, firstName, lastName, phone, address))
                .isInstanceOf(Exception.class)
                .hasMessageContaining("null value in column \"email\"");
    }

    @Test
    void createCustomer_WithNullFirstName_ShouldThrowException() {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        String firstName = null;
        String lastName = "Doe";
        String phone = "555-0101";
        String address = "123 Main St";

        // Act & Assert
        assertThatThrownBy(() -> ecommerceManager.createCustomer(email, firstName, lastName, phone, address))
                .isInstanceOf(Exception.class)
                .hasMessageContaining("null value in column \"first_name\"");
    }

    @Test
    void createCustomer_WithNullLastName_ShouldThrowException() {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        String firstName = "John";
        String lastName = null;
        String phone = "555-0101";
        String address = "123 Main St";

        // Act & Assert
        assertThatThrownBy(() -> ecommerceManager.createCustomer(email, firstName, lastName, phone, address))
                .isInstanceOf(Exception.class)
                .hasMessageContaining("null value in column \"last_name\"");
    }

    @Test
    void createCustomer_WithDuplicateEmail_ShouldThrowException() throws SQLException {
        // Arrange
        String email = "duplicate" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        String firstName = "John";
        String lastName = "Doe";
        String phone = "555-0101";
        String address = "123 Main St";

        // Create first customer
        ecommerceManager.createCustomer(email, firstName, lastName, phone, address);

        // Act & Assert - Try to create second customer with same email
        assertThatThrownBy(() -> ecommerceManager.createCustomer(email, "Jane", "Smith", "555-0102", "456 Oak Ave"))
                .isInstanceOf(Exception.class)
                .hasMessageContaining("duplicate key value violates unique constraint");
    }

    @Test
    void createCart_ShouldReturnCartId() throws SQLException {
        // Arrange - First create a customer
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Jane", "Smith", "555-0102", "456 Oak Ave");

        // Act
        int result = ecommerceManager.createCart(customerId);

        // Assert
        assertThat(result).isGreaterThan(0);
        
        // Verify cart was actually created by retrieving it
        Cart cart = ecommerceManager.getCartByCustomerId(customerId);
        assertThat(cart).isNotNull();
        assertThat(cart.getId()).isEqualTo(result);
        assertThat(cart.getCustomerId()).isEqualTo(customerId);
    }

    @Test
    void createCart_WithInvalidCustomerId_ShouldThrowException() {
        // Arrange
        int invalidCustomerId = 99999; // Non-existent customer

        // Act & Assert
        assertThatThrownBy(() -> ecommerceManager.createCart(invalidCustomerId))
                .isInstanceOf(Exception.class)
                .hasMessageContaining("violates foreign key constraint");
    }

    @Test
    void addToCart_WithValidCustomerAndProduct_ShouldSucceed() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Test", "User", "555-0103", "789 Pine St");
        int cartId = ecommerceManager.createCart(customerId);
        List<Product> products = ecommerceManager.getProducts();
        int productId = products.get(0).getId(); // Use first available product
        int quantity = 2;

        // Act
        ecommerceManager.addToCart(customerId, productId, quantity);

        // Assert - Verify item was added by checking cart total
        double cartTotal = ecommerceManager.calculateCartTotal(customerId);
        assertThat(cartTotal).isGreaterThan(0);
        
        // Verify cart contents
        Cart cart = ecommerceManager.getCartByCustomerId(customerId);
        assertThat(cart.getItems()).hasSize(1);
        assertThat(cart.getItems().get(0).getProductId()).isEqualTo(productId);
        assertThat(cart.getItems().get(0).getQuantity()).isEqualTo(quantity);
    }

    @Test
    void addToCart_WithInvalidCustomer_ShouldNotThrow() throws SQLException {
        // Arrange
        int customerId = 99999; // Non-existent customer
        int productId = 1;
        int quantity = 2;

        // Act & Assert
        assertThatCode(() -> ecommerceManager.addToCart(customerId, productId, quantity))
                .doesNotThrowAnyException();
        
        // Verify no cart was created for invalid customer
        Cart cart = ecommerceManager.getCartByCustomerId(customerId);
        assertThat(cart).isNull();
    }

    @Test
    void addToCart_WithInvalidProductId_ShouldNotThrow() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Test", "User", "555-0103", "789 Pine St");
        int cartId = ecommerceManager.createCart(customerId);
        int invalidProductId = 99999; // Non-existent product
        int quantity = 2;

        // Act & Assert - The method should not throw because it validates product existence first
        assertThatCode(() -> ecommerceManager.addToCart(customerId, invalidProductId, quantity))
                .doesNotThrowAnyException();
    }

    @Test
    void addToCart_WithZeroQuantity_ShouldNotThrow() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Test", "User", "555-0103", "789 Pine St");
        int cartId = ecommerceManager.createCart(customerId);
        List<Product> products = ecommerceManager.getProducts();
        int productId = products.get(0).getId();
        int quantity = 0; // Zero quantity

        // Act & Assert - The method should not throw because it validates product existence first
        assertThatCode(() -> ecommerceManager.addToCart(customerId, productId, quantity))
                .doesNotThrowAnyException();
    }

    @Test
    void calculateCartTotal_WithEmptyCart_ShouldReturnZero() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Empty", "Cart", "555-0104", "321 Elm St");
        int cartId = ecommerceManager.createCart(customerId);

        // Act
        double result = ecommerceManager.calculateCartTotal(customerId);

        // Assert
        assertThat(result).isEqualTo(0.0);
    }

    @Test
    void calculateCartTotal_WithItems_ShouldReturnCorrectTotal() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Cart", "Test", "555-0105", "654 Maple St");
        int cartId = ecommerceManager.createCart(customerId);
        List<Product> products = ecommerceManager.getProducts();
        int productId = products.get(0).getId();
        int quantity = 2;
        double expectedTotal = products.get(0).getPrice() * quantity;

        ecommerceManager.addToCart(customerId, productId, quantity);

        // Act
        double result = ecommerceManager.calculateCartTotal(customerId);

        // Assert
        assertThat(result).isEqualTo(expectedTotal);
    }

    @Test
    void processOrder_WithEmptyCart_ShouldNotThrow() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Order", "Test", "555-0106", "987 Cedar St");
        int cartId = ecommerceManager.createCart(customerId);

        // Act & Assert
        assertThatCode(() -> ecommerceManager.processOrder(customerId))
                .doesNotThrowAnyException();
    }

    @Test
    void processOrder_WithItems_ShouldCreateOrderAndInvoice() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Order", "Process", "555-0107", "147 Birch St");
        int cartId = ecommerceManager.createCart(customerId);
        List<Product> products = ecommerceManager.getProducts();
        int productId = products.get(0).getId();
        int quantity = 1;

        ecommerceManager.addToCart(customerId, productId, quantity);

        // Act
        ecommerceManager.processOrder(customerId);

        // Assert - Verify cart is cleared after order processing
        double cartTotal = ecommerceManager.calculateCartTotal(customerId);
        assertThat(cartTotal).isEqualTo(0);
    }

    @Test
    void updateCustomer_ShouldUpdateCustomerData() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Original", "Name", "555-0108", "258 Spruce St");
        
        String newEmail = "updated" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        String newFirstName = "Updated";
        String newLastName = "Name";
        String newPhone = "555-0109";
        String newAddress = "369 Willow St";

        // Act
        ecommerceManager.updateCustomer(customerId, newEmail, newFirstName, newLastName, newPhone, newAddress);

        // Assert
        Customer updatedCustomer = ecommerceManager.getCustomer(customerId);
        assertThat(updatedCustomer).isNotNull();
        assertThat(updatedCustomer.getEmail()).isEqualTo(newEmail);
        assertThat(updatedCustomer.getFirstName()).isEqualTo(newFirstName);
        assertThat(updatedCustomer.getLastName()).isEqualTo(newLastName);
        assertThat(updatedCustomer.getPhone()).isEqualTo(newPhone);
        assertThat(updatedCustomer.getAddress()).isEqualTo(newAddress);
    }

    @Test
    void deleteCustomer_ShouldRemoveCustomer() throws SQLException {
        // Arrange
        String email = "test" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Delete", "Test", "555-0110", "741 Poplar St");

        // Verify customer exists
        Customer customer = ecommerceManager.getCustomer(customerId);
        assertThat(customer).isNotNull();

        // Act
        ecommerceManager.deleteCustomer(customerId);

        // Assert
        Customer deletedCustomer = ecommerceManager.getCustomer(customerId);
        assertThat(deletedCustomer).isNull();
    }

    @Test
    void generateSalesReport_ShouldNotThrow() throws SQLException {
        // Act & Assert
        assertThatCode(() -> ecommerceManager.generateSalesReport())
                .doesNotThrowAnyException();
    }

    @Test
    void updateProductStock_ShouldNotThrow() throws SQLException {
        // Arrange
        List<Product> products = ecommerceManager.getProducts();
        int productId = products.get(0).getId();
        int newStock = 100;

        // Act & Assert
        assertThatCode(() -> ecommerceManager.updateProductStock(productId, newStock))
                .doesNotThrowAnyException();
    }

    @Test
    void product_ShouldViolateOpenClosedPrinciple() {
        // This test demonstrates that the Product class violates OCP
        // by being hard-coded and not easily extensible

        Product product = new Product(1, "Test Product", 99.99, "TEST-001");

        assertThat(product).isNotNull();
        assertThat(product.getId()).isEqualTo(1);
        assertThat(product.getName()).isEqualTo("Test Product");
        assertThat(product.getPrice()).isEqualTo(99.99);
        assertThat(product.getSku()).isEqualTo("TEST-001");

        // The Product class is hard-coded and cannot be extended without modification
        // This violates the Open/Closed Principle
    }

    @Test
    void customer_ShouldViolateOpenClosedPrinciple() {
        // This test demonstrates that the Customer class violates OCP
        // by being hard-coded and not easily extensible

        Customer customer = new Customer(1, "test@example.com", "John", "Doe", "555-0101", "123 Main St");

        assertThat(customer).isNotNull();
        assertThat(customer.getId()).isEqualTo(1);
        assertThat(customer.getEmail()).isEqualTo("test@example.com");
        assertThat(customer.getFirstName()).isEqualTo("John");
        assertThat(customer.getLastName()).isEqualTo("Doe");
        assertThat(customer.getPhone()).isEqualTo("555-0101");
        assertThat(customer.getAddress()).isEqualTo("123 Main St");

        // The Customer class is hard-coded and cannot be extended without modification
        // This violates the Open/Closed Principle
    }

    @Test
    void cart_ShouldViolateOpenClosedPrinciple() {
        // This test demonstrates that the Cart class violates OCP
        // by being hard-coded and not easily extensible

        Cart cart = new Cart(1, 1, List.of());

        assertThat(cart).isNotNull();
        assertThat(cart.getId()).isEqualTo(1);
        assertThat(cart.getCustomerId()).isEqualTo(1);
        assertThat(cart.getItems()).isEmpty();

        // The Cart class is hard-coded and cannot be extended without modification
        // This violates the Open/Closed Principle
    }

    @Test
    void order_ShouldViolateOpenClosedPrinciple() {
        // This test demonstrates that the Order class violates OCP
        // by being hard-coded and not easily extensible

        Order order = new Order();
        order.setId(1);
        order.setCustomerId(1);
        order.setOrderNumber("ORD-001");

        assertThat(order).isNotNull();
        assertThat(order.getId()).isEqualTo(1);
        assertThat(order.getCustomerId()).isEqualTo(1);
        assertThat(order.getOrderNumber()).isEqualTo("ORD-001");

        // The Order class is hard-coded and cannot be extended without modification
        // This violates the Open/Closed Principle
    }

    @Test
    void invoice_ShouldViolateOpenClosedPrinciple() {
        // This test demonstrates that the Invoice class violates OCP
        // by being hard-coded and not easily extensible

        Invoice invoice = new Invoice();
        invoice.setId(1);
        invoice.setOrderId(1);
        invoice.setInvoiceNumber("INV-001");

        assertThat(invoice).isNotNull();
        assertThat(invoice.getId()).isEqualTo(1);
        assertThat(invoice.getOrderId()).isEqualTo(1);
        assertThat(invoice.getInvoiceNumber()).isEqualTo("INV-001");

        // The Invoice class is hard-coded and cannot be extended without modification
        // This violates the Open/Closed Principle
    }

    @Test
    void cartWorkflow_ShouldDemonstrateMultipleSOLIDViolations() throws SQLException {
        // This test demonstrates multiple SOLID principle violations in a real workflow
        
        // Arrange
        String email = "workflow" + UUID.randomUUID().toString().substring(0, 8) + "@example.com";
        int customerId = ecommerceManager.createCustomer(email, "Workflow", "Test", "555-0111", "852 Ash St");
        
        // Act - Complete cart workflow
        int cartId = ecommerceManager.createCart(customerId);
        List<Product> products = ecommerceManager.getProducts();
        int productId = products.get(0).getId();
        
        ecommerceManager.addToCart(customerId, productId, 2);
        double cartTotal = ecommerceManager.calculateCartTotal(customerId);
        ecommerceManager.processOrder(customerId);
        
        // Assert - Verify the workflow completed successfully
        assertThat(cartId).isGreaterThan(0);
        assertThat(cartTotal).isGreaterThan(0);
        
        // This workflow demonstrates violations of:
        // - SRP: EcommerceManager handles multiple responsibilities
        // - OCP: Hard-coded classes that can't be extended
        // - DIP: Direct database dependencies
    }
}
