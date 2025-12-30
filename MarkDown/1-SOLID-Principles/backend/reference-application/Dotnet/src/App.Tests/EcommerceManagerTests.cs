using Xunit;
using FluentAssertions;
using System;
using System.Collections.Generic;
using EcomApp;
using Npgsql;

namespace App.Tests
{
    public class EcommerceManagerTests : IDisposable
    {
        private readonly EcommerceManager _ecommerceManager;
        private readonly string _connectionString;

        public EcommerceManagerTests()
        {
            _ecommerceManager = new EcommerceManager();
            _connectionString = "Host=localhost;Database=bounteous_ecom;Username=postgres;Password=postgres123";
        }

        public void Dispose()
        {
            // Clean up test data after each test (except products table which is seeded)
            CleanupTestData();
        }

        private void CleanupTestData()
        {
            try
            {
                using var connection = new NpgsqlConnection(_connectionString);
                connection.Open();
                
                // Clean up tables in reverse dependency order
                using var command = new NpgsqlCommand(@"
                    DELETE FROM invoices;
                    DELETE FROM order_items;
                    DELETE FROM orders;
                    DELETE FROM cart_items;
                    DELETE FROM carts;
                    DELETE FROM customers;
                ", connection);
                
                command.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                // Log cleanup errors but don't fail tests
                Console.WriteLine($"Cleanup error: {ex.Message}");
            }
        }

        [Fact]
        public void GetProducts_ShouldReturnListOfProducts()
        {
            // Act
            var result = _ecommerceManager.GetProducts();

            // Assert
            result.Should().NotBeNull();
            result.Should().BeOfType<List<Product>>();
            // Should have sample products from database initialization
            result.Should().HaveCountGreaterThan(0);
        }

        [Fact]
        public void CreateCustomer_ShouldReturnCustomerId()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var firstName = "John";
            var lastName = "Doe";
            var phone = "555-0101";
            var address = "123 Main St";

            // Act
            var result = _ecommerceManager.CreateCustomer(email, firstName, lastName, phone, address);

            // Assert
            result.Should().BeGreaterThan(0);
            
            // Verify customer was actually created by retrieving it
            var customer = _ecommerceManager.GetCustomer(result);
            customer.Should().NotBeNull();
            customer.Email.Should().Be(email);
            customer.FirstName.Should().Be(firstName);
            customer.LastName.Should().Be(lastName);
        }

        [Fact]
        public void CreateCustomer_WithNullEmail_ShouldThrowException()
        {
            // Arrange
            string email = null;
            var firstName = "John";
            var lastName = "Doe";
            var phone = "555-0101";
            var address = "123 Main St";

            // Act & Assert
            var action = () => _ecommerceManager.CreateCustomer(email, firstName, lastName, phone, address);
            action.Should().Throw<Exception>("Expected exception for null email constraint violation");
        }

        [Fact]
        public void CreateCustomer_WithNullFirstName_ShouldThrowException()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            string firstName = null;
            var lastName = "Doe";
            var phone = "555-0101";
            var address = "123 Main St";

            // Act & Assert
            var action = () => _ecommerceManager.CreateCustomer(email, firstName, lastName, phone, address);
            action.Should().Throw<Exception>("Expected exception for null first_name constraint violation");
        }

        [Fact]
        public void CreateCustomer_WithNullLastName_ShouldThrowException()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var firstName = "John";
            string lastName = null;
            var phone = "555-0101";
            var address = "123 Main St";

