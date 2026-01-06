# Testing Best Practices - Python Example

**Section**: [Best Practices for DDD Unit Testing](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)

**Navigation**: [← Previous: Testing Anti-Patterns](./11-testing-anti-patterns.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Testing Best Practices
# File: 2-Domain-Driven-Design/code-samples/python/12-testing-best-practices.py

import pytest
from unittest.mock import Mock, patch, MagicMock
from datetime import datetime
from typing import List, Optional

# Import the domain objects
from order_entity import Order, OrderId, CustomerId, ProductId, Money, OrderItem, OrderStatus
from customer_entity import Customer, CustomerId as CustomerIdType, EmailAddress, CustomerStatus
from pricing_service import PricingService, TaxCalculator, ShippingCalculator
from customer_module import CustomerService, CustomerRepository, EmailService

class TestOrderBestPractices:
    """Examples of testing best practices for Order entity"""
    
    def test_order_creation_with_valid_data(self):
        """✅ GOOD: Test with descriptive name and clear intent"""
        # Arrange
        order_id = OrderId.generate()
        customer_id = CustomerId("customer-123")
        
        # Act
        order = Order(order_id, customer_id)
        
        # Assert
        assert order.id == order_id
        assert order.customer_id == customer_id
        assert order.status == OrderStatus.DRAFT
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is False
    
    def test_order_add_item_when_draft_succeeds(self):
        """✅ GOOD: Test specific scenario with clear conditions"""
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId("product-1")
        quantity = 2
        unit_price = Money(15.99, "USD")
        
        # Act
        order.add_item(product_id, quantity, unit_price)
        
        # Assert
        assert order.item_count == 1
        assert order.total_amount.amount == 31.98
        assert order.has_item(product_id) is True
        
        item = order.get_item_by_product_id(product_id)
        assert item is not None
        assert item.quantity == quantity
        assert item.unit_price == unit_price
    
    def test_order_add_item_when_confirmed_raises_error(self):
        """✅ GOOD: Test error condition with clear scenario"""
        # Arrange
        order = self._create_confirmed_order()
        product_id = ProductId("product-2")
        quantity = 1
        unit_price = Money(10.00, "USD")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot modify confirmed order"):
            order.add_item(product_id, quantity, unit_price)
    
    def test_order_add_item_with_zero_quantity_raises_error(self):
        """✅ GOOD: Test boundary condition"""
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId("product-1")
        quantity = 0
        unit_price = Money(15.99, "USD")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Quantity must be positive"):
            order.add_item(product_id, quantity, unit_price)
    
    def test_order_add_existing_item_updates_quantity(self):
        """✅ GOOD: Test business rule behavior"""
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId("product-1")
        unit_price = Money(15.99, "USD")
        
        # Act
        order.add_item(product_id, 2, unit_price)
        order.add_item(product_id, 3, unit_price)
        
        # Assert
        assert order.item_count == 1
        assert order.total_amount.amount == 79.95  # 5 * 15.99
        
        item = order.get_item_by_product_id(product_id)
        assert item.quantity == 5
    
    def test_order_confirm_with_valid_items_succeeds(self):
        """✅ GOOD: Test successful business operation"""
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        
        # Act
        order.confirm()
        
        # Assert
        assert order.status == OrderStatus.CONFIRMED
        assert order.can_be_modified() is False
        assert order.can_be_shipped() is True
    
    def test_order_confirm_with_empty_order_raises_error(self):
        """✅ GOOD: Test business rule validation"""
        # Arrange
        order = self._create_draft_order()
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot confirm empty order"):
            order.confirm()
    
    def test_order_confirm_with_low_amount_raises_error(self):
        """✅ GOOD: Test business rule for minimum order amount"""
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 1, Money(5.00, "USD"))  # Below $10 minimum
        
        # Act & Assert
        with pytest.raises(ValueError, match="Order amount must be at least"):
            order.confirm()
    
    def test_order_state_transitions_follow_business_rules(self):
        """✅ GOOD: Test complete state transition flow"""
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 1, Money(15.99, "USD"))
        
        # Act & Assert - Draft state
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is True
        assert order.can_be_shipped() is False
        
        # Act & Assert - Confirmed state
        order.confirm()
        assert order.can_be_modified() is False
        assert order.can_be_confirmed() is False
        assert order.can_be_shipped() is True
        assert order.can_be_cancelled() is True
        
        # Act & Assert - Shipped state
        order.ship()
        assert order.can_be_modified() is False
        assert order.can_be_confirmed() is False
        assert order.can_be_shipped() is False
        assert order.can_be_delivered() is True
        assert order.can_be_cancelled() is False
    
    def test_order_total_calculation_with_multiple_items(self):
        """✅ GOOD: Test complex business calculation"""
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        order.add_item(ProductId("product-2"), 1, Money(25.50, "USD"))
        order.add_item(ProductId("product-3"), 3, Money(10.00, "USD"))
        
        # Assert
        expected_total = (2 * 15.99) + (1 * 25.50) + (3 * 10.00)
        assert order.total_amount.amount == expected_total
        assert order.total_amount.currency == "USD"
    
    def test_order_domain_events_are_raised(self):
        """✅ GOOD: Test domain events for significant business events"""
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 1, Money(15.99, "USD"))
        
        # Act
        events = order.get_domain_events()
        assert len(events) == 0
        
        order.confirm()
        events = order.get_domain_events()
        assert "OrderConfirmed" in events
        
        order.ship()
        events = order.get_domain_events()
        assert "OrderShipped" in events
        
        order.deliver()
        events = order.get_domain_events()
        assert "OrderDelivered" in events
    
    # Helper methods for test setup
    def _create_draft_order(self) -> Order:
        """Helper method to create draft order for testing"""
        order_id = OrderId.generate()
        customer_id = CustomerId("customer-123")
        return Order(order_id, customer_id)
    
    def _create_confirmed_order(self) -> Order:
        """Helper method to create confirmed order for testing"""
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 1, Money(15.99, "USD"))
        order.confirm()
        return order

