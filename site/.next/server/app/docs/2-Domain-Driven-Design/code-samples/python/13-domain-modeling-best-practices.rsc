1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"13-domain-modeling-best-practices\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T9b23,<h1>Domain Modeling Best Practices - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling">Best Practices for Domain Modeling</a></p>
<p><strong>Navigation</strong>: <a href="./12-testing-best-practices.md">← Previous: Testing Best Practices</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - Domain Modeling Best Practices
# File: 2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices.py

from abc import ABC, abstractmethod
from typing import List, Optional, Dict, Any, Protocol
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
import uuid
import hashlib

# ✅ GOOD: Pure Domain Logic
@dataclass(frozen=True)
class OrderId:
    &quot;&quot;&quot;Value object for Order identity&quot;&quot;&quot;
    value: str
    
    @classmethod
    def generate(cls) -&gt; &#39;OrderId&#39;:
        return cls(str(uuid.uuid4()))
    
    def __str__(self) -&gt; str:
        return self.value

@dataclass(frozen=True)
class CustomerId:
    &quot;&quot;&quot;Value object for Customer identity&quot;&quot;&quot;
    value: str
    
    def __str__(self) -&gt; str:
        return self.value

@dataclass(frozen=True)
class ProductId:
    &quot;&quot;&quot;Value object for Product identity&quot;&quot;&quot;
    value: str
    
    def __str__(self) -&gt; str:
        return self.value

