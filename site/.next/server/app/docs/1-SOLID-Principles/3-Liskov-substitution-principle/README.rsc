1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","1-SOLID-Principles/3-Liskov-substitution-principle/README","c"],{"children":["__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"3-Liskov-substitution-principle\",\"README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T66be,<h1>Liskov Substitution Principle (LSP)</h1>
<h2>Name</h2>
<p><strong>Liskov Substitution Principle</strong> - The &quot;L&quot; in SOLID</p>
<h2>Goal of the Principle</h2>
<p>Objects of a superclass should be replaceable with objects of its subclasses without affecting the correctness of the program. Derived classes must be substitutable for their base classes, maintaining the same behavior and contracts.</p>
<h2>Theoretical Foundation</h2>
<h3>Barbara Liskov&#39;s Original Work</h3>
<p>The Liskov Substitution Principle was formally defined by Barbara Liskov in 1987 as part of her work on abstract data types and behavioral subtyping. Liskov&#39;s work established the mathematical foundation for understanding when one type can safely substitute for another.</p>
<h3>Behavioral Subtyping Theory</h3>
<p>LSP formalizes the concept of behavioral subtyping, which states that a subtype should be substitutable for its supertype in all contexts. This is more restrictive than structural subtyping, which only requires matching method signatures.</p>
<h3>Design by Contract</h3>
<p>The principle is closely related to Bertrand Meyer&#39;s Design by Contract methodology:</p>
<ul>
<li><strong>Preconditions</strong>: Conditions that must be true before a method is called</li>
<li><strong>Postconditions</strong>: Conditions that must be true after a method completes</li>
<li><strong>Invariants</strong>: Conditions that must always be true for an object</li>
</ul>
<h3>Type Theory and Polymorphism</h3>
<p>LSP ensures that polymorphism works correctly by guaranteeing that:</p>
<ul>
<li>Method calls on derived objects produce expected results</li>
<li>Derived objects maintain the same invariants as base objects</li>
<li>Exception handling remains consistent across the inheritance hierarchy</li>
</ul>
<h3>Mathematical Foundation</h3>
<p>The principle is based on the mathematical concept of substitutability, where if S is a subtype of T, then objects of type S can replace objects of type T without changing the correctness of the program.</p>
<h2>Consequences of Violating LSP</h2>
<h3>Unique LSP-Specific Issues</h3>
<p><strong>Polymorphism Breakdown</strong></p>
<ul>
<li>Code using base class references may fail with derived class objects</li>
<li>Generic algorithms may produce incorrect results</li>
<li>Collection operations may behave unexpectedly</li>
<li>Framework code may malfunction</li>
</ul>
<p><strong>Contract Violations</strong></p>
<ul>
<li>Methods may throw unexpected exceptions</li>
<li>Return values may not match expected types</li>
<li>Side effects may differ from base class behavior</li>
<li>Program correctness cannot be guaranteed</li>
</ul>
<p><strong>Testing Inconsistencies</strong></p>
<ul>
<li>Tests that pass with base classes may fail with derived classes</li>
<li>Mock objects may not behave like real objects</li>
<li>Integration tests become unreliable</li>
<li>Test coverage becomes meaningless</li>
</ul>
<p><strong>Inheritance Hierarchy Problems</strong></p>
<ul>
<li>Changes to derived classes can break existing code</li>
<li>Inheritance hierarchies become unreliable</li>
<li>Code reuse becomes dangerous</li>
<li>Refactoring becomes risky</li>
</ul>
<h2>Impact on Static Code Analysis</h2>
<h3>LSP-Specific Metrics</h3>
<p><strong>Polymorphism Reliability</strong></p>
<ul>
<li>Consistent behavior across inheritance hierarchies improves reliability scores</li>
<li>Predictable polymorphism reduces complexity in static analysis</li>
<li>Better inheritance design metrics in tools like SonarQube</li>
</ul>
<p><strong>Contract Compliance Detection</strong></p>
<ul>
<li>Tools can detect violations of method contracts</li>
<li>Identification of precondition/postcondition violations</li>
<li>Detection of invariant breaking in subclasses</li>
</ul>
<h3>LSP-Specific Tool Benefits</h3>
<p><strong>ESLint/TSLint (JavaScript/TypeScript)</strong></p>
<ul>
<li>Better &quot;no-dupe-class-members&quot; compliance</li>
<li>Improved &quot;no-useless-constructor&quot; usage</li>
<li>Reduced &quot;prefer-const&quot; violations in inheritance</li>
</ul>
<p><strong>Checkstyle (Java)</strong></p>
<ul>
<li>Better &quot;VisibilityModifier&quot; compliance</li>
<li>Improved &quot;MethodLength&quot; in inheritance hierarchies</li>
</ul>
<p><strong>FxCop/StyleCop (.NET)</strong></p>
<ul>
<li>Fewer &quot;CA1501&quot; (Avoid excessive inheritance) violations</li>
</ul>
<h3>LSP-Specific Detection</h3>
<p><strong>LSP Violation Detection</strong></p>
<ul>
<li>Detection of subclasses that don&#39;t honor base class contracts</li>
<li>Identification of methods that throw unexpected exceptions</li>
<li>Recognition of return type violations in inheritance</li>
<li>Detection of invariant breaking in subclasses</li>
</ul>
<p><strong>Inheritance Analysis</strong></p>
<ul>
<li>Analysis of inheritance hierarchy depth and breadth</li>
<li>Detection of proper abstract class usage</li>
<li>Recognition of interface implementation compliance</li>
</ul>
<h2>Role in Improving Software Quality</h2>
<p>The Liskov Substitution Principle is essential for maintaining the integrity of object-oriented design. It ensures that:</p>
<ul>
<li><strong>Reliability</strong>: Subclasses behave predictably when substituted for base classes</li>
<li><strong>Consistency</strong>: Inheritance relationships maintain their intended behavior</li>
<li><strong>Maintainability</strong>: Changes to subclasses don&#39;t break existing code</li>
<li><strong>Testability</strong>: Subclasses can be tested using the same test cases as base classes</li>
<li><strong>Polymorphism</strong>: Runtime polymorphism works correctly and safely</li>
</ul>
<h2>How to Apply This Principle</h2>
<h3>1. Maintain Contracts</h3>
<p><strong>What it means</strong>: Subclasses must honor the contracts established by their base classes. This includes method signatures, return types, exception handling, and behavioral expectations.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Ensure subclasses implement all methods from the base class with compatible signatures</li>
<li>Maintain the same return types or use covariant return types where appropriate</li>
<li>Don&#39;t change method parameters in ways that would break existing callers</li>
<li>Preserve the semantic meaning of method names and their intended behavior</li>
</ul>
<p><strong>Example from our code samples</strong>: In the violating <code>Bird</code> example, the <code>Penguin</code> class throws an exception when <code>Fly()</code> is called, breaking the contract that all birds can fly. The refactored solution creates separate interfaces (<code>IFlyingBird</code> and <code>ISwimmingBird</code>) so that each subclass only implements contracts it can actually honor.</p>
<h3>2. Preserve Invariants</h3>
<p><strong>What it means</strong>: Subclasses must maintain the same invariants (conditions that are always true) as their base classes. These are the fundamental properties that define the object&#39;s state and behavior.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify the invariants that the base class maintains</li>
<li>Ensure subclasses don&#39;t violate these invariants in their implementations</li>
<li>Document invariants clearly so subclasses understand what they must preserve</li>
<li>Test invariants to ensure they hold for all subclasses</li>
</ul>
<p><strong>Example from our code samples</strong>: In the violating <code>Rectangle</code>/<code>Square</code> example, the <code>Square</code> class changes the behavior of <code>setWidth()</code> and <code>setHeight()</code> methods, violating the invariant that these methods should only affect their respective dimensions. The refactored solution makes <code>Square</code> a separate class with its own <code>setSide()</code> method, preserving the invariants of both shapes.</p>
<h3>3. Avoid Weakening Preconditions</h3>
<p><strong>What it means</strong>: Subclasses should not impose stricter requirements on their methods than the base class does. This would make the subclass less substitutable, not more.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Don&#39;t add additional validation or requirements in subclass methods</li>
<li>Don&#39;t require additional parameters or more specific types</li>
<li>Don&#39;t impose stricter business rules than the base class</li>
<li>If you need stricter validation, consider composition instead of inheritance</li>
</ul>
<p><strong>Example from our code samples</strong>: If a base class <code>PaymentProcessor</code> accepts any amount greater than zero, a subclass shouldn&#39;t require amounts to be above $10. This would make the subclass unusable in contexts where the base class is expected to handle smaller amounts.</p>
<h3>4. Avoid Strengthening Postconditions</h3>
<p><strong>What it means</strong>: Subclasses should not weaken the guarantees made by base class methods. This would break the expectations of code that depends on the base class behavior.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Don&#39;t reduce the functionality or capabilities promised by base class methods</li>
<li>Don&#39;t change return values in ways that would break existing code</li>
<li>Don&#39;t remove side effects that calling code might depend on</li>
<li>If you need different behavior, consider composition or a different inheritance hierarchy</li>
</ul>
<p><strong>Example from our code samples</strong>: If a base class <code>Logger</code> guarantees that all messages will be written to a file, a subclass shouldn&#39;t only log messages above a certain priority level. This would break the contract and make the subclass unsuitable for contexts requiring all messages to be logged.</p>
<h3>5. Use Composition Over Inheritance</h3>
<p><strong>What it means</strong>: When substitution becomes problematic or creates awkward inheritance relationships, consider using composition instead. This often leads to more flexible and maintainable designs.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify when inheritance relationships don&#39;t naturally fit the &quot;is-a&quot; relationship</li>
<li>Use composition to combine behaviors from multiple sources</li>
<li>Create interfaces that define the capabilities you need</li>
<li>Implement these interfaces through composition rather than inheritance</li>
</ul>
<p><strong>Example from our code samples</strong>: The refactored <code>Bird</code> solution uses composition by creating separate interfaces for different capabilities (<code>IFlyingBird</code>, <code>ISwimmingBird</code>). A <code>Penguin</code> implements <code>ISwimmingBird</code> and can be used wherever swimming behavior is needed, without forcing it to implement flying behavior it doesn&#39;t have.</p>
<h2>Examples of Violations and Refactoring</h2>
<h3>C# Example</h3>
<p><strong>Violating LSP:</strong></p>
<pre><code class="language-csharp">public class Bird
{
    public virtual void Fly()
    {
        Console.WriteLine(&quot;Flying...&quot;);
    }
    
    public virtual void Eat()
    {
        Console.WriteLine(&quot;Eating...&quot;);
    }
}

