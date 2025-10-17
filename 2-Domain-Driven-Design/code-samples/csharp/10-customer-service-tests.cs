# Customer Service Tests - C# Example (xUnit + Moq)

**Section**: [Domain-Driven Design and Unit Testing - Isolated Testing](../introduction-to-the-domain.md#isolated-testing-with-dependency-injection)

**Navigation**: [← Previous: Pricing Service Tests](./09-pricing-service-tests.cs) | [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Testing Anti-Patterns →](./11-testing-anti-patterns.cs)

---

```csharp
// C# Example - Testing with Mocked Dependencies
public class CustomerServiceTests
{
    private readonly Mock<ICustomerRepository> _mockCustomerRepository;
    private readonly Mock<IEmailService> _mockEmailService;
    private readonly CustomerService _customerService;
    
    public CustomerServiceTests()
    {
        _mockCustomerRepository = new Mock<ICustomerRepository>();
        _mockEmailService = new Mock<IEmailService>();
        _customerService = new CustomerService(_mockCustomerRepository.Object, _mockEmailService.Object);
    }
    
    [Fact]
    public async Task RegisterCustomer_WithValidData_ShouldCreateCustomer()
    {
        // Arrange
        var name = "Test Customer";
        var email = new EmailAddress("test@example.com");
        var address = new Address("123 Main St", "City", "State", "12345");
        
        _mockCustomerRepository.Setup(r => r.FindByEmail(email))
                              .ReturnsAsync((Customer)null);
        
        // Act
        var result = await _customerService.RegisterCustomer(name, email, address);
        
        // Assert
        Assert.NotNull(result);
        Assert.Equal(name, result.Name);
        Assert.Equal(email, result.Email);
        
        _mockCustomerRepository.Verify(r => r.Save(It.IsAny<Customer>()), Times.Once);
        _mockEmailService.Verify(e => e.SendWelcomeEmail(email, name), Times.Once);
    }
    
    [Fact]
    public async Task RegisterCustomer_WithExistingEmail_ShouldThrowException()
    {
        // Arrange
        var name = "Test Customer";
        var email = new EmailAddress("test@example.com");
        var address = new Address("123 Main St", "City", "State", "12345");
        var existingCustomer = new Customer(CustomerId.Generate(), "Existing Customer", email, address);
        
        _mockCustomerRepository.Setup(r => r.FindByEmail(email))
                              .ReturnsAsync(existingCustomer);
        
        // Act & Assert
        await Assert.ThrowsAsync<CustomerAlreadyExistsException>(() => 
            _customerService.RegisterCustomer(name, email, address));
        
        _mockCustomerRepository.Verify(r => r.Save(It.IsAny<Customer>()), Times.Never);
        _mockEmailService.Verify(e => e.SendWelcomeEmail(It.IsAny<EmailAddress>(), It.IsAny<string>()), Times.Never);
    }
}
```

## Key Testing Concepts Demonstrated

- **Dependency Injection Testing**: Testing with mocked dependencies
- **Moq Framework**: Using Moq for creating mock objects
- **Async Testing**: Testing async methods with `async Task`
- **Mock Setup**: Configuring mock behavior with `Setup()`
- **Mock Verification**: Verifying mock interactions with `Verify()`
- **Isolated Testing**: Testing service logic without external dependencies

## Mock Usage Patterns

1. **Setup**: `_mockCustomerRepository.Setup(r => r.FindByEmail(email)).ReturnsAsync((Customer)null)`
2. **Verification**: `_mockCustomerRepository.Verify(r => r.Save(It.IsAny<Customer>()), Times.Once)`
3. **Exception Testing**: `await Assert.ThrowsAsync<CustomerAlreadyExistsException>()`

## Test Scenarios

1. **Happy Path**: Successful customer registration
2. **Business Rule Violation**: Duplicate email handling
3. **Integration Verification**: Repository and email service interactions

## Benefits of Mocked Testing

- **Isolation**: Tests focus on service logic, not dependencies
- **Speed**: No database or external service calls
- **Reliability**: Deterministic behavior without external factors
- **Control**: Complete control over dependency behavior
- **Focused**: Tests verify specific business logic

## Testing Best Practices Shown

- **Constructor Setup**: Mocks created in constructor for reuse
- **Readonly Fields**: Immutable mock references
- **Specific Verifications**: Verifying exact method calls and parameters
- **Exception Testing**: Proper async exception testing
- **Clean Assertions**: Clear verification of expected behavior

## Mock Verification Patterns

- **Times.Once**: Verifies method called exactly once
- **Times.Never**: Verifies method was never called
- **It.IsAny<T>()**: Matches any parameter of type T
- **Specific Parameters**: Verifying exact parameter values

## Related Concepts

- [Customer Module](./06-customer-module.cs) - The module being tested
- [Customer Entity](./01-customer-entity.cs) - Entity used in service
- [EmailAddress Value Object](./04-email-address-value-object.cs) - Value object used
- [Dependency Injection](../introduction-to-the-domain.md#isolated-testing-with-dependency-injection) - DI concepts
- [Unit Testing Best Practices](../introduction-to-the-domain.md#best-practices-for-ddd-unit-testing)
