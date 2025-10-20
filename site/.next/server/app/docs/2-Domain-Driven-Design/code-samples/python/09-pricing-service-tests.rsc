1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"09-pricing-service-tests\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T88e7,<h1>Pricing Service Tests - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#testable-business-rules">Testable Business Rules</a></p>
<p><strong>Navigation</strong>: <a href="./08-money-tests.md">← Previous: Money Tests</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - Pricing Service Tests (pytest) - Domain Service Testing
# File: 2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests.py

import pytest
from unittest.mock import Mock, patch, MagicMock
from datetime import datetime

# Import the domain objects
from pricing_service import PricingService, TaxCalculator, ShippingCalculator
from order_entity import Order, OrderId, CustomerId, ProductId, Money, OrderItem
from customer_entity import Customer, CustomerStatus, CustomerId as CustomerIdType

class TestPricingService:
    &quot;&quot;&quot;Test class for PricingService domain service&quot;&quot;&quot;
    
    def test_calculate_order_total_with_active_customer(self):
        &quot;&quot;&quot;Test calculating order total for active customer&quot;&quot;&quot;
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
        &quot;&quot;&quot;Test that calculating order total for inactive customer raises error&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_inactive_customer()
        address = self._create_address()
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot calculate pricing for inactive customer&quot;):
            pricing_service.calculate_order_total(order, customer, address)
    
    def test_calculate_discount_amount_vip_customer(self):
        &quot;&quot;&quot;Test calculating discount amount for VIP customer&quot;&quot;&quot;
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
    
    def test_calculate_discount_amount_premium_customer(self):
        &quot;&quot;&quot;Test calculating discount amount for premium customer&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_premium_customer()
        
        # Act
        discount = pricing_service.calculate_discount_amount(order, customer)
        
        # Assert
        assert isinstance(discount, Money)
        assert discount.currency == &quot;USD&quot;
        assert discount.amount &gt; 0
    
    def test_calculate_discount_amount_standard_customer(self):
        &quot;&quot;&quot;Test calculating discount amount for standard customer&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        customer = self._create_standard_customer()
        
        # Act
        discount = pricing_service.calculate_discount_amount(order, customer)
        
        # Assert
        assert isinstance(discount, Money)
        assert discount.currency == &quot;USD&quot;
        assert discount.amount &gt; 0
    
    def test_calculate_discount_amount_basic_customer(self):
        &quot;&quot;&quot;Test calculating discount amount for basic customer&quot;&quot;&quot;
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
    
    def test_get_available_discounts(self):
        &quot;&quot;&quot;Test getting available discounts for an order&quot;&quot;&quot;
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
    
    def test_apply_customer_discount_vip(self):
        &quot;&quot;&quot;Test applying VIP customer discount&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        amount = Money(100.00, &quot;USD&quot;)
        customer = self._create_vip_customer()
        
        # Act
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        
        # Assert
        assert discounted_amount.amount == 85.00  # 15% discount
        assert discounted_amount.currency == &quot;USD&quot;
    
    def test_apply_customer_discount_premium(self):
        &quot;&quot;&quot;Test applying premium customer discount&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        amount = Money(100.00, &quot;USD&quot;)
        customer = self._create_premium_customer()
        
        # Act
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        
        # Assert
        assert discounted_amount.amount == 90.00  # 10% discount
        assert discounted_amount.currency == &quot;USD&quot;
    
    def test_apply_customer_discount_standard(self):
        &quot;&quot;&quot;Test applying standard customer discount&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        amount = Money(100.00, &quot;USD&quot;)
        customer = self._create_standard_customer()
        
        # Act
        discounted_amount = pricing_service._apply_customer_discount(amount, customer)
        
        # Assert
        assert discounted_amount.amount == 95.00  # 5% discount
        assert discounted_amount.currency == &quot;USD&quot;
    
    def test_apply_bulk_discount_over_1000(self):
        &quot;&quot;&quot;Test applying bulk discount for orders over $1000&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        amount = Money(1200.00, &quot;USD&quot;)
        order = self._create_order_with_amount(1200.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 1080.00  # 10% discount
        assert discounted_amount.currency == &quot;USD&quot;
    
    def test_apply_bulk_discount_over_500(self):
        &quot;&quot;&quot;Test applying bulk discount for orders over $500&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        amount = Money(600.00, &quot;USD&quot;)
        order = self._create_order_with_amount(600.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 570.00  # 5% discount
        assert discounted_amount.currency == &quot;USD&quot;
    
    def test_apply_bulk_discount_over_100(self):
        &quot;&quot;&quot;Test applying bulk discount for orders over $100&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        amount = Money(150.00, &quot;USD&quot;)
        order = self._create_order_with_amount(150.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 147.00  # 2% discount
        assert discounted_amount.currency == &quot;USD&quot;
    
    def test_apply_bulk_discount_under_100(self):
        &quot;&quot;&quot;Test applying bulk discount for orders under $100&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        amount = Money(50.00, &quot;USD&quot;)
        order = self._create_order_with_amount(50.00)
        
        # Act
        discounted_amount = pricing_service._apply_bulk_discount(amount, order)
        
        # Assert
        assert discounted_amount.amount == 50.00  # No discount
        assert discounted_amount.currency == &quot;USD&quot;
    
    def test_apply_shipping_discount_over_50(self):
        &quot;&quot;&quot;Test applying shipping discount for orders over $50&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        shipping = Money(5.99, &quot;USD&quot;)
        order_amount = Money(75.00, &quot;USD&quot;)
        
        # Act
        discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount)
        
        # Assert
        assert discounted_shipping.amount == 0.00  # Free shipping
        assert discounted_shipping.currency == &quot;USD&quot;
    
    def test_apply_shipping_discount_over_25(self):
        &quot;&quot;&quot;Test applying shipping discount for orders over $25&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        shipping = Money(5.99, &quot;USD&quot;)
        order_amount = Money(30.00, &quot;USD&quot;)
        
        # Act
        discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount)
        
        # Assert
        assert discounted_shipping.amount == 2.995  # 50% off shipping
        assert discounted_shipping.currency == &quot;USD&quot;
    
    def test_apply_shipping_discount_under_25(self):
        &quot;&quot;&quot;Test applying shipping discount for orders under $25&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        shipping = Money(5.99, &quot;USD&quot;)
        order_amount = Money(20.00, &quot;USD&quot;)
        
        # Act
        discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount)
        
        # Assert
        assert discounted_shipping.amount == 5.99  # No discount
        assert discounted_shipping.currency == &quot;USD&quot;
    
    def test_get_customer_discount_rate(self):
        &quot;&quot;&quot;Test getting customer discount rate&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        
        # Act &amp; Assert
        assert pricing_service._get_customer_discount_rate(&quot;VIP&quot;) == 0.15
        assert pricing_service._get_customer_discount_rate(&quot;Premium&quot;) == 0.10
        assert pricing_service._get_customer_discount_rate(&quot;Standard&quot;) == 0.05
        assert pricing_service._get_customer_discount_rate(&quot;Basic&quot;) == 0.0
        assert pricing_service._get_customer_discount_rate(&quot;Unknown&quot;) == 0.0
    
    def test_get_customer_type_discount_vip(self):
        &quot;&quot;&quot;Test getting customer type discount for VIP customer&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        customer = self._create_vip_customer()
        
        # Act
        discount = pricing_service._get_customer_type_discount(customer)
        
        # Assert
        assert discount is not None
        assert discount.name == &quot;VIP Customer Discount&quot;
        assert discount.type == &quot;percentage&quot;
        assert discount.value == 0.15
        assert &quot;VIP&quot; in discount.description
    
    def test_get_customer_type_discount_basic(self):
        &quot;&quot;&quot;Test getting customer type discount for basic customer&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        customer = self._create_basic_customer()
        
        # Act
        discount = pricing_service._get_customer_type_discount(customer)
        
        # Assert
        assert discount is None  # Basic customers get no discount
    
    def test_get_bulk_discount_over_1000(self):
        &quot;&quot;&quot;Test getting bulk discount for orders over $1000&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_amount(1200.00)
        
        # Act
        discount = pricing_service._get_bulk_discount(order)
        
        # Assert
        assert discount is not None
        assert discount.name == &quot;Bulk Discount&quot;
        assert discount.type == &quot;percentage&quot;
        assert discount.value == 0.10
        assert &quot;10%&quot; in discount.description
    
    def test_get_bulk_discount_over_500(self):
        &quot;&quot;&quot;Test getting bulk discount for orders over $500&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_amount(600.00)
        
        # Act
        discount = pricing_service._get_bulk_discount(order)
        
        # Assert
        assert discount is not None
        assert discount.name == &quot;Bulk Discount&quot;
        assert discount.type == &quot;percentage&quot;
        assert discount.value == 0.05
        assert &quot;5%&quot; in discount.description
    
    def test_get_bulk_discount_under_500(self):
        &quot;&quot;&quot;Test getting bulk discount for orders under $500&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_amount(300.00)
        
        # Act
        discount = pricing_service._get_bulk_discount(order)
        
        # Assert
        assert discount is None  # No bulk discount
    
    def test_get_seasonal_discount_holiday_season(self):
        &quot;&quot;&quot;Test getting seasonal discount during holiday season&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        
        # Mock datetime to return December
        with patch(&#39;pricing_service.datetime&#39;) as mock_datetime:
            mock_datetime.now.return_value.month = 12
            
            # Act
            discount = pricing_service._get_seasonal_discount()
            
            # Assert
            assert discount is not None
            assert discount.name == &quot;Holiday Discount&quot;
            assert discount.type == &quot;percentage&quot;
            assert discount.value == 0.08
            assert &quot;holiday&quot; in discount.description.lower()
    
    def test_get_seasonal_discount_non_holiday_season(self):
        &quot;&quot;&quot;Test getting seasonal discount during non-holiday season&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        
        # Mock datetime to return March
        with patch(&#39;pricing_service.datetime&#39;) as mock_datetime:
            mock_datetime.now.return_value.month = 3
            
            # Act
            discount = pricing_service._get_seasonal_discount()
            
            # Assert
            assert discount is None  # No seasonal discount
    
    def test_get_product_discounts_sale_items(self):
        &quot;&quot;&quot;Test getting product discounts for sale items&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_sale_items()
        
        # Act
        discounts = pricing_service._get_product_discounts(order)
        
        # Assert
        assert len(discounts) &gt; 0
        for discount in discounts:
            assert discount.name == &quot;Sale Item Discount&quot;
            assert discount.type == &quot;percentage&quot;
            assert discount.value == 0.20
            assert &quot;sale&quot; in discount.description.lower()
    
    def test_get_product_discounts_no_sale_items(self):
        &quot;&quot;&quot;Test getting product discounts for non-sale items&quot;&quot;&quot;
        # Arrange
        pricing_service = PricingService()
        order = self._create_order_with_items()
        
        # Act
        discounts = pricing_service._get_product_discounts(order)
        
        # Assert
        assert len(discounts) == 0  # No sale items
    
    # Helper methods
    def _create_order_with_items(self):
        &quot;&quot;&quot;Create order with items for testing&quot;&quot;&quot;
        order = MockOrder()
        order.total_amount = Money(100.00, &quot;USD&quot;)
        order.items = [
            MockOrderItem(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;)),
            MockOrderItem(ProductId(&quot;product-2&quot;), 1, Money(25.50, &quot;USD&quot;))
        ]
        return order
    
    def _create_order_with_amount(self, amount):
        &quot;&quot;&quot;Create order with specific amount for testing&quot;&quot;&quot;
        order = MockOrder()
        order.total_amount = Money(amount, &quot;USD&quot;)
        order.items = []
        return order
    
    def _create_order_with_sale_items(self):
        &quot;&quot;&quot;Create order with sale items for testing&quot;&quot;&quot;
        order = MockOrder()
        order.total_amount = Money(100.00, &quot;USD&quot;)
        order.items = [
            MockOrderItem(ProductId(&quot;SALE-product-1&quot;), 2, Money(15.99, &quot;USD&quot;)),
            MockOrderItem(ProductId(&quot;SALE-product-2&quot;), 1, Money(25.50, &quot;USD&quot;))
        ]
        return order
    
    def _create_active_customer(self):
        &quot;&quot;&quot;Create active customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;Standard&quot;
        customer.is_active.return_value = True
        return customer
    
    def _create_inactive_customer(self):
        &quot;&quot;&quot;Create inactive customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;Standard&quot;
        customer.is_active.return_value = False
        return customer
    
    def _create_vip_customer(self):
        &quot;&quot;&quot;Create VIP customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;VIP&quot;
        customer.is_active.return_value = True
        return customer
    
    def _create_premium_customer(self):
        &quot;&quot;&quot;Create premium customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;Premium&quot;
        customer.is_active.return_value = True
        return customer
    
    def _create_standard_customer(self):
        &quot;&quot;&quot;Create standard customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;Standard&quot;
        customer.is_active.return_value = True
        return customer
    
    def _create_basic_customer(self):
        &quot;&quot;&quot;Create basic customer for testing&quot;&quot;&quot;
        customer = MockCustomer()
        customer.customer_type = &quot;Basic&quot;
        customer.is_active.return_value = True
        return customer
    
    def _create_address(self):
        &quot;&quot;&quot;Create address for testing&quot;&quot;&quot;
        address = MockAddress()
        address.country = &quot;US&quot;
        address.state = &quot;CA&quot;
        return address

class TestTaxCalculator:
    &quot;&quot;&quot;Test class for TaxCalculator domain service&quot;&quot;&quot;
    
    def test_calculate_tax_us_california(self):
        &quot;&quot;&quot;Test calculating tax for US California&quot;&quot;&quot;
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, &quot;USD&quot;)
        address = MockAddress()
        address.country = &quot;US&quot;
        address.state = &quot;CA&quot;
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 8.00  # 8% tax
        assert tax.currency == &quot;USD&quot;
    
    def test_calculate_tax_us_texas(self):
        &quot;&quot;&quot;Test calculating tax for US Texas&quot;&quot;&quot;
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, &quot;USD&quot;)
        address = MockAddress()
        address.country = &quot;US&quot;
        address.state = &quot;TX&quot;
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 8.00  # 8% tax
        assert tax.currency == &quot;USD&quot;
    
    def test_calculate_tax_us_other_state(self):
        &quot;&quot;&quot;Test calculating tax for US other state&quot;&quot;&quot;
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, &quot;USD&quot;)
        address = MockAddress()
        address.country = &quot;US&quot;
        address.state = &quot;NY&quot;
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 6.00  # 6% tax
        assert tax.currency == &quot;USD&quot;
    
    def test_calculate_tax_canada_ontario(self):
        &quot;&quot;&quot;Test calculating tax for Canada Ontario&quot;&quot;&quot;
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, &quot;USD&quot;)
        address = MockAddress()
        address.country = &quot;CA&quot;
        address.province = &quot;ON&quot;
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 13.00  # 13% HST
        assert tax.currency == &quot;USD&quot;
    
    def test_calculate_tax_canada_other_province(self):
        &quot;&quot;&quot;Test calculating tax for Canada other province&quot;&quot;&quot;
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, &quot;USD&quot;)
        address = MockAddress()
        address.country = &quot;CA&quot;
        address.province = &quot;QC&quot;
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 15.00  # 15% HST
        assert tax.currency == &quot;USD&quot;
    
    def test_calculate_tax_international(self):
        &quot;&quot;&quot;Test calculating tax for international address&quot;&quot;&quot;
        # Arrange
        tax_calculator = TaxCalculator()
        amount = Money(100.00, &quot;USD&quot;)
        address = MockAddress()
        address.country = &quot;UK&quot;
        
        # Act
        tax = tax_calculator.calculate_tax(amount, address)
        
        # Assert
        assert tax.amount == 0.00  # No tax for international
        assert tax.currency == &quot;USD&quot;

