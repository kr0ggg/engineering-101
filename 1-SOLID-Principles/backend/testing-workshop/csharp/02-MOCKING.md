# C# Mocking with Moq

## Overview

Moq is the most popular mocking library for .NET. This guide covers everything you need to know about using Moq to create test doubles for your C# tests.

## Installation

```bash
dotnet add package Moq
```

## Basic Moq Concepts

### Creating a Mock

```csharp
// Create mock of interface
var mockRepository = new Mock<ICustomerRepository>();

// Use the mock
var service = new CustomerService(mockRepository.Object);
```

### Setup Return Values

```csharp
// Setup method to return specific value
mockRepository
    .Setup(r => r.FindById(1))
    .Returns(new Customer { Id = 1, Name = "John" });

// Setup async method
mockRepository
    .Setup(r => r.FindByIdAsync(1))
    .ReturnsAsync(new Customer { Id = 1, Name = "John" });
```

### Verify Method Calls

```csharp
// Verify method was called
mockRepository.Verify(r => r.Save(It.IsAny<Customer>()), Times.Once);

// Verify method was never called
mockRepository.Verify(r => r.Delete(It.IsAny<int>()), Times.Never);
```

## Setup Patterns

### Basic Setup

```csharp
[Fact]
public void GetCustomer_ShouldReturnCustomer_WhenExists()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    mockRepository
        .Setup(r => r.FindById(1))
        .Returns(new Customer { Id = 1, Name = "John Doe" });
    
    var service = new CustomerService(mockRepository.Object);
    
    // Act
    var result = service.GetCustomer(1);
    
    // Assert
    result.Should().NotBeNull();
    result.Name.Should().Be("John Doe");
}
```

### Setup with Any Parameter

```csharp
[Fact]
public void SaveCustomer_ShouldCallRepository()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    mockRepository
        .Setup(r => r.Save(It.IsAny<Customer>()))
        .Verifiable();
    
    var service = new CustomerService(mockRepository.Object);
    var customer = new Customer { Id = 1, Name = "John" };
    
    // Act
    service.SaveCustomer(customer);
    
    // Assert
    mockRepository.Verify();
}
```

### Setup with Specific Parameter Matching

```csharp
[Fact]
public void UpdateCustomer_ShouldUpdateSpecificCustomer()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    mockRepository
        .Setup(r => r.Update(It.Is<Customer>(c => c.Id == 1)))
        .Verifiable();
    
    var service = new CustomerService(mockRepository.Object);
    var customer = new Customer { Id = 1, Name = "Updated Name" };
    
    // Act
    service.UpdateCustomer(customer);
    
    // Assert
    mockRepository.Verify(
        r => r.Update(It.Is<Customer>(c => c.Id == 1 && c.Name == "Updated Name")),
        Times.Once
    );
}
```

### Setup with Callback

```csharp
[Fact]
public void SaveCustomer_ShouldAssignId()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    var savedCustomer = (Customer?)null;
    
    mockRepository
        .Setup(r => r.Save(It.IsAny<Customer>()))
        .Callback<Customer>(c => savedCustomer = c);
    
    var service = new CustomerService(mockRepository.Object);
    var customer = new Customer { Name = "John" };
    
    // Act
    service.SaveCustomer(customer);
    
    // Assert
    savedCustomer.Should().NotBeNull();
    savedCustomer!.Name.Should().Be("John");
}
```

### Setup Sequential Returns

```csharp
[Fact]
public void GetCustomer_ShouldRetryOnFailure()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    mockRepository
        .SetupSequence(r => r.FindById(1))
        .Returns((Customer?)null)  // First call returns null
        .Returns((Customer?)null)  // Second call returns null
        .Returns(new Customer { Id = 1, Name = "John" });  // Third call succeeds
    
    var service = new CustomerService(mockRepository.Object);
    
    // Act
    var result = service.GetCustomerWithRetry(1);
    
    // Assert
    result.Should().NotBeNull();
    mockRepository.Verify(r => r.FindById(1), Times.Exactly(3));
}
```

## Argument Matching

### It.IsAny<T>

```csharp
// Matches any value of type T
mockRepository
    .Setup(r => r.Save(It.IsAny<Customer>()))
    .Verifiable();
```

### It.Is<T>

```csharp
// Matches values that satisfy a predicate
mockRepository
    .Setup(r => r.FindByEmail(It.Is<string>(email => email.Contains("@"))))
    .Returns(new Customer { Email = "john@example.com" });
```

