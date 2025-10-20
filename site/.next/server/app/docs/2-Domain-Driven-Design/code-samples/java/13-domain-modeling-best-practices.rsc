1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"13-domain-modeling-best-practices\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T8cd5,<h1>Domain Modeling Best Practices - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling">Best Practices for Domain Modeling</a></p>
<p><strong>Navigation</strong>: <a href="./12-testing-best-practices.md">← Previous: Testing Best Practices</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - Domain Modeling Best Practices
// File: 2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices.java

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

// ✅ GOOD: Domain Modeling Best Practices
@DisplayName(&quot;Domain Modeling Best Practices&quot;)
class DomainModelingBestPractices {
    
    // ✅ GOOD: Rich Domain Models with Behavior
    public static class Order {
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
    
    // ✅ GOOD: Immutable Value Objects
    public static class Money {
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
    
    // ✅ GOOD: Self-Validating Value Objects
    public static class EmailAddress {
        private static final Pattern EMAIL_PATTERN = Pattern.compile(
            &quot;^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$&quot;
        );
        
        private final String value;
        
        private EmailAddress(String value) {
            if (value == null || value.trim().isEmpty()) {
                throw new IllegalArgumentException(&quot;Email address cannot be null or empty&quot;);
            }
            
            String trimmedValue = value.trim();
            if (!isValidEmail(trimmedValue)) {
                throw new IllegalArgumentException(&quot;Invalid email address: &quot; + trimmedValue);
            }
            
            this.value = trimmedValue.toLowerCase(); // Normalize to lowercase
        }
        
        public static EmailAddress of(String value) {
            return new EmailAddress(value);
        }
        
        public String getValue() {
            return value;
        }
        
        // ✅ Self-Validation
        private boolean isValidEmail(String email) {
            return EMAIL_PATTERN.matcher(email).matches();
        }
        
