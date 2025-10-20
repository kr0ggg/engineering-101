# Domain Modeling Best Practices - TypeScript Example

**Section**: [Best Practices for Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling)

**Navigation**: [← Previous: Testing Best Practices](./12-testing-best-practices.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to TypeScript Index](./README.md)

---

```typescript
// TypeScript Example - Domain Modeling Best Practices
// File: 2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices.ts

// ✅ GOOD: Pure Domain Logic
export class Order {
    private _items: OrderItem[] = [];
    private _status: OrderStatus = OrderStatus.Draft;

    constructor(
        public readonly id: OrderId,
        public readonly customerId: CustomerId,
        public readonly createdAt: Date = new Date()
    ) {}

    // ✅ Business logic encapsulated in domain object
    addItem(productId: ProductId, quantity: number, unitPrice: Money): void {
        if (this._status !== OrderStatus.Draft) {
            throw new Error('Cannot modify confirmed order');
        }

        if (quantity <= 0) {
            throw new Error('Quantity must be positive');
        }

        // Business rule: Check if item already exists
        const existingItemIndex = this._items.findIndex(
            item => item.productId.equals(productId)
        );

        if (existingItemIndex >= 0) {
            // Update existing item quantity
            const existingItem = this._items[existingItemIndex];
            const newQuantity = existingItem.quantity + quantity;
            this._items[existingItemIndex] = new OrderItem(
                productId,
                newQuantity,
                unitPrice
            );
        } else {
            // Add new item
            this._items.push(new OrderItem(productId, quantity, unitPrice));
        }
    }

    // ✅ Business rules as methods
    canBeModified(): boolean {
        return this._status === OrderStatus.Draft;
    }

    canBeConfirmed(): boolean {
        return this._status === OrderStatus.Draft && this._items.length > 0;
    }
}

// ✅ GOOD: Rich Domain Models with Behavior
export class Customer {
    private _status: CustomerStatus = CustomerStatus.Pending;

    constructor(
        public readonly id: CustomerId,
        public readonly name: string,
        public readonly email: EmailAddress,
        public readonly createdAt: Date = new Date()
    ) {}

    // ✅ Behavior encapsulated with data
    activate(): void {
        if (this._status === CustomerStatus.Suspended) {
            throw new Error('Cannot activate suspended customer');
        }
        this._status = CustomerStatus.Active;
    }

    isActive(): boolean {
        return this._status === CustomerStatus.Active;
    }

    canPlaceOrders(): boolean {
        return this._status === CustomerStatus.Active;
    }

    // ✅ Immutable updates return new instances
    updateEmail(newEmail: EmailAddress): Customer {
        return new Customer(this.id, this.name, newEmail, this.createdAt);
    }
}

// ✅ GOOD: Validation at Domain Boundaries
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

    // ✅ Self-validating value object
    equals(other: EmailAddress): boolean {
        return this.value === other.value;
    }
}

// ✅ GOOD: Value Objects for Complex Types
export class Money {
    constructor(
        public readonly amount: number,
        public readonly currency: string
    ) {
        if (amount < 0) {
            throw new Error('Amount cannot be negative');
        }
        if (!currency || currency.trim().length === 0) {
            throw new Error('Currency cannot be empty');
        }
    }

    // ✅ Immutable operations return new instances
    add(other: Money): Money {
        if (this.currency !== other.currency) {
            throw new Error('Cannot add different currencies');
        }
        return new Money(this.amount + other.amount, this.currency);
    }

    multiply(factor: number): Money {
        if (factor < 0) {
            throw new Error('Factor cannot be negative');
        }
        return new Money(this.amount * factor, this.currency);
    }

    // ✅ Value-based equality
    equals(other: Money): boolean {
        return this.amount === other.amount && this.currency === other.currency;
    }

    // ✅ Factory methods for common values
    static zero(currency: string): Money {
        return new Money(0, currency);
    }

    static fromAmount(amount: number, currency: string): Money {
        return new Money(amount, currency);
    }
}

// ✅ GOOD: Design for Testability
export class PricingService {
    // ✅ Stateless service - no instance variables
    calculateOrderTotal(
        order: Order,
        customer: Customer,
        shippingAddress: Address
    ): Money {
        if (!customer.isActive()) {
            throw new Error('Cannot calculate pricing for inactive customer');
        }

        // ✅ Pure function - same inputs always produce same outputs
        let total = order.totalAmount;
        total = this.applyCustomerDiscount(total, customer);
        total = this.applyBulkDiscount(total, order);
        
        const tax = this.calculateTax(total, shippingAddress);
        const shipping = this.calculateShipping(order, shippingAddress);
        
        return total.add(tax).add(shipping);
    }

    // ✅ Private methods for complex calculations
    private applyCustomerDiscount(total: Money, customer: Customer): Money {
        const discountRate = this.getCustomerDiscountRate(customer.type);
        const discountAmount = total.multiply(discountRate);
        return total.subtract(discountAmount);
    }

    private getCustomerDiscountRate(customerType: string): number {
        switch (customerType) {
            case 'VIP': return 0.15;
            case 'Premium': return 0.10;
            case 'Standard': return 0.05;
            default: return 0.05;
        }
    }
}

// ✅ GOOD: Clear Domain Interfaces
export interface ICustomerRepository {
    findById(id: CustomerId): Promise<Customer | null>;
    findByEmail(email: EmailAddress): Promise<Customer | null>;
    save(customer: Customer): Promise<void>;
    delete(id: CustomerId): Promise<void>;
}

// ✅ GOOD: Domain Service with Clear Responsibilities
export class CustomerService {
    constructor(
        private readonly customerRepository: ICustomerRepository,
        private readonly emailService: IEmailService
    ) {}

    // ✅ Single responsibility per method
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
        customer.activate();

        // Save and notify
        await this.customerRepository.save(customer);
        await this.emailService.sendWelcomeEmail(customer);

        return customer;
    }
}

// ❌ BAD: Anemic Domain Model
export class BadOrder {
    // ❌ Only data, no behavior
    public id: string;
    public customerId: string;
    public items: any[];
    public status: string;
    public totalAmount: number;

    constructor(id: string, customerId: string) {
        this.id = id;
        this.customerId = customerId;
        this.items = [];
        this.status = 'Draft';
        this.totalAmount = 0;
    }

    // ❌ Business logic in external service
    addItem(productId: string, quantity: number, unitPrice: number): void {
        // Business logic should be in the domain object
        if (this.status !== 'Draft') {
            throw new Error('Cannot modify confirmed order');
        }
        // ... rest of logic
    }
}

// ❌ BAD: Primitive Obsession
export class BadCustomer {
    // ❌ Using primitives instead of value objects
    public id: string;
    public name: string;
    public email: string; // Should be EmailAddress
    public status: string; // Should be CustomerStatus enum
    public createdAt: string; // Should be Date

    constructor(id: string, name: string, email: string) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.status = 'Pending';
        this.createdAt = new Date().toISOString();
    }
}

// ❌ BAD: Validation Scattered
export class BadOrderService {
    // ❌ Validation logic spread across layers
    async createOrder(orderData: any): Promise<void> {
        // Validation in service layer
        if (!orderData.customerId) {
            throw new Error('Customer ID is required');
        }
        
        if (!orderData.items || orderData.items.length === 0) {
            throw new Error('Order must have items');
        }

        // More validation scattered throughout
        for (const item of orderData.items) {
            if (item.quantity <= 0) {
                throw new Error('Invalid quantity');
            }
        }
    }
}

// ✅ GOOD: Domain Events for Significant Changes
export class OrderConfirmedEvent {
    constructor(
        public readonly orderId: OrderId,
        public readonly customerId: CustomerId,
        public readonly totalAmount: Money,
        public readonly occurredAt: Date = new Date()
    ) {}
}

export class Order {
    // ... existing code ...

    confirm(): void {
        if (this._status !== OrderStatus.Draft) {
            throw new Error('Order is not in draft status');
        }

        if (this._items.length === 0) {
            throw new Error('Cannot confirm empty order');
        }

        this._status = OrderStatus.Confirmed;
        
        // ✅ Domain event for significant business event
        DomainEvents.raise(new OrderConfirmedEvent(
            this.id,
            this.customerId,
            this.totalAmount
        ));
    }
}

// ✅ GOOD: Aggregate Root Pattern
export class OrderAggregate {
    private _order: Order;
    private _items: OrderItem[] = [];
    private _events: DomainEvent[] = [];

    constructor(order: Order) {
        this._order = order;
    }

    // ✅ Aggregate enforces business rules
    addItem(productId: ProductId, quantity: number, unitPrice: Money): void {
        // Business rules enforced at aggregate level
        if (!this._order.canBeModified()) {
            throw new Error('Cannot modify confirmed order');
        }

        const item = new OrderItem(productId, quantity, unitPrice);
        this._items.push(item);
        
        // Update order total
        this._order.updateTotal(this.calculateTotal());
    }

    private calculateTotal(): Money {
        return this._items.reduce(
            (total, item) => total.add(item.totalPrice),
            Money.zero('USD')
        );
    }

    // ✅ Aggregate manages domain events
    getUncommittedEvents(): DomainEvent[] {
        return [...this._events];
    }

    markEventsAsCommitted(): void {
        this._events = [];
    }
}

// ✅ GOOD: Specification Pattern for Complex Business Rules
export class OrderSpecification {
    canBeConfirmed(order: Order): boolean {
        return order.status === OrderStatus.Draft &&
               order.items.length > 0 &&
               order.totalAmount.amount > 0;
    }

    canBeShipped(order: Order): boolean {
        return order.status === OrderStatus.Confirmed &&
               this.hasValidShippingAddress(order);
    }

    private hasValidShippingAddress(order: Order): boolean {
        // Complex business rule logic
        return true; // Simplified for example
    }
}

// ✅ GOOD: Factory Pattern for Complex Object Creation
export class CustomerFactory {
    static createStandardCustomer(
        name: string,
        email: EmailAddress
    ): Customer {
        const customerId = CustomerId.generate();
        const customer = new Customer(customerId, name, email);
        customer.activate();
        return customer;
    }

    static createVipCustomer(
        name: string,
        email: EmailAddress
    ): Customer {
        const customerId = CustomerId.generate();
        const customer = new Customer(customerId, name, email);
        customer.activate();
        // Additional VIP setup logic
        return customer;
    }
}
```

