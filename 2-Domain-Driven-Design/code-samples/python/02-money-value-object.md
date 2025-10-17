# Money Value Object - Python Example

**Section**: [Value Objects - Immutability](../introduction-to-the-domain.md#immutability)

**Navigation**: [← Previous: Customer Entity](./01-customer-entity.py) | [← Back to Introduction](../introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Money Value Object
from dataclasses import dataclass
from decimal import Decimal
from typing import Optional

@dataclass(frozen=True)
class Money:
    amount: Decimal
    currency: Currency
    
    def __post_init__(self):
        if self.amount < 0:
            raise ValueError("Amount cannot be negative")
        if not self.currency:
            raise ValueError("Currency cannot be null")
    
    def add(self, other: 'Money') -> 'Money':
        if not other:
            raise ValueError("Other money cannot be null")
        if self.currency != other.currency:
            raise ValueError("Cannot add different currencies")
        return Money(self.amount + other.amount, self.currency)
    
    def multiply(self, factor: Decimal) -> 'Money':
        if factor < 0:
            raise ValueError("Factor cannot be negative")
        return Money(self.amount * factor, self.currency)
    
    @classmethod
    def zero(cls, currency: Currency) -> 'Money':
        return cls(Decimal('0'), currency)
```

## Key Concepts Demonstrated

- **Immutability**: Frozen dataclass prevents modification after creation
- **Value Equality**: Dataclass automatically implements equality
- **Self-Validation**: `__post_init__` validates business rules
- **Domain Operations**: Business operations like `add()` and `multiply()`
- **Currency Safety**: Prevents mixing different currencies
- **Factory Methods**: `zero()` class method for common values

## Python-Specific Features

- **Frozen Dataclasses**: Immutable objects with `@dataclass(frozen=True)`
- **Decimal**: Precise decimal arithmetic for monetary calculations
- **Post-Init Validation**: `__post_init__` for validation after object creation
- **Class Methods**: Factory methods using `@classmethod`
- **Type Hints**: Forward references with string literals
- **ValueError**: Standard Python exception for validation failures

## Value Object Characteristics

1. **No Identity**: Distinguished by value, not identity
2. **Immutable**: Cannot be changed after creation (frozen dataclass)
3. **Self-Validating**: Enforces business rules in `__post_init__`
4. **Value Equality**: Automatic equality implementation from dataclass
5. **Side-Effect Free**: Operations return new instances

## Business Rules Enforced

- Amounts cannot be negative
- Currency must be specified
- Cannot add different currencies
- Multiplication factors must be non-negative

## Python Benefits for DDD

- **Clean Syntax**: Concise and readable code
- **Dataclasses**: Reduced boilerplate with automatic methods
- **Decimal Precision**: Accurate monetary calculations
- **Type Hints**: Better IDE support and documentation
- **Rich Standard Library**: Built-in validation and error handling

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
