# Order Tests - Python Example

**Section**: [Pure Domain Logic is Easily Testable](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable)

**Navigation**: [← Previous: Customer Module](./06-customer-module.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Order Tests (pytest) - Pure Domain Logic Testing
# File: 2-Domain-Driven-Design/code-samples/python/07-order-tests.py

import pytest
from datetime import datetime
from unittest.mock import Mock, patch
import uuid

# Import the domain objects
from order_entity import Order, OrderId, CustomerId, ProductId, Money, OrderItem, OrderStatus

class TestOrder:
    """Test class for Order entity"""
    
    def test_create_order(self):
        """Test creating a new order"""
        # Arrange
        order_id = OrderId.generate()
        customer_id = CustomerId("customer-123")
        
        # Act
        order = Order(order_id, customer_id)
        
        # Assert
        assert order.id == order_id
        assert order.customer_id == customer_id
        assert order.status == OrderStatus.DRAFT
        assert order.item_count == 0
        assert order.total_amount.amount == 0
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is False
    
    def test_add_item_to_draft_order(self):
        """Test adding item to draft order"""
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
        assert item.quantity == 2
        assert item.unit_price == unit_price
    
    def test_add_item_to_confirmed_order_raises_error(self):
        """Test that adding item to confirmed order raises error"""
        # Arrange
        order = self._create_confirmed_order()
        product_id = ProductId("product-2")
        quantity = 1
        unit_price = Money(10.00, "USD")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot modify confirmed order"):
            order.add_item(product_id, quantity, unit_price)
    
    def test_add_item_with_zero_quantity_raises_error(self):
        """Test that adding item with zero quantity raises error"""
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId("product-1")
        quantity = 0
        unit_price = Money(15.99, "USD")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Quantity must be positive"):
            order.add_item(product_id, quantity, unit_price)
    
    def test_add_existing_item_updates_quantity(self):
        """Test that adding existing item updates quantity"""
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
    
    def test_remove_item_from_draft_order(self):
        """Test removing item from draft order"""
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId("product-1")
        order.add_item(product_id, 2, Money(15.99, "USD"))
        
        # Act
        order.remove_item(product_id)
        
        # Assert
        assert order.item_count == 0
        assert order.total_amount.amount == 0
        assert order.has_item(product_id) is False
    
    def test_remove_nonexistent_item_raises_error(self):
        """Test that removing nonexistent item raises error"""
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId("nonexistent-product")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Item not found in order"):
            order.remove_item(product_id)
    
    def test_update_item_quantity(self):
        """Test updating item quantity"""
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId("product-1")
        unit_price = Money(15.99, "USD")
        order.add_item(product_id, 2, unit_price)
        
        # Act
        order.update_item_quantity(product_id, 5)
        
        # Assert
        item = order.get_item_by_product_id(product_id)
        assert item.quantity == 5
        assert order.total_amount.amount == 79.95  # 5 * 15.99
    
    def test_confirm_order_with_items(self):
        """Test confirming order with items"""
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        
        # Act
        order.confirm()
        
        # Assert
        assert order.status == OrderStatus.CONFIRMED
        assert order.can_be_modified() is False
        assert order.can_be_shipped() is True
    
    def test_confirm_empty_order_raises_error(self):
        """Test that confirming empty order raises error"""
        # Arrange
        order = self._create_draft_order()
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot confirm empty order"):
            order.confirm()
    
    def test_confirm_order_with_low_amount_raises_error(self):
        """Test that confirming order with low amount raises error"""
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 1, Money(5.00, "USD"))  # Below $10 minimum
        
        # Act & Assert
        with pytest.raises(ValueError, match="Order amount must be at least"):
            order.confirm()
    
    def test_ship_confirmed_order(self):
        """Test shipping confirmed order"""
        # Arrange
        order = self._create_confirmed_order()
        
        # Act
        order.ship()
        
        # Assert
        assert order.status == OrderStatus.SHIPPED
        assert order.can_be_delivered() is True
    
    def test_ship_draft_order_raises_error(self):
        """Test that shipping draft order raises error"""
        # Arrange
        order = self._create_draft_order()
        
        # Act & Assert
        with pytest.raises(ValueError, match="Order must be confirmed before shipping"):
            order.ship()
    
    def test_deliver_shipped_order(self):
        """Test delivering shipped order"""
        # Arrange
        order = self._create_shipped_order()
        
        # Act
        order.deliver()
        
        # Assert
        assert order.status == OrderStatus.DELIVERED
    
    def test_deliver_draft_order_raises_error(self):
        """Test that delivering draft order raises error"""
        # Arrange
        order = self._create_draft_order()
        
        # Act & Assert
        with pytest.raises(ValueError, match="Order must be shipped before delivery"):
            order.deliver()
    
    def test_cancel_draft_order(self):
        """Test cancelling draft order"""
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.cancel()
        
        # Assert
        assert order.status == OrderStatus.CANCELLED
        assert order.can_be_cancelled() is False
    
    def test_cancel_shipped_order_raises_error(self):
        """Test that cancelling shipped order raises error"""
        # Arrange
        order = self._create_shipped_order()
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot cancel shipped or delivered order"):
            order.cancel()
    
    def test_order_business_rules(self):
        """Test order business rules"""
        # Arrange
        order = self._create_draft_order()
        
        # Act & Assert
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is False
        
        order.add_item(ProductId("product-1"), 1, Money(15.99, "USD"))
        
        assert order.can_be_confirmed() is True
        assert order.can_be_shipped() is False
        
        order.confirm()
        
        assert order.can_be_modified() is False
        assert order.can_be_confirmed() is False
        assert order.can_be_shipped() is True
        assert order.can_be_cancelled() is True
    
    def test_order_total_calculation(self):
        """Test order total calculation"""
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        order.add_item(ProductId("product-2"), 1, Money(25.50, "USD"))
        
        # Assert
        expected_total = (2 * 15.99) + (1 * 25.50)
        assert order.total_amount.amount == expected_total
    
    def test_order_with_multiple_items(self):
        """Test order with multiple different items"""
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        order.add_item(ProductId("product-2"), 1, Money(25.50, "USD"))
        order.add_item(ProductId("product-3"), 3, Money(10.00, "USD"))
        
        # Assert
        assert order.item_count == 3
        expected_total = (2 * 15.99) + (1 * 25.50) + (3 * 10.00)
        assert order.total_amount.amount == expected_total
    
    def test_order_domain_events(self):
        """Test order domain events"""
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
    
    def test_order_equality(self):
        """Test order equality"""
        # Arrange
        order_id = OrderId.generate()
        customer_id = CustomerId("customer-123")
        
        # Act
        order1 = Order(order_id, customer_id)
        order2 = Order(order_id, customer_id)
        
        # Assert
        assert order1.id == order2.id
        assert order1.customer_id == order2.customer_id
    
    def test_order_string_representation(self):
        """Test order string representation"""
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        
        # Act
        order_str = str(order)
        
        # Assert
        assert "Order" in order_str
        assert "DRAFT" in order_str
        assert "2" in order_str  # item count
        assert "31.98" in order_str  # total amount
    
    # Helper methods
    def _create_draft_order(self) -> Order:
        """Create a draft order for testing"""
        order_id = OrderId.generate()
        customer_id = CustomerId("customer-123")
        return Order(order_id, customer_id)
    
    def _create_confirmed_order(self) -> Order:
        """Create a confirmed order for testing"""
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 1, Money(15.99, "USD"))
        order.confirm()
        return order
    
    def _create_shipped_order(self) -> Order:
        """Create a shipped order for testing"""
        order = self._create_confirmed_order()
        order.ship()
        return order

