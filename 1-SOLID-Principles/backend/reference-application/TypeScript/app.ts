import { Client } from 'pg';

// VIOLATION: Single Responsibility Principle
// This class handles products, database operations, cart management, order processing, invoice generation, email sending, logging, customer management, inventory management, and reporting
class EcommerceManager {
    private client: Client;
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

    // VIOLATION: Single Responsibility - Product management
    async getProducts(): Promise<Product[]> {
        await this.client.connect();
        const res = await this.client.query('SELECT id, name, price, sku FROM products');
        this.products = res.rows.map(row => new Product(row.id, row.name, row.price, row.sku));
        await this.client.end();
        return this.products;
    }

    // VIOLATION: Single Responsibility - Customer management
    async createCustomer(email: string, firstName: string, lastName: string, phone: string, address: string): Promise<number> {
        await this.client.connect();
        const res = await this.client.query(
            'INSERT INTO customers (email, first_name, last_name, phone, address) VALUES ($1, $2, $3, $4, $5) RETURNING id',
            [email, firstName, lastName, phone, address]
        );
        const customerId = res.rows[0].id;
        
        const customer = new Customer(customerId, email, firstName, lastName, phone, address);
        this.customers.push(customer);
        
        console.log(`Customer ${firstName} ${lastName} created successfully with ID ${customerId}`);
        await this.client.end();
        return customerId;
    }

    async updateCustomer(customerId: number, email: string, firstName: string, lastName: string, phone: string, address: string): Promise<void> {
        await this.client.connect();
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
        await this.client.end();
    }

    async deleteCustomer(customerId: number): Promise<void> {
        await this.client.connect();
        await this.client.query('DELETE FROM customers WHERE id = $1', [customerId]);
        
        this.customers = this.customers.filter(c => c.id !== customerId);
        console.log(`Customer ${customerId} deleted successfully`);
        await this.client.end();
    }

    async getCustomer(customerId: number): Promise<Customer | null> {
        await this.client.connect();
        const res = await this.client.query(
            'SELECT id, email, first_name, last_name, phone, address FROM customers WHERE id = $1',
            [customerId]
        );
        
        if (res.rows.length > 0) {
            const row = res.rows[0];
            const customer = new Customer(
                row.id,
                row.email,
                row.first_name,
                row.last_name,
                row.phone,
                row.address
            );
            await this.client.end();
            return customer;
        }
        await this.client.end();
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

        await this.client.connect();
        const res = await this.client.query(
            'INSERT INTO carts (customer_id) VALUES ($1) RETURNING id',
            [customerId]
        );
        const cartId = res.rows[0].id;
        
        const cart = new Cart(cartId, customerId, []);
        this.carts.push(cart);
        
        console.log(`Cart created successfully with ID ${cartId} for customer ${customerId}`);
        await this.client.end();
        return cartId;
    }

    async getCartByCustomerId(customerId: number): Promise<Cart | null> {
        await this.client.connect();
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
            
            await this.client.end();
            return cart;
        }
        await this.client.end();
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

        const product = this.products.find(p => p.id === productId);
        if (!product) {
            console.log(`Product ${productId} not found!`);
            return;
        }

        await this.client.connect();
        
        // Check if item already exists in cart
        const checkRes = await this.client.query(
            'SELECT id, quantity FROM cart_items WHERE cart_id = $1 AND product_id = $2',
            [cart.id, productId]
        );
        
        if (checkRes.rows.length > 0) {
            // Update existing item
            const existingId = checkRes.rows[0].id;
            const existingQuantity = checkRes.rows[0].quantity;
            
            const newQuantity = existingQuantity + quantity;
            const newTotalPrice = newQuantity * product.price;
            
            await this.client.query(
                'UPDATE cart_items SET quantity = $1, total_price = $2 WHERE id = $3',
                [newQuantity, newTotalPrice, existingId]
            );
            
            console.log(`Updated ${product.name} quantity to ${newQuantity} in cart`);
        } else {
            // Add new item
            await this.client.query(
                'INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, total_price) VALUES ($1, $2, $3, $4, $5)',
                [cart.id, productId, quantity, product.price, product.price * quantity]
            );
            
            console.log(`Added ${quantity} ${product.name} to cart`);
        }
        
