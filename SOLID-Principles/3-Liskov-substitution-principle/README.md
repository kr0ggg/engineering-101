# Liskov Substitution Principle (LSP)

## Name
**Liskov Substitution Principle** - The "L" in SOLID

## Goal of the Principle
Objects of a superclass should be replaceable with objects of its subclasses without affecting the correctness of the program. Derived classes must be substitutable for their base classes, maintaining the same behavior and contracts.

## Theoretical Foundation

### Barbara Liskov's Original Work
The Liskov Substitution Principle was formally defined by Barbara Liskov in 1987 as part of her work on abstract data types and behavioral subtyping. Liskov's work established the mathematical foundation for understanding when one type can safely substitute for another.

### Behavioral Subtyping Theory
LSP formalizes the concept of behavioral subtyping, which states that a subtype should be substitutable for its supertype in all contexts. This is more restrictive than structural subtyping, which only requires matching method signatures.

### Design by Contract
The principle is closely related to Bertrand Meyer's Design by Contract methodology:
- **Preconditions**: Conditions that must be true before a method is called
- **Postconditions**: Conditions that must be true after a method completes
- **Invariants**: Conditions that must always be true for an object

### Type Theory and Polymorphism
LSP ensures that polymorphism works correctly by guaranteeing that:
- Method calls on derived objects produce expected results
- Derived objects maintain the same invariants as base objects
- Exception handling remains consistent across the inheritance hierarchy

### Mathematical Foundation
The principle is based on the mathematical concept of substitutability, where if S is a subtype of T, then objects of type S can replace objects of type T without changing the correctness of the program.

## Consequences of Violating LSP

### Unique LSP-Specific Issues

**Polymorphism Breakdown**
- Code using base class references may fail with derived class objects
- Generic algorithms may produce incorrect results
- Collection operations may behave unexpectedly
- Framework code may malfunction

**Contract Violations**
- Methods may throw unexpected exceptions
- Return values may not match expected types
- Side effects may differ from base class behavior
- Program correctness cannot be guaranteed

**Testing Inconsistencies**
- Tests that pass with base classes may fail with derived classes
- Mock objects may not behave like real objects
- Integration tests become unreliable
- Test coverage becomes meaningless

**Inheritance Hierarchy Problems**
- Changes to derived classes can break existing code
- Inheritance hierarchies become unreliable
- Code reuse becomes dangerous
- Refactoring becomes risky

## Impact on Static Code Analysis

### LSP-Specific Metrics

**Polymorphism Reliability**
- Consistent behavior across inheritance hierarchies improves reliability scores
- Predictable polymorphism reduces complexity in static analysis
- Better inheritance design metrics in tools like SonarQube

**Contract Compliance Detection**
- Tools can detect violations of method contracts
- Identification of precondition/postcondition violations
- Detection of invariant breaking in subclasses

### LSP-Specific Tool Benefits

**ESLint/TSLint (JavaScript/TypeScript)**
- Better "no-dupe-class-members" compliance
- Improved "no-useless-constructor" usage
- Reduced "prefer-const" violations in inheritance

**Checkstyle (Java)**
- Better "VisibilityModifier" compliance
- Improved "MethodLength" in inheritance hierarchies

**FxCop/StyleCop (.NET)**
- Fewer "CA1501" (Avoid excessive inheritance) violations

### LSP-Specific Detection

**LSP Violation Detection**
- Detection of subclasses that don't honor base class contracts
- Identification of methods that throw unexpected exceptions
- Recognition of return type violations in inheritance
- Detection of invariant breaking in subclasses

**Inheritance Analysis**
- Analysis of inheritance hierarchy depth and breadth
- Detection of proper abstract class usage
- Recognition of interface implementation compliance

## Role in Improving Software Quality

The Liskov Substitution Principle is essential for maintaining the integrity of object-oriented design. It ensures that:

- **Reliability**: Subclasses behave predictably when substituted for base classes
- **Consistency**: Inheritance relationships maintain their intended behavior
- **Maintainability**: Changes to subclasses don't break existing code
- **Testability**: Subclasses can be tested using the same test cases as base classes
- **Polymorphism**: Runtime polymorphism works correctly and safely

