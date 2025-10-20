1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"04-email-address-value-object\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T51a4,<h1>EmailAddress Value Object - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#value-objects-and-immutability">Value Objects and Immutability</a></p>
<p><strong>Navigation</strong>: <a href="./03-order-entity.md">← Previous: Order Entity</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - EmailAddress Value Object with Self-Validation
// File: 2-Domain-Driven-Design/code-samples/java/04-email-address-value-object.java

import java.util.Objects;
import java.util.regex.Pattern;

// ✅ GOOD: Immutable Value Object with Self-Validation
public class EmailAddress {
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
    
    // ✅ Value Object Equality
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

// ✅ GOOD: Customer Entity Using EmailAddress Value Object
public class Customer {
    private final CustomerId id;
    private String name;
    private EmailAddress email;
    private CustomerStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime lastActivity;
    
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
    }
    
    // ✅ Business Operations Using Value Objects
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
    
    public void activate() {
        if (status == CustomerStatus.SUSPENDED) {
            throw new IllegalStateException(&quot;Cannot activate suspended customer&quot;);
        }
        
        this.status = CustomerStatus.ACTIVE;
        this.lastActivity = LocalDateTime.now();
    }
    
    public void suspend() {
        this.status = CustomerStatus.SUSPENDED;
        this.lastActivity = LocalDateTime.now();
    }
    
    public void deactivate() {
        this.status = CustomerStatus.INACTIVE;
        this.lastActivity = LocalDateTime.now();
    }
    
    // ✅ Business Rules Using Value Objects
    public boolean isActive() {
        return status == CustomerStatus.ACTIVE;
    }
    
    public boolean canPlaceOrders() {
        return status == CustomerStatus.ACTIVE;
    }
    
    public boolean isCorporateCustomer() {
        return email.isCorporateEmail();
    }
    
    public boolean isEducationalCustomer() {
        return email.isEducationalEmail();
    }
    
    public boolean isGovernmentCustomer() {
        return email.isGovernmentEmail();
    }
    
