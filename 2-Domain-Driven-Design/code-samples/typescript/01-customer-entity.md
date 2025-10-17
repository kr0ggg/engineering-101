# Customer Entity - TypeScript Example

**Section**: [Domain Entities - Identity Management](../introduction-to-the-domain.md#entity-design-principles)

**Navigation**: [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Money Value Object →](./02-money-value-object.ts)

---

```typescript
// TypeScript Example
export class Customer {
    private readonly id: CustomerId;
    private name: string;
    private email: EmailAddress;
    private status: CustomerStatus;
    
    constructor(id: CustomerId, name: string, email: EmailAddress) {
        if (!id) throw new Error("Customer ID cannot be null");
        if (!name) throw new Error("Customer name cannot be null");
        if (!email) throw new Error("Customer email cannot be null");
        
        this.id = id;
        this.name = name;
        this.email = email;
        this.status = CustomerStatus.Active;
    }
    
    updateEmail(newEmail: EmailAddress): void {
        if (!newEmail) throw new Error("Email cannot be null");
        this.email = newEmail;
    }
    
    deactivate(): void {
        this.status = CustomerStatus.Inactive;
    }
    
    // Getters
    getId(): CustomerId { return this.id; }
    getName(): string { return this.name; }
    getEmail(): EmailAddress { return this.email; }
    getStatus(): CustomerStatus { return this.status; }
}
```

## Key Concepts Demonstrated

- **Identity Management**: Customer has a unique `CustomerId`
- **Encapsulation**: Private fields with controlled access through methods
- **Validation**: Constructor validates required parameters
- **Business Logic**: `deactivate()` method encapsulates business behavior
- **Immutability**: Identity field is readonly and cannot be changed
- **TypeScript Features**: Strong typing and access modifiers

## TypeScript-Specific Features

- **Access Modifiers**: `private` and `readonly` keywords
- **Type Annotations**: Explicit typing for parameters and return values
- **Null Checks**: Explicit null validation with error throwing
- **Getter Methods**: Standard getter pattern for controlled access
- **Export/Import**: Module system for code organization

## Type Safety Benefits

- **Compile-Time Validation**: TypeScript catches type errors at compile time
- **IntelliSense Support**: Better IDE support with type information
- **Refactoring Safety**: Type system helps prevent breaking changes
- **Documentation**: Types serve as inline documentation

## Related Concepts

- [Value Objects](../../1-introduction-to-the-domain.md#value-objects) - EmailAddress and CustomerId
- [Domain Services](../../1-introduction-to-the-domain.md#domain-services) - Customer management operations
- [Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation) - Order Entity example

/*
 * Navigation:
 * Previous: N/A
 * Next: 02-money-value-object.md
 *
 * Back to: [Domain Entities - Identity Management](../../1-introduction-to-the-domain.md#identity-management)
 */