## How to Apply This Principle

### 1. Maintain Contracts
**What it means**: Subclasses must honor the contracts established by their base classes. This includes method signatures, return types, exception handling, and behavioral expectations.

**How to do it**:
- Ensure subclasses implement all methods from the base class with compatible signatures
- Maintain the same return types or use covariant return types where appropriate
- Don't change method parameters in ways that would break existing callers
- Preserve the semantic meaning of method names and their intended behavior

**Example from our code samples**: In the violating `Bird` example, the `Penguin` class throws an exception when `Fly()` is called, breaking the contract that all birds can fly. The refactored solution creates separate interfaces (`IFlyingBird` and `ISwimmingBird`) so that each subclass only implements contracts it can actually honor.

### 2. Preserve Invariants
**What it means**: Subclasses must maintain the same invariants (conditions that are always true) as their base classes. These are the fundamental properties that define the object's state and behavior.

**How to do it**:
- Identify the invariants that the base class maintains
- Ensure subclasses don't violate these invariants in their implementations
- Document invariants clearly so subclasses understand what they must preserve
- Test invariants to ensure they hold for all subclasses

**Example from our code samples**: In the violating `Rectangle`/`Square` example, the `Square` class changes the behavior of `setWidth()` and `setHeight()` methods, violating the invariant that these methods should only affect their respective dimensions. The refactored solution makes `Square` a separate class with its own `setSide()` method, preserving the invariants of both shapes.

### 3. Avoid Weakening Preconditions
**What it means**: Subclasses should not impose stricter requirements on their methods than the base class does. This would make the subclass less substitutable, not more.

**How to do it**:
- Don't add additional validation or requirements in subclass methods
- Don't require additional parameters or more specific types
- Don't impose stricter business rules than the base class
- If you need stricter validation, consider composition instead of inheritance

**Example from our code samples**: If a base class `PaymentProcessor` accepts any amount greater than zero, a subclass shouldn't require amounts to be above $10. This would make the subclass unusable in contexts where the base class is expected to handle smaller amounts.

### 4. Avoid Strengthening Postconditions
**What it means**: Subclasses should not weaken the guarantees made by base class methods. This would break the expectations of code that depends on the base class behavior.

**How to do it**:
- Don't reduce the functionality or capabilities promised by base class methods
- Don't change return values in ways that would break existing code
- Don't remove side effects that calling code might depend on
- If you need different behavior, consider composition or a different inheritance hierarchy

**Example from our code samples**: If a base class `Logger` guarantees that all messages will be written to a file, a subclass shouldn't only log messages above a certain priority level. This would break the contract and make the subclass unsuitable for contexts requiring all messages to be logged.

### 5. Use Composition Over Inheritance
**What it means**: When substitution becomes problematic or creates awkward inheritance relationships, consider using composition instead. This often leads to more flexible and maintainable designs.

**How to do it**:
- Identify when inheritance relationships don't naturally fit the "is-a" relationship
- Use composition to combine behaviors from multiple sources
- Create interfaces that define the capabilities you need
- Implement these interfaces through composition rather than inheritance

**Example from our code samples**: The refactored `Bird` solution uses composition by creating separate interfaces for different capabilities (`IFlyingBird`, `ISwimmingBird`). A `Penguin` implements `ISwimmingBird` and can be used wherever swimming behavior is needed, without forcing it to implement flying behavior it doesn't have.

## Examples of Violations and Refactoring

### C# Example

**Violating LSP:**
```csharp
public class Bird
{
    public virtual void Fly()
    {
        Console.WriteLine("Flying...");
    }
    
    public virtual void Eat()
    {
        Console.WriteLine("Eating...");
    }
}

public class Eagle : Bird
{
    public override void Fly()
    {
        Console.WriteLine("Eagle soaring high...");
    }
}

public class Penguin : Bird
{
    public override void Fly()
    {
        throw new NotImplementedException("Penguins can't fly!");
    }
}

// This violates LSP because Penguin can't substitute Bird
public class BirdWatcher
{
    public void WatchBird(Bird bird)
    {
        bird.Eat();
        bird.Fly(); // This will throw exception for Penguin!
    }
}
```