            // Act & Assert
            var action = () => _ecommerceManager.CreateCustomer(email, firstName, lastName, phone, address);
            action.Should().Throw<Exception>("Expected exception for null last_name constraint violation");
        }

        [Fact]
        public void CreateCustomer_WithDuplicateEmail_ShouldThrowException()
        {
            // Arrange
            var email = $"duplicate{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var firstName = "John";
            var lastName = "Doe";
            var phone = "555-0101";
            var address = "123 Main St";

            // Create first customer
            _ecommerceManager.CreateCustomer(email, firstName, lastName, phone, address);

            // Act & Assert - Try to create second customer with same email
            var action = () => _ecommerceManager.CreateCustomer(email, "Jane", "Smith", "555-0102", "456 Oak Ave");
            action.Should().Throw<Exception>("Expected exception for duplicate email constraint violation");
        }

        [Fact]
        public void CreateCart_ShouldReturnCartId()
        {
            // Arrange - First create a customer
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Jane", "Smith", "555-0102", "456 Oak Ave");

            // Act
            var result = _ecommerceManager.CreateCart(customerId);

            // Assert
            result.Should().BeGreaterThan(0);
            
            // Verify cart was actually created by retrieving it
            var cart = _ecommerceManager.GetCartByCustomerId(customerId);
            cart.Should().NotBeNull();
            cart.Id.Should().Be(result);
            cart.CustomerId.Should().Be(customerId);
        }

        [Fact]
        public void CreateCart_WithInvalidCustomerId_ShouldThrowException()
        {
            // Arrange
            var invalidCustomerId = 99999; // Non-existent customer

            // Act & Assert
            var action = () => _ecommerceManager.CreateCart(invalidCustomerId);
            action.Should().Throw<Exception>("Expected exception for foreign key constraint violation on customer_id");
        }

        [Fact]
        public void AddToCart_WithValidCustomerAndProduct_ShouldSucceed()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Test", "User", "555-0103", "789 Pine St");
            var cartId = _ecommerceManager.CreateCart(customerId);
            var products = _ecommerceManager.GetProducts();
            var productId = products[0].Id; // Use first available product
            var quantity = 2;

            // Act
            _ecommerceManager.AddToCart(customerId, productId, quantity);

            // Assert - Verify item was added by checking cart total
            var cartTotal = _ecommerceManager.CalculateCartTotal(customerId);
            cartTotal.Should().BeGreaterThan(0);
            
            // Verify cart contents
            var cart = _ecommerceManager.GetCartByCustomerId(customerId);
            cart.Items.Should().HaveCount(1);
            cart.Items[0].ProductId.Should().Be(productId);
            cart.Items[0].Quantity.Should().Be(quantity);
        }

        [Fact]
        public void AddToCart_WithInvalidCustomer_ShouldNotThrow()
        {
            // Arrange
            var customerId = 99999; // Non-existent customer
            var productId = 1;
            var quantity = 2;

            // Act & Assert
            var action = () => _ecommerceManager.AddToCart(customerId, productId, quantity);
            action.Should().NotThrow();
            
            // Verify no cart was created for invalid customer
            var cart = _ecommerceManager.GetCartByCustomerId(customerId);
            cart.Should().BeNull();
        }

        [Fact]
        public void AddToCart_WithInvalidProductId_ShouldNotThrow()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Test", "User", "555-0103", "789 Pine St");
            var cartId = _ecommerceManager.CreateCart(customerId);
            var invalidProductId = 99999; // Non-existent product
            var quantity = 2;

            // Act & Assert - The method should not throw because it validates product existence first
            var action = () => _ecommerceManager.AddToCart(customerId, invalidProductId, quantity);
            action.Should().NotThrow("The method validates product existence and returns early without database operation");
        }

        [Fact]
        public void AddToCart_WithZeroQuantity_ShouldNotThrow()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Test", "User", "555-0103", "789 Pine St");
            var cartId = _ecommerceManager.CreateCart(customerId);
            var products = _ecommerceManager.GetProducts();
            var productId = products[0].Id;
            var quantity = 0; // Zero quantity

            // Act & Assert - The method should not throw because it validates product existence first
            var action = () => _ecommerceManager.AddToCart(customerId, productId, quantity);
            action.Should().NotThrow("The method validates product existence and returns early without database operation");
        }

        [Fact]
        public void CalculateCartTotal_WithEmptyCart_ShouldReturnZero()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Empty", "Cart", "555-0104", "321 Elm St");
            var cartId = _ecommerceManager.CreateCart(customerId);

            // Act
            var result = _ecommerceManager.CalculateCartTotal(customerId);

            // Assert
            result.Should().Be(0);
        }

        [Fact]
        public void CalculateCartTotal_WithItems_ShouldReturnCorrectTotal()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Cart", "Test", "555-0105", "654 Maple St");
            var cartId = _ecommerceManager.CreateCart(customerId);
            var products = _ecommerceManager.GetProducts();
            var productId = products[0].Id;
            var quantity = 2;
            var expectedTotal = products[0].Price * quantity;

            _ecommerceManager.AddToCart(customerId, productId, quantity);

            // Act
            var result = _ecommerceManager.CalculateCartTotal(customerId);

            // Assert
            result.Should().Be(expectedTotal);
        }

        [Fact]
        public void ProcessOrder_WithEmptyCart_ShouldNotThrow()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Order", "Test", "555-0106", "987 Cedar St");
            var cartId = _ecommerceManager.CreateCart(customerId);

            // Act & Assert
            var action = () => _ecommerceManager.ProcessOrder(customerId);
            action.Should().NotThrow();
        }

        [Fact]
        public void ProcessOrder_WithItems_ShouldCreateOrderAndInvoice()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Order", "Process", "555-0107", "147 Birch St");
            var cartId = _ecommerceManager.CreateCart(customerId);
            var products = _ecommerceManager.GetProducts();
            var productId = products[0].Id;
            var quantity = 1;

            _ecommerceManager.AddToCart(customerId, productId, quantity);

            // Act
            _ecommerceManager.ProcessOrder(customerId);

            // Assert - Verify cart is cleared after order processing
            var cartTotal = _ecommerceManager.CalculateCartTotal(customerId);
            cartTotal.Should().Be(0);
        }

        [Fact]
        public void UpdateCustomer_ShouldUpdateCustomerData()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Original", "Name", "555-0108", "258 Spruce St");
            
            var newEmail = $"updated{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var newFirstName = "Updated";
            var newLastName = "Name";
            var newPhone = "555-0109";
            var newAddress = "369 Willow St";

            // Act
            _ecommerceManager.UpdateCustomer(customerId, newEmail, newFirstName, newLastName, newPhone, newAddress);

            // Assert
            var updatedCustomer = _ecommerceManager.GetCustomer(customerId);
            updatedCustomer.Should().NotBeNull();
            updatedCustomer.Email.Should().Be(newEmail);
            updatedCustomer.FirstName.Should().Be(newFirstName);
            updatedCustomer.LastName.Should().Be(newLastName);
            updatedCustomer.Phone.Should().Be(newPhone);
            updatedCustomer.Address.Should().Be(newAddress);
        }

        [Fact]
        public void DeleteCustomer_ShouldRemoveCustomer()
        {
            // Arrange
            var email = $"test{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Delete", "Test", "555-0110", "741 Poplar St");

            // Verify customer exists
            var customer = _ecommerceManager.GetCustomer(customerId);
            customer.Should().NotBeNull();

            // Act
            _ecommerceManager.DeleteCustomer(customerId);

            // Assert
            var deletedCustomer = _ecommerceManager.GetCustomer(customerId);
            deletedCustomer.Should().BeNull();
        }

        [Fact]
        public void GenerateSalesReport_ShouldNotThrow()
        {
            // Act & Assert
            var action = () => _ecommerceManager.GenerateSalesReport();
            action.Should().NotThrow();
        }

        [Fact]
        public void UpdateProductStock_ShouldNotThrow()
        {
            // Arrange
            var products = _ecommerceManager.GetProducts();
            var productId = products[0].Id;
            var newStock = 100;

            // Act & Assert
            var action = () => _ecommerceManager.UpdateProductStock(productId, newStock);
            action.Should().NotThrow();
        }

        [Fact]
        public void EcommerceManager_ShouldViolateSingleResponsibilityPrinciple()
        {
            // This test demonstrates that the EcommerceManager class violates SRP
            // by having multiple responsibilities

            // Assert - The class handles multiple concerns
            _ecommerceManager.Should().NotBeNull();
            
            // The class should have methods for:
            // - Product management
            // - Customer management  
            // - Cart management
            // - Order processing
            // - Invoice generation
            // - Email sending
            // - Logging
            // - Inventory management
            // - Reporting
            
            // This is a violation of SRP as the class has too many reasons to change
        }

        [Fact]
        public void Product_ShouldViolateOpenClosedPrinciple()
        {
            // This test demonstrates that the Product class violates OCP
            // by being hard-coded and not easily extensible

            var product = new Product { Id = 1, Name = "Test Product", Price = 99.99m, Sku = "TEST-001" };
            
            product.Should().NotBeNull();
            product.Id.Should().Be(1);
            product.Name.Should().Be("Test Product");
            product.Price.Should().Be(99.99m);
            product.Sku.Should().Be("TEST-001");
            
            // The Product class is hard-coded and cannot be extended without modification
            // This violates the Open/Closed Principle
        }

        [Fact]
        public void Customer_ShouldViolateOpenClosedPrinciple()
        {
            // This test demonstrates that the Customer class violates OCP
            // by being hard-coded and not easily extensible

            var customer = new Customer 
            { 
                Id = 1, 
                Email = "test@example.com", 
                FirstName = "John", 
                LastName = "Doe", 
                Phone = "555-0101", 
                Address = "123 Main St" 
            };
            
            customer.Should().NotBeNull();
            customer.Id.Should().Be(1);
            customer.Email.Should().Be("test@example.com");
            customer.FirstName.Should().Be("John");
            customer.LastName.Should().Be("Doe");
            customer.Phone.Should().Be("555-0101");
            customer.Address.Should().Be("123 Main St");
            
            // The Customer class is hard-coded and cannot be extended without modification
            // This violates the Open/Closed Principle
        }

        [Fact]
        public void CartWorkflow_ShouldDemonstrateMultipleSOLIDViolations()
        {
            // This test demonstrates multiple SOLID principle violations in a real workflow
            
            // Arrange
            var email = $"workflow{Guid.NewGuid().ToString("N")[..8]}@example.com";
            var customerId = _ecommerceManager.CreateCustomer(email, "Workflow", "Test", "555-0111", "852 Ash St");
            
            // Act - Complete cart workflow
            var cartId = _ecommerceManager.CreateCart(customerId);
            var products = _ecommerceManager.GetProducts();
            var productId = products[0].Id;
            
            _ecommerceManager.AddToCart(customerId, productId, 2);
            var cartTotal = _ecommerceManager.CalculateCartTotal(customerId);
            _ecommerceManager.ProcessOrder(customerId);
            
            // Assert - Verify the workflow completed successfully
            cartId.Should().BeGreaterThan(0);
            cartTotal.Should().BeGreaterThan(0);
            
            // This workflow demonstrates violations of:
            // - SRP: EcommerceManager handles multiple responsibilities
            // - OCP: Hard-coded classes that can't be extended
            // - DIP: Direct database dependencies
        }
    }
}
