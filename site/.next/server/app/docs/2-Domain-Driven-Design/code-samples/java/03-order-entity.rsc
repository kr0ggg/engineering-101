1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/03-order-entity","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"03-order-entity\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T67d8,<h1>Order Entity - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#business-logic-encapsulation">Business Logic Encapsulation</a></p>
<p><strong>Navigation</strong>: <a href="./01-customer-entity.md">← Previous: Customer Entity</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - Order Entity with Business Logic Encapsulation
// File: 2-Domain-Driven-Design/code-samples/java/03-order-entity.java

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

// ✅ GOOD: Rich Domain Model with Behavior
public enum OrderStatus {
    DRAFT(&quot;Draft&quot;),
    CONFIRMED(&quot;Confirmed&quot;),
    SHIPPED(&quot;Shipped&quot;),
    DELIVERED(&quot;Delivered&quot;),
    CANCELLED(&quot;Cancelled&quot;);
    
    private final String value;
    
    OrderStatus(String value) {
        this.value = value;
    }
    
    public String getValue() {
        return value;
    }
}

// ✅ GOOD: Value Objects for Identity
public class OrderId {
    private final String value;
    
    private OrderId(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(&quot;Order ID cannot be null or empty&quot;);
        }
        this.value = value.trim();
    }
    
    public static OrderId generate() {
        return new OrderId(UUID.randomUUID().toString());
    }
    
    public static OrderId of(String value) {
        return new OrderId(value);
    }
    
    public String getValue() {
        return value;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        OrderId orderId = (OrderId) obj;
        return Objects.equals(value, orderId.value);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(value);
    }
    
    @Override
    public String toString() {
        return value;
    }
}

public class CustomerId {
    private final String value;
    
    private CustomerId(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(&quot;Customer ID cannot be null or empty&quot;);
        }
        this.value = value.trim();
    }
    
    public static CustomerId of(String value) {
        return new CustomerId(value);
    }
    
    public String getValue() {
        return value;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        CustomerId customerId = (CustomerId) obj;
        return Objects.equals(value, customerId.value);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(value);
    }
    
    @Override
    public String toString() {
        return value;
    }
}

public class ProductId {
    private final String value;
    
    private ProductId(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(&quot;Product ID cannot be null or empty&quot;);
        }
        this.value = value.trim();
    }
    
    public static ProductId of(String value) {
        return new ProductId(value);
    }
    
    public String getValue() {
        return value;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        ProductId productId = (ProductId) obj;
        return Objects.equals(value, productId.value);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(value);
    }
    
    @Override
    public String toString() {
        return value;
    }
}

// ✅ GOOD: Value Object for Money
public class Money {
    private final double amount;
    private final String currency;
    
    private Money(double amount, String currency) {
        if (amount &lt; 0) {
            throw new IllegalArgumentException(&quot;Amount cannot be negative&quot;);
        }
        if (currency == null || currency.trim().isEmpty()) {
            throw new IllegalArgumentException(&quot;Currency cannot be null or empty&quot;);
        }
        this.amount = amount;
        this.currency = currency.trim();
    }
    
    public static Money of(double amount, String currency) {
        return new Money(amount, currency);
    }
    
    public static Money zero(String currency) {
        return new Money(0.0, currency);
    }
    
    public Money add(Money other) {
        if (!this.currency.equals(other.currency)) {
            throw new IllegalArgumentException(&quot;Cannot add different currencies&quot;);
        }
        return new Money(this.amount + other.amount, this.currency);
    }
    
    public Money subtract(Money other) {
        if (!this.currency.equals(other.currency)) {
            throw new IllegalArgumentException(&quot;Cannot subtract different currencies&quot;);
        }
        return new Money(this.amount - other.amount, this.currency);
    }
    
    public Money multiply(double factor) {
        if (factor &lt; 0) {
            throw new IllegalArgumentException(&quot;Factor cannot be negative&quot;);
        }
        return new Money(this.amount * factor, this.currency);
    }
    