**Refactored - Applying LSP:**
```csharp
// Base interface for all birds
public interface IBird
{
    void Eat();
}

// Interface for flying birds only
public interface IFlyingBird : IBird
{
    void Fly();
}

// Interface for swimming birds
public interface ISwimmingBird : IBird
{
    void Swim();
}

// Concrete implementations that honor their contracts
public class Eagle : IFlyingBird
{
    public void Eat()
    {
        Console.WriteLine("Eagle eating...");
    }
    
    public void Fly()
    {
        Console.WriteLine("Eagle soaring high...");
    }
}

public class Penguin : ISwimmingBird
{
    public void Eat()
    {
        Console.WriteLine("Penguin eating...");
    }
    
    public void Swim()
    {
        Console.WriteLine("Penguin swimming...");
    }
}

// Now substitution works correctly
public class BirdWatcher
{
    public void WatchFlyingBird(IFlyingBird bird)
    {
        bird.Eat();
        bird.Fly(); // Safe - all flying birds can fly
    }
    
    public void WatchSwimmingBird(ISwimmingBird bird)
    {
        bird.Eat();
        bird.Swim(); // Safe - all swimming birds can swim
    }
}
```

### Java Example

**Violating LSP:**
```java
public class Rectangle {
    protected int width;
    protected int height;
    
    public void setWidth(int width) {
        this.width = width;
    }
    
    public void setHeight(int height) {
        this.height = height;
    }
    
    public int getArea() {
        return width * height;
    }
}

public class Square extends Rectangle {
    @Override
    public void setWidth(int width) {
        this.width = width;
        this.height = width; // Violates LSP - changes behavior
    }
    
    @Override
    public void setHeight(int height) {
        this.width = height; // Violates LSP - changes behavior
        this.height = height;
    }
}

// This violates LSP because Square changes Rectangle's behavior
public class AreaCalculator {
    public void calculateArea(Rectangle rectangle) {
        rectangle.setWidth(5);
        rectangle.setHeight(4);
        // Expects 20, but gets 16 for Square!
        System.out.println("Area: " + rectangle.getArea());
    }
}
```

**Refactored - Applying LSP:**
```java
// Abstract base class that defines the contract
public abstract class Shape {
    public abstract int getArea();
}

// Concrete implementations that honor their contracts
public class Rectangle extends Shape {
    private int width;
    private int height;
    
    public Rectangle(int width, int height) {
        this.width = width;
        this.height = height;
    }
    
    public void setWidth(int width) {
        this.width = width;
    }
    
    public void setHeight(int height) {
        this.height = height;
    }
    
    @Override
    public int getArea() {
        return width * height;
    }
}

public class Square extends Shape {
    private int side;
    
    public Square(int side) {
        this.side = side;
    }
    
    public void setSide(int side) {
        this.side = side;
    }
    
    @Override
    public int getArea() {
        return side * side;
    }
}

// Now substitution works correctly
public class AreaCalculator {
    public void calculateArea(Shape shape) {
        System.out.println("Area: " + shape.getArea());
    }
}
```

### TypeScript Example

**Violating LSP:**
```typescript
class Vehicle {
    startEngine(): void {
        console.log("Engine started");
    }
    
    accelerate(): void {
        console.log("Accelerating...");
    }
}

class Car extends Vehicle {
    startEngine(): void {
        console.log("Car engine started");
    }
    
    accelerate(): void {
        console.log("Car accelerating...");
    }
}

class Bicycle extends Vehicle {
    startEngine(): void {
        throw new Error("Bicycles don't have engines!");
    }
    
    accelerate(): void {
        console.log("Pedaling faster...");
    }
}

// This violates LSP because Bicycle can't substitute Vehicle
function startVehicle(vehicle: Vehicle): void {
    vehicle.startEngine(); // This will throw for Bicycle!
}
```

