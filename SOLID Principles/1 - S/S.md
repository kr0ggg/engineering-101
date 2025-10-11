# Single Responsibility Principle (SRP)

## Name
**Single Responsibility Principle** - The "S" in SOLID

## Goal of the Principle
A class should have only one reason to change, meaning it should have only one job or responsibility. Each class should encapsulate a single concept or functionality, making the code more maintainable, testable, and understandable.

## Role in Improving Software Quality

The Single Responsibility Principle is the foundation of clean code architecture. It ensures that:

- **Maintainability**: Changes to one responsibility don't affect others
- **Testability**: Each class can be tested in isolation
- **Readability**: Code is self-documenting with clear purposes
- **Reusability**: Single-purpose classes are easier to reuse
- **Debugging**: Issues are easier to locate and fix

## How to Apply This Principle

1. **Identify Responsibilities**: Analyze what your class is doing
2. **Separate Concerns**: Split classes that handle multiple responsibilities
3. **Use Composition**: Combine single-responsibility classes when needed
4. **Apply the "One Reason to Change" Rule**: If you can think of multiple reasons why a class might change, it violates SRP

## Examples of Violations and Refactoring

### C# Example

**Violating SRP:**
```csharp
public class UserManager
{
    public void SaveUser(User user)
    {
        // Database operations
        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open();
            var command = new SqlCommand("INSERT INTO Users...", connection);
            command.ExecuteNonQuery();
        }
    }

    public void SendEmail(User user, string message)
    {
        // Email sending logic
        var smtpClient = new SmtpClient("smtp.gmail.com", 587);
        smtpClient.Send("noreply@company.com", user.Email, "Notification", message);
    }

    public void GenerateReport(User user)
    {
        // Report generation
        var report = $"User Report for {user.Name}";
        File.WriteAllText($"report_{user.Id}.txt", report);
    }

    public bool ValidateUser(User user)
    {
        // Validation logic
        return !string.IsNullOrEmpty(user.Email) && user.Email.Contains("@");
    }
}
```

**Refactored - Applying SRP:**
```csharp
// Single responsibility: User data model
public class User
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
}

// Single responsibility: User persistence
public class UserRepository
{
    public void SaveUser(User user)
    {
        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open();
            var command = new SqlCommand("INSERT INTO Users...", connection);
            command.ExecuteNonQuery();
        }
    }
}

// Single responsibility: Email communication
public class EmailService
{
    public void SendEmail(User user, string message)
    {
        var smtpClient = new SmtpClient("smtp.gmail.com", 587);
        smtpClient.Send("noreply@company.com", user.Email, "Notification", message);
    }
}

// Single responsibility: Report generation
public class ReportGenerator
{
    public void GenerateReport(User user)
    {
        var report = $"User Report for {user.Name}";
        File.WriteAllText($"report_{user.Id}.txt", report);
    }
}

// Single responsibility: User validation
public class UserValidator
{
    public bool ValidateUser(User user)
    {
        return !string.IsNullOrEmpty(user.Email) && user.Email.Contains("@");
    }
}
```

### Java Example

**Violating SRP:**
```java
public class OrderProcessor {
    public void processOrder(Order order) {
        // Calculate total
        double total = calculateTotal(order);
        
        // Save to database
        saveOrder(order);
        
        // Send confirmation email
        sendConfirmationEmail(order);
        
        // Update inventory
        updateInventory(order);
        
        // Generate invoice
        generateInvoice(order);
    }
    
    private double calculateTotal(Order order) { /* ... */ }
    private void saveOrder(Order order) { /* ... */ }
    private void sendConfirmationEmail(Order order) { /* ... */ }
    private void updateInventory(Order order) { /* ... */ }
    private void generateInvoice(Order order) { /* ... */ }
}
```

**Refactored - Applying SRP:**
```java
// Single responsibility: Order data
public class Order {
    private String id;
    private List<OrderItem> items;
    private double total;
    // getters and setters
}

// Single responsibility: Order persistence
public class OrderRepository {
    public void saveOrder(Order order) {
        // Database operations
    }
}

// Single responsibility: Price calculation
public class PriceCalculator {
    public double calculateTotal(Order order) {
        // Calculation logic
        return order.getItems().stream()
            .mapToDouble(item -> item.getPrice() * item.getQuantity())
            .sum();
    }
}

// Single responsibility: Email notifications
public class EmailService {
    public void sendConfirmationEmail(Order order) {
        // Email sending logic
    }
}

// Single responsibility: Inventory management
public class InventoryService {
    public void updateInventory(Order order) {
        // Inventory update logic
    }
}

// Single responsibility: Invoice generation
public class InvoiceGenerator {
    public void generateInvoice(Order order) {
        // Invoice generation logic
    }
}

// Orchestrator that coordinates single-responsibility services
public class OrderProcessor {
    private OrderRepository orderRepository;
    private PriceCalculator priceCalculator;
    private EmailService emailService;
    private InventoryService inventoryService;
    private InvoiceGenerator invoiceGenerator;
    
    public void processOrder(Order order) {
        double total = priceCalculator.calculateTotal(order);
        order.setTotal(total);
        
        orderRepository.saveOrder(order);
        emailService.sendConfirmationEmail(order);
        inventoryService.updateInventory(order);
        invoiceGenerator.generateInvoice(order);
    }
}
```