        // ✅ Business Operations
        public String getDomain() {
            int atIndex = value.indexOf(&#39;@&#39;);
            if (atIndex == -1) {
                throw new IllegalStateException(&quot;Invalid email format&quot;);
            }
            return value.substring(atIndex + 1);
        }
        
        public String getLocalPart() {
            int atIndex = value.indexOf(&#39;@&#39;);
            if (atIndex == -1) {
                throw new IllegalStateException(&quot;Invalid email format&quot;);
            }
            return value.substring(0, atIndex);
        }
        
        public boolean isCorporateEmail() {
            String domain = getDomain();
            return domain.endsWith(&quot;.com&quot;) || 
                   domain.endsWith(&quot;.org&quot;) || 
                   domain.endsWith(&quot;.net&quot;);
        }
        
        public boolean isEducationalEmail() {
            String domain = getDomain();
            return domain.endsWith(&quot;.edu&quot;);
        }
        
        public boolean isGovernmentEmail() {
            String domain = getDomain();
            return domain.endsWith(&quot;.gov&quot;);
        }
        
        @Override
        public boolean equals(Object obj) {
            if (this == obj) return true;
            if (obj == null || getClass() != obj.getClass()) return false;
            EmailAddress that = (EmailAddress) obj;
            return Objects.equals(value, that.value);
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
    
    // ✅ GOOD: Domain Services for Complex Business Logic
    public static class PricingService {
        private final TaxCalculator taxCalculator;
        private final ShippingCalculator shippingCalculator;
        private final DiscountRuleRepository discountRuleRepository;
        
        public PricingService(
                TaxCalculator taxCalculator,
                ShippingCalculator shippingCalculator,
                DiscountRuleRepository discountRuleRepository) {
            this.taxCalculator = taxCalculator;
            this.shippingCalculator = shippingCalculator;
            this.discountRuleRepository = discountRuleRepository;
        }
        
        // ✅ Main business operation - calculates total order amount
        public Money calculateOrderTotal(Order order, Customer customer, Address shippingAddress) {
            if (!customer.isActive()) {
                throw new IllegalArgumentException(&quot;Cannot calculate pricing for inactive customer&quot;);
            }
            
            // Start with base order amount
            Money baseAmount = order.getTotalAmount();
            
            // Apply customer-specific discount
            Money discountedAmount = applyCustomerDiscount(baseAmount, customer);
            
            // Apply bulk discount
            Money bulkDiscountedAmount = applyBulkDiscount(discountedAmount, order);
            
            // Calculate tax
            Money taxAmount = taxCalculator.calculateTax(bulkDiscountedAmount, shippingAddress);
            
            // Calculate shipping
            Money shippingAmount = shippingCalculator.calculateShipping(order, shippingAddress);
            
            // Apply shipping discount if applicable
            Money finalShipping = applyShippingDiscount(shippingAmount, bulkDiscountedAmount);
            
            // Calculate final total
            Money finalTotal = bulkDiscountedAmount.add(taxAmount).add(finalShipping);
            
            return finalTotal;
        }
        
        // ✅ Private methods for complex business logic
        private Money applyCustomerDiscount(Money amount, Customer customer) {
            double discountRate = getCustomerDiscountRate(customer.getCustomerType());
            Money discountAmount = amount.multiply(discountRate);
            return amount.subtract(discountAmount);
        }
        
        private Money applyBulkDiscount(Money amount, Order order) {
            double discountRate = getBulkDiscountRate(amount.getAmount());
            Money discountAmount = amount.multiply(discountRate);
            return amount.subtract(discountAmount);
        }
        
        private Money applyShippingDiscount(Money shipping, Money orderAmount) {
            if (orderAmount.getAmount() &gt;= 50.0) {
                return Money.zero(shipping.getCurrency()); // Free shipping
            } else if (orderAmount.getAmount() &gt;= 25.0) {
                return shipping.multiply(0.5); // 50% off shipping
            } else {
                return shipping; // No discount
            }
        }
        
        private double getCustomerDiscountRate(String customerType) {
            return discountRuleRepository.getCustomerDiscountRate(customerType);
        }
        
        private double getBulkDiscountRate(double amount) {
            return discountRuleRepository.getBulkDiscountRate(amount);
        }
    }
    
    // ✅ GOOD: Factory for Complex Object Creation
    public static class OrderFactory {
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
    public static class OrderSpecification {
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
    
    // ✅ GOOD: Module Organization with Clear Boundaries
    public static class CustomerModule {
        
        // ✅ Domain Entities
        public static class Customer {
            private final CustomerId id;
            private String name;
            private EmailAddress email;
            private CustomerStatus status;
            private LocalDateTime createdAt;
            private LocalDateTime lastActivity;
            private int ordersCount;
            private Money totalSpent;
            
            public Customer(CustomerId id, String name, EmailAddress email) {
                if (id == null) {
                    throw new IllegalArgumentException(&quot;Customer ID cannot be null&quot;);
                }
                if (name == null || name.trim().isEmpty()) {
                    throw new IllegalArgumentException(&quot;Name cannot be null or empty&quot;);
                }
                if (email == null) {
                    throw new IllegalArgumentException(&quot;Email cannot be null&quot;);
                }
                
                this.id = id;
                this.name = name.trim();
                this.email = email;
                this.status = CustomerStatus.PENDING;
                this.createdAt = LocalDateTime.now();
                this.ordersCount = 0;
                this.totalSpent = Money.zero(&quot;USD&quot;);
            }
            
            // ✅ Business Operations
            public void activate() {
                if (status == CustomerStatus.SUSPENDED) {
                    throw new IllegalStateException(&quot;Cannot activate suspended customer&quot;);
                }
                this.status = CustomerStatus.ACTIVE;
                this.lastActivity = LocalDateTime.now();
            }
            
            public void deactivate() {
                this.status = CustomerStatus.INACTIVE;
                this.lastActivity = LocalDateTime.now();
            }
            
            public void suspend() {
                this.status = CustomerStatus.SUSPENDED;
                this.lastActivity = LocalDateTime.now();
            }
            
            public void updateEmail(EmailAddress newEmail) {
                if (status == CustomerStatus.SUSPENDED) {
                    throw new IllegalStateException(&quot;Cannot update email for suspended customer&quot;);
                }
                this.email = newEmail;
                this.lastActivity = LocalDateTime.now();
            }
            
            public void updateName(String newName) {
                if (newName == null || newName.trim().isEmpty()) {
                    throw new IllegalArgumentException(&quot;Name cannot be null or empty&quot;);
                }
                this.name = newName.trim();
                this.lastActivity = LocalDateTime.now();
            }
            
            public void recordOrder(Money orderAmount) {
                if (status != CustomerStatus.ACTIVE) {
                    throw new IllegalStateException(&quot;Only active customers can place orders&quot;);
                }
                this.ordersCount++;
                this.totalSpent = this.totalSpent.add(orderAmount);
                this.lastActivity = LocalDateTime.now();
            }
            
            // ✅ Business Rules
            public boolean isActive() {
                return status == CustomerStatus.ACTIVE;
            }
            
            public boolean canPlaceOrders() {
                return status == CustomerStatus.ACTIVE;
            }
            
            public boolean isVip() {
                return totalSpent.getAmount() &gt;= 1000;
            }
            
            public boolean isPremium() {
                return totalSpent.getAmount() &gt;= 500;
            }
            
            public String getCustomerType() {
                if (isVip()) {
                    return &quot;VIP&quot;;
                } else if (isPremium()) {
                    return &quot;Premium&quot;;
                } else {
                    return &quot;Standard&quot;;
                }
            }
            
            // Getters
            public CustomerId getId() {
                return id;
            }
            
            public String getName() {
                return name;
            }
            
            public EmailAddress getEmail() {
                return email;
            }
            
            public CustomerStatus getStatus() {
                return status;
            }
            
            public LocalDateTime getCreatedAt() {
                return createdAt;
            }
            
            public LocalDateTime getLastActivity() {
                return lastActivity;
            }
            
            public int getOrdersCount() {
                return ordersCount;
            }
            
            public Money getTotalSpent() {
                return totalSpent;
            }
            
            @Override
            public boolean equals(Object obj) {
                if (this == obj) return true;
                if (obj == null || getClass() != obj.getClass()) return false;
                Customer customer = (Customer) obj;
                return Objects.equals(id, customer.id);
            }
            
            @Override
            public int hashCode() {
                return Objects.hash(id);
            }
            
            @Override
            public String toString() {
                return String.format(&quot;Customer{id=%s, name=&#39;%s&#39;, email=%s, status=%s}&quot;,
                        id, name, email, status);
            }
        }
        
        // ✅ Domain Services
        public static class CustomerService {
            private final CustomerRepository customerRepository;
            private final EmailService emailService;
            
            public CustomerService(CustomerRepository customerRepository, EmailService emailService) {
                this.customerRepository = customerRepository;
                this.emailService = emailService;
            }
            
            public Customer registerCustomer(String name, String emailString) {
                // ✅ Validate input and create value objects
                if (name == null || name.trim().isEmpty()) {
                    throw new IllegalArgumentException(&quot;Name cannot be empty&quot;);
                }
                
                EmailAddress email = EmailAddress.of(emailString);
                
                // ✅ Check if customer already exists
                Optional&lt;Customer&gt; existingCustomer = customerRepository.findByEmail(email);
                if (existingCustomer.isPresent()) {
                    throw new IllegalArgumentException(&quot;Customer with this email already exists&quot;);
                }
                
                // ✅ Create new customer
                CustomerId customerId = CustomerId.generate();
                Customer customer = new Customer(customerId, name, email);
                
                // ✅ Save customer
                customerRepository.save(customer);
                
                // ✅ Send welcome email
                emailService.sendWelcomeEmail(customer);
                
                return customer;
            }
            
            public void updateCustomerEmail(String customerIdString, String newEmailString) {
                CustomerId customerId = CustomerId.of(customerIdString);
                EmailAddress newEmail = EmailAddress.of(newEmailString);
                
                // ✅ Find customer
                Optional&lt;Customer&gt; customerOpt = customerRepository.findById(customerId);
                if (customerOpt.isEmpty()) {
                    throw new IllegalArgumentException(&quot;Customer not found&quot;);
                }
                
                Customer customer = customerOpt.get();
                
                // ✅ Check if email is already in use
                Optional&lt;Customer&gt; existingCustomer = customerRepository.findByEmail(newEmail);
                if (existingCustomer.isPresent() &amp;&amp; !existingCustomer.get().getId().equals(customerId)) {
                    throw new IllegalArgumentException(&quot;Email already in use&quot;);
                }
                
                // ✅ Update email
                customer.updateEmail(newEmail);
                
                // ✅ Save changes
                customerRepository.save(customer);
                
                // ✅ Send email change notification
                emailService.sendEmailChangeNotification(customer);
            }
        }
        
        // ✅ Repository Interfaces
        public interface CustomerRepository {
            void save(Customer customer);
            Optional&lt;Customer&gt; findById(CustomerId id);
            Optional&lt;Customer&gt; findByEmail(EmailAddress email);
            List&lt;Customer&gt; findByStatus(CustomerStatus status);
            List&lt;Customer&gt; findVipCustomers();
            List&lt;Customer&gt; findByCustomerType(String customerType);
            void delete(CustomerId id);
        }
        
        // ✅ Service Interfaces
        public interface EmailService {
            void sendWelcomeEmail(Customer customer);
            void sendEmailChangeNotification(Customer customer);
            void sendSuspensionNotification(Customer customer, String reason);
            void sendActivationNotification(Customer customer);
            void sendEmail(EmailAddress email, String subject, String body);
        }
    }
}

// Example usage
public class DomainModelingBestPracticesExample {
    public static void main(String[] args) {
        System.out.println(&quot;Domain Modeling Best Practices:&quot;);
        System.out.println(&quot;1. ✅ Rich Domain Models with Behavior&quot;);
        System.out.println(&quot;2. ✅ Immutable Value Objects&quot;);
        System.out.println(&quot;3. ✅ Self-Validating Value Objects&quot;);
        System.out.println(&quot;4. ✅ Domain Services for Complex Business Logic&quot;);
        System.out.println(&quot;5. ✅ Factory for Complex Object Creation&quot;);
        System.out.println(&quot;6. ✅ Specification Pattern for Complex Business Rules&quot;);
        System.out.println(&quot;7. ✅ Module Organization with Clear Boundaries&quot;);
        System.out.println(&quot;8. ✅ Repository Pattern for Data Access&quot;);
        System.out.println(&quot;9. ✅ Service Interfaces for External Dependencies&quot;);
        System.out.println(&quot;10. ✅ Business Rules Encapsulated in Domain Objects&quot;);
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Best Practices for Domain Modeling</h3>
<h4>1. <strong>Rich Domain Models with Behavior</strong></h4>
<ul>
<li>✅ Domain objects contain both data and behavior</li>
<li>✅ Business logic is encapsulated within the objects that own the data</li>
<li>✅ Methods express business operations clearly</li>
</ul>
<h4>2. <strong>Immutable Value Objects</strong></h4>
<ul>
<li>✅ Value objects are immutable once created</li>
<li>✅ All fields are final</li>
<li>✅ No setter methods</li>
<li>✅ Thread-safe by design</li>
</ul>
<h4>3. <strong>Self-Validating Value Objects</strong></h4>
<ul>
<li>✅ Value objects validate themselves during construction</li>
<li>✅ Invalid values are rejected immediately</li>
<li>✅ Validation logic is encapsulated within the value object</li>
</ul>
<h4>4. <strong>Domain Services for Complex Business Logic</strong></h4>
<ul>
<li>✅ Domain services handle complex business logic</li>
<li>✅ Services are stateless</li>
<li>✅ Services coordinate multiple domain objects</li>
</ul>
<h4>5. <strong>Factory for Complex Object Creation</strong></h4>
<ul>
<li>✅ Factories handle complex object creation</li>
<li>✅ Factories encapsulate creation logic</li>
<li>✅ Factories provide clear interfaces</li>
</ul>
<h4>6. <strong>Specification Pattern for Complex Business Rules</strong></h4>
<ul>
<li>✅ Specifications encapsulate complex business rules</li>
<li>✅ Specifications are reusable</li>
<li>✅ Specifications are testable</li>
</ul>
<h4>7. <strong>Module Organization with Clear Boundaries</strong></h4>
<ul>
<li>✅ Modules contain related functionality</li>
<li>✅ Clear separation between modules</li>
<li>✅ Modules provide cohesive functionality</li>
</ul>
<h4>8. <strong>Repository Pattern for Data Access</strong></h4>
<ul>
<li>✅ Repositories abstract data access</li>
<li>✅ Repositories provide clear interfaces</li>
<li>✅ Repositories are testable</li>
</ul>
<h4>9. <strong>Service Interfaces for External Dependencies</strong></h4>
<ul>
<li>✅ Service interfaces define contracts</li>
<li>✅ External dependencies are abstracted</li>
<li>✅ Services are testable</li>
</ul>
<h4>10. <strong>Business Rules Encapsulated in Domain Objects</strong></h4>
<ul>
<li>✅ Business rules are encapsulated in domain objects</li>
<li>✅ Business rules are enforced at the domain boundary</li>
<li>✅ Business rules are testable</li>
</ul>
<h3>Domain Modeling Benefits</h3>
<h4><strong>Maintainability</strong></h4>
<ul>
<li>✅ Domain models are easy to understand and modify</li>
<li>✅ Business logic is centralized</li>
<li>✅ Changes are localized</li>
</ul>
<h4><strong>Testability</strong></h4>
<ul>
<li>✅ Domain models are easy to test</li>
<li>✅ Business logic is isolated</li>
<li>✅ Tests are focused and clear</li>
</ul>
<h4><strong>Reusability</strong></h4>
<ul>
<li>✅ Domain models can be reused</li>
<li>✅ Value objects are reusable</li>
<li>✅ Services are reusable</li>
</ul>
<h4><strong>Consistency</strong></h4>
<ul>
<li>✅ Domain models enforce consistency</li>
<li>✅ Business rules are centralized</li>
<li>✅ Validation is consistent</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Basic entity design</li>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity with business logic</li>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Value object example</li>
<li><a href="./04-email-address-value-object.md">EmailAddress Value Object</a> - Validation example</li>
<li><a href="./05-pricing-service.md">Pricing Service</a> - Domain service example</li>
<li><a href="./06-customer-module.md">Customer Module</a> - Module organization</li>
<li><a href="../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling">Best Practices for Domain Modeling</a> - Domain modeling concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 12-testing-best-practices.md</li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling">Best Practices for Domain Modeling</a></li>
<li></li>
<li>This completes the Java code samples for Domain-Driven Design<br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"13-domain-modeling-best-practices"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"13-domain-modeling-best-practices\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
