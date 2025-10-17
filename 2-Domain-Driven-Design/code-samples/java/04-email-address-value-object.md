# EmailAddress Value Object - Java Example

**Section**: [Value Objects and Immutability](../../1-introduction-to-the-domain.md#value-objects-and-immutability)

**Navigation**: [← Previous: Order Entity](./03-order-entity.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - EmailAddress Value Object with Self-Validation
// File: 2-Domain-Driven-Design/code-samples/java/04-email-address-value-object.java

import java.util.Objects;
import java.util.regex.Pattern;

// ✅ GOOD: Immutable Value Object with Self-Validation
public class EmailAddress {
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    );
    
    private final String value;
    
    private EmailAddress(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Email address cannot be null or empty");
        }
        
        String trimmedValue = value.trim();
        if (!isValidEmail(trimmedValue)) {
            throw new IllegalArgumentException("Invalid email address: " + trimmedValue);
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
        int atIndex = value.indexOf('@');
        if (atIndex == -1) {
            throw new IllegalStateException("Invalid email format");
        }
        return value.substring(atIndex + 1);
    }
    
    public String getLocalPart() {
        int atIndex = value.indexOf('@');
        if (atIndex == -1) {
            throw new IllegalStateException("Invalid email format");
        }
        return value.substring(0, atIndex);
    }
    
    public boolean isCorporateEmail() {
        String domain = getDomain();
        return domain.endsWith(".com") || 
               domain.endsWith(".org") || 
               domain.endsWith(".net");
    }
    
    public boolean isEducationalEmail() {
        String domain = getDomain();
        return domain.endsWith(".edu");
    }
    
    public boolean isGovernmentEmail() {
        String domain = getDomain();
        return domain.endsWith(".gov");
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
    }
    
    // ✅ Business Operations Using Value Objects
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
    
    public void activate() {
        if (status == CustomerStatus.SUSPENDED) {
            throw new IllegalStateException("Cannot activate suspended customer");
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
            return "Government";
        } else if (isEducationalCustomer()) {
            return "Educational";
        } else if (isCorporateCustomer()) {
            return "Corporate";
        } else {
            return "Personal";
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
        return String.format("Customer{id=%s, name='%s', email=%s, status=%s}",
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
            throw new IllegalArgumentException("Name cannot be empty");
        }
        
        EmailAddress email = EmailAddress.of(emailString);
        
        // ✅ Check if customer already exists
        Customer existingCustomer = customerRepository.findByEmail(email);
        if (existingCustomer != null) {
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
        Customer customer = customerRepository.findById(customerId);
        if (customer == null) {
            throw new IllegalArgumentException("Customer not found");
        }
        
        // ✅ Check if email is already in use
        Customer existingCustomer = customerRepository.findByEmail(newEmail);
        if (existingCustomer != null && !existingCustomer.getId().equals(customerId)) {
            throw new IllegalArgumentException("Email already in use");
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
            throw new IllegalArgumentException("Customer not found");
        }
        
        if (!customer.isActive()) {
            throw new IllegalStateException("Cannot send email to inactive customer");
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
    List<Customer> findByStatus(CustomerStatus status);
    List<Customer> findByEmailDomain(String domain);
}

// ✅ GOOD: Email Validation Service
public class EmailValidationService {
    private static final Pattern EMAIL_PATTERN = Pattern.compile(
        "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
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
        
        String domain = email.substring(email.indexOf('@') + 1);
        return domain.endsWith(".com") || 
               domain.endsWith(".org") || 
               domain.endsWith(".net");
    }
    
    public boolean isEducationalEmail(String email) {
        if (!isValidEmail(email)) {
            return false;
        }
        
        String domain = email.substring(email.indexOf('@') + 1);
        return domain.endsWith(".edu");
    }
    
    public boolean isGovernmentEmail(String email) {
        if (!isValidEmail(email)) {
            return false;
        }
        
        String domain = email.substring(email.indexOf('@') + 1);
        return domain.endsWith(".gov");
    }
    
    public String getEmailDomain(String email) {
        if (!isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email address");
        }
        
        return email.substring(email.indexOf('@') + 1);
    }
    
    public String getEmailLocalPart(String email) {
        if (!isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email address");
        }
        
        return email.substring(0, email.indexOf('@'));
    }
}

// ✅ GOOD: Email Address Factory
public class EmailAddressFactory {
    public static EmailAddress createCorporateEmail(String localPart, String companyDomain) {
        String email = localPart + "@" + companyDomain + ".com";
        return EmailAddress.of(email);
    }
    
    public static EmailAddress createEducationalEmail(String localPart, String institutionDomain) {
        String email = localPart + "@" + institutionDomain + ".edu";
        return EmailAddress.of(email);
    }
    
    public static EmailAddress createGovernmentEmail(String localPart, String agencyDomain) {
        String email = localPart + "@" + agencyDomain + ".gov";
        return EmailAddress.of(email);
    }
    
    public static EmailAddress createPersonalEmail(String localPart, String providerDomain) {
        String email = localPart + "@" + providerDomain;
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
        if (newEmail == null || !newEmail.contains("@")) {
            throw new IllegalArgumentException("Invalid email");
        }
        this.email = newEmail;
    }
    
    public boolean isCorporateCustomer() {
        // ❌ Business logic scattered
        return email.endsWith(".com") || email.endsWith(".org");
    }
}

// ❌ BAD: Validation Scattered
class BadEmailValidator {
    public boolean validateEmail(String email) {
        // ❌ Validation logic scattered across multiple classes
        if (email == null || email.isEmpty()) {
            return false;
        }
        
        if (!email.contains("@")) {
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
        EmailAddress email = EmailAddress.of("john.doe@example.com");
        System.out.println("Email: " + email);
        System.out.println("Domain: " + email.getDomain());
        System.out.println("Local part: " + email.getLocalPart());
        System.out.println("Is corporate: " + email.isCorporateEmail());
        
        // Create customer with email
        CustomerId customerId = CustomerId.generate();
        Customer customer = new Customer(customerId, "John Doe", email);
        customer.activate();
        
        System.out.println("Customer: " + customer);
        System.out.println("Customer type: " + customer.getCustomerType());
        
        // Update email
        EmailAddress newEmail = EmailAddress.of("john.doe@company.com");
        customer.updateEmail(newEmail);
        
        System.out.println("Updated customer: " + customer);
        System.out.println("New customer type: " + customer.getCustomerType());
        
        // Test email validation
        EmailValidationService validator = new EmailValidationService();
        System.out.println("Is valid: " + validator.isValidEmail("test@example.com"));
        System.out.println("Is corporate: " + validator.isCorporateEmail("test@company.com"));
        
        // Test email factory
        EmailAddress corporateEmail = EmailAddressFactory.createCorporateEmail("jane", "acme");
        System.out.println("Corporate email: " + corporateEmail);
        
        EmailAddress educationalEmail = EmailAddressFactory.createEducationalEmail("student", "university");
        System.out.println("Educational email: " + educationalEmail);
    }
}
```

## Key Concepts Demonstrated

### Value Objects and Immutability

#### 1. **Self-Validation**
- ✅ EmailAddress validates itself during construction
- ✅ Invalid email addresses are rejected immediately
- ✅ Validation logic is encapsulated within the value object

#### 2. **Immutability**
- ✅ EmailAddress is immutable once created
- ✅ All fields are final
- ✅ No setter methods

#### 3. **Value-Based Equality**
- ✅ Two EmailAddress objects with the same value are equal
- ✅ hashCode() is consistent with equals()
- ✅ Can be used as keys in collections

#### 4. **Business Operations**
- ✅ EmailAddress provides business operations like getDomain()
- ✅ Business logic is encapsulated within the value object
- ✅ Operations are pure functions

### EmailAddress Value Object Design Principles

#### **Self-Validation**
- ✅ EmailAddress validates email format during construction
- ✅ Invalid emails are rejected with clear error messages
- ✅ Validation logic is centralized

#### **Immutability**
- ✅ EmailAddress cannot be modified after creation
- ✅ All fields are final
- ✅ Thread-safe by design

#### **Business Operations**
- ✅ EmailAddress provides domain-specific operations
- ✅ Operations like getDomain() and isCorporateEmail()
- ✅ Business logic is encapsulated

#### **Value-Based Equality**
- ✅ Two EmailAddress objects with same value are equal
- ✅ hashCode() is consistent with equals()
- ✅ Can be used as keys in HashMap

### Java Benefits for Value Objects
- **Final Fields**: Immutable objects with final fields
- **Strong Typing**: Compile-time type checking
- **Equals/HashCode**: Built-in support for value-based equality
- **Collections**: Can be used as keys in collections
- **Thread Safety**: Immutable objects are thread-safe
- **Error Handling**: Clear exception messages for validation

### Common Anti-Patterns to Avoid

#### **Primitive Obsession**
- ❌ Using String instead of EmailAddress
- ❌ No type safety for email addresses
- ❌ Scattered validation logic

#### **Validation Scattered**
- ❌ Validation logic spread across multiple classes
- ❌ Inconsistent validation rules
- ❌ Hard to maintain and test

#### **Mutable Value Objects**
- ❌ Value objects that can be modified
- ❌ Inconsistent state
- ❌ Thread safety issues

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Entity using EmailAddress
- [Order Entity](./03-order-entity.md) - Entity with business logic
- [Money Value Object](./02-money-value-object.md) - Another value object example
- [Value Objects and Immutability](../../1-introduction-to-the-domain.md#value-objects-and-immutability) - Value object concepts

/*
 * Navigation:
 * Previous: 03-order-entity.md
 * Next: 05-pricing-service.md
 *
 * Back to: [Value Objects and Immutability](../../1-introduction-to-the-domain.md#value-objects-and-immutability)
 */
