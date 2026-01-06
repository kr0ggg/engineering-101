# Customer Service Tests - TypeScript Example (Jest)

**Section**: [Domain-Driven Design and Unit Testing - Isolated Testing](../../1-introduction-to-the-domain.md#isolated-testing-with-dependency-injection)

**Navigation**: [← Previous: Pricing Service Tests](./09-pricing-service-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Testing Anti-Patterns →](./11-testing-anti-patterns.md)

---

```typescript
// TypeScript Example - Testing with Mocked Dependencies (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/10-customer-service-tests.ts

import { 
    CustomerService, 
    Customer, 
    CustomerId, 
    CustomerStatus,
    ICustomerRepository,
    IEmailService 
} from './06-customer-module';
import { EmailAddress } from './04-email-address-value-object';

// Mock implementations
class MockCustomerRepository implements ICustomerRepository {
    private customers: Map<string, Customer> = new Map();

    async findById(id: CustomerId): Promise<Customer | null> {
        return this.customers.get(id.toString()) || null;
    }

    async findByEmail(email: EmailAddress): Promise<Customer | null> {
        for (const customer of this.customers.values()) {
            if (customer.email.equals(email)) {
                return customer;
            }
        }
        return null;
    }

    async save(customer: Customer): Promise<void> {
        this.customers.set(customer.id.toString(), customer);
    }

    async delete(id: CustomerId): Promise<void> {
        this.customers.delete(id.toString());
    }

    async findAll(): Promise<Customer[]> {
        return Array.from(this.customers.values());
    }

    // Test helper methods
    clear(): void {
        this.customers.clear();
    }

    getCustomerCount(): number {
        return this.customers.size;
    }
}

class MockEmailService implements IEmailService {
    public sentEmails: Array<{ type: string; customer: Customer }> = [];

    async sendWelcomeEmail(customer: Customer): Promise<void> {
        this.sentEmails.push({ type: 'welcome', customer });
    }

    async sendProfileUpdateEmail(customer: Customer): Promise<void> {
        this.sentEmails.push({ type: 'profile_update', customer });
    }

    // Test helper methods
    getSentEmailCount(): number {
        return this.sentEmails.length;
    }

    getWelcomeEmailCount(): number {
        return this.sentEmails.filter(e => e.type === 'welcome').length;
    }

    getProfileUpdateEmailCount(): number {
        return this.sentEmails.filter(e => e.type === 'profile_update').length;
    }

    clear(): void {
        this.sentEmails = [];
    }
}

describe('Customer Service', () => {
    let customerService: CustomerService;
    let mockRepository: MockCustomerRepository;
    let mockEmailService: MockEmailService;

    beforeEach(() => {
        mockRepository = new MockCustomerRepository();
        mockEmailService = new MockEmailService();
        customerService = new CustomerService(mockRepository, mockEmailService);
    });

    describe('Customer Registration', () => {
        it('should register new customer successfully', async () => {
            const email = EmailAddress.fromString('john.doe@example.com');
            
            const customer = await customerService.registerCustomer('John Doe', email);
            
            expect(customer.name).toBe('John Doe');
            expect(customer.email.equals(email)).toBe(true);
            expect(customer.status).toBe(CustomerStatus.Active);
            expect(customer.id).toBeDefined();
        });

        it('should save customer to repository', async () => {
            const email = EmailAddress.fromString('jane.doe@example.com');
            
            await customerService.registerCustomer('Jane Doe', email);
            
            expect(mockRepository.getCustomerCount()).toBe(1);
        });

        it('should send welcome email after registration', async () => {
            const email = EmailAddress.fromString('welcome@example.com');
            
            await customerService.registerCustomer('Welcome User', email);
            
            expect(mockEmailService.getWelcomeEmailCount()).toBe(1);
        });

        it('should throw error if customer already exists', async () => {
            const email = EmailAddress.fromString('existing@example.com');
            
            // Register first customer
            await customerService.registerCustomer('First User', email);
            
            // Try to register second customer with same email
            await expect(
                customerService.registerCustomer('Second User', email)
            ).rejects.toThrow('Customer with this email already exists');
        });

        it('should throw error for empty name', async () => {
            const email = EmailAddress.fromString('test@example.com');
            
            await expect(
                customerService.registerCustomer('', email)
            ).rejects.toThrow('Customer name cannot be empty');
        });

        it('should throw error for whitespace-only name', async () => {
            const email = EmailAddress.fromString('test@example.com');
            
            await expect(
                customerService.registerCustomer('   ', email)
            ).rejects.toThrow('Customer name cannot be empty');
        });
    });

    describe('Customer Profile Updates', () => {
        let existingCustomer: Customer;

        beforeEach(async () => {
            const email = EmailAddress.fromString('update@example.com');
            existingCustomer = await customerService.registerCustomer('Original Name', email);
        });

        it('should update customer name', async () => {
            const updatedCustomer = await customerService.updateCustomerProfile(
                existingCustomer.id,
                'Updated Name'
            );
            
            expect(updatedCustomer.name).toBe('Updated Name');
            expect(updatedCustomer.email.equals(existingCustomer.email)).toBe(true);
        });

        it('should update customer email', async () => {
            const newEmail = EmailAddress.fromString('newemail@example.com');
            
            const updatedCustomer = await customerService.updateCustomerProfile(
                existingCustomer.id,
                undefined,
                newEmail
            );
            
            expect(updatedCustomer.email.equals(newEmail)).toBe(true);
            expect(updatedCustomer.name).toBe(existingCustomer.name);
        });

        it('should update both name and email', async () => {
            const newEmail = EmailAddress.fromString('both@example.com');
            
            const updatedCustomer = await customerService.updateCustomerProfile(
                existingCustomer.id,
                'New Name',
                newEmail
            );
            
            expect(updatedCustomer.name).toBe('New Name');
            expect(updatedCustomer.email.equals(newEmail)).toBe(true);
        });

        it('should throw error if customer not found', async () => {
            const nonExistentId = CustomerId.generate();
            
            await expect(
                customerService.updateCustomerProfile(nonExistentId, 'New Name')
            ).rejects.toThrow('Customer not found');
        });

        it('should throw error if new email already exists', async () => {
            // Create another customer
            const email2 = EmailAddress.fromString('second@example.com');
            await customerService.registerCustomer('Second Customer', email2);
            
            // Try to update first customer to use second customer's email
            await expect(
                customerService.updateCustomerProfile(
                    existingCustomer.id,
                    undefined,
                    email2
                )
            ).rejects.toThrow('Email address is already in use');
        });

        it('should allow customer to keep their own email', async () => {
            const updatedCustomer = await customerService.updateCustomerProfile(
                existingCustomer.id,
                'New Name',
                existingCustomer.email
            );
            
            expect(updatedCustomer.name).toBe('New Name');
            expect(updatedCustomer.email.equals(existingCustomer.email)).toBe(true);
        });
    });

    describe('Customer Status Management', () => {
        let activeCustomer: Customer;

        beforeEach(async () => {
            const email = EmailAddress.fromString('status@example.com');
            activeCustomer = await customerService.registerCustomer('Status User', email);
        });

        it('should activate customer', async () => {
            // First deactivate the customer
            await customerService.deactivateCustomer(activeCustomer.id);
            
            // Then activate it
            await customerService.activateCustomer(activeCustomer.id);
            
            const customer = await customerService.getCustomerById(activeCustomer.id);
            expect(customer.status).toBe(CustomerStatus.Active);
        });

        it('should deactivate customer', async () => {
            await customerService.deactivateCustomer(activeCustomer.id);
            
            const customer = await customerService.getCustomerById(activeCustomer.id);
            expect(customer.status).toBe(CustomerStatus.Inactive);
        });

        it('should suspend customer', async () => {
            await customerService.suspendCustomer(activeCustomer.id);
            
            const customer = await customerService.getCustomerById(activeCustomer.id);
            expect(customer.status).toBe(CustomerStatus.Suspended);
        });

        it('should throw error when activating non-existent customer', async () => {
            const nonExistentId = CustomerId.generate();
            
            await expect(
                customerService.activateCustomer(nonExistentId)
            ).rejects.toThrow('Customer not found');
        });

        it('should throw error when deactivating non-existent customer', async () => {
            const nonExistentId = CustomerId.generate();
            
            await expect(
                customerService.deactivateCustomer(nonExistentId)
            ).rejects.toThrow('Customer not found');
        });

        it('should throw error when suspending non-existent customer', async () => {
            const nonExistentId = CustomerId.generate();
            
            await expect(
                customerService.suspendCustomer(nonExistentId)
            ).rejects.toThrow('Customer not found');
        });
    });

    describe('Customer Retrieval', () => {
        it('should get customer by ID', async () => {
            const email = EmailAddress.fromString('retrieve@example.com');
            const customer = await customerService.registerCustomer('Retrieve User', email);
            
            const retrievedCustomer = await customerService.getCustomerById(customer.id);
            
            expect(retrievedCustomer.id.equals(customer.id)).toBe(true);
            expect(retrievedCustomer.name).toBe('Retrieve User');
            expect(retrievedCustomer.email.equals(email)).toBe(true);
        });

        it('should throw error when customer not found', async () => {
            const nonExistentId = CustomerId.generate();
            
            await expect(
                customerService.getCustomerById(nonExistentId)
            ).rejects.toThrow('Customer not found');
        });

        it('should get all active customers', async () => {
            // Create multiple customers
            const email1 = EmailAddress.fromString('active1@example.com');
            const email2 = EmailAddress.fromString('active2@example.com');
            const email3 = EmailAddress.fromString('inactive@example.com');
            
            const customer1 = await customerService.registerCustomer('Active 1', email1);
            const customer2 = await customerService.registerCustomer('Active 2', email2);
            const customer3 = await customerService.registerCustomer('Inactive', email3);
            
            // Deactivate one customer
            await customerService.deactivateCustomer(customer3.id);
            
            const activeCustomers = await customerService.getAllActiveCustomers();
            
            expect(activeCustomers).toHaveLength(2);
            expect(activeCustomers.some(c => c.id.equals(customer1.id))).toBe(true);
            expect(activeCustomers.some(c => c.id.equals(customer2.id))).toBe(true);
            expect(activeCustomers.some(c => c.id.equals(customer3.id))).toBe(false);
        });
    });

    describe('Integration Scenarios', () => {
        it('should handle complete customer lifecycle', async () => {
            const email = EmailAddress.fromString('lifecycle@example.com');
            
            // Register customer
            const customer = await customerService.registerCustomer('Lifecycle User', email);
            expect(customer.status).toBe(CustomerStatus.Active);
            
            // Update profile
            const updatedCustomer = await customerService.updateCustomerProfile(
                customer.id,
                'Updated Lifecycle User',
                EmailAddress.fromString('updated@example.com')
            );
            expect(updatedCustomer.name).toBe('Updated Lifecycle User');
            
            // Suspend customer
            await customerService.suspendCustomer(updatedCustomer.id);
            const suspendedCustomer = await customerService.getCustomerById(updatedCustomer.id);
            expect(suspendedCustomer.status).toBe(CustomerStatus.Suspended);
            
            // Reactivate customer
            await customerService.activateCustomer(updatedCustomer.id);
            const reactivatedCustomer = await customerService.getCustomerById(updatedCustomer.id);
            expect(reactivatedCustomer.status).toBe(CustomerStatus.Active);
        });

        it('should handle multiple customers with different statuses', async () => {
            const emails = [
                EmailAddress.fromString('user1@example.com'),
                EmailAddress.fromString('user2@example.com'),
                EmailAddress.fromString('user3@example.com')
            ];
            
            const customers = [];
            for (let i = 0; i < emails.length; i++) {
                const customer = await customerService.registerCustomer(`User ${i + 1}`, emails[i]);
                customers.push(customer);
            }
            
            // Deactivate one customer
            await customerService.deactivateCustomer(customers[1].id);
            
            // Suspend another customer
            await customerService.suspendCustomer(customers[2].id);
            
            const activeCustomers = await customerService.getAllActiveCustomers();
            expect(activeCustomers).toHaveLength(1);
            expect(activeCustomers[0].id.equals(customers[0].id)).toBe(true);
        });
    });
});
```

## Key Concepts Demonstrated

### Isolated Testing with Dependency Injection
- **Mocked Dependencies**: Use test doubles for external services
- **Controlled Environment**: Use mocks to create predictable test scenarios
- **Fast Tests**: No real database or service calls during testing
- **Reliable Tests**: Tests don't fail due to external service issues

### Mock Implementation Patterns
- **Repository Mock**: In-memory storage for testing data persistence
- **Service Mock**: Track method calls and verify interactions
- **Helper Methods**: Test utilities for setup and verification
- **State Management**: Maintain test state across operations

### Jest Testing Features Used
- **Custom Mock Classes**: Implement interfaces for testing
- **Async/Await**: Proper async testing patterns
- **Error Testing**: Verify exception handling with rejects
- **Setup/Teardown**: beforeEach for clean test state
- **Custom Matchers**: Domain-specific assertions

### Testing Best Practices Shown
- **Constructor Setup**: Mocks created in constructor for reuse
- **Readonly Fields**: Immutable mock references
- **Specific Verifications**: Verifying exact method calls and parameters
- **Exception Testing**: Proper async exception testing
- **Clean Assertions**: Clear verification of expected behavior

## Related Concepts

- [Customer Module](./06-customer-module.md) - The module being tested
- [Customer Entity](./01-customer-entity.md) - Entity used in service
- [EmailAddress Value Object](./04-email-address-value-object.md) - Value object used
- [Dependency Injection](../../1-introduction-to-the-domain.md#isolated-testing-with-dependency-injection) - DI concepts
- [Unit Testing Best Practices](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)

/*
 * Navigation:
 * Previous: 09-pricing-service-tests.md
 * Next: 11-testing-anti-patterns.md
 *
 * Back to: [Domain-Driven Design and Unit Testing - Isolated Testing with Dependency Injection](../../1-introduction-to-the-domain.md#isolated-testing-with-dependency-injection)
 */
