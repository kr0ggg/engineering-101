# Pricing Service Tests - Python Example

**Section**: [Testable Business Rules](../../1-introduction-to-the-domain.md#testable-business-rules)

**Navigation**: [← Previous: Money Tests](./08-money-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Pricing Service Tests (pytest) - Domain Service Testing
# File: 2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests.py

import pytest
from unittest.mock import Mock, patch, MagicMock
from datetime import datetime

# Import the domain objects
from pricing_service import PricingService, TaxCalculator, ShippingCalculator
from order_entity import Order, OrderId, CustomerId, ProductId, Money, OrderItem
from customer_entity import Customer, CustomerStatus, CustomerId as CustomerIdType

class TestPricingService:
    """Test class for PricingService domain service"""
    
    def test_calculate_order_total_with_active_customer(self):
        """Test calculating order total for active customer"""
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
        """Test that calculating order total for inactive customer raises error"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_inactive_customer()
        address = self._create_address()
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot calculate pricing for inactive customer"):
            pricing_service.calculate_order_total(order, customer, address)
    
    def test_calculate_discount_amount_vip_customer(self):
        """Test calculating discount amount for VIP customer"""
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
    
    def test_calculate_discount_amount_premium_customer(self):
        """Test calculating discount amount for premium customer"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_premium_customer()
        
        # Act
        discount = pricing_service.calculate_discount_amount(order, customer)
        
        # Assert
        assert isinstance(discount, Money)
        assert discount.currency == "USD"
        assert discount.amount > 0
    
    def test_calculate_discount_amount_standard_customer(self):
        """Test calculating discount amount for standard customer"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_standard_customer()
        
        # Act
        discount = pricing_service.calculate_discount_amount(order, customer)
        
        # Assert
        assert isinstance(discount, Money)
        assert discount.currency == "USD"
        assert discount.amount > 0
    
    def test_calculate_discount_amount_basic_customer(self):
        """Test calculating discount amount for basic customer"""
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
    
    def test_get_available_discounts(self):
        """Test getting available discounts for an order"""
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
    
    def test_apply_customer_discount_vip(self):
        """Test applying VIP customer discount"""
        # Arrange
        pricing_service = PricingService()
        amount = Money(100.00, "USD")
        customer = self._create_vip_customer()
        
        # Act
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        
        # Assert
        assert discounted_amount.amount == 85.00  # 15% discount
        assert discounted_amount.currency == "USD"
    
    def test_apply_customer_discount_premium(self):
        """Test applying premium customer discount"""
        # Arrange
        pricing_service = PricingService()
        amount = Money(100.00, "USD")
        customer = self._create_premium_customer()
        
        # Act
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        
        # Assert
        assert discounted_amount.amount == 90.00  # 10% discount
        assert discounted_amount.currency == "USD"
    
    def test_apply_customer_discount_standard(self):
        """Test applying standard customer discount"""
        # Arrange
        pricing_service = PricingService()
        amount = Money(100.00, "USD")
        customer = self._create_standard_customer()
        
        # Act
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        
        # Assert
        assert discounted_amount.amount == 95.00  # 5% discount
        assert discounted_amount.currency == "USD"
    
    def test_apply_bulk_discount_over_1000(self):
        """Test applying bulk discount for orders over $1000"""
        # Arrange
        pricing_service = PricingService()
        amount = Money(1200.00, "USD")
        order = self._create_order_with_amount(1200.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 1080.00  # 10% discount
        assert discounted_amount.currency == "USD"
    
    def test_apply_bulk_discount_over_500(self):
        """Test applying bulk discount for orders over $500"""
        # Arrange
        pricing_service = PricingService()
        amount = Money(600.00, "USD")
        order = self._create_order_with_amount(600.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 570.00  # 5% discount
        assert discounted_amount.currency == "USD"
    
    def test_apply_bulk_discount_over_100(self):
        """Test applying bulk discount for orders over $100"""
        # Arrange
        pricing_service = PricingService()
        amount = Money(150.00, "USD")
        order = self._create_order_with_amount(150.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 147.00  # 2% discount
        assert discounted_amount.currency == "USD"
    
    def test_apply_bulk_discount_under_100(self):
        """Test applying bulk discount for orders under $100"""
        # Arrange
        pricing_service = PricingService()
        amount = Money(50.00, "USD")
        order = self._create_order_with_amount(50.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 50.00  # No discount
        assert discounted_amount.currency == "USD"
    
    def test_apply_shipping_discount_over_50(self):
        """Test applying shipping discount for orders over $50"""
        # Arrange
        pricing_service = PricingService()
        shipping = Money(5.99, "USD")
        order_amount = Money(75.00, "USD")
        
        # Act
        discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount)
        
        # Assert
        assert discounted_shipping.amount == 0.00  # Free shipping
        assert discounted_shipping.currency == "USD"
    
    def test_apply_shipping_discount_over_25(self):
        """Test applying shipping discount for orders over $25"""
        # Arrange
        pricing_service = PricingService()
        shipping = Money(5.99, "USD")
        order_amount = Money(30.00, "USD")
        
        # Act
        discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount)
        
        # Assert
        assert discounted_shipping.amount == 2.995  # 50% off shipping
        assert discounted_shipping.currency == "USD"
    
    def test_apply_shipping_discount_under_25(self):
        """Test applying shipping discount for orders under $25"""
        # Arrange
        pricing_service = PricingService()
        shipping = Money(5.99, "USD")
        order_amount = Money(20.00, "USD")
        
        # Act
        discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount)
        
        # Assert
        assert discounted_shipping.amount == 5.99  # No discount
        assert discounted_shipping.currency == "USD"
    
    def test_get_customer_discount_rate(self):
        """Test getting customer discount rate"""
        # Arrange
        pricing_service = PricingService()
        
        # Act & Assert
        assert pricing_service._get_customer_discount_rate("VIP") == 0.15
        assert pricing_service._get_customer_discount_rate("Premium") == 0.10
        assert pricing_service._get_customer_discount_rate("Standard") == 0.05
        assert pricing_service._get_customer_discount_rate("Basic") == 0.0
        assert pricing_service._get_customer_discount_rate("Unknown") == 0.0
    
    def test_get_customer_type_discount_vip(self):
        """Test getting customer type discount for VIP customer"""
        # Arrange
        pricing_service = PricingService()
        customer = self._create_vip_customer()
        
        # Act
        discount = pricing_service._get_customer_type_discount(customer)
        
        # Assert
        assert discount is not None
        assert discount.name == "VIP Customer Discount"
        assert discount.type == "percentage"
        assert discount.value == 0.15
        assert "VIP" in discount.description
    
    def test_get_customer_type_discount_basic(self):
        """Test getting customer type discount for basic customer"""
        # Arrange
        pricing_service = PricingService()
        customer = self._create_basic_customer()
        
        # Act
        discount = pricing_service._get_customer_type_discount(customer)
        
        # Assert
        assert discount is None  # Basic customers get no discount
    
    def test_get_bulk_discount_over_1000(self):
        """Test getting bulk discount for orders over $1000"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_amount(1200.00)
        
        # Act
        discount = pricing_service._get_bulk_discount(order)
        
        # Assert
        assert discount is not None
        assert discount.name == "Bulk Discount"
        assert discount.type == "percentage"
        assert discount.value == 0.10
        assert "10%" in discount.description
    
    def test_get_bulk_discount_over_500(self):
        """Test getting bulk discount for orders over $500"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_amount(600.00)
        
        # Act
        discount = pricing_service._get_bulk_discount(order)
        
        # Assert
        assert discount is not None
        assert discount.name == "Bulk Discount"
        assert discount.type == "percentage"
        assert discount.value == 0.05
        assert "5%" in discount.description
    
    def test_get_bulk_discount_under_500(self):
        """Test getting bulk discount for orders under $500"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_amount(300.00)
        
        # Act
        discount = pricing_service._get_bulk_discount(order)
        
        # Assert
        assert discount is None  # No bulk discount
    
    def test_get_seasonal_discount_holiday_season(self):
        """Test getting seasonal discount during holiday season"""
        # Arrange
        pricing_service = PricingService()
        
        # Mock datetime to return December
        with patch('pricing_service.datetime') as mock_datetime:
            mock_datetime.now.return_value.month = 12
            
            # Act
            discount = pricing_service._get_seasonal_discount()
            
            # Assert
            assert discount is not None
            assert discount.name == "Holiday Discount"
            assert discount.type == "percentage"
            assert discount.value == 0.08
            assert "holiday" in discount.description.lower()
    
    def test_get_seasonal_discount_non_holiday_season(self):
        """Test getting seasonal discount during non-holiday season"""
        # Arrange
        pricing_service = PricingService()
        
        # Mock datetime to return March
        with patch('pricing_service.datetime') as mock_datetime:
            mock_datetime.now.return_value.month = 3
            
            # Act
            discount = pricing_service._get_seasonal_discount()
            
            # Assert
            assert discount is None  # No seasonal discount
    
    def test_get_product_discounts_sale_items(self):
        """Test getting product discounts for sale items"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_sale_items()
        
        # Act
        discounts = pricing_service._get_product_discounts(order)
        
        # Assert
        assert len(discounts) > 0
        for discount in discounts:
            assert discount.name == "Sale Item Discount"
            assert discount.type == "percentage"
            assert discount.value == 0.20
            assert "sale" in discount.description.lower()
    
    def test_get_product_discounts_no_sale_items(self):
        """Test getting product discounts for non-sale items"""
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        
        # Act
        discounts = pricing_service._get_product_discounts(order)
        
        # Assert
        assert len(discounts) == 0  # No sale items
    
    # Helper methods
    def _create_order_with_items(self):
        """Create order with items for testing"""
        order = MockOrder()
        order.total_amount = Money(100.00, "USD")
        order.items = [
            MockOrderItem(ProductId("product-1"), 2, Money(15.99, "USD")),
            MockOrderItem(ProductId("product-2"), 1, Money(25.50, "USD"))
        ]
        return order
    
    def _create_order_with_amount(self, amount):
        """Create order with specific amount for testing"""
        order = MockOrder()
        order.total_amount = Money(amount, "USD")
        order.items = []
        return order
    
    def _create_order_with_sale_items(self):
        """Create order with sale items for testing"""
        order = MockOrder()
        order.total_amount = Money(100.00, "USD")
        order.items = [
            MockOrderItem(ProductId("SALE-product-1"), 2, Money(15.99, "USD")),
            MockOrderItem(ProductId("SALE-product-2"), 1, Money(25.50, "USD"))
        ]
        return order
    
    def _create_active_customer(self):
        """Create active customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "Standard"
        customer.is_active.return_value = True
        return customer
    
    def _create_inactive_customer(self):
        """Create inactive customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "Standard"
        customer.is_active.return_value = False
        return customer
    
    def _create_vip_customer(self):
        """Create VIP customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "VIP"
        customer.is_active.return_value = True
        return customer
    
    def _create_premium_customer(self):
        """Create premium customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "Premium"
        customer.is_active.return_value = True
        return customer
    
    def _create_standard_customer(self):
        """Create standard customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "Standard"
        customer.is_active.return_value = True
        return customer
    
    def _create_basic_customer(self):
        """Create basic customer for testing"""
        customer = MockCustomer()
        customer.customer_type = "Basic"
        customer.is_active.return_value = True
        return customer
    
    def _create_address(self):
        """Create address for testing"""
        address = MockAddress()
        address.country = "US"
        address.state = "CA"
        return address

class TestTaxCalculator:
    """Test class for TaxCalculator domain service"""
    
    def test_calculate_tax_us_california(self):
        """Test calculating tax for US California"""
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, "USD")
        address = MockAddress()
        address.country = "US"
        address.state = "CA"
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 8.00  # 8% tax
        assert tax.currency == "USD"
    
    def test_calculate_tax_us_texas(self):
        """Test calculating tax for US Texas"""
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, "USD")
        address = MockAddress()
        address.country = "US"
        address.state = "TX"
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 8.00  # 8% tax
        assert tax.currency == "USD"
    
    def test_calculate_tax_us_other_state(self):
        """Test calculating tax for US other state"""
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, "USD")
        address = MockAddress()
        address.country = "US"
        address.state = "NY"
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 6.00  # 6% tax
        assert tax.currency == "USD"
    
    def test_calculate_tax_canada_ontario(self):
        """Test calculating tax for Canada Ontario"""
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, "USD")
        address = MockAddress()
        address.country = "CA"
        address.province = "ON"
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 13.00  # 13% HST
        assert tax.currency == "USD"
    
    def test_calculate_tax_canada_other_province(self):
        """Test calculating tax for Canada other province"""
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, "USD")
        address = MockAddress()
        address.country = "CA"
        address.province = "QC"
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 15.00  # 15% HST
        assert tax.currency == "USD"
    
    def test_calculate_tax_international(self):
        """Test calculating tax for international address"""
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, "USD")
        address = MockAddress()
        address.country = "UK"
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 0.00  # No tax for international
        assert tax.currency == "USD"