    public String getCustomerType() {
        if (isGovernmentCustomer()) {
            return &quot;Government&quot;;
        } else if (isEducationalCustomer()) {
            return &quot;Educational&quot;;
        } else if (isCorporateCustomer()) {
            return &quot;Corporate&quot;;
        } else {
            return &quot;Personal&quot;;
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

// ✅ GOOD: Domain Service Using EmailAddress Value Object
public class CustomerService {
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
        Customer existingCustomer = customerRepository.findByEmail(email);
        if (existingCustomer != null) {
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
        Customer customer = customerRepository.findById(customerId);
        if (customer == null) {
            throw new IllegalArgumentException(&quot;Customer not found&quot;);
        }
        
        // ✅ Check if email is already in use
        Customer existingCustomer = customerRepository.findByEmail(newEmail);
        if (existingCustomer != null &amp;&amp; !existingCustomer.getId().equals(customerId)) {
            throw new IllegalArgumentException(&quot;Email already in use&quot;);
        }
        
        // ✅ Update email
        customer.updateEmail(newEmail);
        
        // ✅ Save changes
        customerRepository.save(customer);
        
        // ✅ Send email change notification
        emailService.sendEmailChangeNotification(customer);
    }
    
    public void sendPromotionalEmail(String customerIdString, String subject, String body) {
        CustomerId customerId = CustomerId.of(customerIdString);
        Customer customer = customerRepository.findById(customerId);
        
        if (customer == null) {
            throw new IllegalArgumentException(&quot;Customer not found&quot;);
        }
        
        if (!customer.isActive()) {
            throw new IllegalStateException(&quot;Cannot send email to inactive customer&quot;);
        }
        
        // ✅ Use value object for email operations
        emailService.sendEmail(customer.getEmail(), subject, body);
    }
}

// ✅ GOOD: Email Service Interface
public interface EmailService {
    void sendWelcomeEmail(Customer customer);
    void sendEmailChangeNotification(Customer customer);
    void sendEmail(EmailAddress email, String subject, String body);
}

// ✅ GOOD: Customer Repository Interface
public interface CustomerRepository {
    Customer findById(CustomerId id);
    Customer findByEmail(EmailAddress email);
    void save(Customer customer);
    List&lt;Customer&gt; findByStatus(CustomerStatus status);
    List&lt;Customer&gt; findByEmailDomain(String domain);
}

// ✅ GOOD: Email Validation Service
public class EmailValidationService {
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        &quot;^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$&quot;
    );
    
    public boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        return EMAIL_PATTERN.matcher(email.trim()).matches();
    }
    
    public boolean isCorporateEmail(String email) {
        if (!isValidEmail(email)) {
            return false;
        }
        
        String domain = email.substring(email.indexOf(&#39;@&#39;) + 1);
        return domain.endsWith(&quot;.com&quot;) || 
               domain.endsWith(&quot;.org&quot;) || 
               domain.endsWith(&quot;.net&quot;);
    }
    
    public boolean isEducationalEmail(String email) {
        if (!isValidEmail(email)) {
            return false;
        }
        
        String domain = email.substring(email.indexOf(&#39;@&#39;) + 1);
        return domain.endsWith(&quot;.edu&quot;);
    }
    
    public boolean isGovernmentEmail(String email) {
        if (!isValidEmail(email)) {
            return false;
        }
        
        String domain = email.substring(email.indexOf(&#39;@&#39;) + 1);
        return domain.endsWith(&quot;.gov&quot;);
    }
    
    public String getEmailDomain(String email) {
        if (!isValidEmail(email)) {
            throw new IllegalArgumentException(&quot;Invalid email address&quot;);
        }
        
        return email.substring(email.indexOf(&#39;@&#39;) + 1);
    }
    
    public String getEmailLocalPart(String email) {
        if (!isValidEmail(email)) {
            throw new IllegalArgumentException(&quot;Invalid email address&quot;);
        }
        
        return email.substring(0, email.indexOf(&#39;@&#39;));
    }
}

// ✅ GOOD: Email Address Factory
public class EmailAddressFactory {
    public static EmailAddress createCorporateEmail(String localPart, String companyDomain) {
        String email = localPart + &quot;@&quot; + companyDomain + &quot;.com&quot;;
        return EmailAddress.of(email);
    }
    
    public static EmailAddress createEducationalEmail(String localPart, String institutionDomain) {
        String email = localPart + &quot;@&quot; + institutionDomain + &quot;.edu&quot;;
        return EmailAddress.of(email);
    }
    
    public static EmailAddress createGovernmentEmail(String localPart, String agencyDomain) {
        String email = localPart + &quot;@&quot; + agencyDomain + &quot;.gov&quot;;
        return EmailAddress.of(email);
    }
    
    public static EmailAddress createPersonalEmail(String localPart, String providerDomain) {
        String email = localPart + &quot;@&quot; + providerDomain;
        return EmailAddress.of(email);
    }
}

// ❌ BAD: Primitive Obsession
class BadCustomer {
    private String id;
    private String name;
    private String email; // ❌ Using primitive string instead of value object
    
    public BadCustomer(String id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email; // ❌ No validation
    }
    
    public void updateEmail(String newEmail) {
        // ❌ Validation logic scattered
        if (newEmail == null || !newEmail.contains(&quot;@&quot;)) {
            throw new IllegalArgumentException(&quot;Invalid email&quot;);
        }
        this.email = newEmail;
    }
    
    public boolean isCorporateCustomer() {
        // ❌ Business logic scattered
        return email.endsWith(&quot;.com&quot;) || email.endsWith(&quot;.org&quot;);
    }
}

// ❌ BAD: Validation Scattered
class BadEmailValidator {
    public boolean validateEmail(String email) {
        // ❌ Validation logic scattered across multiple classes
        if (email == null || email.isEmpty()) {
            return false;
        }
        
        if (!email.contains(&quot;@&quot;)) {
            return false;
        }
        
        // More validation logic scattered elsewhere
        return true;
    }
}

// Example usage
public class EmailAddressExample {
    public static void main(String[] args) {
        // Create email address
        EmailAddress email = EmailAddress.of(&quot;john.doe@example.com&quot;);
        System.out.println(&quot;Email: &quot; + email);
        System.out.println(&quot;Domain: &quot; + email.getDomain());
        System.out.println(&quot;Local part: &quot; + email.getLocalPart());
        System.out.println(&quot;Is corporate: &quot; + email.isCorporateEmail());
        
        // Create customer with email
        CustomerId customerId = CustomerId.generate();
        Customer customer = new Customer(customerId, &quot;John Doe&quot;, email);
        customer.activate();
        
        System.out.println(&quot;Customer: &quot; + customer);
        System.out.println(&quot;Customer type: &quot; + customer.getCustomerType());
        
        // Update email
        EmailAddress newEmail = EmailAddress.of(&quot;john.doe@company.com&quot;);
        customer.updateEmail(newEmail);
        
        System.out.println(&quot;Updated customer: &quot; + customer);
        System.out.println(&quot;New customer type: &quot; + customer.getCustomerType());
        
        // Test email validation
        EmailValidationService validator = new EmailValidationService();
        System.out.println(&quot;Is valid: &quot; + validator.isValidEmail(&quot;test@example.com&quot;));
        System.out.println(&quot;Is corporate: &quot; + validator.isCorporateEmail(&quot;test@company.com&quot;));
        
        // Test email factory
        EmailAddress corporateEmail = EmailAddressFactory.createCorporateEmail(&quot;jane&quot;, &quot;acme&quot;);
        System.out.println(&quot;Corporate email: &quot; + corporateEmail);
        
        EmailAddress educationalEmail = EmailAddressFactory.createEducationalEmail(&quot;student&quot;, &quot;university&quot;);
        System.out.println(&quot;Educational email: &quot; + educationalEmail);
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Value Objects and Immutability</h3>
<h4>1. <strong>Self-Validation</strong></h4>
<ul>
<li>✅ EmailAddress validates itself during construction</li>
<li>✅ Invalid email addresses are rejected immediately</li>
<li>✅ Validation logic is encapsulated within the value object</li>
</ul>
<h4>2. <strong>Immutability</strong></h4>
<ul>
<li>✅ EmailAddress is immutable once created</li>
<li>✅ All fields are final</li>
<li>✅ No setter methods</li>
</ul>
<h4>3. <strong>Value-Based Equality</strong></h4>
<ul>
<li>✅ Two EmailAddress objects with the same value are equal</li>
<li>✅ hashCode() is consistent with equals()</li>
<li>✅ Can be used as keys in collections</li>
</ul>
<h4>4. <strong>Business Operations</strong></h4>
<ul>
<li>✅ EmailAddress provides business operations like getDomain()</li>
<li>✅ Business logic is encapsulated within the value object</li>
<li>✅ Operations are pure functions</li>
</ul>
<h3>EmailAddress Value Object Design Principles</h3>
<h4><strong>Self-Validation</strong></h4>
<ul>
<li>✅ EmailAddress validates email format during construction</li>
<li>✅ Invalid emails are rejected with clear error messages</li>
<li>✅ Validation logic is centralized</li>
</ul>
<h4><strong>Immutability</strong></h4>
<ul>
<li>✅ EmailAddress cannot be modified after creation</li>
<li>✅ All fields are final</li>
<li>✅ Thread-safe by design</li>
</ul>
<h4><strong>Business Operations</strong></h4>
<ul>
<li>✅ EmailAddress provides domain-specific operations</li>
<li>✅ Operations like getDomain() and isCorporateEmail()</li>
<li>✅ Business logic is encapsulated</li>
</ul>
<h4><strong>Value-Based Equality</strong></h4>
<ul>
<li>✅ Two EmailAddress objects with same value are equal</li>
<li>✅ hashCode() is consistent with equals()</li>
<li>✅ Can be used as keys in HashMap</li>
</ul>
<h3>Java Benefits for Value Objects</h3>
<ul>
<li><strong>Final Fields</strong>: Immutable objects with final fields</li>
<li><strong>Strong Typing</strong>: Compile-time type checking</li>
<li><strong>Equals/HashCode</strong>: Built-in support for value-based equality</li>
<li><strong>Collections</strong>: Can be used as keys in collections</li>
<li><strong>Thread Safety</strong>: Immutable objects are thread-safe</li>
<li><strong>Error Handling</strong>: Clear exception messages for validation</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Primitive Obsession</strong></h4>
<ul>
<li>❌ Using String instead of EmailAddress</li>
<li>❌ No type safety for email addresses</li>
<li>❌ Scattered validation logic</li>
</ul>
<h4><strong>Validation Scattered</strong></h4>
<ul>
<li>❌ Validation logic spread across multiple classes</li>
<li>❌ Inconsistent validation rules</li>
<li>❌ Hard to maintain and test</li>
</ul>
<h4><strong>Mutable Value Objects</strong></h4>
<ul>
<li>❌ Value objects that can be modified</li>
<li>❌ Inconsistent state</li>
<li>❌ Thread safety issues</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Entity using EmailAddress</li>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity with business logic</li>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Another value object example</li>
<li><a href="../../1-introduction-to-the-domain.md#value-objects-and-immutability">Value Objects and Immutability</a> - Value object concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 03-order-entity.md</li>
<li>Next: 05-pricing-service.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#value-objects-and-immutability">Value Objects and Immutability</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"04-email-address-value-object"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"04-email-address-value-object\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
