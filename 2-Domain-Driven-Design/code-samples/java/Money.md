# Money Value Object - Java Example

**Section**: [Value Objects - Immutability](../introduction-to-the-domain.md#immutability)

**Navigation**: [← Previous: Customer Entity](./01-customer-entity.java) | [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Inventory Service →](./03-inventory-service.java)

---

```java
// Java Example - Money Value Object
public class Money {
    private final BigDecimal amount;
    private final Currency currency;
    
    public Money(BigDecimal amount, Currency currency) {
        if (amount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        this.amount = Objects.requireNonNull(amount, "Amount cannot be null");
        this.currency = Objects.requireNonNull(currency, "Currency cannot be null");
    }
    
    public Money add(Money other) {
        if (other == null) throw new IllegalArgumentException("Other money cannot be null");
        if (!this.currency.equals(other.currency)) {
            throw new IllegalArgumentException("Cannot add different currencies");
        }
        return new Money(this.amount.add(other.amount), this.currency);
    }
    
    public Money multiply(BigDecimal factor) {
        if (factor.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Factor cannot be negative");
        }
        return new Money(this.amount.multiply(factor), this.currency);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Money money = (Money) obj;
        return Objects.equals(amount, money.amount) && 
               Objects.equals(currency, money.currency);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(amount, currency);
    }
    
    public static Money zero(Currency currency) {
        return new Money(BigDecimal.ZERO, currency);
    }
}
```

## Key Concepts Demonstrated

- **Immutability**: Fields are final, new instances created for operations
- **Value Equality**: Overrides `equals()` and `hashCode()` for value-based comparison
- **Self-Validation**: Constructor validates business rules (non-negative amounts)
- **Domain Operations**: Business operations like `add()` and `multiply()`
- **Currency Safety**: Prevents mixing different currencies
- **Factory Methods**: `zero()` static method for common values

## Java-Specific Features

- **BigDecimal**: Precise decimal arithmetic for monetary calculations
- **Objects.equals()**: Null-safe equality comparison
- **Objects.hash()**: Null-safe hash code generation
- **Objects.requireNonNull()**: Built-in null validation
- **Final Fields**: Immutable instance variables

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

- [Customer Entity](./01-customer-entity.java) - Uses Money in domain operations
- [Inventory Service](./03-inventory-service.java) - Uses Money for pricing
- [Domain Services](../introduction-to-the-domain.md#domain-services) - Using Money in calculations
- [Unit Testing](../introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing value objects