class TestOrderItem:
    """Test class for OrderItem value object"""
    
    def test_create_order_item(self):
        """Test creating order item"""
        # Arrange
        product_id = ProductId("product-1")
        quantity = 2
        unit_price = Money(15.99, "USD")
        
        # Act
        item = OrderItem(product_id, quantity, unit_price)
        
        # Assert
        assert item.product_id == product_id
        assert item.quantity == quantity
        assert item.unit_price == unit_price
        assert item.total_price.amount == 31.98
    
    def test_order_item_with_zero_quantity_raises_error(self):
        """Test that order item with zero quantity raises error"""
        # Arrange
        product_id = ProductId("product-1")
        quantity = 0
        unit_price = Money(15.99, "USD")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Quantity must be positive"):
            OrderItem(product_id, quantity, unit_price)
    
    def test_order_item_total_price_calculation(self):
        """Test order item total price calculation"""
        # Arrange
        product_id = ProductId("product-1")
        quantity = 3
        unit_price = Money(12.50, "USD")
        
        # Act
        item = OrderItem(product_id, quantity, unit_price)
        
        # Assert
        expected_total = 3 * 12.50
        assert item.total_price.amount == expected_total
    
    def test_order_item_immutability(self):
        """Test that order item is immutable"""
        # Arrange
        product_id = ProductId("product-1")
        quantity = 2
        unit_price = Money(15.99, "USD")
        item = OrderItem(product_id, quantity, unit_price)
        
        # Act & Assert
        # OrderItem should be immutable (frozen dataclass)
        with pytest.raises(AttributeError):
            item.quantity = 5

