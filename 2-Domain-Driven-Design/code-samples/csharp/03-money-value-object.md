# Money Value Object - C# Example

**Section**: [Value Objects - Immutability](../introduction-to-the-domain.md#immutability)

**Navigation**: [← Previous: Order Entity](./02-order-entity.cs) | [← Back to Introduction](../introduction-to-the-domain.md) | [Next: EmailAddress Value Object →](./04-email-address-value-object.cs)

---

```csharp
// C# Example - Money Value Object
public class Money
{
    public decimal Amount { get; }
    public Currency Currency { get; }
    
    public Money(decimal amount, Currency currency)
    {
        if (amount < 0)
            throw new ArgumentException("Amount cannot be negative");
            
        Amount = amount;
        Currency = currency ?? throw new ArgumentNullException(nameof(currency));
    }
    
    public Money Add(Money other)
    {
        if (other == null) throw new ArgumentNullException(nameof(other));
        if (Currency != other.Currency)
            throw new InvalidOperationException("Cannot add different currencies");
            
        return new Money(Amount + other.Amount, Currency);
    }
    
    public Money Multiply(decimal factor)
    {
        if (factor < 0)
            throw new ArgumentException("Factor cannot be negative");
            
        return new Money(Amount * factor, Currency);
    }
    
    public override bool Equals(object obj)
    {
        return obj is Money other && 
               Amount == other.Amount && 
               Currency == other.Currency;
    }
    
    public override int GetHashCode()
    {
        return HashCode.Combine(Amount, Currency);
    }
    
    public static Money Zero(Currency currency) => new Money(0, currency);
}
```

## Key Concepts Demonstrated

- **Immutability**: Properties are read-only, new instances created for operations
- **Value Equality**: Overrides `Equals()` and `GetHashCode()` for value-based comparison
- **Self-Validation**: Constructor validates business rules (non-negative amounts)
- **Domain Operations**: Business operations like `Add()` and `Multiply()`
- **Currency Safety**: Prevents mixing different currencies
- **Factory Methods**: `Zero()` static method for common values

## Value Object Characteristics

1. **No Identity**: Distinguished by value, not identity
2. **Immutable**: Cannot be changed after creation
3. **Self-Validating**: Enforces business rules in constructor
4. **Value Equality**: Two instances with same values are equal
5. **Side-Effect Free**: Operations return new instances

## Business Rules Enforced

- Amounts cannot be negative
- Currency must be specified
- Cannot add different currencies
- Multiplication factors must be non-negative

## Related Concepts

- [EmailAddress Value Object](./04-email-address-value-object.md) - Another value object example
- [Domain Services](../../1-introduction-to-the-domain.md#domain-services) - Using Money in calculations
- [Unit Testing](../../1-introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing value objects

/*
 * Navigation:
 * Previous: 02-order-entity.md
 * Next: 04-email-address-value-object.md
 *
 * Back to: [Value Objects - Immutability](../../1-introduction-to-the-domain.md#immutability)
 */
