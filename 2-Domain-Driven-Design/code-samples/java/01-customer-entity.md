# Customer Entity - Java Example

**Section**: [Domain Entities - Identity Management](../../1-introduction-to-the-domain.md#identity-management)

**Navigation**: [← Previous: N/A] | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Money Value Object →](./02-money-value-object.md)

---

// Java Example - Customer Entity
// File: 2-Domain-Driven-Design/code-samples/java/01-customer-entity.java

import java.util.Objects;

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

// Supporting classes (simplified for example)
class CustomerId {
    private final String value;
    
    public CustomerId(String value) {
        this.value = Objects.requireNonNull(value, "Customer ID value cannot be null");
    }
    
    public static CustomerId generate() {
        return new CustomerId(java.util.UUID.randomUUID().toString());
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        CustomerId that = (CustomerId) obj;
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

enum CustomerStatus {
    ACTIVE, INACTIVE
}

class EmailAddress {
    private final String value;
    
    public EmailAddress(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Email address cannot be empty");
        }
        this.value = value.toLowerCase();
    }
    
    public String getValue() {
        return value;
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

/*
 * Navigation:
 * Previous: N/A
 * Next: 02-money-value-object.md
 *
 * Back to: [Domain Entities - Identity Management](../../1-introduction-to-the-domain.md#identity-management)
 */
