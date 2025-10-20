1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","1-SOLID-Principles/1-Single-class-reponsibility-principle/README","c"],{"children":["__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"1-Single-class-reponsibility-principle\",\"README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T6424,<h1>Single Responsibility Principle (SRP)</h1>
<h2>Name</h2>
<p><strong>Single Responsibility Principle</strong> - The &quot;S&quot; in SOLID</p>
<h2>Goal of the Principle</h2>
<p>A class should have only one reason to change, meaning it should have only one job or responsibility. Each class should encapsulate a single concept or functionality, making the code more maintainable, testable, and understandable.</p>
<h2>Theoretical Foundation</h2>
<h3>Cognitive Load Theory</h3>
<p>The Single Responsibility Principle directly addresses cognitive load theory in software development. When a class has multiple responsibilities, developers must simultaneously track multiple concepts, increasing mental effort and error probability. By limiting each class to a single responsibility, we reduce the cognitive burden required to understand, modify, and debug code.</p>
<h3>Separation of Concerns</h3>
<p>SRP formalizes the fundamental software engineering principle of separation of concerns. This principle states that different aspects of functionality should be handled by different modules, reducing complexity and improving maintainability.</p>
<h3>Cohesion Theory</h3>
<p>SRP maximizes cohesion within a class while minimizing coupling between classes. High cohesion means that all elements within a class work together toward a single, well-defined purpose, making the class easier to understand and modify.</p>
<h3>Change Impact Analysis</h3>
<p>The principle is based on the observation that different responsibilities change for different reasons and at different rates. By separating these responsibilities, we minimize the ripple effects of changes throughout the system.</p>
<h2>Consequences of Violating SRP</h2>
<h3>Unique SRP-Specific Issues</h3>
<p><strong>Multiple Responsibility Coupling</strong></p>
<ul>
<li>Changes to one responsibility can inadvertently affect other responsibilities</li>
<li>Bug fixes in one area can break functionality in another</li>
<li>New features require understanding multiple unrelated concepts</li>
</ul>
<p><strong>Cognitive Load and Complexity</strong></p>
<ul>
<li>Developers must simultaneously track multiple concepts</li>
<li>Increased mental effort and error probability</li>
<li>Reduced code clarity and maintainability</li>
</ul>
<p><strong>Testing and Reusability Problems</strong></p>
<ul>
<li>Classes with multiple responsibilities require complex test scenarios</li>
<li>Cannot be reused in contexts where only one responsibility is needed</li>
<li>Forces developers to accept unnecessary dependencies or duplicate code</li>
</ul>
<h2>Impact on Static Code Analysis</h2>
<h3>SRP-Specific Metrics</h3>
<p><strong>Cyclomatic Complexity Reduction</strong></p>
<ul>
<li>Single-responsibility classes have simpler control flow</li>
<li>Fewer conditional branches and loops per class</li>
<li>Lower complexity scores in tools like SonarQube</li>
</ul>
<p><strong>Cohesion Metrics Enhancement</strong></p>
<ul>
<li>High cohesion within classes (all methods work toward single purpose)</li>
<li>Improved LCOM (Lack of Cohesion of Methods) scores</li>
<li>Better class design metrics in static analysis tools</li>
</ul>
<h3>SRP-Specific Tool Benefits</h3>
<p><strong>ESLint/TSLint (JavaScript/TypeScript)</strong></p>
<ul>
<li>Fewer &quot;max-lines-per-function&quot; violations</li>
<li>Better &quot;max-params&quot; compliance</li>
<li>Improved &quot;max-statements&quot; scores</li>
</ul>
<p><strong>Checkstyle (Java)</strong></p>
<ul>
<li>Better &quot;ParameterNumber&quot; scores</li>
<li>Improved &quot;MethodLength&quot; compliance</li>
</ul>
<p><strong>FxCop/StyleCop (.NET)</strong></p>
<ul>
<li>Better &quot;CA1500&quot; (Avoid excessive class coupling) compliance</li>
</ul>
<h3>SRP-Specific Detection</h3>
<p><strong>SRP Violation Detection</strong></p>
<ul>
<li>Tools can identify classes with multiple responsibilities</li>
<li>Detection of &quot;God Classes&quot; with too many methods</li>
<li>Identification of classes violating cohesion principles</li>
<li>Automated refactoring suggestions for SRP compliance</li>
</ul>
<h2>Role in Improving Software Quality</h2>
<p>The Single Responsibility Principle is the foundation of clean code architecture. It ensures that:</p>
<ul>
<li><strong>Maintainability</strong>: Changes to one responsibility don&#39;t affect others</li>
<li><strong>Testability</strong>: Each class can be tested in isolation</li>
<li><strong>Readability</strong>: Code is self-documenting with clear purposes</li>
<li><strong>Reusability</strong>: Single-purpose classes are easier to reuse</li>
<li><strong>Debugging</strong>: Issues are easier to locate and fix</li>
</ul>
<h2>How to Apply This Principle</h2>
<h3>1. Identify Responsibilities</h3>
<p><strong>What it means</strong>: Carefully analyze each class to understand all the different things it&#39;s doing. Look for methods that serve different purposes or handle different aspects of functionality.</p>
<p><strong>How to do it</strong>: </p>
<ul>
<li>List all the methods in your class</li>
<li>Group methods by their purpose or the type of data they work with</li>
<li>Ask yourself: &quot;What are all the different reasons this class might need to change?&quot;</li>
<li>Look for methods that operate on different types of data or serve different business purposes</li>
</ul>
<p><strong>Example from our code samples</strong>: In the violating <code>UserManager</code> class, we can identify four distinct responsibilities:</p>
<ul>
<li><strong>Data persistence</strong> (SaveUser method working with database connections)</li>
<li><strong>Communication</strong> (SendEmail method handling SMTP operations) </li>
<li><strong>Report generation</strong> (GenerateReport method creating files)</li>
<li><strong>Validation</strong> (ValidateUser method checking business rules)</li>
</ul>
<h3>2. Separate Concerns</h3>
<p><strong>What it means</strong>: Once you&#39;ve identified multiple responsibilities, create separate classes for each distinct responsibility. Each class should have a single, well-defined purpose.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Create a new class for each identified responsibility</li>
<li>Move related methods to their appropriate class</li>
<li>Ensure each class has a clear, single purpose</li>
<li>Give each class a descriptive name that reflects its single responsibility</li>
</ul>
<p><strong>Example from our code samples</strong>: The refactored solution separates the <code>UserManager</code> into:</p>
<ul>
<li><code>UserRepository</code> - handles only data persistence operations</li>
<li><code>EmailService</code> - handles only email communication</li>
<li><code>ReportGenerator</code> - handles only report creation</li>
<li><code>UserValidator</code> - handles only user validation logic</li>
</ul>
<h3>3. Use Composition</h3>
<p><strong>What it means</strong>: When you need functionality from multiple single-responsibility classes, combine them through composition rather than inheritance. This allows you to use multiple focused classes together while maintaining their individual responsibilities.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Create a coordinator class that uses multiple single-responsibility classes</li>
<li>Inject dependencies through constructor or method parameters</li>
<li>Delegate specific operations to the appropriate specialized class</li>
<li>Keep the coordinator focused on orchestrating the workflow, not implementing the details</li>
</ul>
<p><strong>Example from our code samples</strong>: The refactored <code>OrderProcessor</code> uses composition to coordinate multiple services:</p>
<ul>
<li>It depends on <code>OrderRepository</code>, <code>PriceCalculator</code>, <code>EmailService</code>, <code>InventoryService</code>, and <code>InvoiceGenerator</code></li>
<li>Each dependency handles one specific aspect of order processing</li>
<li>The <code>OrderProcessor</code> orchestrates the workflow without implementing any of the details</li>
</ul>
<h3>4. Apply the &quot;One Reason to Change&quot; Rule</h3>
<p><strong>What it means</strong>: This is the litmus test for SRP compliance. If you can identify multiple, unrelated reasons why a class might need to be modified, it violates the Single Responsibility Principle.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>For each class, ask: &quot;What are all the possible reasons this class might need to change?&quot;</li>
<li>If you can identify more than one reason, the class likely has multiple responsibilities</li>
<li>Each reason to change should be related to a single, cohesive responsibility</li>
<li>If reasons are unrelated (e.g., &quot;database schema changes&quot; and &quot;email template updates&quot;), split the class</li>
</ul>
<p><strong>Example from our code samples</strong>: The violating <code>UserManager</code> class has multiple reasons to change:</p>
<ul>
<li>Database schema changes (affects SaveUser)</li>
<li>Email service provider changes (affects SendEmail)</li>
<li>Report format changes (affects GenerateReport)</li>
<li>Validation rule changes (affects ValidateUser)</li>
</ul>
<p>The refactored solution ensures each class has only one reason to change:</p>
<ul>
<li><code>UserRepository</code> changes only when data persistence needs change</li>
<li><code>EmailService</code> changes only when email communication needs change</li>
<li><code>ReportGenerator</code> changes only when report generation needs change</li>
<li><code>UserValidator</code> changes only when validation rules change</li>
</ul>
<h2>Examples of Violations and Refactoring</h2>
<h3>C# Example</h3>
<p><strong>Violating SRP:</strong></p>
<pre><code class="language-csharp">public class UserManager
{
    public void SaveUser(User user)
    {
        // Database operations
        using (var connection = new SqlConnection(connectionString))
        {
            connection.Open();
            var command = new SqlCommand(&quot;INSERT INTO Users...&quot;, connection);
            command.ExecuteNonQuery();
        }
    }

    public void SendEmail(User user, string message)
    {
        // Email sending logic
        var smtpClient = new SmtpClient(&quot;smtp.gmail.com&quot;, 587);
        smtpClient.Send(&quot;noreply@company.com&quot;, user.Email, &quot;Notification&quot;, message);
    }

    public void GenerateReport(User user)
    {
        // Report generation
        var report = $&quot;User Report for {user.Name}&quot;;
        File.WriteAllText($&quot;report_{user.Id}.txt&quot;, report);
    }

    public bool ValidateUser(User user)
    {
        // Validation logic
        return !string.IsNullOrEmpty(user.Email) &amp;&amp; user.Email.Contains(&quot;@&quot;);
    }
}
</code></pre>
<p><strong>Refactored - Applying SRP:</strong></p>
<pre><code class="language-csharp">// Single responsibility: User data model
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
            var command = new SqlCommand(&quot;INSERT INTO Users...&quot;, connection);
            command.ExecuteNonQuery();
        }
    }
}

