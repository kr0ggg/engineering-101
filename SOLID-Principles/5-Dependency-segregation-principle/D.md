# Dependency Inversion Principle (DIP)

## Name
**Dependency Inversion Principle** - The "D" in SOLID

## Goal of the Principle
High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend on details. Details should depend on abstractions. This principle inverts the traditional dependency hierarchy, making systems more flexible and maintainable.

## Role in Improving Software Quality

The Dependency Inversion Principle is the capstone of the SOLID principles, creating loosely coupled and highly cohesive systems. It ensures that:

- **Loose Coupling**: High-level modules are independent of low-level implementation details
- **Flexibility**: Dependencies can be easily swapped or modified
- **Testability**: Dependencies can be easily mocked for testing
- **Maintainability**: Changes to low-level modules don't affect high-level modules
- **Extensibility**: New implementations can be added without modifying existing code

## How to Apply This Principle

1. **Define Abstractions**: Create interfaces or abstract classes for dependencies
2. **Inject Dependencies**: Use dependency injection to provide concrete implementations
3. **Depend on Abstractions**: High-level modules should only depend on abstractions
4. **Implement Abstractions**: Low-level modules should implement the abstractions
5. **Use Dependency Injection Containers**: Leverage IoC containers for automatic dependency resolution

## Examples of Violations and Refactoring

### C# Example

**Violating DIP:**
```csharp
// High-level module depending on low-level module
public class OrderService
{
    private SqlServerDatabase database;
    private SmtpEmailService emailService;
    private FileLogger logger;
    
    public OrderService()
    {
        // Direct dependency on concrete implementations
        database = new SqlServerDatabase();
        emailService = new SmtpEmailService();
        logger = new FileLogger();
    }
    
    public void ProcessOrder(Order order)
    {
        try
        {
            database.SaveOrder(order);
            emailService.SendConfirmationEmail(order.CustomerEmail);
            logger.Log($"Order {order.Id} processed successfully");
        }
        catch (Exception ex)
        {
            logger.Log($"Error processing order {order.Id}: {ex.Message}");
            throw;
        }
    }
}

// Low-level modules
public class SqlServerDatabase
{
    public void SaveOrder(Order order)
    {
        Console.WriteLine($"Saving order {order.Id} to SQL Server");
    }
}

public class SmtpEmailService
{
    public void SendConfirmationEmail(string email)
    {
        Console.WriteLine($"Sending confirmation email to {email} via SMTP");
    }
}

public class FileLogger
{
    public void Log(string message)
    {
        Console.WriteLine($"Logging to file: {message}");
    }
}
```

**Refactored - Applying DIP:**
```csharp
// Abstractions that high-level modules depend on
public interface IOrderRepository
{
    void SaveOrder(Order order);
}

public interface IEmailService
{
    void SendConfirmationEmail(string email);
}

public interface ILogger
{
    void Log(string message);
}

// High-level module depending on abstractions
public class OrderService
{
    private readonly IOrderRepository orderRepository;
    private readonly IEmailService emailService;
    private readonly ILogger logger;
    
    // Dependency injection through constructor
    public OrderService(IOrderRepository orderRepository, IEmailService emailService, ILogger logger)
    {
        this.orderRepository = orderRepository;
        this.emailService = emailService;
        this.logger = logger;
    }
    
    public void ProcessOrder(Order order)
    {
        try
        {
            orderRepository.SaveOrder(order);
            emailService.SendConfirmationEmail(order.CustomerEmail);
            logger.Log($"Order {order.Id} processed successfully");
        }
        catch (Exception ex)
        {
            logger.Log($"Error processing order {order.Id}: {ex.Message}");
            throw;
        }
    }
}

// Low-level modules implementing abstractions
public class SqlServerDatabase : IOrderRepository
{
    public void SaveOrder(Order order)
    {
        Console.WriteLine($"Saving order {order.Id} to SQL Server");
    }
}

public class OracleDatabase : IOrderRepository
{
    public void SaveOrder(Order order)
    {
        Console.WriteLine($"Saving order {order.Id} to Oracle");
    }
}

public class SmtpEmailService : IEmailService
{
    public void SendConfirmationEmail(string email)
    {
        Console.WriteLine($"Sending confirmation email to {email} via SMTP");
    }
}

public class SendGridEmailService : IEmailService
{
    public void SendConfirmationEmail(string email)
    {
        Console.WriteLine($"Sending confirmation email to {email} via SendGrid");
    }
}

public class FileLogger : ILogger
{
    public void Log(string message)
    {
        Console.WriteLine($"Logging to file: {message}");
    }
}

public class DatabaseLogger : ILogger
{
    public void Log(string message)
    {
        Console.WriteLine($"Logging to database: {message}");
    }
}
```

