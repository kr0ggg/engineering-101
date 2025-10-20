1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","1-SOLID-Principles/5-Dependency-segregation-principle/README","c"],{"children":["__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"5-Dependency-segregation-principle\",\"README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T79af,<h1>Dependency Inversion Principle (DIP)</h1>
<h2>Name</h2>
<p><strong>Dependency Inversion Principle</strong> - The &quot;D&quot; in SOLID</p>
<h2>Goal of the Principle</h2>
<p>High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend on details. Details should depend on abstractions. This principle inverts the traditional dependency hierarchy, making systems more flexible and maintainable.</p>
<h2>Theoretical Foundation</h2>
<h3>Dependency Inversion Theory</h3>
<p>The Dependency Inversion Principle inverts the traditional dependency hierarchy in software systems. Instead of high-level modules depending on low-level modules, both depend on abstractions. This creates a more flexible and maintainable architecture.</p>
<h3>Abstraction and Encapsulation</h3>
<p>DIP relies on proper abstraction to hide implementation details behind stable interfaces. This allows:</p>
<ul>
<li>High-level modules to focus on business logic without implementation concerns</li>
<li>Low-level modules to be swapped without affecting high-level modules</li>
<li>System evolution through interface evolution rather than implementation changes</li>
</ul>
<h3>Inversion of Control (IoC)</h3>
<p>DIP is closely related to the Inversion of Control pattern, where:</p>
<ul>
<li>Control of object creation is inverted from the objects themselves to external containers</li>
<li>Dependencies are injected rather than created internally</li>
<li>System configuration is externalized and configurable</li>
</ul>
<h3>Dependency Injection Theory</h3>
<p>The principle formalizes dependency injection as a design pattern:</p>
<ul>
<li><strong>Constructor Injection</strong>: Dependencies provided through constructors</li>
<li><strong>Setter Injection</strong>: Dependencies provided through setter methods</li>
<li><strong>Interface Injection</strong>: Dependencies provided through interface methods</li>
<li><strong>Service Locator</strong>: Dependencies retrieved from a service registry</li>
</ul>
<h3>Layered Architecture Principles</h3>
<p>DIP supports proper layered architecture by ensuring:</p>
<ul>
<li>Business logic layers don&#39;t depend on data access layers</li>
<li>Presentation layers don&#39;t depend on business logic implementation details</li>
<li>Each layer depends only on abstractions from lower layers</li>
</ul>
<h2>Consequences of Violating DIP</h2>
<h3>Unique DIP-Specific Issues</h3>
<p><strong>Rigid Architecture</strong></p>
<ul>
<li>High-level modules depend directly on low-level modules</li>
<li>Changes to low-level modules cascade to high-level modules</li>
<li>System becomes tightly coupled and difficult to modify</li>
<li>Adding new features requires changes throughout the system</li>
</ul>
<p><strong>Testing Difficulties</strong></p>
<ul>
<li>High-level modules cannot be tested in isolation</li>
<li>Mocking dependencies becomes impossible or complex</li>
<li>Integration tests become the only viable testing approach</li>
<li>Test setup becomes complex and fragile</li>
</ul>
<p><strong>Flexibility and Reusability Problems</strong></p>
<ul>
<li>Cannot easily swap implementations (e.g., different databases)</li>
<li>Configuration changes require code modifications</li>
<li>Deployment becomes complex due to hard dependencies</li>
<li>Components can&#39;t be easily reused in different contexts</li>
</ul>
<h2>Impact on Static Code Analysis</h2>
<h3>DIP-Specific Metrics</h3>
<p><strong>Architecture Stability Enhancement</strong></p>
<ul>
<li>Proper dependency inversion improves architectural stability scores</li>
<li>Reduced coupling metrics through abstraction usage</li>
<li>Better separation of concerns detection in static analysis tools</li>
</ul>
<p><strong>Dependency Analysis Enhancement</strong></p>
<ul>
<li>Tools can identify proper dependency injection patterns</li>
<li>Detection of abstraction usage vs. concrete dependencies</li>
<li>Recognition of proper layered architecture</li>
</ul>
<h3>DIP-Specific Tool Benefits</h3>
<p><strong>ESLint/TSLint (JavaScript/TypeScript)</strong></p>
<ul>
<li>Better &quot;no-unused-vars&quot; compliance in dependency injection</li>
<li>Better &quot;max-params&quot; in dependency injection constructors</li>
</ul>
<p><strong>Checkstyle (Java)</strong></p>
<ul>
<li>Better &quot;VisibilityModifier&quot; compliance in dependency injection</li>
<li>Improved &quot;MethodLength&quot; in dependency injection methods</li>
</ul>
<p><strong>FxCop/StyleCop (.NET)</strong></p>
<ul>
<li>Better &quot;CA1500&quot; (Avoid excessive class coupling) compliance</li>
</ul>
<h3>DIP-Specific Detection</h3>
<p><strong>DIP Violation Detection</strong></p>
<ul>
<li>Detection of high-level modules depending on low-level modules</li>
<li>Identification of concrete dependencies instead of abstractions</li>
<li>Recognition of tight coupling patterns</li>
<li>Detection of missing dependency injection</li>
</ul>
<p><strong>Architecture Analysis</strong></p>
<ul>
<li>Analysis of dependency direction and flow</li>
<li>Detection of proper layered architecture</li>
<li>Recognition of abstraction usage patterns</li>
</ul>
<h2>Role in Improving Software Quality</h2>
<p>The Dependency Inversion Principle is the capstone of the SOLID principles, creating loosely coupled and highly cohesive systems. It ensures that:</p>
<ul>
<li><strong>Loose Coupling</strong>: High-level modules are independent of low-level implementation details</li>
<li><strong>Flexibility</strong>: Dependencies can be easily swapped or modified</li>
<li><strong>Testability</strong>: Dependencies can be easily mocked for testing</li>
<li><strong>Maintainability</strong>: Changes to low-level modules don&#39;t affect high-level modules</li>
<li><strong>Extensibility</strong>: New implementations can be added without modifying existing code</li>
</ul>
<h2>How to Apply This Principle</h2>
<h3>1. Define Abstractions</h3>
<p><strong>What it means</strong>: Create interfaces or abstract classes that represent the contracts for external dependencies. These abstractions should define what functionality is needed without specifying how it&#39;s implemented.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify all external dependencies in your high-level modules (databases, email services, file systems, etc.)</li>
<li>Create interfaces that define the contracts for these dependencies</li>
<li>Design abstractions to be stable and unlikely to change frequently</li>
<li>Focus on the essential behavior rather than implementation details</li>
</ul>
<p><strong>Example from our code samples</strong>: In the violating <code>OrderService</code>, we have direct dependencies on <code>SqlServerDatabase</code>, <code>SmtpEmailService</code>, and <code>FileLogger</code>. The refactored solution creates abstractions (<code>IOrderRepository</code>, <code>IEmailService</code>, <code>ILogger</code>) that define the contracts for these dependencies without specifying implementation details.</p>
<h3>2. Inject Dependencies</h3>
<p><strong>What it means</strong>: Instead of creating concrete objects directly within your classes, receive them as dependencies through constructor injection, setter injection, or method parameters.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Modify constructors to accept abstractions rather than creating concrete objects</li>
<li>Use dependency injection containers to manage object creation and wiring</li>
<li>Ensure dependencies are provided at the appropriate scope (singleton, transient, scoped)</li>
<li>Make dependencies explicit and visible in the class interface</li>
</ul>
<p><strong>Example from our code samples</strong>: The refactored <code>OrderService</code> receives its dependencies through constructor injection (<code>IOrderRepository orderRepository</code>, <code>IEmailService emailService</code>, <code>ILogger logger</code>). This makes the dependencies explicit and allows different implementations to be provided without changing the <code>OrderService</code> class.</p>
<h3>3. Depend on Abstractions</h3>
<p><strong>What it means</strong>: High-level modules should only reference abstractions, never concrete implementations. This creates loose coupling and makes the system more flexible.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Use interfaces or abstract classes in method signatures and property declarations</li>
<li>Avoid importing concrete implementation classes in high-level modules</li>
<li>Use polymorphism to work with abstractions rather than specific types</li>
<li>Design your high-level modules to be independent of implementation details</li>
</ul>
<p><strong>Example from our code samples</strong>: The refactored <code>OrderService</code> only depends on the abstractions (<code>IOrderRepository</code>, <code>IEmailService</code>, <code>ILogger</code>) and never directly references concrete implementations like <code>SqlServerDatabase</code> or <code>SmtpEmailService</code>. This allows the service to work with any implementation that satisfies the contracts.</p>
<h3>4. Implement Abstractions</h3>
<p><strong>What it means</strong>: Low-level modules should implement the abstractions defined by high-level modules. This inverts the traditional dependency direction.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Create concrete classes that implement the defined interfaces</li>
<li>Ensure implementations honor the contracts defined by the abstractions</li>
<li>Keep implementation details hidden behind the abstraction</li>
<li>Make implementations easily swappable and configurable</li>
</ul>
<p><strong>Example from our code samples</strong>: The refactored solution includes multiple implementations of each abstraction (<code>SqlServerDatabase</code> and <code>OracleDatabase</code> implement <code>IOrderRepository</code>, <code>SmtpEmailService</code> and <code>SendGridEmailService</code> implement <code>IEmailService</code>). This demonstrates how different implementations can be swapped without affecting the high-level modules.</p>
<h3>5. Use Dependency Injection Containers</h3>
<p><strong>What it means</strong>: Leverage IoC (Inversion of Control) containers to automatically manage dependency creation, wiring, and lifecycle management. This reduces boilerplate code and makes dependency management more systematic.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Configure the container to map abstractions to concrete implementations</li>
<li>Use the container to resolve dependencies automatically</li>
<li>Configure different implementations for different environments (development, testing, production)</li>
<li>Use the container&#39;s lifecycle management features (singleton, transient, scoped)</li>
</ul>
<p><strong>Example from our code samples</strong>: While not shown in the code samples, a typical IoC container configuration would map <code>IOrderRepository</code> to <code>SqlServerDatabase</code> in production and to a mock implementation in testing. This allows the same high-level modules to work in different environments without code changes.</p>
<h2>Examples of Violations and Refactoring</h2>
<h3>C# Example</h3>
<p><strong>Violating DIP:</strong></p>
<pre><code class="language-csharp">// High-level module depending on low-level module
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
            logger.Log($&quot;Order {order.Id} processed successfully&quot;);
        }
        catch (Exception ex)
        {
            logger.Log($&quot;Error processing order {order.Id}: {ex.Message}&quot;);
            throw;
        }
    }
}