public class Eagle : Bird
{
    public override void Fly()
    {
        Console.WriteLine(&quot;Eagle soaring high...&quot;);
    }
}

public class Penguin : Bird
{
    public override void Fly()
    {
        throw new NotImplementedException(&quot;Penguins can&#39;t fly!&quot;);
    }
}

// This violates LSP because Penguin can&#39;t substitute Bird
public class BirdWatcher
{
    public void WatchBird(Bird bird)
    {
        bird.Eat();
        bird.Fly(); // This will throw exception for Penguin!
    }
}
</code></pre>
<p><strong>Refactored - Applying LSP:</strong></p>
<pre><code class="language-csharp">// Base interface for all birds
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
        Console.WriteLine(&quot;Eagle eating...&quot;);
    }
    
    public void Fly()
    {
        Console.WriteLine(&quot;Eagle soaring high...&quot;);
    }
}

public class Penguin : ISwimmingBird
{
    public void Eat()
    {
        Console.WriteLine(&quot;Penguin eating...&quot;);
    }
    
    public void Swim()
    {
        Console.WriteLine(&quot;Penguin swimming...&quot;);
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
</code></pre>
<h3>Java Example</h3>
<p><strong>Violating LSP:</strong></p>
<pre><code class="language-java">public class Rectangle {
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

// This violates LSP because Square changes Rectangle&#39;s behavior
public class AreaCalculator {
    public void calculateArea(Rectangle rectangle) {
        rectangle.setWidth(5);
        rectangle.setHeight(4);
        // Expects 20, but gets 16 for Square!
        System.out.println(&quot;Area: &quot; + rectangle.getArea());
    }
}
</code></pre>
<p><strong>Refactored - Applying LSP:</strong></p>
<pre><code class="language-java">// Abstract base class that defines the contract
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
        System.out.println(&quot;Area: &quot; + shape.getArea());
    }
}
</code></pre>
<h3>TypeScript Example</h3>
<p><strong>Violating LSP:</strong></p>
<pre><code class="language-typescript">class Vehicle {
    startEngine(): void {
        console.log(&quot;Engine started&quot;);
    }
    
    accelerate(): void {
        console.log(&quot;Accelerating...&quot;);
    }
}

class Car extends Vehicle {
    startEngine(): void {
        console.log(&quot;Car engine started&quot;);
    }
    