class TestMoneyBestPractices:
    """Examples of testing best practices for Money value object"""
    
    def test_money_creation_with_valid_amount_succeeds(self):
        """✅ GOOD: Test value object creation with valid data"""
        # Arrange
        amount = 100.50
        currency = "USD"
        
        # Act
        money = Money(amount, currency)
        
        # Assert
        assert money.amount == amount
        assert money.currency == currency
    
    def test_money_creation_with_negative_amount_raises_error(self):
        """✅ GOOD: Test value object validation"""
        # Arrange
        amount = -10.0
        currency = "USD"
        
        # Act & Assert
        with pytest.raises(ValueError, match="Amount cannot be negative"):
            Money(amount, currency)
    
    def test_money_creation_with_empty_currency_raises_error(self):
        """✅ GOOD: Test value object validation for currency"""
        # Arrange
        amount = 100.0
        currency = ""
        
        # Act & Assert
        with pytest.raises(ValueError, match="Currency cannot be empty"):
            Money(amount, currency)
    
    def test_money_addition_with_same_currency_succeeds(self):
        """✅ GOOD: Test value object business operations"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(25.75, "USD")
        
        # Act
        result = money1.add(money2)
        
        # Assert
        assert result.amount == 126.25
        assert result.currency == "USD"
        assert result is not money1  # Should return new instance
        assert result is not money2  # Should return new instance
    
    def test_money_addition_with_different_currencies_raises_error(self):
        """✅ GOOD: Test business rule validation"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(25.75, "EUR")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot add different currencies"):
            money1.add(money2)
    
    def test_money_multiplication_with_positive_factor_succeeds(self):
        """✅ GOOD: Test value object mathematical operations"""
        # Arrange
        money = Money(100.50, "USD")
        factor = 2.5
        
        # Act
        result = money.multiply(factor)
        
        # Assert
        assert result.amount == 251.25
        assert result.currency == "USD"
        assert result is not money  # Should return new instance
    
    def test_money_multiplication_with_negative_factor_raises_error(self):
        """✅ GOOD: Test business rule validation"""
        # Arrange
        money = Money(100.50, "USD")
        factor = -1.5
        
        # Act & Assert
        with pytest.raises(ValueError, match="Factor cannot be negative"):
            money.multiply(factor)
    
    def test_money_equality_with_same_values_returns_true(self):
        """✅ GOOD: Test value object equality"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.50, "USD")
        
        # Act & Assert
        assert money1 == money2
        assert money1.equals(money2) is True
    
    def test_money_equality_with_different_values_returns_false(self):
        """✅ GOOD: Test value object inequality"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.51, "USD")
        
        # Act & Assert
        assert money1 != money2
        assert money1.equals(money2) is False
    
    def test_money_equality_with_different_currencies_returns_false(self):
        """✅ GOOD: Test value object inequality for different currencies"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.50, "EUR")
        
        # Act & Assert
        assert money1 != money2
        assert money1.equals(money2) is False
    
    def test_money_hash_consistency(self):
        """✅ GOOD: Test value object hash consistency"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.50, "USD")
        
        # Act & Assert
        assert hash(money1) == hash(money2)
    
    def test_money_immutability(self):
        """✅ GOOD: Test value object immutability"""
        # Arrange
        money = Money(100.50, "USD")
        
        # Act & Assert
        # Money should be immutable (frozen dataclass)
        with pytest.raises(AttributeError):
            money.amount = 200.0
        
        with pytest.raises(AttributeError):
            money.currency = "EUR"
    
    def test_money_factory_methods(self):
        """✅ GOOD: Test value object factory methods"""
        # Test zero factory
        zero_usd = Money.zero("USD")
        assert zero_usd.amount == 0.0
        assert zero_usd.currency == "USD"
        
        # Test from_amount factory
        amount_usd = Money.from_amount(100.50, "USD")
        assert amount_usd.amount == 100.50
        assert amount_usd.currency == "USD"

