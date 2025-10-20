# Pricing Service Tests - TypeScript Example (Jest)

**Section**: [Domain-Driven Design and Unit Testing - Domain Services](../../1-introduction-to-the-domain.md#domain-services-enable-focused-testing)

**Navigation**: [← Previous: Money Tests](./08-money-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Customer Service Tests →](./10-customer-service-tests.md)

---

```typescript
// TypeScript Example - Pricing Service Tests (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests.ts

import { PricingService, Customer, Address } from './05-pricing-service';
import { Money } from './02-money-value-object';
import { Order, OrderId, CustomerId, ProductId } from './03-order-entity';

describe('Pricing Service', () => {
    let pricingService: PricingService;
    let standardCustomer: Customer;
    let premiumCustomer: Customer;
    let vipCustomer: Customer;
    let californiaAddress: Address;
    let newYorkAddress: Address;
    let texasAddress: Address;

    beforeEach(() => {
        pricingService = new PricingService();
        
        standardCustomer = {
            id: 'customer-1',
            type: 'Standard',
            isActive: true
        };
        
        premiumCustomer = {
            id: 'customer-2',
            type: 'Premium',
            isActive: true
        };
        
        vipCustomer = {
            id: 'customer-3',
            type: 'VIP',
            isActive: true
        };
        
        californiaAddress = { state: 'CA', country: 'US' };
        newYorkAddress = { state: 'NY', country: 'US' };
        texasAddress = { state: 'TX', country: 'US' };
    });

    describe('Order Total Calculation', () => {
        it('should calculate total for standard customer', () => {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                standardCustomer,
                californiaAddress
            );
            
            // Base: $50, Customer discount (5%): $47.50, Tax (8.75%): $51.66, Shipping: $9.99
            expect(total.amount).toBeCloseTo(61.65, 2);
        });

        it('should calculate total for premium customer', () => {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                premiumCustomer,
                californiaAddress
            );
            
            // Base: $50, Customer discount (10%): $45, Tax (8.75%): $48.94, Shipping: $9.99
            expect(total.amount).toBeCloseTo(58.93, 2);
        });

        it('should calculate total for VIP customer', () => {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                vipCustomer,
                californiaAddress
            );
            
            // Base: $50, Customer discount (15%): $42.50, Tax (8.75%): $46.22, Shipping: $9.99
            expect(total.amount).toBeCloseTo(56.21, 2);
        });

        it('should throw error for inactive customer', () => {
            const order = createTestOrder();
            const inactiveCustomer = { ...standardCustomer, isActive: false };
            
            expect(() => {
                pricingService.calculateOrderTotal(
                    order,
                    inactiveCustomer,
                    californiaAddress
                );
            }).toThrow('Cannot calculate pricing for inactive customer');
        });
    });

    describe('Customer Discounts', () => {
        it('should apply correct discount for standard customer', () => {
            const originalAmount = Money.fromAmount(100, 'USD');
            
            const discountAmount = pricingService.calculateDiscountAmount(
                originalAmount,
                standardCustomer
            );
            
            expect(discountAmount.amount).toBe(5); // 5% discount
        });

        it('should apply correct discount for premium customer', () => {
            const originalAmount = Money.fromAmount(100, 'USD');
            
            const discountAmount = pricingService.calculateDiscountAmount(
                originalAmount,
                premiumCustomer
            );
            
            expect(discountAmount.amount).toBe(10); // 10% discount
        });

        it('should apply correct discount for VIP customer', () => {
            const originalAmount = Money.fromAmount(100, 'USD');
            
            const discountAmount = pricingService.calculateDiscountAmount(
                originalAmount,
                vipCustomer
            );
            
            expect(discountAmount.amount).toBe(15); // 15% discount
        });
    });

    describe('Bulk Discounts', () => {
        it('should apply bulk discount for large orders', () => {
            const largeOrder = createLargeOrder(25); // 25 items
            
            const total = pricingService.calculateOrderTotal(
                largeOrder,
                standardCustomer,
                californiaAddress
            );
            
            // Should include 5% bulk discount
            expect(total.amount).toBeLessThan(1000); // Approximate check
        });

        it('should apply medium bulk discount for medium orders', () => {
            const mediumOrder = createMediumOrder(15); // 15 items
            
            const total = pricingService.calculateOrderTotal(
                mediumOrder,
                standardCustomer,
                californiaAddress
            );
            
            // Should include 3% bulk discount
            expect(total.amount).toBeLessThan(500); // Approximate check
        });

        it('should not apply bulk discount for small orders', () => {
            const smallOrder = createTestOrder(); // 2 items
            
            const total = pricingService.calculateOrderTotal(
                smallOrder,
                standardCustomer,
                californiaAddress
            );
            
            // No bulk discount should be applied
            expect(total.amount).toBeGreaterThan(50);
        });
    });

    describe('Tax Calculations', () => {
        it('should calculate correct tax for California', () => {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                standardCustomer,
                californiaAddress
            );
            
            const taxRate = pricingService.getEffectiveTaxRate(californiaAddress);
            expect(taxRate).toBe(0.0875); // 8.75%
        });

        it('should calculate correct tax for New York', () => {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                standardCustomer,
                newYorkAddress
            );
            
            const taxRate = pricingService.getEffectiveTaxRate(newYorkAddress);
            expect(taxRate).toBe(0.08); // 8%
        });

        it('should calculate correct tax for Texas', () => {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                standardCustomer,
                texasAddress
            );
            
            const taxRate = pricingService.getEffectiveTaxRate(texasAddress);
            expect(taxRate).toBe(0.0625); // 6.25%
        });

        it('should use default tax rate for unknown state', () => {
            const unknownAddress = { state: 'UNKNOWN', country: 'US' };
            
            const taxRate = pricingService.getEffectiveTaxRate(unknownAddress);
            expect(taxRate).toBe(0.05); // Default 5%
        });
    });

    describe('Shipping Calculations', () => {
        it('should provide free shipping for orders over threshold', () => {
            const largeOrder = createLargeOrder(30); // Large order
            
            const isEligible = pricingService.isEligibleForFreeShipping(
                largeOrder,
                californiaAddress
            );
            
            expect(isEligible).toBe(true);
        });

        it('should not provide free shipping for orders under threshold', () => {
            const smallOrder = createTestOrder(); // Small order
            
            const isEligible = pricingService.isEligibleForFreeShipping(
                smallOrder,
                californiaAddress
            );
            
            expect(isEligible).toBe(false);
        });

        it('should calculate shipping based on order size', () => {
            const smallOrder = createTestOrder();
            const mediumOrder = createMediumOrder(8);
            const largeOrder = createLargeOrder(15);
            
            const smallTotal = pricingService.calculateOrderTotal(
                smallOrder,
                standardCustomer,
                californiaAddress
            );
            
            const mediumTotal = pricingService.calculateOrderTotal(
                mediumOrder,
                standardCustomer,
                californiaAddress
            );
            
            const largeTotal = pricingService.calculateOrderTotal(
                largeOrder,
                standardCustomer,
                californiaAddress
            );
            
            // Shipping should increase with order size
            expect(largeTotal.amount).toBeGreaterThan(mediumTotal.amount);
            expect(mediumTotal.amount).toBeGreaterThan(smallTotal.amount);
        });
    });

    describe('Edge Cases', () => {
        it('should handle zero amount orders', () => {
            const emptyOrder = new Order(
                new OrderId('empty-order'),
                new CustomerId('customer-1')
            );
            
            const total = pricingService.calculateOrderTotal(
                emptyOrder,
                standardCustomer,
                californiaAddress
            );
            
            // Should only include shipping
            expect(total.amount).toBeCloseTo(9.99, 2);
        });

        it('should handle very large orders', () => {
            const hugeOrder = createHugeOrder(100);
            
            const total = pricingService.calculateOrderTotal(
                hugeOrder,
                vipCustomer,
                californiaAddress
            );
            
            expect(total.amount).toBeGreaterThan(0);
        });

        it('should handle orders with single item', () => {
            const singleItemOrder = new Order(
                new OrderId('single-item'),
                new CustomerId('customer-1')
            );
            
            singleItemOrder.addItem(
                new ProductId('product-1'),
                1,
                Money.fromAmount(10, 'USD')
            );
            
            const total = pricingService.calculateOrderTotal(
                singleItemOrder,
                standardCustomer,
                californiaAddress
            );
            
            expect(total.amount).toBeGreaterThan(10);
        });
    });

    // Helper methods
    function createTestOrder(): Order {
        const order = new Order(
            new OrderId('test-order'),
            new CustomerId('customer-1')
        );
        
        order.addItem(
            new ProductId('product-1'),
            2,
            Money.fromAmount(25, 'USD')
        );
        
        return order;
    }

    function createMediumOrder(itemCount: number): Order {
        const order = new Order(
            new OrderId('medium-order'),
            new CustomerId('customer-1')
        );
        
        for (let i = 0; i < itemCount; i++) {
            order.addItem(
                new ProductId(`product-${i}`),
                1,
                Money.fromAmount(10, 'USD')
            );
        }
        
        return order;
    }

    function createLargeOrder(itemCount: number): Order {
        const order = new Order(
            new OrderId('large-order'),
            new CustomerId('customer-1')
        );
        
        for (let i = 0; i < itemCount; i++) {
            order.addItem(
                new ProductId(`product-${i}`),
                1,
                Money.fromAmount(20, 'USD')
            );
        }
        
        return order;
    }

    function createHugeOrder(itemCount: number): Order {
        const order = new Order(
            new OrderId('huge-order'),
            new CustomerId('customer-1')
        );
        
        for (let i = 0; i < itemCount; i++) {
            order.addItem(
                new ProductId(`product-${i}`),
                1,
                Money.fromAmount(50, 'USD')
            );
        }
        
        return order;
    }
});
```

## Key Concepts Demonstrated

### Domain Service Testing
- **Focused Testing**: Test complex business rules in isolation
- **Mocked Dependencies**: Use test doubles for external services
- **Scenario Testing**: Test various business scenarios and edge cases
- **Integration Testing**: Test how multiple domain objects work together

### Test Categories for Pricing Service
1. **Order Total Calculation**: Main pricing calculation method
2. **Customer Discounts**: Different customer type discounts
3. **Bulk Discounts**: Volume-based discount calculations
4. **Tax Calculations**: Tax rates for different states
5. **Shipping Calculations**: Shipping cost and free shipping rules
6. **Edge Cases**: Zero amounts, large orders, single items

### Jest Testing Features Used
- **describe/it blocks**: Organized test structure
- **beforeEach**: Test setup and data preparation
- **Helper Functions**: Reusable test data creation
- **toBeCloseTo**: Precision testing for monetary calculations
- **Custom Matchers**: Specific assertions for business rules

### Testing Best Practices Shown
- **Helper Methods**: Reusable test data creation
- **Descriptive Names**: Clear test scenario descriptions
- **Specific Assertions**: Testing exact business rule outcomes
- **Scenario Coverage**: Testing different business scenarios

## Related Concepts

- [Pricing Service](./05-pricing-service.md) - The service being tested
- [Order Entity](./03-order-entity.md) - Used in pricing calculations
- [Customer Entity](./01-customer-entity.md) - Customer information for pricing
- [Money Value Object](./02-money-value-object.md) - Used for monetary calculations
- [Domain Services](../../1-introduction-to-the-domain.md#domain-services) - Domain service concepts

/*
 * Navigation:
 * Previous: 08-money-tests.md
 * Next: 10-customer-service-tests.md
 *
 * Back to: [Domain-Driven Design and Unit Testing - Domain Services Enable Focused Testing](../../1-introduction-to-the-domain.md#domain-services-enable-focused-testing)
 */