// Low-level modules
public class SqlServerDatabase
{
    public void SaveOrder(Order order)
    {
        Console.WriteLine($&quot;Saving order {order.Id} to SQL Server&quot;);
    }
}

public class SmtpEmailService
{
    public void SendConfirmationEmail(string email)
    {
        Console.WriteLine($&quot;Sending confirmation email to {email} via SMTP&quot;);
    }
}

public class FileLogger
{
    public void Log(string message)
    {
        Console.WriteLine($&quot;Logging to file: {message}&quot;);
    }
}
</code></pre>
<p><strong>Refactored - Applying DIP:</strong></p>
<pre><code class="language-csharp">// Abstractions that high-level modules depend on
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
            logger.Log($&quot;Order {order.Id} processed successfully&quot;);
        }
        catch (Exception ex)
        {
            logger.Log($&quot;Error processing order {order.Id}: {ex.Message}&quot;);
            throw;
        }
    }
}

// Low-level modules implementing abstractions
public class SqlServerDatabase : IOrderRepository
{
    public void SaveOrder(Order order)
    {
        Console.WriteLine($&quot;Saving order {order.Id} to SQL Server&quot;);
    }
}

public class OracleDatabase : IOrderRepository
{
    public void SaveOrder(Order order)
    {
        Console.WriteLine($&quot;Saving order {order.Id} to Oracle&quot;);
    }
}

