import { Client } from 'pg';

// VIOLATION: Single Responsibility Principle
// This class handles products, database operations, cart management, order processing, invoice generation, email sending, logging, customer management, inventory management, and reporting
export class EcommerceManager {
    private client: Client;
    private connected: boolean = false;
    private products: Product[] = [];
    private customers: Customer[] = [];
    private carts: Cart[] = [];
    private orders: Order[] = [];
    private invoices: Invoice[] = [];

    constructor() {
        this.client = new Client({
            user: 'postgres',
            host: 'localhost',
            database: 'bounteous_ecom',
            password: 'postgres123',
            port: 5432,
        });
    }

    private async ensureConnected(): Promise<void> {
        if (!this.connected) {
            await this.client.connect();
            this.connected = true;
        }
    }

    // VIOLATION: Single Responsibility - Product management
    async getProducts(): Promise<Product[]> {
        await this.ensureConnected();
        const res = await this.client.query('SELECT id, name, price, sku FROM products');
        this.products = res.rows.map(row => new Product(row.id, row.name, row.price, row.sku));
        return this.products;
    }

    // VIOLATION: Single Responsibility - Customer management
    async createCustomer(email: string, firstName: string, lastName: string, phone: string, address: string): Promise<number> {
        await this.ensureConnected();
        const res = await this.client.query(
            'INSERT INTO customers (email, first_name, last_name, phone, address) VALUES ($1, $2, $3, $4, $5) RETURNING id',
            [email, firstName, lastName, phone, address]
        );
        const customerId = res.rows[0].id;
        
        const customer = new Customer(customerId, email, firstName, lastName, phone, address);
        this.customers.push(customer);
        
        console.log(`Customer ${firstName} ${lastName} created successfully with ID ${customerId}`);
        return customerId;
    }

    async updateCustomer(customerId: number, email: string, firstName: string, lastName: string, phone: string, address: string): Promise<void> {
        await this.ensureConnected();
        await this.client.query(
            'UPDATE customers SET email = $1, first_name = $2, last_name = $3, phone = $4, address = $5 WHERE id = $6',
            [email, firstName, lastName, phone, address, customerId]
        );
        
        const customer = this.customers.find(c => c.id === customerId);
        if (customer) {
            customer.email = email;
            customer.firstName = firstName;
            customer.lastName = lastName;
            customer.phone = phone;
            customer.address = address;
        }
        
        console.log(`Customer ${customerId} updated successfully`);
    }

    async deleteCustomer(customerId: number): Promise<void> {
        await this.ensureConnected();
        await this.client.query('DELETE FROM customers WHERE id = $1', [customerId]);
        
        this.customers = this.customers.filter(c => c.id !== customerId);
        console.log(`Customer ${customerId} deleted successfully`);
    }

    async getCustomer(customerId: number): Promise<Customer | null> {
        await this.ensureConnected();
        const res = await this.client.query(
            'SELECT id, email, first_name, last_name, phone, address FROM customers WHERE id = $1',
            [customerId]
        );
        
        if (res.rows.length > 0) {
            const row = res.rows[0];
            return new Customer(
                row.id,
                row.email,
                row.first_name,
                row.last_name,
                row.phone,
                row.address
            );
        }
        return null;
    }

    // VIOLATION: Single Responsibility - Cart management
    async createCart(customerId: number): Promise<number> {
        // VIOLATION: Business logic mixed with data access
        const existingCart = await this.getCartByCustomerId(customerId);
        if (existingCart) {
            console.log(`Customer ${customerId} already has a cart with ID ${existingCart.id}`);
            return existingCart.id;
        }

        await this.ensureConnected();
        const res = await this.client.query(
            'INSERT INTO carts (customer_id) VALUES ($1) RETURNING id',
            [customerId]
        );
        const cartId = res.rows[0].id;
        
        const cart = new Cart(cartId, customerId, []);
        this.carts.push(cart);
        
        console.log(`Cart created successfully with ID ${cartId} for customer ${customerId}`);
        return cartId;
    }