## Key Concepts Demonstrated

### Best Practices for Domain Modeling

#### 1. **Keep Domain Logic Pure**
- ✅ Domain objects should not depend on external frameworks
- ✅ Business rules are encapsulated in domain objects
- ✅ Pure functions for calculations and transformations

#### 2. **Use Rich Domain Models**
- ✅ Domain objects contain both data and behavior
- ✅ Business logic is contained within the objects that own the data
- ✅ Methods express business operations clearly

#### 3. **Validate at Domain Boundaries**
- ✅ Domain objects validate their state and enforce business rules
- ✅ Validation happens at the domain boundary
- ✅ Clear error messages for business rule violations

#### 4. **Use Value Objects for Complex Types**
- ✅ Value objects represent complex concepts and ensure consistency
- ✅ Immutable objects with value-based equality
- ✅ Factory methods for common values

#### 5. **Design for Testability**
- ✅ Minimize external dependencies
- ✅ Clear interfaces for dependencies
- ✅ Pure functions where possible
- ✅ Dependency injection for external services

### Domain Modeling Patterns

#### **Aggregate Root Pattern**
- ✅ Encapsulates business rules and invariants
- ✅ Manages domain events
- ✅ Controls access to aggregate members

#### **Domain Events**
- ✅ Communicate significant business events
- ✅ Enable loose coupling between aggregates
- ✅ Support eventual consistency