public class SmtpEmailService : IEmailService
{
    public void SendConfirmationEmail(string email)
    {
        Console.WriteLine($&quot;Sending confirmation email to {email} via SMTP&quot;);
    }
}

public class SendGridEmailService : IEmailService
{
    public void SendConfirmationEmail(string email)
    {
        Console.WriteLine($&quot;Sending confirmation email to {email} via SendGrid&quot;);
    }
}

public class FileLogger : ILogger
{
    public void Log(string message)
    {
        Console.WriteLine($&quot;Logging to file: {message}&quot;);
    }
}

public class DatabaseLogger : ILogger
{
    public void Log(string message)
    {
        Console.WriteLine($&quot;Logging to database: {message}&quot;);
    }
}
</code></pre>
<h3>Java Example</h3>
<p><strong>Violating DIP:</strong></p>
<pre><code class="language-java">// High-level module depending on low-level module
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
        System.out.println(&quot;Saving user to MySQL: &quot; + user.getName());
    }
}

public class EmailNotificationService {
    public void sendWelcomeEmail(String email) {
        System.out.println(&quot;Sending welcome email to: &quot; + email);
    }
}
</code></pre>
<p><strong>Refactored - Applying DIP:</strong></p>
<pre><code class="language-java">// Abstractions that high-level modules depend on
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
        System.out.println(&quot;Saving user to MySQL: &quot; + user.getName());
    }
}