    async getCartByCustomerId(customerId: number): Promise<Cart | null> {
        await this.ensureConnected();
        const res = await this.client.query(
            'SELECT id, customer_id FROM carts WHERE customer_id = $1',
            [customerId]
        );
        
        if (res.rows.length > 0) {
            const cartId = res.rows[0].id;
            const cart = new Cart(cartId, customerId, []);
            
            // Load cart items
            const itemsRes = await this.client.query(
                'SELECT ci.id, ci.product_id, ci.quantity, ci.unit_price, ci.total_price, p.name ' +
                'FROM cart_items ci JOIN products p ON ci.product_id = p.id WHERE ci.cart_id = $1',
                [cartId]
            );
            
            cart.items = itemsRes.rows.map(row => new CartItem(
                row.id,
                row.product_id,
                row.quantity,
                row.unit_price,
                row.total_price,
                row.name
            ));
            
            return cart;
        }
        return null;
    }

    async addToCart(customerId: number, productId: number, quantity: number): Promise<void> {
        // VIOLATION: Business logic violation - cannot create cart unless customer exists
        const customer = await this.getCustomer(customerId);
        if (!customer) {
            console.log(`Cannot add to cart: Customer ${customerId} does not exist!`);
            return;
        }

        const cart = await this.getCartByCustomerId(customerId);
        if (!cart) {
            console.log(`Cannot add to cart: Customer ${customerId} does not have a cart!`);
            return;
        }

        // VIOLATION: Let database handle constraint validation instead of client-side validation
        await this.ensureConnected();
        
        // Get product price from database
        const productRes = await this.client.query('SELECT price FROM products WHERE id = $1', [productId]);
        if (productRes.rows.length === 0) {
            throw new Error(`Product ${productId} not found!`);
        }
        const productPrice = parseFloat(productRes.rows[0].price);
        
        // Check if item already exists in cart
        const existingItemRes = await this.client.query(
            'SELECT id, quantity FROM cart_items WHERE cart_id = $1 AND product_id = $2',
            [cart.id, productId]
        );

        if (existingItemRes.rows.length > 0) {
            // Update existing item
            const newQuantity = existingItemRes.rows[0].quantity + quantity;
            const totalPrice = newQuantity * productPrice;
            
            await this.client.query(
                'UPDATE cart_items SET quantity = $1, total_price = $2 WHERE cart_id = $3 AND product_id = $4',
                [newQuantity, totalPrice, cart.id, productId]
            );
        } else {
            // Add new item
            const totalPrice = quantity * productPrice;
            
            await this.client.query(
                'INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, total_price) VALUES ($1, $2, $3, $4, $5)',
                [cart.id, productId, quantity, productPrice, totalPrice]
            );
        }
        
        console.log(`Added ${quantity} x Product ${productId} to cart for customer ${customerId}`);
    }

    async calculateCartTotal(customerId: number): Promise<number> {
        const cart = await this.getCartByCustomerId(customerId);
        if (!cart) {
            return 0;
        }

        await this.ensureConnected();
        const res = await this.client.query(
            'SELECT SUM(total_price) as total FROM cart_items WHERE cart_id = $1',
            [cart.id]
        );
        
        return parseFloat(res.rows[0].total) || 0;
    }

    async displayCart(customerId: number): Promise<void> {
        const cart = await this.getCartByCustomerId(customerId);
        if (!cart) {
            console.log(`No cart found for customer ${customerId}`);
            return;
        }

        console.log(`\n=== Cart for Customer ${customerId} ===`);
        console.log(`Cart ID: ${cart.id}`);
        
        if (cart.items.length === 0) {
            console.log('Cart is empty');
            return;
        }

        let total = 0;
        cart.items.forEach(item => {
            console.log(`${item.productName} - Quantity: ${item.quantity}, Unit Price: $${item.unitPrice}, Total: $${item.totalPrice}`);
            total += item.totalPrice;
        });
        
        console.log(`\nTotal: $${total.toFixed(2)}`);
    }

