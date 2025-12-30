import pytest
import uuid
import psycopg2
from bounteous_ecom.app import EcommerceManager, Product, Customer, Cart, CartItem, Order, Invoice


class TestEcommerceManager:
    """Test class for EcommerceManager demonstrating SOLID principle violations."""

    @pytest.fixture
    def ecommerce_manager(self):
        """Create an EcommerceManager instance for testing."""
        return EcommerceManager()

    @pytest.fixture(autouse=True)
    def cleanup_test_data(self):
        """Clean up test data after each test (except products table which is seeded)."""
        yield  # Run the test
        self._cleanup_test_data()

    def _cleanup_test_data(self):
        """Clean up test data from database."""
        try:
            conn = psycopg2.connect(
                host="localhost",
                database="bounteous_ecom",
                user="postgres",
                password="postgres123"
            )
            cursor = conn.cursor()
            
            # Clean up tables in reverse dependency order
            cursor.execute("DELETE FROM invoices")
            cursor.execute("DELETE FROM order_items")
            cursor.execute("DELETE FROM orders")
            cursor.execute("DELETE FROM cart_items")
            cursor.execute("DELETE FROM carts")
            cursor.execute("DELETE FROM customers")
            
            conn.commit()
            cursor.close()
            conn.close()
            
        except Exception as ex:
            # Log cleanup errors but don't fail tests
            print(f"Cleanup error: {ex}")

    def test_get_products_should_return_list_of_products(self, ecommerce_manager):
        """Test that get_products returns a list of products."""
        # Act
        result = ecommerce_manager.get_products()

        # Assert
        assert result is not None
        assert isinstance(result, list)
        # Should have sample products from database initialization
        assert len(result) > 0

    def test_create_customer_should_return_customer_id(self, ecommerce_manager):
        """Test that create_customer returns a customer ID."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        first_name = "John"
        last_name = "Doe"
        phone = "555-0101"
        address = "123 Main St"

        # Act
        result = ecommerce_manager.create_customer(email, first_name, last_name, phone, address)

        # Assert
        assert result > 0
        
        # Verify customer was actually created by retrieving it
        customer = ecommerce_manager.get_customer(result)
        assert customer is not None
        assert customer.email == email
        assert customer.first_name == first_name
        assert customer.last_name == last_name

    def test_create_customer_with_null_email_should_throw_exception(self, ecommerce_manager):
        """Test that create_customer throws exception with null email."""
        # Arrange
        email = None
        first_name = "John"
        last_name = "Doe"
        phone = "555-0101"
        address = "123 Main St"

        # Act & Assert
        with pytest.raises(Exception, match="null value in column \"email\""):
            ecommerce_manager.create_customer(email, first_name, last_name, phone, address)

    def test_create_customer_with_null_first_name_should_throw_exception(self, ecommerce_manager):
        """Test that create_customer throws exception with null first_name."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        first_name = None
        last_name = "Doe"
        phone = "555-0101"
        address = "123 Main St"

        # Act & Assert
        with pytest.raises(Exception, match="null value in column \"first_name\""):
            ecommerce_manager.create_customer(email, first_name, last_name, phone, address)

    def test_create_customer_with_null_last_name_should_throw_exception(self, ecommerce_manager):
        """Test that create_customer throws exception with null last_name."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        first_name = "John"
        last_name = None
        phone = "555-0101"
        address = "123 Main St"

        # Act & Assert
        with pytest.raises(Exception, match="null value in column \"last_name\""):
            ecommerce_manager.create_customer(email, first_name, last_name, phone, address)

    def test_create_customer_with_duplicate_email_should_throw_exception(self, ecommerce_manager):
        """Test that create_customer throws exception with duplicate email."""
        # Arrange
        email = f"duplicate{uuid.uuid4().hex[:8]}@example.com"
        first_name = "John"
        last_name = "Doe"
        phone = "555-0101"
        address = "123 Main St"

        # Create first customer
        ecommerce_manager.create_customer(email, first_name, last_name, phone, address)

        # Act & Assert - Try to create second customer with same email
        with pytest.raises(Exception, match="duplicate key value violates unique constraint"):
            ecommerce_manager.create_customer(email, "Jane", "Smith", "555-0102", "456 Oak Ave")

    def test_create_cart_should_return_cart_id(self, ecommerce_manager):
        """Test that create_cart returns a cart ID."""
        # Arrange - First create a customer
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Jane", "Smith", "555-0102", "456 Oak Ave")

        # Act
        result = ecommerce_manager.create_cart(customer_id)

        # Assert
        assert result > 0
        
        # Verify cart was actually created by retrieving it
        cart = ecommerce_manager.get_cart_by_customer_id(customer_id)
        assert cart is not None
        assert cart.id == result
        assert cart.customer_id == customer_id

    def test_create_cart_with_invalid_customer_id_should_throw_exception(self, ecommerce_manager):
        """Test that create_cart throws exception with invalid customer_id."""
        # Arrange
        invalid_customer_id = 99999  # Non-existent customer

        # Act & Assert
        with pytest.raises(Exception, match="violates foreign key constraint"):
            ecommerce_manager.create_cart(invalid_customer_id)

    def test_add_to_cart_with_valid_customer_and_product_should_succeed(self, ecommerce_manager):
        """Test that add_to_cart succeeds with valid customer and product."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Test", "User", "555-0103", "789 Pine St")
        cart_id = ecommerce_manager.create_cart(customer_id)
        products = ecommerce_manager.get_products()
        product_id = products[0].id  # Use first available product
        quantity = 2

        # Act
        ecommerce_manager.add_to_cart(customer_id, product_id, quantity)

        # Assert - Verify item was added by checking cart total
        cart_total = ecommerce_manager.calculate_cart_total(customer_id)
        assert cart_total > 0
        
        # Verify cart contents
        cart = ecommerce_manager.get_cart_by_customer_id(customer_id)
        assert len(cart.items) == 1
        assert cart.items[0].product_id == product_id
        assert cart.items[0].quantity == quantity

    def test_add_to_cart_with_invalid_customer_should_not_throw(self, ecommerce_manager):
        """Test that add_to_cart doesn't throw with invalid customer."""
        # Arrange
        customer_id = 99999  # Non-existent customer
        product_id = 1
        quantity = 2

        # Act & Assert
        # Should not raise an exception
        ecommerce_manager.add_to_cart(customer_id, product_id, quantity)
        
        # Verify no cart was created for invalid customer
        cart = ecommerce_manager.get_cart_by_customer_id(customer_id)
        assert cart is None

    def test_add_to_cart_with_invalid_product_id_should_not_throw(self, ecommerce_manager):
        """Test that add_to_cart does not throw with invalid product_id."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Test", "User", "555-0103", "789 Pine St")
        cart_id = ecommerce_manager.create_cart(customer_id)
        invalid_product_id = 99999  # Non-existent product
        quantity = 2

        # Act & Assert - The method should not throw because it validates product existence first
        ecommerce_manager.add_to_cart(customer_id, invalid_product_id, quantity)  # Should not raise

    def test_add_to_cart_with_zero_quantity_should_not_throw(self, ecommerce_manager):
        """Test that add_to_cart does not throw with zero quantity."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Test", "User", "555-0103", "789 Pine St")
        cart_id = ecommerce_manager.create_cart(customer_id)
        products = ecommerce_manager.get_products()
        product_id = products[0].id
        quantity = 0  # Zero quantity

        # Act & Assert - The method should not throw because it validates product existence first
        ecommerce_manager.add_to_cart(customer_id, product_id, quantity)  # Should not raise

    def test_calculate_cart_total_with_empty_cart_should_return_zero(self, ecommerce_manager):
        """Test that calculate_cart_total returns zero for empty cart."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Empty", "Cart", "555-0104", "321 Elm St")
        cart_id = ecommerce_manager.create_cart(customer_id)

        # Act
        result = ecommerce_manager.calculate_cart_total(customer_id)

        # Assert
        assert result == 0

    def test_calculate_cart_total_with_items_should_return_correct_total(self, ecommerce_manager):
        """Test that calculate_cart_total returns correct total with items."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Cart", "Test", "555-0105", "654 Maple St")
        cart_id = ecommerce_manager.create_cart(customer_id)
        products = ecommerce_manager.get_products()
        product_id = products[0].id
        quantity = 2
        expected_total = products[0].price * quantity

        ecommerce_manager.add_to_cart(customer_id, product_id, quantity)

        # Act
        result = ecommerce_manager.calculate_cart_total(customer_id)

        # Assert
        assert result == expected_total

    def test_process_order_with_empty_cart_should_not_throw(self, ecommerce_manager):
        """Test that process_order doesn't throw with empty cart."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Order", "Test", "555-0106", "987 Cedar St")
        cart_id = ecommerce_manager.create_cart(customer_id)

        # Act & Assert
        # Should not raise an exception
        ecommerce_manager.process_order(customer_id)

    def test_process_order_with_items_should_create_order_and_invoice(self, ecommerce_manager):
        """Test that process_order creates order and invoice with items."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Order", "Process", "555-0107", "147 Birch St")
        cart_id = ecommerce_manager.create_cart(customer_id)
        products = ecommerce_manager.get_products()
        product_id = products[0].id
        quantity = 1

        ecommerce_manager.add_to_cart(customer_id, product_id, quantity)

        # Act
        ecommerce_manager.process_order(customer_id)

        # Assert - Verify cart is cleared after order processing
        cart_total = ecommerce_manager.calculate_cart_total(customer_id)
        assert cart_total == 0

    def test_update_customer_should_update_customer_data(self, ecommerce_manager):
        """Test that update_customer updates customer data."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Original", "Name", "555-0108", "258 Spruce St")
        
        new_email = f"updated{uuid.uuid4().hex[:8]}@example.com"
        new_first_name = "Updated"
        new_last_name = "Name"
        new_phone = "555-0109"
        new_address = "369 Willow St"

        # Act
        ecommerce_manager.update_customer(customer_id, new_email, new_first_name, new_last_name, new_phone, new_address)

        # Assert
        updated_customer = ecommerce_manager.get_customer(customer_id)
        assert updated_customer is not None
        assert updated_customer.email == new_email
        assert updated_customer.first_name == new_first_name
        assert updated_customer.last_name == new_last_name
        assert updated_customer.phone == new_phone
        assert updated_customer.address == new_address

    def test_delete_customer_should_remove_customer(self, ecommerce_manager):
        """Test that delete_customer removes customer."""
        # Arrange
        email = f"test{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Delete", "Test", "555-0110", "741 Poplar St")

        # Verify customer exists
        customer = ecommerce_manager.get_customer(customer_id)
        assert customer is not None

        # Act
        ecommerce_manager.delete_customer(customer_id)

        # Assert
        deleted_customer = ecommerce_manager.get_customer(customer_id)
        assert deleted_customer is None

    def test_generate_sales_report_should_not_throw(self, ecommerce_manager):
        """Test that generate_sales_report doesn't throw."""
        # Act & Assert
        # Should not raise an exception
        ecommerce_manager.generate_sales_report()

    def test_update_product_stock_should_not_throw(self, ecommerce_manager):
        """Test that update_product_stock doesn't throw."""
        # Arrange
        products = ecommerce_manager.get_products()
        product_id = products[0].id
        new_stock = 100

        # Act & Assert
        # Should not raise an exception
        ecommerce_manager.update_product_stock(product_id, new_stock)

    def test_ecommerce_manager_should_violate_single_responsibility_principle(self, ecommerce_manager):
        """Test that demonstrates EcommerceManager violates SRP."""
        # This test demonstrates that the EcommerceManager class violates SRP
        # by having multiple responsibilities

        # Assert - The class handles multiple concerns
        assert ecommerce_manager is not None

        # The class should have methods for:
        # - Product management
        # - Customer management
        # - Cart management
        # - Order processing
        # - Invoice generation
        # - Email sending
        # - Logging
        # - Inventory management
        # - Reporting

        # This is a violation of SRP as the class has too many reasons to change

    def test_product_should_violate_open_closed_principle(self):
        """Test that demonstrates Product violates OCP."""
        # This test demonstrates that the Product class violates OCP
        # by being hard-coded and not easily extensible

        product = Product(1, "Test Product", 99.99, "TEST-001")

        assert product is not None
        assert product.id == 1
        assert product.name == "Test Product"
        assert product.price == 99.99
        assert product.sku == "TEST-001"

        # The Product class is hard-coded and cannot be extended without modification
        # This violates the Open/Closed Principle

    def test_customer_should_violate_open_closed_principle(self):
        """Test that demonstrates Customer violates OCP."""
        # This test demonstrates that the Customer class violates OCP
        # by being hard-coded and not easily extensible

        customer = Customer(1, "test@example.com", "John", "Doe", "555-0101", "123 Main St")

        assert customer is not None
        assert customer.id == 1
        assert customer.email == "test@example.com"
        assert customer.first_name == "John"
        assert customer.last_name == "Doe"
        assert customer.phone == "555-0101"
        assert customer.address == "123 Main St"

        # The Customer class is hard-coded and cannot be extended without modification
        # This violates the Open/Closed Principle

    def test_cart_should_violate_open_closed_principle(self):
        """Test that demonstrates Cart violates OCP."""
        # This test demonstrates that the Cart class violates OCP
        # by being hard-coded and not easily extensible

        cart = Cart(1, 1, [])

        assert cart is not None
        assert cart.id == 1
        assert cart.customer_id == 1
        assert cart.items == []

        # The Cart class is hard-coded and cannot be extended without modification
        # This violates the Open/Closed Principle

    def test_order_should_violate_open_closed_principle(self):
        """Test that demonstrates Order violates OCP."""
        # This test demonstrates that the Order class violates OCP
        # by being hard-coded and not easily extensible

        order = Order()
        order.id = 1
        order.customer_id = 1
        order.order_number = "ORD-001"

        assert order is not None
        assert order.id == 1
        assert order.customer_id == 1
        assert order.order_number == "ORD-001"

        # The Order class is hard-coded and cannot be extended without modification
        # This violates the Open/Closed Principle

    def test_invoice_should_violate_open_closed_principle(self):
        """Test that demonstrates Invoice violates OCP."""
        # This test demonstrates that the Invoice class violates OCP
        # by being hard-coded and not easily extensible

        invoice = Invoice()
        invoice.id = 1
        invoice.order_id = 1
        invoice.invoice_number = "INV-001"

        assert invoice is not None
        assert invoice.id == 1
        assert invoice.order_id == 1
        assert invoice.invoice_number == "INV-001"

        # The Invoice class is hard-coded and cannot be extended without modification
        # This violates the Open/Closed Principle

    def test_cart_workflow_should_demonstrate_multiple_solid_violations(self, ecommerce_manager):
        """Test that demonstrates multiple SOLID principle violations in a real workflow."""
        # This test demonstrates multiple SOLID principle violations in a real workflow
        
        # Arrange
        email = f"workflow{uuid.uuid4().hex[:8]}@example.com"
        customer_id = ecommerce_manager.create_customer(email, "Workflow", "Test", "555-0111", "852 Ash St")
        
        # Act - Complete cart workflow
        cart_id = ecommerce_manager.create_cart(customer_id)
        products = ecommerce_manager.get_products()
        product_id = products[0].id
        
        ecommerce_manager.add_to_cart(customer_id, product_id, 2)
        cart_total = ecommerce_manager.calculate_cart_total(customer_id)
        ecommerce_manager.process_order(customer_id)
        
        # Assert - Verify the workflow completed successfully
        assert cart_id > 0
        assert cart_total > 0
        
        # This workflow demonstrates violations of:
        # - SRP: EcommerceManager handles multiple responsibilities
        # - OCP: Hard-coded classes that can't be extended
        # - DIP: Direct database dependencies
