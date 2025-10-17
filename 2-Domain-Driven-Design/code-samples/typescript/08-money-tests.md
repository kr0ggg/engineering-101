# Money Tests - TypeScript Example (Jest)

**Section**: [Domain-Driven Design and Unit Testing - Value Objects](../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing)

**Navigation**: [← Previous: Order Tests](./07-order-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Pricing Service Tests →](./09-pricing-service-tests.md)

---

```typescript
// TypeScript Example - Money Tests (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/08-money-tests.ts

import { Money } from './02-money-value-object';

describe('Money Value Object', () => {
    describe('Creation and Validation', () => {
        it('should create money with valid amount and currency', () => {
            const money = new Money(100.50, 'USD');
            
            expect(money.amount).toBe(100.50);
            expect(money.currency).toBe('USD');
        });

        it('should throw error for negative amount', () => {
            expect(() => {
                new Money(-10.00, 'USD');
            }).toThrow('Amount cannot be negative');
        });

        it('should throw error for empty currency', () => {
            expect(() => {
                new Money(100.00, '');
            }).toThrow('Currency cannot be empty');
        });

        it('should throw error for null currency', () => {
            expect(() => {
                new Money(100.00, null as any);
            }).toThrow('Currency cannot be empty');
        });

        it('should handle zero amount', () => {
            const money = new Money(0, 'USD');
            expect(money.amount).toBe(0);
            expect(money.currency).toBe('USD');
        });

        it('should handle large amounts', () => {
            const money = new Money(999999.99, 'USD');
            expect(money.amount).toBe(999999.99);
        });
    });

    describe('Arithmetic Operations', () => {
        let usd100: Money;
        let usd50: Money;
        let eur100: Money;

        beforeEach(() => {
            usd100 = new Money(100.00, 'USD');
            usd50 = new Money(50.00, 'USD');
            eur100 = new Money(100.00, 'EUR');
        });

        describe('Addition', () => {
            it('should add same currency amounts', () => {
                const result = usd100.add(usd50);
                
                expect(result.amount).toBe(150.00);
                expect(result.currency).toBe('USD');
            });

            it('should throw error when adding different currencies', () => {
                expect(() => {
                    usd100.add(eur100);
                }).toThrow('Cannot add different currencies');
            });

            it('should return new instance (immutability)', () => {
                const result = usd100.add(usd50);
                
                expect(result).not.toBe(usd100);
                expect(result).not.toBe(usd50);
                expect(usd100.amount).toBe(100.00); // Original unchanged
            });

            it('should handle addition with zero', () => {
                const zero = new Money(0, 'USD');
                const result = usd100.add(zero);
                
                expect(result.equals(usd100)).toBe(true);
            });
        });

        describe('Subtraction', () => {
            it('should subtract same currency amounts', () => {
                const result = usd100.subtract(usd50);
                
                expect(result.amount).toBe(50.00);
                expect(result.currency).toBe('USD');
            });

            it('should throw error when subtracting different currencies', () => {
                expect(() => {
                    usd100.subtract(eur100);
                }).toThrow('Cannot subtract different currencies');
            });

            it('should handle subtraction resulting in zero', () => {
                const result = usd100.subtract(usd100);
                
                expect(result.amount).toBe(0);
                expect(result.currency).toBe('USD');
            });

            it('should handle subtraction resulting in negative (if business allows)', () => {
                const result = usd50.subtract(usd100);
                
                expect(result.amount).toBe(-50.00);
                expect(result.currency).toBe('USD');
            });
        });

        describe('Multiplication', () => {
            it('should multiply by positive factor', () => {
                const result = usd100.multiply(1.5);
                
                expect(result.amount).toBe(150.00);
                expect(result.currency).toBe('USD');
            });

            it('should multiply by decimal factor', () => {
                const result = usd100.multiply(0.1);
                
                expect(result.amount).toBe(10.00);
                expect(result.currency).toBe('USD');
            });

            it('should multiply by zero', () => {
                const result = usd100.multiply(0);
                
                expect(result.amount).toBe(0);
                expect(result.currency).toBe('USD');
            });

            it('should throw error for negative factor', () => {
                expect(() => {
                    usd100.multiply(-1);
                }).toThrow('Factor cannot be negative');
            });

            it('should handle multiplication with large factors', () => {
                const result = usd100.multiply(1000);
                
                expect(result.amount).toBe(100000.00);
                expect(result.currency).toBe('USD');
            });
        });

        describe('Division', () => {
            it('should divide by positive divisor', () => {
                const result = usd100.divide(2);
                
                expect(result.amount).toBe(50.00);
                expect(result.currency).toBe('USD');
            });

            it('should divide by decimal divisor', () => {
                const result = usd100.divide(0.5);
                
                expect(result.amount).toBe(200.00);
                expect(result.currency).toBe('USD');
            });

            it('should throw error for zero divisor', () => {
                expect(() => {
                    usd100.divide(0);
                }).toThrow('Cannot divide by zero');
            });

            it('should throw error for negative divisor', () => {
                expect(() => {
                    usd100.divide(-2);
                }).toThrow('Divisor cannot be negative');
            });
        });
    });

    describe('Comparison Operations', () => {
        let usd100: Money;
        let usd50: Money;
        let usd100_2: Money;
        let eur100: Money;

        beforeEach(() => {
            usd100 = new Money(100.00, 'USD');
            usd50 = new Money(50.00, 'USD');
            usd100_2 = new Money(100.00, 'USD');
            eur100 = new Money(100.00, 'EUR');
        });

        describe('Equality', () => {
            it('should be equal to same amount and currency', () => {
                expect(usd100.equals(usd100_2)).toBe(true);
            });

            it('should not be equal to different amount', () => {
                expect(usd100.equals(usd50)).toBe(false);
            });

            it('should not be equal to different currency', () => {
                expect(usd100.equals(eur100)).toBe(false);
            });

            it('should be equal to itself', () => {
                expect(usd100.equals(usd100)).toBe(true);
            });
        });

        describe('Greater Than', () => {
            it('should be greater than smaller amount', () => {
                expect(usd100.isGreaterThan(usd50)).toBe(true);
            });

            it('should not be greater than equal amount', () => {
                expect(usd100.isGreaterThan(usd100_2)).toBe(false);
            });

            it('should not be greater than larger amount', () => {
                expect(usd50.isGreaterThan(usd100)).toBe(false);
            });

            it('should throw error when comparing different currencies', () => {
                expect(() => {
                    usd100.isGreaterThan(eur100);
                }).toThrow('Cannot compare different currencies');
            });
        });

        describe('Less Than', () => {
            it('should be less than larger amount', () => {
                expect(usd50.isLessThan(usd100)).toBe(true);
            });

            it('should not be less than equal amount', () => {
                expect(usd100.isLessThan(usd100_2)).toBe(false);
            });

            it('should not be less than smaller amount', () => {
                expect(usd100.isLessThan(usd50)).toBe(false);
            });
        });

        describe('Greater Than or Equal', () => {
            it('should be greater than or equal to smaller amount', () => {
                expect(usd100.isGreaterThanOrEqual(usd50)).toBe(true);
            });

            it('should be greater than or equal to equal amount', () => {
                expect(usd100.isGreaterThanOrEqual(usd100_2)).toBe(true);
            });

            it('should not be greater than or equal to larger amount', () => {
                expect(usd50.isGreaterThanOrEqual(usd100)).toBe(false);
            });
        });

        describe('Less Than or Equal', () => {
            it('should be less than or equal to larger amount', () => {
                expect(usd50.isLessThanOrEqual(usd100)).toBe(true);
            });

            it('should be less than or equal to equal amount', () => {
                expect(usd100.isLessThanOrEqual(usd100_2)).toBe(true);
            });

            it('should not be less than or equal to smaller amount', () => {
                expect(usd100.isLessThanOrEqual(usd50)).toBe(false);
            });
        });
    });

    describe('Factory Methods', () => {
        it('should create zero amount', () => {
            const zero = Money.zero('USD');
            
            expect(zero.amount).toBe(0);
            expect(zero.currency).toBe('USD');
        });

        it('should create from amount', () => {
            const money = Money.fromAmount(150.75, 'EUR');
            
            expect(money.amount).toBe(150.75);
            expect(money.currency).toBe('EUR');
        });

        it('should create from string amount', () => {
            const money = Money.fromString('99.99', 'GBP');
            
            expect(money.amount).toBe(99.99);
            expect(money.currency).toBe('GBP');
        });

        it('should throw error for invalid string amount', () => {
            expect(() => {
                Money.fromString('invalid', 'USD');
            }).toThrow('Invalid amount format');
        });
    });

    describe('String Representation', () => {
        it('should format as currency string', () => {
            const money = new Money(123.45, 'USD');
            
            expect(money.toString()).toBe('$123.45');
        });

        it('should format different currencies correctly', () => {
            const eur = new Money(123.45, 'EUR');
            const gbp = new Money(123.45, 'GBP');
            
            expect(eur.toString()).toBe('€123.45');
            expect(gbp.toString()).toBe('£123.45');
        });

        it('should handle zero amount formatting', () => {
            const zero = Money.zero('USD');
            
            expect(zero.toString()).toBe('$0.00');
        });
    });

    describe('Edge Cases', () => {
        it('should handle very small amounts', () => {
            const money = new Money(0.01, 'USD');
            
            expect(money.amount).toBe(0.01);
            expect(money.currency).toBe('USD');
        });

        it('should handle very large amounts', () => {
            const money = new Money(999999999.99, 'USD');
            
            expect(money.amount).toBe(999999999.99);
            expect(money.currency).toBe('USD');
        });

        it('should handle precision correctly', () => {
            const money1 = new Money(0.1, 'USD');
            const money2 = new Money(0.2, 'USD');
            const result = money1.add(money2);
            
            expect(result.amount).toBeCloseTo(0.3, 2);
        });

        it('should handle currency case insensitivity', () => {
            const money1 = new Money(100, 'USD');
            const money2 = new Money(100, 'usd');
            
            expect(money1.equals(money2)).toBe(true);
        });
    });
});
```

