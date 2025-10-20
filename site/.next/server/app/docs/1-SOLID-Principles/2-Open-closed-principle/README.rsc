1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","1-SOLID-Principles/2-Open-closed-principle/README","c"],{"children":["__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"2-Open-closed-principle\",\"README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T6983,<h1>Open/Closed Principle (OCP)</h1>
<h2>Name</h2>
<p><strong>Open/Closed Principle</strong> - The &quot;O&quot; in SOLID</p>
<h2>Goal of the Principle</h2>
<p>Software entities (classes, modules, functions, etc.) should be open for extension but closed for modification. This means you should be able to add new functionality without changing existing code, promoting stability and reducing the risk of introducing bugs.</p>
<h2>Theoretical Foundation</h2>
<h3>Bertrand Meyer&#39;s Original Formulation</h3>
<p>The Open/Closed Principle was first articulated by Bertrand Meyer in 1988 as part of his work on object-oriented design. Meyer recognized that software systems need to evolve continuously, but modification of existing, tested code introduces significant risk of regression bugs.</p>
<h3>Information Hiding and Encapsulation</h3>
<p>OCP relies on proper encapsulation to hide implementation details behind stable interfaces. This allows internal implementation to change without affecting clients, while new functionality can be added through extension points.</p>
<h3>Polymorphism and Late Binding</h3>
<p>The principle leverages polymorphism to enable runtime behavior changes without compile-time modifications. This allows systems to be configured and extended dynamically based on runtime conditions.</p>
<h3>Design Patterns Foundation</h3>
<p>OCP is the theoretical foundation for many design patterns including:</p>
<ul>
<li>Strategy Pattern: Encapsulating algorithms</li>
<li>Template Method: Defining algorithm structure</li>
<li>Decorator: Adding behavior dynamically</li>
<li>Factory Method: Creating objects without specifying exact classes</li>
</ul>
<h3>Risk Mitigation Theory</h3>
<p>The principle is based on the observation that modifying existing code carries inherent risk. By designing systems that can be extended without modification, we minimize the probability of introducing bugs in previously working functionality.</p>
<h2>Consequences of Violating OCP</h2>
<h3>Unique OCP-Specific Issues</h3>
<p><strong>Modification Risk and Regression</strong></p>
<ul>
<li>Every modification to existing code carries the risk of breaking previously working functionality</li>
<li>Creates a vicious cycle where new features require changes to existing code</li>
<li>Changes introduce bugs in existing functionality, requiring more changes</li>
</ul>
<p><strong>Testing Overhead and Complexity</strong></p>
<ul>
<li>All existing tests must be re-run to ensure no regressions</li>
<li>New tests must be written for modified functionality</li>
<li>Integration testing becomes more complex</li>
<li>Test maintenance overhead increases exponentially</li>
</ul>
<p><strong>Technical Debt Accumulation</strong></p>
<ul>
<li>Leads to increasingly complex conditional logic (if/switch statements)</li>
<li>Creates tight coupling between modules</li>
<li>Results in difficult-to-understand code paths</li>
<li>Reduces confidence in making changes</li>
</ul>
<h2>Impact on Static Code Analysis</h2>
<h3>OCP-Specific Metrics</h3>
<p><strong>Stability Metrics Enhancement</strong></p>
<ul>
<li>Existing code remains unchanged, improving stability scores</li>
<li>Reduced volatility in maintainability index calculations</li>
<li>Lower risk scores in static analysis tools</li>
</ul>
<p><strong>Extension Point Detection</strong></p>
<ul>
<li>Tools can identify well-designed extension points</li>
<li>Detection of proper abstraction usage</li>
<li>Recognition of polymorphic designs</li>
</ul>
<h3>OCP-Specific Tool Benefits</h3>
<p><strong>ESLint/TSLint (JavaScript/TypeScript)</strong></p>
<ul>
<li>Better &quot;max-depth&quot; compliance</li>
<li>Reduced &quot;no-case-declarations&quot; violations</li>
</ul>
<p><strong>Checkstyle (Java)</strong></p>
<ul>
<li>Reduced &quot;SwitchStatement&quot; violations</li>
<li>Better &quot;CyclomaticComplexity&quot; compliance</li>
</ul>
<p><strong>FxCop/StyleCop (.NET)</strong></p>
<ul>
<li>Fewer &quot;CA1502&quot; (Avoid excessive complexity) violations</li>
</ul>
<h3>OCP-Specific Detection</h3>
<p><strong>OCP Violation Detection</strong></p>
<ul>
<li>Detection of switch statements that could be replaced with polymorphism</li>
<li>Identification of classes that need modification for new features</li>
<li>Recognition of tight coupling that prevents extension</li>
</ul>
<p><strong>Extension Point Analysis</strong></p>
<ul>
<li>Detection of well-designed interfaces and abstract classes</li>
<li>Recognition of proper inheritance hierarchies</li>
<li>Identification of extensible design patterns</li>
</ul>
<h2>Role in Improving Software Quality</h2>
<p>The Open/Closed Principle is essential for creating maintainable and scalable software systems. It ensures that:</p>
<ul>
<li><strong>Stability</strong>: Existing code remains unchanged, reducing regression risks</li>
<li><strong>Extensibility</strong>: New features can be added without modifying existing code</li>
<li><strong>Maintainability</strong>: Changes are isolated to new code, making maintenance easier</li>
<li><strong>Testability</strong>: Existing functionality continues to work as expected</li>
<li><strong>Flexibility</strong>: System can evolve to meet new requirements</li>
</ul>
<h2>How to Apply This Principle</h2>
<h3>1. Use Abstraction</h3>
<p><strong>What it means</strong>: Create interfaces or abstract classes that define stable contracts for behavior. These abstractions serve as extension points that can be implemented in different ways without modifying existing code.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify areas where you have hard-coded business logic or conditional statements</li>
<li>Create abstract base classes or interfaces that define the contract for that behavior</li>
<li>Design abstractions to be stable and unlikely to change frequently</li>
<li>Ensure abstractions capture the essential behavior without implementation details</li>
</ul>
<p><strong>Example from our code samples</strong>: In the violating <code>DiscountCalculator</code>, we have hard-coded customer type logic. The refactored solution creates a <code>DiscountStrategy</code> abstract base class that defines the contract for discount calculation. This abstraction is stable and can be extended with new discount types without modifying existing code.</p>
<h3>2. Implement Polymorphism</h3>
<p><strong>What it means</strong>: Use inheritance or composition to create different implementations of your abstractions. This allows the same interface to behave differently based on the specific implementation being used.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Create concrete classes that implement your abstractions</li>
<li>Each concrete class should represent a specific variation of the behavior</li>
<li>Use polymorphism to call methods on the abstraction rather than concrete types</li>
<li>Ensure all implementations honor the contract defined by the abstraction</li>
</ul>
<p><strong>Example from our code samples</strong>: The refactored solution creates specific discount implementations (<code>RegularCustomerDiscount</code>, <code>PremiumCustomerDiscount</code>, <code>VIPCustomerDiscount</code>) that all implement the <code>DiscountStrategy</code> abstraction. The <code>DiscountCalculator</code> uses polymorphism to call <code>CalculateDiscount</code> on whatever strategy is provided, without knowing the specific implementation.</p>
<h3>3. Apply Strategy Pattern</h3>
<p><strong>What it means</strong>: Encapsulate different algorithms or behaviors in separate classes that implement a common interface. This allows you to switch between different approaches at runtime without changing the code that uses them.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify algorithms or behaviors that vary based on context</li>
<li>Create a strategy interface that defines the common contract</li>
<li>Implement each variation as a separate strategy class</li>
<li>Use composition to inject the appropriate strategy into the context</li>
</ul>
<p><strong>Example from our code samples</strong>: The discount calculation is implemented using the Strategy pattern. Each customer type has its own discount strategy class, and the <code>Customer</code> object holds a reference to its specific strategy. This allows the same <code>DiscountCalculator</code> to work with any discount strategy without modification.</p>
<h3>4. Use Dependency Injection</h3>
<p><strong>What it means</strong>: Instead of creating concrete objects directly, inject them as dependencies. This allows you to provide different implementations without changing the consuming code.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Define dependencies as abstractions (interfaces or abstract classes)</li>
<li>Inject dependencies through constructors, setters, or method parameters</li>
<li>Use dependency injection containers to manage object creation and wiring</li>
<li>Configure different implementations for different environments or use cases</li>
</ul>
<p><strong>Example from our code samples</strong>: The <code>Customer</code> class receives its <code>DiscountStrategy</code> as a dependency rather than determining it internally. This allows the same customer to use different discount strategies without changing the customer class or the discount calculator.</p>
<h3>5. Design for Extension</h3>
<p><strong>What it means</strong>: Plan your interfaces and abstractions to accommodate future requirements. Design extension points that can handle new functionality without breaking existing implementations.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Design interfaces with future extensibility in mind</li>
<li>Avoid making abstractions too specific to current requirements</li>
<li>Consider what types of extensions might be needed in the future</li>
<li>Use generic or parameterized types where appropriate</li>
</ul>
<p><strong>Example from our code samples</strong>: The <code>DiscountStrategy</code> abstraction is designed to be easily extensible. When a new <code>CorporateCustomerDiscount</code> is needed, it can be added without modifying any existing code. The abstraction is generic enough to handle any type of discount calculation while being specific enough to provide a clear contract.</p>
<h2>Examples of Violations and Refactoring</h2>
<h3>C# Example</h3>
<p><strong>Violating OCP:</strong></p>
<pre><code class="language-csharp">public class DiscountCalculator
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
</code></pre>
<p><strong>Refactored - Applying OCP:</strong></p>
<pre><code class="language-csharp">// Abstract base class - closed for modification
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
</code></pre>
<h3>Java Example</h3>
<p><strong>Violating OCP:</strong></p>
<pre><code class="language-java">public class ShapeCalculator {
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
        throw new IllegalArgumentException(&quot;Unknown shape type&quot;);
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
</code></pre>
<p><strong>Refactored - Applying OCP:</strong></p>
<pre><code class="language-java">// Abstract interface - closed for modification
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
    public double calculateTotalArea(List&lt;Shape&gt; shapes) {
        return shapes.stream()
            .mapToDouble(Shape::calculateArea)
            .sum();
    }
}
</code></pre>
<h3>TypeScript Example</h3>
<p><strong>Violating OCP:</strong></p>
<pre><code class="language-typescript">class PaymentProcessor {
    processPayment(amount: number, paymentType: string): boolean {
        switch (paymentType) {
            case &#39;credit&#39;:
                return this.processCreditCard(amount);
            case &#39;paypal&#39;:
                return this.processPayPal(amount);
            case &#39;bank&#39;:
                return this.processBankTransfer(amount);
            default:
                throw new Error(&#39;Unsupported payment type&#39;);
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
</code></pre>
<p><strong>Refactored - Applying OCP:</strong></p>
<pre><code class="language-typescript">// Abstract interface - closed for modification
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
</code></pre>
<h2>How This Principle Helps with Code Quality</h2>
<ol>
<li><strong>Reduced Risk</strong>: Existing code remains unchanged, preventing regressions</li>
<li><strong>Better Organization</strong>: New functionality is isolated in separate classes</li>
<li><strong>Improved Maintainability</strong>: Changes don&#39;t cascade through the system</li>
<li><strong>Enhanced Readability</strong>: Code structure is clearer and more logical</li>
<li><strong>Increased Stability</strong>: Core functionality remains stable while extending capabilities</li>
</ol>
<h2>How This Principle Helps with Automated Testing</h2>
<ol>
<li><strong>Stable Tests</strong>: Existing tests continue to pass when adding new features</li>
<li><strong>Isolated Testing</strong>: New functionality can be tested independently</li>
<li><strong>Mock-Friendly</strong>: Abstract interfaces make mocking easier</li>
<li><strong>Regression Prevention</strong>: Existing functionality is protected from changes</li>
<li><strong>Comprehensive Coverage</strong>: Each extension can have its own test suite</li>
</ol>
<pre><code class="language-csharp">// Example of testing with OCP
[Test]
public void DiscountCalculator_RegularCustomer_ReturnsCorrectDiscount()
{
    // Arrange
    var customer = new Customer 
    { 
        Name = &quot;John&quot;, 
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
        Name = &quot;Corp&quot;, 
        DiscountStrategy = new CorporateCustomerDiscount() 
    };
    var calculator = new DiscountCalculator();
    
    // Act
    var discount = calculator.CalculateDiscount(customer, 100);
    
    // Assert
    Assert.AreEqual(20, discount);
}
</code></pre>
<h2>Summary</h2>
<p>The Open/Closed Principle is crucial for creating flexible and maintainable software systems. By designing classes that are open for extension but closed for modification, we achieve:</p>
<ul>
<li><strong>Stability</strong>: Existing code remains unchanged and stable</li>
<li><strong>Extensibility</strong>: New features can be added without risk</li>
<li><strong>Maintainability</strong>: Changes are isolated and don&#39;t affect existing functionality</li>
<li><strong>Scalability</strong>: System can grow to meet new requirements</li>
</ul>
<p>This principle works hand-in-hand with the Single Responsibility Principle. When classes have single responsibilities, they naturally become easier to extend without modification. The Open/Closed Principle also sets the foundation for the Liskov Substitution Principle, as the abstractions we create for extension must be substitutable.</p>
<h2>Exercise 1: Design - Open/Closed Principle</h2>
<h3>Objective</h3>
<p>Design a solution that makes the e-commerce system extensible without modification, following the Open/Closed Principle.</p>
<h3>Task</h3>
<p>Analyze the hard-coded business rules in the e-commerce system and design an extensible architecture.</p>
<ol>
<li><strong>Identify Hard-coded Rules</strong>: Examine the code and find all hard-coded business logic (tax rates, shipping calculations, payment methods, discount codes, etc.)</li>
<li><strong>Design Abstractions</strong>: Create abstract base classes or interfaces that define contracts for extensible behavior</li>
<li><strong>Plan Strategy Pattern</strong>: Design how different implementations can be plugged in without modifying existing code</li>
<li><strong>Design Configuration</strong>: Plan how new business rules can be added through configuration rather than code changes</li>
</ol>
<h3>Deliverables</h3>
<ul>
<li>List of all hard-coded business rules identified</li>
<li>Abstract base classes or interfaces for extensible behavior</li>
<li>Strategy pattern implementation plan</li>
<li>Configuration design for new business rules</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Navigate to the <code>ecom-exercises</code> folder</li>
<li>Choose your preferred language (C#, Java, Python, or TypeScript)</li>
<li>Examine the code for hard-coded values and business logic</li>
<li>Create your design without modifying any code</li>
</ol>
<hr>
<h2>Exercise 2: Implementation - Open/Closed Principle</h2>
<h3>Objective</h3>
<p>Implement your design from Exercise 1, ensuring that all existing unit tests continue to pass and the system can be extended without modification.</p>
<h3>Task</h3>
<p>Refactor the hard-coded business rules according to your design while maintaining system functionality.</p>
<ol>
<li><strong>Create Abstractions</strong>: Implement the abstract base classes or interfaces from your design</li>
<li><strong>Implement Strategies</strong>: Create concrete implementations for existing business rules</li>
<li><strong>Refactor Hard-coded Logic</strong>: Replace hard-coded values with strategy implementations</li>
<li><strong>Add Configuration</strong>: Implement configuration system for new business rules</li>
<li><strong>Maintain Functionality</strong>: Ensure all existing unit tests pass</li>
<li><strong>Demonstrate Extensibility</strong>: Add a new business rule without modifying existing code</li>
</ol>
<h3>Success Criteria</h3>
<ul>
<li>All existing unit tests pass</li>
<li>The application runs without errors</li>
<li>New business rules can be added without modifying existing code</li>
<li>The system maintains the same external behavior</li>
<li>Extensibility is demonstrated with a new implementation</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Use your design from Exercise 1 as a guide</li>
<li>Start by creating the abstractions</li>
<li>Implement existing business rules as concrete strategies</li>
<li>Run tests frequently to ensure you don&#39;t break existing functionality</li>
<li>Add a new business rule to demonstrate extensibility</li>
</ol>
<h3>Implementation Best Practices</h3>
<h4>Git Workflow</h4>
<ol>
<li><p><strong>Create a Feature Branch</strong>: Start from main and create a new branch for your OCP refactoring</p>
<pre><code class="language-bash">git checkout main
git pull origin main
git checkout -b feature/ocp-refactoring
</code></pre>
</li>
<li><p><strong>Commit Frequently</strong>: Make small, focused commits as you refactor</p>
<pre><code class="language-bash">git add .
git commit -m &quot;Create TaxCalculator abstraction&quot;
git commit -m &quot;Implement StandardTaxCalculator&quot;
git commit -m &quot;Create ShippingCalculator abstraction&quot;
git commit -m &quot;Implement FixedShippingCalculator&quot;
git commit -m &quot;Add new ExpressShippingCalculator without modifying existing code&quot;
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
<li><strong>Strategy Pattern Implementation</strong>: Use the Strategy pattern to encapsulate different algorithms</li>
<li><strong>Configuration-Driven Extensions</strong>: Make new business rules configurable rather than hard-coded</li>
<li><strong>Interface Segregation</strong>: Create focused interfaces for each type of business rule</li>
<li><strong>Factory Pattern</strong>: Use factories to create appropriate strategy implementations</li>
<li><strong>Validation</strong>: Ensure new implementations don&#39;t break existing functionality</li>
<li><strong>Documentation</strong>: Document how to add new business rules without modifying existing code</li>
<li><strong>Backward Compatibility</strong>: Ensure existing behavior remains unchanged</li>
<li><strong>Performance Considerations</strong>: Consider the performance impact of strategy selection</li>
</ol>
<h3>Learning Objectives</h3>
<p>After completing both exercises, you should be able to:</p>
<ul>
<li>Identify hard-coded business rules that violate OCP</li>
<li>Design extensible systems using abstractions</li>
<li>Apply the Strategy pattern effectively</li>
<li>Implement OCP while maintaining system functionality</li>
<li>Create systems that can be extended without modification</li>
</ul>
<p><strong>Next</strong>: The <a href="../3-Liskov-substitution-principle/README.md">Liskov Substitution Principle</a> builds upon OCP by ensuring that our extensible classes can be substituted for their base classes without breaking the system&#39;s correctness.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","1-SOLID-Principles/2-Open-closed-principle/README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"2-Open-closed-principle\",\"README\"]}"},"styles":[]}],"segment":["slug","1-SOLID-Principles/2-Open-closed-principle/README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