### Java Example

**Violating DIP:**
```java
// High-level module depending on low-level module
public class UserService {
    private MySQLUserRepository userRepository;
    private EmailNotificationService emailService;
    
    public UserService() {
        // Direct dependency on concrete implementations
        userRepository = new MySQLUserRepository();
        emailService = new EmailNotificationService();
    }
    
    public void createUser(User user) {
        userRepository.save(user);
        emailService.sendWelcomeEmail(user.getEmail());
    }
}

// Low-level modules
public class MySQLUserRepository {
    public void save(User user) {
        System.out.println("Saving user to MySQL: " + user.getName());
    }
}

public class EmailNotificationService {
    public void sendWelcomeEmail(String email) {
        System.out.println("Sending welcome email to: " + email);
    }
}
```

**Refactored - Applying DIP:**
```java
// Abstractions that high-level modules depend on
public interface UserRepository {
    void save(User user);
}

public interface NotificationService {
    void sendWelcomeEmail(String email);
}

// High-level module depending on abstractions
public class UserService {
    private final UserRepository userRepository;
    private final NotificationService notificationService;
    
    // Dependency injection through constructor
    public UserService(UserRepository userRepository, NotificationService notificationService) {
        this.userRepository = userRepository;
        this.notificationService = notificationService;
    }
    
    public void createUser(User user) {
        userRepository.save(user);
        notificationService.sendWelcomeEmail(user.getEmail());
    }
}

// Low-level modules implementing abstractions
public class MySQLUserRepository implements UserRepository {
    @Override
    public void save(User user) {
        System.out.println("Saving user to MySQL: " + user.getName());
    }
}

public class PostgreSQLUserRepository implements UserRepository {
    @Override
    public void save(User user) {
        System.out.println("Saving user to PostgreSQL: " + user.getName());
    }
}

public class EmailNotificationService implements NotificationService {
    @Override
    public void sendWelcomeEmail(String email) {
        System.out.println("Sending welcome email to: " + email);
    }
}

public class SMSPushNotificationService implements NotificationService {
    @Override
    public void sendWelcomeEmail(String email) {
        System.out.println("Sending SMS welcome to: " + email);
    }
}
```

### TypeScript Example

**Violating DIP:**
```typescript
// High-level module depending on low-level module
class PaymentProcessor {
    private stripePaymentGateway: StripePaymentGateway;
    private consoleLogger: ConsoleLogger;
    
    constructor() {
        // Direct dependency on concrete implementations
        this.stripePaymentGateway = new StripePaymentGateway();
        this.consoleLogger = new ConsoleLogger();
    }
    
    processPayment(amount: number, customerId: string): boolean {
        try {
            const result = this.stripePaymentGateway.charge(amount, customerId);
            this.consoleLogger.log(`Payment processed: ${amount} for customer ${customerId}`);
            return result;
        } catch (error) {
            this.consoleLogger.log(`Payment failed: ${error}`);
            return false;
        }
    }
}

// Low-level modules
class StripePaymentGateway {
    charge(amount: number, customerId: string): boolean {
        console.log(`Charging ${amount} to customer ${customerId} via Stripe`);
        return true;
    }
}

class ConsoleLogger {
    log(message: string): void {
        console.log(`[LOG] ${message}`);
    }
}
```

