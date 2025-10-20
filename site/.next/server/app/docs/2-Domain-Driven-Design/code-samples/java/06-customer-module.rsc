1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/06-customer-module","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"06-customer-module\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T77ca,<h1>Customer Module - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns">Modules and Separation of Concerns</a></p>
<p><strong>Navigation</strong>: <a href="./05-pricing-service.md">← Previous: Pricing Service</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - Customer Module with Separation of Concerns
// File: 2-Domain-Driven-Design/code-samples/java/06-customer-module.java

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

// ✅ GOOD: Module Organization with Clear Boundaries
public class CustomerModule {
    
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
        
        public void suspendCustomer(String customerIdString, String reason) {
            CustomerId customerId = CustomerId.of(customerIdString);
            
            // ✅ Find customer
            Optional&lt;Customer&gt; customerOpt = customerRepository.findById(customerId);
            if (customerOpt.isEmpty()) {
                throw new IllegalArgumentException(&quot;Customer not found&quot;);
            }
            
            Customer customer = customerOpt.get();
            
            // ✅ Suspend customer
            customer.suspend();
            
            // ✅ Save changes
            customerRepository.save(customer);
            
            // ✅ Send suspension notification
            emailService.sendSuspensionNotification(customer, reason);
        }
        
        public void activateCustomer(String customerIdString) {
            CustomerId customerId = CustomerId.of(customerIdString);
            
            // ✅ Find customer
            Optional&lt;Customer&gt; customerOpt = customerRepository.findById(customerId);
            if (customerOpt.isEmpty()) {
                throw new IllegalArgumentException(&quot;Customer not found&quot;);
            }
            
            Customer customer = customerOpt.get();
            
            // ✅ Activate customer
            customer.activate();
            
            // ✅ Save changes
            customerRepository.save(customer);
            
            // ✅ Send activation notification
            emailService.sendActivationNotification(customer);
        }
        
        public Customer getCustomer(String customerIdString) {
            CustomerId customerId = CustomerId.of(customerIdString);
            return customerRepository.findById(customerId)
                    .orElseThrow(() -&gt; new IllegalArgumentException(&quot;Customer not found&quot;));
        }
        
        public List&lt;Customer&gt; getActiveCustomers() {
            return customerRepository.findByStatus(CustomerStatus.ACTIVE);
        }
        