        await this.client.end();
    }

    async removeFromCart(customerId: number, productId: number): Promise<void> {
        const cart = await this.getCartByCustomerId(customerId);
        if (!cart) {
            console.log(`Customer ${customerId} does not have a cart!`);
            return;
        }

        await this.client.connect();
        await this.client.query(
            'DELETE FROM cart_items WHERE cart_id = $1 AND product_id = $2',
            [cart.id, productId]
        );
        
        console.log(`Removed product ${productId} from cart`);
        await this.client.end();
    }

    async calculateCartTotal(customerId: number): Promise<number> {
        const cart = await this.getCartByCustomerId(customerId);
        if (!cart) return 0;

        return cart.items.reduce((total, item) => total + item.totalPrice, 0);
    }

    async displayCart(customerId: number): Promise<void> {
        const cart = await this.getCartByCustomerId(customerId);
        if (!cart) {
            console.log(`Customer ${customerId} does not have a cart!`);
            return;
        }

        console.log(`=== Shopping Cart for Customer ${customerId} ===`);
        cart.items.forEach(item => {
            console.log(`${item.productName} x${item.quantity} - $${item.unitPrice} each = $${item.totalPrice}`);
        });
        console.log(`Total: $${await this.calculateCartTotal(customerId)}`);
    }

    // VIOLATION: Single Responsibility - Order processing
    async processOrder(customerId: number): Promise<void> {
        const cart = await this.getCartByCustomerId(customerId);
        if (!cart || cart.items.length === 0) {
            console.log('Cart is empty or does not exist!');
            return;
        }

        // Create order
        const order = new Order();
        order.id = this.orders.length + 1;
        order.customerId = customerId;
        order.cartId = cart.id;
        order.orderNumber = `ORD-${new Date().toISOString().slice(0, 10).replace(/-/g, '')}-${String(this.orders.length + 1).padStart(4, '0')}`;
        order.items = [];
        order.subtotal = await this.calculateCartTotal(customerId);
        order.taxAmount = order.subtotal * 0.08; // 8% tax
        order.shippingAmount = 9.99;
        order.totalAmount = order.subtotal + order.taxAmount + order.shippingAmount;
        order.status = 'Pending';
        order.orderDate = new Date();

        this.orders.push(order);

        // Save to database
        await this.client.connect();
        const res = await this.client.query(
            'INSERT INTO orders (customer_id, cart_id, order_number, status, subtotal, tax_amount, shipping_amount, total_amount) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id',
            [order.customerId, order.cartId, order.orderNumber, order.status, order.subtotal, order.taxAmount, order.shippingAmount, order.totalAmount]
        );
        order.id = res.rows[0].id;

        // Save order items
        for (const cartItem of cart.items) {
            await this.client.query(
                'INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES ($1, $2, $3, $4, $5)',
                [order.id, cartItem.productId, cartItem.quantity, cartItem.unitPrice, cartItem.totalPrice]
            );
        }

        // Generate invoice
        await this.generateInvoice(order);

        // Send confirmation email
        const customer = await this.getCustomer(customerId);
        this.sendConfirmationEmail(customer!.email, order);

        // Log the order
        this.logOrder(order);

        // Clear cart
        await this.client.query('DELETE FROM cart_items WHERE cart_id = $1', [cart.id]);

        console.log(`Order ${order.orderNumber} processed successfully!`);
        await this.client.end();
    }

    // VIOLATION: Single Responsibility - Invoice generation
    async generateInvoice(order: Order): Promise<void> {
        const invoice = new Invoice();
        invoice.id = this.invoices.length + 1;
        invoice.orderId = order.id;
        invoice.invoiceNumber = `INV-${new Date().toISOString().slice(0, 10).replace(/-/g, '')}-${String(this.invoices.length + 1).padStart(4, '0')}`;
        invoice.amount = order.totalAmount;
        invoice.taxAmount = order.taxAmount;
        invoice.totalAmount = order.totalAmount;
        invoice.status = 'Pending';
        invoice.dueDate = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 30 days from now
        invoice.createdDate = new Date();

        this.invoices.push(invoice);

        // Save to database
        await this.client.connect();
        await this.client.query(
            'INSERT INTO invoices (order_id, invoice_number, status, amount, tax_amount, total_amount, due_date) VALUES ($1, $2, $3, $4, $5, $6, $7)',
            [invoice.orderId, invoice.invoiceNumber, invoice.status, invoice.amount, invoice.taxAmount, invoice.totalAmount, invoice.dueDate]
        );
        await this.client.end();

        // Generate PDF invoice (simulated)
        this.generatePDFInvoice(invoice);

        console.log(`Invoice ${invoice.invoiceNumber} generated for order ${order.orderNumber}`);
    }

    // VIOLATION: Single Responsibility - PDF generation
    private generatePDFInvoice(invoice: Invoice): void {
        // Simulated PDF generation
        console.log(`=== INVOICE ${invoice.invoiceNumber} ===`);
        console.log(`Amount: $${invoice.amount}`);
        console.log(`Tax: $${invoice.taxAmount}`);
        console.log(`Total: $${invoice.totalAmount}`);
        console.log(`Due Date: ${invoice.dueDate.toISOString().slice(0, 10)}`);
        console.log('=== END INVOICE ===');
    }

    // VIOLATION: Single Responsibility - Email sending
    private sendConfirmationEmail(email: string, order: Order): void {
        // Simulated email sending
        console.log(`Sending confirmation email to ${email}`);
        console.log(`Subject: Order Confirmation - ${order.orderNumber}`);
        console.log(`Body: Your order has been processed. Total: $${order.totalAmount}`);
    }

    // VIOLATION: Single Responsibility - Logging
    private logOrder(order: Order): void {
        // Simulated logging
        console.log(`[LOG] Order processed: ${order.orderNumber}, Customer: ${order.customerId}, Total: $${order.totalAmount}`);
    }

    // VIOLATION: Single Responsibility - Inventory management
    async updateProductStock(productId: number, newStock: number): Promise<void> {
        await this.client.connect();
        await this.client.query(
            'UPDATE products SET stock_quantity = $1 WHERE id = $2',
            [newStock, productId]
        );
        await this.client.end();
        console.log(`Updated stock for product ${productId} to ${newStock}`);
    }

    // VIOLATION: Single Responsibility - Reporting
    generateSalesReport(): void {
        const totalSales = this.orders.reduce((total, order) => total + order.totalAmount, 0);
        console.log('=== SALES REPORT ===');
        console.log(`Total Orders: ${this.orders.length}`);
        console.log(`Total Sales: $${totalSales}`);
        console.log(`Average Order Value: $${this.orders.length > 0 ? totalSales / this.orders.length : 0}`);
    }

    // VIOLATION: Single Responsibility - Payment processing
    processPayment(order: Order, paymentMethod: string, amount: number): void {
        if (paymentMethod === 'credit_card') {
            console.log(`Processing credit card payment of $${amount} for order ${order.orderNumber}`);
        } else if (paymentMethod === 'paypal') {
            console.log(`Processing PayPal payment of $${amount} for order ${order.orderNumber}`);
        } else if (paymentMethod === 'bank_transfer') {
            console.log(`Processing bank transfer of $${amount} for order ${order.orderNumber}`);
        } else {
            console.log(`Unknown payment method: ${paymentMethod}`);
        }
    }

    // VIOLATION: Single Responsibility - Shipping management
    calculateShipping(order: Order): number {
        if (order.totalAmount > 100) {
            return 0.0; // Free shipping over $100
        } else if (order.totalAmount > 50) {
            return 5.99; // Reduced shipping
        } else {
            return 9.99; // Standard shipping
        }
    }

    // VIOLATION: Single Responsibility - Discount calculation
    applyDiscount(order: Order, discountCode: string): number {
        if (discountCode === 'SAVE10') {
            return order.subtotal * 0.10;
        } else if (discountCode === 'SAVE20') {
            return order.subtotal * 0.20;
        } else if (discountCode === 'FREESHIP') {
            return order.shippingAmount;
        } else {
            return 0.0;
        }
    }

    // VIOLATION: Single Responsibility - Notification management
    sendNotification(customerId: number, message: string, type: string): void {
        if (type === 'email') {
            console.log(`Sending email notification to customer ${customerId}: ${message}`);
        } else if (type === 'sms') {
            console.log(`Sending SMS notification to customer ${customerId}: ${message}`);
        } else if (type === 'push') {
            console.log(`Sending push notification to customer ${customerId}: ${message}`);
        } else {
            console.log(`Unknown notification type: ${type}`);
        }
    }

    // VIOLATION: Single Responsibility - Analytics
    generateAnalytics(): void {
        const totalRevenue = this.orders.reduce((total, order) => total + order.totalAmount, 0);
        const averageOrderValue = this.orders.length > 0 ? totalRevenue / this.orders.length : 0;
        const totalCustomers = new Set(this.orders.map(order => order.customerId)).size;
        
        console.log('=== ANALYTICS REPORT ===');
        console.log(`Total Revenue: $${totalRevenue}`);
        console.log(`Average Order Value: $${averageOrderValue}`);
        console.log(`Total Customers: ${totalCustomers}`);
        console.log(`Orders per Customer: ${this.orders.length > 0 ? this.orders.length / totalCustomers : 0}`);
    }
}