@dataclass(frozen=True)
class Money:
    &quot;&quot;&quot;Value object for monetary amounts&quot;&quot;&quot;
    amount: float
    currency: str
    
    def __post_init__(self):
        if self.amount &lt; 0:
            raise ValueError(&quot;Amount cannot be negative&quot;)
        if not self.currency or not self.currency.strip():
            raise ValueError(&quot;Currency cannot be empty&quot;)
    
    def add(self, other: &#39;Money&#39;) -&gt; &#39;Money&#39;:
        if self.currency != other.currency:
            raise ValueError(&quot;Cannot add different currencies&quot;)
        return Money(self.amount + other.amount, self.currency)
    
    def subtract(self, other: &#39;Money&#39;) -&gt; &#39;Money&#39;:
        if self.currency != other.currency:
            raise ValueError(&quot;Cannot subtract different currencies&quot;)
        return Money(self.amount - other.amount, self.currency)
    
    def multiply(self, factor: float) -&gt; &#39;Money&#39;:
        if factor &lt; 0:
            raise ValueError(&quot;Factor cannot be negative&quot;)
        return Money(self.amount * factor, self.currency)
    
    def equals(self, other: &#39;Money&#39;) -&gt; bool:
        return self.amount == other.amount and self.currency == other.currency
    
    @classmethod
    def zero(cls, currency: str) -&gt; &#39;Money&#39;:
        return cls(0, currency)
    
    @classmethod
    def from_amount(cls, amount: float, currency: str) -&gt; &#39;Money&#39;:
        return cls(amount, currency)
    
    def __str__(self) -&gt; str:
        return f&quot;{self.currency} {self.amount:.2f}&quot;

class OrderStatus(Enum):
    DRAFT = &quot;Draft&quot;
    CONFIRMED = &quot;Confirmed&quot;
    SHIPPED = &quot;Shipped&quot;
    DELIVERED = &quot;Delivered&quot;
    CANCELLED = &quot;Cancelled&quot;

@dataclass(frozen=True)
class OrderItem:
    &quot;&quot;&quot;Value object representing an order item&quot;&quot;&quot;
    product_id: ProductId
    quantity: int
    unit_price: Money
    
    def __post_init__(self):
        if self.quantity &lt;= 0:
            raise ValueError(&quot;Quantity must be positive&quot;)
    
    @property
    def total_price(self) -&gt; Money:
        return self.unit_price.multiply(self.quantity)

class Order:
    &quot;&quot;&quot;Domain Entity representing an Order with rich behavior&quot;&quot;&quot;
    
    def __init__(
        self,
        order_id: OrderId,
        customer_id: CustomerId,
        created_at: Optional[datetime] = None
    ):
        self._id = order_id
        self._customer_id = customer_id
        self._created_at = created_at or datetime.utcnow()
        self._items: List[OrderItem] = []
        self._status = OrderStatus.DRAFT
        self._confirmed_at: Optional[datetime] = None
        self._shipped_at: Optional[datetime] = None
    
    # ✅ Identity properties
    @property
    def id(self) -&gt; OrderId:
        return self._id
    
    @property
    def customer_id(self) -&gt; CustomerId:
        return self._customer_id
    
    @property
    def created_at(self) -&gt; datetime:
        return self._created_at
    
    @property
    def status(self) -&gt; OrderStatus:
        return self._status
    
    @property
    def items(self) -&gt; List[OrderItem]:
        return self._items.copy()  # Return copy to maintain encapsulation
    
    @property
    def item_count(self) -&gt; int:
        return len(self._items)
    
    @property
    def total_amount(self) -&gt; Money:
        &quot;&quot;&quot;Calculate total amount for all items&quot;&quot;&quot;
        if not self._items:
            return Money.zero(&quot;USD&quot;)
        
        total = self._items[0].total_price
        for item in self._items[1:]:
            total = total.add(item.total_price)
        return total
    
    # ✅ Business Logic Encapsulation
    def add_item(self, product_id: ProductId, quantity: int, unit_price: Money) -&gt; None:
        &quot;&quot;&quot;Add an item to the order with business rule validation&quot;&quot;&quot;
        if self._status != OrderStatus.DRAFT:
            raise ValueError(&quot;Cannot modify confirmed order&quot;)
        
        if quantity &lt;= 0:
            raise ValueError(&quot;Quantity must be positive&quot;)
        
        # Business rule: Check if item already exists
        existing_item_index = self._find_item_index(product_id)
        
        if existing_item_index &gt;= 0:
            # Update existing item quantity
            existing_item = self._items[existing_item_index]
            new_quantity = existing_item.quantity + quantity
            updated_item = OrderItem(product_id, new_quantity, unit_price)
            self._items[existing_item_index] = updated_item
        else:
            # Add new item
            new_item = OrderItem(product_id, quantity, unit_price)
            self._items.append(new_item)
    
    def confirm(self) -&gt; None:
        &quot;&quot;&quot;Confirm the order with business rule validation&quot;&quot;&quot;
        if self._status != OrderStatus.DRAFT:
            raise ValueError(&quot;Order is not in draft status&quot;)
        
        if not self._items:
            raise ValueError(&quot;Cannot confirm empty order&quot;)
        
        # Business rule: Minimum order amount
        if self.total_amount.amount &lt; 10.0:
            raise ValueError(&quot;Order amount must be at least $10.00&quot;)
        
        self._status = OrderStatus.CONFIRMED
        self._confirmed_at = datetime.utcnow()
    
    # ✅ Business Rules as Methods
    def can_be_modified(self) -&gt; bool:
        &quot;&quot;&quot;Check if order can be modified&quot;&quot;&quot;
        return self._status == OrderStatus.DRAFT
    
    def can_be_confirmed(self) -&gt; bool:
        &quot;&quot;&quot;Check if order can be confirmed&quot;&quot;&quot;
        return (self._status == OrderStatus.DRAFT and 
                len(self._items) &gt; 0 and 
                self.total_amount.amount &gt;= 10.0)
    
    def can_be_shipped(self) -&gt; bool:
        &quot;&quot;&quot;Check if order can be shipped&quot;&quot;&quot;
        return self._status == OrderStatus.CONFIRMED
    
    def can_be_delivered(self) -&gt; bool:
        &quot;&quot;&quot;Check if order can be delivered&quot;&quot;&quot;
        return self._status == OrderStatus.SHIPPED
    
    def can_be_cancelled(self) -&gt; bool:
        &quot;&quot;&quot;Check if order can be cancelled&quot;&quot;&quot;
        return self._status in [OrderStatus.DRAFT, OrderStatus.CONFIRMED]
    
    # ✅ Helper methods
    def _find_item_index(self, product_id: ProductId) -&gt; int:
        &quot;&quot;&quot;Find the index of an item by product ID&quot;&quot;&quot;
        for i, item in enumerate(self._items):
            if item.product_id == product_id:
                return i
        return -1
    
    def get_item_by_product_id(self, product_id: ProductId) -&gt; Optional[OrderItem]:
        &quot;&quot;&quot;Get an item by product ID&quot;&quot;&quot;
        item_index = self._find_item_index(product_id)
        return self._items[item_index] if item_index &gt;= 0 else None
    
    def has_item(self, product_id: ProductId) -&gt; bool:
        &quot;&quot;&quot;Check if order contains an item with the given product ID&quot;&quot;&quot;
        return self._find_item_index(product_id) &gt;= 0
    
    # ✅ Domain Events (simplified)
    def get_domain_events(self) -&gt; List[str]:
        &quot;&quot;&quot;Get domain events that occurred on this aggregate&quot;&quot;&quot;
        events = []
        if self._status == OrderStatus.CONFIRMED:
            events.append(&quot;OrderConfirmed&quot;)
        if self._status == OrderStatus.SHIPPED:
            events.append(&quot;OrderShipped&quot;)
        if self._status == OrderStatus.DELIVERED:
            events.append(&quot;OrderDelivered&quot;)
        if self._status == OrderStatus.CANCELLED:
            events.append(&quot;OrderCancelled&quot;)
        return events
    
    def __str__(self) -&gt; str:
        return (f&quot;Order(id={self._id}, customer_id={self._customer_id}, &quot;
                f&quot;status={self._status.value}, items={len(self._items)}, &quot;
                f&quot;total={self.total_amount})&quot;)

# ✅ GOOD: Rich Domain Models with Behavior
class CustomerStatus(Enum):
    PENDING = &quot;Pending&quot;
    ACTIVE = &quot;Active&quot;
    SUSPENDED = &quot;Suspended&quot;
    INACTIVE = &quot;Inactive&quot;

@dataclass(frozen=True)
class EmailAddress:
    &quot;&quot;&quot;Value object for email address&quot;&quot;&quot;
    value: str
    
    def __post_init__(self):
        if not self._is_valid_email(self.value):
            raise ValueError(f&quot;Invalid email address: {self.value}&quot;)
    
    def _is_valid_email(self, email: str) -&gt; bool:
        import re
        pattern = r&#39;^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$&#39;
        return re.match(pattern, email) is not None
    
    def __str__(self) -&gt; str:
        return self.value

class Customer:
    &quot;&quot;&quot;Customer entity with rich behavior&quot;&quot;&quot;
    
    def __init__(
        self,
        customer_id: CustomerId,
        name: str,
        email: EmailAddress,
        created_at: Optional[datetime] = None
    ):
        self._id = customer_id
        self._name = name
        self._email = email
        self._created_at = created_at or datetime.utcnow()
        self._status = CustomerStatus.PENDING
        self._last_activity = None
        self._orders_count = 0
        self._total_spent = Money.zero(&#39;USD&#39;)
    
    # Identity properties
    @property
    def id(self) -&gt; CustomerId:
        return self._id
    
    @property
    def name(self) -&gt; str:
        return self._name
    
    @property
    def email(self) -&gt; EmailAddress:
        return self._email
    
    @property
    def created_at(self) -&gt; datetime:
        return self._created_at
    
    @property
    def status(self) -&gt; CustomerStatus:
        return self._status
    
    @property
    def last_activity(self) -&gt; Optional[datetime]:
        return self._last_activity
    
    @property
    def orders_count(self) -&gt; int:
        return self._orders_count
    
    @property
    def total_spent(self) -&gt; Money:
        return self._total_spent
    
    # Business operations
    def activate(self) -&gt; None:
        &quot;&quot;&quot;Activate the customer&quot;&quot;&quot;
        if self._status == CustomerStatus.SUSPENDED:
            raise ValueError(&quot;Cannot activate suspended customer&quot;)
        self._status = CustomerStatus.ACTIVE
        self._last_activity = datetime.utcnow()
    
    def deactivate(self) -&gt; None:
        &quot;&quot;&quot;Deactivate the customer&quot;&quot;&quot;
        self._status = CustomerStatus.INACTIVE
        self._last_activity = datetime.utcnow()
    
    def suspend(self) -&gt; None:
        &quot;&quot;&quot;Suspend the customer&quot;&quot;&quot;
        self._status = CustomerStatus.SUSPENDED
        self._last_activity = datetime.utcnow()
    
    def update_email(self, new_email: EmailAddress) -&gt; None:
        &quot;&quot;&quot;Update customer email&quot;&quot;&quot;
        if self._status == CustomerStatus.SUSPENDED:
            raise ValueError(&quot;Cannot update email for suspended customer&quot;)
        self._email = new_email
        self._last_activity = datetime.utcnow()
    
    def update_name(self, new_name: str) -&gt; None:
        &quot;&quot;&quot;Update customer name&quot;&quot;&quot;
        if not new_name or not new_name.strip():
            raise ValueError(&quot;Name cannot be empty&quot;)
        self._name = new_name.strip()
        self._last_activity = datetime.utcnow()
    
    def record_order(self, order_amount: Money) -&gt; None:
        &quot;&quot;&quot;Record a new order&quot;&quot;&quot;
        if self._status != CustomerStatus.ACTIVE:
            raise ValueError(&quot;Only active customers can place orders&quot;)
        self._orders_count += 1
        self._total_spent = self._total_spent.add(order_amount)
        self._last_activity = datetime.utcnow()
    
    # Business rules
    def is_active(self) -&gt; bool:
        &quot;&quot;&quot;Check if customer is active&quot;&quot;&quot;
        return self._status == CustomerStatus.ACTIVE
    
    def can_place_orders(self) -&gt; bool:
        &quot;&quot;&quot;Check if customer can place orders&quot;&quot;&quot;
        return self._status == CustomerStatus.ACTIVE
    
    def is_vip(self) -&gt; bool:
        &quot;&quot;&quot;Check if customer is VIP&quot;&quot;&quot;
        return self._total_spent.amount &gt;= 1000
    
    def is_premium(self) -&gt; bool:
        &quot;&quot;&quot;Check if customer is premium&quot;&quot;&quot;
        return self._total_spent.amount &gt;= 500
    
    def get_customer_type(self) -&gt; str:
        &quot;&quot;&quot;Get customer type based on spending&quot;&quot;&quot;
        if self.is_vip():
            return &#39;VIP&#39;
        elif self.is_premium():
            return &#39;Premium&#39;
        else:
            return &#39;Standard&#39;
    
    def __str__(self) -&gt; str:
        return f&quot;Customer(id={self._id}, name={self._name}, email={self._email}, status={self._status.value})&quot;

# ✅ GOOD: Validation at Domain Boundaries
@dataclass(frozen=True)
class Address:
    &quot;&quot;&quot;Value object for address&quot;&quot;&quot;
    street: str
    city: str
    state: str
    country: str
    postal_code: str
    
    def __post_init__(self):
        if not self.street or not self.street.strip():
            raise ValueError(&quot;Street cannot be empty&quot;)
        if not self.city or not self.city.strip():
            raise ValueError(&quot;City cannot be empty&quot;)
        if not self.country or not self.country.strip():
            raise ValueError(&quot;Country cannot be empty&quot;)
    
    def __str__(self) -&gt; str:
        return f&quot;{self.street}, {self.city}, {self.state} {self.postal_code}, {self.country}&quot;

# ✅ GOOD: Domain Service for Complex Business Logic
class PricingService:
    &quot;&quot;&quot;Domain service for complex pricing calculations&quot;&quot;&quot;
    
    def __init__(self):
        self._discount_rules = DiscountRuleRepository()
        self._tax_calculator = TaxCalculator()
        self._shipping_calculator = ShippingCalculator()
    
    def calculate_order_total(
        self,
        order: Order,
        customer: Customer,
        shipping_address: Address
    ) -&gt; Money:
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
    
    def _apply_customer_discount(self, amount: Money, customer: Customer) -&gt; Money:
        &quot;&quot;&quot;Apply customer-specific discount&quot;&quot;&quot;
        discount_rate = self._get_customer_discount_rate(customer.get_customer_type())
        discount_amount = amount.multiply(discount_rate)
        return amount.subtract(discount_amount)
    
    def _apply_bulk_discount(self, amount: Money, order: Order) -&gt; Money:
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
    
    def _apply_shipping_discount(self, shipping: Money, order_amount: Money) -&gt; Money:
        &quot;&quot;&quot;Apply shipping discount based on order amount&quot;&quot;&quot;
        if order_amount.amount &gt;= 50:
            return Money.zero(shipping.currency)  # Free shipping
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

# ✅ GOOD: Domain Service Interfaces
class TaxCalculator:
    &quot;&quot;&quot;Domain service for tax calculations&quot;&quot;&quot;
    
    def calculate_tax(self, amount: Money, address: Address) -&gt; Money:
        &quot;&quot;&quot;Calculate tax based on shipping address&quot;&quot;&quot;
        if address.country == &#39;US&#39;:
            return self._calculate_us_tax(amount, address)
        elif address.country == &#39;CA&#39;:
            return self._calculate_canadian_tax(amount, address)
        else:
            return Money.zero(amount.currency)  # No tax for international orders
    
    def _calculate_us_tax(self, amount: Money, address: Address) -&gt; Money:
        &quot;&quot;&quot;Calculate US tax&quot;&quot;&quot;
        if address.state in [&#39;CA&#39;, &#39;NY&#39;, &#39;TX&#39;]:
            tax_rate = 0.08  # 8% tax
        else:
            tax_rate = 0.06  # 6% tax
        
        return amount.multiply(tax_rate)
    
    def _calculate_canadian_tax(self, amount: Money, address: Address) -&gt; Money:
        &quot;&quot;&quot;Calculate Canadian tax&quot;&quot;&quot;
        if address.state in [&#39;ON&#39;, &#39;BC&#39;, &#39;AB&#39;]:
            tax_rate = 0.13  # 13% HST
        else:
            tax_rate = 0.15  # 15% HST
        
        return amount.multiply(tax_rate)

class ShippingCalculator:
    &quot;&quot;&quot;Domain service for shipping calculations&quot;&quot;&quot;
    
    def calculate_shipping(self, order: Order, address: Address) -&gt; Money:
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
    
    def _get_base_shipping_rate(self, address: Address) -&gt; Money:
        &quot;&quot;&quot;Get base shipping rate&quot;&quot;&quot;
        if address.country == &#39;US&#39;:
            return Money(5.99, &#39;USD&#39;)
        elif address.country == &#39;CA&#39;:
            return Money(8.99, &#39;USD&#39;)
        else:
            return Money(15.99, &#39;USD&#39;)
    
    def _calculate_weight_charge(self, order: Order) -&gt; Money:
        &quot;&quot;&quot;Calculate weight-based shipping charge&quot;&quot;&quot;
        total_weight = sum(item.quantity * 0.5 for item in order.items)  # Simplified
        
        if total_weight &gt; 20:
            return Money(10.00, &#39;USD&#39;)
        elif total_weight &gt; 10:
            return Money(5.00, &#39;USD&#39;)
        else:
            return Money.zero(&#39;USD&#39;)
    
    def _calculate_distance_charge(self, address: Address) -&gt; Money:
        &quot;&quot;&quot;Calculate distance-based shipping charge&quot;&quot;&quot;
        if address.country == &#39;US&#39;:
            if address.state in [&#39;AK&#39;, &#39;HI&#39;]:
                return Money(15.00, &#39;USD&#39;)
            else:
                return Money.zero(&#39;USD&#39;)
        else:
            return Money.zero(&#39;USD&#39;)

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

# ✅ GOOD: Domain Events for Significant Changes
@dataclass(frozen=True)
class OrderConfirmedEvent:
    &quot;&quot;&quot;Domain event for order confirmation&quot;&quot;&quot;
    order_id: OrderId
    customer_id: CustomerId
    total_amount: Money
    occurred_at: datetime = field(default_factory=datetime.utcnow)

@dataclass(frozen=True)
class OrderShippedEvent:
    &quot;&quot;&quot;Domain event for order shipping&quot;&quot;&quot;
    order_id: OrderId
    customer_id: CustomerId
    shipping_address: Address
    occurred_at: datetime = field(default_factory=datetime.utcnow)

class DomainEvents:
    &quot;&quot;&quot;Domain events manager&quot;&quot;&quot;
    
    _events: List[Any] = []
    
    @classmethod
    def raise(cls, event: Any) -&gt; None:
        &quot;&quot;&quot;Raise a domain event&quot;&quot;&quot;
        cls._events.append(event)
    
    @classmethod
    def get_events(cls) -&gt; List[Any]:
        &quot;&quot;&quot;Get all domain events&quot;&quot;&quot;
        return cls._events.copy()
    
    @classmethod
    def clear_events(cls) -&gt; None:
        &quot;&quot;&quot;Clear all domain events&quot;&quot;&quot;
        cls._events.clear()

# ✅ GOOD: Aggregate Root Pattern
class OrderAggregate:
    &quot;&quot;&quot;Aggregate root for order management&quot;&quot;&quot;
    
    def __init__(self, order: Order):
        self._order = order
        self._events: List[Any] = []
    
    @property
    def order(self) -&gt; Order:
        return self._order
    
    def add_item(self, product_id: ProductId, quantity: int, unit_price: Money) -&gt; None:
        &quot;&quot;&quot;Add item to order with business rule validation&quot;&quot;&quot;
        if not self._order.can_be_modified():
            raise ValueError(&quot;Cannot modify confirmed order&quot;)
        
        self._order.add_item(product_id, quantity, unit_price)
        
        # Raise domain event
        self._events.append(f&quot;ItemAdded: {product_id.value}, quantity: {quantity}&quot;)
    
    def confirm(self) -&gt; None:
        &quot;&quot;&quot;Confirm order with business rule validation&quot;&quot;&quot;
        if not self._order.can_be_confirmed():
            raise ValueError(&quot;Order cannot be confirmed&quot;)
        
        self._order.confirm()
        
        # Raise domain event
        event = OrderConfirmedEvent(
            self._order.id,
            self._order.customer_id,
            self._order.total_amount
        )
        self._events.append(event)
    
    def ship(self, shipping_address: Address) -&gt; None:
        &quot;&quot;&quot;Ship order with business rule validation&quot;&quot;&quot;
        if not self._order.can_be_shipped():
            raise ValueError(&quot;Order cannot be shipped&quot;)
        
        self._order._status = OrderStatus.SHIPPED
        self._order._shipped_at = datetime.utcnow()
        
        # Raise domain event
        event = OrderShippedEvent(
            self._order.id,
            self._order.customer_id,
            shipping_address
        )
        self._events.append(event)
    
    def get_uncommitted_events(self) -&gt; List[Any]:
        &quot;&quot;&quot;Get uncommitted domain events&quot;&quot;&quot;
        return self._events.copy()
    
    def mark_events_as_committed(self) -&gt; None:
        &quot;&quot;&quot;Mark events as committed&quot;&quot;&quot;
        self._events.clear()

# ✅ GOOD: Specification Pattern for Complex Business Rules
class OrderSpecification:
    &quot;&quot;&quot;Specification for complex business rules&quot;&quot;&quot;
    
    def can_be_confirmed(self, order: Order) -&gt; bool:
        &quot;&quot;&quot;Check if order meets all confirmation criteria&quot;&quot;&quot;
        return (order.status == OrderStatus.DRAFT and
                len(order.items) &gt; 0 and
                order.total_amount.amount &gt;= 10.0 and
                self._has_valid_items(order))
    
    def can_be_shipped(self, order: Order) -&gt; bool:
        &quot;&quot;&quot;Check if order can be shipped&quot;&quot;&quot;
        return (order.status == OrderStatus.CONFIRMED and
                self._has_shipping_address(order) and
                self._all_items_in_stock(order))
    
    def _has_valid_items(self, order: Order) -&gt; bool:
        &quot;&quot;&quot;Check if all items are valid&quot;&quot;&quot;
        return all(item.quantity &gt; 0 for item in order.items)
    
    def _has_shipping_address(self, order: Order) -&gt; bool:
        &quot;&quot;&quot;Check if order has valid shipping address&quot;&quot;&quot;
        # Simplified - would check actual address
        return True
    
    def _all_items_in_stock(self, order: Order) -&gt; bool:
        &quot;&quot;&quot;Check if all items are in stock&quot;&quot;&quot;
        # Simplified - would check inventory
        return True

# ✅ GOOD: Factory Pattern for Complex Object Creation
class OrderFactory:
    &quot;&quot;&quot;Factory for creating orders with complex initialization&quot;&quot;&quot;
    
    @staticmethod
    def create_draft_order(customer_id: CustomerId) -&gt; Order:
        &quot;&quot;&quot;Create a new draft order&quot;&quot;&quot;
        order_id = OrderId.generate()
        return Order(order_id, customer_id)
    
    @staticmethod
    def create_order_from_cart(
        customer_id: CustomerId, 
        cart_items: List[tuple]
    ) -&gt; Order:
        &quot;&quot;&quot;Create order from shopping cart items&quot;&quot;&quot;
        order = OrderFactory.create_draft_order(customer_id)
        
        for product_id_str, quantity, unit_price_amount in cart_items:
            product_id = ProductId(product_id_str)
            unit_price = Money(unit_price_amount, &quot;USD&quot;)
            order.add_item(product_id, quantity, unit_price)
        
        return order
    
    @staticmethod
    def create_order_with_items(
        customer_id: CustomerId,
        items: List[tuple]
    ) -&gt; Order:
        &quot;&quot;&quot;Create order with specific items&quot;&quot;&quot;
        order = OrderFactory.create_draft_order(customer_id)
        
        for product_id_str, quantity, unit_price_amount in items:
            product_id = ProductId(product_id_str)
            unit_price = Money(unit_price_amount, &quot;USD&quot;)
            order.add_item(product_id, quantity, unit_price)
        
        return order

class CustomerFactory:
    &quot;&quot;&quot;Factory for creating customers with different strategies&quot;&quot;&quot;
    
    @staticmethod
    def create_standard_customer(name: str, email: str) -&gt; Customer:
        &quot;&quot;&quot;Create a standard customer&quot;&quot;&quot;
        customer_id = CustomerId.generate()
        email_address = EmailAddress(email)
        customer = Customer(customer_id, name, email_address)
        customer.activate()
        return customer
    
    @staticmethod
    def create_vip_customer(name: str, email: str) -&gt; Customer:
        &quot;&quot;&quot;Create a VIP customer&quot;&quot;&quot;
        customer_id = CustomerId.generate()
        email_address = EmailAddress(email)
        customer = Customer(customer_id, name, email_address)
        customer.activate()
        # VIP customers start with some benefits
        customer._total_spent = Money(1000, &#39;USD&#39;)  # Start as VIP
        return customer
    
    @staticmethod
    def create_customer_from_data(data: Dict[str, Any]) -&gt; Customer:
        &quot;&quot;&quot;Create customer from data dictionary&quot;&quot;&quot;
        customer_id = CustomerId(data[&#39;id&#39;])
        email_address = EmailAddress(data[&#39;email&#39;])
        customer = Customer(customer_id, data[&#39;name&#39;], email_address)
        
        # Set status
        if data.get(&#39;status&#39;) == &#39;Active&#39;:
            customer.activate()
        elif data.get(&#39;status&#39;) == &#39;Suspended&#39;:
            customer.suspend()
        elif data.get(&#39;status&#39;) == &#39;Inactive&#39;:
            customer.deactivate()
        
        return customer

# ❌ BAD: Anemic Domain Model
class BadOrder:
    &quot;&quot;&quot;Example of anemic domain model - only data, no behavior&quot;&quot;&quot;
    
    def __init__(self, order_id: str, customer_id: str):
        self.id = order_id
        self.customer_id = customer_id
        self.items = []
        self.status = &quot;Draft&quot;
        self.total_amount = 0.0
        self.created_at = datetime.utcnow()
    
    # ❌ No business logic - just data access
    def add_item(self, product_id: str, quantity: int, unit_price: float):
        # Business logic should be in the domain object
        if self.status != &quot;Draft&quot;:
            raise ValueError(&quot;Cannot modify confirmed order&quot;)
        # ... rest of logic scattered elsewhere

# ❌ BAD: Primitive Obsession
class BadCustomer:
    &quot;&quot;&quot;Example of primitive obsession - using primitives instead of domain types&quot;&quot;&quot;
    
    def __init__(self, name: str, email: str):
        self.name = name
        self.email = email  # ❌ Using primitive string
    
    def send_email(self, subject: str, body: str):
        # ❌ No validation, no type safety
        if &#39;@&#39; not in self.email:
            raise ValueError(&quot;Invalid email&quot;)
        # ... rest of logic

# ❌ BAD: Validation Scattered
class BadEmailValidator:
    &quot;&quot;&quot;Example of scattered validation logic&quot;&quot;&quot;
    
    def validate_email(self, email: str) -&gt; bool:
        # ❌ Validation logic scattered across multiple classes
        if not email:
            return False
        
        if &#39;@&#39; not in email:
            return False
        
        # More validation logic scattered elsewhere
        return True

# Example usage
if __name__ == &quot;__main__&quot;:
    # Create order using factory
    customer_id = CustomerId(&quot;customer-123&quot;)
    order = OrderFactory.create_draft_order(customer_id)
    
    # Add items
    product1 = ProductId(&quot;product-1&quot;)
    product2 = ProductId(&quot;product-2&quot;)
    
    order.add_item(product1, 2, Money(15.99, &quot;USD&quot;))
    order.add_item(product2, 1, Money(25.50, &quot;USD&quot;))
    
    print(f&quot;Order created: {order}&quot;)
    print(f&quot;Total amount: {order.total_amount}&quot;)
    print(f&quot;Can be confirmed: {order.can_be_confirmed()}&quot;)
    
    # Confirm order
    order.confirm()
    print(f&quot;Order confirmed: {order}&quot;)
    print(f&quot;Can be shipped: {order.can_be_shipped()}&quot;)
    
    # Create customer
    customer = CustomerFactory.create_standard_customer(&quot;John Doe&quot;, &quot;john.doe@example.com&quot;)
    print(f&quot;Customer created: {customer}&quot;)
    print(f&quot;Customer type: {customer.get_customer_type()}&quot;)
    
    # Create pricing service
    pricing_service = PricingService()
    address = Address(&quot;123 Main St&quot;, &quot;Anytown&quot;, &quot;CA&quot;, &quot;US&quot;, &quot;12345&quot;)
    
    # Calculate order total
    total = pricing_service.calculate_order_total(order, customer, address)
    print(f&quot;Order total with tax and shipping: {total}&quot;)
    
    # Test specification
    order_spec = OrderSpecification()
    print(f&quot;Order can be confirmed: {order_spec.can_be_confirmed(order)}&quot;)
    print(f&quot;Order can be shipped: {order_spec.can_be_shipped(order)}&quot;)
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Best Practices for Domain Modeling</h3>
<h4>1. <strong>Keep Domain Logic Pure</strong></h4>
<ul>
<li>✅ Domain objects should not depend on external frameworks</li>
<li>✅ Business rules are encapsulated in domain objects</li>
<li>✅ Pure functions for calculations and transformations</li>
</ul>
<h4>2. <strong>Use Rich Domain Models</strong></h4>
<ul>
<li>✅ Domain objects contain both data and behavior</li>
<li>✅ Business logic is contained within the objects that own the data</li>
<li>✅ Methods express business operations clearly</li>
</ul>
<h4>3. <strong>Validate at Domain Boundaries</strong></h4>
<ul>
<li>✅ Domain objects validate their state and enforce business rules</li>
<li>✅ Validation happens at the domain boundary</li>
<li>✅ Clear error messages for business rule violations</li>
</ul>
<h4>4. <strong>Use Value Objects for Complex Types</strong></h4>
<ul>
<li>✅ Value objects represent complex concepts and ensure consistency</li>
<li>✅ Immutable objects with value-based equality</li>
<li>✅ Factory methods for common values</li>
</ul>
<h4>5. <strong>Design for Testability</strong></h4>
<ul>
<li>✅ Minimize external dependencies</li>
<li>✅ Clear interfaces for dependencies</li>
<li>✅ Pure functions where possible</li>
<li>✅ Dependency injection for external services</li>
</ul>
<h3>Domain Modeling Patterns</h3>
<h4><strong>Aggregate Root Pattern</strong></h4>
<ul>
<li>✅ Encapsulates business rules and invariants</li>
<li>✅ Manages domain events</li>
<li>✅ Controls access to aggregate members</li>
</ul>
<h4><strong>Domain Events</strong></h4>
<ul>
<li>✅ Communicate significant business events</li>
<li>✅ Enable loose coupling between aggregates</li>
<li>✅ Support eventual consistency</li>
</ul>
<h4><strong>Specification Pattern</strong></h4>
<ul>
<li>✅ Encapsulate complex business rules</li>
<li>✅ Reusable business logic</li>
<li>✅ Clear expression of business constraints</li>
</ul>
<h4><strong>Factory Pattern</strong></h4>
<ul>
<li>✅ Complex object creation logic</li>
<li>✅ Consistent object initialization</li>
<li>✅ Hide creation complexity</li>
</ul>
<h3>Python Benefits for Domain Modeling</h3>
<ul>
<li><strong>Dataclasses</strong>: Clean, concise class definitions with <code>@dataclass</code></li>
<li><strong>Frozen Dataclasses</strong>: Immutable objects with <code>frozen=True</code></li>
<li><strong>Type Hints</strong>: Better IDE support and documentation</li>
<li><strong>Enums</strong>: Type-safe status and state management</li>
<li><strong>Properties</strong>: Clean access to encapsulated data</li>
<li><strong>Method Chaining</strong>: Fluent interfaces for operations</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Anemic Domain Model</strong></h4>
<ul>
<li>❌ Domain objects contain only data</li>
<li>❌ Business logic in external services</li>
<li>❌ No encapsulation of business rules</li>
</ul>
<h4><strong>Primitive Obsession</strong></h4>
<ul>
<li>❌ Using primitives instead of domain types</li>
<li>❌ No type safety for business concepts</li>
<li>❌ Scattered validation logic</li>
</ul>
<h4><strong>Validation Scattered</strong></h4>
<ul>
<li>❌ Validation logic spread across layers</li>
<li>❌ Inconsistent business rule enforcement</li>
<li>❌ Hard to maintain and test</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Example of good entity design</li>
<li><a href="./03-order-entity.md">Order Entity</a> - Rich domain model example</li>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Value object best practices</li>
<li><a href="./04-email-address-value-object.md">EmailAddress Value Object</a> - Validation example</li>
<li><a href="./05-pricing-service.md">Pricing Service</a> - Domain service example</li>
<li><a href="./06-customer-module.md">Customer Module</a> - Module organization</li>
<li><a href="../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling">Best Practices for Domain Modeling</a> - Domain modeling concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 12-testing-best-practices.md</li>
<li>Next: N/A</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling">Best Practices for Domain Modeling</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"13-domain-modeling-best-practices"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"13-domain-modeling-best-practices\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