    // VIOLATION: Single Responsibility - Order processing
    async processOrder(customerId: number): Promise<void> {
        const cart = await this.getCartByCustomerId(customerId);
        if (!cart || cart.items.length === 0) {
            console.log(`No items in cart for customer ${customerId}`);
            return;
        }

        const total = await this.calculateCartTotal(customerId);
        
        // VIOLATION: Hard-coded order processing logic
        const order = new Order();
        order.customerId = customerId;
        order.cartId = cart.id;
        order.orderNumber = `ORD-${Date.now()}`;
        order.totalAmount = total;
        order.status = 'Processing';
        order.orderDate = new Date();
        
        // VIOLATION: Direct database operations mixed with business logic
        await this.ensureConnected();
        
        // Create order record
        const orderRes = await this.client.query(
            'INSERT INTO orders (customer_id, cart_id, order_number, subtotal, total_amount, status, order_date) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id',
            [customerId, cart.id, order.orderNumber, total, total, order.status, order.orderDate]
        );
        order.id = orderRes.rows[0].id;
        
        // Create order items
        for (const item of cart.items) {
            await this.client.query(
                'INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES ($1, $2, $3, $4, $5)',
                [order.id, item.productId, item.quantity, item.unitPrice, item.totalPrice]
            );
        }
        
        // Generate invoice
        await this.generateInvoice(order.id);
        
        // Clear cart items but keep the cart (it's referenced by the order)
        await this.client.query('DELETE FROM cart_items WHERE cart_id = $1', [cart.id]);
        
        this.orders.push(order);
        
        console.log(`Order ${order.orderNumber} processed successfully for customer ${customerId}`);
    }

    // VIOLATION: Single Responsibility - Invoice generation
    async generateInvoice(orderId: number): Promise<void> {
        await this.ensureConnected();
        
        const orderRes = await this.client.query(
            'SELECT id, customer_id, total_amount FROM orders WHERE id = $1',
            [orderId]
        );
        
        if (orderRes.rows.length === 0) {
            console.log(`Order ${orderId} not found`);
            return;
        }
        
        const order = orderRes.rows[0];
        const taxRate = 0.08; // VIOLATION: Hard-coded tax rate
        const orderTotal = parseFloat(order.total_amount);
        const taxAmount = orderTotal * taxRate;
        const totalAmount = orderTotal + taxAmount;
        
        const invoice = new Invoice();
        invoice.orderId = orderId;
        invoice.invoiceNumber = `INV-${Date.now()}`;
        invoice.amount = orderTotal;
        invoice.taxAmount = taxAmount;
        invoice.totalAmount = totalAmount;
        invoice.invoiceDate = new Date();
        
        // VIOLATION: Direct database operations
        const invoiceRes = await this.client.query(
            'INSERT INTO invoices (order_id, invoice_number, amount, tax_amount, total_amount) VALUES ($1, $2, $3, $4, $5) RETURNING id',
            [orderId, invoice.invoiceNumber, invoice.amount, invoice.taxAmount, invoice.totalAmount]
        );
        invoice.id = invoiceRes.rows[0].id;
        
        this.invoices.push(invoice);
        
        console.log(`Invoice ${invoice.invoiceNumber} generated for order ${orderId}`);
        console.log(`Amount: $${invoice.amount.toFixed(2)}, Tax: $${invoice.taxAmount.toFixed(2)}, Total: $${invoice.totalAmount.toFixed(2)}`);
    }

    // VIOLATION: Single Responsibility - Email sending
    async sendOrderConfirmation(customerId: number, orderId: number): Promise<void> {
        const customer = await this.getCustomer(customerId);
        if (!customer) {
            console.log(`Customer ${customerId} not found`);
            return;
        }
        
        console.log(`Sending order confirmation email to ${customer.email} for order ${orderId}`);
        // VIOLATION: Hard-coded email logic
    }

    // VIOLATION: Single Responsibility - Logging
    async logActivity(activity: string): Promise<void> {
        console.log(`[${new Date().toISOString()}] ${activity}`);
        // VIOLATION: Hard-coded logging to console
    }

    // VIOLATION: Single Responsibility - Inventory management
    async updateProductStock(productId: number, newStock: number): Promise<void> {
        await this.ensureConnected();
        await this.client.query(
            'UPDATE products SET stock_quantity = $1 WHERE id = $2',
            [newStock, productId]
        );
        
        console.log(`Product ${productId} stock updated to ${newStock}`);
    }