        public List&lt;Customer&gt; getVipCustomers() {
            return customerRepository.findVipCustomers();
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
    
    // ✅ Factory Classes
    public static class CustomerFactory {
        public static Customer createStandardCustomer(String name, String email) {
            CustomerId customerId = CustomerId.generate();
            EmailAddress emailAddress = EmailAddress.of(email);
            Customer customer = new Customer(customerId, name, emailAddress);
            customer.activate();
            return customer;
        }
        
        public static Customer createVipCustomer(String name, String email) {
            CustomerId customerId = CustomerId.generate();
            EmailAddress emailAddress = EmailAddress.of(email);
            Customer customer = new Customer(customerId, name, emailAddress);
            customer.activate();
            // VIP customers start with some benefits
            customer.recordOrder(Money.of(1000, &quot;USD&quot;)); // Start as VIP
            return customer;
        }
        
        public static Customer createCustomerFromData(CustomerData data) {
            CustomerId customerId = CustomerId.of(data.getId());
            EmailAddress emailAddress = EmailAddress.of(data.getEmail());
            Customer customer = new Customer(customerId, data.getName(), emailAddress);
            
            // Set status
            if (data.getStatus() == CustomerStatus.ACTIVE) {
                customer.activate();
            } else if (data.getStatus() == CustomerStatus.SUSPENDED) {
                customer.suspend();
            } else if (data.getStatus() == CustomerStatus.INACTIVE) {
                customer.deactivate();
            }
            
            return customer;
        }
    }
    
    // ✅ Value Objects
    public static class CustomerData {
        private final String id;
        private final String name;
        private final String email;
        private final CustomerStatus status;
        private final LocalDateTime createdAt;
        private final LocalDateTime lastActivity;
        private final int ordersCount;
        private final Money totalSpent;
        
        public CustomerData(String id, String name, String email, CustomerStatus status,
                          LocalDateTime createdAt, LocalDateTime lastActivity,
                          int ordersCount, Money totalSpent) {
            this.id = id;
            this.name = name;
            this.email = email;
            this.status = status;
            this.createdAt = createdAt;
            this.lastActivity = lastActivity;
            this.ordersCount = ordersCount;
            this.totalSpent = totalSpent;
        }
        
        public String getId() { return id; }
        public String getName() { return name; }
        public String getEmail() { return email; }
        public CustomerStatus getStatus() { return status; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public LocalDateTime getLastActivity() { return lastActivity; }
        public int getOrdersCount() { return ordersCount; }
        public Money getTotalSpent() { return totalSpent; }
    }
    
    // ✅ Specification Classes
    public static class CustomerSpecification {
        public boolean canBeActivated(Customer customer) {
            return customer.getStatus() != CustomerStatus.SUSPENDED;
        }
        
        public boolean canPlaceOrders(Customer customer) {
            return customer.getStatus() == CustomerStatus.ACTIVE;
        }
        
        public boolean isVipCustomer(Customer customer) {
            return customer.getTotalSpent().getAmount() &gt;= 1000;
        }
        
        public boolean isPremiumCustomer(Customer customer) {
            return customer.getTotalSpent().getAmount() &gt;= 500;
        }
        
        public boolean isActiveCustomer(Customer customer) {
            return customer.getStatus() == CustomerStatus.ACTIVE;
        }
        
        public boolean isSuspendedCustomer(Customer customer) {
            return customer.getStatus() == CustomerStatus.SUSPENDED;
        }
    }
    
    // ✅ Event Classes
    public static class CustomerRegisteredEvent {
        private final CustomerId customerId;
        private final String name;
        private final EmailAddress email;
        private final LocalDateTime occurredAt;
        
        public CustomerRegisteredEvent(CustomerId customerId, String name, EmailAddress email) {
            this.customerId = customerId;
            this.name = name;
            this.email = email;
            this.occurredAt = LocalDateTime.now();
        }
        
        public CustomerId getCustomerId() { return customerId; }
        public String getName() { return name; }
        public EmailAddress getEmail() { return email; }
        public LocalDateTime getOccurredAt() { return occurredAt; }
    }
    
    public static class CustomerEmailChangedEvent {
        private final CustomerId customerId;
        private final EmailAddress oldEmail;
        private final EmailAddress newEmail;
        private final LocalDateTime occurredAt;
        
        public CustomerEmailChangedEvent(CustomerId customerId, EmailAddress oldEmail, EmailAddress newEmail) {
            this.customerId = customerId;
            this.oldEmail = oldEmail;
            this.newEmail = newEmail;
            this.occurredAt = LocalDateTime.now();
        }
        
        public CustomerId getCustomerId() { return customerId; }
        public EmailAddress getOldEmail() { return oldEmail; }
        public EmailAddress getNewEmail() { return newEmail; }
        public LocalDateTime getOccurredAt() { return occurredAt; }
    }
    
    public static class CustomerSuspendedEvent {
        private final CustomerId customerId;
        private final String reason;
        private final LocalDateTime occurredAt;
        
        public CustomerSuspendedEvent(CustomerId customerId, String reason) {
            this.customerId = customerId;
            this.reason = reason;
            this.occurredAt = LocalDateTime.now();
        }
        
        public CustomerId getCustomerId() { return customerId; }
        public String getReason() { return reason; }
        public LocalDateTime getOccurredAt() { return occurredAt; }
    }
}

// ✅ GOOD: Module Configuration
public class CustomerModuleConfiguration {
    private final CustomerRepository customerRepository;
    private final EmailService emailService;
    
    public CustomerModuleConfiguration(CustomerRepository customerRepository, EmailService emailService) {
        this.customerRepository = customerRepository;
        this.emailService = emailService;
    }
    
    public CustomerModule.CustomerService createCustomerService() {
        return new CustomerModule.CustomerService(customerRepository, emailService);
    }
    
    public CustomerModule.CustomerFactory createCustomerFactory() {
        return new CustomerModule.CustomerFactory();
    }
    
    public CustomerModule.CustomerSpecification createCustomerSpecification() {
        return new CustomerModule.CustomerSpecification();
    }
}

// ❌ BAD: Poor Module Organization
class BadCustomerModule {
    // ❌ Everything in one class
    public class Customer {
        // Customer entity
    }
    
    public class CustomerService {
        // Customer service
    }
    
    public class CustomerRepository {
        // Customer repository
    }
    
    public class EmailService {
        // Email service
    }
    
    // ❌ No clear boundaries
    // ❌ Hard to understand and maintain
    // ❌ Violates separation of concerns
}

// ✅ GOOD: Module Tests
public class CustomerModuleTest {
    private CustomerModule.CustomerService customerService;
    private MockCustomerRepository mockRepository;
    private MockEmailService mockEmailService;
    
    @BeforeEach
    void setUp() {
        mockRepository = new MockCustomerRepository();
        mockEmailService = new MockEmailService();
        customerService = new CustomerModule.CustomerService(mockRepository, mockEmailService);
    }
    
    @Test
    void shouldRegisterCustomerSuccessfully() {
        // Arrange
        String name = &quot;John Doe&quot;;
        String email = &quot;john.doe@example.com&quot;;
        
        // Act
        CustomerModule.Customer customer = customerService.registerCustomer(name, email);
        
        // Assert
        assertThat(customer.getName()).isEqualTo(name);
        assertThat(customer.getEmail().getValue()).isEqualTo(email);
        assertThat(customer.isActive()).isFalse(); // Pending status
        
        // Verify repository was called
        verify(mockRepository).save(customer);
        
        // Verify email service was called
        verify(mockEmailService).sendWelcomeEmail(customer);
    }
    
    @Test
    void shouldThrowExceptionWhenEmailAlreadyExists() {
        // Arrange
        String name = &quot;John Doe&quot;;
        String email = &quot;john.doe@example.com&quot;;
        
        CustomerModule.Customer existingCustomer = new CustomerModule.Customer(
            CustomerId.generate(), &quot;Jane Doe&quot;, EmailAddress.of(email)
        );
        mockRepository.addCustomer(existingCustomer);
        
        // Act &amp; Assert
        assertThrows(IllegalArgumentException.class, () -&gt; {
            customerService.registerCustomer(name, email);
        });
    }
    
    @Test
    void shouldUpdateCustomerEmailSuccessfully() {
        // Arrange
        CustomerId customerId = CustomerId.generate();
        CustomerModule.Customer customer = new CustomerModule.Customer(
            customerId, &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;)
        );
        mockRepository.addCustomer(customer);
        
        String newEmail = &quot;john.doe.new@example.com&quot;;
        
        // Act
        customerService.updateCustomerEmail(customerId.getValue(), newEmail);
        
        // Assert
        assertThat(customer.getEmail().getValue()).isEqualTo(newEmail);
        
        // Verify repository was called
        verify(mockRepository).save(customer);
        
        // Verify email service was called
        verify(mockEmailService).sendEmailChangeNotification(customer);
    }
}

// Mock classes for testing
class MockCustomerRepository implements CustomerModule.CustomerRepository {
    private final Map&lt;CustomerId, CustomerModule.Customer&gt; customers = new HashMap&lt;&gt;();
    private final Map&lt;EmailAddress, CustomerModule.Customer&gt; customersByEmail = new HashMap&lt;&gt;();
    