public class PostgreSQLUserRepository implements UserRepository {
    @Override
    public void save(User user) {
        System.out.println(&quot;Saving user to PostgreSQL: &quot; + user.getName());
    }
}

public class EmailNotificationService implements NotificationService {
    @Override
    public void sendWelcomeEmail(String email) {
        System.out.println(&quot;Sending welcome email to: &quot; + email);
    }
}

public class SMSPushNotificationService implements NotificationService {
    @Override
    public void sendWelcomeEmail(String email) {
        System.out.println(&quot;Sending SMS welcome to: &quot; + email);
    }
}
</code></pre>
<h3>TypeScript Example</h3>
<p><strong>Violating DIP:</strong></p>
<pre><code class="language-typescript">// High-level module depending on low-level module
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
</code></pre>
<p><strong>Refactored - Applying DIP:</strong></p>
<pre><code class="language-typescript">// Abstractions that high-level modules depend on
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
</code></pre>
<h2>How This Principle Helps with Code Quality</h2>
<ol>
<li><strong>Loose Coupling</strong>: High-level modules are independent of low-level implementation details</li>
<li><strong>Flexibility</strong>: Dependencies can be easily swapped or modified</li>
<li><strong>Maintainability</strong>: Changes to low-level modules don&#39;t affect high-level modules</li>
<li><strong>Extensibility</strong>: New implementations can be added without modifying existing code</li>
<li><strong>Better Design</strong>: Forces proper separation of concerns and abstraction layers</li>
</ol>
<h2>How This Principle Helps with Automated Testing</h2>
<ol>
<li><strong>Easy Mocking</strong>: Dependencies can be easily mocked for testing</li>
<li><strong>Isolated Testing</strong>: High-level modules can be tested independently</li>
<li><strong>Test Flexibility</strong>: Different implementations can be used for different test scenarios</li>
<li><strong>Better Test Coverage</strong>: Each component can be tested in isolation</li>
<li><strong>Faster Tests</strong>: Mocked dependencies make tests run faster</li>
</ol>
<pre><code class="language-csharp">// Example of testing with DIP
[Test]
public void OrderService_ProcessOrder_SavesOrderAndSendsEmail()
{
    // Arrange
    var mockRepository = new Mock&lt;IOrderRepository&gt;();
    var mockEmailService = new Mock&lt;IEmailService&gt;();
    var mockLogger = new Mock&lt;ILogger&gt;();
    var orderService = new OrderService(mockRepository.Object, mockEmailService.Object, mockLogger.Object);
    var order = new Order { Id = 1, CustomerEmail = &quot;test@example.com&quot; };
    
    // Act
    orderService.ProcessOrder(order);
    
    // Assert
    mockRepository.Verify(x =&gt; x.SaveOrder(order), Times.Once);
    mockEmailService.Verify(x =&gt; x.SendConfirmationEmail(&quot;test@example.com&quot;), Times.Once);
    mockLogger.Verify(x =&gt; x.Log(&quot;Order 1 processed successfully&quot;), Times.Once);
}

