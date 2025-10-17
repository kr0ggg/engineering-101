# Customer Entity - Java Example

**Section**: [Domain Entities - Identity Management](../introduction-to-the-domain.md#entity-design-principles)

**Navigation**: [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Money Value Object →](./02-money-value-object.java)

---

```java
// Java Example
public class Customer {
    private final CustomerId id;
    private String name;
    private EmailAddress email;
    private CustomerStatus status;
    
    public Customer(CustomerId id, String name, EmailAddress email) {
        this.id = Objects.requireNonNull(id, "Customer ID cannot be null");
        this.name = Objects.requireNonNull(name, "Customer name cannot be null");
        this.email = Objects.requireNonNull(email, "Customer email cannot be null");
        this.status = CustomerStatus.ACTIVE;
    }
    
    public void updateEmail(EmailAddress newEmail) {
        if (newEmail == null) throw new IllegalArgumentException("Email cannot be null");
        this.email = newEmail;
    }
    
    public void deactivate() {
        this.status = CustomerStatus.INACTIVE;
    }
    
    // Getters
    public CustomerId getId() { return id; }
    public String getName() { return name; }
    public EmailAddress getEmail() { return email; }
    public CustomerStatus getStatus() { return status; }
}
```

## Key Concepts Demonstrated

- **Identity Management**: Customer has a unique `CustomerId`
- **Encapsulation**: Private fields with controlled access through methods
- **Validation**: Constructor validates required parameters using `Objects.requireNonNull()`
- **Business Logic**: `deactivate()` method encapsulates business behavior
- **Immutability**: Identity field is final and cannot be changed
- **Java Conventions**: Proper getter methods and null safety

## Java-Specific Features

- **Objects.requireNonNull()**: Built-in null validation
- **Final Fields**: Immutable identity field
- **Getter Methods**: Standard Java bean pattern
- **IllegalArgumentException**: Standard Java exception for invalid arguments

## Related Concepts

- [Value Objects](../introduction-to-the-domain.md#value-objects) - EmailAddress and CustomerId
- [Domain Services](../introduction-to-the-domain.md#domain-services) - Customer management operations
- [Business Logic Encapsulation](../introduction-to-the-domain.md#business-logic-encapsulation) - Order Entity example
