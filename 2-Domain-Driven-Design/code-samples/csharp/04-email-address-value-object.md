# EmailAddress Value Object - C# Example

**Section**: [Value Objects - Self-Validation](../../1-introduction-to-the-domain.md#self-validation)

**Navigation**: [← Previous: Money Value Object](./03-money-value-object.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Pricing Service →](./05-pricing-service.md)

---

```csharp
// C# Example - EmailAddress Value Object
public class EmailAddress
{
    public string Value { get; }
    
    public EmailAddress(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
            throw new ArgumentException("Email address cannot be empty");
            
        if (!IsValidEmail(value))
            throw new ArgumentException("Invalid email address format");
            
        Value = value.ToLowerInvariant();
    }
    
    private static bool IsValidEmail(string email)
    {
        try
        {
            var addr = new System.Net.Mail.MailAddress(email);
            return addr.Address == email;
        }
        catch
        {
            return false;
        }
    }
    
    public override bool Equals(object obj)
    {
        return obj is EmailAddress other && Value == other.Value;
    }
    
    public override int GetHashCode()
    {
        return Value.GetHashCode();
    }
    
    public override string ToString() => Value;
}
```

## Key Concepts Demonstrated

- **Self-Validation**: Constructor validates email format using .NET's MailAddress
- **Normalization**: Converts email to lowercase for consistency
- **Immutability**: Value property is read-only
- **Value Equality**: Overrides `Equals()` and `GetHashCode()` for value-based comparison
- **String Representation**: Overrides `ToString()` for display
- **Business Rules**: Enforces valid email format and non-empty values

## Validation Rules

1. **Non-Empty**: Email cannot be null, empty, or whitespace
2. **Valid Format**: Must be a properly formatted email address
3. **Normalization**: Automatically converts to lowercase
4. **Consistency**: Same email addresses are always equal regardless of case

## Benefits of EmailAddress Value Object

- **Type Safety**: Prevents primitive obsession with string
- **Validation**: Ensures all email addresses are valid
- **Consistency**: Normalizes email format across the system
- **Domain Clarity**: Makes email concept explicit in the domain
- **Reusability**: Can be used anywhere email addresses are needed

## Related Concepts

- [Money Value Object](./03-money-value-object.md) - Another value object example
- [Customer Entity](./01-customer-entity.md) - Uses EmailAddress
- [Unit Testing](../../1-introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing value object validation

/*
 * Navigation:
 * Previous: 03-money-value-object.md
 * Next: 05-pricing-service.md
 *
 * Back to: [Value Objects - Self-Validation](../../1-introduction-to-the-domain.md#self-validation)
 */