class TestOrderIntegration:
    """Integration tests for Order entity"""
    
    def test_complete_order_lifecycle(self):
        """Test complete order lifecycle from draft to delivered"""
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId("product-1")
        unit_price = Money(15.99, "USD")
        
        # Act & Assert - Draft stage
        assert order.status == OrderStatus.DRAFT
        assert order.can_be_modified() is True
        
        order.add_item(product_id, 2, unit_price)
        assert order.item_count == 1
        assert order.total_amount.amount == 31.98
        
        # Act & Assert - Confirmed stage
        order.confirm()
        assert order.status == OrderStatus.CONFIRMED
        assert order.can_be_modified() is False
        assert order.can_be_shipped() is True
        
        # Act & Assert - Shipped stage
        order.ship()
        assert order.status == OrderStatus.SHIPPED
        assert order.can_be_delivered() is True
        
        # Act & Assert - Delivered stage
        order.deliver()
        assert order.status == OrderStatus.DELIVERED
    
    def test_order_with_multiple_items_lifecycle(self):
        """Test order lifecycle with multiple items"""
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
        order.add_item(ProductId("product-2"), 1, Money(25.50, "USD"))
        order.add_item(ProductId("product-3"), 3, Money(10.00, "USD"))
        
        # Assert
        assert order.item_count == 3
        expected_total = (2 * 15.99) + (1 * 25.50) + (3 * 10.00)
        assert order.total_amount.amount == expected_total
        
        # Confirm and ship
        order.confirm()
        order.ship()
        order.deliver()
        
        assert order.status == OrderStatus.DELIVERED
    
    def test_order_cancellation_scenarios(self):
        """Test different order cancellation scenarios"""
        # Test 1: Cancel draft order
        order1 = self._create_draft_order()
        order1.add_item(ProductId("product-1"), 1, Money(15.99, "USD"))
        order1.cancel()
        assert order1.status == OrderStatus.CANCELLED
        
        # Test 2: Cancel confirmed order
        order2 = self._create_confirmed_order()
        order2.cancel()
        assert order2.status == OrderStatus.CANCELLED
        
        # Test 3: Cannot cancel shipped order
        order3 = self._create_shipped_order()
        with pytest.raises(ValueError, match="Cannot cancel shipped or delivered order"):
            order3.cancel()
    
    def _create_draft_order(self) -> Order:
        """Create a draft order for testing"""
        order_id = OrderId.generate()
        customer_id = CustomerId("customer-123")
        return Order(order_id, customer_id)
    
    def _create_confirmed_order(self) -> Order:
        """Create a confirmed order for testing"""
        order = self._create_draft_order()
        order.add_item(ProductId("product-1"), 1, Money(15.99, "USD"))
        order.confirm()
        return order
    
    def _create_shipped_order(self) -> Order:
        """Create a shipped order for testing"""
        order = self._create_confirmed_order()
        order.ship()
        return order

# Test fixtures
@pytest.fixture
def sample_order():
    """Fixture for creating a sample order"""
    order_id = OrderId.generate()
    customer_id = CustomerId("customer-123")
    order = Order(order_id, customer_id)
    order.add_item(ProductId("product-1"), 2, Money(15.99, "USD"))
    return order

@pytest.fixture
def sample_order_item():
    """Fixture for creating a sample order item"""
    return OrderItem(ProductId("product-1"), 2, Money(15.99, "USD"))