    // Test cleanup method
    async cleanupTestData(): Promise<void> {
        await this.ensureConnected();
        
        // Delete in reverse order of dependencies
        await this.client.query('DELETE FROM invoices');
        await this.client.query('DELETE FROM order_items');
        await this.client.query('DELETE FROM orders');
        await this.client.query('DELETE FROM cart_items');
        await this.client.query('DELETE FROM carts');
        await this.client.query('DELETE FROM customers WHERE email LIKE \'%test%\' OR email LIKE \'%example.com\'');
        
        // Reset sequences
        await this.client.query('ALTER SEQUENCE customers_id_seq RESTART WITH 1');
        await this.client.query('ALTER SEQUENCE carts_id_seq RESTART WITH 1');
        await this.client.query('ALTER SEQUENCE cart_items_id_seq RESTART WITH 1');
        await this.client.query('ALTER SEQUENCE orders_id_seq RESTART WITH 1');
        await this.client.query('ALTER SEQUENCE order_items_id_seq RESTART WITH 1');
        await this.client.query('ALTER SEQUENCE invoices_id_seq RESTART WITH 1');
    }

    // VIOLATION: Single Responsibility - Reporting
    async generateSalesReport(): Promise<void> {
        await this.ensureConnected();
        
        const ordersRes = await this.client.query('SELECT COUNT(*) as count, SUM(total_amount) as total FROM orders');
        const orderCount = parseInt(ordersRes.rows[0].count) || 0;
        const totalSales = parseFloat(ordersRes.rows[0].total) || 0;
        const averageOrderValue = orderCount > 0 ? totalSales / orderCount : 0;
        
        console.log('\n=== SALES REPORT ===');
        console.log(`Total Orders: ${orderCount}`);
        console.log(`Total Sales: $${totalSales.toFixed(2)}`);
        console.log(`Average Order Value: $${averageOrderValue.toFixed(2)}`);
    }
}

// VIOLATION: Open/Closed Principle - Hard-coded classes that can't be extended
export class Product {
    constructor(
        public id: number,
        public name: string,
        public price: number,
        public sku: string
    ) {}
}

export class Customer {
    constructor(
        public id: number,
        public email: string,
        public firstName: string,
        public lastName: string,
        public phone: string,
        public address: string
    ) {}
}

export class Cart {
    constructor(
        public id: number,
        public customerId: number,
        public items: CartItem[]
    ) {}
}

export class CartItem {
    constructor(
        public id: number,
        public productId: number,
        public quantity: number,
        public unitPrice: number,
        public totalPrice: number,
        public productName: string
    ) {}
}

export class Order {
    public id: number = 0;
    public customerId: number = 0;
    public cartId: number = 0;
    public orderNumber: string = '';
    public items: Product[] = [];
    public totalAmount: number = 0;
    public status: string = '';
    public orderDate: Date = new Date();
}

export class Invoice {
    public id: number = 0;
    public orderId: number = 0;
    public invoiceNumber: string = '';
    public amount: number = 0;
    public taxAmount: number = 0;
    public totalAmount: number = 0;
    public invoiceDate: Date = new Date();
}

// Main function to demonstrate the e-commerce system
async function main() {
    const ecommerce = new EcommerceManager();
    
    console.log('=== E-commerce System (SOLID Violations Demo) ===');
    
    // Load products
    const products = await ecommerce.getProducts();
    console.log('Available Products:');
    products.forEach(product => {
        console.log(`${product.id}. ${product.name} - $${product.price}`);
    });
    
    // Create a customer
    const customerId = await ecommerce.createCustomer('john.doe@example.com', 'John', 'Doe', '555-0101', '123 Main St');
    
    // Create a cart for the customer
    const cartId = await ecommerce.createCart(customerId);
    
    // Add items to cart
    await ecommerce.addToCart(customerId, 1, 2); // Add 2 laptops
    await ecommerce.addToCart(customerId, 2, 1); // Add 1 mouse
    
    // Display cart
    await ecommerce.displayCart(customerId);
    
    // Process order
    await ecommerce.processOrder(customerId);
    
    // Generate sales report
    await ecommerce.generateSalesReport();
}

// Run the main function if this file is executed directly
if (require.main === module) {
    main().catch(console.error);
}