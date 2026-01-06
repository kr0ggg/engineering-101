# Pricing Service - C# Example

**Section**: [Domain Services](../../1-introduction-to-the-domain.md#domain-services)

**Navigation**: [← Previous: EmailAddress Value Object](./04-email-address-value-object.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Customer Module →](./06-customer-module.md)

---

```csharp
// C# Example - Pricing Service
public class PricingService
{
    public Money CalculateOrderTotal(Order order, Customer customer)
    {
        if (order == null) throw new ArgumentNullException(nameof(order));
        if (customer == null) throw new ArgumentNullException(nameof(customer));
        
        var subtotal = order.Items.Sum(item => item.TotalPrice);
        var discount = CalculateDiscount(order, customer);
        var tax = CalculateTax(subtotal, customer.Address);
        var shipping = CalculateShipping(order, customer.Address);
        
        return subtotal.Subtract(discount).Add(tax).Add(shipping);
    }
    
    private Money CalculateDiscount(Order order, Customer customer)
    {
        var discount = Money.Zero(order.Items.FirstOrDefault()?.Price.Currency ?? Currency.USD);
        
        // Premium customer discount
        if (customer.IsPremium())
        {
            discount = discount.Add(order.Subtotal.Multiply(0.1m)); // 10% discount
        }
        
        // Bulk order discount
        if (order.TotalQuantity >= 10)
        {
            discount = discount.Add(order.Subtotal.Multiply(0.05m)); // 5% bulk discount
        }
        
        return discount;
    }
    
    private Money CalculateTax(Money subtotal, Address address)
    {
        var taxRate = GetTaxRate(address);
        return subtotal.Multiply(taxRate);
    }
    
    private Money CalculateShipping(Order order, Address address)
    {
        var baseShipping = Money.Zero(Currency.USD);
        
        if (order.TotalWeight > 10) // Heavy items
        {
            baseShipping = baseShipping.Add(new Money(15, Currency.USD));
        }
        else if (order.TotalWeight > 5)
        {
            baseShipping = baseShipping.Add(new Money(10, Currency.USD));
        }
        else
        {
            baseShipping = baseShipping.Add(new Money(5, Currency.USD));
        }
        
        // Free shipping for orders over $50
        if (order.Subtotal.Amount >= 50)
        {
            return Money.Zero(Currency.USD);
        }
        
        return baseShipping;
    }
    
    private decimal GetTaxRate(Address address)
    {
        // Simplified tax calculation - in reality, this would be more complex
        return address.State switch
        {
            "CA" => 0.0875m,
            "NY" => 0.08m,
            "TX" => 0.0625m,
            _ => 0.05m
        };
    }
}
```

## Key Concepts Demonstrated

- **Domain Service**: Contains business logic that doesn't belong to entities
- **Cross-Entity Operations**: Works with Order and Customer entities
- **Complex Business Rules**: Handles multiple pricing scenarios
- **Stateless**: No internal state, pure business logic
- **Composition**: Combines multiple calculations (discount, tax, shipping)
- **Business Rules**: Encapsulates pricing policies and rules

## Business Rules Encapsulated

1. **Premium Customer Discount**: 10% discount for premium customers
2. **Bulk Order Discount**: 5% discount for orders with 10+ items
3. **Tax Calculation**: State-based tax rates
4. **Shipping Calculation**: Weight-based shipping with free shipping over $50
5. **Total Calculation**: Combines all pricing components

## When to Use Domain Services

- **Cross-Entity Logic**: Operations involving multiple entities
- **Complex Calculations**: Business rules too complex for single entity
- **Stateless Operations**: No need to maintain state
- **Domain-Specific Logic**: Business rules that are part of the domain

## Related Concepts

- [Order Entity](./02-order-entity.md) - Uses PricingService for calculations
- [Customer Entity](./01-customer-entity.md) - Customer information used in pricing
- [Money Value Object](./03-money-value-object.md) - Used for all monetary calculations
- [Unit Testing](../../1-introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing domain services

/*
 * Navigation:
 * Previous: 04-email-address-value-object.md
 * Next: 06-customer-module.md
 *
 * Back to: [Domain Services - Domain Service Design Principles](../../1-introduction-to-the-domain.md#domain-service-design-principles)
 */