    accelerate(): void {
        console.log(&quot;Car accelerating...&quot;);
    }
}

class Bicycle extends Vehicle {
    startEngine(): void {
        throw new Error(&quot;Bicycles don&#39;t have engines!&quot;);
    }
    
    accelerate(): void {
        console.log(&quot;Pedaling faster...&quot;);
    }
}

// This violates LSP because Bicycle can&#39;t substitute Vehicle
function startVehicle(vehicle: Vehicle): void {
    vehicle.startEngine(); // This will throw for Bicycle!
}
</code></pre>
<p><strong>Refactored - Applying LSP:</strong></p>
<pre><code class="language-typescript">// Base interface for all vehicles
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
        console.log(&quot;Car engine started&quot;);
    }
    
    accelerate(): void {
        console.log(&quot;Car accelerating...&quot;);
    }
}

class Bicycle implements HumanPoweredVehicle {
    accelerate(): void {
        console.log(&quot;Pedaling faster...&quot;);
    }
    
    pedal(): void {
        console.log(&quot;Pedaling...&quot;);
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
</code></pre>
<h2>How This Principle Helps with Code Quality</h2>
<ol>
<li><strong>Predictable Behavior</strong>: Subclasses behave as expected when substituted</li>
<li><strong>Consistent Interfaces</strong>: Inheritance relationships maintain their contracts</li>
<li><strong>Reduced Bugs</strong>: Eliminates unexpected behavior from subclass substitution</li>
<li><strong>Better Design</strong>: Forces proper inheritance hierarchies</li>
<li><strong>Maintainable Code</strong>: Changes to subclasses don&#39;t break existing functionality</li>
</ol>
<h2>How This Principle Helps with Automated Testing</h2>
<ol>
<li><strong>Test Reusability</strong>: Tests for base classes can be reused for subclasses</li>
<li><strong>Consistent Testing</strong>: All subclasses can be tested using the same test patterns</li>
<li><strong>Mock Substitution</strong>: Subclasses can be used as mocks for base classes</li>
<li><strong>Regression Prevention</strong>: Substitution violations are caught during testing</li>
<li><strong>Comprehensive Coverage</strong>: Tests ensure all subclasses honor their contracts</li>
</ol>
<pre><code class="language-csharp">// Example of testing with LSP
[Test]
public void Eagle_CanSubstituteForFlyingBird()
{
    // Arrange
    IFlyingBird bird = new Eagle();
    
    // Act &amp; Assert
    Assert.DoesNotThrow(() =&gt; bird.Eat());
    Assert.DoesNotThrow(() =&gt; bird.Fly());
}

[Test]
public void Penguin_CanSubstituteForSwimmingBird()
{
    // Arrange
    ISwimmingBird bird = new Penguin();
    
    // Act &amp; Assert
    Assert.DoesNotThrow(() =&gt; bird.Eat());
    Assert.DoesNotThrow(() =&gt; bird.Swim());
}

[Test]
public void BirdWatcher_WatchFlyingBird_WorksWithAnyFlyingBird()
{
    // Arrange
    var watcher = new BirdWatcher();
    IFlyingBird eagle = new Eagle();
    
    // Act &amp; Assert
    Assert.DoesNotThrow(() =&gt; watcher.WatchFlyingBird(eagle));
}

// Test that demonstrates LSP compliance
[Test]
public void AllFlyingBirds_CanBeSubstituted()
{
    // Arrange
    var flyingBirds = new IFlyingBird[] { new Eagle() };
    
    // Act &amp; Assert
    foreach (var bird in flyingBirds)
    {
        Assert.DoesNotThrow(() =&gt; bird.Eat());
        Assert.DoesNotThrow(() =&gt; bird.Fly());
    }
}
</code></pre>
<h2>Summary</h2>
<p>The Liskov Substitution Principle is crucial for maintaining the integrity of object-oriented design. By ensuring that subclasses can be substituted for their base classes without breaking functionality, we achieve:</p>
<ul>
<li><strong>Reliability</strong>: Predictable behavior across inheritance hierarchies</li>
<li><strong>Consistency</strong>: Proper inheritance relationships that maintain contracts</li>
<li><strong>Maintainability</strong>: Changes to subclasses don&#39;t break existing code</li>
<li><strong>Testability</strong>: Subclasses can be tested using the same patterns as base classes</li>
</ul>
<p>This principle builds upon the Open/Closed Principle by ensuring that the extensions we create (subclasses) can be safely substituted for their base classes. It also sets the foundation for the Interface Segregation Principle, as proper substitution requires well-defined, focused interfaces.</p>
<h2>Exercise 1: Design - Liskov Substitution Principle</h2>
<h3>Objective</h3>
<p>Design inheritance hierarchies where subclasses can be substituted for their base classes without breaking functionality, following the Liskov Substitution Principle.</p>
<h3>Task</h3>
<p>Analyze the e-commerce system and design proper inheritance relationships that honor LSP.</p>
<ol>
<li><strong>Identify Inheritance Opportunities</strong>: Examine the refactored code from previous exercises and identify where inheritance relationships make sense</li>
<li><strong>Design Base Classes</strong>: Create abstract base classes or interfaces that define clear contracts</li>
<li><strong>Plan Subclasses</strong>: Design concrete implementations that honor the base class contracts</li>
<li><strong>Validate Substitution</strong>: Ensure that subclasses can be substituted for base classes without breaking functionality</li>
</ol>
<h3>Deliverables</h3>
<ul>
<li>Inheritance hierarchy design showing base classes and subclasses</li>
<li>Contract definitions for base classes (preconditions, postconditions, invariants)</li>
<li>Substitution validation plan</li>
<li>Examples of proper and improper inheritance relationships</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Navigate to the <code>ecom-exercises</code> folder</li>
<li>Choose your preferred language (C#, Java, Python, or TypeScript)</li>
<li>Review your refactored code from SRP and OCP exercises</li>
<li>Identify where inheritance would be beneficial</li>
<li>Create your design without modifying any code</li>
</ol>
<hr>
<h2>Exercise 2: Implementation - Liskov Substitution Principle</h2>
<h3>Objective</h3>
<p>Implement your design from Exercise 1, ensuring that all existing unit tests continue to pass and subclasses can be substituted for base classes.</p>
<h3>Task</h3>
<p>Implement the inheritance hierarchies according to your design while maintaining system functionality.</p>
<ol>
<li><strong>Create Base Classes</strong>: Implement the abstract base classes or interfaces from your design</li>
<li><strong>Implement Subclasses</strong>: Create concrete implementations that honor the base class contracts</li>
<li><strong>Ensure Substitution</strong>: Verify that subclasses can be substituted for base classes without breaking functionality</li>
<li><strong>Maintain Functionality</strong>: Ensure all existing unit tests pass</li>
<li><strong>Test Polymorphism</strong>: Verify that polymorphic behavior works correctly with all implementations</li>
</ol>
<h3>Success Criteria</h3>
<ul>
<li>All existing unit tests pass</li>
<li>The application runs without errors</li>
<li>Subclasses can be substituted for base classes without breaking functionality</li>
<li>Polymorphic behavior works correctly</li>
<li>The system maintains the same external behavior</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Use your design from Exercise 1 as a guide</li>
<li>Start by implementing the base classes</li>
<li>Create concrete implementations that honor the contracts</li>
<li>Run tests frequently to ensure you don&#39;t break existing functionality</li>
<li>Test substitution by using subclasses where base classes are expected</li>
</ol>
<h3>Implementation Best Practices</h3>
<h4>Git Workflow</h4>
<ol>
<li><p><strong>Create a Feature Branch</strong>: Start from main and create a new branch for your LSP refactoring</p>
<pre><code class="language-bash">git checkout main
git pull origin main
git checkout -b feature/lsp-refactoring
</code></pre>
</li>
<li><p><strong>Commit Frequently</strong>: Make small, focused commits as you refactor</p>
<pre><code class="language-bash">git add .
git commit -m &quot;Create PaymentProcessor base class&quot;
git commit -m &quot;Implement CreditCardProcessor&quot;
git commit -m &quot;Implement PayPalProcessor&quot;
git commit -m &quot;Add substitution tests for PaymentProcessor&quot;
git commit -m &quot;Create ShippingCalculator hierarchy&quot;
</code></pre>
</li>
<li><p><strong>Test After Each Change</strong>: Run tests after each refactoring step</p>
<pre><code class="language-bash"># Run tests to ensure nothing is broken
dotnet test  # or equivalent for your language
</code></pre>
</li>
</ol>
<h4>Industry Best Practices</h4>
<ol>
<li><strong>Contract Definition</strong>: Clearly define preconditions, postconditions, and invariants for base classes</li>
<li><strong>Substitution Testing</strong>: Create tests that verify subclasses can substitute for base classes</li>
<li><strong>Behavioral Compatibility</strong>: Ensure subclasses maintain the same behavior as base classes</li>
<li><strong>Exception Handling</strong>: Subclasses should not throw exceptions that base classes don&#39;t throw</li>
<li><strong>Return Type Covariance</strong>: Use covariant return types where appropriate</li>
<li><strong>Composition Over Inheritance</strong>: Consider composition when inheritance violates LSP</li>
<li><strong>Documentation</strong>: Document the behavioral contracts that subclasses must honor</li>
<li><strong>Refactoring Safety</strong>: Use polymorphism safely without breaking existing functionality</li>
</ol>
<h3>Learning Objectives</h3>
<p>After completing both exercises, you should be able to:</p>
<ul>
<li>Design inheritance hierarchies that honor LSP</li>
<li>Ensure subclasses can substitute for base classes</li>
<li>Implement LSP while maintaining system functionality</li>
<li>Identify and fix LSP violations</li>
<li>Use composition when inheritance is problematic</li>
</ul>
<p><strong>Next</strong>: The <a href="../4-Interface-segregation-principle/README.md">Interface Segregation Principle</a> builds upon LSP by ensuring that clients only depend on the interfaces they actually use, creating more focused and maintainable designs.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","1-SOLID-Principles/3-Liskov-substitution-principle/README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"3-Liskov-substitution-principle\",\"README\"]}"},"styles":[]}],"segment":["slug","1-SOLID-Principles/3-Liskov-substitution-principle/README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
