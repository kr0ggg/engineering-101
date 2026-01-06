# Single Responsibility Principle (SRP)

## Name
**Single Responsibility Principle** - The "S" in SOLID

> **🎨 React Developers**: This is the backend-focused version. For React.js/TypeScript-specific content, see the [Frontend Edition](../../frontend/1-Single-class-reponsibility-principle/README.md).

## Goal of the Principle
A class should have only one reason to change, meaning it should have only one job or responsibility. Each class should encapsulate a single concept or functionality, making the code more maintainable, testable, and understandable.

## Theoretical Foundation

### Cognitive Load Theory
The Single Responsibility Principle directly addresses cognitive load theory in software development. When a class has multiple responsibilities, developers must simultaneously track multiple concepts, increasing mental effort and error probability. By limiting each class to a single responsibility, we reduce the cognitive burden required to understand, modify, and debug code.

### Separation of Concerns
SRP formalizes the fundamental software engineering principle of separation of concerns. This principle states that different aspects of functionality should be handled by different modules, reducing complexity and improving maintainability.

### Cohesion Theory
SRP maximizes cohesion within a class while minimizing coupling between classes. High cohesion means that all elements within a class work together toward a single, well-defined purpose, making the class easier to understand and modify.

### Change Impact Analysis
The principle is based on the observation that different responsibilities change for different reasons and at different rates. By separating these responsibilities, we minimize the ripple effects of changes throughout the system.

## Consequences of Violating SRP

### Unique SRP-Specific Issues

**Multiple Responsibility Coupling**
- Changes to one responsibility can inadvertently affect other responsibilities
- Bug fixes in one area can break functionality in another
- New features require understanding multiple unrelated concepts

**Cognitive Load and Complexity**
- Developers must simultaneously track multiple concepts
- Increased mental effort and error probability
- Reduced code clarity and maintainability

**Testing and Reusability Problems**
- Classes with multiple responsibilities require complex test scenarios
- Cannot be reused in contexts where only one responsibility is needed
- Forces developers to accept unnecessary dependencies or duplicate code

## Impact on Static Code Analysis

### SRP-Specific Metrics

**Cyclomatic Complexity Reduction**
- Single-responsibility classes have simpler control flow
- Fewer conditional branches and loops per class
- Lower complexity scores in tools like SonarQube

**Cohesion Metrics Enhancement**
- High cohesion within classes (all methods work toward single purpose)
- Improved LCOM (Lack of Cohesion of Methods) scores
- Better class design metrics in static analysis tools

### SRP-Specific Tool Benefits

**ESLint/TSLint (JavaScript/TypeScript)**
- Fewer "max-lines-per-function" violations
- Better "max-params" compliance
- Improved "max-statements" scores

**Checkstyle (Java)**
- Better "ParameterNumber" scores
- Improved "MethodLength" compliance

**FxCop/StyleCop (.NET)**
- Better "CA1500" (Avoid excessive class coupling) compliance

### SRP-Specific Detection

**SRP Violation Detection**
- Tools can identify classes with multiple responsibilities
- Detection of "God Classes" with too many methods
- Identification of classes violating cohesion principles
- Automated refactoring suggestions for SRP compliance

## Role in Improving Software Quality

The Single Responsibility Principle is the foundation of clean code architecture. It ensures that:

- **Maintainability**: Changes to one responsibility don't affect others
- **Testability**: Each class can be tested in isolation
- **Readability**: Code is self-documenting with clear purposes
- **Reusability**: Single-purpose classes are easier to reuse
- **Debugging**: Issues are easier to locate and fix

## How to Apply This Principle

### 1. Identify Responsibilities
**What it means**: Carefully analyze each class to understand all the different things it's doing. Look for methods that serve different purposes or handle different aspects of functionality.

**How to do it**: 
- List all the methods in your class
- Group methods by their purpose or the type of data they work with
- Ask yourself: "What are all the different reasons this class might need to change?"
- Look for methods that operate on different types of data or serve different business purposes

**Example from our code samples**: In the violating `UserManager` class, we can identify four distinct responsibilities:
- **Data persistence** (SaveUser method working with database connections)
- **Communication** (SendEmail method handling SMTP operations) 
- **Report generation** (GenerateReport method creating files)
- **Validation** (ValidateUser method checking business rules)

### 2. Separate Concerns
**What it means**: Once you've identified multiple responsibilities, create separate classes for each distinct responsibility. Each class should have a single, well-defined purpose.

**How to do it**:
- Create a new class for each identified responsibility
- Move related methods to their appropriate class
- Ensure each class has a clear, single purpose
- Give each class a descriptive name that reflects its single responsibility

**Example from our code samples**: The refactored solution separates the `UserManager` into:
- `UserRepository` - handles only data persistence operations
- `EmailService` - handles only email communication
- `ReportGenerator` - handles only report creation
- `UserValidator` - handles only user validation logic

### 3. Use Composition
**What it means**: When you need functionality from multiple single-responsibility classes, combine them through composition rather than inheritance. This allows you to use multiple focused classes together while maintaining their individual responsibilities.

