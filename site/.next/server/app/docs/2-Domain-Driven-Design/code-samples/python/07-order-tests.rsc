1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/07-order-tests","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"07-order-tests\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T651a,<h1>Order Tests - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable">Pure Domain Logic is Easily Testable</a></p>
<p><strong>Navigation</strong>: <a href="./06-customer-module.md">← Previous: Customer Module</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - Order Tests (pytest) - Pure Domain Logic Testing
# File: 2-Domain-Driven-Design/code-samples/python/07-order-tests.py

import pytest
from datetime import datetime
from unittest.mock import Mock, patch
import uuid

# Import the domain objects
from order_entity import Order, OrderId, CustomerId, ProductId, Money, OrderItem, OrderStatus

class TestOrder:
    &quot;&quot;&quot;Test class for Order entity&quot;&quot;&quot;
    
    def test_create_order(self):
        &quot;&quot;&quot;Test creating a new order&quot;&quot;&quot;
        # Arrange
        order_id = OrderId.generate()
        customer_id = CustomerId(&quot;customer-123&quot;)
        
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
        &quot;&quot;&quot;Test adding item to draft order&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId(&quot;product-1&quot;)
        quantity = 2
        unit_price = Money(15.99, &quot;USD&quot;)
        
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
        &quot;&quot;&quot;Test that adding item to confirmed order raises error&quot;&quot;&quot;
        # Arrange
        order = self._create_confirmed_order()
        product_id = ProductId(&quot;product-2&quot;)
        quantity = 1
        unit_price = Money(10.00, &quot;USD&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot modify confirmed order&quot;):
            order.add_item(product_id, quantity, unit_price)
    
    def test_add_item_with_zero_quantity_raises_error(self):
        &quot;&quot;&quot;Test that adding item with zero quantity raises error&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId(&quot;product-1&quot;)
        quantity = 0
        unit_price = Money(15.99, &quot;USD&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Quantity must be positive&quot;):
            order.add_item(product_id, quantity, unit_price)
    
    def test_add_existing_item_updates_quantity(self):
        &quot;&quot;&quot;Test that adding existing item updates quantity&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId(&quot;product-1&quot;)
        unit_price = Money(15.99, &quot;USD&quot;)
        
        # Act
        order.add_item(product_id, 2, unit_price)
        order.add_item(product_id, 3, unit_price)
        
        # Assert
        assert order.item_count == 1
        assert order.total_amount.amount == 79.95  # 5 * 15.99
        
        item = order.get_item_by_product_id(product_id)
        assert item.quantity == 5
    
    def test_remove_item_from_draft_order(self):
        &quot;&quot;&quot;Test removing item from draft order&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId(&quot;product-1&quot;)
        order.add_item(product_id, 2, Money(15.99, &quot;USD&quot;))
        
        # Act
        order.remove_item(product_id)
        
        # Assert
        assert order.item_count == 0
        assert order.total_amount.amount == 0
        assert order.has_item(product_id) is False
    
    def test_remove_nonexistent_item_raises_error(self):
        &quot;&quot;&quot;Test that removing nonexistent item raises error&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId(&quot;nonexistent-product&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Item not found in order&quot;):
            order.remove_item(product_id)
    
    def test_update_item_quantity(self):
        &quot;&quot;&quot;Test updating item quantity&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId(&quot;product-1&quot;)
        unit_price = Money(15.99, &quot;USD&quot;)
        order.add_item(product_id, 2, unit_price)
        
        # Act
        order.update_item_quantity(product_id, 5)
        
        # Assert
        item = order.get_item_by_product_id(product_id)
        assert item.quantity == 5
        assert order.total_amount.amount == 79.95  # 5 * 15.99
    
    def test_confirm_order_with_items(self):
        &quot;&quot;&quot;Test confirming order with items&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        
        # Act
        order.confirm()
        
        # Assert
        assert order.status == OrderStatus.CONFIRMED
        assert order.can_be_modified() is False
        assert order.can_be_shipped() is True
    
    def test_confirm_empty_order_raises_error(self):
        &quot;&quot;&quot;Test that confirming empty order raises error&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot confirm empty order&quot;):
            order.confirm()
    
    def test_confirm_order_with_low_amount_raises_error(self):
        &quot;&quot;&quot;Test that confirming order with low amount raises error&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 1, Money(5.00, &quot;USD&quot;))  # Below $10 minimum
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Order amount must be at least&quot;):
            order.confirm()
    
    def test_ship_confirmed_order(self):
        &quot;&quot;&quot;Test shipping confirmed order&quot;&quot;&quot;
        # Arrange
        order = self._create_confirmed_order()
        
        # Act
        order.ship()
        
        # Assert
        assert order.status == OrderStatus.SHIPPED
        assert order.can_be_delivered() is True
    
    def test_ship_draft_order_raises_error(self):
        &quot;&quot;&quot;Test that shipping draft order raises error&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Order must be confirmed before shipping&quot;):
            order.ship()
    
    def test_deliver_shipped_order(self):
        &quot;&quot;&quot;Test delivering shipped order&quot;&quot;&quot;
        # Arrange
        order = self._create_shipped_order()
        
        # Act
        order.deliver()
        
        # Assert
        assert order.status == OrderStatus.DELIVERED
    
    def test_deliver_draft_order_raises_error(self):
        &quot;&quot;&quot;Test that delivering draft order raises error&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Order must be shipped before delivery&quot;):
            order.deliver()
    
    def test_cancel_draft_order(self):
        &quot;&quot;&quot;Test cancelling draft order&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.cancel()
        
        # Assert
        assert order.status == OrderStatus.CANCELLED
        assert order.can_be_cancelled() is False
    
    def test_cancel_shipped_order_raises_error(self):
        &quot;&quot;&quot;Test that cancelling shipped order raises error&quot;&quot;&quot;
        # Arrange
        order = self._create_shipped_order()
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot cancel shipped or delivered order&quot;):
            order.cancel()
    
    def test_order_business_rules(self):
        &quot;&quot;&quot;Test order business rules&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act &amp; Assert
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is False
        
        order.add_item(ProductId(&quot;product-1&quot;), 1, Money(15.99, &quot;USD&quot;))
        
        assert order.can_be_confirmed() is True
        assert order.can_be_shipped() is False
        
        order.confirm()
        
        assert order.can_be_modified() is False
        assert order.can_be_confirmed() is False
        assert order.can_be_shipped() is True
        assert order.can_be_cancelled() is True
    
    def test_order_total_calculation(self):
        &quot;&quot;&quot;Test order total calculation&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        order.add_item(ProductId(&quot;product-2&quot;), 1, Money(25.50, &quot;USD&quot;))
        
        # Assert
        expected_total = (2 * 15.99) + (1 * 25.50)
        assert order.total_amount.amount == expected_total
    
    def test_order_with_multiple_items(self):
        &quot;&quot;&quot;Test order with multiple different items&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        order.add_item(ProductId(&quot;product-2&quot;), 1, Money(25.50, &quot;USD&quot;))
        order.add_item(ProductId(&quot;product-3&quot;), 3, Money(10.00, &quot;USD&quot;))
        
        # Assert
        assert order.item_count == 3
        expected_total = (2 * 15.99) + (1 * 25.50) + (3 * 10.00)
        assert order.total_amount.amount == expected_total
    
    def test_order_domain_events(self):
        &quot;&quot;&quot;Test order domain events&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 1, Money(15.99, &quot;USD&quot;))
        
        # Act
        events = order.get_domain_events()
        assert len(events) == 0
        
        order.confirm()
        events = order.get_domain_events()
        assert &quot;OrderConfirmed&quot; in events
        
        order.ship()
        events = order.get_domain_events()
        assert &quot;OrderShipped&quot; in events
        
        order.deliver()
        events = order.get_domain_events()
        assert &quot;OrderDelivered&quot; in events
    
    def test_order_equality(self):
        &quot;&quot;&quot;Test order equality&quot;&quot;&quot;
        # Arrange
        order_id = OrderId.generate()
        customer_id = CustomerId(&quot;customer-123&quot;)
        
        # Act
        order1 = Order(order_id, customer_id)
        order2 = Order(order_id, customer_id)
        
        # Assert
        assert order1.id == order2.id
        assert order1.customer_id == order2.customer_id
    
    def test_order_string_representation(self):
        &quot;&quot;&quot;Test order string representation&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        
        # Act
        order_str = str(order)
        
        # Assert
        assert &quot;Order&quot; in order_str
        assert &quot;DRAFT&quot; in order_str
        assert &quot;2&quot; in order_str  # item count
        assert &quot;31.98&quot; in order_str  # total amount
    
    # Helper methods
    def _create_draft_order(self) -&gt; Order:
        &quot;&quot;&quot;Create a draft order for testing&quot;&quot;&quot;
        order_id = OrderId.generate()
        customer_id = CustomerId(&quot;customer-123&quot;)
        return Order(order_id, customer_id)
    
    def _create_confirmed_order(self) -&gt; Order:
        &quot;&quot;&quot;Create a confirmed order for testing&quot;&quot;&quot;
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 1, Money(15.99, &quot;USD&quot;))
        order.confirm()
        return order
    
    def _create_shipped_order(self) -&gt; Order:
        &quot;&quot;&quot;Create a shipped order for testing&quot;&quot;&quot;
        order = self._create_confirmed_order()
        order.ship()
        return order