[Test]
public void OrderService_ProcessOrder_LogsErrorOnException()
{
    // Arrange
    var mockRepository = new Mock&lt;IOrderRepository&gt;();
    var mockEmailService = new Mock&lt;IEmailService&gt;();
    var mockLogger = new Mock&lt;ILogger&gt;();
    mockRepository.Setup(x =&gt; x.SaveOrder(It.IsAny&lt;Order&gt;())).Throws(new Exception(&quot;Database error&quot;));
    var orderService = new OrderService(mockRepository.Object, mockEmailService.Object, mockLogger.Object);
    var order = new Order { Id = 1, CustomerEmail = &quot;test@example.com&quot; };
    
    // Act &amp; Assert
    Assert.Throws&lt;Exception&gt;(() =&gt; orderService.ProcessOrder(order));
    mockLogger.Verify(x =&gt; x.Log(&quot;Error processing order 1: Database error&quot;), Times.Once);
}
</code></pre>
<h2>Summary</h2>
<p>The Dependency Inversion Principle is the capstone of the SOLID principles, creating loosely coupled and highly cohesive systems. By ensuring that high-level modules depend on abstractions rather than concrete implementations, we achieve:</p>
<ul>
<li><strong>Loose Coupling</strong>: High-level modules are independent of low-level implementation details</li>
<li><strong>Flexibility</strong>: Dependencies can be easily swapped or modified</li>
<li><strong>Testability</strong>: Dependencies can be easily mocked for testing</li>
<li><strong>Maintainability</strong>: Changes to low-level modules don&#39;t affect high-level modules</li>
<li><strong>Extensibility</strong>: New implementations can be added without modifying existing code</li>
</ul>
<p>This principle completes the SOLID foundation by building upon all the previous principles:</p>
<ul>
<li><strong>SRP</strong> ensures each class has a single responsibility</li>
<li><strong>OCP</strong> allows extending functionality without modification</li>
<li><strong>LSP</strong> ensures subclasses can substitute base classes</li>
<li><strong>ISP</strong> creates focused, cohesive interfaces</li>
<li><strong>DIP</strong> inverts dependencies to depend on abstractions</li>
</ul>
<p>Together, these principles create a robust foundation for building maintainable, testable, and extensible software systems.</p>
<h2>Exercise 1: Design - Dependency Inversion Principle</h2>
<h3>Objective</h3>
<p>Design a solution that makes high-level modules depend on abstractions rather than concrete implementations, following the Dependency Inversion Principle.</p>
<h3>Task</h3>
<p>Analyze the e-commerce system and design an architecture that inverts dependencies.</p>
<ol>
<li><strong>Identify Dependencies</strong>: Examine the refactored code from previous exercises and identify all direct dependencies on concrete implementations</li>
<li><strong>Design Abstractions</strong>: Create interfaces or abstract classes for all external dependencies</li>
<li><strong>Plan Dependency Injection</strong>: Design how dependencies will be injected into high-level modules</li>
<li><strong>Design IoC Container</strong>: Plan a dependency injection container configuration</li>
</ol>
<h3>Deliverables</h3>
<ul>
<li>List of all direct dependencies identified</li>
<li>Interface designs for all external dependencies</li>
<li>Dependency injection architecture plan</li>
<li>IoC container configuration design</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Navigate to the <code>ecom-exercises</code> folder</li>
<li>Choose your preferred language (C#, Java, Python, or TypeScript)</li>
<li>Review your refactored code from all previous SOLID principle exercises</li>
<li>Identify direct dependencies on concrete implementations</li>
<li>Create your design without modifying any code</li>
</ol>
<hr>
<h2>Exercise 2: Implementation - Dependency Inversion Principle</h2>
<h3>Objective</h3>
<p>Implement your design from Exercise 1, ensuring that all existing unit tests continue to pass and high-level modules depend on abstractions.</p>
<h3>Task</h3>
<p>Implement the dependency inversion architecture according to your design while maintaining system functionality.</p>
<ol>
<li><strong>Create Abstractions</strong>: Implement the interfaces or abstract classes from your design</li>
<li><strong>Implement Dependency Injection</strong>: Modify classes to receive dependencies through constructor injection</li>
<li><strong>Configure IoC Container</strong>: Set up dependency injection container with proper mappings</li>
<li><strong>Maintain Functionality</strong>: Ensure all existing unit tests pass</li>
<li><strong>Test with Mocks</strong>: Verify that the system works with mock implementations</li>
</ol>
<h3>Success Criteria</h3>
<ul>
<li>All existing unit tests pass</li>
<li>The application runs without errors</li>
<li>High-level modules depend on abstractions, not concrete implementations</li>
<li>Dependencies can be easily swapped or mocked</li>
<li>The system maintains the same external behavior</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Use your design from Exercise 1 as a guide</li>
<li>Start by creating the abstractions</li>
<li>Implement dependency injection in existing classes</li>
<li>Set up the IoC container configuration</li>
<li>Run tests frequently to ensure you don&#39;t break existing functionality</li>
</ol>
<h3>Implementation Best Practices</h3>
<h4>Git Workflow</h4>
<ol>
<li><p><strong>Create a Feature Branch</strong>: Start from main and create a new branch for your DIP refactoring</p>
<pre><code class="language-bash">git checkout main
git pull origin main
git checkout -b feature/dip-refactoring
</code></pre>
</li>
<li><p><strong>Commit Frequently</strong>: Make small, focused commits as you refactor</p>
<pre><code class="language-bash">git add .
git commit -m &quot;Create IDatabaseConnection interface&quot;
git commit -m &quot;Create IEmailService interface&quot;
git commit -m &quot;Implement dependency injection in OrderService&quot;
git commit -m &quot;Configure IoC container mappings&quot;
git commit -m &quot;Add mock implementations for testing&quot;
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
<li><strong>Dependency Injection</strong>: Use constructor injection for required dependencies</li>
<li><strong>Interface Segregation</strong>: Create focused interfaces for each dependency</li>
<li><strong>IoC Container Configuration</strong>: Use dependency injection containers for automatic resolution</li>
<li><strong>Mock Testing</strong>: Create mock implementations for unit testing</li>
<li><strong>Configuration Management</strong>: Externalize configuration for different environments</li>
<li><strong>Service Locator Anti-pattern</strong>: Avoid service locator pattern in favor of dependency injection</li>
<li><strong>Circular Dependencies</strong>: Avoid circular dependencies between modules</li>
<li><strong>Lifetime Management</strong>: Properly manage object lifetimes (singleton, transient, scoped)</li>
<li><strong>Error Handling</strong>: Handle dependency resolution failures gracefully</li>
<li><strong>Performance</strong>: Consider the performance impact of dependency injection</li>
</ol>
<h3>Learning Objectives</h3>
<p>After completing both exercises, you should be able to:</p>
<ul>
<li>Identify direct dependencies that violate DIP</li>
<li>Design proper abstractions for external dependencies</li>
<li>Implement dependency injection effectively</li>
<li>Implement DIP while maintaining system functionality</li>
<li>Design loosely coupled systems</li>
</ul>
<p><strong>Congratulations!</strong> You have now learned all five SOLID principles. These principles work together to create software that is maintainable, testable, and adaptable to change. Apply them thoughtfully in your projects to build better software.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","1-SOLID-Principles/5-Dependency-segregation-principle/README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"5-Dependency-segregation-principle\",\"README\"]}"},"styles":[]}],"segment":["slug","1-SOLID-Principles/5-Dependency-segregation-principle/README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
