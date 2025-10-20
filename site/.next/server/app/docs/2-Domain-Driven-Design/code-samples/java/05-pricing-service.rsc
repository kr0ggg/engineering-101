1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/05-pricing-service","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"05-pricing-service\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T607a,<h1>Pricing Service - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#domain-services-and-domain-service-design-principles">Domain Services and Domain Service Design Principles</a></p>
<p><strong>Navigation</strong>: <a href="./04-email-address-value-object.md">← Previous: EmailAddress Value Object</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - Pricing Service Domain Service
// File: 2-Domain-Driven-Design/code-samples/java/05-pricing-service.java

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

// ✅ GOOD: Domain Service for Complex Business Logic
public class PricingService {
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
    
    // ✅ Business operation - calculates discount amount
    public Money calculateDiscountAmount(Order order, Customer customer) {
        Money baseAmount = order.getTotalAmount();
        Money discountedAmount = applyCustomerDiscount(baseAmount, customer);
        Money bulkDiscountedAmount = applyBulkDiscount(discountedAmount, order);
        
        Money totalDiscount = baseAmount.subtract(bulkDiscountedAmount);
        return totalDiscount;
    }
    
    // ✅ Business operation - gets available discounts
    public List&lt;Discount&gt; getAvailableDiscounts(Order order, Customer customer) {
        List&lt;Discount&gt; discounts = new ArrayList&lt;&gt;();
        
        // Customer type discount
        Discount customerDiscount = getCustomerTypeDiscount(customer);
        if (customerDiscount != null) {
            discounts.add(customerDiscount);
        }
        
        // Bulk discount
        Discount bulkDiscount = getBulkDiscount(order);
        if (bulkDiscount != null) {
            discounts.add(bulkDiscount);
        }
        
        // Seasonal discount
        Discount seasonalDiscount = getSeasonalDiscount();
        if (seasonalDiscount != null) {
            discounts.add(seasonalDiscount);
        }
        
        // Product discounts
        List&lt;Discount&gt; productDiscounts = getProductDiscounts(order);
        discounts.addAll(productDiscounts);
        
        return discounts;
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
    
    private Discount getCustomerTypeDiscount(Customer customer) {
        String customerType = customer.getCustomerType();
        double discountRate = getCustomerDiscountRate(customerType);
        
        if (discountRate &gt; 0) {
            return new Discount(
                &quot;customer-type-&quot; + customerType.toLowerCase(),
                customerType + &quot; Customer Discount&quot;,
                &quot;percentage&quot;,
                discountRate,
                &quot;Discount for &quot; + customerType + &quot; customers&quot;
            );
        }
        
        return null;
    }
    
    private Discount getBulkDiscount(Order order) {
        double amount = order.getTotalAmount().getAmount();
        double discountRate = getBulkDiscountRate(amount);
        
        if (discountRate &gt; 0) {
            return new Discount(
                &quot;bulk-discount&quot;,
                &quot;Bulk Discount&quot;,
                &quot;percentage&quot;,
                discountRate,
                String.format(&quot;%.0f%% discount for orders over $%.0f&quot;, 
                    discountRate * 100, getBulkThreshold(amount))
            );
        }
        
        return null;
    }
    
    private Discount getSeasonalDiscount() {
        // Simplified seasonal discount logic
        int currentMonth = LocalDateTime.now().getMonthValue();
        
        if (currentMonth == 12) { // December - holiday season
            return new Discount(
                &quot;holiday-discount&quot;,
                &quot;Holiday Discount&quot;,
                &quot;percentage&quot;,
                0.08,
                &quot;8% discount during holiday season&quot;
            );
        }
        
        return null;
    }
    
    private List&lt;Discount&gt; getProductDiscounts(Order order) {
        List&lt;Discount&gt; discounts = new ArrayList&lt;&gt;();
        
        for (OrderItem item : order.getItems()) {
            if (item.getProductId().getValue().startsWith(&quot;SALE-&quot;)) {
                discounts.add(new Discount(
                    &quot;sale-item-discount&quot;,
                    &quot;Sale Item Discount&quot;,
                    &quot;percentage&quot;,
                    0.20,
                    &quot;20% discount on sale items&quot;
                ));
            }
        }
        
        return discounts;
    }
    
    private double getBulkThreshold(double amount) {
        if (amount &gt;= 1000) return 1000;
        if (amount &gt;= 500) return 500;
        if (amount &gt;= 100) return 100;
        return 0;
    }
}

// ✅ GOOD: Tax Calculator Domain Service
public class TaxCalculator {
    public Money calculateTax(Money amount, Address address) {
        if (address.getCountry().equals(&quot;US&quot;)) {
            return calculateUSTax(amount, address);
        } else if (address.getCountry().equals(&quot;CA&quot;)) {
            return calculateCanadianTax(amount, address);
        } else {
            return Money.zero(amount.getCurrency()); // No tax for international
        }
    }
    