class TestShippingCalculator:
    """Test class for ShippingCalculator domain service"""
    
    def test_calculate_shipping_us(self):
        """Test calculating shipping for US address"""
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_order_with_items()
        address = MockAddress()
        address.country = "US"
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount >= 5.99  # Base shipping
        assert shipping.currency == "USD"
    
    def test_calculate_shipping_canada(self):
        """Test calculating shipping for Canada address"""
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_order_with_items()
        address = MockAddress()
        address.country = "CA"
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount >= 8.99  # Base shipping
        assert shipping.currency == "USD"
    
    def test_calculate_shipping_international(self):
        """Test calculating shipping for international address"""
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_order_with_items()
        address = MockAddress()
        address.country = "UK"
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount >= 15.99  # Base shipping
        assert shipping.currency == "USD"
    
    def test_calculate_shipping_with_weight_charge(self):
        """Test calculating shipping with weight charge"""
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_heavy_order()
        address = MockAddress()
        address.country = "US"
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount > 5.99  # Base shipping + weight charge
        assert shipping.currency == "USD"
    
    def test_calculate_shipping_with_distance_charge(self):
        """Test calculating shipping with distance charge"""
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_order_with_items()
        address = MockAddress()
        address.country = "US"
        address.state = "AK"  # Alaska
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount > 5.99  # Base shipping + distance charge
        assert shipping.currency == "USD"
    
    def _create_order_with_items(self):
        """Create order with items for testing"""
        order = MockOrder()
        order.items = [
            MockOrderItem(ProductId("product-1"), 2, Money(15.99, "USD")),
            MockOrderItem(ProductId("product-2"), 1, Money(25.50, "USD"))
        ]
        return order
    
    def _create_heavy_order(self):
        """Create heavy order for testing"""
        order = MockOrder()
        order.items = [
            MockOrderItem(ProductId("product-1"), 50, Money(15.99, "USD"))  # Heavy order
        ]
        return order

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
def pricing_service():
    """Fixture for creating pricing service"""
    return PricingService()