**Refactored - Applying DIP:**
```typescript
// Abstractions that high-level modules depend on
interface PaymentGateway {
    charge(amount: number, customerId: string): boolean;
}

interface Logger {
    log(message: string): void;
}

// High-level module depending on abstractions
class PaymentProcessor {
    private paymentGateway: PaymentGateway;
    private logger: Logger;
    
    // Dependency injection through constructor
    constructor(paymentGateway: PaymentGateway, logger: Logger) {
        this.paymentGateway = paymentGateway;
        this.logger = logger;
    }
    
    processPayment(amount: number, customerId: string): boolean {
        try {
            const result = this.paymentGateway.charge(amount, customerId);
            this.logger.log(`Payment processed: ${amount} for customer ${customerId}`);
            return result;
        } catch (error) {
            this.logger.log(`Payment failed: ${error}`);
            return false;
        }
    }
}

// Low-level modules implementing abstractions
class StripePaymentGateway implements PaymentGateway {
    charge(amount: number, customerId: string): boolean {
        console.log(`Charging ${amount} to customer ${customerId} via Stripe`);
        return true;
    }
}

class PayPalPaymentGateway implements PaymentGateway {
    charge(amount: number, customerId: string): boolean {
        console.log(`Charging ${amount} to customer ${customerId} via PayPal`);
        return true;
    }
}

class ConsoleLogger implements Logger {
    log(message: string): void {
        console.log(`[LOG] ${message}`);
    }
}

class FileLogger implements Logger {
    log(message: string): void {
        console.log(`[FILE LOG] ${message}`);
    }
}

// Usage with dependency injection
const stripeGateway = new StripePaymentGateway();
const consoleLogger = new ConsoleLogger();
const paymentProcessor = new PaymentProcessor(stripeGateway, consoleLogger);

// Easy to swap implementations
const paypalGateway = new PayPalPaymentGateway();
const fileLogger = new FileLogger();
const alternativeProcessor = new PaymentProcessor(paypalGateway, fileLogger);
```

## How This Principle Helps with Code Quality

1. **Loose Coupling**: High-level modules are independent of low-level implementation details
2. **Flexibility**: Dependencies can be easily swapped or modified
3. **Maintainability**: Changes to low-level modules don't affect high-level modules
4. **Extensibility**: New implementations can be added without modifying existing code
5. **Better Design**: Forces proper separation of concerns and abstraction layers

## How This Principle Helps with Automated Testing

1. **Easy Mocking**: Dependencies can be easily mocked for testing
2. **Isolated Testing**: High-level modules can be tested independently
3. **Test Flexibility**: Different implementations can be used for different test scenarios
4. **Better Test Coverage**: Each component can be tested in isolation
5. **Faster Tests**: Mocked dependencies make tests run faster

```csharp
// Example of testing with DIP
[Test]
public void OrderService_ProcessOrder_SavesOrderAndSendsEmail()
{
    // Arrange
    var mockRepository = new Mock<IOrderRepository>();
    var mockEmailService = new Mock<IEmailService>();
    var mockLogger = new Mock<ILogger>();
    var orderService = new OrderService(mockRepository.Object, mockEmailService.Object, mockLogger.Object);
    var order = new Order { Id = 1, CustomerEmail = "test@example.com" };
    
    // Act
    orderService.ProcessOrder(order);
    
    // Assert
    mockRepository.Verify(x => x.SaveOrder(order), Times.Once);
    mockEmailService.Verify(x => x.SendConfirmationEmail("test@example.com"), Times.Once);
    mockLogger.Verify(x => x.Log("Order 1 processed successfully"), Times.Once);
}

[Test]
public void OrderService_ProcessOrder_LogsErrorOnException()
{
    // Arrange
    var mockRepository = new Mock<IOrderRepository>();
    var mockEmailService = new Mock<IEmailService>();
    var mockLogger = new Mock<ILogger>();
    mockRepository.Setup(x => x.SaveOrder(It.IsAny<Order>())).Throws(new Exception("Database error"));
    var orderService = new OrderService(mockRepository.Object, mockEmailService.Object, mockLogger.Object);
    var order = new Order { Id = 1, CustomerEmail = "test@example.com" };
    
    // Act & Assert
    Assert.Throws<Exception>(() => orderService.ProcessOrder(order));
    mockLogger.Verify(x => x.Log("Error processing order 1: Database error"), Times.Once);
}
```

## Summary

The Dependency Inversion Principle is the capstone of the SOLID principles, creating loosely coupled and highly cohesive systems. By ensuring that high-level modules depend on abstractions rather than concrete implementations, we achieve:

- **Loose Coupling**: High-level modules are independent of low-level implementation details
- **Flexibility**: Dependencies can be easily swapped or modified
- **Testability**: Dependencies can be easily mocked for testing
- **Maintainability**: Changes to low-level modules don't affect high-level modules
- **Extensibility**: New implementations can be added without modifying existing code

