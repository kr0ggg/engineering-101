# Domain Modeling Best Practices - C# Example

**Section**: [Best Practices for Domain Modeling](../introduction-to-the-domain.md#best-practices-for-domain-modeling)

**Navigation**: [← Previous: Testing Best Practices](./12-testing-best-practices.cs) | [← Back to Introduction](../introduction-to-the-domain.md) | [← Back to C# Index](./README.md)

---

```csharp
// Good - Pure domain logic
public class Order
{
    public void AddItem(Product product, int quantity)
    {
        if (Status != OrderStatus.Draft)
            throw new InvalidOperationException("Cannot modify confirmed order");
            
        // Domain logic here
    }
}

// Bad - Mixed with infrastructure concerns
public class Order
{
    public void AddItem(Product product, int quantity)
    {
        if (Status != OrderStatus.Draft)
            throw new InvalidOperationException("Cannot modify confirmed order");
            
        // Bad - logging is an infrastructure concern
        _logger.LogInformation("Adding item to order");
        
        // Bad - database access is an infrastructure concern
        _database.Save(this);
    }
}

// Good - Rich domain model
public class Order
{
    public void Confirm()
    {
        if (Status != OrderStatus.Draft)
            throw new InvalidOperationException("Only draft orders can be confirmed");
            
        if (!Items.Any())
            throw new InvalidOperationException("Cannot confirm empty order");
            
        Status = OrderStatus.Confirmed;
    }
    
    public bool CanBeModified()
    {
        return Status == OrderStatus.Draft;
    }
}

// Bad - Anemic domain model
public class Order
{
    public OrderStatus Status { get; set; }
    public List<OrderItem> Items { get; set; }
    
    // No behavior - business logic is elsewhere
}

// Good - Validation in domain object
public class Money
{
    public Money(decimal amount, Currency currency)
    {
        if (amount < 0)
            throw new ArgumentException("Amount cannot be negative");
            
        Amount = amount;
        Currency = currency ?? throw new ArgumentNullException(nameof(currency));
    }
}

// Bad - Validation elsewhere
public class Money
{
    public decimal Amount { get; set; }
    public Currency Currency { get; set; }
    
    // No validation - relies on external validation
}

// Good - Value object for email
public class EmailAddress
{
    public string Value { get; }
    
    public EmailAddress(string value)
    {
        if (!IsValidEmail(value))
            throw new ArgumentException("Invalid email address");
            
        Value = value.ToLowerInvariant();
    }
}

// Bad - Primitive obsession
public class Customer
{
    public string Email { get; set; } // No validation, no consistency
}
```

## Best Practices Demonstrated

### 1. **Keep Domain Logic Pure**
- **Good**: Domain objects contain only business logic
- **Bad**: Mixing infrastructure concerns (logging, database access)
- **Benefit**: Domain remains focused and testable

### 2. **Use Rich Domain Models**
- **Good**: Domain objects contain both data and behavior
- **Bad**: Anemic models with only properties
- **Benefit**: Business logic is encapsulated and discoverable

### 3. **Validate at Domain Boundaries**
- **Good**: Domain objects validate their own state
- **Bad**: Relying on external validation
- **Benefit**: Ensures domain integrity and consistency

### 4. **Use Value Objects for Complex Types**
- **Good**: EmailAddress value object with validation
- **Bad**: Primitive obsession with raw strings
- **Benefit**: Type safety and domain clarity

## Domain Modeling Principles

### Separation of Concerns
- **Domain Layer**: Pure business logic
- **Infrastructure Layer**: Technical implementation
- **Application Layer**: Orchestration and coordination

### Encapsulation
- **Data Hiding**: Private fields and controlled access
- **Behavior Encapsulation**: Business rules in domain objects
- **State Management**: Controlled state transitions

### Consistency
- **Validation**: Domain objects enforce business rules
- **Immutability**: Value objects are immutable
- **Type Safety**: Strong typing prevents errors

## Benefits of Good Domain Modeling

1. **Maintainability**: Changes to business rules are localized
2. **Testability**: Pure domain logic is easily testable
3. **Understandability**: Code reflects business concepts
4. **Reliability**: Validation ensures data integrity
5. **Flexibility**: Technical implementation can change independently

## Common Pitfalls to Avoid

### Infrastructure Leakage
- **Problem**: Domain objects depend on infrastructure
- **Solution**: Use dependency injection and interfaces
- **Example**: Don't inject logger or database into domain objects

### Anemic Domain Models
- **Problem**: Domain objects are just data containers
- **Solution**: Move behavior into domain objects
- **Example**: Add business methods to entities

### Primitive Obsession
- **Problem**: Using primitives instead of domain types
- **Solution**: Create value objects for complex concepts
- **Example**: Use EmailAddress instead of string

### Validation Scattered
- **Problem**: Validation logic spread across layers
- **Solution**: Validate at domain boundaries
- **Example**: Constructor validation in value objects

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Example of good entity design
- [Order Entity](./02-order-entity.md) - Rich domain model example
- [Money Value Object](./03-money-value-object.md) - Value object best practices
- [EmailAddress Value Object](./04-email-address-value-object.md) - Validation example
- [Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling) - Domain modeling concepts

/*
 * Navigation:
 * Previous: 12-testing-best-practices.md
 * Next: N/A
 *
 * Back to: [Best Practices for Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling)
 */
