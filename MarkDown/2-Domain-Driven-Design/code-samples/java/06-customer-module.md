# Customer Module - Java Example

**Section**: [Modules and Separation of Concerns](../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns)

**Navigation**: [← Previous: Pricing Service](./05-pricing-service.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Customer Module with Separation of Concerns
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
                throw new IllegalArgumentException("Customer ID cannot be null");
            }
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Name cannot be null or empty");
            }
            if (email == null) {
                throw new IllegalArgumentException("Email cannot be null");
            }
            
            this.id = id;
            this.name = name.trim();
            this.email = email;
            this.status = CustomerStatus.PENDING;
            this.createdAt = LocalDateTime.now();
            this.ordersCount = 0;
            this.totalSpent = Money.zero("USD");
        }
        
        // ✅ Business Operations
        public void activate() {
            if (status == CustomerStatus.SUSPENDED) {
                throw new IllegalStateException("Cannot activate suspended customer");
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
                throw new IllegalStateException("Cannot update email for suspended customer");
            }
            this.email = newEmail;
            this.lastActivity = LocalDateTime.now();
        }
        
        public void updateName(String newName) {
            if (newName == null || newName.trim().isEmpty()) {
                throw new IllegalArgumentException("Name cannot be null or empty");
            }
            this.name = newName.trim();
            this.lastActivity = LocalDateTime.now();
        }
        
        public void recordOrder(Money orderAmount) {
            if (status != CustomerStatus.ACTIVE) {
                throw new IllegalStateException("Only active customers can place orders");
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
            return totalSpent.getAmount() >= 1000;
        }
        
        public boolean isPremium() {
            return totalSpent.getAmount() >= 500;
        }
        
        public String getCustomerType() {
            if (isVip()) {
                return "VIP";
            } else if (isPremium()) {
                return "Premium";
            } else {
                return "Standard";
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
            return String.format("Customer{id=%s, name='%s', email=%s, status=%s}",
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
                throw new IllegalArgumentException("Name cannot be empty");
            }
            
            EmailAddress email = EmailAddress.of(emailString);
            
            // ✅ Check if customer already exists
            Optional<Customer> existingCustomer = customerRepository.findByEmail(email);
            if (existingCustomer.isPresent()) {
                throw new IllegalArgumentException("Customer with this email already exists");
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
            Optional<Customer> customerOpt = customerRepository.findById(customerId);
            if (customerOpt.isEmpty()) {
                throw new IllegalArgumentException("Customer not found");
            }
            
            Customer customer = customerOpt.get();
            
            // ✅ Check if email is already in use
            Optional<Customer> existingCustomer = customerRepository.findByEmail(newEmail);
            if (existingCustomer.isPresent() && !existingCustomer.get().getId().equals(customerId)) {
                throw new IllegalArgumentException("Email already in use");
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
            Optional<Customer> customerOpt = customerRepository.findById(customerId);
            if (customerOpt.isEmpty()) {
                throw new IllegalArgumentException("Customer not found");
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
            Optional<Customer> customerOpt = customerRepository.findById(customerId);
            if (customerOpt.isEmpty()) {
                throw new IllegalArgumentException("Customer not found");
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
                    .orElseThrow(() -> new IllegalArgumentException("Customer not found"));
        }
        
        public List<Customer> getActiveCustomers() {
            return customerRepository.findByStatus(CustomerStatus.ACTIVE);
        }
        
        public List<Customer> getVipCustomers() {
            return customerRepository.findVipCustomers();
        }
    }
    
    // ✅ Repository Interfaces
    public interface CustomerRepository {
        void save(Customer customer);
        Optional<Customer> findById(CustomerId id);
        Optional<Customer> findByEmail(EmailAddress email);
        List<Customer> findByStatus(CustomerStatus status);
        List<Customer> findVipCustomers();
        List<Customer> findByCustomerType(String customerType);
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
            customer.recordOrder(Money.of(1000, "USD")); // Start as VIP
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
            return customer.getTotalSpent().getAmount() >= 1000;
        }
        
        public boolean isPremiumCustomer(Customer customer) {
            return customer.getTotalSpent().getAmount() >= 500;
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
        String name = "John Doe";
        String email = "john.doe@example.com";
        
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
        String name = "John Doe";
        String email = "john.doe@example.com";
        
        CustomerModule.Customer existingCustomer = new CustomerModule.Customer(
            CustomerId.generate(), "Jane Doe", EmailAddress.of(email)
        );
        mockRepository.addCustomer(existingCustomer);
        
        // Act & Assert
        assertThrows(IllegalArgumentException.class, () -> {
            customerService.registerCustomer(name, email);
        });
    }
    
    @Test
    void shouldUpdateCustomerEmailSuccessfully() {
        // Arrange
        CustomerId customerId = CustomerId.generate();
        CustomerModule.Customer customer = new CustomerModule.Customer(
            customerId, "John Doe", EmailAddress.of("john.doe@example.com")
        );
        mockRepository.addCustomer(customer);
        
        String newEmail = "john.doe.new@example.com";
        
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
    private final Map<CustomerId, CustomerModule.Customer> customers = new HashMap<>();
    private final Map<EmailAddress, CustomerModule.Customer> customersByEmail = new HashMap<>();
    
    @Override
    public void save(CustomerModule.Customer customer) {
        customers.put(customer.getId(), customer);
        customersByEmail.put(customer.getEmail(), customer);
    }
    
    @Override
    public Optional<CustomerModule.Customer> findById(CustomerId id) {
        return Optional.ofNullable(customers.get(id));
    }
    
    @Override
    public Optional<CustomerModule.Customer> findByEmail(EmailAddress email) {
        return Optional.ofNullable(customersByEmail.get(email));
    }
    
    @Override
    public List<CustomerModule.Customer> findByStatus(CustomerStatus status) {
        return customers.values().stream()
                .filter(customer -> customer.getStatus() == status)
                .collect(Collectors.toList());
    }
    
    @Override
    public List<CustomerModule.Customer> findVipCustomers() {
        return customers.values().stream()
                .filter(CustomerModule.Customer::isVip)
                .collect(Collectors.toList());
    }
    
    @Override
    public List<CustomerModule.Customer> findByCustomerType(String customerType) {
        return customers.values().stream()
                .filter(customer -> customer.getCustomerType().equals(customerType))
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
        CustomerModule.Customer customer = customerService.registerCustomer("John Doe", "john.doe@example.com");
        System.out.println("Customer registered: " + customer);
        
        // Activate customer
        customerService.activateCustomer(customer.getId().getValue());
        System.out.println("Customer activated: " + customer);
        
        // Update email
        customerService.updateCustomerEmail(customer.getId().getValue(), "john.doe.new@example.com");
        System.out.println("Email updated: " + customer);
        
        // Check customer type
        System.out.println("Customer type: " + customer.getCustomerType());
        System.out.println("Is VIP: " + customer.isVip());
        System.out.println("Is Premium: " + customer.isPremium());
        
        // Get active customers
        List<CustomerModule.Customer> activeCustomers = customerService.getActiveCustomers();
        System.out.println("Active customers: " + activeCustomers.size());
    }
}
```

## Key Concepts Demonstrated

### Modules and Separation of Concerns

#### 1. **Clear Module Boundaries**
- ✅ CustomerModule contains all customer-related domain logic
- ✅ Clear separation between entities, services, and repositories
- ✅ Module provides a cohesive set of functionality

#### 2. **Separation of Concerns**
- ✅ Customer entity handles customer state and behavior
- ✅ CustomerService handles customer operations
- ✅ Repository handles data persistence
- ✅ EmailService handles email notifications

#### 3. **Module Organization**
- ✅ Entities, services, repositories, and value objects are organized
- ✅ Factory classes for object creation
- ✅ Specification classes for complex business rules
- ✅ Event classes for domain events

#### 4. **Dependency Injection**
- ✅ Dependencies are injected through constructors
- ✅ Services depend on interfaces, not implementations
- ✅ Easy to test and maintain

### Customer Module Design Principles

#### **Module Boundaries**
- ✅ CustomerModule contains all customer-related functionality
- ✅ Clear separation from other modules
- ✅ Module provides cohesive customer management

#### **Separation of Concerns**
- ✅ Customer entity handles customer state and behavior
- ✅ CustomerService handles customer operations
- ✅ Repository handles data persistence
- ✅ EmailService handles email notifications

#### **Dependency Injection**
- ✅ Dependencies are injected through constructors
- ✅ Services depend on interfaces, not implementations
- ✅ Easy to test and maintain

#### **Module Configuration**
- ✅ CustomerModuleConfiguration manages module setup
- ✅ Centralized configuration for dependencies
- ✅ Easy to configure for different environments

### Java Benefits for Module Organization
- **Packages**: Clear namespace organization
- **Interfaces**: Clear contracts for dependencies
- **Dependency Injection**: Constructor injection for dependencies
- **Factory Pattern**: Centralized object creation
- **Specification Pattern**: Complex business rules
- **Event Pattern**: Domain events for integration

### Common Anti-Patterns to Avoid

#### **Poor Module Organization**
- ❌ Everything in one class
- ❌ No clear boundaries
- ❌ Hard to understand and maintain

#### **Tight Coupling**
- ❌ Modules depend on concrete implementations
- ❌ Hard to test and maintain
- ❌ Violates dependency inversion principle

#### **God Module**
- ❌ Single module with too many responsibilities
- ❌ Hard to understand and maintain
- ❌ Violates single responsibility principle

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Basic entity design
- [Order Entity](./03-order-entity.md) - Entity with business logic
- [EmailAddress Value Object](./04-email-address-value-object.md) - Value object example
- [Pricing Service](./05-pricing-service.md) - Domain service example
- [Modules and Separation of Concerns](../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns) - Module concepts

/*
 * Navigation:
 * Previous: 05-pricing-service.md
 * Next: 07-order-tests.md
 *
 * Back to: [Modules and Separation of Concerns](../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns)
 */