**Refactored - Applying LSP:**
```typescript
// Base interface for all vehicles
interface Vehicle {
    accelerate(): void;
}

// Interface for motorized vehicles
interface MotorizedVehicle extends Vehicle {
    startEngine(): void;
}

// Interface for human-powered vehicles
interface HumanPoweredVehicle extends Vehicle {
    pedal(): void;
}

// Concrete implementations that honor their contracts
class Car implements MotorizedVehicle {
    startEngine(): void {
        console.log("Car engine started");
    }
    
    accelerate(): void {
        console.log("Car accelerating...");
    }
}

class Bicycle implements HumanPoweredVehicle {
    accelerate(): void {
        console.log("Pedaling faster...");
    }
    
    pedal(): void {
        console.log("Pedaling...");
    }
}

// Now substitution works correctly
function startMotorizedVehicle(vehicle: MotorizedVehicle): void {
    vehicle.startEngine(); // Safe - all motorized vehicles have engines
    vehicle.accelerate();
}

function rideHumanPoweredVehicle(vehicle: HumanPoweredVehicle): void {
    vehicle.pedal(); // Safe - all human-powered vehicles can pedal
    vehicle.accelerate();
}
```

## How This Principle Helps with Code Quality

1. **Predictable Behavior**: Subclasses behave as expected when substituted
2. **Consistent Interfaces**: Inheritance relationships maintain their contracts
3. **Reduced Bugs**: Eliminates unexpected behavior from subclass substitution
4. **Better Design**: Forces proper inheritance hierarchies
5. **Maintainable Code**: Changes to subclasses don't break existing functionality

## How This Principle Helps with Automated Testing

1. **Test Reusability**: Tests for base classes can be reused for subclasses
2. **Consistent Testing**: All subclasses can be tested using the same test patterns
3. **Mock Substitution**: Subclasses can be used as mocks for base classes
4. **Regression Prevention**: Substitution violations are caught during testing
5. **Comprehensive Coverage**: Tests ensure all subclasses honor their contracts

```csharp
// Example of testing with LSP
[Test]
public void Eagle_CanSubstituteForFlyingBird()
{
    // Arrange
    IFlyingBird bird = new Eagle();
    
    // Act & Assert
    Assert.DoesNotThrow(() => bird.Eat());
    Assert.DoesNotThrow(() => bird.Fly());
}

[Test]
public void Penguin_CanSubstituteForSwimmingBird()
{
    // Arrange
    ISwimmingBird bird = new Penguin();
    
    // Act & Assert
    Assert.DoesNotThrow(() => bird.Eat());
    Assert.DoesNotThrow(() => bird.Swim());
}

[Test]
public void BirdWatcher_WatchFlyingBird_WorksWithAnyFlyingBird()
{
    // Arrange
    var watcher = new BirdWatcher();
    IFlyingBird eagle = new Eagle();
    
    // Act & Assert
    Assert.DoesNotThrow(() => watcher.WatchFlyingBird(eagle));
}

// Test that demonstrates LSP compliance
[Test]
public void AllFlyingBirds_CanBeSubstituted()
{
    // Arrange
    var flyingBirds = new IFlyingBird[] { new Eagle() };
    
    // Act & Assert
    foreach (var bird in flyingBirds)
    {
        Assert.DoesNotThrow(() => bird.Eat());
        Assert.DoesNotThrow(() => bird.Fly());
    }
}
```

## Summary

The Liskov Substitution Principle is crucial for maintaining the integrity of object-oriented design. By ensuring that subclasses can be substituted for their base classes without breaking functionality, we achieve:

- **Reliability**: Predictable behavior across inheritance hierarchies
- **Consistency**: Proper inheritance relationships that maintain contracts
- **Maintainability**: Changes to subclasses don't break existing code
- **Testability**: Subclasses can be tested using the same patterns as base classes

This principle builds upon the Open/Closed Principle by ensuring that the extensions we create (subclasses) can be safely substituted for their base classes. It also sets the foundation for the Interface Segregation Principle, as proper substitution requires well-defined, focused interfaces.

## Exercise 1: Design - Liskov Substitution Principle

