export declare class EcommerceManager {
    private client;
    private connected;
    private products;
    private customers;
    private carts;
    private orders;
    private invoices;
    constructor();
    private ensureConnected;
    getProducts(): Promise<Product[]>;
    createCustomer(email: string, firstName: string, lastName: string, phone: string, address: string): Promise<number>;
    updateCustomer(customerId: number, email: string, firstName: string, lastName: string, phone: string, address: string): Promise<void>;
    deleteCustomer(customerId: number): Promise<void>;
    getCustomer(customerId: number): Promise<Customer | null>;
    createCart(customerId: number): Promise<number>;
    getCartByCustomerId(customerId: number): Promise<Cart | null>;
    addToCart(customerId: number, productId: number, quantity: number): Promise<void>;
    calculateCartTotal(customerId: number): Promise<number>;
    displayCart(customerId: number): Promise<void>;
    processOrder(customerId: number): Promise<void>;
    generateInvoice(orderId: number): Promise<void>;
    sendOrderConfirmation(customerId: number, orderId: number): Promise<void>;
    logActivity(activity: string): Promise<void>;
    updateProductStock(productId: number, newStock: number): Promise<void>;
    cleanupTestData(): Promise<void>;
    generateSalesReport(): Promise<void>;
}
export declare class Product {
    id: number;
    name: string;
    price: number;
    sku: string;
    constructor(id: number, name: string, price: number, sku: string);
}
export declare class Customer {
    id: number;
    email: string;
    firstName: string;
    lastName: string;
    phone: string;
    address: string;
    constructor(id: number, email: string, firstName: string, lastName: string, phone: string, address: string);
}
export declare class Cart {
    id: number;
    customerId: number;
    items: CartItem[];
    constructor(id: number, customerId: number, items: CartItem[]);
}
export declare class CartItem {
    id: number;
    productId: number;
    quantity: number;
    unitPrice: number;
    totalPrice: number;
    productName: string;
    constructor(id: number, productId: number, quantity: number, unitPrice: number, totalPrice: number, productName: string);
}
export declare class Order {
    id: number;
    customerId: number;
    cartId: number;
    orderNumber: string;
    items: Product[];
    totalAmount: number;
    status: string;
    orderDate: Date;
}
export declare class Invoice {
    id: number;
    orderId: number;
    invoiceNumber: string;
    amount: number;
    taxAmount: number;
    totalAmount: number;
    invoiceDate: Date;
}
//# sourceMappingURL=app.d.ts.map