# Order Tests - Java Example (JUnit 5)

**Section**: [Domain-Driven Design and Unit Testing - Pure Domain Logic](../introduction-to-the-domain.md#pure-domain-logic-is-easily-testable)

**Navigation**: [← Previous: Inventory Service](./03-inventory-service.java) | [← Back to Introduction](../introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Easily Testable Domain Logic
@ExtendWith(MockitoExtension.class)
class OrderTest {
    
    @Test
    void addItem_WhenOrderIsDraft_ShouldAddItem() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.generate());
        Product product = new Product(ProductId.generate(), "Test Product", 
                                   new Money(BigDecimal.valueOf(10.00), Currency.USD));
        
        // Act
        order.addItem(product, 2);
        
        // Assert
        assertEquals(1, order.getItems().size());
        assertEquals(2, order.getItems().get(0).getQuantity());
        assertEquals(new Money(BigDecimal.valueOf(20.00), Currency.USD), order.getTotalAmount());
    }
    
    @Test
    void addItem_WhenOrderIsConfirmed_ShouldThrowException() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.generate());
        order.confirm(); // Change status to confirmed
        Product product = new Product(ProductId.generate(), "Test Product", 
                                   new Money(BigDecimal.valueOf(10.00), Currency.USD));
        
        // Act & Assert
        assertThrows(InvalidOperationException.class, () -> 
            order.addItem(product, 1));
    }
}
```

## Key Testing Concepts Demonstrated

- **Pure Domain Logic**: Testing business rules without external dependencies
- **JUnit 5 Framework**: Using `@Test` annotations and `assertEquals` methods
- **Arrange-Act-Assert**: Clear test structure
- **Business Rule Testing**: Validating order modification rules
- **Exception Testing**: Verifying proper exception handling with `assertThrows`
- **Fast Execution**: No database or external service calls

## Java-Specific Testing Features

- **JUnit 5**: Modern testing framework with `@Test` and `@ExtendWith`
- **MockitoExtension**: Integration with Mockito for mocking
- **BigDecimal**: Precise decimal arithmetic for monetary calculations
- **assertThrows**: Exception testing with lambda expressions
- **Static Imports**: Clean assertion syntax

## Test Categories

1. **Happy Path**: `addItem_WhenOrderIsDraft_ShouldAddItem()`
2. **Business Rule Violation**: `addItem_WhenOrderIsConfirmed_ShouldThrowException()`

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

## Java Testing Conventions

- **Method Naming**: `methodName_Scenario_ExpectedResult` pattern
- **Static Imports**: `import static org.junit.jupiter.api.Assertions.*;`
- **Lambda Expressions**: Used in `assertThrows` for exception testing
- **BigDecimal Usage**: Proper monetary calculations in tests

## Related Concepts

- [Customer Entity](./01-customer-entity.java) - Basic entity example
- [Money Value Object](./02-money-value-object.java) - Value object used in tests
- [Inventory Service](./03-inventory-service.java) - Domain service example
- [Unit Testing Best Practices](../introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)
