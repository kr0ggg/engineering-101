# Testing Anti-Patterns - C# Example (xUnit)

**Section**: [Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid)

**Navigation**: [← Previous: Customer Service Tests](./10-customer-service-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [Next: Testing Best Practices →](./12-testing-best-practices.md)

---

// C# Example - Testing Anti-Patterns to Avoid (xUnit)
// File: 2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns.cs

```csharp
using Xunit;
using Moq;
using System;
using System.Reflection; // For accessing private fields (demonstrating bad practice)
using System.Collections.Generic;
using System.Threading.Tasks;
using EcommerceApp.Domain.Customer;
using EcommerceApp.Domain.Order;
using EcommerceApp.Domain.Shared;
using EcommerceApp.Domain.Services;

// Mock interfaces and classes for demonstration purposes
public interface IDatabase
{
    void Save(object entity);
}

public interface ILogger
{
    void LogInformation(string message);
}

public class InventoryCheckResult { public bool IsAvailable { get; set; } }
public interface IInventoryService
{
    Task<InventoryCheckResult> CheckAvailability(ProductId productId);
}

public interface IShippingService
{
    Task<Money> CalculateShipping(Order order);
}

public class ProcessOrderService // A service that orchestrates multiple domain services
{
    private readonly IInventoryService _inventoryService;
    private readonly PricingService _pricingService; // Assuming PricingService is a domain service
    private readonly IShippingService _shippingService;
    private readonly ICustomerRepository _customerRepository; // Assuming repository for customer
    private readonly IOrderRepository _orderRepository; // Assuming repository for order

    public ProcessOrderService(
        IInventoryService inventoryService,
        PricingService pricingService,
        IShippingService shippingService,
        ICustomerRepository customerRepository,
        IOrderRepository orderRepository)
    {
        _inventoryService = inventoryService;
        _pricingService = pricingService;
        _shippingService = shippingService;
        _customerRepository = customerRepository;
        _orderRepository = orderRepository;
    }

    public async Task<Order> ProcessOrder(OrderId orderId, CustomerId customerId)
    {
        var order = await _orderRepository.FindById(orderId);
        if (order == null) throw new InvalidOperationException("Order not found.");

        var customer = await _customerRepository.FindById(customerId);
        if (customer == null) throw new InvalidOperationException("Customer not found.");

        // Example of complex orchestration
        foreach (var item in order.Items)
        {
            var availability = await _inventoryService.CheckAvailability(item.ProductId);
            if (!availability.IsAvailable)
            {
                throw new InvalidOperationException($"Product {item.ProductId} is not available.");
            }
        }

        // Recalculate total with pricing service
        var finalTotal = _pricingService.CalculateOrderTotal(order, customer);
        // Assume order.TotalAmount can be set or updated via a method
        // order.UpdateTotal(finalTotal);

        // Calculate shipping
        var shippingCost = await _shippingService.CalculateShipping(order);
        // Assume shipping cost is added to order or handled separately

        order.Confirm(); // Business logic within the entity

        await _orderRepository.Save(order);

        return order;
    }
}

public interface IOrderRepository
{
    Task<Order> FindById(OrderId id);
    Task Save(Order order);
}


public class TestingAntiPatterns
{
    // Bad - Testing infrastructure concerns
    // This test verifies that a specific method on a mock repository is called.
    // It doesn't test any business logic or behavior of the domain.
    // It couples the test to the implementation detail of how persistence is handled.
    [Fact]
    public void SaveCustomer_ShouldCallDatabase()
    {
        // Arrange
        var mockRepository = new Mock<ICustomerRepository>();
        var customer = new Customer(CustomerId.Generate(), "Test", new EmailAddress("test@test.com"), new Address("s", "c", "st", "z"));

        // Act
        mockRepository.Object.Save(customer);

        // Assert
        // This tests database interaction, not business logic
        mockRepository.Verify(r => r.Save(customer), Times.Once);
        // Asserting that a method was called is often a sign of testing implementation details.
    }

    // Bad - Testing implementation details
    // This test attempts to access a private field of the Order class.
    // It makes the test brittle, as any refactoring of internal state (e.g., changing _items to a different collection type)
    // would break the test, even if the external behavior of the Order remains the same.
    [Fact]
    public void Order_ShouldHavePrivateFieldForItems()
    {
        // Arrange
        var order = new Order(OrderId.Generate(), CustomerId.Generate());

        // Act
        // Using reflection to access a private field - a strong anti-pattern for unit testing
        var field = typeof(Order).GetField("_items", BindingFlags.NonPublic | BindingFlags.Instance);

        // Assert
        Assert.NotNull(field);
        var itemsList = field.GetValue(order) as List<OrderItem>;
        Assert.NotNull(itemsList);
        Assert.Empty(itemsList); // Asserting on the internal state
    }

    // Bad - Over-mocking makes tests brittle and hard to understand
    // This test for ProcessOrderService mocks almost every dependency.
    // While mocking dependencies is good, mocking too many or mocking collaborators
    // that are themselves complex domain services can make the test:
    // 1. Hard to read: The arrange section becomes very long and complex.
    // 2. Brittle: Changes in how ProcessOrderService interacts with its dependencies
    //    (e.g., a new method call, different order of calls) will break the test.
    // 3. Less valuable: It tests the "wiring" more than the actual business logic
    //    of the ProcessOrderService itself.
    [Fact]
    public async Task ProcessOrder_OverMockedExample_ShouldWork()
    {
        // Arrange
        var mockInventoryService = new Mock<IInventoryService>();
        var mockPricingService = new Mock<PricingService>(); // Mocking a concrete class, often a sign of issues
        var mockShippingService = new Mock<IShippingService>();
        var mockCustomerRepository = new Mock<ICustomerRepository>();
        var mockOrderRepository = new Mock<IOrderRepository>();

        var orderId = OrderId.Generate();
        var customerId = CustomerId.Generate();
        var product = new Product(ProductId.Generate(), "Test Product", new Money(10.00m, Currency.USD));
        var order = new Order(orderId, customerId);
        order.AddItem(product, 1); // Add an item so it's not empty

        var customer = new Customer(customerId, "Test Customer", new EmailAddress("test@example.com"), new Address("s", "c", "st", "z"));

        mockOrderRepository.Setup(r => r.FindById(orderId)).ReturnsAsync(order);
        mockCustomerRepository.Setup(r => r.FindById(customerId)).ReturnsAsync(customer);
        mockInventoryService.Setup(x => x.CheckAvailability(It.IsAny<ProductId>()))
                            .ReturnsAsync(new InventoryCheckResult { IsAvailable = true });
        // Note: PricingService is a domain service, ideally it should be tested directly, not mocked here
        // If it's a dependency, it should be an interface. Mocking concrete classes can be problematic.
        // For this example, we'll assume it's mocked for demonstration of over-mocking.
        mockPricingService.Setup(x => x.CalculateOrderTotal(It.IsAny<Order>(), It.IsAny<Customer>()))
                        .Returns(new Money(100, Currency.USD));
        mockShippingService.Setup(x => x.CalculateShipping(It.IsAny<Order>()))
                        .ReturnsAsync(new Money(10, Currency.USD));

        var service = new ProcessOrderService(
            mockInventoryService.Object,
            mockPricingService.Object, // Passing mock object
            mockShippingService.Object,
            mockCustomerRepository.Object,
            mockOrderRepository.Object);

        // Act
        var result = await service.ProcessOrder(orderId, customerId);

        // Assert
        Assert.NotNull(result);
        Assert.Equal(OrderStatus.Confirmed, result.Status);
        mockOrderRepository.Verify(r => r.Save(order), Times.Once);
        // ... many more verifications, making the test long and hard to read
    }
}
```
/*
 * Navigation:
 * Previous: 10-customer-service-tests.cs
 * Next: 12-testing-best-practices.cs
 *
 * Back to: [Domain-Driven Design and Unit Testing - Testing Anti-Patterns to Avoid](../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid)
 */
