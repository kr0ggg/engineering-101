# Customer Entity - C# Example

**Section**: [Domain Entities - Identity Management](../../1-introduction-to-the-domain.md#identity-management)

**Navigation**: [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Order Entity →](./02-order-entity.md)

---

```csharp
// C# Example
public class Customer
{
    public CustomerId Id { get; private set; }
    public string Name { get; private set; }
    public EmailAddress Email { get; private set; }
    public CustomerStatus Status { get; private set; }
    
    public Customer(CustomerId id, string name, EmailAddress email)
    {
        Id = id ?? throw new ArgumentNullException(nameof(id));
        Name = name ?? throw new ArgumentNullException(nameof(name));
        Email = email ?? throw new ArgumentNullException(nameof(email));
        Status = CustomerStatus.Active;
    }
    
    public void UpdateEmail(EmailAddress newEmail)
    {
        if (newEmail == null) throw new ArgumentNullException(nameof(newEmail));
        Email = newEmail;
    }
    
    public void Deactivate()
    {
        Status = CustomerStatus.Inactive;
    }
}
```

## Key Concepts Demonstrated

- **Identity Management**: Customer has a unique `CustomerId`
- **Encapsulation**: Properties are private set, modified through methods
- **Validation**: Constructor validates required parameters
- **Business Logic**: `Deactivate()` method encapsulates business behavior
- **Immutability**: Identity and core properties are protected from external modification

## Related Concepts

- [Value Objects](../../1-introduction-to-the-domain.md#value-objects) - EmailAddress and CustomerId
- [Domain Services](../../1-introduction-to-the-domain.md#domain-services) - Customer management operations
- [Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation) - Order Entity example

/*
 * Navigation:
 * Previous: N/A
 * Next: 02-order-entity.md
 *
 * Back to: [Domain Entities - Identity Management](../../1-introduction-to-the-domain.md#identity-management)
 */
