# Customer Module - TypeScript Example

**Section**: [Modules and Separation of Concerns - Module Implementation Example](../../1-introduction-to-the-domain.md#module-implementation-example)

**Navigation**: [← Previous: Pricing Service](./05-pricing-service.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Order Tests →](./07-order-tests.md)

---

```typescript
// TypeScript Example - Customer Module
// File: 2-Domain-Driven-Design/code-samples/typescript/06-customer-module.ts

import { EmailAddress } from './04-email-address-value-object';

// Customer Domain Objects
export class CustomerId {
    private readonly value: string;

    constructor(value: string) {
        if (!value || value.trim().length === 0) {
            throw new Error('CustomerId cannot be empty');
        }
        this.value = value;
    }

    equals(other: CustomerId): boolean {
        return this.value === other.value;
    }

    toString(): string {
        return this.value;
    }

    static generate(): CustomerId {
        return new CustomerId(`customer_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`);
    }
}

export enum CustomerStatus {
    Active = 'Active',
    Inactive = 'Inactive',
    Suspended = 'Suspended',
    Pending = 'Pending'
}

export class Customer {
    private _status: CustomerStatus = CustomerStatus.Pending;

    constructor(
        public readonly id: CustomerId,
        public readonly name: string,
        public readonly email: EmailAddress,
        public readonly createdAt: Date = new Date()
    ) {}

    get status(): CustomerStatus {
        return this._status;
    }

    activate(): void {
        if (this._status === CustomerStatus.Suspended) {
            throw new Error('Cannot activate suspended customer');
        }
        this._status = CustomerStatus.Active;
    }

    deactivate(): void {
        this._status = CustomerStatus.Inactive;
    }

    suspend(): void {
        this._status = CustomerStatus.Suspended;
    }

    isActive(): boolean {
        return this._status === CustomerStatus.Active;
    }

    canPlaceOrders(): boolean {
        return this._status === CustomerStatus.Active;
    }

    updateEmail(newEmail: EmailAddress): Customer {
        return new Customer(this.id, this.name, newEmail, this.createdAt);
    }

    updateName(newName: string): Customer {
        if (!newName || newName.trim().length === 0) {
            throw new Error('Customer name cannot be empty');
        }
        return new Customer(this.id, newName.trim(), this.email, this.createdAt);
    }
}

// Repository Interface
export interface ICustomerRepository {
    findById(id: CustomerId): Promise<Customer | null>;
    findByEmail(email: EmailAddress): Promise<Customer | null>;
    save(customer: Customer): Promise<void>;
    delete(id: CustomerId): Promise<void>;
    findAll(): Promise<Customer[]>;
}

// Domain Service
export class CustomerService {
    constructor(
        private readonly customerRepository: ICustomerRepository,
        private readonly emailService: IEmailService
    ) {}

    async registerCustomer(
        name: string,
        email: EmailAddress
    ): Promise<Customer> {
        // Check if customer already exists
        const existingCustomer = await this.customerRepository.findByEmail(email);
        if (existingCustomer) {
            throw new Error('Customer with this email already exists');
        }

        // Create new customer
        const customerId = CustomerId.generate();
        const customer = new Customer(customerId, name, email);
        
        // Activate customer
        customer.activate();

        // Save to repository
        await this.customerRepository.save(customer);

        // Send welcome email
        await this.emailService.sendWelcomeEmail(customer);

        return customer;
    }

    async updateCustomerProfile(
        customerId: CustomerId,
        name?: string,
        email?: EmailAddress
    ): Promise<Customer> {
        const customer = await this.customerRepository.findById(customerId);
        if (!customer) {
            throw new Error('Customer not found');
        }

        let updatedCustomer = customer;

        if (name !== undefined) {
            updatedCustomer = updatedCustomer.updateName(name);
        }

        if (email !== undefined) {
            // Check if new email is already taken
            const existingCustomer = await this.customerRepository.findByEmail(email);
            if (existingCustomer && !existingCustomer.id.equals(customerId)) {
                throw new Error('Email address is already in use');
            }
            updatedCustomer = updatedCustomer.updateEmail(email);
        }

        await this.customerRepository.save(updatedCustomer);
        return updatedCustomer;
    }

    async activateCustomer(customerId: CustomerId): Promise<void> {
        const customer = await this.customerRepository.findById(customerId);
        if (!customer) {
            throw new Error('Customer not found');
        }

        customer.activate();
        await this.customerRepository.save(customer);
    }

    async deactivateCustomer(customerId: CustomerId): Promise<void> {
        const customer = await this.customerRepository.findById(customerId);
        if (!customer) {
            throw new Error('Customer not found');
        }

        customer.deactivate();
        await this.customerRepository.save(customer);
    }

    async suspendCustomer(customerId: CustomerId): Promise<void> {
        const customer = await this.customerRepository.findById(customerId);
        if (!customer) {
            throw new Error('Customer not found');
        }

        customer.suspend();
        await this.customerRepository.save(customer);
    }

    async getCustomerById(customerId: CustomerId): Promise<Customer> {
        const customer = await this.customerRepository.findById(customerId);
        if (!customer) {
            throw new Error('Customer not found');
        }
        return customer;
    }

    async getAllActiveCustomers(): Promise<Customer[]> {
        const allCustomers = await this.customerRepository.findAll();
        return allCustomers.filter(customer => customer.isActive());
    }
}

// Email Service Interface
export interface IEmailService {
    sendWelcomeEmail(customer: Customer): Promise<void>;
    sendProfileUpdateEmail(customer: Customer): Promise<void>;
}

// Module Export
export const CustomerModule = {
    // Domain Objects
    CustomerId,
    Customer,
    CustomerStatus,
    
    // Services
    CustomerService,
    
    // Interfaces
    ICustomerRepository,
    IEmailService
};

// Usage Example
export class CustomerModuleExample {
    constructor(
        private customerService: CustomerService
    ) {}

    async demonstrateCustomerOperations(): Promise<void> {
        try {
            // Register new customer
            const email = EmailAddress.fromString('john.doe@example.com');
            const customer = await this.customerService.registerCustomer('John Doe', email);
            
            console.log(`Customer registered: ${customer.id.toString()}`);

            // Update customer profile
            const updatedCustomer = await this.customerService.updateCustomerProfile(
                customer.id,
                'John Smith',
                EmailAddress.fromString('john.smith@example.com')
            );

            console.log(`Customer updated: ${updatedCustomer.name}`);

            // Get customer details
            const retrievedCustomer = await this.customerService.getCustomerById(customer.id);
            console.log(`Customer status: ${retrievedCustomer.status}`);

        } catch (error) {
            console.error('Customer operation failed:', error.message);
        }
    }
}
```

## Key Concepts Demonstrated

### Module Organization
- **High Cohesion**: Related customer concepts grouped together
- **Low Coupling**: Clear interfaces define module boundaries
- **Domain-Driven**: Module reflects business capabilities
- **Separation of Concerns**: Domain logic separated from infrastructure

### Module Components
- **Domain Objects**: CustomerId, Customer, CustomerStatus
- **Repository Interface**: ICustomerRepository for data access
- **Domain Service**: CustomerService for business operations
- **External Service Interface**: IEmailService for email operations

### Business Operations
- **Customer Registration**: Creates new customers with validation
- **Profile Updates**: Updates customer information with business rules
- **Customer Retrieval**: Gets customer by ID with error handling
- **Status Management**: Handles customer activation/deactivation

### TypeScript Module Benefits
- **Namespace Organization**: Clear module boundaries
- **Interface Segregation**: Well-defined contracts
- **Type Safety**: Compile-time validation of business rules
- **Export Control**: Public API clearly defined
- **Dependency Injection**: Services depend on interfaces

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Basic customer entity
- [EmailAddress Value Object](./04-email-address-value-object.md) - Used in customer
- [Pricing Service](./05-pricing-service.md) - Uses customer information
- [Unit Testing](../../1-introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing customer operations

/*
 * Navigation:
 * Previous: 05-pricing-service.md
 * Next: 07-order-tests.md
 *
 * Back to: [Modules and Separation of Concerns - Module Implementation Example](../../1-introduction-to-the-domain.md#module-implementation-example)
 */
