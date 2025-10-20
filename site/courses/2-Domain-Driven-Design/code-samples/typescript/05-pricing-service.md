# Pricing Service - TypeScript Example

**Section**: [Domain Services - Domain Service Design Principles](../../1-introduction-to-the-domain.md#domain-service-design-principles)

**Navigation**: [← Previous: EmailAddress Value Object](./04-email-address-value-object.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Customer Module →](./06-customer-module.md)

---

```typescript
// TypeScript Example - Pricing Service
// File: 2-Domain-Driven-Design/code-samples/typescript/05-pricing-service.ts

import { Money } from './02-money-value-object';
import { Order, OrderItem } from './03-order-entity';

export interface Customer {
    id: string;
    type: 'Standard' | 'Premium' | 'VIP';
    isActive: boolean;
}

export interface Address {
    state: string;
    country: string;
}

export class PricingService {
    // Stateless service - no instance variables

    calculateOrderTotal(
        order: Order,
        customer: Customer,
        shippingAddress: Address
    ): Money {
        if (!customer.isActive) {
            throw new Error('Cannot calculate pricing for inactive customer');
        }

        // Start with base order total
        let total = order.totalAmount;

        // Apply customer discounts
        total = this.applyCustomerDiscount(total, customer);

        // Apply bulk discounts
        total = this.applyBulkDiscount(total, order);

        // Add tax
        const tax = this.calculateTax(total, shippingAddress);
        total = total.add(tax);

        // Add shipping
        const shipping = this.calculateShipping(order, shippingAddress);
        total = total.add(shipping);

        return total;
    }

    private applyCustomerDiscount(total: Money, customer: Customer): Money {
        const discountRate = this.getCustomerDiscountRate(customer.type);
        const discountAmount = total.multiply(discountRate);
        return total.subtract(discountAmount);
    }

    private getCustomerDiscountRate(customerType: string): number {
        switch (customerType) {
            case 'VIP':
                return 0.15; // 15% discount
            case 'Premium':
                return 0.10; // 10% discount
            case 'Standard':
            default:
                return 0.05; // 5% discount
        }
    }

    private applyBulkDiscount(total: Money, order: Order): Money {
        const itemCount = order.itemCount;
        
        if (itemCount >= 20) {
            return total.multiply(0.95); // 5% bulk discount
        } else if (itemCount >= 10) {
            return total.multiply(0.97); // 3% bulk discount
        }
        
        return total;
    }

    private calculateTax(subtotal: Money, address: Address): Money {
        const taxRate = this.getTaxRate(address.state);
        return subtotal.multiply(taxRate);
    }

    private getTaxRate(state: string): number {
        // Simplified tax rates
        const taxRates: { [key: string]: number } = {
            'CA': 0.0875,
            'NY': 0.08,
            'TX': 0.0625,
            'FL': 0.06,
            'WA': 0.065
        };

        return taxRates[state] || 0.05; // Default 5% tax
    }

    private calculateShipping(order: Order, address: Address): Money {
        const baseShipping = Money.fromAmount(9.99, 'USD');
        const freeShippingThreshold = Money.fromAmount(50.00, 'USD');

        // Free shipping for orders over threshold
        if (order.totalAmount.isGreaterThanOrEqual(freeShippingThreshold)) {
            return Money.zero('USD');
        }

        // Weight-based shipping (simplified)
        const weightMultiplier = this.calculateWeightMultiplier(order);
        return baseShipping.multiply(weightMultiplier);
    }

    private calculateWeightMultiplier(order: Order): number {
        // Simplified weight calculation based on item count
        const itemCount = order.itemCount;
        
        if (itemCount >= 10) {
            return 1.5; // Heavier items
        } else if (itemCount >= 5) {
            return 1.2; // Medium weight
        }
        
        return 1.0; // Standard weight
    }

    // Utility methods for pricing calculations
    calculateDiscountAmount(
        originalAmount: Money,
        customer: Customer
    ): Money {
        const discountRate = this.getCustomerDiscountRate(customer.type);
        return originalAmount.multiply(discountRate);
    }

    isEligibleForFreeShipping(
        order: Order,
        address: Address
    ): boolean {
        const freeShippingThreshold = Money.fromAmount(50.00, 'USD');
        return order.totalAmount.isGreaterThanOrEqual(freeShippingThreshold);
    }

    getEffectiveTaxRate(address: Address): number {
        return this.getTaxRate(address.state);
    }
}

// Usage example
const pricingService = new PricingService();

const order = new Order(
    { value: 'order-123' } as any, // OrderId
    { value: 'customer-456' } as any, // CustomerId
    new Date()
);

// Add items to order
order.addItem(
    { value: 'product-1' } as any, // ProductId
    2,
    Money.fromAmount(25.00, 'USD')
);

const customer: Customer = {
    id: 'customer-456',
    type: 'Premium',
    isActive: true
};

const address: Address = {
    state: 'CA',
    country: 'US'
};

try {
    const total = pricingService.calculateOrderTotal(order, customer, address);
    console.log(`Order total: ${total.toString()}`);
} catch (error) {
    console.error('Pricing calculation failed:', error.message);
}
```

## Key Concepts Demonstrated

### Domain Service Design
- **Stateless**: No instance variables, pure functions
- **Cross-Entity Logic**: Operations involving multiple entities
- **Complex Calculations**: Business rules too complex for single entity
- **Stateless Operations**: No need to maintain state
- **Domain-Specific Logic**: Business rules that are part of the domain

### Service Methods
- **calculateOrderTotal()**: Main pricing calculation method
- **applyCustomerDiscount()**: Customer-specific discount logic
- **applyBulkDiscount()**: Volume-based discount calculations
- **calculateTax()**: Tax calculation based on location
- **calculateShipping()**: Shipping cost calculations

### TypeScript Benefits for Domain Services
- **Type Safety**: Compile-time checking of business rules
- **Interface Segregation**: Clear contracts for dependencies
- **Method Chaining**: Fluent API for complex calculations
- **Enum-like Types**: Type-safe customer types and states
- **Generic Constraints**: Type-safe money operations

## Related Concepts

- [Order Entity](./03-order-entity.md) - Uses PricingService for calculations
- [Customer Entity](./01-customer-entity.md) - Customer information used in pricing
- [Money Value Object](./02-money-value-object.md) - Used for all monetary calculations
- [Unit Testing](../../1-introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing domain services

/*
 * Navigation:
 * Previous: 04-email-address-value-object.md
 * Next: 06-customer-module.md
 *
 * Back to: [Domain Services - Domain Service Design Principles](../../1-introduction-to-the-domain.md#domain-service-design-principles)
 */
