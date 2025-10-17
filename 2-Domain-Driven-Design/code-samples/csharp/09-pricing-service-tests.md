# Pricing Service Tests - C# Example (xUnit)

**Section**: [Domain-Driven Design and Unit Testing - Domain Services](../introduction-to-the-domain.md#domain-services-enable-focused-testing)

**Navigation**: [← Previous: Money Tests](./08-money-tests.cs) | [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Customer Service Tests →](./10-customer-service-tests.cs)

---

```csharp
// C# Example - Testing Domain Services
public class PricingServiceTests
{
    private readonly PricingService _pricingService;
    
    public PricingServiceTests()
    {
        _pricingService = new PricingService();
    }
    
    [Fact]
    public void CalculateOrderTotal_PremiumCustomer_ShouldApplyDiscount()
    {
        // Arrange
        var order = CreateTestOrder();
        var premiumCustomer = CreatePremiumCustomer();
        
        // Act
        var total = _pricingService.CalculateOrderTotal(order, premiumCustomer);
        
        // Assert
        var expectedSubtotal = new Money(100.00m, Currency.USD);
        var expectedDiscount = new Money(10.00m, Currency.USD); // 10% discount
        var expectedTotal = expectedSubtotal.Subtract(expectedDiscount);
        
        Assert.Equal(expectedTotal.Amount, total.Amount);
    }
    
    [Fact]
    public void CalculateOrderTotal_BulkOrder_ShouldApplyBulkDiscount()
    {
        // Arrange
        var bulkOrder = CreateBulkOrder(); // Order with 10+ items
        var regularCustomer = CreateRegularCustomer();
        
        // Act
        var total = _pricingService.CalculateOrderTotal(bulkOrder, regularCustomer);
        
        // Assert
        // Should have 5% bulk discount
        Assert.True(total.Amount < bulkOrder.Subtotal.Amount);
    }
    
    [Fact]
    public void CalculateOrderTotal_OrderOver50Dollars_ShouldHaveFreeShipping()
    {
        // Arrange
        var largeOrder = CreateLargeOrder(); // Order over $50
        var customer = CreateRegularCustomer();
        
        // Act
        var total = _pricingService.CalculateOrderTotal(largeOrder, customer);
        
        // Assert
        // Total should not include shipping costs
        var expectedTotal = largeOrder.Subtotal.Add(CalculateTax(largeOrder.Subtotal));
        Assert.Equal(expectedTotal.Amount, total.Amount);
    }
    
    private Order CreateTestOrder()
    {
        var order = new Order(OrderId.Generate(), CustomerId.Generate());
        var product = new Product(ProductId.Generate(), "Test Product", new Money(100.00m, Currency.USD));
        order.AddItem(product, 1);
        return order;
    }
    
    private Customer CreatePremiumCustomer()
    {
        var customer = new Customer(CustomerId.Generate(), "Premium Customer", 
                                  new EmailAddress("premium@example.com"), 
                                  new Address("123 Main St", "City", "State", "12345"));
        customer.SetPremiumStatus(true);
        return customer;
    }
    
    // Additional helper methods...
}
```

## Key Testing Concepts Demonstrated

- **Domain Service Testing**: Testing stateless business logic
- **Test Data Builders**: Helper methods for creating test objects
- **Business Scenario Testing**: Testing complex business rules
- **Focused Testing**: Testing specific pricing scenarios
- **Pure Logic Testing**: No external dependencies or mocks needed
- **Comprehensive Coverage**: Testing different customer types and order scenarios

## Test Categories

1. **Premium Customer Discount**: Testing 10% discount for premium customers
2. **Bulk Order Discount**: Testing 5% discount for large orders
3. **Free Shipping**: Testing free shipping for orders over $50
4. **Complex Scenarios**: Testing multiple discounts combined

## Test Data Builders

- **CreateTestOrder()**: Creates a standard test order
- **CreatePremiumCustomer()**: Creates a premium customer for testing
- **CreateRegularCustomer()**: Creates a regular customer for testing
- **CreateBulkOrder()**: Creates an order with many items
- **CreateLargeOrder()**: Creates an order over $50

## Domain Service Testing Benefits

- **Stateless**: No state management complexity
- **Pure Logic**: Business rules without external dependencies
- **Focused**: Each test focuses on specific business scenarios
- **Fast**: No database or external service calls
- **Reliable**: Deterministic results

## Testing Best Practices Shown

- **Helper Methods**: Reusable test data creation
- **Descriptive Names**: Clear test scenario descriptions
- **Specific Assertions**: Testing exact business rule outcomes
- **Scenario Coverage**: Testing different business scenarios

## Related Concepts

- [Pricing Service](./05-pricing-service.cs) - The service being tested
- [Order Entity](./02-order-entity.cs) - Used in pricing calculations
- [Customer Entity](./01-customer-entity.cs) - Customer information for pricing
- [Money Value Object](./03-money-value-object.cs) - Used for monetary calculations
- [Domain Services](../introduction-to-the-domain.md#domain-services) - Domain service concepts