class TestOrderItem:
    &quot;&quot;&quot;Test class for OrderItem value object&quot;&quot;&quot;
    
    def test_create_order_item(self):
        &quot;&quot;&quot;Test creating order item&quot;&quot;&quot;
        # Arrange
        product_id = ProductId(&quot;product-1&quot;)
        quantity = 2
        unit_price = Money(15.99, &quot;USD&quot;)
        
        # Act
        item = OrderItem(product_id, quantity, unit_price)
        
        # Assert
        assert item.product_id == product_id
        assert item.quantity == quantity
        assert item.unit_price == unit_price
        assert item.total_price.amount == 31.98
    
    def test_order_item_with_zero_quantity_raises_error(self):
        &quot;&quot;&quot;Test that order item with zero quantity raises error&quot;&quot;&quot;
        # Arrange
        product_id = ProductId(&quot;product-1&quot;)
        quantity = 0
        unit_price = Money(15.99, &quot;USD&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Quantity must be positive&quot;):
            OrderItem(product_id, quantity, unit_price)
    
    def test_order_item_total_price_calculation(self):
        &quot;&quot;&quot;Test order item total price calculation&quot;&quot;&quot;
        # Arrange
        product_id = ProductId(&quot;product-1&quot;)
        quantity = 3
        unit_price = Money(12.50, &quot;USD&quot;)
        
        # Act
        item = OrderItem(product_id, quantity, unit_price)
        
        # Assert
        expected_total = 3 * 12.50
        assert item.total_price.amount == expected_total
    
    def test_order_item_immutability(self):
        &quot;&quot;&quot;Test that order item is immutable&quot;&quot;&quot;
        # Arrange
        product_id = ProductId(&quot;product-1&quot;)
        quantity = 2
        unit_price = Money(15.99, &quot;USD&quot;)
        item = OrderItem(product_id, quantity, unit_price)
        
        # Act &amp; Assert
        # OrderItem should be immutable (frozen dataclass)
        with pytest.raises(AttributeError):
            item.quantity = 5