### TypeScript Example

**Violating SRP:**
```typescript
class UserService {
    saveUser(user: User): void {
        // Database operations
        console.log(`Saving user ${user.name} to database`);
    }

    sendWelcomeEmail(user: User): void {
        // Email logic
        console.log(`Sending welcome email to ${user.email}`);
    }

    validateUser(user: User): boolean {
        // Validation logic
        return user.email.includes('@') && user.name.length > 0;
    }

    generateUserReport(user: User): string {
        // Report generation
        return `Report for ${user.name}: Active since ${user.createdAt}`;
    }

    logUserActivity(user: User, activity: string): void {
        // Logging logic
        console.log(`User ${user.name} performed: ${activity}`);
    }
}
```

**Refactored - Applying SRP:**
```typescript
interface User {
    id: number;
    name: string;
    email: string;
    createdAt: Date;
}

// Single responsibility: User persistence
class UserRepository {
    saveUser(user: User): void {
        console.log(`Saving user ${user.name} to database`);
    }
}

// Single responsibility: Email communication
class EmailService {
    sendWelcomeEmail(user: User): void {
        console.log(`Sending welcome email to ${user.email}`);
    }
}

// Single responsibility: User validation
class UserValidator {
    validateUser(user: User): boolean {
        return user.email.includes('@') && user.name.length > 0;
    }
}

// Single responsibility: Report generation
class ReportGenerator {
    generateUserReport(user: User): string {
        return `Report for ${user.name}: Active since ${user.createdAt}`;
    }
}

// Single responsibility: Activity logging
class ActivityLogger {
    logUserActivity(user: User, activity: string): void {
        console.log(`User ${user.name} performed: ${activity}`);
    }
}

// Orchestrator that coordinates single-responsibility services
class UserService {
    constructor(
        private userRepository: UserRepository,
        private emailService: EmailService,
        private userValidator: UserValidator,
        private reportGenerator: ReportGenerator,
        private activityLogger: ActivityLogger
    ) {}

    processNewUser(user: User): void {
        if (this.userValidator.validateUser(user)) {
            this.userRepository.saveUser(user);
            this.emailService.sendWelcomeEmail(user);
            this.activityLogger.logUserActivity(user, 'Account created');
        }
    }
}
```

## How This Principle Helps with Code Quality

1. **Reduced Complexity**: Each class has a single, clear purpose
2. **Better Organization**: Related functionality is grouped together
3. **Easier Maintenance**: Changes are localized to specific classes
4. **Improved Readability**: Code is self-documenting
5. **Reduced Coupling**: Classes are less dependent on each other

## How This Principle Helps with Automated Testing

1. **Unit Testing**: Each class can be tested in isolation
2. **Mocking**: Dependencies can be easily mocked for testing
3. **Test Coverage**: Easier to achieve comprehensive test coverage
4. **Test Maintenance**: Tests are simpler and more focused
5. **Parallel Testing**: Tests can run independently

```csharp
// Example of focused unit testing with SRP
[Test]
public void UserValidator_ValidUser_ReturnsTrue()
{
    // Arrange
    var validator = new UserValidator();
    var user = new User { Email = "test@example.com", Name = "John Doe" };
    
    // Act
    var result = validator.ValidateUser(user);
    
    // Assert
    Assert.IsTrue(result);
}

[Test]
public void EmailService_SendEmail_CallsSmtpClient()
{
    // Arrange
    var mockSmtpClient = new Mock<ISmtpClient>();
    var emailService = new EmailService(mockSmtpClient.Object);
    var user = new User { Email = "test@example.com" };
    
    // Act
    emailService.SendEmail(user, "Test message");
    
    // Assert
    mockSmtpClient.Verify(x => x.Send(It.IsAny<string>(), user.Email, It.IsAny<string>(), It.IsAny<string>()), Times.Once);
}
```

## Summary

The Single Responsibility Principle is the cornerstone of clean architecture. By ensuring each class has only one reason to change, we create code that is:

- **Maintainable**: Easy to modify without side effects
- **Testable**: Simple to unit test in isolation
- **Reusable**: Single-purpose classes are more reusable
- **Understandable**: Clear, focused responsibilities

This principle sets the foundation for the other SOLID principles. When classes have single responsibilities, they naturally become more extensible (Open/Closed Principle), substitutable (Liskov Substitution Principle), and focused (Interface Segregation Principle). The Single Responsibility Principle also makes it easier to apply dependency inversion, as smaller, focused classes have clearer dependencies.

**Next**: The [Open/Closed Principle](../2%20-%20O/O.md) builds upon SRP by ensuring that our single-responsibility classes can be extended without modification, enabling flexible and maintainable software evolution.

