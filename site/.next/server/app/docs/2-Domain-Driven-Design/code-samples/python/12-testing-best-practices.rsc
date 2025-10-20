1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"12-testing-best-practices\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T9267,<h1>Testing Best Practices - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing">Best Practices for DDD Unit Testing</a></p>
<p><strong>Navigation</strong>: <a href="./11-testing-anti-patterns.md">← Previous: Testing Anti-Patterns</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - Testing Best Practices
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
    &quot;&quot;&quot;Examples of testing best practices for Order entity&quot;&quot;&quot;
    
    def test_order_creation_with_valid_data(self):
        &quot;&quot;&quot;✅ GOOD: Test with descriptive name and clear intent&quot;&quot;&quot;
        # Arrange
        order_id = OrderId.generate()
        customer_id = CustomerId(&quot;customer-123&quot;)
        
        # Act
        order = Order(order_id, customer_id)
        
        # Assert
        assert order.id == order_id
        assert order.customer_id == customer_id
        assert order.status == OrderStatus.DRAFT
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is False
    
    def test_order_add_item_when_draft_succeeds(self):
        &quot;&quot;&quot;✅ GOOD: Test specific scenario with clear conditions&quot;&quot;&quot;
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
        assert item.quantity == quantity
        assert item.unit_price == unit_price
    
    def test_order_add_item_when_confirmed_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test error condition with clear scenario&quot;&quot;&quot;
        # Arrange
        order = self._create_confirmed_order()
        product_id = ProductId(&quot;product-2&quot;)
        quantity = 1
        unit_price = Money(10.00, &quot;USD&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot modify confirmed order&quot;):
            order.add_item(product_id, quantity, unit_price)
    
    def test_order_add_item_with_zero_quantity_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test boundary condition&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        product_id = ProductId(&quot;product-1&quot;)
        quantity = 0
        unit_price = Money(15.99, &quot;USD&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Quantity must be positive&quot;):
            order.add_item(product_id, quantity, unit_price)
    
    def test_order_add_existing_item_updates_quantity(self):
        &quot;&quot;&quot;✅ GOOD: Test business rule behavior&quot;&quot;&quot;
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
    
    def test_order_confirm_with_valid_items_succeeds(self):
        &quot;&quot;&quot;✅ GOOD: Test successful business operation&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        
        # Act
        order.confirm()
        
        # Assert
        assert order.status == OrderStatus.CONFIRMED
        assert order.can_be_modified() is False
        assert order.can_be_shipped() is True
    
    def test_order_confirm_with_empty_order_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test business rule validation&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot confirm empty order&quot;):
            order.confirm()
    
    def test_order_confirm_with_low_amount_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test business rule for minimum order amount&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 1, Money(5.00, &quot;USD&quot;))  # Below $10 minimum
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Order amount must be at least&quot;):
            order.confirm()
    
    def test_order_state_transitions_follow_business_rules(self):
        &quot;&quot;&quot;✅ GOOD: Test complete state transition flow&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 1, Money(15.99, &quot;USD&quot;))
        
        # Act &amp; Assert - Draft state
        assert order.can_be_modified() is True
        assert order.can_be_confirmed() is True
        assert order.can_be_shipped() is False
        
        # Act &amp; Assert - Confirmed state
        order.confirm()
        assert order.can_be_modified() is False
        assert order.can_be_confirmed() is False
        assert order.can_be_shipped() is True
        assert order.can_be_cancelled() is True
        
        # Act &amp; Assert - Shipped state
        order.ship()
        assert order.can_be_modified() is False
        assert order.can_be_confirmed() is False
        assert order.can_be_shipped() is False
        assert order.can_be_delivered() is True
        assert order.can_be_cancelled() is False
    
    def test_order_total_calculation_with_multiple_items(self):
        &quot;&quot;&quot;✅ GOOD: Test complex business calculation&quot;&quot;&quot;
        # Arrange
        order = self._create_draft_order()
        
        # Act
        order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
        order.add_item(ProductId(&quot;product-2&quot;), 1, Money(25.50, &quot;USD&quot;))
        order.add_item(ProductId(&quot;product-3&quot;), 3, Money(10.00, &quot;USD&quot;))
        
        # Assert
        expected_total = (2 * 15.99) + (1 * 25.50) + (3 * 10.00)
        assert order.total_amount.amount == expected_total
        assert order.total_amount.currency == &quot;USD&quot;
    
    def test_order_domain_events_are_raised(self):
        &quot;&quot;&quot;✅ GOOD: Test domain events for significant business events&quot;&quot;&quot;
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
    
    # Helper methods for test setup
    def _create_draft_order(self) -&gt; Order:
        &quot;&quot;&quot;Helper method to create draft order for testing&quot;&quot;&quot;
        order_id = OrderId.generate()
        customer_id = CustomerId(&quot;customer-123&quot;)
        return Order(order_id, customer_id)
    
    def _create_confirmed_order(self) -&gt; Order:
        &quot;&quot;&quot;Helper method to create confirmed order for testing&quot;&quot;&quot;
        order = self._create_draft_order()
        order.add_item(ProductId(&quot;product-1&quot;), 1, Money(15.99, &quot;USD&quot;))
        order.confirm()
        return order