    private Money calculateUSTax(Money amount, Address address) {
        double taxRate = getUSTaxRate(address.getState());
        return amount.multiply(taxRate);
    }
    
    private Money calculateCanadianTax(Money amount, Address address) {
        double taxRate = getCanadianTaxRate(address.getProvince());
        return amount.multiply(taxRate);
    }
    
    private double getUSTaxRate(String state) {
        switch (state) {
            case &quot;CA&quot;:
            case &quot;NY&quot;:
            case &quot;TX&quot;:
                return 0.08; // 8% tax
            default:
                return 0.06; // 6% tax
        }
    }
    
    private double getCanadianTaxRate(String province) {
        switch (province) {
            case &quot;ON&quot;:
            case &quot;BC&quot;:
            case &quot;AB&quot;:
                return 0.13; // 13% HST
            default:
                return 0.15; // 15% HST
        }
    }
}

// ✅ GOOD: Shipping Calculator Domain Service
public class ShippingCalculator {
    public Money calculateShipping(Order order, Address address) {
        Money baseShipping = getBaseShippingRate(address);
        
        // Add weight-based charges
        Money weightCharge = calculateWeightCharge(order);
        
        // Add distance-based charges
        Money distanceCharge = calculateDistanceCharge(address);
        
        // Add handling fee
        Money handlingFee = Money.of(2.99, baseShipping.getCurrency());
        
        Money totalShipping = baseShipping.add(weightCharge).add(distanceCharge).add(handlingFee);
        
        return totalShipping;
    }
    
    private Money getBaseShippingRate(Address address) {
        if (address.getCountry().equals(&quot;US&quot;)) {
            return Money.of(5.99, &quot;USD&quot;);
        } else if (address.getCountry().equals(&quot;CA&quot;)) {
            return Money.of(8.99, &quot;USD&quot;);
        } else {
            return Money.of(15.99, &quot;USD&quot;);
        }
    }
    
    private Money calculateWeightCharge(Order order) {
        double totalWeight = calculateTotalWeight(order);
        
        if (totalWeight &gt; 20) {
            return Money.of(10.00, &quot;USD&quot;);
        } else if (totalWeight &gt; 10) {
            return Money.of(5.00, &quot;USD&quot;);
        } else {
            return Money.zero(&quot;USD&quot;);
        }
    }
    
    private Money calculateDistanceCharge(Address address) {
        if (address.getCountry().equals(&quot;US&quot;)) {
            if (address.getState().equals(&quot;AK&quot;) || address.getState().equals(&quot;HI&quot;)) {
                return Money.of(15.00, &quot;USD&quot;);
            }
        }
        
        return Money.zero(&quot;USD&quot;);
    }
    
    private double calculateTotalWeight(Order order) {
        // Simplified weight calculation
        return order.getItems().stream()
                .mapToDouble(item -&gt; item.getQuantity() * 0.5) // 0.5 lbs per item
                .sum();
    }
}

// ✅ GOOD: Discount Rule Repository
public class DiscountRuleRepository {
    public double getCustomerDiscountRate(String customerType) {
        switch (customerType) {
            case &quot;VIP&quot;:
                return 0.15; // 15% discount
            case &quot;Premium&quot;:
                return 0.10; // 10% discount
            case &quot;Standard&quot;:
                return 0.05; // 5% discount
            case &quot;Basic&quot;:
                return 0.0; // No discount
            default:
                return 0.0;
        }
    }
    
    public double getBulkDiscountRate(double amount) {
        if (amount &gt;= 1000) {
            return 0.10; // 10% discount
        } else if (amount &gt;= 500) {
            return 0.05; // 5% discount
        } else if (amount &gt;= 100) {
            return 0.02; // 2% discount
        } else {
            return 0.0; // No discount
        }
    }
    
    public double getSeasonalDiscountRate() {
        int currentMonth = LocalDateTime.now().getMonthValue();
        
        if (currentMonth == 12) { // December
            return 0.08; // 8% holiday discount
        } else if (currentMonth &gt;= 6 &amp;&amp; currentMonth &lt;= 8) { // Summer
            return 0.05; // 5% summer discount
        }
        
        return 0.0; // No seasonal discount
    }
}

// ✅ GOOD: Discount Value Object
public class Discount {
    private final String id;
    private final String name;
    private final String type;
    private final double value;
    private final String description;
    
    public Discount(String id, String name, String type, double value, String description) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.value = value;
        this.description = description;
    }
    
    public String getId() {
        return id;
    }
    
    public String getName() {
        return name;
    }
    
