import psycopg2
from datetime import datetime, timedelta
from typing import List, Optional

# VIOLATION: Single Responsibility Principle
# This class handles products, database operations, cart management, order processing, invoice generation, email sending, logging, customer management, inventory management, and reporting
class EcommerceManager:
    def __init__(self):
        self.connection_string = "host='localhost' dbname='bounteous_ecom' user='postgres' password='postgres123'"
        self.products = []
        self.customers = []
        self.carts = []
        self.orders = []
        self.invoices = []

    # VIOLATION: Single Responsibility - Product management
    def get_products(self) -> List['Product']:
        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute("SELECT id, name, price, sku FROM products")
        self.products.clear()
        for row in cur.fetchall():
            self.products.append(Product(row[0], row[1], row[2], row[3]))
        conn.close()
        return self.products

    # VIOLATION: Single Responsibility - Customer management
    def create_customer(self, email: str, first_name: str, last_name: str, phone: str, address: str) -> int:
        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO customers (email, first_name, last_name, phone, address) VALUES (%s, %s, %s, %s, %s) RETURNING id",
            (email, first_name, last_name, phone, address)
        )
        customer_id = cur.fetchone()[0]
        
        customer = Customer(customer_id, email, first_name, last_name, phone, address)
        self.customers.append(customer)
        
        print(f"Customer {first_name} {last_name} created successfully with ID {customer_id}")
        conn.commit()
        conn.close()
        return customer_id

    def update_customer(self, customer_id: int, email: str, first_name: str, last_name: str, phone: str, address: str):
        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute(
            "UPDATE customers SET email = %s, first_name = %s, last_name = %s, phone = %s, address = %s WHERE id = %s",
            (email, first_name, last_name, phone, address, customer_id)
        )
        
        customer = next((c for c in self.customers if c.id == customer_id), None)
        if customer:
            customer.email = email
            customer.first_name = first_name
            customer.last_name = last_name
            customer.phone = phone
            customer.address = address
        
        print(f"Customer {customer_id} updated successfully")
        conn.commit()
        conn.close()

    def delete_customer(self, customer_id: int):
        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute("DELETE FROM customers WHERE id = %s", (customer_id,))
        
        self.customers = [c for c in self.customers if c.id != customer_id]
        print(f"Customer {customer_id} deleted successfully")
        conn.commit()
        conn.close()

    def get_customer(self, customer_id: int) -> Optional['Customer']:
        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute(
            "SELECT id, email, first_name, last_name, phone, address FROM customers WHERE id = %s",
            (customer_id,)
        )
        row = cur.fetchone()
        
        if row:
            customer = Customer(row[0], row[1], row[2], row[3], row[4], row[5])
            conn.close()
            return customer
        conn.close()
        return None

    # VIOLATION: Single Responsibility - Cart management
    def create_cart(self, customer_id: int) -> int:
        # VIOLATION: Business logic mixed with data access
        existing_cart = self.get_cart_by_customer_id(customer_id)
        if existing_cart:
            print(f"Customer {customer_id} already has a cart with ID {existing_cart.id}")
            return existing_cart.id

        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO carts (customer_id) VALUES (%s) RETURNING id",
            (customer_id,)
        )
        cart_id = cur.fetchone()[0]
        
        cart = Cart(cart_id, customer_id, [])
        self.carts.append(cart)
        
        print(f"Cart created successfully with ID {cart_id} for customer {customer_id}")
        conn.commit()
        conn.close()
        return cart_id

    def get_cart_by_customer_id(self, customer_id: int) -> Optional['Cart']:
        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute(
            "SELECT id, customer_id FROM carts WHERE customer_id = %s",
            (customer_id,)
        )
        row = cur.fetchone()
        
        if row:
            cart_id = row[0]
            cart = Cart(cart_id, customer_id, [])
            
            # Load cart items
            cur.execute(
                "SELECT ci.id, ci.product_id, ci.quantity, ci.unit_price, ci.total_price, p.name "
                "FROM cart_items ci JOIN products p ON ci.product_id = p.id WHERE ci.cart_id = %s",
                (cart_id,)
            )
            
            for item_row in cur.fetchall():
                cart.items.append(CartItem(
                    item_row[0], item_row[1], item_row[2], item_row[3], item_row[4], item_row[5]
                ))
            
            conn.close()
            return cart
        conn.close()
        return None

    def add_to_cart(self, customer_id: int, product_id: int, quantity: int):
        # VIOLATION: Business logic violation - cannot create cart unless customer exists
        customer = self.get_customer(customer_id)
        if not customer:
            print(f"Cannot add to cart: Customer {customer_id} does not exist!")
            return

        cart = self.get_cart_by_customer_id(customer_id)
        if not cart:
            print(f"Cannot add to cart: Customer {customer_id} does not have a cart!")
            return

        product = next((p for p in self.products if p.id == product_id), None)
        if not product:
            print(f"Product {product_id} not found!")
            return

        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        
        # Check if item already exists in cart
        cur.execute(
            "SELECT id, quantity FROM cart_items WHERE cart_id = %s AND product_id = %s",
            (cart.id, product_id)
        )
        existing_item = cur.fetchone()
        
        if existing_item:
            # Update existing item
            existing_id, existing_quantity = existing_item
            new_quantity = existing_quantity + quantity
            new_total_price = new_quantity * product.price
            
            cur.execute(
                "UPDATE cart_items SET quantity = %s, total_price = %s WHERE id = %s",
                (new_quantity, new_total_price, existing_id)
            )
            
            print(f"Updated {product.name} quantity to {new_quantity} in cart")
        else:
            # Add new item
            cur.execute(
                "INSERT INTO cart_items (cart_id, product_id, quantity, unit_price, total_price) VALUES (%s, %s, %s, %s, %s)",
                (cart.id, product_id, quantity, product.price, product.price * quantity)
            )
            
            print(f"Added {quantity} {product.name} to cart")
        
        conn.commit()
        conn.close()

    def remove_from_cart(self, customer_id: int, product_id: int):
        cart = self.get_cart_by_customer_id(customer_id)
        if not cart:
            print(f"Customer {customer_id} does not have a cart!")
            return

        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute(
            "DELETE FROM cart_items WHERE cart_id = %s AND product_id = %s",
            (cart.id, product_id)
        )
        
        print(f"Removed product {product_id} from cart")
        conn.commit()
        conn.close()

    def calculate_cart_total(self, customer_id: int) -> float:
        cart = self.get_cart_by_customer_id(customer_id)
        if not cart:
            return 0

        return sum(item.total_price for item in cart.items)

    def display_cart(self, customer_id: int):
        cart = self.get_cart_by_customer_id(customer_id)
        if not cart:
            print(f"Customer {customer_id} does not have a cart!")
            return

        print(f"=== Shopping Cart for Customer {customer_id} ===")
        for item in cart.items:
            print(f"{item.product_name} x{item.quantity} - ${item.unit_price} each = ${item.total_price}")
        print(f"Total: ${self.calculate_cart_total(customer_id)}")

    # VIOLATION: Single Responsibility - Order processing
    def process_order(self, customer_id: int):
        cart = self.get_cart_by_customer_id(customer_id)
        if not cart or not cart.items:
            print("Cart is empty or does not exist!")
            return

        # Create order
        order = Order()
        order.id = len(self.orders) + 1
        order.customer_id = customer_id
        order.cart_id = cart.id
        order.order_number = f"ORD-{datetime.now().strftime('%Y%m%d')}-{len(self.orders) + 1:04d}"
        order.items = []
        order.subtotal = self.calculate_cart_total(customer_id)
        order.tax_amount = self.calculate_cart_total(customer_id) * 0.08  # 8% tax
        order.shipping_amount = 9.99
        order.total_amount = self.calculate_cart_total(customer_id) + (self.calculate_cart_total(customer_id) * 0.08) + 9.99
        order.status = "Pending"
        order.order_date = datetime.now()

        self.orders.append(order)

        # Save to database
        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO orders (customer_id, cart_id, order_number, status, subtotal, tax_amount, shipping_amount, total_amount) VALUES (%s, %s, %s, %s, %s, %s, %s, %s) RETURNING id",
            (order.customer_id, order.cart_id, order.order_number, order.status, order.subtotal, order.tax_amount, order.shipping_amount, order.total_amount)
        )
        order.id = cur.fetchone()[0]

        # Save order items
        for cart_item in cart.items:
            cur.execute(
                "INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES (%s, %s, %s, %s, %s)",
                (order.id, cart_item.product_id, cart_item.quantity, cart_item.unit_price, cart_item.total_price)
            )

        conn.commit()

        # Generate invoice
        self.generate_invoice(order)

        # Send confirmation email
        customer = self.get_customer(customer_id)
        self.send_confirmation_email(customer.email, order)

        # Log the order
        self.log_order(order)

        # Clear cart
        cur.execute("DELETE FROM cart_items WHERE cart_id = %s", (cart.id,))
        conn.commit()
        conn.close()

        print(f"Order {order.order_number} processed successfully!")

    # VIOLATION: Single Responsibility - Invoice generation
    def generate_invoice(self, order: 'Order'):
        invoice = Invoice()
        invoice.id = len(self.invoices) + 1
        invoice.order_id = order.id
        invoice.invoice_number = f"INV-{datetime.now().strftime('%Y%m%d')}-{len(self.invoices) + 1:04d}"
        invoice.amount = order.total_amount
        invoice.tax_amount = order.tax_amount
        invoice.total_amount = order.total_amount
        invoice.status = "Pending"
        invoice.due_date = datetime.now() + timedelta(days=30)
        invoice.created_date = datetime.now()

        self.invoices.append(invoice)

        # Save to database
        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute(
            "INSERT INTO invoices (order_id, invoice_number, status, amount, tax_amount, total_amount, due_date) VALUES (%s, %s, %s, %s, %s, %s, %s)",
            (invoice.order_id, invoice.invoice_number, invoice.status, invoice.amount, invoice.tax_amount, invoice.total_amount, invoice.due_date.date())
        )
        conn.commit()
        conn.close()

        # Generate PDF invoice (simulated)
        self.generate_pdf_invoice(invoice)

        print(f"Invoice {invoice.invoice_number} generated for order {order.order_number}")

    # VIOLATION: Single Responsibility - PDF generation
    def generate_pdf_invoice(self, invoice: 'Invoice'):
        # Simulated PDF generation
        print(f"=== INVOICE {invoice.invoice_number} ===")
        print(f"Amount: ${invoice.amount}")
        print(f"Tax: ${invoice.tax_amount}")
        print(f"Total: ${invoice.total_amount}")
        print(f"Due Date: {invoice.due_date.strftime('%Y-%m-%d')}")
        print("=== END INVOICE ===")

    # VIOLATION: Single Responsibility - Email sending
    def send_confirmation_email(self, email: str, order: 'Order'):
        # Simulated email sending
        print(f"Sending confirmation email to {email}")
        print(f"Subject: Order Confirmation - {order.order_number}")
        print(f"Body: Your order has been processed. Total: ${order.total_amount}")

    # VIOLATION: Single Responsibility - Logging
    def log_order(self, order: 'Order'):
        # Simulated logging
        print(f"[LOG] Order processed: {order.order_number}, Customer: {order.customer_id}, Total: ${order.total_amount}")

    # VIOLATION: Single Responsibility - Inventory management
    def update_product_stock(self, product_id: int, new_stock: int):
        conn = psycopg2.connect(self.connection_string)
        cur = conn.cursor()
        cur.execute(
            "UPDATE products SET stock_quantity = %s WHERE id = %s",
            (new_stock, product_id)
        )
        conn.commit()
        conn.close()
        print(f"Updated stock for product {product_id} to {new_stock}")

    # VIOLATION: Single Responsibility - Reporting
    def generate_sales_report(self):
        total_sales = sum(order.total_amount for order in self.orders)
        print("=== SALES REPORT ===")
        print(f"Total Orders: {len(self.orders)}")
        print(f"Total Sales: ${total_sales}")
        print(f"Average Order Value: ${total_sales / len(self.orders) if self.orders else 0}")

    # VIOLATION: Single Responsibility - Payment processing
    def process_payment(self, order: 'Order', payment_method: str, amount: float):
        if payment_method == "credit_card":
            print(f"Processing credit card payment of ${amount} for order {order.order_number}")
        elif payment_method == "paypal":
            print(f"Processing PayPal payment of ${amount} for order {order.order_number}")
        elif payment_method == "bank_transfer":
            print(f"Processing bank transfer of ${amount} for order {order.order_number}")
        else:
            print(f"Unknown payment method: {payment_method}")

    # VIOLATION: Single Responsibility - Shipping management
    def calculate_shipping(self, order: 'Order') -> float:
        if order.total_amount > 100:
            return 0.0  # Free shipping over $100
        elif order.total_amount > 50:
            return 5.99  # Reduced shipping
        else:
            return 9.99  # Standard shipping

    # VIOLATION: Single Responsibility - Discount calculation
    def apply_discount(self, order: 'Order', discount_code: str) -> float:
        if discount_code == "SAVE10":
            return order.subtotal * 0.10
        elif discount_code == "SAVE20":
            return order.subtotal * 0.20
        elif discount_code == "FREESHIP":
            return order.shipping_amount
        else:
            return 0.0