    @Override
    public void save(CustomerModule.Customer customer) {
        customers.put(customer.getId(), customer);
        customersByEmail.put(customer.getEmail(), customer);
    }
    
    @Override
    public Optional&lt;CustomerModule.Customer&gt; findById(CustomerId id) {
        return Optional.ofNullable(customers.get(id));
    }
    
    @Override
    public Optional&lt;CustomerModule.Customer&gt; findByEmail(EmailAddress email) {
        return Optional.ofNullable(customersByEmail.get(email));
    }
    
    @Override
    public List&lt;CustomerModule.Customer&gt; findByStatus(CustomerStatus status) {
        return customers.values().stream()
                .filter(customer -&gt; customer.getStatus() == status)
                .collect(Collectors.toList());
    }
    
    @Override
    public List&lt;CustomerModule.Customer&gt; findVipCustomers() {
        return customers.values().stream()
                .filter(CustomerModule.Customer::isVip)
                .collect(Collectors.toList());
    }
    
    @Override
    public List&lt;CustomerModule.Customer&gt; findByCustomerType(String customerType) {
        return customers.values().stream()
                .filter(customer -&gt; customer.getCustomerType().equals(customerType))
                .collect(Collectors.toList());
    }
    
    @Override
    public void delete(CustomerId id) {
        CustomerModule.Customer customer = customers.remove(id);
        if (customer != null) {
            customersByEmail.remove(customer.getEmail());
        }
    }
    