### It.IsIn<T>

```csharp
// Matches values in a collection
mockRepository
    .Setup(r => r.FindById(It.IsIn(1, 2, 3)))
    .Returns(new Customer { Id = 1 });
```

### It.IsNotNull<T>

```csharp
// Matches non-null values
mockRepository
    .Setup(r => r.Save(It.IsNotNull<Customer>()))
    .Verifiable();
```

### It.IsRegex

```csharp
// Matches strings matching a regex
mockRepository
    .Setup(r => r.FindByEmail(It.IsRegex(@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")))
    .Returns(new Customer { Email = "john@example.com" });
```

## Async Methods

### Setup Async Return

```csharp
[Fact]
public async Task GetCustomerAsync_ShouldReturnCustomer()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    mockRepository
        .Setup(r => r.FindByIdAsync(1))
        .ReturnsAsync(new Customer { Id = 1, Name = "John" });
    
    var service = new CustomerService(mockRepository.Object);
    
    // Act
    var result = await service.GetCustomerAsync(1);
    
    // Assert
    result.Should().NotBeNull();
}
```

### Setup Async Exception

```csharp
[Fact]
public async Task GetCustomerAsync_ShouldThrowException()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    mockRepository
        .Setup(r => r.FindByIdAsync(It.IsAny<int>()))
        .ThrowsAsync(new NotFoundException("Customer not found"));
    
    var service = new CustomerService(mockRepository.Object);
    
    // Act & Assert
    await Assert.ThrowsAsync<NotFoundException>(() => 
        service.GetCustomerAsync(999)
    );
}
```

## Exception Handling

### Setup to Throw Exception

```csharp
[Fact]
public void SaveCustomer_ShouldHandleDatabaseException()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    mockRepository
        .Setup(r => r.Save(It.IsAny<Customer>()))
        .Throws<DatabaseException>();
    
    var service = new CustomerService(mockRepository.Object);
    var customer = new Customer { Name = "John" };
    
    // Act & Assert
    Assert.Throws<DatabaseException>(() => service.SaveCustomer(customer));
}
```

### Setup to Throw Specific Exception

```csharp
[Fact]
public void SaveCustomer_ShouldThrowValidationException()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    mockRepository
        .Setup(r => r.Save(It.IsAny<Customer>()))
        .Throws(new ValidationException("Email is required"));
    
    var service = new CustomerService(mockRepository.Object);
    var customer = new Customer { Name = "John" };
    
    // Act & Assert
    var exception = Assert.Throws<ValidationException>(() => 
        service.SaveCustomer(customer)
    );
    exception.Message.Should().Contain("Email is required");
}
```

## Property Mocking

### Setup Property Get

```csharp
[Fact]
public void GetConnectionString_ShouldReturnConfiguredValue()
{
    // Arrange
    var mockConfig = new Mock<IConfiguration>();
    mockConfig
        .Setup(c => c.ConnectionString)
        .Returns("Server=localhost;Database=test");
    
    var service = new DatabaseService(mockConfig.Object);
    
    // Act
    var result = service.GetConnectionString();
    
    // Assert
    result.Should().Be("Server=localhost;Database=test");
}
```

### Setup Property with SetupProperty

```csharp
[Fact]
public void SetCustomerName_ShouldUpdateProperty()
{
    // Arrange
    var mockCustomer = new Mock<ICustomer>();
    mockCustomer.SetupProperty(c => c.Name);
    
    // Act
    mockCustomer.Object.Name = "John Doe";
    
    // Assert
    mockCustomer.Object.Name.Should().Be("John Doe");
}
```

### Setup All Properties

```csharp
[Fact]
public void Customer_ShouldTrackAllProperties()
{
    // Arrange
    var mockCustomer = new Mock<ICustomer>();
    mockCustomer.SetupAllProperties();
    
    // Act
    mockCustomer.Object.Name = "John";
    mockCustomer.Object.Email = "john@example.com";
    
    // Assert
    mockCustomer.Object.Name.Should().Be("John");
    mockCustomer.Object.Email.Should().Be("john@example.com");
}
```

## Verification

### Verify Method Called

```csharp
[Fact]
public void ProcessOrder_ShouldSendEmail()
{
    // Arrange
    var mockEmailService = new Mock<IEmailService>();
    var service = new OrderService(mockEmailService.Object);
    var order = new Order { Id = 1 };
    
    // Act
    service.ProcessOrder(order);
    
    // Assert
    mockEmailService.Verify(
        e => e.SendOrderConfirmation(It.Is<Order>(o => o.Id == 1)),
        Times.Once
    );
}
```

