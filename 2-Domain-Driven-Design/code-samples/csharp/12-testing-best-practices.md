# Testing Best Practices - C# Example (xUnit)

**Section**: [Best Practices for DDD Unit Testing](../introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)

**Navigation**: [← Previous: Testing Anti-Patterns](./11-testing-anti-patterns.cs) | [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Domain Modeling Best Practices →](./13-domain-modeling-best-practices.cs)

---

```csharp
// Good - Testing business behavior
[Fact]
public void ConfirmOrder_WhenOrderIsEmpty_ShouldThrowException()
{
    var order = new Order(OrderId.Generate(), CustomerId.Generate());
    Assert.Throws<InvalidOperationException>(() => order.Confirm());
}

// Good - Clear test intent
[Fact]
public void AddItem_WhenOrderIsConfirmed_ShouldThrowInvalidOperationException()
{
    // Test implementation
}

// Good - Testing business rules thoroughly
[Fact]
public void CalculateDiscount_PremiumCustomerWithBulkOrder_ShouldApplyBothDiscounts()
{
    // Test complex business scenario
}

// Good - One concept per test
[Fact]
public void Money_Add_SameCurrency_ShouldReturnSum()
{
    var money1 = new Money(10, Currency.USD);
    var money2 = new Money(5, Currency.USD);
    var result = money1.Add(money2);
    Assert.Equal(new Money(15, Currency.USD), result);
}
```

## Best Practices Demonstrated

### 1. **Test Behavior, Not Implementation**
- **Focus**: Test what the code does, not how it does it
- **Benefit**: Tests remain stable during refactoring
- **Example**: Testing order confirmation behavior, not internal state changes

### 2. **Use Descriptive Test Names**
- **Format**: `MethodName_Scenario_ExpectedResult`
- **Benefit**: Tests serve as documentation
- **Example**: `AddItem_WhenOrderIsConfirmed_ShouldThrowInvalidOperationException`

### 3. **Test Edge Cases and Business Rules**
- **Focus**: Test complex business scenarios
- **Benefit**: Ensures business requirements are met
- **Example**: Testing multiple discount combinations

### 4. **Keep Tests Simple and Focused**
- **Principle**: One concept per test
- **Benefit**: Easy to understand and maintain
- **Example**: Testing single Money addition operation

## Testing Principles

### Behavior-Driven Testing
- **What**: Test observable behavior and outcomes
- **Why**: Ensures business requirements are met
- **How**: Focus on public methods and return values

### Scenario-Based Testing
- **What**: Test specific business scenarios
- **Why**: Validates real-world usage patterns
- **How**: Use descriptive test names and clear scenarios

### Edge Case Coverage
- **What**: Test boundary conditions and error cases
- **Why**: Ensures robust error handling
- **How**: Test invalid inputs and exceptional conditions

### Single Responsibility Testing
- **What**: Each test focuses on one behavior
- **Why**: Makes tests easier to understand and debug
- **How**: One assertion per test, clear test purpose

## Test Naming Conventions

### Pattern: `MethodName_Scenario_ExpectedResult`
- **MethodName**: The method being tested
- **Scenario**: The specific condition or context
- **ExpectedResult**: What should happen

### Examples:
- `AddItem_WhenOrderIsDraft_ShouldAddItem`
- `ConfirmOrder_WhenOrderIsEmpty_ShouldThrowException`
- `CalculateDiscount_PremiumCustomer_ShouldApplyDiscount`

## Test Structure

### Arrange-Act-Assert Pattern
```csharp
[Fact]
public void Example_Test()
{
    // Arrange - Set up test data
    var order = new Order(OrderId.Generate(), CustomerId.Generate());
    
    // Act - Execute the behavior
    order.AddItem(product, 2);
    
    // Assert - Verify the outcome
    Assert.Equal(1, order.Items.Count);
}
```

## Benefits of These Practices

1. **Maintainable**: Tests are easy to understand and modify
2. **Reliable**: Tests provide consistent results
3. **Documentation**: Tests serve as living documentation
4. **Confidence**: Comprehensive coverage builds confidence in changes
5. **Debugging**: Clear test names help identify issues quickly

## Related Concepts

- [Order Tests](./07-order-tests.md) - Examples of good testing practices
- [Money Tests](./08-money-tests.md) - Value object testing examples
- [Customer Service Tests](./10-customer-service-tests.md) - Mocking best practices
- [Testing Anti-Patterns](./11-testing-anti-patterns.md) - What to avoid
- [Unit Testing Benefits](../../1-introduction-to-the-domain.md#benefits-of-ddd-for-unit-testing)

/*
 * Navigation:
 * Previous: 11-testing-anti-patterns.md
 * Next: 13-domain-modeling-best-practices.md
 *
 * Back to: [Domain-Driven Design and Unit Testing - Best Practices for DDD Unit Testing](../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)
 */