class TestMoneyBestPractices:
    &quot;&quot;&quot;Examples of testing best practices for Money value object&quot;&quot;&quot;
    
    def test_money_creation_with_valid_amount_succeeds(self):
        &quot;&quot;&quot;✅ GOOD: Test value object creation with valid data&quot;&quot;&quot;
        # Arrange
        amount = 100.50
        currency = &quot;USD&quot;
        
        # Act
        money = Money(amount, currency)
        
        # Assert
        assert money.amount == amount
        assert money.currency == currency
    
    def test_money_creation_with_negative_amount_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test value object validation&quot;&quot;&quot;
        # Arrange
        amount = -10.0
        currency = &quot;USD&quot;
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Amount cannot be negative&quot;):
            Money(amount, currency)
    
    def test_money_creation_with_empty_currency_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test value object validation for currency&quot;&quot;&quot;
        # Arrange
        amount = 100.0
        currency = &quot;&quot;
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Currency cannot be empty&quot;):
            Money(amount, currency)
    
    def test_money_addition_with_same_currency_succeeds(self):
        &quot;&quot;&quot;✅ GOOD: Test value object business operations&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(25.75, &quot;USD&quot;)
        
        # Act
        result = money1.add(money2)
        
        # Assert
        assert result.amount == 126.25
        assert result.currency == &quot;USD&quot;
        assert result is not money1  # Should return new instance
        assert result is not money2  # Should return new instance
    
    def test_money_addition_with_different_currencies_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test business rule validation&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(25.75, &quot;EUR&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot add different currencies&quot;):
            money1.add(money2)
    
    def test_money_multiplication_with_positive_factor_succeeds(self):
        &quot;&quot;&quot;✅ GOOD: Test value object mathematical operations&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        factor = 2.5
        
        # Act
        result = money.multiply(factor)
        
        # Assert
        assert result.amount == 251.25
        assert result.currency == &quot;USD&quot;
        assert result is not money  # Should return new instance
    
    def test_money_multiplication_with_negative_factor_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test business rule validation&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        factor = -1.5
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Factor cannot be negative&quot;):
            money.multiply(factor)
    
    def test_money_equality_with_same_values_returns_true(self):
        &quot;&quot;&quot;✅ GOOD: Test value object equality&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.50, &quot;USD&quot;)
        
        # Act &amp; Assert
        assert money1 == money2
        assert money1.equals(money2) is True
    
    def test_money_equality_with_different_values_returns_false(self):
        &quot;&quot;&quot;✅ GOOD: Test value object inequality&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.51, &quot;USD&quot;)
        
        # Act &amp; Assert
        assert money1 != money2
        assert money1.equals(money2) is False
    
    def test_money_equality_with_different_currencies_returns_false(self):
        &quot;&quot;&quot;✅ GOOD: Test value object inequality for different currencies&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.50, &quot;EUR&quot;)
        
        # Act &amp; Assert
        assert money1 != money2
        assert money1.equals(money2) is False
    
    def test_money_hash_consistency(self):
        &quot;&quot;&quot;✅ GOOD: Test value object hash consistency&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.50, &quot;USD&quot;)
        
        # Act &amp; Assert
        assert hash(money1) == hash(money2)
    
    def test_money_immutability(self):
        &quot;&quot;&quot;✅ GOOD: Test value object immutability&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        
        # Act &amp; Assert
        # Money should be immutable (frozen dataclass)
        with pytest.raises(AttributeError):
            money.amount = 200.0
        
        with pytest.raises(AttributeError):
            money.currency = &quot;EUR&quot;
    
    def test_money_factory_methods(self):
        &quot;&quot;&quot;✅ GOOD: Test value object factory methods&quot;&quot;&quot;
        # Test zero factory
        zero_usd = Money.zero(&quot;USD&quot;)
        assert zero_usd.amount == 0.0
        assert zero_usd.currency == &quot;USD&quot;
        
        # Test from_amount factory
        amount_usd = Money.from_amount(100.50, &quot;USD&quot;)
        assert amount_usd.amount == 100.50
        assert amount_usd.currency == &quot;USD&quot;