    public double getAmount() {
        return amount;
    }
    
    public String getCurrency() {
        return currency;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Money money = (Money) obj;
        return Double.compare(money.amount, amount) == 0 &amp;&amp;
               Objects.equals(currency, money.currency);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(amount, currency);
    }
    
    @Override
    public String toString() {
        return String.format(&quot;%s %.2f&quot;, currency, amount);
    }
}

// ✅ GOOD: Value Object for Order Item
public class OrderItem {
    private final ProductId productId;
    private final int quantity;
    private final Money unitPrice;
    
    public OrderItem(ProductId productId, int quantity, Money unitPrice) {
        if (productId == null) {
            throw new IllegalArgumentException(&quot;Product ID cannot be null&quot;);
        }
        if (quantity &lt;= 0) {
            throw new IllegalArgumentException(&quot;Quantity must be positive&quot;);
        }
        if (unitPrice == null) {
            throw new IllegalArgumentException(&quot;Unit price cannot be null&quot;);
        }
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }
    
    public ProductId getProductId() {
        return productId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public Money getUnitPrice() {
        return unitPrice;
    }
    
    public Money getTotalPrice() {
        return unitPrice.multiply(quantity);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        OrderItem orderItem = (OrderItem) obj;
        return quantity == orderItem.quantity &amp;&amp;
               Objects.equals(productId, orderItem.productId) &amp;&amp;
               Objects.equals(unitPrice, orderItem.unitPrice);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(productId, quantity, unitPrice);
    }
    
    @Override
    public String toString() {
        return String.format(&quot;OrderItem{productId=%s, quantity=%d, unitPrice=%s}&quot;,
                productId, quantity, unitPrice);
    }
}

// ✅ GOOD: Domain Entity with Rich Behavior
public class Order {
    private final OrderId id;
    private final CustomerId customerId;
    private final LocalDateTime createdAt;
    private final List&lt;OrderItem&gt; items;
    private OrderStatus status;
    private LocalDateTime confirmedAt;
    private LocalDateTime shippedAt;
    
    public Order(OrderId id, CustomerId customerId) {
        this(id, customerId, LocalDateTime.now());
    }
    
    public Order(OrderId id, CustomerId customerId, LocalDateTime createdAt) {
        if (id == null) {
            throw new IllegalArgumentException(&quot;Order ID cannot be null&quot;);
        }
        if (customerId == null) {
            throw new IllegalArgumentException(&quot;Customer ID cannot be null&quot;);
        }
        if (createdAt == null) {
            throw new IllegalArgumentException(&quot;Created at cannot be null&quot;);
        }
        
        this.id = id;
        this.customerId = customerId;
        this.createdAt = createdAt;
        this.items = new ArrayList&lt;&gt;();
        this.status = OrderStatus.DRAFT;
    }
    
    // ✅ Identity properties
    public OrderId getId() {
        return id;
    }
    
    public CustomerId getCustomerId() {
        return customerId;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public OrderStatus getStatus() {
        return status;
    }
    
    public List&lt;OrderItem&gt; getItems() {
        return new ArrayList&lt;&gt;(items); // Return copy to maintain encapsulation
    }
    
    public int getItemCount() {
        return items.size();
    }
    
    public Money getTotalAmount() {
        if (items.isEmpty()) {
            return Money.zero(&quot;USD&quot;);
        }
        
        Money total = items.get(0).getTotalPrice();
        for (int i = 1; i &lt; items.size(); i++) {
            total = total.add(items.get(i).getTotalPrice());
        }
        return total;
    }
    
    // ✅ Business Logic Encapsulation
    public void addItem(ProductId productId, int quantity, Money unitPrice) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException(&quot;Cannot modify confirmed order&quot;);
        }
        
        if (quantity &lt;= 0) {
            throw new IllegalArgumentException(&quot;Quantity must be positive&quot;);
        }
        
        // Business rule: Check if item already exists
        int existingItemIndex = findItemIndex(productId);
        
