1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"11-testing-anti-patterns\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T6334,<h1>Testing Anti-Patterns - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid">Testing Anti-Patterns to Avoid</a></p>
<p><strong>Navigation</strong>: <a href="./10-customer-service-tests.md">← Previous: Customer Service Tests</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - Testing Anti-Patterns to Avoid
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
    &quot;&quot;&quot;Examples of testing anti-patterns to avoid&quot;&quot;&quot;
    
    # ❌ BAD: Testing Infrastructure Concerns
    def test_order_save_to_database(self):
        &quot;&quot;&quot;❌ BAD: Testing infrastructure concerns instead of domain logic&quot;&quot;&quot;
        # This test is testing database operations, not domain logic
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        
        # ❌ Testing database connection and SQL operations
        with patch(&#39;database.connection&#39;) as mock_conn:
            mock_cursor = mock_conn.cursor.return_value
            order.save_to_database()
            
            # ❌ Verifying SQL queries instead of business behavior
            mock_cursor.execute.assert_called_with(
                &quot;INSERT INTO orders (id, customer_id, status) VALUES (?, ?, ?)&quot;,
                (order.id.value, order.customer_id.value, &quot;Draft&quot;)
            )
    
    def test_order_send_email_notification(self):
        &quot;&quot;&quot;❌ BAD: Testing email infrastructure instead of domain logic&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        order.confirm()
        
        # ❌ Testing email sending infrastructure
        with patch(&#39;smtplib.SMTP&#39;) as mock_smtp:
            order.send_confirmation_email()
            
            # ❌ Verifying SMTP calls instead of business behavior
            mock_smtp.assert_called_with(&#39;smtp.gmail.com&#39;, 587)
            mock_smtp.return_value.starttls.assert_called_once()
            mock_smtp.return_value.login.assert_called_with(&#39;user&#39;, &#39;password&#39;)
    
    def test_order_log_to_file(self):
        &quot;&quot;&quot;❌ BAD: Testing file system operations instead of domain logic&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        
        # ❌ Testing file system operations
        with tempfile.NamedTemporaryFile(mode=&#39;w&#39;, delete=False) as temp_file:
            temp_filename = temp_file.name
        
        try:
            order.log_to_file(temp_filename)
            
            # ❌ Verifying file contents instead of business behavior
            with open(temp_filename, &#39;r&#39;) as f:
                content = f.read()
                assert &quot;Order created&quot; in content
                assert order.id.value in content
        finally:
            os.unlink(temp_filename)
    
    # ❌ BAD: Testing Implementation Details
    def test_order_internal_state(self):
        &quot;&quot;&quot;❌ BAD: Testing internal implementation details&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
        # ❌ Testing private/internal attributes
        assert hasattr(order, &#39;_items&#39;)
        assert hasattr(order, &#39;_status&#39;)
        assert order._status == OrderStatus.DRAFT
        
        # ❌ Testing internal method behavior
        order._find_item_index(ProductId(&quot;product-1&quot;)) == -1
    
    def test_order_private_methods(self):
        &quot;&quot;&quot;❌ BAD: Testing private methods directly&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
        # ❌ Testing private methods directly
        result = order._find_item_index(ProductId(&quot;product-1&quot;))
        assert result == -1
        
        # ❌ Testing internal calculations
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        result = order._find_item_index(ProductId(&quot;product-1&quot;))
        assert result == 0
    
    def test_order_internal_data_structures(self):
        &quot;&quot;&quot;❌ BAD: Testing internal data structures&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
        # ❌ Testing internal data structure types
        assert isinstance(order._items, list)
        assert len(order._items) == 0
        
        # ❌ Testing internal data structure modifications
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        assert len(order._items) == 1
        assert isinstance(order._items[0], OrderItem)
    
    # ❌ BAD: Over-Mocking
    def test_order_with_excessive_mocking(self):
        &quot;&quot;&quot;❌ BAD: Over-mocking everything instead of testing real behavior&quot;&quot;&quot;
        # ❌ Mocking domain objects instead of testing real behavior
        mock_order = Mock(spec=Order)
        mock_order.id = Mock(spec=OrderId)
        mock_order.customer_id = Mock(spec=CustomerId)
        mock_order.status = OrderStatus.DRAFT
        mock_order.can_be_modified.return_value = True
        mock_order.add_item.return_value = None
        
        # ❌ Testing mocked behavior instead of real domain logic
        assert mock_order.can_be_modified() is True
        mock_order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        mock_order.add_item.assert_called_once()
    
    def test_pricing_service_with_over_mocking(self):
        &quot;&quot;&quot;❌ BAD: Over-mocking domain service dependencies&quot;&quot;&quot;
        # ❌ Mocking all dependencies instead of testing real behavior
        mock_tax_calculator = Mock(spec=TaxCalculator)
        mock_shipping_calculator = Mock(spec=ShippingCalculator)
        mock_discount_repository = Mock(spec=DiscountRuleRepository)
        
        # ❌ Mocking all method calls
        mock_tax_calculator.calculate_tax.return_value = Money(8.00, &quot;USD&quot;)
        mock_shipping_calculator.calculate_shipping.return_value = Money(5.99, &quot;USD&quot;)
        mock_discount_repository.get_customer_discount_rate.return_value = 0.10
        
        # ❌ Testing mocked behavior instead of real business logic
        pricing_service = PricingService()
        pricing_service._tax_calculator = mock_tax_calculator
        pricing_service._shipping_calculator = mock_shipping_calculator
        pricing_service._discount_rules = mock_discount_repository
        
        # ❌ This test doesn&#39;t verify actual business logic
        result = pricing_service._apply_customer_discount(Money(100.00, &quot;USD&quot;), Mock())
        assert result.amount == 90.00
    
    def test_customer_service_with_over_mocking(self):
        &quot;&quot;&quot;❌ BAD: Over-mocking customer service dependencies&quot;&quot;&quot;
        # ❌ Mocking all domain objects
        mock_customer = Mock(spec=Customer)
        mock_customer.id = Mock(spec=CustomerId)
        mock_customer.name = &quot;John Doe&quot;
        mock_customer.email = Mock(spec=EmailAddress)
        mock_customer.is_active.return_value = True
        
        mock_repository = Mock(spec=CustomerRepository)
        mock_repository.find_by_email.return_value = None
        mock_repository.save.return_value = None
        
        mock_email_service = Mock(spec=EmailService)
        mock_email_service.send_welcome_email.return_value = None
        
        # ❌ Testing mocked behavior instead of real domain logic
        customer_service = CustomerService(mock_repository, mock_email_service)
        customer = customer_service.register_customer(&quot;John Doe&quot;, &quot;john.doe@example.com&quot;)
        
        # ❌ This test doesn&#39;t verify actual business logic
        assert customer is not None
        mock_repository.save.assert_called_once()
    
    # ❌ BAD: Testing Implementation Details
    def test_order_implementation_details(self):
        &quot;&quot;&quot;❌ BAD: Testing implementation details instead of behavior&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
        # ❌ Testing specific implementation details
        assert order._items == []  # Testing internal list
        assert order._status == OrderStatus.DRAFT  # Testing internal state
        
        # ❌ Testing specific method implementations
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        assert len(order._items) == 1  # Testing internal list length
        assert order._items[0].product_id == ProductId(&quot;product-1&quot;)  # Testing internal structure
    
    def test_money_implementation_details(self):
        &quot;&quot;&quot;❌ BAD: Testing implementation details of value objects&quot;&quot;&quot;
        money = Money(100.50, &quot;USD&quot;)
        
        # ❌ Testing internal attributes instead of behavior
        assert money.amount == 100.50
        assert money.currency == &quot;USD&quot;
        
        # ❌ Testing specific implementation details
        result = money.add(Money(25.25, &quot;USD&quot;))
        assert result.amount == 125.75  # Testing specific calculation
    
    # ❌ BAD: Brittle Tests
    def test_order_string_representation_brittle(self):
        &quot;&quot;&quot;❌ BAD: Brittle test that breaks when implementation changes&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        
        # ❌ Testing exact string format - brittle
        expected_str = f&quot;Order(id={order.id.value}, customer_id={order.customer_id.value}, status=Draft, items=1, total=31.98)&quot;
        assert str(order) == expected_str
    
    def test_order_repr_representation_brittle(self):
        &quot;&quot;&quot;❌ BAD: Brittle test for repr representation&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
        # ❌ Testing exact repr format - brittle
        expected_repr = f&quot;Order(id={order.id.value}, customer_id={order.customer_id.value}, status=Draft, items=0, total=0.00)&quot;
        assert repr(order) == expected_repr
    
    # ❌ BAD: Testing Multiple Concerns
    def test_order_multiple_concerns(self):
        &quot;&quot;&quot;❌ BAD: Testing multiple concerns in one test&quot;&quot;&quot;
        # ❌ Testing order creation, item addition, and confirmation in one test
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
        # Testing order creation
        assert order.status == OrderStatus.DRAFT
        assert order.item_count == 0
        
        # Testing item addition
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        assert order.item_count == 1
        assert order.total_amount.amount == 31.98
        
        # Testing order confirmation
        order.confirm()
        assert order.status == OrderStatus.CONFIRMED
        assert order.can_be_shipped() is True
        
        # ❌ This test is doing too much and is hard to maintain
    
    def test_customer_multiple_concerns(self):
        &quot;&quot;&quot;❌ BAD: Testing multiple customer concerns in one test&quot;&quot;&quot;
        # ❌ Testing customer creation, activation, and email update in one test
        customer_id = CustomerId.generate()
        email = EmailAddress(&quot;john.doe@example.com&quot;)
        customer = Customer(customer_id, &quot;John Doe&quot;, email)
        
        # Testing customer creation
        assert customer.status == CustomerStatus.PENDING
        assert customer.is_active() is False
        
        # Testing customer activation
        customer.activate()
        assert customer.status == CustomerStatus.ACTIVE
        assert customer.is_active() is True
        
        # Testing email update
        new_email = EmailAddress(&quot;john.doe.new@example.com&quot;)
        customer.update_email(new_email)
        assert customer.email == new_email
        
        # ❌ This test is doing too much and is hard to maintain
    
    # ❌ BAD: Testing Error Messages
    def test_order_error_messages(self):
        &quot;&quot;&quot;❌ BAD: Testing exact error messages instead of behavior&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        order.confirm()
        
        # ❌ Testing exact error message text - brittle
        with pytest.raises(ValueError, match=&quot;Cannot modify confirmed order&quot;):
            order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        
        # ❌ Testing specific error message format
        with pytest.raises(ValueError) as exc_info:
            order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        assert str(exc_info.value) == &quot;Cannot modify confirmed order&quot;
    
    def test_money_error_messages(self):
        &quot;&quot;&quot;❌ BAD: Testing exact error messages for value objects&quot;&quot;&quot;
        # ❌ Testing exact error message text - brittle
        with pytest.raises(ValueError, match=&quot;Amount cannot be negative&quot;):
            Money(-10.0, &quot;USD&quot;)
        
        # ❌ Testing specific error message format
        with pytest.raises(ValueError) as exc_info:
            Money(-10.0, &quot;USD&quot;)
        assert str(exc_info.value) == &quot;Amount cannot be negative&quot;
    
    # ❌ BAD: Testing Framework Details
    def test_order_with_framework_details(self):
        &quot;&quot;&quot;❌ BAD: Testing framework details instead of domain logic&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
        # ❌ Testing framework-specific details
        assert hasattr(order, &#39;__class__&#39;)
        assert order.__class__.__name__ == &#39;Order&#39;
        assert hasattr(order, &#39;__dict__&#39;)
        
        # ❌ Testing framework methods
        assert hasattr(order, &#39;__str__&#39;)
        assert hasattr(order, &#39;__repr__&#39;)
        assert hasattr(order, &#39;__eq__&#39;)
    
    # ❌ BAD: Testing Performance Details
    def test_order_performance_details(self):
        &quot;&quot;&quot;❌ BAD: Testing performance details instead of behavior&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
        # ❌ Testing performance characteristics
        import time
        
        start_time = time.time()
        for i in range(1000):
            order.add_item(ProductId(f&quot;product-{i}&quot;), 1, Money(10.00, &quot;USD&quot;))
        end_time = time.time()
        
        # ❌ Testing specific performance requirements
        assert (end_time - start_time) &lt; 0.1  # Must complete in 100ms
    
    # ❌ BAD: Testing Random Behavior
    def test_order_random_behavior(self):
        &quot;&quot;&quot;❌ BAD: Testing random behavior instead of deterministic behavior&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
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
    &quot;&quot;&quot;Examples of proper testing practices&quot;&quot;&quot;
    
    def test_order_business_behavior(self):
        &quot;&quot;&quot;✅ GOOD: Testing business behavior instead of implementation&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        
        # ✅ Testing business behavior
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is False
        
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        
        assert order.can_be_confirmed() is True
        assert order.total_amount.amount == 31.98
    
    def test_order_state_transitions(self):
        &quot;&quot;&quot;✅ GOOD: Testing state transitions instead of internal state&quot;&quot;&quot;
        order = Order(OrderId.generate(), CustomerId(&quot;customer-123&quot;))
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        
        # ✅ Testing state transitions
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is True
        
        order.confirm()
        
        assert order.can_be_modified() is False
        assert order.can_be_shipped() is True
    
    def test_money_business_operations(self):
        &quot;&quot;&quot;✅ GOOD: Testing business operations instead of implementation&quot;&quot;&quot;
        money1 = Money(100.00, &quot;USD&quot;)
        money2 = Money(25.50, &quot;USD&quot;)
        
        # ✅ Testing business operations
        result = money1.add(money2)
        assert result.amount == 125.50
        assert result.currency == &quot;USD&quot;
        
        # ✅ Testing business rules
        with pytest.raises(ValueError):
            money1.add(Money(25.50, &quot;EUR&quot;))  # Different currencies
    
    def test_customer_business_rules(self):
        &quot;&quot;&quot;✅ GOOD: Testing business rules instead of implementation&quot;&quot;&quot;
        customer = Customer(CustomerId.generate(), &quot;John Doe&quot;, EmailAddress(&quot;john.doe@example.com&quot;))
        
        # ✅ Testing business rules
        assert customer.is_active() is False
        assert customer.can_place_orders() is False
        
        customer.activate()
        
        assert customer.is_active() is True
        assert customer.can_place_orders() is True
    
    def test_pricing_service_business_logic(self):
        &quot;&quot;&quot;✅ GOOD: Testing business logic instead of implementation&quot;&quot;&quot;
        pricing_service = PricingService()
        
        # ✅ Testing business logic
        amount = Money(100.00, &quot;USD&quot;)
        customer = Mock()
        customer.customer_type = &quot;VIP&quot;
        
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        assert discounted_amount.amount == 85.00  # 15% discount for VIP
    
    def test_customer_service_business_behavior(self):
        &quot;&quot;&quot;✅ GOOD: Testing business behavior instead of implementation&quot;&quot;&quot;
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        # ✅ Testing business behavior
        mock_repository.find_by_email.return_value = None
        
        customer = customer_service.register_customer(&quot;John Doe&quot;, &quot;john.doe@example.com&quot;)
        
        assert customer.name == &quot;John Doe&quot;
        assert customer.email.value == &quot;john.doe@example.com&quot;
        assert customer.is_active() is True
        
        # ✅ Testing business interactions
        mock_repository.save.assert_called_once_with(customer)
        mock_email_service.send_welcome_email.assert_called_once_with(customer)
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Testing Anti-Patterns to Avoid</h3>
<h4>1. <strong>Testing Infrastructure Concerns</strong></h4>
<ul>
<li>❌ Testing database operations instead of domain logic</li>
<li>❌ Testing email sending infrastructure instead of business behavior</li>
<li>❌ Testing file system operations instead of domain logic</li>
</ul>
<h4>2. <strong>Testing Implementation Details</strong></h4>
<ul>
<li>❌ Testing private methods and attributes</li>
<li>❌ Testing internal data structures</li>
<li>❌ Testing specific implementation details</li>
</ul>
<h4>3. <strong>Over-Mocking</strong></h4>
<ul>
<li>❌ Mocking domain objects instead of testing real behavior</li>
<li>❌ Mocking all dependencies instead of testing business logic</li>
<li>❌ Testing mocked behavior instead of actual domain logic</li>
</ul>
<h4>4. <strong>Brittle Tests</strong></h4>
<ul>
<li>❌ Testing exact string formats</li>
<li>❌ Testing specific error message text</li>
<li>❌ Testing implementation-specific details</li>
</ul>
<h3>Common Anti-Patterns</h3>
<h4><strong>Testing Infrastructure Instead of Domain Logic</strong></h4>
<ul>
<li>❌ Database operations, email sending, file operations</li>
<li>❌ Framework-specific details</li>
<li>❌ Performance characteristics</li>
</ul>
<h4><strong>Testing Implementation Details</strong></h4>
<ul>
<li>❌ Private methods and attributes</li>
<li>❌ Internal data structures</li>
<li>❌ Specific implementation details</li>
</ul>
<h4><strong>Over-Mocking</strong></h4>
<ul>
<li>❌ Mocking domain objects</li>
<li>❌ Mocking all dependencies</li>
<li>❌ Testing mocked behavior</li>
</ul>
<h4><strong>Brittle Tests</strong></h4>
<ul>
<li>❌ Exact string formats</li>
<li>❌ Specific error messages</li>
<li>❌ Implementation-specific details</li>
</ul>
<h3>Proper Testing Practices</h3>
<h4><strong>Test Business Behavior</strong></h4>
<ul>
<li>✅ Test what the object does, not how it does it</li>
<li>✅ Test business rules and state transitions</li>
<li>✅ Test business operations and interactions</li>
</ul>
<h4><strong>Test Domain Logic</strong></h4>
<ul>
<li>✅ Focus on domain concepts and business rules</li>
<li>✅ Test behavior that matters to the business</li>
<li>✅ Test interactions between domain objects</li>
</ul>
<h4><strong>Test Deterministic Behavior</strong></h4>
<ul>
<li>✅ Test behavior that is predictable and consistent</li>
<li>✅ Avoid testing random or performance characteristics</li>
<li>✅ Focus on business logic, not technical details</li>
</ul>
<h3>Python Testing Benefits</h3>
<ul>
<li><strong>pytest</strong>: Powerful testing framework with clear error messages</li>
<li><strong>unittest.mock</strong>: Built-in mocking capabilities</li>
<li><strong>Type Hints</strong>: Better IDE support and documentation</li>
<li><strong>Fixtures</strong>: Reusable test data and setup</li>
<li><strong>Parametrized Tests</strong>: Test multiple scenarios efficiently</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
</ul>
<h3>Best Practices for DDD Testing</h3>
<h4><strong>Test Domain Behavior</strong></h4>
<ul>
<li>✅ Focus on business rules and domain logic</li>
<li>✅ Test state transitions and business operations</li>
<li>✅ Test interactions between domain objects</li>
</ul>
<h4><strong>Avoid Infrastructure Testing</strong></h4>
<ul>
<li>❌ Don&#39;t test database operations</li>
<li>❌ Don&#39;t test email sending infrastructure</li>
<li>❌ Don&#39;t test file system operations</li>
</ul>
<h4><strong>Use Appropriate Mocking</strong></h4>
<ul>
<li>✅ Mock external dependencies</li>
<li>✅ Don&#39;t mock domain objects</li>
<li>✅ Focus on testing real business logic</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./07-order-tests.md">Order Tests</a> - Proper testing examples</li>
<li><a href="./08-money-tests.md">Money Tests</a> - Value object testing</li>
<li><a href="./09-pricing-service-tests.md">Pricing Service Tests</a> - Domain service testing</li>
<li><a href="./10-customer-service-tests.md">Customer Service Tests</a> - Service testing with mocking</li>
<li><a href="../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid">Testing Anti-Patterns to Avoid</a> - Testing concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 10-customer-service-tests.md</li>
<li>Next: 12-testing-best-practices.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid">Testing Anti-Patterns to Avoid</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"11-testing-anti-patterns"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"11-testing-anti-patterns\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