#### **Specification Pattern**
- ✅ Encapsulate complex business rules
- ✅ Reusable business logic
- ✅ Clear expression of business constraints

#### **Factory Pattern**
- ✅ Complex object creation logic
- ✅ Consistent object initialization
- ✅ Hide creation complexity

### TypeScript Benefits for Domain Modeling
- **Type Safety**: Compile-time checking of business rules
- **Interfaces**: Clear contracts for dependencies
- **Enums**: Type-safe status and state management
- **Generics**: Reusable patterns for value objects
- **Readonly Properties**: Immutable domain objects

### Common Anti-Patterns to Avoid

#### **Anemic Domain Model**
- ❌ Domain objects contain only data
- ❌ Business logic in external services
- ❌ No encapsulation of business rules

#### **Primitive Obsession**
- ❌ Using primitives instead of domain types
- ❌ No type safety for business concepts
- ❌ Scattered validation logic

#### **Validation Scattered**
- ❌ Validation logic spread across layers
- ❌ Inconsistent business rule enforcement
- ❌ Hard to maintain and test

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Example of good entity design
- [Order Entity](./03-order-entity.md) - Rich domain model example
- [Money Value Object](./02-money-value-object.md) - Value object best practices
- [EmailAddress Value Object](./04-email-address-value-object.md) - Validation example
- [Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling) - Domain modeling concepts

/*
 * Navigation:
 * Previous: 12-testing-best-practices.md
 * Next: N/A
 *
 * Back to: [Best Practices for Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling)
 */