class TestPricingServiceBestPractices:
    """Examples of testing best practices for PricingService domain service"""
    
    def test_calculate_order_total_with_active_customer_succeeds(self):
        """✅ GOOD: Test domain service with valid inputs"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_active_customer()
        address = self._create_address()
        
        # Act
        total = pricing_service.calculate_order_total(order, customer, address)
        
        # Assert
        assert isinstance(total, Money)
        assert total.currency == "USD"
        assert total.amount > 0
    
    def test_calculate_order_total_with_inactive_customer_raises_error(self):
        """✅ GOOD: Test domain service error condition"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_inactive_customer()
        address = self._create_address()
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot calculate pricing for inactive customer"):
            pricing_service.calculate_order_total(order, customer, address)
    
    def test_calculate_discount_amount_for_vip_customer(self):
        """✅ GOOD: Test domain service business logic"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_vip_customer()
        
        # Act
        discount = pricing_service.calculate_discount_amount(order, customer)
        
        # Assert
        assert isinstance(discount, Money)
        assert discount.currency == "USD"
        assert discount.amount > 0
    
    def test_calculate_discount_amount_for_basic_customer(self):
        """✅ GOOD: Test domain service with no discount scenario"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_basic_customer()
        
        # Act
        discount = pricing_service.calculate_discount_amount(order, customer)
        
        # Assert
        assert isinstance(discount, Money)
        assert discount.currency == "USD"
        assert discount.amount == 0  # Basic customers get no discount
    
    def test_get_available_discounts_returns_list(self):
        """✅ GOOD: Test domain service return value"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_vip_customer()
        
        # Act
        discounts = pricing_service.get_available_discounts(order, customer)
        
        # Assert
        assert isinstance(discounts, list)
        assert len(discounts) > 0
        
        for discount in discounts:
            assert hasattr(discount, 'id')
            assert hasattr(discount, 'name')
            assert hasattr(discount, 'type')
            assert hasattr(discount, 'value')
            assert hasattr(discount, 'description')
    
    def test_apply_customer_discount_vip_rate(self):
        """✅ GOOD: Test domain service internal business logic"""
        # Arrange
        pricing_service = PricingService()
        amount = Money(100.00, "USD")
        customer = self._create_vip_customer()
        
        # Act
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        
        # Assert
        assert discounted_amount.amount == 85.00  # 15% discount
        assert discounted_amount.currency == "USD"
    
    def test_apply_bulk_discount_over_1000_threshold(self):
        """✅ GOOD: Test domain service threshold logic"""
        # Arrange
        pricing_service = PricingService()
        amount = Money(1200.00, "USD")
        order = self._create_order_with_amount(1200.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 1080.00  # 10% discount
        assert discounted_amount.currency == "USD"
    
    def test_apply_shipping_discount_over_50_free_shipping(self):
        """✅ GOOD: Test domain service free shipping logic"""
        # Arrange
        pricing_service = PricingService()
        shipping = Money(5.99, "USD")
        order_amount = Money(75.00, "USD")
        
        # Act
        discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount)
        
        # Assert
        assert discounted_shipping.amount == 0.00  # Free shipping
        assert discounted_shipping.currency == "USD"
    
    # Helper methods for test setup
    def _create_order_with_items(self):
        """Helper method to create order with items for testing"""
        order = MockOrder()
        order.total_amount = Money(100.00, "USD")
        order.items = [
            MockOrderItem(ProductId("product-1"), 2, Money(15.99, "USD")),
            MockOrderItem(ProductId("product-2"), 1, Money(25.50, "USD"))
        ]
        return order
    
    def _create_order_with_amount(self, amount):
        """Helper method to create order with specific amount for testing"""
        order = MockOrder()
        order.total_amount = Money(amount, "USD")
        order.items = []
        return order
    
    def _create_active_customer(self):
        """Helper method to create active customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "Standard"
        customer.is_active.return_value = True
        return customer
    
    def _create_inactive_customer(self):
        """Helper method to create inactive customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "Standard"
        customer.is_active.return_value = False
        return customer
    
    def _create_vip_customer(self):
        """Helper method to create VIP customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "VIP"
        customer.is_active.return_value = True
        return customer
    
    def _create_basic_customer(self):
        """Helper method to create basic customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "Basic"
        customer.is_active.return_value = True
        return customer
    
    def _create_address(self):
        """Helper method to create address for testing"""
        address = MockAddress()
        address.country = "US"
        address.state = "CA"
        return address

class TestCustomerServiceBestPractices:
    """Examples of testing best practices for CustomerService domain service"""
    
    def test_register_customer_with_valid_data_succeeds(self):
        """✅ GOOD: Test domain service with valid inputs"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = "John Doe"
        email = "john.doe@example.com"
        
        # Mock repository to return None (customer doesn't exist)
        mock_repository.find_by_email.return_value = None
        
        # Act
        customer = customer_service.register_customer(name, email)
        
        # Assert
        assert isinstance(customer, Customer)
        assert customer.name == name
        assert customer.email.value == email
        assert customer.is_active() is True
        
        # Verify repository interactions
        mock_repository.find_by_email.assert_called_once_with(email)
        mock_repository.save.assert_called_once_with(customer)
        
        # Verify email service interactions
        mock_email_service.send_welcome_email.assert_called_once_with(customer)
    
    def test_register_customer_with_empty_name_raises_error(self):
        """✅ GOOD: Test domain service validation"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = ""
        email = "john.doe@example.com"
        
        # Act & Assert
        with pytest.raises(ValueError, match="Name cannot be empty"):
            customer_service.register_customer(name, email)
        
        # Verify repository was not called
        mock_repository.find_by_email.assert_not_called()
        mock_repository.save.assert_not_called()
    
    def test_register_customer_with_existing_email_raises_error(self):
        """✅ GOOD: Test domain service business rule validation"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = "John Doe"
        email = "john.doe@example.com"
        
        # Mock repository to return existing customer
        existing_customer = Mock(spec=Customer)
        mock_repository.find_by_email.return_value = existing_customer
        
        # Act & Assert
        with pytest.raises(ValueError, match="Customer with this email already exists"):
            customer_service.register_customer(name, email)
        
        # Verify repository was called but save was not
        mock_repository.find_by_email.assert_called_once_with(email)
        mock_repository.save.assert_not_called()
    
    def test_update_customer_email_with_valid_data_succeeds(self):
        """✅ GOOD: Test domain service update operation"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "customer-123"
        new_email = "john.doe.new@example.com"
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Mock repository to return None (new email doesn't exist)
        mock_repository.find_by_email.return_value = None
        
        # Act
        customer_service.update_customer_email(customer_id, new_email)
        
        # Assert
        # Verify customer's update_email method was called
        existing_customer.update_email.assert_called_once()
        
        # Verify repository interactions
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.find_by_email.assert_called_once_with(new_email)
        mock_repository.save.assert_called_once_with(existing_customer)
        
        # Verify email service interactions
        mock_email_service.send_email_change_notification.assert_called_once_with(existing_customer)
    
    def test_update_customer_email_with_nonexistent_customer_raises_error(self):
        """✅ GOOD: Test domain service error condition"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "non-existent-customer"
        new_email = "john.doe.new@example.com"
        
        # Mock repository to return None (customer doesn't exist)
        mock_repository.find_by_id.return_value = None
        
        # Act & Assert
        with pytest.raises(ValueError, match="Customer not found"):
            customer_service.update_customer_email(customer_id, new_email)
        
        # Verify repository was called but save was not
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.save.assert_not_called()
    
    def test_suspend_customer_with_valid_data_succeeds(self):
        """✅ GOOD: Test domain service suspension operation"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "customer-123"
        reason = "Violation of terms of service"
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Act
        customer_service.suspend_customer(customer_id, reason)
        
        # Assert
        # Verify customer's suspend method was called
        existing_customer.suspend.assert_called_once()
        
        # Verify repository interactions
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.save.assert_called_once_with(existing_customer)
        
        # Verify email service interactions
        mock_email_service.send_suspension_notification.assert_called_once_with(existing_customer, reason)
    
    def test_customer_service_dependency_injection(self):
        """✅ GOOD: Test dependency injection setup"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        
        # Act
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        # Assert
        assert customer_service._repository is mock_repository
        assert customer_service._email_service is mock_email_service

