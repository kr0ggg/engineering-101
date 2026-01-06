# EmailAddress Value Object - TypeScript Example

**Section**: [Value Objects - Self-Validation](../../1-introduction-to-the-domain.md#self-validation)

**Navigation**: [← Previous: Order Entity](./03-order-entity.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Pricing Service →](./05-pricing-service.md)

---

```typescript
// TypeScript Example - EmailAddress Value Object
// File: 2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object.ts

export class EmailAddress {
    private readonly value: string;

    constructor(email: string) {
        if (!email || email.trim().length === 0) {
            throw new Error('Email address cannot be empty');
        }

        const trimmedEmail = email.trim().toLowerCase();
        
        if (!this.isValidEmail(trimmedEmail)) {
            throw new Error(`Invalid email address format: ${email}`);
        }

        this.value = trimmedEmail;
    }

    private isValidEmail(email: string): boolean {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    getValue(): string {
        return this.value;
    }

    getDomain(): string {
        return this.value.split('@')[1];
    }

    getLocalPart(): string {
        return this.value.split('@')[0];
    }

    equals(other: EmailAddress): boolean {
        return this.value === other.value;
    }

    toString(): string {
        return this.value;
    }

    // Factory methods for common cases
    static fromString(email: string): EmailAddress {
        return new EmailAddress(email);
    }

    static create(email: string): EmailAddress {
        return new EmailAddress(email);
    }
}

// Usage example
export class Customer {
    constructor(
        public readonly id: string,
        public readonly name: string,
        public readonly email: EmailAddress
    ) {}

    updateEmail(newEmail: EmailAddress): Customer {
        return new Customer(this.id, this.name, newEmail);
    }

    getEmailDomain(): string {
        return this.email.getDomain();
    }
}

// Example usage
const customer = new Customer(
    'customer-123',
    'John Doe',
    EmailAddress.fromString('john.doe@example.com')
);

console.log(customer.email.getValue()); // john.doe@example.com
console.log(customer.getEmailDomain()); // example.com

// Validation examples
try {
    new EmailAddress('invalid-email'); // Throws error
} catch (error) {
    console.error('Invalid email:', error.message);
}

try {
    new EmailAddress(''); // Throws error
} catch (error) {
    console.error('Empty email:', error.message);
}
```

## Key Concepts Demonstrated

### Self-Validation
- **Input Validation**: Email format validation in constructor
- **Normalization**: Converts to lowercase and trims whitespace
- **Error Handling**: Clear error messages for invalid input
- **Immutable**: Once created, email address cannot be changed

### Value Object Benefits
- **Type Safety**: Prevents primitive obsession with string
- **Validation**: Ensures all email addresses are valid
- **Consistency**: Normalizes email format across the system
- **Domain Clarity**: Makes email concept explicit in the domain
- **Reusability**: Can be used anywhere email addresses are needed

### TypeScript Features Used
- **Private Fields**: Encapsulated internal state
- **Readonly Properties**: Immutable value storage
- **Method Chaining**: Fluent API design
- **Static Methods**: Factory methods for creation
- **Type Safety**: Compile-time validation

## Related Concepts

- [Money Value Object](./02-money-value-object.md) - Another value object example
- [Customer Entity](./01-customer-entity.md) - Uses EmailAddress
- [Order Entity](./03-order-entity.md) - Uses EmailAddress in customer context
- [Unit Testing](../../1-introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing value object validation

/*
 * Navigation:
 * Previous: 03-order-entity.md
 * Next: 05-pricing-service.md
 *
 * Back to: [Value Objects - Self-Validation](../../1-introduction-to-the-domain.md#self-validation)
 */
