# Money Tests - C# Example (xUnit)

**Section**: [Domain-Driven Design and Unit Testing - Value Objects](../introduction-to-the-domain.md#value-objects-enable-comprehensive-testing)

**Navigation**: [← Previous: Order Tests](./07-order-tests.cs) | [← Back to Introduction](../introduction-to-the-domain.md) | [Next: EmailAddress Tests →](./09-email-address-tests.cs)

---

```csharp
// C# Example - Testing Value Objects
public class MoneyTests
{
    [Fact]
    public void Add_SameCurrency_ShouldReturnCorrectSum()
    {
        // Arrange
        var money1 = new Money(10.00m, Currency.USD);
        var money2 = new Money(5.00m, Currency.USD);
        
        // Act
        var result = money1.Add(money2);
        
        // Assert
        Assert.Equal(new Money(15.00m, Currency.USD), result);
    }
    
    [Fact]
    public void Add_DifferentCurrencies_ShouldThrowException()
    {
        // Arrange
        var money1 = new Money(10.00m, Currency.USD);
        var money2 = new Money(5.00m, Currency.EUR);
        
        // Act & Assert
        Assert.Throws<InvalidOperationException>(() => 
            money1.Add(money2));
    }
    
    [Fact]
    public void Multiply_PositiveFactor_ShouldReturnCorrectProduct()
    {
        // Arrange
        var money = new Money(10.00m, Currency.USD);
        
        // Act
        var result = money.Multiply(2.5m);
        
        // Assert
        Assert.Equal(new Money(25.00m, Currency.USD), result);
    }
    
    [Fact]
    public void Constructor_NegativeAmount_ShouldThrowException()
    {
        // Act & Assert
        Assert.Throws<ArgumentException>(() => 
            new Money(-10.00m, Currency.USD));
    }
    
    [Fact]
    public void Equals_SameAmountAndCurrency_ShouldReturnTrue()
    {
        // Arrange
        var money1 = new Money(10.00m, Currency.USD);
        var money2 = new Money(10.00m, Currency.USD);
        
        // Act & Assert
        Assert.True(money1.Equals(money2));
        Assert.Equal(money1.GetHashCode(), money2.GetHashCode());
    }
}

public class EmailAddressTests
{
    [Fact]
    public void Constructor_ValidEmail_ShouldCreateInstance()
    {
        // Arrange
        var emailString = "test@example.com";
        
        // Act
        var email = new EmailAddress(emailString);
        
        // Assert
        Assert.Equal("test@example.com", email.Value);
    }
    
    [Fact]
    public void Constructor_InvalidEmail_ShouldThrowException()
    {
        // Act & Assert
        Assert.Throws<ArgumentException>(() => 
            new EmailAddress("invalid-email"));
    }
    
    [Fact]
    public void Constructor_EmptyEmail_ShouldThrowException()
    {
        // Act & Assert
        Assert.Throws<ArgumentException>(() => 
            new EmailAddress(""));
    }
    
    [Fact]
    public void Constructor_EmailWithUppercase_ShouldConvertToLowercase()
    {
        // Arrange
        var emailString = "TEST@EXAMPLE.COM";
        
        // Act
        var email = new EmailAddress(emailString);
        
        // Assert
        Assert.Equal("test@example.com", email.Value);
    }
}
```

## Key Testing Concepts Demonstrated

- **Value Object Testing**: Testing immutable objects with value equality
- **Comprehensive Coverage**: Testing all public methods and edge cases
- **Validation Testing**: Verifying constructor validation rules
- **Equality Testing**: Testing value-based equality and hash codes
- **Business Rule Testing**: Testing domain-specific rules (currency mixing)
- **Edge Case Testing**: Testing boundary conditions and invalid inputs

## Test Categories for Money

1. **Operations**: `Add()`, `Multiply()` methods
2. **Validation**: Constructor parameter validation
3. **Business Rules**: Currency mixing prevention
4. **Equality**: Value-based equality and hash codes
5. **Edge Cases**: Negative amounts, invalid factors

## Test Categories for EmailAddress

1. **Validation**: Email format validation
2. **Normalization**: Case conversion testing
3. **Edge Cases**: Empty, null, invalid formats
4. **Business Rules**: Email format requirements

## Value Object Testing Benefits

- **Immutable**: No state changes to worry about
- **Self-Validating**: Constructor validation is testable
- **Deterministic**: Same inputs always produce same outputs
- **Comprehensive**: Can test all possible scenarios
- **Fast**: No external dependencies

## Testing Best Practices Shown

- **Comprehensive Coverage**: Testing all methods and edge cases
- **Clear Test Names**: Descriptive names explaining the scenario
- **Proper Assertions**: Specific assertions about expected behavior
- **Exception Testing**: Verifying proper exception handling

## Related Concepts

- [Money Value Object](./03-money-value-object.md) - The value object being tested
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