# Mock classes for testing
class MockOrder:
    """Mock order for testing"""
    def __init__(self):
        self.total_amount = Money(100.00, "USD")
        self.items = []

class MockOrderItem:
    """Mock order item for testing"""
    def __init__(self, product_id, quantity, unit_price):
        self.product_id = product_id
        self.quantity = quantity
        self.unit_price = unit_price

class MockCustomer:
    """Mock customer for testing"""
    def __init__(self):
        self.customer_type = "Standard"
        self.is_active = Mock(return_value=True)

class MockAddress:
    """Mock address for testing"""
    def __init__(self):
        self.country = "US"
        self.state = "CA"
        self.province = None

# Test fixtures
@pytest.fixture
def sample_order():
    """Fixture for creating sample order"""
    order_id = OrderId.generate()
    customer_id = CustomerId("customer-123")
    order = Order(order_id, customer_id)
    order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
    return order

@pytest.fixture
def sample_money():
    """Fixture for creating sample money"""
    return Money(100.50, "USD")

@pytest.fixture
def sample_customer():
    """Fixture for creating sample customer"""
    customer_id = CustomerId.generate()
    email = EmailAddress("john.doe@example.com")
    customer = Customer(customer_id, "John Doe", email)
    customer.activate()
    return customer

# Parametrized tests
@pytest.mark.parametrize("customer_type,expected_discount_rate", [
    ("VIP", 0.15),
    ("Premium", 0.10),
    ("Standard", 0.05),
    ("Basic", 0.0),
    ("Unknown", 0.0)
])
def test_customer_discount_rates(customer_type, expected_discount_rate):
    """✅ GOOD: Parametrized test for customer discount rates"""
    # Arrange
    pricing_service = PricingService()
    
    # Act
    discount_rate = pricing_service._get_customer_discount_rate(customer_type)
    
    # Assert
    assert discount_rate == expected_discount_rate