class TestPricingServiceBestPractices:
    &quot;&quot;&quot;Examples of testing best practices for PricingService domain service&quot;&quot;&quot;
    
    def test_calculate_order_total_with_active_customer_succeeds(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service with valid inputs&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_active_customer()
        address = self._create_address()
        
        # Act
        total = pricing_service.calculate_order_total(order, customer, address)
        
        # Assert
        assert isinstance(total, Money)
        assert total.currency == &quot;USD&quot;
        assert total.amount &gt; 0
    
    def test_calculate_order_total_with_inactive_customer_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service error condition&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_inactive_customer()
        address = self._create_address()
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot calculate pricing for inactive customer&quot;):
            pricing_service.calculate_order_total(order, customer, address)
    
    def test_calculate_discount_amount_for_vip_customer(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service business logic&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_vip_customer()
        
        # Act
        discount = pricing_service.calculate_discount_amount(order, customer)
        
        # Assert
        assert isinstance(discount, Money)
        assert discount.currency == &quot;USD&quot;
        assert discount.amount &gt; 0
    
    def test_calculate_discount_amount_for_basic_customer(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service with no discount scenario&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_basic_customer()
        
        # Act
        discount = pricing_service.calculate_discount_amount(order, customer)
        
        # Assert
        assert isinstance(discount, Money)
        assert discount.currency == &quot;USD&quot;
        assert discount.amount == 0  # Basic customers get no discount
    
    def test_get_available_discounts_returns_list(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service return value&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_vip_customer()
        
        # Act
        discounts = pricing_service.get_available_discounts(order, customer)
        
        # Assert
        assert isinstance(discounts, list)
        assert len(discounts) &gt; 0
        
        for discount in discounts:
            assert hasattr(discount, &#39;id&#39;)
            assert hasattr(discount, &#39;name&#39;)
            assert hasattr(discount, &#39;type&#39;)
            assert hasattr(discount, &#39;value&#39;)
            assert hasattr(discount, &#39;description&#39;)
    
    def test_apply_customer_discount_vip_rate(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service internal business logic&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        amount = Money(100.00, &quot;USD&quot;)
        customer = self._create_vip_customer()
        
        # Act
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        
        # Assert
        assert discounted_amount.amount == 85.00  # 15% discount
        assert discounted_amount.currency == &quot;USD&quot;
    
    def test_apply_bulk_discount_over_1000_threshold(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service threshold logic&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        amount = Money(1200.00, &quot;USD&quot;)
        order = self._create_order_with_amount(1200.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 1080.00  # 10% discount
        assert discounted_amount.currency == &quot;USD&quot;
    
    def test_apply_shipping_discount_over_50_free_shipping(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service free shipping logic&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        shipping = Money(5.99, &quot;USD&quot;)
        order_amount = Money(75.00, &quot;USD&quot;)
        
        # Act
        discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount)
        
        # Assert
        assert discounted_shipping.amount == 0.00  # Free shipping
        assert discounted_shipping.currency == &quot;USD&quot;
    
    # Helper methods for test setup
    def _create_order_with_items(self):
        &quot;&quot;&quot;Helper method to create order with items for testing&quot;&quot;&quot;
        order = MockOrder()
        order.total_amount = Money(100.00, &quot;USD&quot;)
        order.items = [
            MockOrderItem(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;)),
            MockOrderItem(ProductId(&quot;product-2&quot;), 1, Money(25.50, &quot;USD&quot;))
        ]
        return order
    
    def _create_order_with_amount(self, amount):
        &quot;&quot;&quot;Helper method to create order with specific amount for testing&quot;&quot;&quot;
        order = MockOrder()
        order.total_amount = Money(amount, &quot;USD&quot;)
        order.items = []
        return order
    
    def _create_active_customer(self):
        &quot;&quot;&quot;Helper method to create active customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;Standard&quot;
        customer.is_active.return_value = True
        return customer
    
    def _create_inactive_customer(self):
        &quot;&quot;&quot;Helper method to create inactive customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;Standard&quot;
        customer.is_active.return_value = False
        return customer
    
    def _create_vip_customer(self):
        &quot;&quot;&quot;Helper method to create VIP customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;VIP&quot;
        customer.is_active.return_value = True
        return customer
    
    def _create_basic_customer(self):
        &quot;&quot;&quot;Helper method to create basic customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;Basic&quot;
        customer.is_active.return_value = True
        return customer
    
    def _create_address(self):
        &quot;&quot;&quot;Helper method to create address for testing&quot;&quot;&quot;
        address = MockAddress()
        address.country = &quot;US&quot;
        address.state = &quot;CA&quot;
        return address

class TestCustomerServiceBestPractices:
    &quot;&quot;&quot;Examples of testing best practices for CustomerService domain service&quot;&quot;&quot;
    
    def test_register_customer_with_valid_data_succeeds(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service with valid inputs&quot;&quot;&quot;
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = &quot;John Doe&quot;
        email = &quot;john.doe@example.com&quot;
        
        # Mock repository to return None (customer doesn&#39;t exist)
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
        &quot;&quot;&quot;✅ GOOD: Test domain service validation&quot;&quot;&quot;
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = &quot;&quot;
        email = &quot;john.doe@example.com&quot;
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Name cannot be empty&quot;):
            customer_service.register_customer(name, email)
        
        # Verify repository was not called
        mock_repository.find_by_email.assert_not_called()
        mock_repository.save.assert_not_called()
    
    def test_register_customer_with_existing_email_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service business rule validation&quot;&quot;&quot;
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = &quot;John Doe&quot;
        email = &quot;john.doe@example.com&quot;
        
        # Mock repository to return existing customer
        existing_customer = Mock(spec=Customer)
        mock_repository.find_by_email.return_value = existing_customer
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Customer with this email already exists&quot;):
            customer_service.register_customer(name, email)
        
        # Verify repository was called but save was not
        mock_repository.find_by_email.assert_called_once_with(email)
        mock_repository.save.assert_not_called()
    
    def test_update_customer_email_with_valid_data_succeeds(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service update operation&quot;&quot;&quot;
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = &quot;customer-123&quot;
        new_email = &quot;john.doe.new@example.com&quot;
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Mock repository to return None (new email doesn&#39;t exist)
        mock_repository.find_by_email.return_value = None
        
        # Act
        customer_service.update_customer_email(customer_id, new_email)
        
        # Assert
        # Verify customer&#39;s update_email method was called
        existing_customer.update_email.assert_called_once()
        
        # Verify repository interactions
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.find_by_email.assert_called_once_with(new_email)
        mock_repository.save.assert_called_once_with(existing_customer)
        
        # Verify email service interactions
        mock_email_service.send_email_change_notification.assert_called_once_with(existing_customer)
    
    def test_update_customer_email_with_nonexistent_customer_raises_error(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service error condition&quot;&quot;&quot;
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = &quot;non-existent-customer&quot;
        new_email = &quot;john.doe.new@example.com&quot;
        
        # Mock repository to return None (customer doesn&#39;t exist)
        mock_repository.find_by_id.return_value = None
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Customer not found&quot;):
            customer_service.update_customer_email(customer_id, new_email)
        
        # Verify repository was called but save was not
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.save.assert_not_called()
    
    def test_suspend_customer_with_valid_data_succeeds(self):
        &quot;&quot;&quot;✅ GOOD: Test domain service suspension operation&quot;&quot;&quot;
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = &quot;customer-123&quot;
        reason = &quot;Violation of terms of service&quot;
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Act
        customer_service.suspend_customer(customer_id, reason)
        
        # Assert
        # Verify customer&#39;s suspend method was called
        existing_customer.suspend.assert_called_once()
        
        # Verify repository interactions
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.save.assert_called_once_with(existing_customer)
        
        # Verify email service interactions
        mock_email_service.send_suspension_notification.assert_called_once_with(existing_customer, reason)
    
    def test_customer_service_dependency_injection(self):
        &quot;&quot;&quot;✅ GOOD: Test dependency injection setup&quot;&quot;&quot;
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
    &quot;&quot;&quot;Mock order for testing&quot;&quot;&quot;
    def __init__(self):
        self.total_amount = Money(100.00, &quot;USD&quot;)
        self.items = []

class MockOrderItem:
    &quot;&quot;&quot;Mock order item for testing&quot;&quot;&quot;
    def __init__(self, product_id, quantity, unit_price):
        self.product_id = product_id
        self.quantity = quantity
        self.unit_price = unit_price

class MockCustomer:
    &quot;&quot;&quot;Mock customer for testing&quot;&quot;&quot;
    def __init__(self):
        self.customer_type = &quot;Standard&quot;
        self.is_active = Mock(return_value=True)

class MockAddress:
    &quot;&quot;&quot;Mock address for testing&quot;&quot;&quot;
    def __init__(self):
        self.country = &quot;US&quot;
        self.state = &quot;CA&quot;
        self.province = None

# Test fixtures
@pytest.fixture
def sample_order():
    &quot;&quot;&quot;Fixture for creating sample order&quot;&quot;&quot;
    order_id = OrderId.generate()
    customer_id = CustomerId(&quot;customer-123&quot;)
    order = Order(order_id, customer_id)
    order.add_item(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;))
    return order

@pytest.fixture
def sample_money():
    &quot;&quot;&quot;Fixture for creating sample money&quot;&quot;&quot;
    return Money(100.50, &quot;USD&quot;)

@pytest.fixture
def sample_customer():
    &quot;&quot;&quot;Fixture for creating sample customer&quot;&quot;&quot;
    customer_id = CustomerId.generate()
    email = EmailAddress(&quot;john.doe@example.com&quot;)
    customer = Customer(customer_id, &quot;John Doe&quot;, email)
    customer.activate()
    return customer

# Parametrized tests
@pytest.mark.parametrize(&quot;customer_type,expected_discount_rate&quot;, [
    (&quot;VIP&quot;, 0.15),
    (&quot;Premium&quot;, 0.10),
    (&quot;Standard&quot;, 0.05),
    (&quot;Basic&quot;, 0.0),
    (&quot;Unknown&quot;, 0.0)
])
def test_customer_discount_rates(customer_type, expected_discount_rate):
    &quot;&quot;&quot;✅ GOOD: Parametrized test for customer discount rates&quot;&quot;&quot;
    # Arrange
    pricing_service = PricingService()
    
    # Act
    discount_rate = pricing_service._get_customer_discount_rate(customer_type)
    
    # Assert
    assert discount_rate == expected_discount_rate

@pytest.mark.parametrize(&quot;order_amount,expected_discount_rate&quot;, [
    (1200.0, 0.10),
    (600.0, 0.05),
    (150.0, 0.02),
    (50.0, 0.0)
])
def test_bulk_discount_rates(order_amount, expected_discount_rate):
    &quot;&quot;&quot;✅ GOOD: Parametrized test for bulk discount rates&quot;&quot;&quot;
    # Arrange
    pricing_service = PricingService()
    order = MockOrder()
    order.total_amount = Money(order_amount, &quot;USD&quot;)
    
    # Act
    discount = pricing_service._get_bulk_discount(order)
    
    # Assert
    if expected_discount_rate &gt; 0:
        assert discount is not None
        assert discount.value == expected_discount_rate
    else:
        assert discount is None

@pytest.mark.parametrize(&quot;amount1,amount2,expected&quot;, [
    (100.0, 50.0, 150.0),
    (0.0, 100.0, 100.0),
    (25.50, 75.25, 100.75),
    (999.99, 0.01, 1000.0)
])
def test_money_addition(amount1, amount2, expected):
    &quot;&quot;&quot;✅ GOOD: Parametrized test for money addition&quot;&quot;&quot;
    # Arrange
    money1 = Money(amount1, &quot;USD&quot;)
    money2 = Money(amount2, &quot;USD&quot;)
    
    # Act
    result = money1.add(money2)
    
    # Assert
    assert result.amount == expected
    assert result.currency == &quot;USD&quot;
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Best Practices for DDD Unit Testing</h3>
<h4>1. <strong>Descriptive Test Names</strong></h4>
<ul>
<li>✅ Test names clearly describe what is being tested</li>
<li>✅ Test names include the scenario and expected outcome</li>
<li>✅ Test names are readable and self-documenting</li>
</ul>
<h4>2. <strong>Arrange-Act-Assert Pattern</strong></h4>
<ul>
<li>✅ Clear separation of test setup, execution, and verification</li>
<li>✅ Test structure is consistent and easy to follow</li>
<li>✅ Test intent is clear from the structure</li>
</ul>
<h4>3. <strong>Test Business Behavior</strong></h4>
<ul>
<li>✅ Tests focus on business rules and domain logic</li>
<li>✅ Tests verify behavior that matters to the business</li>
<li>✅ Tests are independent of implementation details</li>
</ul>
<h4>4. <strong>Comprehensive Test Coverage</strong></h4>
<ul>
<li>✅ Tests cover all public methods and properties</li>
<li>✅ Tests cover edge cases and error conditions</li>
<li>✅ Tests cover business rule validation</li>
</ul>
<h3>Testing Best Practices</h3>
<h4><strong>Test Business Rules</strong></h4>
<ul>
<li>✅ Customer discount rates are tested for all customer types</li>
<li>✅ Bulk discount thresholds are verified</li>
<li>✅ Order state transitions follow business rules</li>
</ul>
<h4><strong>Test Error Conditions</strong></h4>
<ul>
<li>✅ Invalid inputs are properly rejected</li>
<li>✅ Business rule violations are handled</li>
<li>✅ Error messages are clear and descriptive</li>
</ul>
<h4><strong>Test Edge Cases</strong></h4>
<ul>
<li>✅ Boundary conditions are tested</li>
<li>✅ Zero and negative values are handled</li>
<li>✅ Empty and null inputs are validated</li>
</ul>
<h4><strong>Use Helper Methods</strong></h4>
<ul>
<li>✅ Test setup is simplified with helper methods</li>
<li>✅ Test data creation is consistent</li>
<li>✅ Test maintenance is easier</li>
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
<h4><strong>Use Appropriate Mocking</strong></h4>
<ul>
<li>✅ Mock external dependencies</li>
<li>✅ Don&#39;t mock domain objects</li>
<li>✅ Focus on testing real business logic</li>
</ul>
<h4><strong>Test Error Conditions</strong></h4>
<ul>
<li>✅ Test business rule violations</li>
<li>✅ Test invalid inputs</li>
<li>✅ Test edge cases and boundary conditions</li>
</ul>
<h4><strong>Use Test Fixtures</strong></h4>
<ul>
<li>✅ Reusable test data and setup</li>
<li>✅ Consistent test environment</li>
<li>✅ Easier test maintenance</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./07-order-tests.md">Order Tests</a> - Proper testing examples</li>
<li><a href="./08-money-tests.md">Money Tests</a> - Value object testing</li>
<li><a href="./09-pricing-service-tests.md">Pricing Service Tests</a> - Domain service testing</li>
<li><a href="./10-customer-service-tests.md">Customer Service Tests</a> - Service testing with mocking</li>
<li><a href="./11-testing-anti-patterns.md">Testing Anti-Patterns</a> - Anti-patterns to avoid</li>
<li><a href="../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing">Best Practices for DDD Unit Testing</a> - Testing concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 11-testing-anti-patterns.md</li>
<li>Next: 13-domain-modeling-best-practices.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing">Best Practices for DDD Unit Testing</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"12-testing-best-practices"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"12-testing-best-practices\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