// Single responsibility: Email communication
public class EmailService
{
    public void SendEmail(User user, string message)
    {
        var smtpClient = new SmtpClient(&quot;smtp.gmail.com&quot;, 587);
        smtpClient.Send(&quot;noreply@company.com&quot;, user.Email, &quot;Notification&quot;, message);
    }
}

// Single responsibility: Report generation
public class ReportGenerator
{
    public void GenerateReport(User user)
    {
        var report = $&quot;User Report for {user.Name}&quot;;
        File.WriteAllText($&quot;report_{user.Id}.txt&quot;, report);
    }
}

// Single responsibility: User validation
public class UserValidator
{
    public bool ValidateUser(User user)
    {
        return !string.IsNullOrEmpty(user.Email) &amp;&amp; user.Email.Contains(&quot;@&quot;);
    }
}
</code></pre>
<h3>Java Example</h3>
<p><strong>Violating SRP:</strong></p>
<pre><code class="language-java">public class OrderProcessor {
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
</code></pre>
<p><strong>Refactored - Applying SRP:</strong></p>
<pre><code class="language-java">// Single responsibility: Order data
public class Order {
    private String id;
    private List&lt;OrderItem&gt; items;
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
            .mapToDouble(item -&gt; item.getPrice() * item.getQuantity())
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
</code></pre>
<h3>TypeScript Example</h3>
<p><strong>Violating SRP:</strong></p>
<pre><code class="language-typescript">class UserService {
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
        return user.email.includes(&#39;@&#39;) &amp;&amp; user.name.length &gt; 0;
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
</code></pre>
<p><strong>Refactored - Applying SRP:</strong></p>
<pre><code class="language-typescript">interface User {
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
        return user.email.includes(&#39;@&#39;) &amp;&amp; user.name.length &gt; 0;
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
            this.activityLogger.logUserActivity(user, &#39;Account created&#39;);
        }
    }
}
</code></pre>
<h2>How This Principle Helps with Code Quality</h2>
<ol>
<li><strong>Reduced Complexity</strong>: Each class has a single, clear purpose</li>
<li><strong>Better Organization</strong>: Related functionality is grouped together</li>
<li><strong>Easier Maintenance</strong>: Changes are localized to specific classes</li>
<li><strong>Improved Readability</strong>: Code is self-documenting</li>
<li><strong>Reduced Coupling</strong>: Classes are less dependent on each other</li>
</ol>
<h2>How This Principle Helps with Automated Testing</h2>
<ol>
<li><strong>Unit Testing</strong>: Each class can be tested in isolation</li>
<li><strong>Mocking</strong>: Dependencies can be easily mocked for testing</li>
<li><strong>Test Coverage</strong>: Easier to achieve comprehensive test coverage</li>
<li><strong>Test Maintenance</strong>: Tests are simpler and more focused</li>
<li><strong>Parallel Testing</strong>: Tests can run independently</li>
</ol>
<pre><code class="language-csharp">// Example of focused unit testing with SRP
[Test]
public void UserValidator_ValidUser_ReturnsTrue()
{
    // Arrange
    var validator = new UserValidator();
    var user = new User { Email = &quot;test@example.com&quot;, Name = &quot;John Doe&quot; };
    
    // Act
    var result = validator.ValidateUser(user);
    
    // Assert
    Assert.IsTrue(result);
}

[Test]
public void EmailService_SendEmail_CallsSmtpClient()
{
    // Arrange
    var mockSmtpClient = new Mock&lt;ISmtpClient&gt;();
    var emailService = new EmailService(mockSmtpClient.Object);
    var user = new User { Email = &quot;test@example.com&quot; };
    
    // Act
    emailService.SendEmail(user, &quot;Test message&quot;);
    
    // Assert
    mockSmtpClient.Verify(x =&gt; x.Send(It.IsAny&lt;string&gt;(), user.Email, It.IsAny&lt;string&gt;(), It.IsAny&lt;string&gt;()), Times.Once);
}
</code></pre>
<h2>Summary</h2>
<p>The Single Responsibility Principle is the cornerstone of clean architecture. By ensuring each class has only one reason to change, we create code that is:</p>
<ul>
<li><strong>Maintainable</strong>: Easy to modify without side effects</li>
<li><strong>Testable</strong>: Simple to unit test in isolation</li>
<li><strong>Reusable</strong>: Single-purpose classes are more reusable</li>
<li><strong>Understandable</strong>: Clear, focused responsibilities</li>
</ul>
<p>This principle sets the foundation for the other SOLID principles. When classes have single responsibilities, they naturally become more extensible (Open/Closed Principle), substitutable (Liskov Substitution Principle), and focused (Interface Segregation Principle). The Single Responsibility Principle also makes it easier to apply dependency inversion, as smaller, focused classes have clearer dependencies.</p>
<h2>Exercise 1: Design - Single Responsibility Principle</h2>
<h3>Objective</h3>
<p>Design a solution that separates the multiple responsibilities in the <code>EcommerceManager</code> class into focused, single-responsibility classes.</p>
<h3>Task</h3>
<p>Analyze the <code>EcommerceManager</code> class in the <code>ecom-exercises</code> folder and create a design that follows the Single Responsibility Principle.</p>
<ol>
<li><strong>Identify Responsibilities</strong>: Examine the <code>EcommerceManager</code> class and list all the different responsibilities it handles</li>
<li><strong>Design Classes</strong>: Create a class diagram or design document showing how you would separate these responsibilities into focused classes</li>
<li><strong>Define Interfaces</strong>: Design interfaces that define the contracts for each responsibility</li>
<li><strong>Plan Dependencies</strong>: Determine how the separated classes will interact and depend on each other</li>
</ol>
<h3>Deliverables</h3>
<ul>
<li>List of all responsibilities identified in <code>EcommerceManager</code></li>
<li>Class diagram showing the separated responsibilities</li>
<li>Interface definitions for each responsibility</li>
<li>Dependency relationship diagram</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Navigate to the <code>ecom-exercises</code> folder</li>
<li>Choose your preferred language (C#, Java, Python, or TypeScript)</li>
<li>Examine the <code>EcommerceManager</code> class to understand its current responsibilities</li>
<li>Create your design without modifying any code</li>
</ol>
<hr>
<h2>Exercise 2: Implementation - Single Responsibility Principle</h2>
<h3>Objective</h3>
<p>Implement your design from Exercise 1, ensuring that all existing unit tests continue to pass.</p>
<h3>Task</h3>
<p>Refactor the <code>EcommerceManager</code> class according to your design while maintaining system functionality.</p>
<ol>
<li><strong>Create Classes</strong>: Implement the focused, single-responsibility classes from your design</li>
<li><strong>Implement Interfaces</strong>: Create the interfaces and their implementations</li>
<li><strong>Refactor EcommerceManager</strong>: Modify the <code>EcommerceManager</code> to use the new separated classes</li>
<li><strong>Maintain Functionality</strong>: Ensure all existing unit tests pass</li>
<li><strong>Verify Behavior</strong>: Run the application to confirm it works as expected</li>
</ol>
<h3>Success Criteria</h3>
<ul>
<li>All existing unit tests pass</li>
<li>The application runs without errors</li>
<li>Each class has a single, well-defined responsibility</li>
<li>The system maintains the same external behavior</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Use your design from Exercise 1 as a guide</li>
<li>Start implementing the classes one by one</li>
<li>Run tests frequently to ensure you don&#39;t break existing functionality</li>
<li>Refactor incrementally rather than all at once</li>
</ol>
<h3>Implementation Best Practices</h3>
<h4>Git Workflow</h4>
<ol>
<li><p><strong>Create a Feature Branch</strong>: Start from main and create a new branch for your SRP refactoring</p>
<pre><code class="language-bash">git checkout main
git pull origin main
git checkout -b feature/srp-refactoring
</code></pre>
</li>
<li><p><strong>Commit Frequently</strong>: Make small, focused commits as you refactor</p>
<pre><code class="language-bash">git add .
git commit -m &quot;Extract ProductService from EcommerceManager&quot;
git commit -m &quot;Extract CartService from EcommerceManager&quot;
git commit -m &quot;Extract OrderService from EcommerceManager&quot;
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
<li><strong>Incremental Refactoring</strong>: Refactor one responsibility at a time rather than all at once</li>
<li><strong>Test-Driven Refactoring</strong>: Ensure all existing tests pass before and after each change</li>
<li><strong>Single Responsibility Validation</strong>: Ask &quot;Does this class have only one reason to change?&quot;</li>
<li><strong>Dependency Analysis</strong>: Identify and minimize dependencies between separated classes</li>
<li><strong>Interface Design</strong>: Create clear interfaces for each responsibility</li>
<li><strong>Documentation</strong>: Update class documentation to reflect new responsibilities</li>
<li><strong>Code Review</strong>: Have someone review your refactored code for clarity and correctness</li>
</ol>
<h3>Learning Objectives</h3>
<p>After completing both exercises, you should be able to:</p>
<ul>
<li>Identify multiple responsibilities in a single class</li>
<li>Design focused, single-responsibility classes</li>
<li>Implement SRP while maintaining system functionality</li>
<li>Understand the benefits of SRP in practice</li>
</ul>
<p><strong>Next</strong>: The <a href="../2-Open-closed-principle/README.md">Open/Closed Principle</a> builds upon SRP by ensuring that our single-responsibility classes can be extended without modification, enabling flexible and maintainable software evolution.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","1-SOLID-Principles/1-Single-class-reponsibility-principle/README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"1-Single-class-reponsibility-principle\",\"README\"]}"},"styles":[]}],"segment":["slug","1-SOLID-Principles/1-Single-class-reponsibility-principle/README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