@pytest.mark.parametrize("order_amount,expected_discount_rate", [
    (1200.0, 0.10),
    (600.0, 0.05),
    (150.0, 0.02),
    (50.0, 0.0)
])
def test_bulk_discount_rates(order_amount, expected_discount_rate):
    """✅ GOOD: Parametrized test for bulk discount rates"""
    # Arrange
    pricing_service = PricingService()
    order = MockOrder()
    order.total_amount = Money(order_amount, "USD")
    
    # Act
    discount = pricing_service._get_bulk_discount(order)
    
    # Assert
    if expected_discount_rate > 0:
        assert discount is not None
        assert discount.value == expected_discount_rate
    else:
        assert discount is None

@pytest.mark.parametrize("amount1,amount2,expected", [
    (100.0, 50.0, 150.0),
    (0.0, 100.0, 100.0),
    (25.50, 75.25, 100.75),
    (999.99, 0.01, 1000.0)
])
def test_money_addition(amount1, amount2, expected):
    """✅ GOOD: Parametrized test for money addition"""
    # Arrange
    money1 = Money(amount1, "USD")
    money2 = Money(amount2, "USD")
    
    # Act
    result = money1.add(money2)
    
    # Assert
    assert result.amount == expected
    assert result.currency == "USD"
```

## Key Concepts Demonstrated

### Best Practices for DDD Unit Testing

#### 1. **Descriptive Test Names**
- ✅ Test names clearly describe what is being tested
- ✅ Test names include the scenario and expected outcome
- ✅ Test names are readable and self-documenting

#### 2. **Arrange-Act-Assert Pattern**
- ✅ Clear separation of test setup, execution, and verification
- ✅ Test structure is consistent and easy to follow
- ✅ Test intent is clear from the structure

#### 3. **Test Business Behavior**
- ✅ Tests focus on business rules and domain logic
- ✅ Tests verify behavior that matters to the business
- ✅ Tests are independent of implementation details

#### 4. **Comprehensive Test Coverage**
- ✅ Tests cover all public methods and properties
- ✅ Tests cover edge cases and error conditions
- ✅ Tests cover business rule validation

### Testing Best Practices

#### **Test Business Rules**
- ✅ Customer discount rates are tested for all customer types
- ✅ Bulk discount thresholds are verified
- ✅ Order state transitions follow business rules

#### **Test Error Conditions**
- ✅ Invalid inputs are properly rejected
- ✅ Business rule violations are handled
- ✅ Error messages are clear and descriptive

#### **Test Edge Cases**
- ✅ Boundary conditions are tested
- ✅ Zero and negative values are handled
- ✅ Empty and null inputs are validated

#### **Use Helper Methods**
- ✅ Test setup is simplified with helper methods
- ✅ Test data creation is consistent
- ✅ Test maintenance is easier

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

#### **Use Appropriate Mocking**
- ✅ Mock external dependencies
- ✅ Don't mock domain objects
- ✅ Focus on testing real business logic

#### **Test Error Conditions**
- ✅ Test business rule violations
- ✅ Test invalid inputs
- ✅ Test edge cases and boundary conditions

#### **Use Test Fixtures**
- ✅ Reusable test data and setup
- ✅ Consistent test environment
- ✅ Easier test maintenance

## Related Concepts

- [Order Tests](./07-order-tests.md) - Proper testing examples
- [Money Tests](./08-money-tests.md) - Value object testing
- [Pricing Service Tests](./09-pricing-service-tests.md) - Domain service testing
- [Customer Service Tests](./10-customer-service-tests.md) - Service testing with mocking
- [Testing Anti-Patterns](./11-testing-anti-patterns.md) - Anti-patterns to avoid
- [Best Practices for DDD Unit Testing](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing) - Testing concepts

/*
 * Navigation:
 * Previous: 11-testing-anti-patterns.md
 * Next: 13-domain-modeling-best-practices.md
 *
 * Back to: [Best Practices for DDD Unit Testing](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)
 */