# Parametrized tests
@pytest.mark.parametrize("quantity,unit_price,expected_total", [
    (1, 15.99, 15.99),
    (2, 15.99, 31.98),
    (5, 10.00, 50.00),
    (10, 25.50, 255.00)
])
def test_order_item_total_calculation(quantity, unit_price, expected_total):
    """Test order item total calculation with different parameters"""
    # Arrange
    product_id = ProductId("product-1")
    unit_price_obj = Money(unit_price, "USD")
    
    # Act
    item = OrderItem(product_id, quantity, unit_price_obj)
    
    # Assert
    assert item.total_price.amount == expected_total

@pytest.mark.parametrize("status,can_modify,can_confirm,can_ship,can_deliver,can_cancel", [
    (OrderStatus.DRAFT, True, False, False, False, True),
    (OrderStatus.CONFIRMED, False, False, True, False, True),
    (OrderStatus.SHIPPED, False, False, False, True, False),
    (OrderStatus.DELIVERED, False, False, False, False, False),
    (OrderStatus.CANCELLED, False, False, False, False, False)
])
def test_order_status_business_rules(status, can_modify, can_confirm, can_ship, can_deliver, can_cancel):
    """Test order status business rules"""
    # Arrange
    order = self._create_draft_order()
    order.add_item(ProductId("product-1"), 1, Money(15.99, "USD"))
    
    # Set order to specific status
    if status == OrderStatus.CONFIRMED:
        order.confirm()
    elif status == OrderStatus.SHIPPED:
        order.confirm()
        order.ship()
    elif status == OrderStatus.DELIVERED:
        order.confirm()
        order.ship()
        order.deliver()
    elif status == OrderStatus.CANCELLED:
        order.cancel()
    
    # Assert
    assert order.can_be_modified() == can_modify
    assert order.can_be_confirmed() == can_confirm
    assert order.can_be_shipped() == can_ship
    assert order.can_be_delivered() == can_deliver
    assert order.can_be_cancelled() == can_cancel
```

## Key Concepts Demonstrated

### Pure Domain Logic Testing

#### 1. **Isolated Testing**
- ✅ Tests focus on domain logic without external dependencies
- ✅ No database, network, or file system dependencies
- ✅ Fast and reliable test execution

#### 2. **Business Rule Validation**
- ✅ Tests verify business rules are enforced
- ✅ Invalid operations are properly rejected
- ✅ State transitions follow business rules

#### 3. **Comprehensive Coverage**
- ✅ Tests cover all public methods and properties
- ✅ Edge cases and error conditions are tested
- ✅ Integration scenarios are covered

#### 4. **Clear Test Structure**
- ✅ Arrange-Act-Assert pattern for clarity
- ✅ Descriptive test names explain what is being tested
- ✅ Helper methods reduce code duplication

### Order Testing Principles

#### **Test Behavior, Not Implementation**
- ✅ Tests verify business behavior, not internal implementation
- ✅ Tests focus on what the object does, not how it does it
- ✅ Tests remain stable when implementation changes

#### **Test Business Rules**
- ✅ Tests verify business rules are enforced
- ✅ Invalid operations are properly rejected
- ✅ State transitions follow business rules

#### **Test Edge Cases**
- ✅ Tests cover boundary conditions
- ✅ Error conditions are properly handled
- ✅ Invalid inputs are rejected

#### **Test Integration**
- ✅ Tests verify components work together
- ✅ Complete workflows are tested
- ✅ Domain events are properly triggered

### Python Testing Benefits
- **pytest**: Powerful testing framework with fixtures and parametrization
- **Type Hints**: Better IDE support and documentation
- **Dataclasses**: Clean, concise class definitions
- **Error Handling**: Clear exception messages for business rules
- **Fixtures**: Reusable test data and setup
- **Parametrized Tests**: Test multiple scenarios efficiently

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

- [Order Entity](./03-order-entity.md) - Entity being tested
- [Money Value Object](./02-money-value-object.md) - Value object used in tests
- [Customer Entity](./01-customer-entity.md) - Entity used in tests
- [Pure Domain Logic is Easily Testable](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable) - Testing concepts

/*
 * Navigation:
 * Previous: 06-customer-module.md
 * Next: 08-money-tests.md
 *
 * Back to: [Pure Domain Logic is Easily Testable](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable)
 */
