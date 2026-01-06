# Order Tests - C# Example (xUnit)

**Section**: [Domain-Driven Design and Unit Testing - Pure Domain Logic](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable)

**Navigation**: [← Previous: Customer Module](./06-customer-module.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Money Tests →](./08-money-tests.md)

---

```csharp
// C# Example - Easily Testable Domain Logic
public class OrderTests
{
    [Fact]
    public void AddItem_WhenOrderIsDraft_ShouldAddItem()
    {
        // Arrange
        var order = new Order(OrderId.Generate(), CustomerId.Generate());
        var product = new Product(ProductId.Generate(), "Test Product", new Money(10.00m, Currency.USD));
        
        // Act
        order.AddItem(product, 2);
        
        // Assert
        Assert.Equal(1, order.Items.Count);
        Assert.Equal(2, order.Items.First().Quantity);
        Assert.Equal(new Money(20.00m, Currency.USD), order.TotalAmount);
    }
    
    [Fact]
    public void AddItem_WhenOrderIsConfirmed_ShouldThrowException()
    {
        // Arrange
        var order = new Order(OrderId.Generate(), CustomerId.Generate());
        order.Confirm(); // Change status to confirmed
        var product = new Product(ProductId.Generate(), "Test Product", new Money(10.00m, Currency.USD));
        
        // Act & Assert
        Assert.Throws<InvalidOperationException>(() => 
            order.AddItem(product, 1));
    }
    
    [Fact]
    public void Confirm_WhenOrderIsEmpty_ShouldThrowException()
    {
        // Arrange
        var order = new Order(OrderId.Generate(), CustomerId.Generate());
        // Order has no items
        
        // Act & Assert
        Assert.Throws<InvalidOperationException>(() => 
            order.Confirm());
    }
}
```

## Key Testing Concepts Demonstrated

- **Pure Domain Logic**: Testing business rules without external dependencies
- **xUnit Framework**: Using `[Fact]` attributes and `Assert` methods
- **Arrange-Act-Assert**: Clear test structure
- **Business Rule Testing**: Validating order modification rules
- **Exception Testing**: Verifying proper exception handling
- **Fast Execution**: No database or external service calls

## Test Categories

1. **Happy Path**: `AddItem_WhenOrderIsDraft_ShouldAddItem()`
2. **Business Rule Violation**: `AddItem_WhenOrderIsConfirmed_ShouldThrowException()`
3. **Edge Case**: `Confirm_WhenOrderIsEmpty_ShouldThrowException()`

## Benefits of DDD for Testing

- **No External Dependencies**: Tests run fast and reliably
- **Deterministic**: Same input always produces same output
- **Business Focused**: Tests validate business rules, not implementation
- **Maintainable**: Changes to infrastructure don't break domain tests

## Testing Best Practices Shown

- **Descriptive Names**: Test names clearly describe the scenario
- **Single Responsibility**: Each test focuses on one behavior
- **Clear Assertions**: Specific assertions about expected outcomes
- **Proper Setup**: Clean arrange phase with test data

## Related Concepts

- [Order Entity](./02-order-entity.md) - The entity being tested
- [Money Tests](./08-money-tests.md) - Testing value objects
- [Customer Service Tests](./10-customer-service-tests.md) - Testing with mocks
- [Unit Testing Best Practices](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)

/*
 * Navigation:
 * Previous: 06-customer-module.md
 * Next: 08-money-tests.md
 *
 * Back to: [Domain-Driven Design and Unit Testing - Pure Domain Logic is Easily Testable](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable)
 */