**How to do it**:
- Create a coordinator class that uses multiple single-responsibility classes
- Inject dependencies through constructor or method parameters
- Delegate specific operations to the appropriate specialized class
- Keep the coordinator focused on orchestrating the workflow, not implementing the details

**Example from our code samples**: The refactored `OrderProcessor` uses composition to coordinate multiple services:
- It depends on `OrderRepository`, `PriceCalculator`, `EmailService`, `InventoryService`, and `InvoiceGenerator`
- Each dependency handles one specific aspect of order processing
- The `OrderProcessor` orchestrates the workflow without implementing any of the details

### 4. Apply the "One Reason to Change" Rule
**What it means**: This is the litmus test for SRP compliance. If you can identify multiple, unrelated reasons why a class might need to be modified, it violates the Single Responsibility Principle.

**How to do it**:
- For each class, ask: "What are all the possible reasons this class might need to change?"
- If you can identify more than one reason, the class likely has multiple responsibilities
- Each reason to change should be related to a single, cohesive responsibility
- If reasons are unrelated (e.g., "database schema changes" and "email template updates"), split the class

**Example from our code samples**: The violating `UserManager` class has multiple reasons to change:
- Database schema changes (affects SaveUser)
- Email service provider changes (affects SendEmail)
- Report format changes (affects GenerateReport)
- Validation rule changes (affects ValidateUser)

The refactored solution ensures each class has only one reason to change:
- `UserRepository` changes only when data persistence needs change
- `EmailService` changes only when email communication needs change
- `ReportGenerator` changes only when report generation needs change
- `UserValidator` changes only when validation rules change

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

## Exercise 1: Design - Single Responsibility Principle

### Objective
Design a solution that separates the multiple responsibilities in the `EcommerceManager` class into focused, single-responsibility classes.

### Task
Analyze the `EcommerceManager` class in the `ecom-exercises` folder and create a design that follows the Single Responsibility Principle.

1. **Identify Responsibilities**: Examine the `EcommerceManager` class and list all the different responsibilities it handles
2. **Design Classes**: Create a class diagram or design document showing how you would separate these responsibilities into focused classes
3. **Define Interfaces**: Design interfaces that define the contracts for each responsibility
4. **Plan Dependencies**: Determine how the separated classes will interact and depend on each other

### Deliverables
- List of all responsibilities identified in `EcommerceManager`
- Class diagram showing the separated responsibilities
- Interface definitions for each responsibility
- Dependency relationship diagram

### Getting Started
1. Navigate to the `ecom-exercises` folder
2. Choose your preferred language (C#, Java, Python, or TypeScript)
3. Examine the `EcommerceManager` class to understand its current responsibilities
4. Create your design without modifying any code

---

## Exercise 2: Implementation - Single Responsibility Principle

### Objective
Implement your design from Exercise 1, ensuring that all existing unit tests continue to pass.

### Task
Refactor the `EcommerceManager` class according to your design while maintaining system functionality.

1. **Create Classes**: Implement the focused, single-responsibility classes from your design
2. **Implement Interfaces**: Create the interfaces and their implementations
3. **Refactor EcommerceManager**: Modify the `EcommerceManager` to use the new separated classes
4. **Maintain Functionality**: Ensure all existing unit tests pass
5. **Verify Behavior**: Run the application to confirm it works as expected

### Success Criteria
- All existing unit tests pass
- The application runs without errors
- Each class has a single, well-defined responsibility
- The system maintains the same external behavior

### Getting Started
1. Use your design from Exercise 1 as a guide
2. Start implementing the classes one by one
3. Run tests frequently to ensure you don't break existing functionality
4. Refactor incrementally rather than all at once

### Implementation Best Practices

#### Git Workflow
1. **Create a Feature Branch**: Start from main and create a new branch for your SRP refactoring
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/srp-refactoring
   ```

2. **Commit Frequently**: Make small, focused commits as you refactor
   ```bash
   git add .
   git commit -m "Extract ProductService from EcommerceManager"
   git commit -m "Extract CartService from EcommerceManager"
   git commit -m "Extract OrderService from EcommerceManager"
   ```

3. **Test After Each Change**: Run tests after each refactoring step
   ```bash
   # Run tests to ensure nothing is broken
   dotnet test  # or equivalent for your language
   ```

#### Industry Best Practices
1. **Incremental Refactoring**: Refactor one responsibility at a time rather than all at once
2. **Test-Driven Refactoring**: Ensure all existing tests pass before and after each change
3. **Single Responsibility Validation**: Ask "Does this class have only one reason to change?"
4. **Dependency Analysis**: Identify and minimize dependencies between separated classes
5. **Interface Design**: Create clear interfaces for each responsibility
6. **Documentation**: Update class documentation to reflect new responsibilities
7. **Code Review**: Have someone review your refactored code for clarity and correctness

### Learning Objectives
After completing both exercises, you should be able to:
- Identify multiple responsibilities in a single class
- Design focused, single-responsibility classes
- Implement SRP while maintaining system functionality
- Understand the benefits of SRP in practice

**Next**: The [Open/Closed Principle](../2-Open-closed-principle/README.md) builds upon SRP by ensuring that our single-responsibility classes can be extended without modification, enabling flexible and maintainable software evolution.

