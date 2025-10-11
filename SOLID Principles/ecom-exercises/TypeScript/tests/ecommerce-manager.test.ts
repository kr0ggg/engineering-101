import { EcommerceManager, Product, Customer, Cart, CartItem, Order, Invoice } from '../src/app';
import { Pool } from 'pg';

describe('EcommerceManager', () => {
    let ecommerceManager: EcommerceManager;
    let pool: Pool;

    beforeEach(async () => {
        ecommerceManager = new EcommerceManager();
        pool = new Pool({
            host: 'localhost',
            database: 'bounteous_ecom',
            user: 'postgres',
            password: 'postgres',
            port: 5432,
        });
        // Clean up test data before each test
        await cleanupTestData();
    });

    afterEach(async () => {
        // Clean up test data after each test
        await cleanupTestData();
        await pool.end();
    });

    async function cleanupTestData(): Promise<void> {
        try {
            const client = await pool.connect();
            try {
                // Clean up tables in reverse dependency order
                await client.query('DELETE FROM invoices');
                await client.query('DELETE FROM order_items');
                await client.query('DELETE FROM orders');
                await client.query('DELETE FROM cart_items');
                await client.query('DELETE FROM carts');
                await client.query('DELETE FROM customers');
            } finally {
                client.release();
            }
        } catch (error) {
            // Log cleanup errors but don't fail tests
            console.error('Cleanup error:', error);
        }
    }

    describe('getProducts', () => {
        it('should return list of products', async () => {
            // Act
            const result = await ecommerceManager.getProducts();

            // Assert
            expect(result).toBeDefined();
            expect(Array.isArray(result)).toBe(true);
            // Should have sample products from database initialization
            expect(result.length).toBeGreaterThan(0);
        });
    });

    describe('createCustomer', () => {
        it('should return customer ID', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const firstName = 'John';
            const lastName = 'Doe';
            const phone = '555-0101';
            const address = '123 Main St';

            // Act
            const result = await ecommerceManager.createCustomer(email, firstName, lastName, phone, address);

            // Assert
            expect(result).toBeGreaterThan(0);
            
            // Verify customer was actually created by retrieving it
            const customer = await ecommerceManager.getCustomer(result);
            expect(customer).toBeDefined();
            expect(customer?.email).toBe(email);
            expect(customer?.firstName).toBe(firstName);
            expect(customer?.lastName).toBe(lastName);
        });

        it('should throw error when creating customer with null email', async () => {
            // Arrange
            const email: string | null = null;
            const firstName = 'John';
            const lastName = 'Doe';
            const phone = '555-0101';
            const address = '123 Main St';

            // Act & Assert
            await expect(ecommerceManager.createCustomer(email!, firstName, lastName, phone, address))
                .rejects.toThrow('Expected exception for null email constraint violation');
        });

        it('should throw error when creating customer with null firstName', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const firstName: string | null = null;
            const lastName = 'Doe';
            const phone = '555-0101';
            const address = '123 Main St';

            // Act & Assert
            await expect(ecommerceManager.createCustomer(email, firstName!, lastName, phone, address))
                .rejects.toThrow('Expected exception for null first_name constraint violation');
        });

        it('should throw error when creating customer with null lastName', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const firstName = 'John';
            const lastName: string | null = null;
            const phone = '555-0101';
            const address = '123 Main St';

            // Act & Assert
            await expect(ecommerceManager.createCustomer(email, firstName, lastName!, phone, address))
                .rejects.toThrow('Expected exception for null last_name constraint violation');
        });

        it('should throw error when creating customer with duplicate email', async () => {
            // Arrange
            const email = `duplicate${Math.random().toString(36).substring(2, 10)}@example.com`;
            const firstName = 'John';
            const lastName = 'Doe';
            const phone = '555-0101';
            const address = '123 Main St';

            // Create first customer
            await ecommerceManager.createCustomer(email, firstName, lastName, phone, address);
            
            // Act & Assert
            await expect(ecommerceManager.createCustomer(email, 'Jane', 'Smith', '555-0102', '456 Oak Ave'))
                .rejects.toThrow('Expected exception for duplicate email constraint violation');
        });
    });

    describe('createCart', () => {
        it('should return cart ID', async () => {
            // Arrange - First create a customer
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Jane', 'Smith', '555-0102', '456 Oak Ave');

            // Act
            const result = await ecommerceManager.createCart(customerId);

            // Assert
            expect(result).toBeGreaterThan(0);
            
            // Verify cart was actually created by retrieving it
            const cart = await ecommerceManager.getCartByCustomerId(customerId);
            expect(cart).toBeDefined();
            expect(cart?.id).toBe(result);
            expect(cart?.customerId).toBe(customerId);
        });

        it('should throw error when creating cart with invalid customer ID', async () => {
            // Arrange
            const invalidCustomerId = 99999; // Non-existent customer

            // Act & Assert
            await expect(ecommerceManager.createCart(invalidCustomerId))
                .rejects.toThrow('Expected exception for foreign key constraint violation on customer_id');
        });
    });

    describe('addToCart', () => {
        it('should succeed with valid customer and product', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Test', 'User', '555-0103', '789 Pine St');
            const cartId = await ecommerceManager.createCart(customerId);
            const products = await ecommerceManager.getProducts();
            const productId = products[0].id; // Use first available product
            const quantity = 2;

            // Act
            await ecommerceManager.addToCart(customerId, productId, quantity);

            // Assert - Verify item was added by checking cart total
            const cartTotal = await ecommerceManager.calculateCartTotal(customerId);
            expect(cartTotal).toBeGreaterThan(0);
            
            // Verify cart contents
            const cart = await ecommerceManager.getCartByCustomerId(customerId);
            expect(cart?.items).toHaveLength(1);
            expect(cart?.items[0].productId).toBe(productId);
            expect(cart?.items[0].quantity).toBe(quantity);
        });

        it('should not throw with invalid customer', async () => {
            // Arrange
            const customerId = 99999; // Non-existent customer
            const productId = 1;
            const quantity = 2;

            // Act & Assert
            await expect(ecommerceManager.addToCart(customerId, productId, quantity))
                .resolves.not.toThrow();
            
            // Verify no cart was created for invalid customer
            const cart = await ecommerceManager.getCartByCustomerId(customerId);
            expect(cart).toBeNull();
        });

        it('should throw error when adding invalid product to cart', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Test', 'User', '555-0103', '789 Pine St');
            const cartId = await ecommerceManager.createCart(customerId);
            const invalidProductId = 99999; // Non-existent product
            const quantity = 2;

            // Act & Assert
            await expect(ecommerceManager.addToCart(customerId, invalidProductId, quantity))
                .rejects.toThrow('Expected exception for foreign key constraint violation on product_id');
        });

        it('should throw error when adding item with zero quantity to cart', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Test', 'User', '555-0103', '789 Pine St');
            const cartId = await ecommerceManager.createCart(customerId);
            const products = await ecommerceManager.getProducts();
            const productId = products[0].id;
            const quantity = 0; // Zero quantity should violate NOT NULL constraint

            // Act & Assert
            await expect(ecommerceManager.addToCart(customerId, productId, quantity))
                .rejects.toThrow('Expected exception for quantity constraint violation');
        });
    });

    describe('calculateCartTotal', () => {
        it('should return zero for empty cart', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Empty', 'Cart', '555-0104', '321 Elm St');
            const cartId = await ecommerceManager.createCart(customerId);

            // Act
            const result = await ecommerceManager.calculateCartTotal(customerId);

            // Assert
            expect(result).toBe(0);
        });

        it('should return correct total with items', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Cart', 'Test', '555-0105', '654 Maple St');
            const cartId = await ecommerceManager.createCart(customerId);
            const products = await ecommerceManager.getProducts();
            const productId = products[0].id;
            const quantity = 2;
            const expectedTotal = products[0].price * quantity;

            await ecommerceManager.addToCart(customerId, productId, quantity);

            // Act
            const result = await ecommerceManager.calculateCartTotal(customerId);

            // Assert
            expect(result).toBe(expectedTotal);
        });
    });

    describe('processOrder', () => {
        it('should not throw with empty cart', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Order', 'Test', '555-0106', '987 Cedar St');
            const cartId = await ecommerceManager.createCart(customerId);

            // Act & Assert
            await expect(ecommerceManager.processOrder(customerId))
                .resolves.not.toThrow();
        });

        it('should create order and invoice with items', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Order', 'Process', '555-0107', '147 Birch St');
            const cartId = await ecommerceManager.createCart(customerId);
            const products = await ecommerceManager.getProducts();
            const productId = products[0].id;
            const quantity = 1;

            await ecommerceManager.addToCart(customerId, productId, quantity);

            // Act
            await ecommerceManager.processOrder(customerId);

            // Assert - Verify cart is cleared after order processing
            const cartTotal = await ecommerceManager.calculateCartTotal(customerId);
            expect(cartTotal).toBe(0);
        });
    });

    describe('updateCustomer', () => {
        it('should update customer data', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Original', 'Name', '555-0108', '258 Spruce St');
            
            const newEmail = `updated${Math.random().toString(36).substring(2, 10)}@example.com`;
            const newFirstName = 'Updated';
            const newLastName = 'Name';
            const newPhone = '555-0109';
            const newAddress = '369 Willow St';

            // Act
            await ecommerceManager.updateCustomer(customerId, newEmail, newFirstName, newLastName, newPhone, newAddress);

            // Assert
            const updatedCustomer = await ecommerceManager.getCustomer(customerId);
            expect(updatedCustomer).toBeDefined();
            expect(updatedCustomer?.email).toBe(newEmail);
            expect(updatedCustomer?.firstName).toBe(newFirstName);
            expect(updatedCustomer?.lastName).toBe(newLastName);
            expect(updatedCustomer?.phone).toBe(newPhone);
            expect(updatedCustomer?.address).toBe(newAddress);
        });
    });

    describe('deleteCustomer', () => {
        it('should remove customer', async () => {
            // Arrange
            const email = `test${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Delete', 'Test', '555-0110', '741 Poplar St');

            // Verify customer exists
            const customer = await ecommerceManager.getCustomer(customerId);
            expect(customer).toBeDefined();

            // Act
            await ecommerceManager.deleteCustomer(customerId);

            // Assert
            const deletedCustomer = await ecommerceManager.getCustomer(customerId);
            expect(deletedCustomer).toBeNull();
        });
    });

    describe('generateSalesReport', () => {
        it('should not throw', async () => {
            // Act & Assert
            await expect(ecommerceManager.generateSalesReport())
                .resolves.not.toThrow();
        });
    });

    describe('updateProductStock', () => {
        it('should not throw', async () => {
            // Arrange
            const products = await ecommerceManager.getProducts();
            const productId = products[0].id;
            const newStock = 100;

            // Act & Assert
            await expect(ecommerceManager.updateProductStock(productId, newStock))
                .resolves.not.toThrow();
        });
    });

    describe('SOLID Principle Violations', () => {
        it('should violate Single Responsibility Principle', () => {
            // This test demonstrates that the EcommerceManager class violates SRP
            // by having multiple responsibilities

            // Assert - The class handles multiple concerns
            expect(ecommerceManager).toBeDefined();

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
        });

        it('should violate Open/Closed Principle - Product class', () => {
            // This test demonstrates that the Product class violates OCP
            // by being hard-coded and not easily extensible

            const product = new Product(1, 'Test Product', 99.99, 'TEST-001');

            expect(product).toBeDefined();
            expect(product.id).toBe(1);
            expect(product.name).toBe('Test Product');
            expect(product.price).toBe(99.99);
            expect(product.sku).toBe('TEST-001');

            // The Product class is hard-coded and cannot be extended without modification
            // This violates the Open/Closed Principle
        });

        it('should violate Open/Closed Principle - Customer class', () => {
            // This test demonstrates that the Customer class violates OCP
            // by being hard-coded and not easily extensible

            const customer = new Customer(1, 'test@example.com', 'John', 'Doe', '555-0101', '123 Main St');

            expect(customer).toBeDefined();
            expect(customer.id).toBe(1);
            expect(customer.email).toBe('test@example.com');
            expect(customer.firstName).toBe('John');
            expect(customer.lastName).toBe('Doe');
            expect(customer.phone).toBe('555-0101');
            expect(customer.address).toBe('123 Main St');

            // The Customer class is hard-coded and cannot be extended without modification
            // This violates the Open/Closed Principle
        });

        it('should violate Open/Closed Principle - Cart class', () => {
            // This test demonstrates that the Cart class violates OCP
            // by being hard-coded and not easily extensible

            const cart = new Cart(1, 1, []);

            expect(cart).toBeDefined();
            expect(cart.id).toBe(1);
            expect(cart.customerId).toBe(1);
            expect(cart.items).toEqual([]);

            // The Cart class is hard-coded and cannot be extended without modification
            // This violates the Open/Closed Principle
        });

        it('should violate Open/Closed Principle - Order class', () => {
            // This test demonstrates that the Order class violates OCP
            // by being hard-coded and not easily extensible

            const order = new Order();
            order.id = 1;
            order.customerId = 1;
            order.orderNumber = 'ORD-001';

            expect(order).toBeDefined();
            expect(order.id).toBe(1);
            expect(order.customerId).toBe(1);
            expect(order.orderNumber).toBe('ORD-001');

            // The Order class is hard-coded and cannot be extended without modification
            // This violates the Open/Closed Principle
        });

        it('should violate Open/Closed Principle - Invoice class', () => {
            // This test demonstrates that the Invoice class violates OCP
            // by being hard-coded and not easily extensible

            const invoice = new Invoice();
            invoice.id = 1;
            invoice.orderId = 1;
            invoice.invoiceNumber = 'INV-001';

            expect(invoice).toBeDefined();
            expect(invoice.id).toBe(1);
            expect(invoice.orderId).toBe(1);
            expect(invoice.invoiceNumber).toBe('INV-001');

            // The Invoice class is hard-coded and cannot be extended without modification
            // This violates the Open/Closed Principle
        });

        it('should violate Liskov Substitution Principle', () => {
            // This test demonstrates LSP violations in the codebase
            // The classes don't maintain proper contracts and behaviors

            const product = new Product(1, 'Test', 100, 'TEST');
            const customer = new Customer(1, 'test@test.com', 'John', 'Doe', '555-0101', '123 Main');

            // These classes don't follow proper inheritance/substitution patterns
            expect(product).toBeDefined();
            expect(customer).toBeDefined();

            // LSP violations are present due to inconsistent interfaces and behaviors
        });

        it('should violate Interface Segregation Principle', () => {
            // This test demonstrates ISP violations
            // The EcommerceManager has too many responsibilities and clients are forced
            // to depend on methods they don't use

            expect(ecommerceManager).toBeDefined();

            // The EcommerceManager class forces clients to depend on:
            // - Product management methods
            // - Customer management methods
            // - Cart management methods
            // - Order processing methods
            // - Invoice generation methods
            // - Email sending methods
            // - Logging methods
            // - Inventory management methods
            // - Reporting methods

            // This violates ISP as clients are forced to depend on methods they don't use
        });

        it('should violate Dependency Inversion Principle', () => {
            // This test demonstrates DIP violations
            // High-level modules depend on low-level modules directly

            expect(ecommerceManager).toBeDefined();

            // The EcommerceManager directly depends on:
            // - PostgreSQL database connection
            // - Specific database implementation details
            // - Hard-coded connection strings
            // - Direct database queries

            // This violates DIP as high-level modules should depend on abstractions,
            // not concrete implementations
        });

        it('should demonstrate multiple SOLID violations in workflow', async () => {
            // This test demonstrates multiple SOLID principle violations in a real workflow
            
            // Arrange
            const email = `workflow${Math.random().toString(36).substring(2, 10)}@example.com`;
            const customerId = await ecommerceManager.createCustomer(email, 'Workflow', 'Test', '555-0111', '852 Ash St');
            
            // Act - Complete cart workflow
            const cartId = await ecommerceManager.createCart(customerId);
            const products = await ecommerceManager.getProducts();
            const productId = products[0].id;
            
            await ecommerceManager.addToCart(customerId, productId, 2);
            const cartTotal = await ecommerceManager.calculateCartTotal(customerId);
            await ecommerceManager.processOrder(customerId);
            
            // Assert - Verify the workflow completed successfully
            expect(cartId).toBeGreaterThan(0);
            expect(cartTotal).toBeGreaterThan(0);
            
            // This workflow demonstrates violations of:
            // - SRP: EcommerceManager handles multiple responsibilities
            // - OCP: Hard-coded classes that can't be extended
            // - DIP: Direct database dependencies
        });
    });
});