class TestShippingCalculator:
    &quot;&quot;&quot;Test class for ShippingCalculator domain service&quot;&quot;&quot;
    
    def test_calculate_shipping_us(self):
        &quot;&quot;&quot;Test calculating shipping for US address&quot;&quot;&quot;
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_order_with_items()
        address = MockAddress()
        address.country = &quot;US&quot;
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount &gt;= 5.99  # Base shipping
        assert shipping.currency == &quot;USD&quot;
    
    def test_calculate_shipping_canada(self):
        &quot;&quot;&quot;Test calculating shipping for Canada address&quot;&quot;&quot;
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_order_with_items()
        address = MockAddress()
        address.country = &quot;CA&quot;
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount &gt;= 8.99  # Base shipping
        assert shipping.currency == &quot;USD&quot;
    
    def test_calculate_shipping_international(self):
        &quot;&quot;&quot;Test calculating shipping for international address&quot;&quot;&quot;
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_order_with_items()
        address = MockAddress()
        address.country = &quot;UK&quot;
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount &gt;= 15.99  # Base shipping
        assert shipping.currency == &quot;USD&quot;
    
    def test_calculate_shipping_with_weight_charge(self):
        &quot;&quot;&quot;Test calculating shipping with weight charge&quot;&quot;&quot;
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_heavy_order()
        address = MockAddress()
        address.country = &quot;US&quot;
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount &gt; 5.99  # Base shipping + weight charge
        assert shipping.currency == &quot;USD&quot;
    
    def test_calculate_shipping_with_distance_charge(self):
        &quot;&quot;&quot;Test calculating shipping with distance charge&quot;&quot;&quot;
        # Arrange
        shipping_calculator = ShippingCalculator()
        order = self._create_order_with_items()
        address = MockAddress()
        address.country = &quot;US&quot;
        address.state = &quot;AK&quot;  # Alaska
        
        # Act
        shipping = shipping_calculator.calculate_shipping(order, address)
        
        # Assert
        assert shipping.amount &gt; 5.99  # Base shipping + distance charge
        assert shipping.currency == &quot;USD&quot;
    
    def _create_order_with_items(self):
        &quot;&quot;&quot;Create order with items for testing&quot;&quot;&quot;
        order = MockOrder()
        order.items = [
            MockOrderItem(ProductId(&quot;product-1&quot;), 2, Money(15.99, &quot;USD&quot;)),
            MockOrderItem(ProductId(&quot;product-2&quot;), 1, Money(25.50, &quot;USD&quot;))
        ]
        return order
    
    def _create_heavy_order(self):
        &quot;&quot;&quot;Create heavy order for testing&quot;&quot;&quot;
        order = MockOrder()
        order.items = [
            MockOrderItem(ProductId(&quot;product-1&quot;), 50, Money(15.99, &quot;USD&quot;))  # Heavy order
        ]
        return order

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
def pricing_service():
    &quot;&quot;&quot;Fixture for creating pricing service&quot;&quot;&quot;
    return PricingService()

