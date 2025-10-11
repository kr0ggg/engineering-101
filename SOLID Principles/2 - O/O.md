# Open/Closed Principle (OCP)

## Name
**Open/Closed Principle** - The "O" in SOLID

## Goal of the Principle
Software entities (classes, modules, functions, etc.) should be open for extension but closed for modification. This means you should be able to add new functionality without changing existing code, promoting stability and reducing the risk of introducing bugs.

## Role in Improving Software Quality

The Open/Closed Principle is essential for creating maintainable and scalable software systems. It ensures that:

- **Stability**: Existing code remains unchanged, reducing regression risks
- **Extensibility**: New features can be added without modifying existing code
- **Maintainability**: Changes are isolated to new code, making maintenance easier
- **Testability**: Existing functionality continues to work as expected
- **Flexibility**: System can evolve to meet new requirements

## How to Apply This Principle

1. **Use Abstraction**: Create interfaces or abstract classes that define contracts
2. **Implement Polymorphism**: Use inheritance or composition to extend behavior
3. **Apply Strategy Pattern**: Encapsulate algorithms in separate classes
4. **Use Dependency Injection**: Inject dependencies to enable runtime behavior changes
5. **Design for Extension**: Plan interfaces that can accommodate future requirements

## Examples of Violations and Refactoring

### C# Example

**Violating OCP:**
```csharp
public class DiscountCalculator
{
    public decimal CalculateDiscount(Customer customer, decimal amount)
    {
        switch (customer.Type)
        {
            case CustomerType.Regular:
                return amount * 0.05m; // 5% discount
            case CustomerType.Premium:
                return amount * 0.10m; // 10% discount
            case CustomerType.VIP:
                return amount * 0.15m; // 15% discount
            default:
                return 0;
        }
    }
}

public class Customer
{
    public CustomerType Type { get; set; }
    public string Name { get; set; }
}

public enum CustomerType
{
    Regular,
    Premium,
    VIP
}
```

**Refactored - Applying OCP:**
```csharp
// Abstract base class - closed for modification
public abstract class DiscountStrategy
{
    public abstract decimal CalculateDiscount(decimal amount);
}

// Concrete implementations - open for extension
public class RegularCustomerDiscount : DiscountStrategy
{
    public override decimal CalculateDiscount(decimal amount)
    {
        return amount * 0.05m; // 5% discount
    }
}

public class PremiumCustomerDiscount : DiscountStrategy
{
    public override decimal CalculateDiscount(decimal amount)
    {
        return amount * 0.10m; // 10% discount
    }
}

public class VIPCustomerDiscount : DiscountStrategy
{
    public override decimal CalculateDiscount(decimal amount)
    {
        return amount * 0.15m; // 15% discount
    }
}

// New discount type can be added without modifying existing code
public class CorporateCustomerDiscount : DiscountStrategy
{
    public override decimal CalculateDiscount(decimal amount)
    {
        return amount * 0.20m; // 20% discount
    }
}

public class Customer
{
    public string Name { get; set; }
    public DiscountStrategy DiscountStrategy { get; set; }
}

// Calculator is closed for modification but open for extension
public class DiscountCalculator
{
    public decimal CalculateDiscount(Customer customer, decimal amount)
    {
        return customer.DiscountStrategy.CalculateDiscount(amount);
    }
}
```

### Java Example

**Violating OCP:**
```java
public class ShapeCalculator {
    public double calculateArea(Object shape) {
        if (shape instanceof Circle) {
            Circle circle = (Circle) shape;
            return Math.PI * circle.getRadius() * circle.getRadius();
        } else if (shape instanceof Rectangle) {
            Rectangle rectangle = (Rectangle) shape;
            return rectangle.getWidth() * rectangle.getHeight();
        } else if (shape instanceof Triangle) {
            Triangle triangle = (Triangle) shape;
            return 0.5 * triangle.getBase() * triangle.getHeight();
        }
        throw new IllegalArgumentException("Unknown shape type");
    }
}

public class Circle {
    private double radius;
    public double getRadius() { return radius; }
}

public class Rectangle {
    private double width, height;
    public double getWidth() { return width; }
    public double getHeight() { return height; }
}

public class Triangle {
    private double base, height;
    public double getBase() { return base; }
    public double getHeight() { return height; }
}
```

**Refactored - Applying OCP:**
```java
// Abstract interface - closed for modification
public interface Shape {
    double calculateArea();
}

// Concrete implementations - open for extension
public class Circle implements Shape {
    private double radius;
    
    public Circle(double radius) {
        this.radius = radius;
    }
    
    @Override
    public double calculateArea() {
        return Math.PI * radius * radius;
    }
}

public class Rectangle implements Shape {
    private double width, height;
    
    public Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }
    
    @Override
    public double calculateArea() {
        return width * height;
    }
}

public class Triangle implements Shape {
    private double base, height;
    
    public Triangle(double base, double height) {
        this.base = base;
        this.height = height;
    }
    
    @Override
    public double calculateArea() {
        return 0.5 * base * height;
    }
}

// New shape can be added without modifying existing code
public class Square implements Shape {
    private double side;
    
    public Square(double side) {
        this.side = side;
    }
    
    @Override
    public double calculateArea() {
        return side * side;
    }
}

// Calculator is closed for modification but open for extension
public class ShapeCalculator {
    public double calculateTotalArea(List<Shape> shapes) {
        return shapes.stream()
            .mapToDouble(Shape::calculateArea)
            .sum();
    }
}
```