        if (existingItemIndex &gt;= 0) {
            // Update existing item quantity
            OrderItem existingItem = items.get(existingItemIndex);
            int newQuantity = existingItem.getQuantity() + quantity;
            OrderItem updatedItem = new OrderItem(productId, newQuantity, unitPrice);
            items.set(existingItemIndex, updatedItem);
        } else {
            // Add new item
            OrderItem newItem = new OrderItem(productId, quantity, unitPrice);
            items.add(newItem);
        }
    }
    
    public void removeItem(ProductId productId) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException(&quot;Cannot modify confirmed order&quot;);
        }
        
        int itemIndex = findItemIndex(productId);
        if (itemIndex &gt;= 0) {
            items.remove(itemIndex);
        } else {
            throw new IllegalArgumentException(&quot;Item not found in order&quot;);
        }
    }
    
    public void updateItemQuantity(ProductId productId, int newQuantity) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException(&quot;Cannot modify confirmed order&quot;);
        }
        
        if (newQuantity &lt;= 0) {
            throw new IllegalArgumentException(&quot;Quantity must be positive&quot;);
        }
        
        int itemIndex = findItemIndex(productId);
        if (itemIndex &gt;= 0) {
            OrderItem existingItem = items.get(itemIndex);
            OrderItem updatedItem = new OrderItem(productId, newQuantity, existingItem.getUnitPrice());
            items.set(itemIndex, updatedItem);
        } else {
            throw new IllegalArgumentException(&quot;Item not found in order&quot;);
        }
    }
    
    public void confirm() {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException(&quot;Order is not in draft status&quot;);
        }
        
        if (items.isEmpty()) {
            throw new IllegalStateException(&quot;Cannot confirm empty order&quot;);
        }
        
        // Business rule: Minimum order amount
        if (getTotalAmount().getAmount() &lt; 10.0) {
            throw new IllegalStateException(&quot;Order amount must be at least $10.00&quot;);
        }
        
        this.status = OrderStatus.CONFIRMED;
        this.confirmedAt = LocalDateTime.now();
    }
    
    public void ship() {
        if (status != OrderStatus.CONFIRMED) {
            throw new IllegalStateException(&quot;Order must be confirmed before shipping&quot;);
        }
        
        this.status = OrderStatus.SHIPPED;
        this.shippedAt = LocalDateTime.now();
    }
    
    public void deliver() {
        if (status != OrderStatus.SHIPPED) {
            throw new IllegalStateException(&quot;Order must be shipped before delivery&quot;);
        }
        
        this.status = OrderStatus.DELIVERED;
    }
    
    public void cancel() {
        if (status == OrderStatus.SHIPPED || status == OrderStatus.DELIVERED) {
            throw new IllegalStateException(&quot;Cannot cancel shipped or delivered order&quot;);
        }
        
        this.status = OrderStatus.CANCELLED;
    }
    
    // ✅ Business Rules as Methods
    public boolean canBeModified() {
        return status == OrderStatus.DRAFT;
    }
    
    public boolean canBeConfirmed() {
        return status == OrderStatus.DRAFT &amp;&amp; 
               !items.isEmpty() &amp;&amp; 
               getTotalAmount().getAmount() &gt;= 10.0;
    }
    
    public boolean canBeShipped() {
        return status == OrderStatus.CONFIRMED;
    }
    
    public boolean canBeDelivered() {
        return status == OrderStatus.SHIPPED;
    }
    
    public boolean canBeCancelled() {
        return status == OrderStatus.DRAFT || status == OrderStatus.CONFIRMED;
    }
    
    // ✅ Helper methods
    private int findItemIndex(ProductId productId) {
        for (int i = 0; i &lt; items.size(); i++) {
            if (items.get(i).getProductId().equals(productId)) {
                return i;
            }
        }
        return -1;
    }
    
    public OrderItem getItemByProductId(ProductId productId) {
        int itemIndex = findItemIndex(productId);
        return itemIndex &gt;= 0 ? items.get(itemIndex) : null;
    }
    
    public boolean hasItem(ProductId productId) {
        return findItemIndex(productId) &gt;= 0;
    }
    
    // ✅ Domain Events (simplified)
    public List&lt;String&gt; getDomainEvents() {
        List&lt;String&gt; events = new ArrayList&lt;&gt;();
        if (status == OrderStatus.CONFIRMED) {
            events.add(&quot;OrderConfirmed&quot;);
        }
        if (status == OrderStatus.SHIPPED) {
            events.add(&quot;OrderShipped&quot;);
        }
        if (status == OrderStatus.DELIVERED) {
            events.add(&quot;OrderDelivered&quot;);
        }
        if (status == OrderStatus.CANCELLED) {
            events.add(&quot;OrderCancelled&quot;);
        }
        return events;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Order order = (Order) obj;
        return Objects.equals(id, order.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    @Override
    public String toString() {
        return String.format(&quot;Order{id=%s, customerId=%s, status=%s, items=%d, total=%s}&quot;,
                id, customerId, status.getValue(), items.size(), getTotalAmount());
    }
}

// ❌ BAD: Anemic Domain Model
class BadOrder {
    // ❌ Only data, no behavior
    public String id;
    public String customerId;
    public List&lt;Object&gt; items;
    public String status;
    public double totalAmount;
    public LocalDateTime createdAt;
    
    public BadOrder(String id, String customerId) {
        this.id = id;
        this.customerId = customerId;
        this.items = new ArrayList&lt;&gt;();
        this.status = &quot;Draft&quot;;
        this.totalAmount = 0.0;
        this.createdAt = LocalDateTime.now();
    }
    
    // ❌ Business logic in external service
    public void addItem(String productId, int quantity, double unitPrice) {
        // Business logic should be in the domain object
        if (!&quot;Draft&quot;.equals(status)) {
            throw new IllegalArgumentException(&quot;Cannot modify confirmed order&quot;);
        }
        // ... rest of logic
    }
}

// ✅ GOOD: Domain Service for Complex Business Logic
class OrderPricingService {
    // ✅ Stateless service - no instance variables
    public Money calculateOrderTotal(Order order, Customer customer, Address shippingAddress) {
        if (!customer.isActive()) {
            throw new IllegalArgumentException(&quot;Cannot calculate pricing for inactive customer&quot;);
        }
        
        // ✅ Pure function - same inputs always produce same outputs
        Money total = order.getTotalAmount();
        total = applyCustomerDiscount(total, customer);
        total = applyBulkDiscount(total, order);
        
        Money tax = calculateTax(total, shippingAddress);
        Money shipping = calculateShipping(order, shippingAddress);
        
        return total.add(tax).add(shipping);
    }
    
    // ✅ Private methods for complex calculations
    private Money applyCustomerDiscount(Money total, Customer customer) {
        double discountRate = getCustomerDiscountRate(customer.getCustomerType());
        Money discountAmount = total.multiply(discountRate);
        return total.subtract(discountAmount);
    }
    
    private double getCustomerDiscountRate(String customerType) {
        switch (customerType) {
            case &quot;VIP&quot;: return 0.15;
            case &quot;Premium&quot;: return 0.10;
            case &quot;Standard&quot;: return 0.05;
            default: return 0.05;
        }
    }
    
    private Money applyBulkDiscount(Money total, Order order) {
        if (total.getAmount() &gt;= 1000) {
            return total.multiply(0.10);
        } else if (total.getAmount() &gt;= 500) {
            return total.multiply(0.05);
        } else if (total.getAmount() &gt;= 100) {
            return total.multiply(0.02);
        }
        return Money.zero(total.getCurrency());
    }
    
    private Money calculateTax(Money amount, Address address) {
        // Simplified tax calculation
        if (&quot;US&quot;.equals(address.getCountry())) {
            return amount.multiply(0.08);
        }
        return Money.zero(amount.getCurrency());
    }
    
    private Money calculateShipping(Order order, Address address) {
        // Simplified shipping calculation
        if (&quot;US&quot;.equals(address.getCountry())) {
            return Money.of(5.99, &quot;USD&quot;);
        }
        return Money.of(15.99, &quot;USD&quot;);
    }
}

// ✅ GOOD: Factory for Complex Object Creation
class OrderFactory {
    public static Order createDraftOrder(CustomerId customerId) {
        OrderId orderId = OrderId.generate();
        return new Order(orderId, customerId);
    }
    
    public static Order createOrderFromCart(CustomerId customerId, List&lt;CartItem&gt; cartItems) {
        Order order = createDraftOrder(customerId);
        
        for (CartItem cartItem : cartItems) {
            ProductId productId = ProductId.of(cartItem.getProductId());
            Money unitPrice = Money.of(cartItem.getUnitPrice(), &quot;USD&quot;);
            order.addItem(productId, cartItem.getQuantity(), unitPrice);
        }
        
        return order;
    }
}

// ✅ GOOD: Specification Pattern for Complex Business Rules
class OrderSpecification {
    public boolean canBeConfirmed(Order order) {
        return order.getStatus() == OrderStatus.DRAFT &amp;&amp;
               !order.getItems().isEmpty() &amp;&amp;
               order.getTotalAmount().getAmount() &gt;= 10.0 &amp;&amp;
               hasValidItems(order);
    }
    
    public boolean canBeShipped(Order order) {
        return order.getStatus() == OrderStatus.CONFIRMED &amp;&amp;
               hasShippingAddress(order) &amp;&amp;
               allItemsInStock(order);
    }
    
    private boolean hasValidItems(Order order) {
        return order.getItems().stream()
                .allMatch(item -&gt; item.getQuantity() &gt; 0);
    }
    
    private boolean hasShippingAddress(Order order) {
        // Simplified - would check actual address
        return true;
    }
    
    private boolean allItemsInStock(Order order) {
        // Simplified - would check inventory
        return true;
    }
}

// Example usage
public class OrderExample {
    public static void main(String[] args) {
        // Create order
        CustomerId customerId = CustomerId.of(&quot;customer-123&quot;);
        Order order = OrderFactory.createDraftOrder(customerId);
        
        // Add items
        ProductId product1 = ProductId.of(&quot;product-1&quot;);
        ProductId product2 = ProductId.of(&quot;product-2&quot;);
        
        order.addItem(product1, 2, Money.of(15.99, &quot;USD&quot;));
        order.addItem(product2, 1, Money.of(25.50, &quot;USD&quot;));
        
        System.out.println(&quot;Order created: &quot; + order);
        System.out.println(&quot;Total amount: &quot; + order.getTotalAmount());
        System.out.println(&quot;Can be confirmed: &quot; + order.canBeConfirmed());
        
        // Confirm order
        order.confirm();
        System.out.println(&quot;Order confirmed: &quot; + order);
        System.out.println(&quot;Can be shipped: &quot; + order.canBeShipped());
        
        // Ship order
        order.ship();
        System.out.println(&quot;Order shipped: &quot; + order);
        System.out.println(&quot;Can be delivered: &quot; + order.canBeDelivered());
        
        // Deliver order
        order.deliver();
        System.out.println(&quot;Order delivered: &quot; + order);
    }
}
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
<li>✅ Operations like addItem, confirm, ship are methods</li>
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
<h3>Java Benefits for Domain Modeling</h3>
<ul>
<li><strong>Strong Typing</strong>: Compile-time type checking</li>
<li><strong>Immutability</strong>: Final fields and immutable value objects</li>
<li><strong>Encapsulation</strong>: Private fields with public methods</li>
<li><strong>Method Chaining</strong>: Fluent interfaces for operations</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
<li><strong>Collections</strong>: Rich collection framework for managing items</li>
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
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/03-order-entity","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"03-order-entity"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"03-order-entity\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/03-order-entity","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