### Verify with Times

```csharp
// Verify called exactly once
mock.Verify(m => m.Method(), Times.Once);

// Verify called exactly N times
mock.Verify(m => m.Method(), Times.Exactly(3));

// Verify never called
mock.Verify(m => m.Method(), Times.Never);

// Verify called at least once
mock.Verify(m => m.Method(), Times.AtLeastOnce);

// Verify called at most N times
mock.Verify(m => m.Method(), Times.AtMost(5));

// Verify called between N and M times
mock.Verify(m => m.Method(), Times.Between(2, 5, Range.Inclusive));
```

### Verify All Setups

```csharp
[Fact]
public void Service_ShouldCallAllDependencies()
{
    // Arrange
    var mockRepo = new Mock<IRepository>();
    mockRepo.Setup(r => r.Save(It.IsAny<Customer>())).Verifiable();
    
    var mockEmail = new Mock<IEmailService>();
    mockEmail.Setup(e => e.Send(It.IsAny<string>())).Verifiable();
    
    var service = new CustomerService(mockRepo.Object, mockEmail.Object);
    
    // Act
    service.CreateCustomer(new Customer { Name = "John" });
    
    // Assert - Verifies all setups marked as Verifiable
    mockRepo.Verify();
    mockEmail.Verify();
}
```

## Advanced Patterns

### Loose vs Strict Mocks

```csharp
// Loose mock (default) - doesn't throw on unexpected calls
var looseMock = new Mock<IRepository>();

// Strict mock - throws on any call not explicitly setup
var strictMock = new Mock<IRepository>(MockBehavior.Strict);
strictMock.Setup(r => r.FindById(1)).Returns(new Customer());

// This would throw with strict mock
// strictMock.Object.FindById(2);
```

### Mock with Constructor Arguments

```csharp
public interface IService
{
    string GetData();
}

public class ServiceWithDependency : IService
{
    private readonly string _connectionString;
    
    public ServiceWithDependency(string connectionString)
    {
        _connectionString = connectionString;
    }
    
    public string GetData() => _connectionString;
}

[Fact]
public void Mock_WithConstructorArgs()
{
    // Create mock with constructor arguments
    var mock = new Mock<ServiceWithDependency>("test-connection");
    mock.CallBase = true;  // Call real implementation
    
    var result = mock.Object.GetData();
    result.Should().Be("test-connection");
}
```

### Protected Method Mocking

```csharp
public abstract class BaseService
{
    protected abstract string GetConnectionString();
    
    public string Connect()
    {
        return GetConnectionString();
    }
}

[Fact]
public void Mock_ProtectedMethod()
{
    // Arrange
    var mock = new Mock<BaseService>();
    mock.Protected()
        .Setup<string>("GetConnectionString")
        .Returns("test-connection");
    
    // Act
    var result = mock.Object.Connect();
    
    // Assert
    result.Should().Be("test-connection");
}
```

### Event Mocking

```csharp
public interface INotificationService
{
    event EventHandler<NotificationEventArgs> NotificationSent;
    void SendNotification(string message);
}

[Fact]
public void Service_ShouldRaiseEvent()
{
    // Arrange
    var mockNotification = new Mock<INotificationService>();
    var eventRaised = false;
    
    mockNotification.Object.NotificationSent += (sender, args) =>
    {
        eventRaised = true;
    };
    
    // Act
    mockNotification.Raise(
        n => n.NotificationSent += null,
        new NotificationEventArgs("Test")
    );
    
    // Assert
    eventRaised.Should().BeTrue();
}
```

## Testing with Multiple Mocks

