# Order Entity with Business Logic - TypeScript Example

**Section**: [Domain Entities - Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation)

**Navigation**: [← Previous: Money Value Object](./02-money-value-object.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: EmailAddress Value Object →](./04-email-address-value-object.md)

---

```typescript
// TypeScript Example - Order Entity with Business Logic
// File: 2-Domain-Driven-Design/code-samples/typescript/03-order-entity.ts

import { Money } from './02-money-value-object';

export class OrderId {
    private readonly value: string;

    constructor(value: string) {
        if (!value || value.trim().length === 0) {
            throw new Error('OrderId cannot be empty');
        }
        this.value = value;
    }

    equals(other: OrderId): boolean {
        return this.value === other.value;
    }

    toString(): string {
        return this.value;
    }

    static generate(): OrderId {
        return new OrderId(`order_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`);
    }
}

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
}

export class ProductId {
    private readonly value: string;

    constructor(value: string) {
        if (!value || value.trim().length === 0) {
            throw new Error('ProductId cannot be empty');
        }
        this.value = value;
    }

    equals(other: ProductId): boolean {
        return this.value === other.value;
    }

    toString(): string {
        return this.value;
    }
}

export enum OrderStatus {
    Draft = 'Draft',
    Confirmed = 'Confirmed',
    Shipped = 'Shipped',
    Delivered = 'Delivered',
    Cancelled = 'Cancelled'
}

export class OrderItem {
    constructor(
        public readonly productId: ProductId,
        public readonly quantity: number,
        public readonly unitPrice: Money
    ) {
        if (quantity <= 0) {
            throw new Error('Quantity must be positive');
        }
    }

    get totalPrice(): Money {
        return this.unitPrice.multiply(this.quantity);
    }

    equals(other: OrderItem): boolean {
        return this.productId.equals(other.productId) &&
               this.quantity === other.quantity &&
               this.unitPrice.equals(other.unitPrice);
    }
}

export class Order {
    private _items: OrderItem[] = [];
    private _status: OrderStatus = OrderStatus.Draft;

    constructor(
        public readonly id: OrderId,
        public readonly customerId: CustomerId,
        public readonly createdAt: Date = new Date()
    ) {}

    get items(): readonly OrderItem[] {
        return [...this._items];
    }

    get status(): OrderStatus {
        return this._status;
    }

    get totalAmount(): Money {
        return this._items.reduce(
            (total, item) => total.add(item.totalPrice),
            Money.zero('USD')
        );
    }

    get itemCount(): number {
        return this._items.length;
    }

    // Business Logic Methods
    addItem(productId: ProductId, quantity: number, unitPrice: Money): void {
        if (this._status !== OrderStatus.Draft) {
            throw new Error('Cannot modify confirmed order');
        }

        if (quantity <= 0) {
            throw new Error('Quantity must be positive');
        }

        // Check if item already exists
        const existingItemIndex = this._items.findIndex(
            item => item.productId.equals(productId)
        );

        if (existingItemIndex >= 0) {
            // Update existing item
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

    removeItem(productId: ProductId): void {
        if (this._status !== OrderStatus.Draft) {
            throw new Error('Cannot modify confirmed order');
        }

        const index = this._items.findIndex(
            item => item.productId.equals(productId)
        );

        if (index >= 0) {
            this._items.splice(index, 1);
        }
    }

    updateItemQuantity(productId: ProductId, newQuantity: number): void {
        if (this._status !== OrderStatus.Draft) {
            throw new Error('Cannot modify confirmed order');
        }

        if (newQuantity <= 0) {
            throw new Error('Quantity must be positive');
        }

        const index = this._items.findIndex(
            item => item.productId.equals(productId)
        );

        if (index >= 0) {
            const item = this._items[index];
            this._items[index] = new OrderItem(
                productId,
                newQuantity,
                item.unitPrice
            );
        }
    }

    confirm(): void {
        if (this._status !== OrderStatus.Draft) {
            throw new Error('Order is not in draft status');
        }

        if (this._items.length === 0) {
            throw new Error('Cannot confirm empty order');
        }

        this._status = OrderStatus.Confirmed;
    }

    ship(): void {
        if (this._status !== OrderStatus.Confirmed) {
            throw new Error('Order must be confirmed before shipping');
        }

        this._status = OrderStatus.Shipped;
    }

    deliver(): void {
        if (this._status !== OrderStatus.Shipped) {
            throw new Error('Order must be shipped before delivery');
        }

        this._status = OrderStatus.Delivered;
    }

    cancel(): void {
        if (this._status === OrderStatus.Delivered) {
            throw new Error('Cannot cancel delivered order');
        }

        this._status = OrderStatus.Cancelled;
    }

    // Business Rules
    canBeModified(): boolean {
        return this._status === OrderStatus.Draft;
    }

    canBeConfirmed(): boolean {
        return this._status === OrderStatus.Draft && this._items.length > 0;
    }

    canBeShipped(): boolean {
        return this._status === OrderStatus.Confirmed;
    }

    canBeDelivered(): boolean {
        return this._status === OrderStatus.Shipped;
    }

    canBeCancelled(): boolean {
        return this._status !== OrderStatus.Delivered;
    }
}
```

## Key Concepts Demonstrated

### Business Logic Encapsulation
- **Order State Management**: Only draft orders can be modified
- **Item Management**: Adding items updates quantities and recalculates totals
- **Order Confirmation**: Orders must have items before they can be confirmed
- **Business Validation**: Quantity must be positive, products must exist

### TypeScript Benefits for DDD
- **Type Safety**: Compile-time checking of business rules
- **Enums**: Type-safe status management
- **Readonly Properties**: Immutable identity fields
- **Method Chaining**: Fluent API for business operations
- **Generic Types**: Reusable value object patterns

### Domain Rules Enforced
- Orders can only be modified when in draft status
- Orders must have items before confirmation
- Order status transitions follow business rules
- Quantity validation prevents invalid operations
- Immutable identity objects ensure consistency

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Basic entity example
- [Money Value Object](./02-money-value-object.md) - Used for pricing calculations
- [EmailAddress Value Object](./04-email-address-value-object.md) - Another value object example
- [Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation) - Entity design principles

/*
 * Navigation:
 * Previous: 02-money-value-object.md
 * Next: 04-email-address-value-object.md
 *
 * Back to: [Domain Entities - Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation)
 */