### TypeScript Example

**Violating OCP:**
```typescript
class PaymentProcessor {
    processPayment(amount: number, paymentType: string): boolean {
        switch (paymentType) {
            case 'credit':
                return this.processCreditCard(amount);
            case 'paypal':
                return this.processPayPal(amount);
            case 'bank':
                return this.processBankTransfer(amount);
            default:
                throw new Error('Unsupported payment type');
        }
    }

    private processCreditCard(amount: number): boolean {
        console.log(`Processing credit card payment: $${amount}`);
        return true;
    }

    private processPayPal(amount: number): boolean {
        console.log(`Processing PayPal payment: $${amount}`);
        return true;
    }

    private processBankTransfer(amount: number): boolean {
        console.log(`Processing bank transfer: $${amount}`);
        return true;
    }
}
```

**Refactored - Applying OCP:**
```typescript
// Abstract interface - closed for modification
interface PaymentMethod {
    processPayment(amount: number): boolean;
}

// Concrete implementations - open for extension
class CreditCardPayment implements PaymentMethod {
    processPayment(amount: number): boolean {
        console.log(`Processing credit card payment: $${amount}`);
        return true;
    }
}

class PayPalPayment implements PaymentMethod {
    processPayment(amount: number): boolean {
        console.log(`Processing PayPal payment: $${amount}`);
        return true;
    }
}

class BankTransferPayment implements PaymentMethod {
    processPayment(amount: number): boolean {
        console.log(`Processing bank transfer: $${amount}`);
        return true;
    }
}

// New payment method can be added without modifying existing code
class CryptocurrencyPayment implements PaymentMethod {
    processPayment(amount: number): boolean {
        console.log(`Processing cryptocurrency payment: $${amount}`);
        return true;
    }
}

// Processor is closed for modification but open for extension
class PaymentProcessor {
    processPayment(amount: number, paymentMethod: PaymentMethod): boolean {
        return paymentMethod.processPayment(amount);
    }
}

// Usage example
const processor = new PaymentProcessor();
const creditCard = new CreditCardPayment();
const crypto = new CryptocurrencyPayment();

processor.processPayment(100, creditCard);
processor.processPayment(50, crypto);
```

## How This Principle Helps with Code Quality

1. **Reduced Risk**: Existing code remains unchanged, preventing regressions
2. **Better Organization**: New functionality is isolated in separate classes
3. **Improved Maintainability**: Changes don't cascade through the system
4. **Enhanced Readability**: Code structure is clearer and more logical
5. **Increased Stability**: Core functionality remains stable while extending capabilities

## How This Principle Helps with Automated Testing

1. **Stable Tests**: Existing tests continue to pass when adding new features
2. **Isolated Testing**: New functionality can be tested independently
3. **Mock-Friendly**: Abstract interfaces make mocking easier
4. **Regression Prevention**: Existing functionality is protected from changes
5. **Comprehensive Coverage**: Each extension can have its own test suite

```csharp
// Example of testing with OCP
[Test]
public void DiscountCalculator_RegularCustomer_ReturnsCorrectDiscount()
{
    // Arrange
    var customer = new Customer 
    { 
        Name = "John", 
        DiscountStrategy = new RegularCustomerDiscount() 
    };
    var calculator = new DiscountCalculator();
    
    // Act
    var discount = calculator.CalculateDiscount(customer, 100);
    
    // Assert
    Assert.AreEqual(5, discount);
}

[Test]
public void CorporateCustomerDiscount_CalculateDiscount_ReturnsCorrectAmount()
{
    // Arrange
    var strategy = new CorporateCustomerDiscount();
    
    // Act
    var discount = strategy.CalculateDiscount(100);
    
    // Assert
    Assert.AreEqual(20, discount);
}

// New test for new functionality without affecting existing tests
[Test]
public void DiscountCalculator_CorporateCustomer_ReturnsCorrectDiscount()
{
    // Arrange
    var customer = new Customer 
    { 
        Name = "Corp", 
        DiscountStrategy = new CorporateCustomerDiscount() 
    };
    var calculator = new DiscountCalculator();
    
    // Act
    var discount = calculator.CalculateDiscount(customer, 100);
    
    // Assert
    Assert.AreEqual(20, discount);
}
```

## Summary

The Open/Closed Principle is crucial for creating flexible and maintainable software systems. By designing classes that are open for extension but closed for modification, we achieve:

- **Stability**: Existing code remains unchanged and stable
- **Extensibility**: New features can be added without risk
- **Maintainability**: Changes are isolated and don't affect existing functionality
- **Scalability**: System can grow to meet new requirements

This principle works hand-in-hand with the Single Responsibility Principle. When classes have single responsibilities, they naturally become easier to extend without modification. The Open/Closed Principle also sets the foundation for the Liskov Substitution Principle, as the abstractions we create for extension must be substitutable.

**Next**: The [Liskov Substitution Principle](../3%20-%20L/L.md) builds upon OCP by ensuring that our extensible classes can be substituted for their base classes without breaking the system's correctness.

