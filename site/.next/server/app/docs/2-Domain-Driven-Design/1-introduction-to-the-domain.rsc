1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/1-introduction-to-the-domain","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"1-introduction-to-the-domain\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T7ae7,<h1>Introduction to the Domain</h1>
<h2>📚 Code Samples</h2>
<p>This document contains comprehensive code examples in multiple programming languages. For easier navigation and focused learning, all code samples have been organized into individual files:</p>
<p>Each code sample includes:</p>
<ul>
<li><strong>Section Reference</strong>: Link back to the specific section in this document</li>
<li><strong>Navigation</strong>: Previous/Next links for easy movement</li>
<li><strong>Key Concepts</strong>: Detailed explanation of what the code demonstrates</li>
<li><strong>Related Concepts</strong>: Links to related samples and documentation</li>
</ul>
<h2>Overview</h2>
<p>The domain is the heart of Domain-Driven Design (DDD). It represents the business area that your software is designed to serve. Understanding the domain is crucial for building software that truly meets business needs and provides value to users.</p>
<p>This document introduces key concepts for expressing the domain in software, including model-driven design, domain isolation through layered architecture, domain entities, value objects, services, modules, and separation of concerns.</p>
<h2>What is a Domain?</h2>
<p>A <strong>domain</strong> is the sphere of knowledge, influence, or activity that your software addresses. It encompasses:</p>
<ul>
<li><strong>Business concepts</strong> and terminology</li>
<li><strong>Business rules</strong> and constraints  </li>
<li><strong>Business processes</strong> and workflows</li>
<li><strong>Business relationships</strong> and dependencies</li>
<li><strong>Business goals</strong> and objectives</li>
</ul>
<p>In Domain-Driven Design, the domain is not just the data or the user interface—it&#39;s the complete understanding of the business problem space that your software is trying to solve.</p>
<h3>Domain vs. Technical Concerns</h3>
<p>It&#39;s important to distinguish between domain concerns and technical concerns:</p>
<p><strong>Domain Concerns</strong> (What the business cares about):</p>
<ul>
<li>Customer registration and management</li>
<li>Order processing and fulfillment</li>
<li>Inventory tracking and management</li>
<li>Payment processing and billing</li>
<li>Product catalog and pricing</li>
</ul>
<p><strong>Technical Concerns</strong> (How we implement the domain):</p>
<ul>
<li>Database design and optimization</li>
<li>User interface frameworks</li>
<li>Network protocols and APIs</li>
<li>Caching strategies</li>
<li>Security implementations</li>
</ul>
<p>The goal of Domain-Driven Design is to keep domain concerns separate from technical concerns, allowing the domain to drive the design while technical concerns support it.</p>
<h2>Model-Driven Design</h2>
<p>Model-driven design is the practice of creating software that directly reflects the domain model. The domain model becomes the blueprint for the software structure, ensuring that the code represents business reality rather than technical convenience.</p>
<h3>Principles of Model-Driven Design</h3>
<ol>
<li><strong>The Model Drives the Code</strong>: The domain model should be the primary influence on code structure</li>
<li><strong>Business Logic in the Model</strong>: Business rules and logic should be encapsulated in domain objects</li>
<li><strong>Consistent Representation</strong>: The same domain concepts should be represented consistently throughout the system</li>
<li><strong>Evolutionary Design</strong>: The model evolves as understanding of the domain deepens</li>
</ol>
<h3>Benefits of Model-Driven Design</h3>
<ul>
<li><strong>Business Alignment</strong>: Software structure matches business structure</li>
<li><strong>Maintainability</strong>: Changes to business rules are localized to domain objects</li>
<li><strong>Understandability</strong>: Code is easier to understand for both developers and business stakeholders</li>
<li><strong>Testability</strong>: Business logic can be tested independently of technical concerns</li>
</ul>
<h2>Domain Isolation and Layered Architecture</h2>
<p>Domain isolation is achieved through layered architecture, which separates different concerns into distinct layers. This separation ensures that domain logic remains pure and independent of technical implementation details.</p>
<h3>Traditional Layered Architecture</h3>
<pre><code>┌─────────────────────────────────────┐
│           Presentation Layer        │  ← User Interface, Controllers, Views
├─────────────────────────────────────┤
│           Application Layer         │  ← Use Cases, Application Services
├─────────────────────────────────────┤
│             Domain Layer            │  ← Business Logic, Domain Models
├─────────────────────────────────────┤
│          Infrastructure Layer       │  ← Database, External Services, Frameworks
└─────────────────────────────────────┘
</code></pre>
<h3>Layer Responsibilities</h3>
<h4>Presentation Layer</h4>
<ul>
<li><strong>Purpose</strong>: Handles user interaction and presentation</li>
<li><strong>Responsibilities</strong>: <ul>
<li>User interface components</li>
<li>Input validation and formatting</li>
<li>Response formatting</li>
<li>User experience concerns</li>
</ul>
</li>
<li><strong>Dependencies</strong>: Can depend on Application Layer</li>
</ul>
<h4>Application Layer</h4>
<ul>
<li><strong>Purpose</strong>: Orchestrates domain operations and coordinates between layers</li>
<li><strong>Responsibilities</strong>:<ul>
<li>Use case implementation</li>
<li>Transaction management</li>
<li>Security and authorization</li>
<li>Integration with external systems</li>
</ul>
</li>
<li><strong>Dependencies</strong>: Can depend on Domain Layer and Infrastructure Layer</li>
</ul>
<h4>Domain Layer</h4>
<ul>
<li><strong>Purpose</strong>: Contains the core business logic and domain models</li>
<li><strong>Responsibilities</strong>:<ul>
<li>Business rules and constraints</li>
<li>Domain entities and value objects</li>
<li>Domain services</li>
<li>Business process modeling</li>
</ul>
</li>
<li><strong>Dependencies</strong>: Should not depend on other layers (pure domain)</li>
</ul>
<h4>Infrastructure Layer</h4>
<ul>
<li><strong>Purpose</strong>: Provides technical capabilities and external integrations</li>
<li><strong>Responsibilities</strong>:<ul>
<li>Database access and persistence</li>
<li>External service integration</li>
<li>Framework-specific implementations</li>
<li>Technical utilities and helpers</li>
</ul>
</li>
<li><strong>Dependencies</strong>: Can depend on Domain Layer (through interfaces)</li>
</ul>
<h3>Benefits of Layered Architecture</h3>
<ol>
<li><strong>Separation of Concerns</strong>: Each layer has a single, well-defined responsibility</li>
<li><strong>Domain Isolation</strong>: Domain logic is protected from technical changes</li>
<li><strong>Testability</strong>: Each layer can be tested independently</li>
<li><strong>Maintainability</strong>: Changes in one layer don&#39;t necessarily affect others</li>
<li><strong>Flexibility</strong>: Technical implementations can be changed without affecting domain logic</li>
</ol>
<h2>Domain Entities</h2>
<p>Domain entities are objects that have a distinct identity that persists over time. They represent concepts that the business cares about as individuals, even if their attributes change.</p>
<h3>Characteristics of Entities</h3>
<ol>
<li><strong>Unique Identity</strong>: Each entity has a unique identifier that distinguishes it from other entities</li>
<li><strong>Lifecycle</strong>: Entities have a lifecycle (creation, modification, deletion)</li>
<li><strong>Mutable State</strong>: Entities can change their state over time</li>
<li><strong>Business Meaning</strong>: Entities represent important business concepts</li>
</ol>
<h3>Entity Design Principles</h3>
<h4>Identity Management</h4>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/01-customer-entity.md">C#</a> | <a href="./code-samples/java/01-customer-entity.md">Java</a> | <a href="./code-samples/typescript/01-customer-entity.md">TypeScript</a> | <a href="./code-samples/python/01-customer-entity.md">Python</a></p>
<p>Entities must have a unique identity that distinguishes them from other entities, even if their attributes change over time. This identity should be:</p>
<ul>
<li><strong>Immutable</strong>: Once assigned, the identity should never change</li>
<li><strong>Unique</strong>: No two entities should have the same identity</li>
<li><strong>Meaningful</strong>: The identity should have business significance</li>
<li><strong>Stable</strong>: The identity should persist throughout the entity&#39;s lifecycle</li>
</ul>
<p>In our e-commerce example, a <code>Customer</code> entity has a <code>CustomerId</code> that uniquely identifies each customer. Even if the customer changes their name, email, or address, they remain the same customer because their <code>CustomerId</code> doesn&#39;t change.</p>
<p><strong>Key Design Principles:</strong></p>
<ul>
<li>Use value objects for identity types (e.g., <code>CustomerId</code>, <code>OrderId</code>)</li>
<li>Make identity immutable and meaningful</li>
<li>Ensure identity uniqueness across the system</li>
<li>Use factory methods or services to generate identities</li>
</ul>
<h4>Business Logic Encapsulation</h4>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/02-order-entity.md">C#</a></p>
<p>Entities should contain business logic related to their state and behavior. This encapsulation ensures that:</p>
<ul>
<li><strong>Business rules are enforced</strong> at the domain level</li>
<li><strong>Data integrity is maintained</strong> through controlled access</li>
<li><strong>Complex operations are atomic</strong> and consistent</li>
<li><strong>Business knowledge is centralized</strong> in the domain</li>
</ul>
<p>In our e-commerce example, the <code>Order</code> entity encapsulates important business rules:</p>
<ul>
<li><strong>Order State Management</strong>: Only draft orders can be modified</li>
<li><strong>Item Management</strong>: Adding items updates quantities and recalculates totals</li>
<li><strong>Order Confirmation</strong>: Orders must have items before they can be confirmed</li>
<li><strong>Business Validation</strong>: Quantity must be positive, products must exist</li>
</ul>
<p><strong>Key Design Principles:</strong></p>
<ul>
<li>Keep business logic within entities, not in external services</li>
<li>Use private setters and controlled methods for state changes</li>
<li>Validate business rules before allowing state changes</li>
<li>Make operations atomic and consistent</li>
<li>Use domain events to communicate significant changes</li>
</ul>
<h2>Value Objects</h2>
<p>Value objects are objects that are defined by their attributes rather than their identity. They represent concepts that are equal if they have the same attributes, and they are typically immutable.</p>
<h3>Characteristics of Value Objects</h3>
<ol>
<li><strong>No Identity</strong>: Value objects don&#39;t have a unique identifier</li>
<li><strong>Immutable</strong>: Once created, value objects cannot be changed</li>
<li><strong>Value Equality</strong>: Two value objects are equal if they have the same attributes</li>
<li><strong>Self-Validating</strong>: Value objects validate their own state</li>
</ol>
<h3>When to Use Value Objects</h3>
<p>Value objects are ideal for representing:</p>
<ul>
<li><strong>Quantities and Measurements</strong>: Money, Distance, Weight, Temperature</li>
<li><strong>Descriptive Attributes</strong>: Address, Email, Phone Number, Color</li>
<li><strong>Complex Types</strong>: Date Range, Time Period, Geographic Coordinates</li>
<li><strong>Business Concepts</strong>: Product Code, SKU, ISBN, Currency Code</li>
</ul>
<h3>Value Object Design Principles</h3>
<h4>Immutability</h4>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/03-money-value-object.md">C#</a> | <a href="./code-samples/java/02-money-value-object.md">Java</a> | <a href="./code-samples/typescript/02-money-value-object.md">TypeScript</a> | <a href="./code-samples/python/02-money-value-object.md">Python</a></p>
<p>Value objects should be immutable to ensure:</p>
<ul>
<li><strong>Thread Safety</strong>: Multiple threads can safely access the same value object</li>
<li><strong>Predictable Behavior</strong>: Value objects cannot be unexpectedly modified</li>
<li><strong>Simplified Reasoning</strong>: No need to track state changes over time</li>
<li><strong>Consistent Equality</strong>: Equality comparisons remain valid</li>
</ul>
<p>In our e-commerce example, the <code>Money</code> value object represents monetary amounts with currency. Once created, the amount and currency cannot be changed, ensuring that monetary calculations are predictable and safe.</p>
<p><strong>Key Design Principles:</strong></p>
<ul>
<li>Make all properties read-only (getters only)</li>
<li>Validate input in the constructor</li>
<li>Return new instances for operations (don&#39;t modify existing ones)</li>
<li>Implement proper equality and hash code methods</li>
<li>Use factory methods for common values (e.g., <code>Money.Zero()</code>)</li>
</ul>
<h4>Self-Validation</h4>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/04-email-address-value-object.md">C#</a></p>
<p>Value objects should validate their own state upon creation to ensure:</p>
<ul>
<li><strong>Data Integrity</strong>: Invalid data cannot enter the system</li>
<li><strong>Early Error Detection</strong>: Problems are caught at the domain boundary</li>
<li><strong>Consistent Validation</strong>: Same rules applied everywhere the value object is used</li>
<li><strong>Clear Error Messages</strong>: Domain-specific validation messages</li>
</ul>
<p>In our e-commerce example, the <code>EmailAddress</code> value object validates that the email format is correct and normalizes it to lowercase, ensuring consistent email handling throughout the system.</p>
<p><strong>Key Design Principles:</strong></p>
<ul>
<li>Validate all input in the constructor</li>
<li>Throw meaningful exceptions for invalid data</li>
<li>Normalize data when appropriate (e.g., lowercase emails)</li>
<li>Use domain-specific validation rules</li>
<li>Consider using validation libraries for complex rules</li>
</ul>
<h2>Domain Services</h2>
<p>Domain services contain business logic that doesn&#39;t naturally belong to any entity or value object. They represent operations that involve multiple domain objects or complex business rules.</p>
<h3>When to Use Domain Services</h3>
<p>Domain services are appropriate when:</p>
<ol>
<li><strong>Cross-Entity Operations</strong>: Operations that involve multiple entities</li>
<li><strong>Complex Business Rules</strong>: Rules that are too complex for a single entity</li>
<li><strong>Stateless Operations</strong>: Operations that don&#39;t maintain state</li>
<li><strong>Domain-Specific Calculations</strong>: Complex calculations that are part of the domain</li>
</ol>
<h3>Domain Service Design Principles</h3>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/05-pricing-service.md">C#</a> | <a href="./code-samples/java/03-inventory-service.md">Java</a></p>
<p>Domain services should be:</p>
<ul>
<li><strong>Stateless</strong>: No instance variables that change over time</li>
<li><strong>Pure</strong>: Same inputs always produce same outputs</li>
<li><strong>Focused</strong>: Each service has a single, well-defined responsibility</li>
<li><strong>Domain-Specific</strong>: Contain only business logic, not technical concerns</li>
</ul>
<p>In our e-commerce example, the <code>PricingService</code> calculates order totals by considering:</p>
<ul>
<li><strong>Customer Type</strong>: Premium customers get discounts</li>
<li><strong>Order Size</strong>: Bulk orders receive additional discounts</li>
<li><strong>Geographic Location</strong>: Tax rates vary by state/region</li>
<li><strong>Shipping Rules</strong>: Free shipping thresholds and weight-based pricing</li>
</ul>
<p><strong>Key Design Principles:</strong></p>
<ul>
<li>Keep services stateless and pure</li>
<li>Focus on business logic, not technical implementation</li>
<li>Use dependency injection for external dependencies</li>
<li>Make services testable with clear interfaces</li>
<li>Consider using interfaces for better testability</li>
</ul>
<h2>Modules and Separation of Concerns</h2>
<p>Modules provide a way to organize related domain concepts together. They help manage complexity by grouping related functionality and providing clear boundaries within the domain layer.</p>
<h3>Module Design Principles</h3>
<ol>
<li><strong>High Cohesion</strong>: Modules should contain related concepts</li>
<li><strong>Low Coupling</strong>: Modules should have minimal dependencies on each other</li>
<li><strong>Clear Interfaces</strong>: Module boundaries should be well-defined</li>
<li><strong>Domain-Driven</strong>: Modules should reflect domain concepts, not technical concerns</li>
</ol>
<h3>Example Module Organization</h3>
<pre><code>Domain/
├── Customer/
│   ├── Customer.cs
│   ├── CustomerId.cs
│   ├── CustomerStatus.cs
│   ├── CustomerService.cs
│   └── ICustomerRepository.cs
├── Order/
│   ├── Order.cs
│   ├── OrderId.cs
│   ├── OrderItem.cs
│   ├── OrderStatus.cs
│   ├── OrderService.cs
│   └── IOrderRepository.cs
├── Product/
│   ├── Product.cs
│   ├── ProductId.cs
│   ├── ProductCategory.cs
│   ├── ProductService.cs
│   └── IProductRepository.cs
├── Shared/
│   ├── Money.cs
│   ├── Address.cs
│   ├── EmailAddress.cs
│   └── Currency.cs
└── Services/
    ├── PricingService.cs
    ├── InventoryService.cs
    └── NotificationService.cs
</code></pre>
<h3>Module Implementation Example</h3>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/06-customer-module.md">C#</a></p>
<p>Modules should be organized around business capabilities rather than technical layers. In our e-commerce example:</p>
<ul>
<li><strong>Customer Module</strong>: Contains all customer-related domain objects and services</li>
<li><strong>Order Module</strong>: Handles order processing and management</li>
<li><strong>Product Module</strong>: Manages product catalog and inventory</li>
<li><strong>Shared Module</strong>: Contains common value objects used across modules</li>
<li><strong>Services Module</strong>: Contains cross-cutting domain services</li>
</ul>
<p><strong>Key Design Principles:</strong></p>
<ul>
<li>Group related domain concepts together</li>
<li>Minimize dependencies between modules</li>
<li>Use interfaces to define module boundaries</li>
<li>Keep shared concepts in a common module</li>
<li>Avoid circular dependencies between modules</li>
</ul>
<h2>Domain-Driven Design and Unit Testing</h2>
<p>Domain-Driven Design significantly improves the ability to write effective unit tests by creating a clear separation between business logic and technical concerns. This separation makes it easier to test business rules in isolation, leading to more reliable and maintainable test suites.</p>
<h3>How DDD Improves Unit Testing</h3>
<h4>1. <strong>Pure Domain Logic is Easily Testable</strong></h4>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/07-order-tests.md">C#</a> | <a href="./code-samples/java/04-order-tests.md">Java</a></p>
<p>Domain objects contain pure business logic without external dependencies, making them ideal for unit testing. This means:</p>
<ul>
<li><strong>No External Dependencies</strong>: Tests don&#39;t need to mock databases, web services, or file systems</li>
<li><strong>Fast Execution</strong>: Tests run quickly without I/O operations</li>
<li><strong>Deterministic Results</strong>: Same inputs always produce same outputs</li>
<li><strong>Easy Setup</strong>: Simple object creation and method calls</li>
</ul>
<p>In our e-commerce example, testing the <code>Order</code> entity&#39;s business rules is straightforward because the entity contains only domain logic. We can test scenarios like:</p>
<ul>
<li>Adding items to a draft order</li>
<li>Preventing modifications to confirmed orders</li>
<li>Ensuring orders have items before confirmation</li>
</ul>
<h4>2. <strong>Value Objects Enable Comprehensive Testing</strong></h4>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/08-money-tests.md">C#</a></p>
<p>Value objects are immutable and self-validating, making them perfect for thorough testing. This enables:</p>
<ul>
<li><strong>Comprehensive Coverage</strong>: Test all validation rules and edge cases</li>
<li><strong>Equality Testing</strong>: Verify that value equality works correctly</li>
<li><strong>Immutability Testing</strong>: Ensure objects cannot be modified after creation</li>
<li><strong>Edge Case Testing</strong>: Test boundary conditions and invalid inputs</li>
</ul>
<p>In our e-commerce example, we can thoroughly test the <code>Money</code> value object by:</p>
<ul>
<li>Testing arithmetic operations with same and different currencies</li>
<li>Verifying validation of negative amounts</li>
<li>Testing equality and hash code implementations</li>
<li>Ensuring immutability through all operations</li>
</ul>
<h4>3. <strong>Domain Services Enable Focused Testing</strong></h4>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/09-pricing-service-tests.md">C#</a></p>
<p>Domain services can be tested independently with mocked dependencies. This allows:</p>
<ul>
<li><strong>Focused Testing</strong>: Test complex business rules in isolation</li>
<li><strong>Mocked Dependencies</strong>: Use test doubles for external services</li>
<li><strong>Scenario Testing</strong>: Test various business scenarios and edge cases</li>
<li><strong>Integration Testing</strong>: Test how multiple domain objects work together</li>
</ul>
<p>In our e-commerce example, the <code>PricingService</code> can be tested by:</p>
<ul>
<li>Testing discount calculations for different customer types</li>
<li>Verifying bulk order discounts</li>
<li>Testing tax calculations for different regions</li>
<li>Ensuring shipping cost calculations are correct</li>
</ul>
<h4>4. <strong>Testable Business Rules</strong></h4>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/07-order-tests.md">C#</a> (see business rule tests)</p>
<p>Business rules are encapsulated in domain objects, making them easy to test. This provides:</p>
<ul>
<li><strong>Clear Test Intent</strong>: Each test validates a specific business rule</li>
<li><strong>Readable Tests</strong>: Tests express business requirements clearly</li>
<li><strong>Maintainable Tests</strong>: Changes to business rules are reflected in tests</li>
<li><strong>Documentation</strong>: Tests serve as living documentation of business rules</li>
</ul>
<p>In our e-commerce example, we can test business rules like:</p>
<ul>
<li>Customers can only place orders when they are active</li>
<li>Orders cannot be modified once confirmed</li>
<li>Orders must have items before they can be confirmed</li>
<li>Email addresses must be valid before customer registration</li>
</ul>
<h4>5. <strong>Isolated Testing with Dependency Injection</strong></h4>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/10-customer-service-tests.md">C#</a></p>
<p>Domain services can be tested with mocked dependencies. This enables:</p>
<ul>
<li><strong>Isolated Testing</strong>: Test business logic without external dependencies</li>
<li><strong>Controlled Environment</strong>: Use mocks to create predictable test scenarios</li>
<li><strong>Fast Tests</strong>: No real database or service calls during testing</li>
<li><strong>Reliable Tests</strong>: Tests don&#39;t fail due to external service issues</li>
</ul>
<p>In our e-commerce example, the <code>CustomerService</code> can be tested by:</p>
<ul>
<li>Mocking the customer repository to control data access</li>
<li>Mocking the email service to verify welcome emails are sent</li>
<li>Testing customer registration with various scenarios</li>
<li>Verifying error handling when customers already exist</li>
</ul>
<h3>Benefits of DDD for Unit Testing</h3>
<h4>1. <strong>Fast Test Execution</strong></h4>
<ul>
<li>Domain objects have no external dependencies</li>
<li>Tests run quickly without database or network calls</li>
<li>Enables rapid feedback during development</li>
</ul>
<h4>2. <strong>Reliable Tests</strong></h4>
<ul>
<li>Pure domain logic is deterministic</li>
<li>No flaky tests due to external dependencies</li>
<li>Tests are consistent across different environments</li>
</ul>
<h4>3. <strong>Comprehensive Coverage</strong></h4>
<ul>
<li>Business rules are encapsulated and easily testable</li>
<li>Edge cases can be thoroughly tested</li>
<li>Complex business scenarios can be modeled and tested</li>
</ul>
<h4>4. <strong>Maintainable Test Suite</strong></h4>
<ul>
<li>Tests are focused on business logic</li>
<li>Changes to technical implementation don&#39;t break domain tests</li>
<li>Tests serve as living documentation of business rules</li>
</ul>
<h4>5. <strong>Clear Test Intent</strong></h4>
<ul>
<li>Tests clearly express business requirements</li>
<li>Domain language makes tests readable to business stakeholders</li>
<li>Tests validate business rules, not technical implementation</li>
</ul>
<h3>Testing Anti-Patterns to Avoid</h3>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/11-testing-anti-patterns.md">C#</a></p>
<h4>1. <strong>Testing Infrastructure Concerns</strong></h4>
<p>Don&#39;t test database interactions, logging, or other technical concerns in domain tests. Focus on business logic instead.</p>
<h4>2. <strong>Testing Implementation Details</strong></h4>
<p>Don&#39;t test private fields, internal methods, or implementation-specific behavior. Test the public interface and behavior.</p>
<h4>3. <strong>Over-Mocking</strong></h4>
<p>Avoid mocking too many dependencies, which makes tests brittle and hard to understand. Mock only what&#39;s necessary.</p>
<h4>4. <strong>Testing Technical Framework Code</strong></h4>
<p>Don&#39;t test framework methods or third-party library functionality. Test your domain logic.</p>
<h3>Best Practices for DDD Unit Testing</h3>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/12-testing-best-practices.md">C#</a></p>
<h4>1. <strong>Test Behavior, Not Implementation</strong></h4>
<p>Focus on what the domain object does, not how it does it. Test the observable behavior and outcomes.</p>
<h4>2. <strong>Use Descriptive Test Names</strong></h4>
<p>Test names should clearly express the scenario, action, and expected outcome. Make them readable to business stakeholders.</p>
<h4>3. <strong>Test Edge Cases and Business Rules</strong></h4>
<p>Ensure comprehensive coverage of business rules and boundary conditions. Test both happy paths and error scenarios.</p>
<h4>4. <strong>Keep Tests Simple and Focused</strong></h4>
<p>Each test should validate one concept or business rule. Avoid complex test setups and multiple assertions per test.</p>
<h4>5. <strong>Use Domain Language in Tests</strong></h4>
<p>Use business terminology in test names and assertions to make tests more readable and maintainable.</p>
<h2>Best Practices for Domain Modeling</h2>
<p><strong>Code Samples</strong>: <a href="./code-samples/csharp/13-domain-modeling-best-practices.md">C#</a></p>
<h3>1. Keep Domain Logic Pure</h3>
<p>Domain objects should not depend on external frameworks or infrastructure concerns. This ensures:</p>
<ul>
<li><strong>Testability</strong>: Domain logic can be tested in isolation</li>
<li><strong>Portability</strong>: Domain logic can be reused across different technical implementations</li>
<li><strong>Clarity</strong>: Business rules are not obscured by technical details</li>
<li><strong>Maintainability</strong>: Changes to technical infrastructure don&#39;t affect domain logic</li>
</ul>
<h3>2. Use Rich Domain Models</h3>
<p>Domain objects should contain both data and behavior. This creates:</p>
<ul>
<li><strong>Encapsulation</strong>: Business rules are contained within the objects that own the data</li>
<li><strong>Cohesion</strong>: Related data and behavior are kept together</li>
<li><strong>Expressiveness</strong>: The domain model clearly expresses business concepts</li>
<li><strong>Maintainability</strong>: Changes to business rules are localized to the appropriate objects</li>
</ul>
<h3>3. Validate at Domain Boundaries</h3>
<p>Domain objects should validate their state and enforce business rules. This provides:</p>
<ul>
<li><strong>Data Integrity</strong>: Invalid data cannot enter the system</li>
<li><strong>Early Error Detection</strong>: Problems are caught at the domain boundary</li>
<li><strong>Consistent Validation</strong>: Same rules applied everywhere the domain object is used</li>
<li><strong>Clear Error Messages</strong>: Domain-specific validation messages</li>
</ul>
<h3>4. Use Value Objects for Complex Types</h3>
<p>Use value objects to represent complex concepts and ensure consistency. This enables:</p>
<ul>
<li><strong>Type Safety</strong>: Compile-time checking of business rules</li>
<li><strong>Immutability</strong>: Values cannot be accidentally modified</li>
<li><strong>Validation</strong>: Complex validation rules are enforced at creation</li>
<li><strong>Expressiveness</strong>: Business concepts are clearly represented in code</li>
</ul>
<h3>5. Design for Testability</h3>
<p>Make domain objects easy to test by:</p>
<ul>
<li><strong>Minimizing Dependencies</strong>: Reduce external dependencies</li>
<li><strong>Clear Interfaces</strong>: Provide well-defined public interfaces</li>
<li><strong>Pure Functions</strong>: Use pure functions where possible</li>
<li><strong>Dependency Injection</strong>: Use dependency injection for external services</li>
</ul>
<h2>Summary</h2>
<p>The domain is the heart of Domain-Driven Design, representing the business knowledge that drives software design. By understanding and properly modeling the domain through:</p>
<ul>
<li><strong>Model-driven design</strong> that reflects business reality</li>
<li><strong>Layered architecture</strong> that isolates domain concerns</li>
<li><strong>Rich entities</strong> that encapsulate business logic</li>
<li><strong>Immutable value objects</strong> that ensure consistency</li>
<li><strong>Domain services</strong> that handle complex operations</li>
<li><strong>Well-organized modules</strong> that manage complexity</li>
</ul>
<p>We can build software that truly serves business needs while maintaining technical excellence. The key is to keep the domain pure, focused, and free from technical concerns, allowing business logic to drive the design while technical implementation supports it.</p>
<p>This foundation enables teams to build maintainable, testable, and understandable software that evolves with business needs and provides real value to users.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/1-introduction-to-the-domain","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"1-introduction-to-the-domain"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"1-introduction-to-the-domain\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/1-introduction-to-the-domain","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