class TestOrderIntegration:
    &quot;&quot;&quot;Integration tests for Order entity&quot;&quot;&quot;
    
    def test_complete_order_lifecycle(self):
        &quot;&quot;&quot;Test complete order lifecycle from draft to delivered&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId(&quot;product-1&quot;)
        unit_price = Money(15.99, &quot;USD&quot;)
        
        # Act &amp; Assert - Draft stage
        assert order.status == OrderStatus.DRAFT
        assert order.can_be_modified() is True
        
        order.add_item(product_id, 2, unit_price)
        assert order.item_count == 1
        assert order.total_amount.amount == 31.98
        
        # Act &amp; Assert - Confirmed stage
        order.confirm()
        assert order.status == OrderStatus.CONFIRMED
        assert order.can_be_modified() is False
        assert order.can_be_shipped() is True
        
        # Act &amp; Assert - Shipped stage
        order.ship()
        assert order.status == OrderStatus.SHIPPED
        assert order.can_be_delivered() is True
        
        # Act &amp; Assert - Delivered stage
        order.deliver()
        assert order.status == OrderStatus.DELIVERED
    
    def test_order_with_multiple_items_lifecycle(self):
        &quot;&quot;&quot;Test order lifecycle with multiple items&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        order.add_item(ProductId(&quot;product-2&quot;), 1, Money(25.50, &quot;USD&quot;))
        order.add_item(ProductId(&quot;product-3&quot;), 3, Money(10.00, &quot;USD&quot;))
        
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
        &quot;&quot;&quot;Test different order cancellation scenarios&quot;&quot;&quot;
        # Test 1: Cancel draft order
        order1 = self._create_draft_order()
        order1.add_item(ProductId(&quot;product-1&quot;), 1, Money(15.99, &quot;USD&quot;))
        order1.cancel()
        assert order1.status == OrderStatus.CANCELLED
        
        # Test 2: Cancel confirmed order
        order2 = self._create_confirmed_order()
        order2.cancel()
        assert order2.status == OrderStatus.CANCELLED
        
        # Test 3: Cannot cancel shipped order
        order3 = self._create_shipped_order()
        with pytest.raises(ValueError, match=&quot;Cannot cancel shipped or delivered order&quot;):
            order3.cancel()
    
    def _create_draft_order(self) -&gt; Order:
        &quot;&quot;&quot;Create a draft order for testing&quot;&quot;&quot;
        order_id = OrderId.generate()
        customer_id = CustomerId(&quot;customer-123&quot;)
        return Order(order_id, customer_id)
    
    def _create_confirmed_order(self) -&gt; Order:
        &quot;&quot;&quot;Create a confirmed order for testing&quot;&quot;&quot;
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 1, Money(15.99, &quot;USD&quot;))
        order.confirm()
        return order
    
    def _create_shipped_order(self) -&gt; Order:
        &quot;&quot;&quot;Create a shipped order for testing&quot;&quot;&quot;
        order = self._create_confirmed_order()
        order.ship()
        return order

