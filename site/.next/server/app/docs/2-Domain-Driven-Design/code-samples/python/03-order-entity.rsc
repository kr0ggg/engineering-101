1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/03-order-entity","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"03-order-entity\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T5211,<h1>Order Entity - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#business-logic-encapsulation">Business Logic Encapsulation</a></p>
<p><strong>Navigation</strong>: <a href="./01-customer-entity.md">← Previous: Customer Entity</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - Order Entity with Business Logic Encapsulation
# File: 2-Domain-Driven-Design/code-samples/python/03-order-entity.py

from datetime import datetime
from typing import List, Optional
from dataclasses import dataclass, field
from enum import Enum
import uuid

# ✅ GOOD: Rich Domain Model with Behavior
class OrderStatus(Enum):
    DRAFT = &quot;Draft&quot;
    CONFIRMED = &quot;Confirmed&quot;
    SHIPPED = &quot;Shipped&quot;
    DELIVERED = &quot;Delivered&quot;
    CANCELLED = &quot;Cancelled&quot;

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
    
    def multiply(self, factor: float) -&gt; &#39;Money&#39;:
        if factor &lt; 0:
            raise ValueError(&quot;Factor cannot be negative&quot;)
        return Money(self.amount * factor, self.currency)
    
    def __str__(self) -&gt; str:
        return f&quot;{self.currency} {self.amount:.2f}&quot;

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
            return Money(0, &quot;USD&quot;)
        
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
    
    def remove_item(self, product_id: ProductId) -&gt; None:
        &quot;&quot;&quot;Remove an item from the order&quot;&quot;&quot;
        if self._status != OrderStatus.DRAFT:
            raise ValueError(&quot;Cannot modify confirmed order&quot;)
        
        item_index = self._find_item_index(product_id)
        if item_index &gt;= 0:
            del self._items[item_index]
        else:
            raise ValueError(&quot;Item not found in order&quot;)
    
    def update_item_quantity(self, product_id: ProductId, new_quantity: int) -&gt; None:
        &quot;&quot;&quot;Update the quantity of an existing item&quot;&quot;&quot;
        if self._status != OrderStatus.DRAFT:
            raise ValueError(&quot;Cannot modify confirmed order&quot;)
        
        if new_quantity &lt;= 0:
            raise ValueError(&quot;Quantity must be positive&quot;)
        
        item_index = self._find_item_index(product_id)
        if item_index &gt;= 0:
            existing_item = self._items[item_index]
            updated_item = OrderItem(product_id, new_quantity, existing_item.unit_price)
            self._items[item_index] = updated_item
        else:
            raise ValueError(&quot;Item not found in order&quot;)
    
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
    
    def ship(self) -&gt; None:
        &quot;&quot;&quot;Mark the order as shipped&quot;&quot;&quot;
        if self._status != OrderStatus.CONFIRMED:
            raise ValueError(&quot;Order must be confirmed before shipping&quot;)
        
        self._status = OrderStatus.SHIPPED
        self._shipped_at = datetime.utcnow()
    
    def deliver(self) -&gt; None:
        &quot;&quot;&quot;Mark the order as delivered&quot;&quot;&quot;
        if self._status != OrderStatus.SHIPPED:
            raise ValueError(&quot;Order must be shipped before delivery&quot;)
        
        self._status = OrderStatus.DELIVERED
    
    def cancel(self) -&gt; None:
        &quot;&quot;&quot;Cancel the order&quot;&quot;&quot;
        if self._status in [OrderStatus.SHIPPED, OrderStatus.DELIVERED]:
            raise ValueError(&quot;Cannot cancel shipped or delivered order&quot;)
        
        self._status = OrderStatus.CANCELLED
    
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
    
    # ✅ String representation for debugging
    def __str__(self) -&gt; str:
        return (f&quot;Order(id={self._id}, customer_id={self._customer_id}, &quot;
                f&quot;status={self._status.value}, items={len(self._items)}, &quot;
                f&quot;total={self.total_amount})&quot;)
    
    def __repr__(self) -&gt; str:
        return self.__str__()

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