    public String getType() {
        return type;
    }
    
    public double getValue() {
        return value;
    }
    
    public String getDescription() {
        return description;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Discount discount = (Discount) obj;
        return Objects.equals(id, discount.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    @Override
    public String toString() {
        return String.format(&quot;Discount{id=&#39;%s&#39;, name=&#39;%s&#39;, type=&#39;%s&#39;, value=%.2f, description=&#39;%s&#39;}&quot;,
                id, name, type, value, description);
    }
}

// ✅ GOOD: Address Value Object
public class Address {
    private final String street;
    private final String city;
    private final String state;
    private final String country;
    private final String postalCode;
    
    public Address(String street, String city, String state, String country, String postalCode) {
        if (street == null || street.trim().isEmpty()) {
            throw new IllegalArgumentException(&quot;Street cannot be null or empty&quot;);
        }
        if (city == null || city.trim().isEmpty()) {
            throw new IllegalArgumentException(&quot;City cannot be null or empty&quot;);
        }
        if (country == null || country.trim().isEmpty()) {
            throw new IllegalArgumentException(&quot;Country cannot be null or empty&quot;);
        }
        
        this.street = street.trim();
        this.city = city.trim();
        this.state = state != null ? state.trim() : &quot;&quot;;
        this.country = country.trim();
        this.postalCode = postalCode != null ? postalCode.trim() : &quot;&quot;;
    }
    
    public String getStreet() {
        return street;
    }
    
    public String getCity() {
        return city;
    }
    
    public String getState() {
        return state;
    }
    
    public String getCountry() {
        return country;
    }
    
    public String getPostalCode() {
        return postalCode;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Address address = (Address) obj;
        return Objects.equals(street, address.street) &amp;&amp;
               Objects.equals(city, address.city) &amp;&amp;
               Objects.equals(state, address.state) &amp;&amp;
               Objects.equals(country, address.country) &amp;&amp;
               Objects.equals(postalCode, address.postalCode);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(street, city, state, country, postalCode);
    }
    
    @Override
    public String toString() {
        return String.format(&quot;%s, %s, %s %s, %s&quot;, street, city, state, postalCode, country);
    }
}

// ❌ BAD: Anemic Domain Service
class BadPricingService {
    // ❌ Only data, no behavior
    private double taxRate;
    private double shippingRate;
    private double discountRate;
    
    public BadPricingService(double taxRate, double shippingRate, double discountRate) {
        this.taxRate = taxRate;
        this.discountRate = discountRate;
        this.shippingRate = shippingRate;
    }
    
    // ❌ Business logic in external service
    public double calculateTotal(double orderAmount, String customerType, String country) {
        // Business logic should be in the domain service
        double discount = calculateDiscount(orderAmount, customerType);
        double tax = calculateTax(orderAmount - discount, country);
        double shipping = calculateShipping(country);
        
        return orderAmount - discount + tax + shipping;
    }
    
    private double calculateDiscount(double amount, String customerType) {
        // Business logic scattered
        switch (customerType) {
            case &quot;VIP&quot;: return amount * 0.15;
            case &quot;Premium&quot;: return amount * 0.10;
            default: return amount * 0.05;
        }
    }
    
    private double calculateTax(double amount, String country) {
        // Business logic scattered
        if (&quot;US&quot;.equals(country)) {
            return amount * 0.08;
        }
        return 0;
    }
    
    private double calculateShipping(String country) {
        // Business logic scattered
        if (&quot;US&quot;.equals(country)) {
            return 5.99;
        }
        return 15.99;
    }
}

// ✅ GOOD: Pricing Service Factory
public class PricingServiceFactory {
    public static PricingService createDefaultPricingService() {
        TaxCalculator taxCalculator = new TaxCalculator();
        ShippingCalculator shippingCalculator = new ShippingCalculator();
        DiscountRuleRepository discountRuleRepository = new DiscountRuleRepository();
        
        return new PricingService(taxCalculator, shippingCalculator, discountRuleRepository);
    }
    
    public static PricingService createPricingServiceWithCustomRules(DiscountRuleRepository customRules) {
        TaxCalculator taxCalculator = new TaxCalculator();
        ShippingCalculator shippingCalculator = new ShippingCalculator();
        
        return new PricingService(taxCalculator, shippingCalculator, customRules);
    }
}

// Example usage
public class PricingServiceExample {
    public static void main(String[] args) {
        // Create pricing service
        PricingService pricingService = PricingServiceFactory.createDefaultPricingService();
        
        // Create order
        CustomerId customerId = CustomerId.of(&quot;customer-123&quot;);
        Order order = new Order(OrderId.generate(), customerId);
        order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
        order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(25.50, &quot;USD&quot;));
        order.confirm();
        
        // Create customer
        Customer customer = new Customer(customerId, &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
        customer.activate();
        
        // Create shipping address
        Address address = new Address(&quot;123 Main St&quot;, &quot;Anytown&quot;, &quot;CA&quot;, &quot;US&quot;, &quot;12345&quot;);
        
        // Calculate order total
        Money total = pricingService.calculateOrderTotal(order, customer, address);
        System.out.println(&quot;Order total: &quot; + total);
        
        // Calculate discount amount
        Money discount = pricingService.calculateDiscountAmount(order, customer);
        System.out.println(&quot;Discount amount: &quot; + discount);
        
        // Get available discounts
        List&lt;Discount&gt; discounts = pricingService.getAvailableDiscounts(order, customer);
        System.out.println(&quot;Available discounts:&quot;);
        for (Discount discountItem : discounts) {
            System.out.println(&quot;  &quot; + discountItem);
        }
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Domain Services and Domain Service Design Principles</h3>
<h4>1. <strong>Stateless Services</strong></h4>
<ul>
<li>✅ PricingService has no instance variables for state</li>
<li>✅ All operations are pure functions</li>
<li>✅ Same inputs always produce same outputs</li>
</ul>
<h4>2. <strong>Complex Business Logic</strong></h4>
<ul>
<li>✅ PricingService handles complex pricing calculations</li>
<li>✅ Business logic is encapsulated within the service</li>
<li>✅ Service coordinates multiple domain objects</li>
</ul>
<h4>3. <strong>Service Composition</strong></h4>
<ul>
<li>✅ PricingService uses other domain services</li>
<li>✅ TaxCalculator, ShippingCalculator, DiscountRuleRepository</li>
<li>✅ Service interactions are well-defined</li>
</ul>
<h4>4. <strong>Business Operations</strong></h4>
<ul>
<li>✅ calculateOrderTotal() is the main business operation</li>
<li>✅ calculateDiscountAmount() provides discount information</li>
<li>✅ getAvailableDiscounts() lists all applicable discounts</li>
</ul>
<h3>Pricing Service Design Principles</h3>
<h4><strong>Stateless Design</strong></h4>
<ul>
<li>✅ PricingService has no instance variables for state</li>
<li>✅ All operations are pure functions</li>
<li>✅ Thread-safe by design</li>
</ul>
<h4><strong>Service Composition</strong></h4>
<ul>
<li>✅ PricingService uses other domain services</li>
<li>✅ Dependencies are injected through constructor</li>
<li>✅ Service interactions are well-defined</li>
</ul>
<h4><strong>Business Logic Encapsulation</strong></h4>
<ul>
<li>✅ Complex pricing logic is encapsulated</li>
<li>✅ Business rules are centralized</li>
<li>✅ Service provides clear business operations</li>
</ul>
<h4><strong>Domain Service Interface</strong></h4>
<ul>
<li>✅ Clear public interface for business operations</li>
<li>✅ Private methods for complex calculations</li>
<li>✅ Service is focused on pricing domain</li>
</ul>
<h3>Java Benefits for Domain Services</h3>
<ul>
<li><strong>Strong Typing</strong>: Compile-time type checking</li>
<li><strong>Interface Segregation</strong>: Clear contracts for dependencies</li>
<li><strong>Dependency Injection</strong>: Constructor injection for dependencies</li>
<li><strong>Method Chaining</strong>: Fluent interfaces for operations</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
<li><strong>Collections</strong>: Rich collection framework for managing data</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Anemic Domain Service</strong></h4>
<ul>
<li>❌ Service contains only data</li>
<li>❌ Business logic in external services</li>
<li>❌ No encapsulation of business rules</li>
</ul>
<h4><strong>God Service</strong></h4>
<ul>
<li>❌ Single service with too many responsibilities</li>
<li>❌ Hard to understand and maintain</li>
<li>❌ Violates Single Responsibility Principle</li>
</ul>
<h4><strong>Stateful Services</strong></h4>
<ul>
<li>❌ Services with instance variables for state</li>
<li>❌ Thread safety issues</li>
<li>❌ Hard to test and maintain</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity used by Pricing Service</li>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Entity used by Pricing Service</li>
<li><a href="./04-email-address-value-object.md">EmailAddress Value Object</a> - Value object example</li>
<li><a href="../../1-introduction-to-the-domain.md#domain-services-and-domain-service-design-principles">Domain Services and Domain Service Design Principles</a> - Domain service concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 04-email-address-value-object.md</li>
<li>Next: 06-customer-module.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#domain-services-and-domain-service-design-principles">Domain Services and Domain Service Design Principles</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/05-pricing-service","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"05-pricing-service"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"05-pricing-service\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/05-pricing-service","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