# Test fixtures
@pytest.fixture
def sample_order():
    &quot;&quot;&quot;Fixture for creating a sample order&quot;&quot;&quot;
    order_id = OrderId.generate()
    customer_id = CustomerId(&quot;customer-123&quot;)
    order = Order(order_id, customer_id)
    order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
    return order

@pytest.fixture
def sample_order_item():
    &quot;&quot;&quot;Fixture for creating a sample order item&quot;&quot;&quot;
    return OrderItem(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))

# Parametrized tests
@pytest.mark.parametrize(&quot;quantity,unit_price,expected_total&quot;, [
    (1, 15.99, 15.99),
    (2, 15.99, 31.98),
    (5, 10.00, 50.00),
    (10, 25.50, 255.00)
])
def test_order_item_total_calculation(quantity, unit_price, expected_total):
    &quot;&quot;&quot;Test order item total calculation with different parameters&quot;&quot;&quot;
    # Arrange
    product_id = ProductId(&quot;product-1&quot;)
    unit_price_obj = Money(unit_price, &quot;USD&quot;)
    
    # Act
    item = OrderItem(product_id, quantity, unit_price_obj)
    
    # Assert
    assert item.total_price.amount == expected_total

@pytest.mark.parametrize(&quot;status,can_modify,can_confirm,can_ship,can_deliver,can_cancel&quot;, [
    (OrderStatus.DRAFT, True, False, False, False, True),
    (OrderStatus.CONFIRMED, False, False, True, False, True),
    (OrderStatus.SHIPPED, False, False, False, True, False),
    (OrderStatus.DELIVERED, False, False, False, False, False),
    (OrderStatus.CANCELLED, False, False, False, False, False)
])
def test_order_status_business_rules(status, can_modify, can_confirm, can_ship, can_deliver, can_cancel):
    &quot;&quot;&quot;Test order status business rules&quot;&quot;&quot;
    # Arrange
    order = self._create_draft_order()
    order.add_item(ProductId(&quot;product-1&quot;), 1, Money(15.99, &quot;USD&quot;))
    
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
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Pure Domain Logic Testing</h3>
<h4>1. <strong>Isolated Testing</strong></h4>
<ul>
<li>✅ Tests focus on domain logic without external dependencies</li>
<li>✅ No database, network, or file system dependencies</li>
<li>✅ Fast and reliable test execution</li>
</ul>
<h4>2. <strong>Business Rule Validation</strong></h4>
<ul>
<li>✅ Tests verify business rules are enforced</li>
<li>✅ Invalid operations are properly rejected</li>
<li>✅ State transitions follow business rules</li>
</ul>
<h4>3. <strong>Comprehensive Coverage</strong></h4>
<ul>
<li>✅ Tests cover all public methods and properties</li>
<li>✅ Edge cases and error conditions are tested</li>
<li>✅ Integration scenarios are covered</li>
</ul>
<h4>4. <strong>Clear Test Structure</strong></h4>
<ul>
<li>✅ Arrange-Act-Assert pattern for clarity</li>
<li>✅ Descriptive test names explain what is being tested</li>
<li>✅ Helper methods reduce code duplication</li>
</ul>
<h3>Order Testing Principles</h3>
<h4><strong>Test Behavior, Not Implementation</strong></h4>
<ul>
<li>✅ Tests verify business behavior, not internal implementation</li>
<li>✅ Tests focus on what the object does, not how it does it</li>
<li>✅ Tests remain stable when implementation changes</li>
</ul>
<h4><strong>Test Business Rules</strong></h4>
<ul>
<li>✅ Tests verify business rules are enforced</li>
<li>✅ Invalid operations are properly rejected</li>
<li>✅ State transitions follow business rules</li>
</ul>
<h4><strong>Test Edge Cases</strong></h4>
<ul>
<li>✅ Tests cover boundary conditions</li>
<li>✅ Error conditions are properly handled</li>
<li>✅ Invalid inputs are rejected</li>
</ul>
<h4><strong>Test Integration</strong></h4>
<ul>
<li>✅ Tests verify components work together</li>
<li>✅ Complete workflows are tested</li>
<li>✅ Domain events are properly triggered</li>
</ul>
<h3>Python Testing Benefits</h3>
<ul>
<li><strong>pytest</strong>: Powerful testing framework with fixtures and parametrization</li>
<li><strong>Type Hints</strong>: Better IDE support and documentation</li>
<li><strong>Dataclasses</strong>: Clean, concise class definitions</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
<li><strong>Fixtures</strong>: Reusable test data and setup</li>
<li><strong>Parametrized Tests</strong>: Test multiple scenarios efficiently</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Testing Implementation Details</strong></h4>
<ul>
<li>❌ Tests that verify internal implementation</li>
<li>❌ Tests that break when implementation changes</li>
<li>❌ Tests that don&#39;t verify business behavior</li>
</ul>
<h4><strong>Over-Mocking</strong></h4>
<ul>
<li>❌ Mocking everything instead of testing real behavior</li>
<li>❌ Tests that don&#39;t verify actual business logic</li>
<li>❌ Tests that are hard to maintain</li>
</ul>
<h4><strong>Incomplete Test Coverage</strong></h4>
<ul>
<li>❌ Tests that don&#39;t cover all business rules</li>
<li>❌ Tests that miss edge cases</li>
<li>❌ Tests that don&#39;t verify error conditions</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity being tested</li>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Value object used in tests</li>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Entity used in tests</li>
<li><a href="../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable">Pure Domain Logic is Easily Testable</a> - Testing concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 06-customer-module.md</li>
<li>Next: 08-money-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable">Pure Domain Logic is Easily Testable</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/07-order-tests","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"07-order-tests"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"07-order-tests\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/07-order-tests","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