    public void addCustomer(CustomerModule.Customer customer) {
        save(customer);
    }
}

class MockEmailService implements CustomerModule.EmailService {
    @Override
    public void sendWelcomeEmail(CustomerModule.Customer customer) {
        // Mock implementation
    }
    
    @Override
    public void sendEmailChangeNotification(CustomerModule.Customer customer) {
        // Mock implementation
    }
    
    @Override
    public void sendSuspensionNotification(CustomerModule.Customer customer, String reason) {
        // Mock implementation
    }
    
    @Override
    public void sendActivationNotification(CustomerModule.Customer customer) {
        // Mock implementation
    }
    
    @Override
    public void sendEmail(EmailAddress email, String subject, String body) {
        // Mock implementation
    }
}

// Example usage
public class CustomerModuleExample {
    public static void main(String[] args) {
        // Create module configuration
        CustomerRepository customerRepository = new InMemoryCustomerRepository();
        EmailService emailService = new ConsoleEmailService();
        CustomerModuleConfiguration config = new CustomerModuleConfiguration(customerRepository, emailService);
        
        // Create services
        CustomerModule.CustomerService customerService = config.createCustomerService();
        CustomerModule.CustomerFactory customerFactory = config.createCustomerFactory();
        CustomerModule.CustomerSpecification customerSpec = config.createCustomerSpecification();
        
        // Register customer
        CustomerModule.Customer customer = customerService.registerCustomer(&quot;John Doe&quot;, &quot;john.doe@example.com&quot;);
        System.out.println(&quot;Customer registered: &quot; + customer);
        
        // Activate customer
        customerService.activateCustomer(customer.getId().getValue());
        System.out.println(&quot;Customer activated: &quot; + customer);
        
        // Update email
        customerService.updateCustomerEmail(customer.getId().getValue(), &quot;john.doe.new@example.com&quot;);
        System.out.println(&quot;Email updated: &quot; + customer);
        
        // Check customer type
        System.out.println(&quot;Customer type: &quot; + customer.getCustomerType());
        System.out.println(&quot;Is VIP: &quot; + customer.isVip());
        System.out.println(&quot;Is Premium: &quot; + customer.isPremium());
        
        // Get active customers
        List&lt;CustomerModule.Customer&gt; activeCustomers = customerService.getActiveCustomers();
        System.out.println(&quot;Active customers: &quot; + activeCustomers.size());
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Modules and Separation of Concerns</h3>
<h4>1. <strong>Clear Module Boundaries</strong></h4>
<ul>
<li>✅ CustomerModule contains all customer-related domain logic</li>
<li>✅ Clear separation between entities, services, and repositories</li>
<li>✅ Module provides a cohesive set of functionality</li>
</ul>
<h4>2. <strong>Separation of Concerns</strong></h4>
<ul>
<li>✅ Customer entity handles customer state and behavior</li>
<li>✅ CustomerService handles customer operations</li>
<li>✅ Repository handles data persistence</li>
<li>✅ EmailService handles email notifications</li>
</ul>
<h4>3. <strong>Module Organization</strong></h4>
<ul>
<li>✅ Entities, services, repositories, and value objects are organized</li>
<li>✅ Factory classes for object creation</li>
<li>✅ Specification classes for complex business rules</li>
<li>✅ Event classes for domain events</li>
</ul>
<h4>4. <strong>Dependency Injection</strong></h4>
<ul>
<li>✅ Dependencies are injected through constructors</li>
<li>✅ Services depend on interfaces, not implementations</li>
<li>✅ Easy to test and maintain</li>
</ul>
<h3>Customer Module Design Principles</h3>
<h4><strong>Module Boundaries</strong></h4>
<ul>
<li>✅ CustomerModule contains all customer-related functionality</li>
<li>✅ Clear separation from other modules</li>
<li>✅ Module provides cohesive customer management</li>
</ul>
<h4><strong>Separation of Concerns</strong></h4>
<ul>
<li>✅ Customer entity handles customer state and behavior</li>
<li>✅ CustomerService handles customer operations</li>
<li>✅ Repository handles data persistence</li>
<li>✅ EmailService handles email notifications</li>
</ul>
<h4><strong>Dependency Injection</strong></h4>
<ul>
<li>✅ Dependencies are injected through constructors</li>
<li>✅ Services depend on interfaces, not implementations</li>
<li>✅ Easy to test and maintain</li>
</ul>
<h4><strong>Module Configuration</strong></h4>
<ul>
<li>✅ CustomerModuleConfiguration manages module setup</li>
<li>✅ Centralized configuration for dependencies</li>
<li>✅ Easy to configure for different environments</li>
</ul>
<h3>Java Benefits for Module Organization</h3>
<ul>
<li><strong>Packages</strong>: Clear namespace organization</li>
<li><strong>Interfaces</strong>: Clear contracts for dependencies</li>
<li><strong>Dependency Injection</strong>: Constructor injection for dependencies</li>
<li><strong>Factory Pattern</strong>: Centralized object creation</li>
<li><strong>Specification Pattern</strong>: Complex business rules</li>
<li><strong>Event Pattern</strong>: Domain events for integration</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Poor Module Organization</strong></h4>
<ul>
<li>❌ Everything in one class</li>
<li>❌ No clear boundaries</li>
<li>❌ Hard to understand and maintain</li>
</ul>
<h4><strong>Tight Coupling</strong></h4>
<ul>
<li>❌ Modules depend on concrete implementations</li>
<li>❌ Hard to test and maintain</li>
<li>❌ Violates dependency inversion principle</li>
</ul>
<h4><strong>God Module</strong></h4>
<ul>
<li>❌ Single module with too many responsibilities</li>
<li>❌ Hard to understand and maintain</li>
<li>❌ Violates single responsibility principle</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Basic entity design</li>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity with business logic</li>
<li><a href="./04-email-address-value-object.md">EmailAddress Value Object</a> - Value object example</li>
<li><a href="./05-pricing-service.md">Pricing Service</a> - Domain service example</li>
<li><a href="../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns">Modules and Separation of Concerns</a> - Module concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 05-pricing-service.md</li>
<li>Next: 07-order-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns">Modules and Separation of Concerns</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/06-customer-module","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"06-customer-module"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"06-customer-module\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/06-customer-module","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
