# Money Value Object - TypeScript Example

**Section**: [Value Objects - Immutability](../../1-introduction-to-the-domain.md#immutability)

**Navigation**: [← Previous: Customer Entity](./01-customer-entity.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to TypeScript Index](./README.md)

---

```typescript
// TypeScript Example - Money Value Object
export class Money {
    private readonly amount: number;
    private readonly currency: Currency;
    
    constructor(amount: number, currency: Currency) {
        if (amount < 0) throw new Error("Amount cannot be negative");
        if (!currency) throw new Error("Currency cannot be null");
        
        this.amount = amount;
        this.currency = currency;
    }
    
    add(other: Money): Money {
        if (!other) throw new Error("Other money cannot be null");
        if (this.currency !== other.currency) {
            throw new Error("Cannot add different currencies");
        }
        return new Money(this.amount + other.amount, this.currency);
    }
    
    multiply(factor: number): Money {
        if (factor < 0) throw new Error("Factor cannot be negative");
        return new Money(this.amount * factor, this.currency);
    }
    
    equals(other: Money): boolean {
        return this.amount === other.amount && this.currency === other.currency;
    }
    
    static zero(currency: Currency): Money {
        return new Money(0, currency);
    }
}
```

## Key Concepts Demonstrated

- **Immutability**: Fields are readonly, new instances created for operations
- **Value Equality**: Custom `equals()` method for value-based comparison
- **Self-Validation**: Constructor validates business rules (non-negative amounts)
- **Domain Operations**: Business operations like `add()` and `multiply()`
- **Currency Safety**: Prevents mixing different currencies
- **Factory Methods**: `zero()` static method for common values

## TypeScript-Specific Features

- **Readonly Fields**: Immutable instance variables
- **Static Methods**: Factory methods for common operations
- **Type Annotations**: Explicit typing for parameters and return values
- **Error Handling**: Custom error messages for validation failures
- **Module Exports**: Clean module system for code organization

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

## TypeScript Benefits

- **Type Safety**: Compile-time type checking
- **IntelliSense**: Better IDE support with type information
- **Refactoring**: Safer refactoring with type system
- **Documentation**: Types serve as inline documentation

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Uses Money in domain operations
- [Value Objects](../../1-introduction-to-the-domain.md#value-objects) - Value object concepts
- [Domain Services](../../1-introduction-to-the-domain.md#domain-services) - Using Money in calculations
- [Unit Testing](../../1-introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing value objects

/*
 * Navigation:
 * Previous: 01-customer-entity.md
 * Next: N/A
 *
 * Back to: [Value Objects - Immutability](../../1-introduction-to-the-domain.md#immutability)
 */