This principle completes the SOLID foundation by building upon all the previous principles:
- **SRP** ensures each class has a single responsibility
- **OCP** allows extending functionality without modification
- **LSP** ensures subclasses can substitute base classes
- **ISP** creates focused, cohesive interfaces
- **DIP** inverts dependencies to depend on abstractions

Together, these principles create a robust foundation for building maintainable, testable, and extensible software systems.

## Exercise 1: Design - Dependency Inversion Principle

### Objective
Design a solution that makes high-level modules depend on abstractions rather than concrete implementations, following the Dependency Inversion Principle.

### Task
Analyze the e-commerce system and design an architecture that inverts dependencies.

1. **Identify Dependencies**: Examine the refactored code from previous exercises and identify all direct dependencies on concrete implementations
2. **Design Abstractions**: Create interfaces or abstract classes for all external dependencies
3. **Plan Dependency Injection**: Design how dependencies will be injected into high-level modules
4. **Design IoC Container**: Plan a dependency injection container configuration

### Deliverables
- List of all direct dependencies identified
- Interface designs for all external dependencies
- Dependency injection architecture plan
- IoC container configuration design

### Getting Started
1. Navigate to the `ecom-exercises` folder
2. Choose your preferred language (C#, Java, Python, or TypeScript)
3. Review your refactored code from all previous SOLID principle exercises
4. Identify direct dependencies on concrete implementations
5. Create your design without modifying any code

---

## Exercise 2: Implementation - Dependency Inversion Principle

### Objective
Implement your design from Exercise 1, ensuring that all existing unit tests continue to pass and high-level modules depend on abstractions.

### Task
Implement the dependency inversion architecture according to your design while maintaining system functionality.

1. **Create Abstractions**: Implement the interfaces or abstract classes from your design
2. **Implement Dependency Injection**: Modify classes to receive dependencies through constructor injection
3. **Configure IoC Container**: Set up dependency injection container with proper mappings
4. **Maintain Functionality**: Ensure all existing unit tests pass
5. **Test with Mocks**: Verify that the system works with mock implementations

### Success Criteria
- All existing unit tests pass
- The application runs without errors
- High-level modules depend on abstractions, not concrete implementations
- Dependencies can be easily swapped or mocked
- The system maintains the same external behavior

### Getting Started
1. Use your design from Exercise 1 as a guide
2. Start by creating the abstractions
3. Implement dependency injection in existing classes
4. Set up the IoC container configuration
5. Run tests frequently to ensure you don't break existing functionality

### Implementation Best Practices

#### Git Workflow
1. **Create a Feature Branch**: Start from main and create a new branch for your DIP refactoring
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/dip-refactoring
   ```

2. **Commit Frequently**: Make small, focused commits as you refactor
   ```bash
   git add .
   git commit -m "Create IDatabaseConnection interface"
   git commit -m "Create IEmailService interface"
   git commit -m "Implement dependency injection in OrderService"
   git commit -m "Configure IoC container mappings"
   git commit -m "Add mock implementations for testing"
   ```

3. **Test After Each Change**: Run tests after each refactoring step
   ```bash
   # Run tests to ensure nothing is broken
   dotnet test  # or equivalent for your language
   ```

#### Industry Best Practices
1. **Dependency Injection**: Use constructor injection for required dependencies
2. **Interface Segregation**: Create focused interfaces for each dependency
3. **IoC Container Configuration**: Use dependency injection containers for automatic resolution
4. **Mock Testing**: Create mock implementations for unit testing
5. **Configuration Management**: Externalize configuration for different environments
6. **Service Locator Anti-pattern**: Avoid service locator pattern in favor of dependency injection
7. **Circular Dependencies**: Avoid circular dependencies between modules
8. **Lifetime Management**: Properly manage object lifetimes (singleton, transient, scoped)
9. **Error Handling**: Handle dependency resolution failures gracefully
10. **Performance**: Consider the performance impact of dependency injection

### Learning Objectives
After completing both exercises, you should be able to:
- Identify direct dependencies that violate DIP
- Design proper abstractions for external dependencies
- Implement dependency injection effectively
- Implement DIP while maintaining system functionality
- Design loosely coupled systems

**Congratulations!** You have now learned all five SOLID principles. These principles work together to create software that is maintainable, testable, and adaptable to change. Apply them thoughtfully in your projects to build better software.

