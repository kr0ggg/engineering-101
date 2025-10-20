1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/05-pricing-service","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"05-pricing-service\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T5a8b,<h1>Pricing Service - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#domain-services">Domain Services</a></p>
<p><strong>Navigation</strong>: <a href="./04-email-address-value-object.md">← Previous: EmailAddress Value Object</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - Pricing Service with Domain Service Design Principles
# File: 2-Domain-Driven-Design/code-samples/python/05-pricing-service.py

from abc import ABC, abstractmethod
from typing import List, Optional, Dict, Any
from dataclasses import dataclass
from datetime import datetime, timedelta
import uuid

# ✅ GOOD: Domain Service for Complex Business Logic
class PricingService:
    &quot;&quot;&quot;Domain service for complex pricing calculations&quot;&quot;&quot;
    
    def __init__(self):
        self._discount_rules = DiscountRuleRepository()
        self._tax_calculator = TaxCalculator()
        self._shipping_calculator = ShippingCalculator()
    
    def calculate_order_total(
        self,
        order: &#39;Order&#39;,
        customer: &#39;Customer&#39;,
        shipping_address: &#39;Address&#39;
    ) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Calculate total order amount with all applicable charges&quot;&quot;&quot;
        if not customer.is_active():
            raise ValueError(&quot;Cannot calculate pricing for inactive customer&quot;)
        
        # Start with base order amount
        base_amount = order.total_amount
        
        # Apply customer-specific discount
        discounted_amount = self._apply_customer_discount(base_amount, customer)
        
        # Apply bulk discount
        bulk_discounted_amount = self._apply_bulk_discount(discounted_amount, order)
        
        # Calculate tax
        tax_amount = self._tax_calculator.calculate_tax(bulk_discounted_amount, shipping_address)
        
        # Calculate shipping
        shipping_amount = self._shipping_calculator.calculate_shipping(order, shipping_address)
        
        # Apply shipping discount if applicable
        final_shipping = self._apply_shipping_discount(shipping_amount, bulk_discounted_amount)
        
        # Calculate final total
        final_total = bulk_discounted_amount.add(tax_amount).add(final_shipping)
        
        return final_total
    
    def calculate_discount_amount(
        self,
        order: &#39;Order&#39;,
        customer: &#39;Customer&#39;
    ) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Calculate total discount amount for an order&quot;&quot;&quot;
        base_amount = order.total_amount
        discounted_amount = self._apply_customer_discount(base_amount, customer)
        bulk_discounted_amount = self._apply_bulk_discount(discounted_amount, order)
        
        return base_amount.subtract(bulk_discounted_amount)
    
    def get_available_discounts(
        self,
        order: &#39;Order&#39;,
        customer: &#39;Customer&#39;
    ) -&gt; List[&#39;Discount&#39;]:
        &quot;&quot;&quot;Get all available discounts for an order&quot;&quot;&quot;
        discounts = []
        
        # Customer type discount
        customer_discount = self._get_customer_type_discount(customer)
        if customer_discount:
            discounts.append(customer_discount)
        
        # Bulk discount
        bulk_discount = self._get_bulk_discount(order)
        if bulk_discount:
            discounts.append(bulk_discount)
        
        # Seasonal discount
        seasonal_discount = self._get_seasonal_discount()
        if seasonal_discount:
            discounts.append(seasonal_discount)
        
        # Product-specific discounts
        product_discounts = self._get_product_discounts(order)
        discounts.extend(product_discounts)
        
        return discounts
    
    def _apply_customer_discount(self, amount: &#39;Money&#39;, customer: &#39;Customer&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Apply customer-specific discount&quot;&quot;&quot;
        discount_rate = self._get_customer_discount_rate(customer.customer_type)
        discount_amount = amount.multiply(discount_rate)
        return amount.subtract(discount_amount)
    
    def _apply_bulk_discount(self, amount: &#39;Money&#39;, order: &#39;Order&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Apply bulk discount based on order amount&quot;&quot;&quot;
        if amount.amount &gt;= 1000:
            discount_rate = 0.10  # 10% for orders over $1000
        elif amount.amount &gt;= 500:
            discount_rate = 0.05   # 5% for orders over $500
        elif amount.amount &gt;= 100:
            discount_rate = 0.02   # 2% for orders over $100
        else:
            discount_rate = 0.0
        
        discount_amount = amount.multiply(discount_rate)
        return amount.subtract(discount_amount)
    
    def _apply_shipping_discount(self, shipping: &#39;Money&#39;, order_amount: &#39;Money&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Apply shipping discount based on order amount&quot;&quot;&quot;
        if order_amount.amount &gt;= 50:
            return Money(0, shipping.currency)  # Free shipping
        elif order_amount.amount &gt;= 25:
            return shipping.multiply(0.5)  # 50% off shipping
        else:
            return shipping
    
    def _get_customer_discount_rate(self, customer_type: str) -&gt; float:
        &quot;&quot;&quot;Get discount rate based on customer type&quot;&quot;&quot;
        discount_rates = {
            &#39;VIP&#39;: 0.15,
            &#39;Premium&#39;: 0.10,
            &#39;Standard&#39;: 0.05,
            &#39;Basic&#39;: 0.0
        }
        return discount_rates.get(customer_type, 0.0)
    
    def _get_customer_type_discount(self, customer: &#39;Customer&#39;) -&gt; Optional[&#39;Discount&#39;]:
        &quot;&quot;&quot;Get customer type discount&quot;&quot;&quot;
        rate = self._get_customer_discount_rate(customer.customer_type)
        if rate &gt; 0:
            return Discount(
                id=str(uuid.uuid4()),
                name=f&quot;{customer.customer_type} Customer Discount&quot;,
                type=&quot;percentage&quot;,
                value=rate,
                description=f&quot;{int(rate * 100)}% discount for {customer.customer_type} customers&quot;
            )
        return None
    
    def _get_bulk_discount(self, order: &#39;Order&#39;) -&gt; Optional[&#39;Discount&#39;]:
        &quot;&quot;&quot;Get bulk discount&quot;&quot;&quot;
        amount = order.total_amount
        if amount.amount &gt;= 1000:
            return Discount(
                id=str(uuid.uuid4()),
                name=&quot;Bulk Discount&quot;,
                type=&quot;percentage&quot;,
                value=0.10,
                description=&quot;10% discount for orders over $1000&quot;
            )
        elif amount.amount &gt;= 500:
            return Discount(
                id=str(uuid.uuid4()),
                name=&quot;Bulk Discount&quot;,
                type=&quot;percentage&quot;,
                value=0.05,
                description=&quot;5% discount for orders over $500&quot;
            )
        return None
    
    def _get_seasonal_discount(self) -&gt; Optional[&#39;Discount&#39;]:
        &quot;&quot;&quot;Get seasonal discount&quot;&quot;&quot;
        current_month = datetime.now().month
        if current_month in [11, 12]:  # November and December
            return Discount(
                id=str(uuid.uuid4()),
                name=&quot;Holiday Discount&quot;,
                type=&quot;percentage&quot;,
                value=0.08,
                description=&quot;8% holiday discount&quot;
            )
        return None
    
    def _get_product_discounts(self, order: &#39;Order&#39;) -&gt; List[&#39;Discount&#39;]:
        &quot;&quot;&quot;Get product-specific discounts&quot;&quot;&quot;
        discounts = []
        for item in order.items:
            if item.product_id.value.startswith(&#39;SALE&#39;):
                discounts.append(Discount(
                    id=str(uuid.uuid4()),
                    name=&quot;Sale Item Discount&quot;,
                    type=&quot;percentage&quot;,
                    value=0.20,
                    description=&quot;20% discount on sale items&quot;
                ))
        return discounts

# ✅ GOOD: Tax Calculator Domain Service
class TaxCalculator:
    &quot;&quot;&quot;Domain service for tax calculations&quot;&quot;&quot;
    
    def calculate_tax(self, amount: &#39;Money&#39;, address: &#39;Address&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Calculate tax based on shipping address&quot;&quot;&quot;
        if address.country == &#39;US&#39;:
            return self._calculate_us_tax(amount, address)
        elif address.country == &#39;CA&#39;:
            return self._calculate_canadian_tax(amount, address)
        else:
            return Money(0, amount.currency)  # No tax for international orders
    
    def _calculate_us_tax(self, amount: &#39;Money&#39;, address: &#39;Address&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Calculate US tax&quot;&quot;&quot;
        if address.state in [&#39;CA&#39;, &#39;NY&#39;, &#39;TX&#39;]:
            tax_rate = 0.08  # 8% tax
        else:
            tax_rate = 0.06  # 6% tax
        
        return amount.multiply(tax_rate)
    
    def _calculate_canadian_tax(self, amount: &#39;Money&#39;, address: &#39;Address&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Calculate Canadian tax&quot;&quot;&quot;
        if address.province in [&#39;ON&#39;, &#39;BC&#39;, &#39;AB&#39;]:
            tax_rate = 0.13  # 13% HST
        else:
            tax_rate = 0.15  # 15% HST
        
        return amount.multiply(tax_rate)

# ✅ GOOD: Shipping Calculator Domain Service
class ShippingCalculator:
    &quot;&quot;&quot;Domain service for shipping calculations&quot;&quot;&quot;
    
    def calculate_shipping(self, order: &#39;Order&#39;, address: &#39;Address&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Calculate shipping cost&quot;&quot;&quot;
        base_shipping = self._get_base_shipping_rate(address)
        
        # Add weight-based charges
        weight_charge = self._calculate_weight_charge(order)
        
        # Add distance-based charges
        distance_charge = self._calculate_distance_charge(address)
        
        # Add handling fee
        handling_fee = Money(2.99, base_shipping.currency)
        
        total_shipping = base_shipping.add(weight_charge).add(distance_charge).add(handling_fee)
        
        return total_shipping
    
    def _get_base_shipping_rate(self, address: &#39;Address&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Get base shipping rate&quot;&quot;&quot;
        if address.country == &#39;US&#39;:
            return Money(5.99, &#39;USD&#39;)
        elif address.country == &#39;CA&#39;:
            return Money(8.99, &#39;USD&#39;)
        else:
            return Money(15.99, &#39;USD&#39;)
    
    def _calculate_weight_charge(self, order: &#39;Order&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Calculate weight-based shipping charge&quot;&quot;&quot;
        total_weight = sum(item.quantity * 0.5 for item in order.items)  # Simplified
        
        if total_weight &gt; 20:
            return Money(10.00, &#39;USD&#39;)
        elif total_weight &gt; 10:
            return Money(5.00, &#39;USD&#39;)
        else:
            return Money(0, &#39;USD&#39;)
    
    def _calculate_distance_charge(self, address: &#39;Address&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Calculate distance-based shipping charge&quot;&quot;&quot;
        if address.country == &#39;US&#39;:
            if address.state in [&#39;AK&#39;, &#39;HI&#39;]:
                return Money(15.00, &#39;USD&#39;)
            else:
                return Money(0, &#39;USD&#39;)
        else:
            return Money(0, &#39;USD&#39;)

# ✅ GOOD: Discount Rule Repository
class DiscountRuleRepository:
    &quot;&quot;&quot;Repository for discount rules&quot;&quot;&quot;
    
    def __init__(self):
        self._rules = {
            &#39;customer_type&#39;: {
                &#39;VIP&#39;: 0.15,
                &#39;Premium&#39;: 0.10,
                &#39;Standard&#39;: 0.05
            },
            &#39;bulk&#39;: {
                1000: 0.10,
                500: 0.05,
                100: 0.02
            },
            &#39;seasonal&#39;: {
                &#39;holiday&#39;: 0.08,
                &#39;summer&#39;: 0.05
            }
        }
    
    def get_customer_discount_rate(self, customer_type: str) -&gt; float:
        &quot;&quot;&quot;Get customer discount rate&quot;&quot;&quot;
        return self._rules[&#39;customer_type&#39;].get(customer_type, 0.0)
    
    def get_bulk_discount_rate(self, amount: float) -&gt; float:
        &quot;&quot;&quot;Get bulk discount rate&quot;&quot;&quot;
        for threshold, rate in sorted(self._rules[&#39;bulk&#39;].items(), reverse=True):
            if amount &gt;= threshold:
                return rate
        return 0.0

# ✅ GOOD: Discount Value Object
@dataclass(frozen=True)
class Discount:
    &quot;&quot;&quot;Value object representing a discount&quot;&quot;&quot;
    id: str
    name: str
    type: str  # &#39;percentage&#39; or &#39;fixed&#39;
    value: float
    description: str
    
    def apply_to(self, amount: &#39;Money&#39;) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Apply discount to an amount&quot;&quot;&quot;
        if self.type == &#39;percentage&#39;:
            discount_amount = amount.multiply(self.value)
        else:  # fixed
            discount_amount = Money(self.value, amount.currency)
        
        return amount.subtract(discount_amount)

# ✅ GOOD: Pricing Strategy Interface
class PricingStrategy(ABC):
    &quot;&quot;&quot;Abstract base class for pricing strategies&quot;&quot;&quot;
    
    @abstractmethod
    def calculate_price(self, base_price: &#39;Money&#39;, context: Dict[str, Any]) -&gt; &#39;Money&#39;:
        &quot;&quot;&quot;Calculate price using this strategy&quot;&quot;&quot;
        pass

# ✅ GOOD: Customer Type Pricing Strategy
class CustomerTypePricingStrategy(PricingStrategy):
    &quot;&quot;&quot;Pricing strategy based on customer type&quot;&quot;&quot;
    
    def calculate_price(self, base_price: &#39;Money&#39;, context: Dict[str, Any]) -&gt; &#39;Money&#39;:
        customer_type = context.get(&#39;customer_type&#39;, &#39;Basic&#39;)
        discount_rate = self._get_discount_rate(customer_type)
        discount_amount = base_price.multiply(discount_rate)
        return base_price.subtract(discount_amount)
    
    def _get_discount_rate(self, customer_type: str) -&gt; float:
        rates = {
            &#39;VIP&#39;: 0.15,
            &#39;Premium&#39;: 0.10,
            &#39;Standard&#39;: 0.05,
            &#39;Basic&#39;: 0.0
        }
        return rates.get(customer_type, 0.0)

# ✅ GOOD: Bulk Pricing Strategy
class BulkPricingStrategy(PricingStrategy):
    &quot;&quot;&quot;Pricing strategy based on order amount&quot;&quot;&quot;
    
    def calculate_price(self, base_price: &#39;Money&#39;, context: Dict[str, Any]) -&gt; &#39;Money&#39;:
        order_amount = context.get(&#39;order_amount&#39;, 0.0)
        discount_rate = self._get_discount_rate(order_amount)
        discount_amount = base_price.multiply(discount_rate)
        return base_price.subtract(discount_amount)
    
    def _get_discount_rate(self, order_amount: float) -&gt; float:
        if order_amount &gt;= 1000:
            return 0.10
        elif order_amount &gt;= 500:
            return 0.05
        elif order_amount &gt;= 100:
            return 0.02
        else:
            return 0.0

# ✅ GOOD: Composite Pricing Strategy
class CompositePricingStrategy(PricingStrategy):
    &quot;&quot;&quot;Composite pricing strategy that combines multiple strategies&quot;&quot;&quot;
    
    def __init__(self, strategies: List[PricingStrategy]):
        self._strategies = strategies
    
    def calculate_price(self, base_price: &#39;Money&#39;, context: Dict[str, Any]) -&gt; &#39;Money&#39;:
        current_price = base_price
        for strategy in self._strategies:
            current_price = strategy.calculate_price(current_price, context)
        return current_price

# ❌ BAD: Anemic Domain Service
class BadPricingService:
    &quot;&quot;&quot;Example of anemic domain service - only data, no behavior&quot;&quot;&quot;
    
    def __init__(self):
        self.discount_rate = 0.1
        self.tax_rate = 0.08
        self.shipping_rate = 5.99
    
    def calculate_total(self, order_amount: float) -&gt; float:
        # ❌ Business logic scattered, no domain concepts
        discount = order_amount * self.discount_rate
        subtotal = order_amount - discount
        tax = subtotal * self.tax_rate
        total = subtotal + tax + self.shipping_rate
        return total

# ❌ BAD: Service with External Dependencies
class BadPricingServiceWithDependencies:
    &quot;&quot;&quot;Example of service with external dependencies&quot;&quot;&quot;
    
    def __init__(self, database, cache, logger):
        self.database = database  # ❌ External dependency
        self.cache = cache        # ❌ External dependency
        self.logger = logger      # ❌ External dependency
    
    def calculate_price(self, order):
        # ❌ Business logic mixed with infrastructure concerns
        self.logger.info(&quot;Calculating price&quot;)
        data = self.database.get_pricing_data()
        cached_data = self.cache.get(&quot;pricing&quot;)
        # ... business logic mixed with infrastructure

# Example usage
if __name__ == &quot;__main__&quot;:
    # Create pricing service
    pricing_service = PricingService()
    
    # Create mock objects for demonstration
    class MockOrder:
        def __init__(self, total_amount):
            self.total_amount = total_amount
            self.items = []
    
    class MockCustomer:
        def __init__(self, customer_type, is_active=True):
            self.customer_type = customer_type
            self._is_active = is_active
        
        def is_active(self):
            return self._is_active
    
    class MockAddress:
        def __init__(self, country, state=None, province=None):
            self.country = country
            self.state = state
            self.province = province
    
    # Test pricing calculations
    order = MockOrder(Money(500, &#39;USD&#39;))
    customer = MockCustomer(&#39;Premium&#39;)
    address = MockAddress(&#39;US&#39;, &#39;CA&#39;)
    
    try:
        total = pricing_service.calculate_order_total(order, customer, address)
        print(f&quot;Order total: {total}&quot;)
        
        discounts = pricing_service.get_available_discounts(order, customer)
        print(f&quot;Available discounts: {len(discounts)}&quot;)
        for discount in discounts:
            print(f&quot;  - {discount.name}: {discount.description}&quot;)
        
    except ValueError as e:
        print(f&quot;Error: {e}&quot;)
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Domain Services</h3>
<h4>1. <strong>Stateless Services</strong></h4>
<ul>
<li>✅ Domain services are stateless and stateless</li>
<li>✅ No instance variables that change state</li>
<li>✅ Pure functions for calculations</li>
</ul>
<h4>2. <strong>Complex Business Logic</strong></h4>
<ul>
<li>✅ Domain services handle complex business logic</li>
<li>✅ Business logic that doesn&#39;t belong to a single entity</li>
<li>✅ Calculations that involve multiple domain objects</li>
</ul>
<h4>3. <strong>Domain Service Design Principles</strong></h4>
<ul>
<li>✅ Domain services are part of the domain layer</li>
<li>✅ They don&#39;t depend on external frameworks</li>
<li>✅ They express business operations clearly</li>
</ul>
<h4>4. <strong>Service Composition</strong></h4>
<ul>
<li>✅ Domain services can be composed together</li>
<li>✅ Each service has a single responsibility</li>
<li>✅ Services can be easily tested in isolation</li>
</ul>
<h3>Pricing Service Design Principles</h3>
<h4><strong>Single Responsibility</strong></h4>
<ul>
<li>✅ Pricing service only handles pricing calculations</li>
<li>✅ Tax calculation is handled by TaxCalculator</li>
<li>✅ Shipping calculation is handled by ShippingCalculator</li>
</ul>
<h4><strong>Domain Service Design</strong></h4>
<ul>
<li>✅ Service is stateless and stateless</li>
<li>✅ No external dependencies</li>
<li>✅ Pure functions for calculations</li>
</ul>
<h4><strong>Business Logic Encapsulation</strong></h4>
<ul>
<li>✅ Complex pricing rules are encapsulated</li>
<li>✅ Business rules are expressed clearly</li>
<li>✅ Service methods express business operations</li>
</ul>
<h4><strong>Testability</strong></h4>
<ul>
<li>✅ Service can be easily tested in isolation</li>
<li>✅ No external dependencies to mock</li>
<li>✅ Pure functions are predictable</li>
</ul>
<h3>Python Benefits for Domain Services</h3>
<ul>
<li><strong>Type Hints</strong>: Better IDE support and documentation</li>
<li><strong>Abstract Base Classes</strong>: Clear interfaces for strategies</li>
<li><strong>Dataclasses</strong>: Clean, concise class definitions</li>
<li><strong>Method Chaining</strong>: Fluent interfaces for operations</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
<li><strong>Composition</strong>: Easy to compose services together</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Anemic Domain Service</strong></h4>
<ul>
<li>❌ Service contains only data, no behavior</li>
<li>❌ Business logic scattered across multiple classes</li>
<li>❌ No encapsulation of business rules</li>
</ul>
<h4><strong>Service with External Dependencies</strong></h4>
<ul>
<li>❌ Domain service depends on external frameworks</li>
<li>❌ Business logic mixed with infrastructure concerns</li>
<li>❌ Hard to test and maintain</li>
</ul>
<h4><strong>God Service</strong></h4>
<ul>
<li>❌ Single service with too many responsibilities</li>
<li>❌ Hard to understand and maintain</li>
<li>❌ Violates Single Responsibility Principle</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity used by Pricing Service</li>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Entity used by Pricing Service</li>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Value object used by Pricing Service</li>
<li><a href="../../1-introduction-to-the-domain.md#domain-services">Domain Services</a> - Domain service concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 04-email-address-value-object.md</li>
<li>Next: 06-customer-module.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#domain-services">Domain Services</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/05-pricing-service","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"05-pricing-service"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"05-pricing-service\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/05-pricing-service","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