@pytest.fixture
def tax_calculator():
    """Fixture for creating tax calculator"""
    return TaxCalculator()

@pytest.fixture
def shipping_calculator():
    """Fixture for creating shipping calculator"""
    return ShippingCalculator()

# Parametrized tests
@pytest.mark.parametrize("customer_type,expected_discount_rate", [
    ("VIP", 0.15),
    ("Premium", 0.10),
    ("Standard", 0.05),
    ("Basic", 0.0),
    ("Unknown", 0.0)
])
def test_customer_discount_rates(customer_type, expected_discount_rate):
    """Test customer discount rates with different parameters"""
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
    """Test bulk discount rates with different parameters"""
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

@pytest.mark.parametrize("order_amount,expected_shipping_discount", [
    (75.0, 0.0),  # Free shipping
    (30.0, 0.5),  # 50% off shipping
    (20.0, 1.0)   # No discount
])
def test_shipping_discount_rates(order_amount, expected_shipping_discount):
    """Test shipping discount rates with different parameters"""
    # Arrange
    pricing_service = PricingService()
    shipping = Money(5.99, "USD")
    order_amount_obj = Money(order_amount, "USD")
    
    # Act
    discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount_obj)
    
    # Assert
    if expected_shipping_discount == 0.0:
        assert discounted_shipping.amount == 0.0
    elif expected_shipping_discount == 0.5:
        assert discounted_shipping.amount == 2.995
    else:
        assert discounted_shipping.amount == 5.99