// VIOLATION: Open/Closed Principle - Hard-coded classes that can't be extended
class Product {
    constructor(
        public id: number,
        public name: string,
        public price: number,
        public sku: string
    ) {}
}

class Customer {
    constructor(
        public id: number,
        public email: string,
        public firstName: string,
        public lastName: string,
        public phone: string,
        public address: string
    ) {}
}

class Cart {
    constructor(
        public id: number,
        public customerId: number,
        public items: CartItem[]
    ) {}
}

class CartItem {
    constructor(
        public id: number,
        public productId: number,
        public quantity: number,
        public unitPrice: number,
        public totalPrice: number,
        public productName: string
    ) {}
}

class Order {
    public id: number = 0;
    public customerId: number = 0;
    public cartId: number = 0;
    public orderNumber: string = '';
    public items: Product[] = [];
    public subtotal: number = 0;
    public taxAmount: number = 0;
    public shippingAmount: number = 0;
    public totalAmount: number = 0;
    public status: string = '';
    public orderDate: Date = new Date();
}

class Invoice {
    public id: number = 0;
    public orderId: number = 0;
    public invoiceNumber: string = '';
    public amount: number = 0;
    public taxAmount: number = 0;
    public totalAmount: number = 0;
    public status: string = '';
    public dueDate: Date = new Date();
    public createdDate: Date = new Date();
}

// Main execution
(async () => {
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
    ecommerce.generateSalesReport();
    
    // Generate analytics
    ecommerce.generateAnalytics();
})();