@pytest.fixture
def tax_calculator():
    &quot;&quot;&quot;Fixture for creating tax calculator&quot;&quot;&quot;
    return TaxCalculator()

@pytest.fixture
def shipping_calculator():
    &quot;&quot;&quot;Fixture for creating shipping calculator&quot;&quot;&quot;
    return ShippingCalculator()

# Parametrized tests
@pytest.mark.parametrize(&quot;customer_type,expected_discount_rate&quot;, [
    (&quot;VIP&quot;, 0.15),
    (&quot;Premium&quot;, 0.10),
    (&quot;Standard&quot;, 0.05),
    (&quot;Basic&quot;, 0.0),
    (&quot;Unknown&quot;, 0.0)
])
def test_customer_discount_rates(customer_type, expected_discount_rate):
    &quot;&quot;&quot;Test customer discount rates with different parameters&quot;&quot;&quot;
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
    &quot;&quot;&quot;Test bulk discount rates with different parameters&quot;&quot;&quot;
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

@pytest.mark.parametrize(&quot;order_amount,expected_shipping_discount&quot;, [
    (75.0, 0.0),  # Free shipping
    (30.0, 0.5),  # 50% off shipping
    (20.0, 1.0)   # No discount
])
def test_shipping_discount_rates(order_amount, expected_shipping_discount):
    &quot;&quot;&quot;Test shipping discount rates with different parameters&quot;&quot;&quot;
    # Arrange
    pricing_service = PricingService()
    shipping = Money(5.99, &quot;USD&quot;)
    order_amount_obj = Money(order_amount, &quot;USD&quot;)
    
    # Act
    discounted_shipping = pricing_service._apply_shipping_discount(shipping, order_amount_obj)
    
    # Assert
    if expected_shipping_discount == 0.0:
        assert discounted_shipping.amount == 0.0
    elif expected_shipping_discount == 0.5:
        assert discounted_shipping.amount == 2.995
    else:
        assert discounted_shipping.amount == 5.99
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Testable Business Rules</h3>
<h4>1. <strong>Domain Service Testing</strong></h4>
<ul>
<li>✅ Tests focus on business logic without external dependencies</li>
<li>✅ Complex business rules are tested in isolation</li>
<li>✅ Service behavior is verified through comprehensive test cases</li>
</ul>
<h4>2. <strong>Business Rule Validation</strong></h4>
<ul>
<li>✅ Tests verify business rules are enforced correctly</li>
<li>✅ Different customer types get appropriate discounts</li>
<li>✅ Bulk discounts are applied based on order amounts</li>
</ul>
<h4>3. <strong>Service Composition Testing</strong></h4>
<ul>
<li>✅ Individual services (TaxCalculator, ShippingCalculator) are tested</li>
<li>✅ Service interactions are verified</li>
<li>✅ Complex calculations are broken down into testable components</li>
</ul>
<h4>4. <strong>Mock Usage</strong></h4>
<ul>
<li>✅ External dependencies are mocked for isolated testing</li>
<li>✅ Test data is created using helper methods</li>
<li>✅ Tests focus on business logic, not infrastructure</li>
</ul>
<h3>Pricing Service Testing Principles</h3>
<h4><strong>Test Business Rules</strong></h4>
<ul>
<li>✅ Customer discount rates are tested for all customer types</li>
<li>✅ Bulk discount thresholds are verified</li>
<li>✅ Shipping discount rules are tested</li>
</ul>
<h4><strong>Test Edge Cases</strong></h4>
<ul>
<li>✅ Boundary conditions (exactly $100, $500, $1000)</li>
<li>✅ Error conditions (inactive customers)</li>
<li>✅ Different address types (US, Canada, International)</li>
</ul>
<h4><strong>Test Service Composition</strong></h4>
<ul>
<li>✅ Individual services are tested separately</li>
<li>✅ Service interactions are verified</li>
<li>✅ Complex calculations are broken down</li>
</ul>
<h4><strong>Test Mocking</strong></h4>
<ul>
<li>✅ External dependencies are properly mocked</li>
<li>✅ Test data is created using helper methods</li>
<li>✅ Tests remain focused on business logic</li>
</ul>
<h3>Python Testing Benefits</h3>
<ul>
<li><strong>pytest</strong>: Powerful testing framework with fixtures and parametrization</li>
<li><strong>unittest.mock</strong>: Built-in mocking capabilities</li>
<li><strong>Type Hints</strong>: Better IDE support and documentation</li>
<li><strong>Fixtures</strong>: Reusable test data and setup</li>
<li><strong>Parametrized Tests</strong>: Test multiple scenarios efficiently</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
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
<li><a href="./05-pricing-service.md">Pricing Service</a> - Service being tested</li>
<li><a href="./07-order-tests.md">Order Tests</a> - Tests that use Pricing Service</li>
<li><a href="./08-money-tests.md">Money Tests</a> - Tests for Money value object</li>
<li><a href="../../1-introduction-to-the-domain.md#testable-business-rules">Testable Business Rules</a> - Testing concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 08-money-tests.md</li>
<li>Next: 10-customer-service-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#testable-business-rules">Testable Business Rules</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"09-pricing-service-tests"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"09-pricing-service-tests\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