```

## Key Concepts Demonstrated

### Testable Business Rules

#### 1. **Domain Service Testing**
- ✅ Tests focus on business logic without external dependencies
- ✅ Complex business rules are tested in isolation
- ✅ Service behavior is verified through comprehensive test cases

#### 2. **Business Rule Validation**
- ✅ Tests verify business rules are enforced correctly
- ✅ Different customer types get appropriate discounts
- ✅ Bulk discounts are applied based on order amounts

#### 3. **Service Composition Testing**
- ✅ Individual services (TaxCalculator, ShippingCalculator) are tested
- ✅ Service interactions are verified
- ✅ Complex calculations are broken down into testable components

#### 4. **Mock Usage**
- ✅ External dependencies are mocked for isolated testing
- ✅ Test data is created using helper methods
- ✅ Tests focus on business logic, not infrastructure

### Pricing Service Testing Principles

#### **Test Business Rules**
- ✅ Customer discount rates are tested for all customer types
- ✅ Bulk discount thresholds are verified
- ✅ Shipping discount rules are tested

#### **Test Edge Cases**
- ✅ Boundary conditions (exactly $100, $500, $1000)
- ✅ Error conditions (inactive customers)
- ✅ Different address types (US, Canada, International)

#### **Test Service Composition**
- ✅ Individual services are tested separately
- ✅ Service interactions are verified
- ✅ Complex calculations are broken down

#### **Test Mocking**
- ✅ External dependencies are properly mocked
- ✅ Test data is created using helper methods
- ✅ Tests remain focused on business logic

### Python Testing Benefits
- **pytest**: Powerful testing framework with fixtures and parametrization
- **unittest.mock**: Built-in mocking capabilities
- **Type Hints**: Better IDE support and documentation
- **Fixtures**: Reusable test data and setup
- **Parametrized Tests**: Test multiple scenarios efficiently
- **Error Handling**: Clear exception messages for business rules

### Common Anti-Patterns to Avoid

#### **Testing Implementation Details**
- ❌ Tests that verify internal implementation
- ❌ Tests that break when implementation changes
- ❌ Tests that don't verify business behavior

#### **Over-Mocking**
- ❌ Mocking everything instead of testing real behavior
- ❌ Tests that don't verify actual business logic
- ❌ Tests that are hard to maintain

#### **Incomplete Test Coverage**
- ❌ Tests that don't cover all business rules
- ❌ Tests that miss edge cases
- ❌ Tests that don't verify error conditions

## Related Concepts

- [Pricing Service](./05-pricing-service.md) - Service being tested
- [Order Tests](./07-order-tests.md) - Tests that use Pricing Service
- [Money Tests](./08-money-tests.md) - Tests for Money value object
- [Testable Business Rules](../../1-introduction-to-the-domain.md#testable-business-rules) - Testing concepts

/*
 * Navigation:
 * Previous: 08-money-tests.md
 * Next: 10-customer-service-tests.md
 *
 * Back to: [Testable Business Rules](../../1-introduction-to-the-domain.md#testable-business-rules)
 */
