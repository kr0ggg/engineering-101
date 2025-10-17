# Customer Entity - Python Example

**Section**: [Domain Entities - Identity Management](../introduction-to-the-domain.md#entity-design-principles)

**Navigation**: [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Money Value Object →](./02-money-value-object.py)

---

```python
# Python Example
from dataclasses import dataclass
from typing import Optional

@dataclass(frozen=True)
class CustomerId:
    value: str

@dataclass
class Customer:
    id: CustomerId
    name: str
    email: EmailAddress
    status: CustomerStatus
    
    def __init__(self, id: CustomerId, name: str, email: EmailAddress):
        if not id:
            raise ValueError("Customer ID cannot be null")
        if not name:
            raise ValueError("Customer name cannot be null")
        if not email:
            raise ValueError("Customer email cannot be null")
            
        self.id = id
        self.name = name
        self.email = email
        self.status = CustomerStatus.ACTIVE
    
    def update_email(self, new_email: EmailAddress) -> None:
        if not new_email:
            raise ValueError("Email cannot be null")
        self.email = new_email
    
    def deactivate(self) -> None:
        self.status = CustomerStatus.INACTIVE
```

## Key Concepts Demonstrated

- **Identity Management**: Customer has a unique `CustomerId`
- **Encapsulation**: Controlled access through methods
- **Validation**: Constructor validates required parameters
- **Business Logic**: `deactivate()` method encapsulates business behavior
- **Python Features**: Dataclasses, type hints, and Pythonic patterns

## Python-Specific Features

- **Dataclasses**: `@dataclass` decorator for clean class definition
- **Type Hints**: Explicit typing with `typing` module
- **Frozen Dataclasses**: Immutable value objects with `@dataclass(frozen=True)`
- **ValueError**: Standard Python exception for invalid arguments
- **Property Access**: Direct attribute access with validation

## Python Benefits for DDD

- **Clean Syntax**: Concise and readable code
- **Type Hints**: Optional typing for better IDE support
- **Dataclasses**: Reduced boilerplate for data classes
- **Duck Typing**: Flexible object-oriented programming
- **Rich Standard Library**: Built-in validation and error handling

## Related Concepts

- [Value Objects](../introduction-to-the-domain.md#value-objects) - EmailAddress and CustomerId
- [Domain Services](../introduction-to-the-domain.md#domain-services) - Customer management operations
- [Business Logic Encapsulation](../introduction-to-the-domain.md#business-logic-encapsulation) - Order Entity example