### Objective
Design inheritance hierarchies where subclasses can be substituted for their base classes without breaking functionality, following the Liskov Substitution Principle.

### Task
Analyze the e-commerce system and design proper inheritance relationships that honor LSP.

1. **Identify Inheritance Opportunities**: Examine the refactored code from previous exercises and identify where inheritance relationships make sense
2. **Design Base Classes**: Create abstract base classes or interfaces that define clear contracts
3. **Plan Subclasses**: Design concrete implementations that honor the base class contracts
4. **Validate Substitution**: Ensure that subclasses can be substituted for base classes without breaking functionality

### Deliverables
- Inheritance hierarchy design showing base classes and subclasses
- Contract definitions for base classes (preconditions, postconditions, invariants)
- Substitution validation plan
- Examples of proper and improper inheritance relationships

### Getting Started
1. Navigate to the `ecom-exercises` folder
2. Choose your preferred language (C#, Java, Python, or TypeScript)
3. Review your refactored code from SRP and OCP exercises
4. Identify where inheritance would be beneficial
5. Create your design without modifying any code

---

## Exercise 2: Implementation - Liskov Substitution Principle

### Objective
Implement your design from Exercise 1, ensuring that all existing unit tests continue to pass and subclasses can be substituted for base classes.

### Task
Implement the inheritance hierarchies according to your design while maintaining system functionality.

1. **Create Base Classes**: Implement the abstract base classes or interfaces from your design
2. **Implement Subclasses**: Create concrete implementations that honor the base class contracts
3. **Ensure Substitution**: Verify that subclasses can be substituted for base classes without breaking functionality
4. **Maintain Functionality**: Ensure all existing unit tests pass
5. **Test Polymorphism**: Verify that polymorphic behavior works correctly with all implementations

### Success Criteria
- All existing unit tests pass
- The application runs without errors
- Subclasses can be substituted for base classes without breaking functionality
- Polymorphic behavior works correctly
- The system maintains the same external behavior

### Getting Started
1. Use your design from Exercise 1 as a guide
2. Start by implementing the base classes
3. Create concrete implementations that honor the contracts
4. Run tests frequently to ensure you don't break existing functionality
5. Test substitution by using subclasses where base classes are expected

### Implementation Best Practices

#### Git Workflow
1. **Create a Feature Branch**: Start from main and create a new branch for your LSP refactoring
   ```bash
   git checkout main
   git pull origin main
   git checkout -b feature/lsp-refactoring
   ```

2. **Commit Frequently**: Make small, focused commits as you refactor
   ```bash
   git add .
   git commit -m "Create PaymentProcessor base class"
   git commit -m "Implement CreditCardProcessor"
   git commit -m "Implement PayPalProcessor"
   git commit -m "Add substitution tests for PaymentProcessor"
   git commit -m "Create ShippingCalculator hierarchy"
   ```

3. **Test After Each Change**: Run tests after each refactoring step
   ```bash
   # Run tests to ensure nothing is broken
   dotnet test  # or equivalent for your language
   ```

#### Industry Best Practices
1. **Contract Definition**: Clearly define preconditions, postconditions, and invariants for base classes
2. **Substitution Testing**: Create tests that verify subclasses can substitute for base classes
3. **Behavioral Compatibility**: Ensure subclasses maintain the same behavior as base classes
4. **Exception Handling**: Subclasses should not throw exceptions that base classes don't throw
5. **Return Type Covariance**: Use covariant return types where appropriate
6. **Composition Over Inheritance**: Consider composition when inheritance violates LSP
7. **Documentation**: Document the behavioral contracts that subclasses must honor
8. **Refactoring Safety**: Use polymorphism safely without breaking existing functionality

### Learning Objectives
After completing both exercises, you should be able to:
- Design inheritance hierarchies that honor LSP
- Ensure subclasses can substitute for base classes
- Implement LSP while maintaining system functionality
- Identify and fix LSP violations
- Use composition when inheritance is problematic

**Next**: The [Interface Segregation Principle](../4-Interface-segregation-principle/README.md) builds upon LSP by ensuring that clients only depend on the interfaces they actually use, creating more focused and maintainable designs.