# ✅ GOOD: Domain Service for Complex Business Logic
class OrderPricingService:
    &quot;&quot;&quot;Domain service for complex pricing calculations&quot;&quot;&quot;
    
    def calculate_discount(self, order: Order, customer_type: str) -&gt; Money:
        &quot;&quot;&quot;Calculate discount based on customer type and order amount&quot;&quot;&quot;
        base_amount = order.total_amount
        
        if customer_type == &quot;VIP&quot;:
            discount_rate = 0.15
        elif customer_type == &quot;Premium&quot;:
            discount_rate = 0.10
        elif customer_type == &quot;Standard&quot;:
            discount_rate = 0.05
        else:
            discount_rate = 0.0
        
        discount_amount = base_amount.multiply(discount_rate)
        return discount_amount
    
    def calculate_shipping(self, order: Order, shipping_address: str) -&gt; Money:
        &quot;&quot;&quot;Calculate shipping cost based on order and destination&quot;&quot;&quot;
        base_shipping = Money(5.99, &quot;USD&quot;)
        
        # Free shipping for orders over $50
        if order.total_amount.amount &gt;= 50.0:
            return Money(0, &quot;USD&quot;)
        
        # Additional cost for heavy items
        total_weight = sum(item.quantity * 0.5 for item in order.items)  # Simplified
        if total_weight &gt; 10:
            return base_shipping.add(Money(2.99, &quot;USD&quot;))
        
        return base_shipping

# ✅ GOOD: Factory for Complex Object Creation
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

# Example usage
if __name__ == &quot;__main__&quot;:
    # Create order
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
    
    # Ship order
    order.ship()
    print(f&quot;Order shipped: {order}&quot;)
    print(f&quot;Can be delivered: {order.can_be_delivered()}&quot;)
    
    # Deliver order
    order.deliver()
    print(f&quot;Order delivered: {order}&quot;)
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Business Logic Encapsulation</h3>
<h4>1. <strong>Rich Domain Models</strong></h4>
<ul>
<li>✅ Domain objects contain both data and behavior</li>
<li>✅ Business logic is encapsulated within the objects that own the data</li>
<li>✅ Methods express business operations clearly</li>
</ul>
<h4>2. <strong>Business Rules as Methods</strong></h4>
<ul>
<li>✅ Business rules are expressed as methods on domain objects</li>
<li>✅ Validation happens at the domain boundary</li>
<li>✅ Clear error messages for business rule violations</li>
</ul>
<h4>3. <strong>State Management</strong></h4>
<ul>
<li>✅ Order status is managed through business operations</li>
<li>✅ State transitions are controlled by business rules</li>
<li>✅ Invalid state transitions are prevented</li>
</ul>
<h4>4. <strong>Domain Events</strong></h4>
<ul>
<li>✅ Significant business events are captured</li>
<li>✅ Events can be used for integration and notifications</li>
<li>✅ Domain events maintain consistency</li>
</ul>
<h3>Order Entity Design Principles</h3>
<h4><strong>Identity Management</strong></h4>
<ul>
<li>✅ Order has a unique identity (OrderId)</li>
<li>✅ Identity is immutable and generated</li>
<li>✅ Identity distinguishes orders from each other</li>
</ul>
<h4><strong>Business Logic Encapsulation</strong></h4>
<ul>
<li>✅ Order contains all business rules for order management</li>
<li>✅ Operations like add_item, confirm, ship are methods</li>
<li>✅ Business rules prevent invalid operations</li>
</ul>
<h4><strong>State Management</strong></h4>
<ul>
<li>✅ Order status is managed through business operations</li>
<li>✅ State transitions follow business rules</li>
<li>✅ Invalid transitions are prevented</li>
</ul>
<h4><strong>Value Objects</strong></h4>
<ul>
<li>✅ OrderId, CustomerId, ProductId are value objects</li>
<li>✅ Money is a value object with business operations</li>
<li>✅ OrderItem is a value object representing order line items</li>
</ul>
<h3>Python Benefits for Domain Modeling</h3>
<ul>
<li><strong>Dataclasses</strong>: Clean, concise class definitions</li>
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
<h4><strong>God Object</strong></h4>
<ul>
<li>❌ Single object with too many responsibilities</li>
<li>❌ Hard to understand and maintain</li>
<li>❌ Violates Single Responsibility Principle</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Basic entity design</li>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Value object example</li>
<li><a href="./04-email-address-value-object.md">EmailAddress Value Object</a> - Validation example</li>
<li><a href="../../1-introduction-to-the-domain.md#business-logic-encapsulation">Business Logic Encapsulation</a> - Business logic concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 01-customer-entity.md</li>
<li>Next: 04-email-address-value-object.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#business-logic-encapsulation">Business Logic Encapsulation</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/03-order-entity","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"03-order-entity"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"03-order-entity\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/03-order-entity","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
