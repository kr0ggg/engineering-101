# Testing Anti-Patterns - Python Example

**Section**: [Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid)

**Navigation**: [← Previous: Customer Service Tests](./10-customer-service-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Testing Anti-Patterns to Avoid
# File: 2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns.py

import pytest
from unittest.mock import Mock, patch, MagicMock
from datetime import datetime
import os
import tempfile

# Import the domain objects
from order_entity import Order, OrderId, CustomerId, ProductId, Money, OrderItem, OrderStatus
from customer_entity import Customer, CustomerId as CustomerIdType, EmailAddress, CustomerStatus
from pricing_service import PricingService

class TestTestingAntiPatterns:
    """Examples of testing anti-patterns to avoid"""
    
    # ❌ BAD: Testing Infrastructure Concerns
    def test_order_save_to_database(self):
        """❌ BAD: Testing infrastructure concerns instead of domain logic"""
        # This test is testing database operations, not domain logic
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        
        # ❌ Testing database connection and SQL operations
        with patch('database.connection') as mock_conn:
            mock_cursor = mock_conn.cursor.return_value
            order.save_to_database()
            
            # ❌ Verifying SQL queries instead of business behavior
            mock_cursor.execute.assert_called_with(
                "INSERT INTO orders (id, customer_id, status) VALUES (?, ?, ?)",
                (order.id.value, order.customer_id.value, "Draft")
            )
    
    def test_order_send_email_notification(self):
        """❌ BAD: Testing email infrastructure instead of domain logic"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        order.confirm()
        
        # ❌ Testing email sending infrastructure
        with patch('smtplib.SMTP') as mock_smtp:
            order.send_confirmation_email()
            
            # ❌ Verifying SMTP calls instead of business behavior
            mock_smtp.assert_called_with('smtp.gmail.com', 587)
            mock_smtp.return_value.starttls.assert_called_once()
            mock_smtp.return_value.login.assert_called_with('user', 'password')
    
    def test_order_log_to_file(self):
        """❌ BAD: Testing file system operations instead of domain logic"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        
        # ❌ Testing file system operations
        with tempfile.NamedTemporaryFile(mode='w', delete=False) as temp_file:
            temp_filename = temp_file.name
        
        try:
            order.log_to_file(temp_filename)
            
            # ❌ Verifying file contents instead of business behavior
            with open(temp_filename, 'r') as f:
                content = f.read()
                assert "Order created" in content
                assert order.id.value in content
        finally:
            os.unlink(temp_filename)
    
    # ❌ BAD: Testing Implementation Details
    def test_order_internal_state(self):
        """❌ BAD: Testing internal implementation details"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # ❌ Testing private/internal attributes
        assert hasattr(order, '_items')
        assert hasattr(order, '_status')
        assert order._status == OrderStatus.DRAFT
        
        # ❌ Testing internal method behavior
        order._find_item_index(ProductId("product-1")) == -1
    
    def test_order_private_methods(self):
        """❌ BAD: Testing private methods directly"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # ❌ Testing private methods directly
        result = order._find_item_index(ProductId("product-1"))
        assert result == -1
        
        # ❌ Testing internal calculations
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        result = order._find_item_index(ProductId("product-1"))
        assert result == 0
    
    def test_order_internal_data_structures(self):
        """❌ BAD: Testing internal data structures"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # ❌ Testing internal data structure types
        assert isinstance(order._items, list)
        assert len(order._items) == 0
        
        # ❌ Testing internal data structure modifications
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        assert len(order._items) == 1
        assert isinstance(order._items[0], OrderItem)
    
    # ❌ BAD: Over-Mocking
    def test_order_with_excessive_mocking(self):
        """❌ BAD: Over-mocking everything instead of testing real behavior"""
        # ❌ Mocking domain objects instead of testing real behavior
        mock_order = Mock(spec=Order)
        mock_order.id = Mock(spec=OrderId)
        mock_order.customer_id = Mock(spec=CustomerId)
        mock_order.status = OrderStatus.DRAFT
        mock_order.can_be_modified.return_value = True
        mock_order.add_item.return_value = None
        
        # ❌ Testing mocked behavior instead of real domain logic
        assert mock_order.can_be_modified() is True
        mock_order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        mock_order.add_item.assert_called_once()
    
    def test_pricing_service_with_over_mocking(self):
        """❌ BAD: Over-mocking domain service dependencies"""
        # ❌ Mocking all dependencies instead of testing real behavior
        mock_tax_calculator = Mock(spec=TaxCalculator)
        mock_shipping_calculator = Mock(spec=ShippingCalculator)
        mock_discount_repository = Mock(spec=DiscountRuleRepository)
        
        # ❌ Mocking all method calls
        mock_tax_calculator.calculate_tax.return_value = Money(8.00, "USD")
        mock_shipping_calculator.calculate_shipping.return_value = Money(5.99, "USD")
        mock_discount_repository.get_customer_discount_rate.return_value = 0.10
        
        # ❌ Testing mocked behavior instead of real business logic
        pricing_service = PricingService()
        pricing_service._tax_calculator = mock_tax_calculator
        pricing_service._shipping_calculator = mock_shipping_calculator
        pricing_service._discount_rules = mock_discount_repository
        
        # ❌ This test doesn't verify actual business logic
        result = pricing_service._apply_customer_discount(Money(100.00, "USD"), Mock())
        assert result.amount == 90.00
    
    def test_customer_service_with_over_mocking(self):
        """❌ BAD: Over-mocking customer service dependencies"""
        # ❌ Mocking all domain objects
        mock_customer = Mock(spec=Customer)
        mock_customer.id = Mock(spec=CustomerId)
        mock_customer.name = "John Doe"
        mock_customer.email = Mock(spec=EmailAddress)
        mock_customer.is_active.return_value = True
        
        mock_repository = Mock(spec=CustomerRepository)
        mock_repository.find_by_email.return_value = None
        mock_repository.save.return_value = None
        
        mock_email_service = Mock(spec=EmailService)
        mock_email_service.send_welcome_email.return_value = None
        
        # ❌ Testing mocked behavior instead of real domain logic
        customer_service = CustomerService(mock_repository, mock_email_service)
        customer = customer_service.register_customer("John Doe", "john.doe@example.com")
        
        # ❌ This test doesn't verify actual business logic
        assert customer is not None
        mock_repository.save.assert_called_once()
    
    # ❌ BAD: Testing Implementation Details
    def test_order_implementation_details(self):
        """❌ BAD: Testing implementation details instead of behavior"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # ❌ Testing specific implementation details
        assert order._items == []  # Testing internal list
        assert order._status == OrderStatus.DRAFT  # Testing internal state
        
        # ❌ Testing specific method implementations
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        assert len(order._items) == 1  # Testing internal list length
        assert order._items[0].product_id == ProductId("product-1")  # Testing internal structure
    
    def test_money_implementation_details(self):
        """❌ BAD: Testing implementation details of value objects"""
        money = Money(100.50, "USD")
        
        # ❌ Testing internal attributes instead of behavior
        assert money.amount == 100.50
        assert money.currency == "USD"
        
        # ❌ Testing specific implementation details
        result = money.add(Money(25.25, "USD"))
        assert result.amount == 125.75  # Testing specific calculation
    
    # ❌ BAD: Brittle Tests
    def test_order_string_representation_brittle(self):
        """❌ BAD: Brittle test that breaks when implementation changes"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        
        # ❌ Testing exact string format - brittle
        expected_str = f"Order(id={order.id.value}, customer_id={order.customer_id.value}, status=Draft, items=1, total=31.98)"
        assert str(order) == expected_str
    
    def test_order_repr_representation_brittle(self):
        """❌ BAD: Brittle test for repr representation"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # ❌ Testing exact repr format - brittle
        expected_repr = f"Order(id={order.id.value}, customer_id={order.customer_id.value}, status=Draft, items=0, total=0.00)"
        assert repr(order) == expected_repr
    
    # ❌ BAD: Testing Multiple Concerns
    def test_order_multiple_concerns(self):
        """❌ BAD: Testing multiple concerns in one test"""
        # ❌ Testing order creation, item addition, and confirmation in one test
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # Testing order creation
        assert order.status == OrderStatus.DRAFT
        assert order.item_count == 0
        
        # Testing item addition
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        assert order.item_count == 1
        assert order.total_amount.amount == 31.98
        
        # Testing order confirmation
        order.confirm()
        assert order.status == OrderStatus.CONFIRMED
        assert order.can_be_shipped() is True
        
        # ❌ This test is doing too much and is hard to maintain
    
    def test_customer_multiple_concerns(self):
        """❌ BAD: Testing multiple customer concerns in one test"""
        # ❌ Testing customer creation, activation, and email update in one test
        customer_id = CustomerId.generate()
        email = EmailAddress("john.doe@example.com")
        customer = Customer(customer_id, "John Doe", email)
        
        # Testing customer creation
        assert customer.status == CustomerStatus.PENDING
        assert customer.is_active() is False
        
        # Testing customer activation
        customer.activate()
        assert customer.status == CustomerStatus.ACTIVE
        assert customer.is_active() is True
        
        # Testing email update
        new_email = EmailAddress("john.doe.new@example.com")
        customer.update_email(new_email)
        assert customer.email == new_email
        
        # ❌ This test is doing too much and is hard to maintain
    
    # ❌ BAD: Testing Error Messages
    def test_order_error_messages(self):
        """❌ BAD: Testing exact error messages instead of behavior"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        order.confirm()
        
        # ❌ Testing exact error message text - brittle
        with pytest.raises(ValueError, match="Cannot modify confirmed order"):
            order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        
        # ❌ Testing specific error message format
        with pytest.raises(ValueError) as exc_info:
            order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        assert str(exc_info.value) == "Cannot modify confirmed order"
    
    def test_money_error_messages(self):
        """❌ BAD: Testing exact error messages for value objects"""
        # ❌ Testing exact error message text - brittle
        with pytest.raises(ValueError, match="Amount cannot be negative"):
            Money(-10.0, "USD")
        
        # ❌ Testing specific error message format
        with pytest.raises(ValueError) as exc_info:
            Money(-10.0, "USD")
        assert str(exc_info.value) == "Amount cannot be negative"
    
    # ❌ BAD: Testing Framework Details
    def test_order_with_framework_details(self):
        """❌ BAD: Testing framework details instead of domain logic"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # ❌ Testing framework-specific details
        assert hasattr(order, '__class__')
        assert order.__class__.__name__ == 'Order'
        assert hasattr(order, '__dict__')
        
        # ❌ Testing framework methods
        assert hasattr(order, '__str__')
        assert hasattr(order, '__repr__')
        assert hasattr(order, '__eq__')
    
    # ❌ BAD: Testing Performance Details
    def test_order_performance_details(self):
        """❌ BAD: Testing performance details instead of behavior"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # ❌ Testing performance characteristics
        import time
        
        start_time = time.time()
        for i in range(1000):
            order.add_item(ProductId(f"product-{i}"), 1, Money(10.00, "USD"))
        end_time = time.time()
        
        # ❌ Testing specific performance requirements
        assert (end_time - start_time) < 0.1  # Must complete in 100ms
    
    # ❌ BAD: Testing Random Behavior
    def test_order_random_behavior(self):
        """❌ BAD: Testing random behavior instead of deterministic behavior"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # ❌ Testing random behavior
        import random
        
        # ❌ Testing random order generation
        random_order_id = OrderId.generate()
        assert random_order_id.value != order.id.value  # This might fail randomly
        
        # ❌ Testing random customer ID generation
        random_customer_id = CustomerId.generate()
        assert random_customer_id.value != order.customer_id.value  # This might fail randomly

# ✅ GOOD: Proper Testing Examples
class TestProperTestingExamples:
    """Examples of proper testing practices"""
    
    def test_order_business_behavior(self):
        """✅ GOOD: Testing business behavior instead of implementation"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        
        # ✅ Testing business behavior
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is False
        
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        
        assert order.can_be_confirmed() is True
        assert order.total_amount.amount == 31.98
    
    def test_order_state_transitions(self):
        """✅ GOOD: Testing state transitions instead of internal state"""
        order = Order(OrderId.generate(), CustomerId("customer-123"))
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        
        # ✅ Testing state transitions
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is True
        
        order.confirm()
        
        assert order.can_be_modified() is False
        assert order.can_be_shipped() is True
    
    def test_money_business_operations(self):
        """✅ GOOD: Testing business operations instead of implementation"""
        money1 = Money(100.00, "USD")
        money2 = Money(25.50, "USD")
        
        # ✅ Testing business operations
        result = money1.add(money2)
        assert result.amount == 125.50
        assert result.currency == "USD"
        
        # ✅ Testing business rules
        with pytest.raises(ValueError):
            money1.add(Money(25.50, "EUR"))  # Different currencies
    
    def test_customer_business_rules(self):
        """✅ GOOD: Testing business rules instead of implementation"""
        customer = Customer(CustomerId.generate(), "John Doe", EmailAddress("john.doe@example.com"))
        
        # ✅ Testing business rules
        assert customer.is_active() is False
        assert customer.can_place_orders() is False
        
        customer.activate()
        
        assert customer.is_active() is True
        assert customer.can_place_orders() is True
    
    def test_pricing_service_business_logic(self):
        """✅ GOOD: Testing business logic instead of implementation"""
        pricing_service = PricingService()
        
        # ✅ Testing business logic
        amount = Money(100.00, "USD")
        customer = Mock()
        customer.customer_type = "VIP"
        
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        assert discounted_amount.amount == 85.00  # 15% discount for VIP
    
    def test_customer_service_business_behavior(self):
        """✅ GOOD: Testing business behavior instead of implementation"""
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        # ✅ Testing business behavior
        mock_repository.find_by_email.return_value = None
        
        customer = customer_service.register_customer("John Doe", "john.doe@example.com")
        
        assert customer.name == "John Doe"
        assert customer.email.value == "john.doe@example.com"
        assert customer.is_active() is True
        
        # ✅ Testing business interactions
        mock_repository.save.assert_called_once_with(customer)
        mock_email_service.send_welcome_email.assert_called_once_with(customer)
```

## Key Concepts Demonstrated

### Testing Anti-Patterns to Avoid

#### 1. **Testing Infrastructure Concerns**
- ❌ Testing database operations instead of domain logic
- ❌ Testing email sending infrastructure instead of business behavior
- ❌ Testing file system operations instead of domain logic

#### 2. **Testing Implementation Details**
- ❌ Testing private methods and attributes
- ❌ Testing internal data structures
- ❌ Testing specific implementation details

#### 3. **Over-Mocking**
- ❌ Mocking domain objects instead of testing real behavior
- ❌ Mocking all dependencies instead of testing business logic
- ❌ Testing mocked behavior instead of actual domain logic

#### 4. **Brittle Tests**
- ❌ Testing exact string formats
- ❌ Testing specific error message text
- ❌ Testing implementation-specific details

### Common Anti-Patterns

#### **Testing Infrastructure Instead of Domain Logic**
- ❌ Database operations, email sending, file operations
- ❌ Framework-specific details
- ❌ Performance characteristics

#### **Testing Implementation Details**
- ❌ Private methods and attributes
- ❌ Internal data structures
- ❌ Specific implementation details

#### **Over-Mocking**
- ❌ Mocking domain objects
- ❌ Mocking all dependencies
- ❌ Testing mocked behavior

#### **Brittle Tests**
- ❌ Exact string formats
- ❌ Specific error messages
- ❌ Implementation-specific details

### Proper Testing Practices

#### **Test Business Behavior**
- ✅ Test what the object does, not how it does it
- ✅ Test business rules and state transitions
- ✅ Test business operations and interactions

#### **Test Domain Logic**
- ✅ Focus on domain concepts and business rules
- ✅ Test behavior that matters to the business
- ✅ Test interactions between domain objects

#### **Test Deterministic Behavior**
- ✅ Test behavior that is predictable and consistent
- ✅ Avoid testing random or performance characteristics
- ✅ Focus on business logic, not technical details

### Python Testing Benefits
- **pytest**: Powerful testing framework with clear error messages
- **unittest.mock**: Built-in mocking capabilities
- **Type Hints**: Better IDE support and documentation
- **Fixtures**: Reusable test data and setup
- **Parametrized Tests**: Test multiple scenarios efficiently
- **Error Handling**: Clear exception messages for business rules

### Best Practices for DDD Testing

#### **Test Domain Behavior**
- ✅ Focus on business rules and domain logic
- ✅ Test state transitions and business operations
- ✅ Test interactions between domain objects

#### **Avoid Infrastructure Testing**
- ❌ Don't test database operations
- ❌ Don't test email sending infrastructure
- ❌ Don't test file system operations

#### **Use Appropriate Mocking**
- ✅ Mock external dependencies
- ✅ Don't mock domain objects
- ✅ Focus on testing real business logic

## Related Concepts

- [Order Tests](./07-order-tests.md) - Proper testing examples
- [Money Tests](./08-money-tests.md) - Value object testing
- [Pricing Service Tests](./09-pricing-service-tests.md) - Domain service testing
- [Customer Service Tests](./10-customer-service-tests.md) - Service testing with mocking
- [Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid) - Testing concepts

/*
 * Navigation:
 * Previous: 10-customer-service-tests.md
 * Next: 12-testing-best-practices.md
 *
 * Back to: [Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid)
 */