## Key Concepts Demonstrated

### Value Object Testing
- **Comprehensive Coverage**: Testing all public methods and edge cases
- **Validation Testing**: Verifying constructor validation rules
- **Equality Testing**: Testing value-based equality and hash codes
- **Immutability Testing**: Ensuring objects cannot be modified after creation
- **Edge Case Testing**: Testing boundary conditions and invalid inputs

### Test Categories for Money
1. **Creation**: Constructor validation and factory methods
2. **Arithmetic**: Addition, subtraction, multiplication, division
3. **Comparison**: Equality, greater than, less than operations
4. **Factory Methods**: Zero, fromAmount, fromString methods
5. **Edge Cases**: Precision, large numbers, currency handling

### Jest Testing Features Used
- **describe/it blocks**: Organized test structure
- **beforeEach**: Test setup and data preparation
- **expect assertions**: Clear and readable assertions
- **Error testing**: Verifying proper exception handling
- **toBeCloseTo**: Precision testing for decimal numbers

### Testing Best Practices Shown
- **Comprehensive Coverage**: Testing all methods and edge cases
- **Clear Test Names**: Descriptive names explaining the scenario
- **Proper Assertions**: Specific assertions about expected behavior
- **Exception Testing**: Verifying proper exception handling

## Related Concepts

- [Money Value Object](./02-money-value-object.md) - The value object being tested
- [EmailAddress Value Object](./04-email-address-value-object.md) - Another value object being tested
- [Order Tests](./07-order-tests.md) - Testing entities
- [Value Objects](../../1-introduction-to-the-domain.md#value-objects) - Value object concepts

/*
 * Navigation:
 * Previous: 07-order-tests.md
 * Next: 09-pricing-service-tests.md
 *
 * Back to: [Domain-Driven Design and Unit Testing - Value Objects Enable Comprehensive Testing](../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing)
 */