```csharp
[Fact]
public void ProcessOrder_ShouldCoordinateMultipleServices()
{
    // Arrange
    var mockProductRepo = new Mock<IProductRepository>();
    var mockInventory = new Mock<IInventoryService>();
    var mockPayment = new Mock<IPaymentService>();
    var mockEmail = new Mock<IEmailService>();
    
    mockProductRepo
        .Setup(r => r.FindById(1))
        .Returns(new Product { Id = 1, Price = 10.00m });
    
    mockInventory
        .Setup(i => i.CheckAvailability(1, 2))
        .Returns(true);
    
    mockPayment
        .Setup(p => p.ProcessPayment(It.IsAny<decimal>()))
        .Returns(new PaymentResult { Success = true });
    
    var service = new OrderService(
        mockProductRepo.Object,
        mockInventory.Object,
        mockPayment.Object,
        mockEmail.Object
    );
    
    var order = new Order
    {
        Items = new List<OrderItem>
        {
            new OrderItem { ProductId = 1, Quantity = 2 }
        }
    };
    
    // Act
    var result = service.ProcessOrder(order);
    
    // Assert
    result.Success.Should().BeTrue();
    mockInventory.Verify(i => i.CheckAvailability(1, 2), Times.Once);
    mockPayment.Verify(p => p.ProcessPayment(20.00m), Times.Once);
    mockEmail.Verify(e => e.SendOrderConfirmation(It.IsAny<Order>()), Times.Once);
}
```

## Common Patterns

### Repository Pattern

```csharp
[Fact]
public async Task GetCustomer_ShouldUseRepository()
{
    // Arrange
    var mockRepository = new Mock<ICustomerRepository>();
    mockRepository
        .Setup(r => r.FindByIdAsync(1))
        .ReturnsAsync(new Customer { Id = 1, Name = "John" });
    
    var service = new CustomerService(mockRepository.Object);
    
    // Act
    var result = await service.GetCustomerAsync(1);
    
    // Assert
    result.Should().NotBeNull();
    mockRepository.Verify(r => r.FindByIdAsync(1), Times.Once);
}
```

### Unit of Work Pattern

```csharp
[Fact]
public async Task SaveChanges_ShouldCommitTransaction()
{
    // Arrange
    var mockUnitOfWork = new Mock<IUnitOfWork>();
    var mockRepository = new Mock<ICustomerRepository>();
    
    mockUnitOfWork
        .Setup(u => u.Customers)
        .Returns(mockRepository.Object);
    
    var service = new CustomerService(mockUnitOfWork.Object);
    var customer = new Customer { Name = "John" };
    
    // Act
    await service.CreateCustomerAsync(customer);
    
    // Assert
    mockRepository.Verify(r => r.AddAsync(customer), Times.Once);
    mockUnitOfWork.Verify(u => u.CommitAsync(), Times.Once);
}
```

## Best Practices

### ✅ Do's

```csharp
// Use It.IsAny for flexible matching
mock.Setup(m => m.Method(It.IsAny<int>())).Returns(value);

// Verify important interactions
mock.Verify(m => m.CriticalMethod(), Times.Once);

// Use descriptive variable names
var mockCustomerRepository = new Mock<ICustomerRepository>();

// Setup only what you need
mock.Setup(m => m.GetData()).Returns(data);
```

### ❌ Don'ts

```csharp
// Don't mock what you don't own
var mockHttpClient = new Mock<HttpClient>(); // Bad

// Don't over-verify
mock.Verify(m => m.LogDebug(It.IsAny<string>()), Times.Exactly(5)); // Too brittle

// Don't mock value objects
var mockMoney = new Mock<Money>(); // Bad - use real Money

// Don't use strict mocks unless necessary
var mock = new Mock<IService>(MockBehavior.Strict); // Usually too rigid
```

## Troubleshooting

### Setup Not Working

```csharp
// Problem: Setup doesn't match call
mock.Setup(m => m.Method(1)).Returns(value);
var result = mock.Object.Method(2); // Different parameter!

// Solution: Use It.IsAny or correct parameter
mock.Setup(m => m.Method(It.IsAny<int>())).Returns(value);
```

### Verify Failing

```csharp
// Problem: Verification too strict
mock.Verify(m => m.Method(It.Is<Customer>(c => c.Id == 1 && c.Name == "John")));

// Solution: Verify only what matters
mock.Verify(m => m.Method(It.Is<Customer>(c => c.Id == 1)), Times.Once);
```

## Summary

**Key Moq Concepts**:
- Setup return values with `.Setup().Returns()`
- Setup async with `.ReturnsAsync()`
- Match parameters with `It.IsAny<T>()`, `It.Is<T>()`
- Verify calls with `.Verify()`
- Use callbacks for complex scenarios
- Mock interfaces, not concrete classes

## Next Steps

1. Review [Testing Patterns](./01-TESTING-PATTERNS.md)
2. Learn [Integration Testing](./03-INTEGRATION-TESTING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Moq makes it easy to create test doubles. Use it to isolate your code under test and verify important interactions.