# VIOLATION: Open/Closed Principle - Hard-coded classes that can't be extended
class Product:
    def __init__(self, id: int, name: str, price: float, sku: str):
        self.id = id
        self.name = name
        self.price = price
        self.sku = sku


class Customer:
    def __init__(self, id: int, email: str, first_name: str, last_name: str, phone: str, address: str):
        self.id = id
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.phone = phone
        self.address = address


class Cart:
    def __init__(self, id: int, customer_id: int, items: List['CartItem']):
        self.id = id
        self.customer_id = customer_id
        self.items = items


class CartItem:
    def __init__(self, id: int, product_id: int, quantity: int, unit_price: float, total_price: float, product_name: str):
        self.id = id
        self.product_id = product_id
        self.quantity = quantity
        self.unit_price = unit_price
        self.total_price = total_price
        self.product_name = product_name


class Order:
    def __init__(self):
        self.id = 0
        self.customer_id = 0
        self.cart_id = 0
        self.order_number = ""
        self.items = []
        self.subtotal = 0.0
        self.tax_amount = 0.0
        self.shipping_amount = 0.0
        self.total_amount = 0.0
        self.status = ""
        self.order_date = None


class Invoice:
    def __init__(self):
        self.id = 0
        self.order_id = 0
        self.invoice_number = ""
        self.amount = 0.0
        self.tax_amount = 0.0
        self.total_amount = 0.0
        self.status = ""
        self.due_date = None
        self.created_date = None


if __name__ == "__main__":
    ecommerce = EcommerceManager()
    
    print("=== E-commerce System (SOLID Violations Demo) ===")
    
    # Load products
    products = ecommerce.get_products()
    print("Available Products:")
    for product in products:
        print(f"{product.id}. {product.name} - ${product.price}")
    
    # Create a customer
    customer_id = ecommerce.create_customer("john.doe@example.com", "John", "Doe", "555-0101", "123 Main St")
    
    # Create a cart for the customer
    cart_id = ecommerce.create_cart(customer_id)
    
    # Add items to cart
    ecommerce.add_to_cart(customer_id, 1, 2)  # Add 2 laptops
    ecommerce.add_to_cart(customer_id, 2, 1)  # Add 1 mouse
    
    # Display cart
    ecommerce.display_cart(customer_id)
    
    # Process order
    ecommerce.process_order(customer_id)
    
    # Generate sales report
    ecommerce.generate_sales_report()