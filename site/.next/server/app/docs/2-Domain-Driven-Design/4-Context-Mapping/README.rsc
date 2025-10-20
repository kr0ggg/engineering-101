1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/4-Context-Mapping/README","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"4-Context-Mapping\",\"README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T1312e,<h1>Context Mapping</h1>
<h2>Name</h2>
<p><strong>Context Mapping</strong> - Managing Relationships Between Bounded Contexts</p>
<h2>Goal of the Concept</h2>
<p>Context mapping defines the relationships between different bounded contexts and how they interact. It helps manage the complexity of large systems by clearly defining how different parts communicate, what dependencies exist, and how to handle integration challenges.</p>
<h2>Theoretical Foundation</h2>
<h3>Integration Complexity</h3>
<p>Context mapping addresses the reality that large systems are composed of multiple bounded contexts that need to interact. Without clear mapping, these interactions become chaotic and unmanageable.</p>
<h3>Relationship Patterns</h3>
<p>Eric Evans identified several patterns for context relationships, each with different characteristics, trade-offs, and implementation strategies. These patterns provide guidance for managing different types of relationships.</p>
<h3>Strategic Design</h3>
<p>Context mapping is a strategic design tool that helps teams make high-level architectural decisions about how different parts of the system should interact and what level of coupling is acceptable.</p>
<h3>Organizational Alignment</h3>
<p>Context mapping often reflects organizational structure, with different teams owning different contexts and needing to coordinate their work through well-defined interfaces.</p>
<h2>Consequences of Poor Context Mapping</h2>
<h3>Unique Context Mapping Issues</h3>
<p><strong>Integration Chaos</strong></p>
<ul>
<li>Different contexts interact in unpredictable ways</li>
<li>Changes in one context break other contexts</li>
<li>Integration becomes a source of bugs and failures</li>
<li>System becomes hard to understand and maintain</li>
</ul>
<p><strong>Coupling Problems</strong></p>
<ul>
<li>Contexts become tightly coupled despite boundaries</li>
<li>Changes cascade across context boundaries</li>
<li>Teams can&#39;t work independently</li>
<li>System becomes fragile and hard to modify</li>
</ul>
<p><strong>Communication Breakdown</strong></p>
<ul>
<li>Teams don&#39;t understand how their context relates to others</li>
<li>Integration requirements are unclear</li>
<li>Dependencies are hidden or misunderstood</li>
<li>Coordination becomes difficult and error-prone</li>
</ul>
<h2>Impact on System Architecture</h2>
<h3>Architectural Benefits</h3>
<p><strong>Clear Integration Points</strong></p>
<ul>
<li>Well-defined interfaces between contexts</li>
<li>Clear understanding of dependencies</li>
<li>Predictable integration behavior</li>
<li>Easier to test and validate</li>
</ul>
<p><strong>Team Autonomy</strong></p>
<ul>
<li>Teams can work independently on their contexts</li>
<li>Clear boundaries reduce coordination overhead</li>
<li>Different contexts can evolve at different rates</li>
<li>Easier to scale development efforts</li>
</ul>
<h3>Architectural Challenges</h3>
<p><strong>Integration Complexity</strong></p>
<ul>
<li>Managing communication between contexts</li>
<li>Handling data consistency across boundaries</li>
<li>Performance considerations for cross-context operations</li>
<li>Error handling and recovery across boundaries</li>
</ul>
<h2>Role in Domain-Driven Design</h2>
<p>Context mapping is essential to Domain-Driven Design because it:</p>
<ul>
<li><strong>Defines relationships</strong> between different bounded contexts</li>
<li><strong>Manages integration complexity</strong> in large systems</li>
<li><strong>Enables team autonomy</strong> by providing clear boundaries</li>
<li><strong>Supports strategic design</strong> decisions about system architecture</li>
<li><strong>Facilitates communication</strong> between different teams</li>
</ul>
<h2>How to Map Context Relationships</h2>
<h3>1. Identify Context Relationships</h3>
<p><strong>What it means</strong>: Determine how different bounded contexts need to interact with each other. This includes understanding data flow, dependencies, and communication patterns.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Map data flow between contexts</li>
<li>Identify which contexts depend on others</li>
<li>Understand the direction of dependencies</li>
<li>Look for shared concepts or data</li>
</ul>
<p><strong>Example</strong>: In an e-commerce system, the Order context might need customer information from the Customer context, and the Inventory context might need to know about orders to update stock levels.</p>
<h3>2. Choose Relationship Patterns</h3>
<p><strong>What it means</strong>: Select appropriate patterns for each relationship based on the nature of the interaction, the level of coupling acceptable, and the organizational structure.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Understand the characteristics of each pattern</li>
<li>Consider the trade-offs of different patterns</li>
<li>Match patterns to relationship needs</li>
<li>Consider organizational constraints</li>
</ul>
<p><strong>Example</strong>: A Customer-Supplier relationship might be appropriate when one context provides services to another, while a Shared Kernel might be used when two contexts need to share some common concepts.</p>
<h3>3. Define Integration Interfaces</h3>
<p><strong>What it means</strong>: Create clear interfaces for communication between contexts, including data formats, protocols, and error handling.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Design stable interfaces between contexts</li>
<li>Define data formats and protocols</li>
<li>Specify error handling and recovery</li>
<li>Document integration requirements</li>
</ul>
<p><strong>Example</strong>: The Order context might expose a REST API for other contexts to query order information, with clear data formats and error codes.</p>
<h3>4. Handle Data Consistency</h3>
<p><strong>What it means</strong>: Manage data consistency across context boundaries, which is often the most challenging aspect of context integration.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Choose appropriate consistency models</li>
<li>Implement eventual consistency where needed</li>
<li>Handle data synchronization</li>
<li>Manage conflicts and reconciliation</li>
</ul>
<p><strong>Example</strong>: When an order is placed, the Inventory context might be updated asynchronously, with eventual consistency between the Order and Inventory contexts.</p>
<h3>5. Plan for Evolution</h3>
<p><strong>What it means</strong>: Design context relationships to evolve over time as the system grows and requirements change.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Design interfaces to be extensible</li>
<li>Plan for versioning and backward compatibility</li>
<li>Consider how relationships might change</li>
<li>Design for independent evolution</li>
</ul>
<p><strong>Example</strong>: The Customer context might evolve its data model while maintaining backward compatibility with the Order context through versioned APIs.</p>
<h2>Context Relationship Patterns</h2>
<h3>1. Shared Kernel</h3>
<p><strong>What it means</strong>: Two teams share a small, common model that both teams depend on. This pattern is used when contexts are closely related but need some independence.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Small, shared model between contexts</li>
<li>Requires close coordination between teams</li>
<li>Changes to shared model affect both contexts</li>
<li>Provides consistency for shared concepts</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>Contexts are closely related</li>
<li>Some concepts must be shared</li>
<li>Teams can coordinate closely</li>
<li>Consistency is more important than independence</li>
</ul>
<p><strong>Example</strong>: The Customer and Order contexts might share a common CustomerId concept to ensure consistency in customer identification.</p>
<h3>2. Customer-Supplier</h3>
<p><strong>What it means</strong>: One context (supplier) provides services to another context (customer). The supplier has more control over the interface, but the customer&#39;s needs influence the design.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Clear upstream-downstream relationship</li>
<li>Supplier controls the interface</li>
<li>Customer needs influence supplier design</li>
<li>Supplier provides services to customer</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>One context provides services to another</li>
<li>Clear dependency direction</li>
<li>Supplier can influence customer needs</li>
<li>Customer depends on supplier capabilities</li>
</ul>
<p><strong>Example</strong>: The Payment context provides payment processing services to the Order context, with the Payment context controlling the payment interface.</p>
<h3>3. Conformist</h3>
<p><strong>What it means</strong>: The downstream context conforms to the upstream model without modification. This pattern is used when the downstream context has little influence over the upstream design.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Downstream context uses upstream model as-is</li>
<li>Minimal customization or adaptation</li>
<li>Upstream context has full control</li>
<li>Simple integration but limited flexibility</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>Downstream context has little influence</li>
<li>Upstream model is suitable for downstream needs</li>
<li>Simplicity is more important than customization</li>
<li>Upstream context is stable and well-designed</li>
</ul>
<p><strong>Example</strong>: The Reporting context might conform to the Order context&#39;s data model for generating reports, using the same data structures.</p>
<h3>4. Anti-Corruption Layer</h3>
<p><strong>What it means</strong>: The downstream context translates the upstream model to its own model, protecting itself from changes in the upstream context.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Translation layer between contexts</li>
<li>Downstream context maintains its own model</li>
<li>Protects downstream from upstream changes</li>
<li>More complex but provides better isolation</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>Upstream model doesn&#39;t fit downstream needs</li>
<li>Downstream context needs protection from upstream changes</li>
<li>Downstream context has specific requirements</li>
<li>Isolation is more important than simplicity</li>
</ul>
<p><strong>Example</strong>: The Order context might translate customer data from the Customer context into its own customer model to maintain its specific requirements.</p>
<h3>5. Open Host Service</h3>
<p><strong>What it means</strong>: The upstream context provides a well-defined service interface that multiple downstream contexts can use.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Well-defined service interface</li>
<li>Multiple downstream contexts can use the service</li>
<li>Upstream context controls the interface</li>
<li>Service is designed for reuse</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>Multiple contexts need the same service</li>
<li>Service can be standardized</li>
<li>Upstream context can provide stable interface</li>
<li>Reuse is more important than customization</li>
</ul>
<p><strong>Example</strong>: The Customer context might provide a customer lookup service that multiple other contexts can use to get customer information.</p>
<h3>6. Published Language</h3>
<p><strong>What it means</strong>: A well-documented, shared language is used for communication between contexts, often implemented as a shared data format or API specification.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Well-documented, shared language</li>
<li>Used for communication between contexts</li>
<li>Often implemented as shared formats</li>
<li>Provides consistency and clarity</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>Multiple contexts need to communicate</li>
<li>Communication needs to be standardized</li>
<li>Consistency is important</li>
<li>Language can be shared and documented</li>
</ul>
<p><strong>Example</strong>: A shared JSON schema might be used for customer data exchange between the Customer and Order contexts.</p>
<h2>Examples of Context Mapping</h2>
<h3>E-commerce System Example</h3>
<p><strong>Context Map</strong></p>
<pre><code>[Customer Context] --Customer-Supplier--&gt; [Order Context]
[Order Context] --Customer-Supplier--&gt; [Payment Context]
[Order Context] --Customer-Supplier--&gt; [Inventory Context]
[Order Context] --Customer-Supplier--&gt; [Shipping Context]
[Customer Context] --Open Host Service--&gt; [Marketing Context]
[Order Context] --Anti-Corruption Layer--&gt; [Legacy System]
</code></pre>
<p><strong>Relationship Details</strong></p>
<ul>
<li><strong>Customer-Order</strong>: Customer context provides customer information to Order context</li>
<li><strong>Order-Payment</strong>: Order context requests payment processing from Payment context</li>
<li><strong>Order-Inventory</strong>: Order context requests inventory updates from Inventory context</li>
<li><strong>Order-Shipping</strong>: Order context provides shipping information to Shipping context</li>
<li><strong>Customer-Marketing</strong>: Customer context provides customer data service to Marketing context</li>
<li><strong>Order-Legacy</strong>: Order context translates data for legacy system integration</li>
</ul>
<h3>Banking System Example</h3>
<p><strong>Context Map</strong></p>
<pre><code>[Account Management] --Shared Kernel--&gt; [Transaction Processing]
[Account Management] --Customer-Supplier--&gt; [Loan Processing]
[Transaction Processing] --Customer-Supplier--&gt; [Payment Processing]
[Account Management] --Open Host Service--&gt; [Reporting Context]
[Loan Processing] --Anti-Corruption Layer--&gt; [Credit Bureau]
</code></pre>
<p><strong>Relationship Details</strong></p>
<ul>
<li><strong>Account-Transaction</strong>: Shared kernel for account and transaction concepts</li>
<li><strong>Account-Loan</strong>: Account context provides account information to Loan context</li>
<li><strong>Transaction-Payment</strong>: Transaction context requests payment processing</li>
<li><strong>Account-Reporting</strong>: Account context provides account data service</li>
<li><strong>Loan-Credit Bureau</strong>: Loan context translates data for credit bureau integration</li>
</ul>
<h2>How This Concept Helps with System Design</h2>
<ol>
<li><strong>Clear Integration Points</strong>: Well-defined interfaces between contexts</li>
<li><strong>Manageable Complexity</strong>: Large systems broken into manageable pieces</li>
<li><strong>Team Autonomy</strong>: Teams can work independently on their contexts</li>
<li><strong>Predictable Behavior</strong>: Integration behavior is well-defined and predictable</li>
<li><strong>Scalable Architecture</strong>: System can grow by adding new contexts</li>
</ol>
<h2>How This Concept Helps with Development</h2>
<ol>
<li><strong>Independent Development</strong>: Teams can work on their contexts independently</li>
<li><strong>Clear Dependencies</strong>: Dependencies between contexts are explicit</li>
<li><strong>Easier Testing</strong>: Each context can be tested independently</li>
<li><strong>Better Coordination</strong>: Teams understand how their work affects others</li>
<li><strong>Faster Development</strong>: Reduced coordination overhead</li>
</ol>
<h2>Common Patterns and Anti-patterns</h2>
<h3>Patterns</h3>
<p><strong>Clear Relationship Patterns</strong></p>
<ul>
<li>Use established patterns for context relationships</li>
<li>Choose patterns based on relationship characteristics</li>
<li>Document relationship patterns and rationale</li>
</ul>
<p><strong>Stable Interfaces</strong></p>
<ul>
<li>Design interfaces to be stable and well-defined</li>
<li>Version interfaces for evolution</li>
<li>Provide clear documentation</li>
</ul>
<p><strong>Appropriate Coupling</strong></p>
<ul>
<li>Choose coupling level based on relationship needs</li>
<li>Balance independence with integration needs</li>
<li>Consider organizational constraints</li>
</ul>
<h3>Anti-patterns</h3>
<p><strong>Big Ball of Mud</strong></p>
<ul>
<li>No clear boundaries between contexts</li>
<li>Everything is connected to everything else</li>
<li>Difficult to understand or modify</li>
</ul>
<p><strong>Tight Coupling</strong></p>
<ul>
<li>Contexts are too tightly coupled</li>
<li>Changes cascade across boundaries</li>
<li>Teams can&#39;t work independently</li>
</ul>
<p><strong>Hidden Dependencies</strong></p>
<ul>
<li>Dependencies are not explicit or documented</li>
<li>Integration requirements are unclear</li>
<li>Changes have unexpected effects</li>
</ul>
<h2>Summary</h2>
<p>Context mapping is essential for managing the complexity of large systems with multiple bounded contexts. By identifying relationships, choosing appropriate patterns, and defining clear interfaces, teams can:</p>
<ul>
<li><strong>Manage integration complexity</strong> in large systems</li>
<li><strong>Enable team autonomy</strong> through clear boundaries</li>
<li><strong>Support system evolution</strong> through well-designed relationships</li>
<li><strong>Facilitate communication</strong> between different teams</li>
<li><strong>Build maintainable systems</strong> with clear integration points</li>
</ul>
<p>The key to successful context mapping is understanding the nature of relationships, choosing appropriate patterns, defining stable interfaces, handling data consistency, and planning for evolution. This creates a foundation for building large, maintainable systems.</p>
<h2>Exercise 1: Map Context Relationships</h2>
<h3>Objective</h3>
<p>Analyze a complex system and map the relationships between different bounded contexts.</p>
<h3>Task</h3>
<p>Choose a complex business domain and map the relationships between different bounded contexts.</p>
<ol>
<li><strong>Identify Contexts</strong>: List all bounded contexts in the system</li>
<li><strong>Map Relationships</strong>: Identify how contexts interact with each other</li>
<li><strong>Choose Patterns</strong>: Select appropriate relationship patterns for each interaction</li>
<li><strong>Document Dependencies</strong>: Map dependencies and data flow</li>
<li><strong>Create Context Map</strong>: Visualize the relationships between contexts</li>
</ol>
<h3>Deliverables</h3>
<ul>
<li>List of identified bounded contexts</li>
<li>Relationship analysis between contexts</li>
<li>Pattern selection for each relationship</li>
<li>Dependency mapping</li>
<li>Visual context map</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Choose a complex business domain</li>
<li>Identify all bounded contexts</li>
<li>Analyze how contexts interact</li>
<li>Choose appropriate relationship patterns</li>
<li>Create a visual map of relationships</li>
</ol>
<hr>
<h2>Exercise 2: Design Integration Interfaces</h2>
<h3>Objective</h3>
<p>Design integration interfaces for the mapped context relationships.</p>
<h3>Task</h3>
<p>Take the context relationships from Exercise 1 and design integration interfaces.</p>
<ol>
<li><strong>Design Interfaces</strong>: Create interfaces for each context relationship</li>
<li><strong>Define Data Formats</strong>: Specify data formats for communication</li>
<li><strong>Handle Errors</strong>: Design error handling and recovery</li>
<li><strong>Plan Consistency</strong>: Design data consistency strategies</li>
<li><strong>Document Integration</strong>: Create integration documentation</li>
</ol>
<h3>Success Criteria</h3>
<ul>
<li>Clear interfaces for each relationship</li>
<li>Well-defined data formats</li>
<li>Appropriate error handling</li>
<li>Data consistency strategies</li>
<li>Complete integration documentation</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Use your context relationships from Exercise 1</li>
<li>Design interfaces for each relationship</li>
<li>Define data formats and protocols</li>
<li>Plan error handling and recovery</li>
<li>Document integration requirements</li>
</ol>
<h3>Implementation Best Practices</h3>
<h4>Interface Design</h4>
<ol>
<li><strong>Stable Interfaces</strong>: Design interfaces to be stable and well-defined</li>
<li><strong>Clear Contracts</strong>: Define clear contracts for each interface</li>
<li><strong>Versioning</strong>: Plan for interface versioning and evolution</li>
<li><strong>Documentation</strong>: Provide clear documentation for each interface</li>
</ol>
<h4>Integration Patterns</h4>
<ol>
<li><strong>Appropriate Patterns</strong>: Choose patterns based on relationship characteristics</li>
<li><strong>Consistency Models</strong>: Choose appropriate consistency models</li>
<li><strong>Error Handling</strong>: Design robust error handling and recovery</li>
<li><strong>Performance</strong>: Consider performance implications of integration</li>
</ol>
<h3>Learning Objectives</h3>
<p>After completing both exercises, you should be able to:</p>
<ul>
<li>Map relationships between bounded contexts</li>
<li>Choose appropriate relationship patterns</li>
<li>Design integration interfaces</li>
<li>Handle data consistency across boundaries</li>
<li>Plan for system evolution</li>
</ul>
<h2>Implementation Patterns and Code Examples</h2>
<h3>Context Integration Implementation Patterns</h3>
<h4>1. Customer-Supplier Pattern Implementation</h4>
<p><strong>C# Example - Customer-Supplier Integration</strong></p>
<pre><code class="language-csharp">// Customer Context (Supplier)
namespace CustomerContext
{
    public interface ICustomerService
    {
        Task&lt;Customer&gt; GetCustomer(CustomerId customerId);
        Task&lt;bool&gt; IsCustomerActive(CustomerId customerId);
        Task&lt;CustomerProfile&gt; GetCustomerProfile(CustomerId customerId);
    }
    
    public class CustomerService : ICustomerService
    {
        private readonly ICustomerRepository _customerRepository;
        
        public CustomerService(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository ?? throw new ArgumentNullException(nameof(customerRepository));
        }
        
        public async Task&lt;Customer&gt; GetCustomer(CustomerId customerId)
        {
            var customer = await _customerRepository.FindById(customerId);
            if (customer == null)
            {
                throw new CustomerNotFoundException($&quot;Customer with ID {customerId} not found&quot;);
            }
            
            return customer;
        }
        
        public async Task&lt;bool&gt; IsCustomerActive(CustomerId customerId)
        {
            var customer = await GetCustomer(customerId);
            return customer.Status == CustomerStatus.Active;
        }
        
        public async Task&lt;CustomerProfile&gt; GetCustomerProfile(CustomerId customerId)
        {
            var customer = await GetCustomer(customerId);
            return new CustomerProfile
            {
                CustomerId = customer.Id,
                Name = customer.Name,
                Email = customer.Email,
                Status = customer.Status,
                CreatedAt = customer.CreatedAt
            };
        }
    }
    
    // Published language for customer data
    public class CustomerProfile
    {
        public CustomerId CustomerId { get; set; }
        public string Name { get; set; }
        public EmailAddress Email { get; set; }
        public CustomerStatus Status { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}

// Order Context (Customer)
namespace OrderContext
{
    public class OrderService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly ICustomerService _customerService; // Dependency on customer context
        
        public OrderService(IOrderRepository orderRepository, ICustomerService customerService)
        {
            _orderRepository = orderRepository ?? throw new ArgumentNullException(nameof(orderRepository));
            _customerService = customerService ?? throw new ArgumentNullException(nameof(customerService));
        }
        
        public async Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items)
        {
            // Validate customer exists and is active
            if (!await _customerService.IsCustomerActive(customerId))
            {
                throw new InvalidCustomerException($&quot;Customer {customerId} is not active&quot;);
            }
            
            // Get customer profile for order
            var customerProfile = await _customerService.GetCustomerProfile(customerId);
            
            // Create order
            var orderId = OrderId.Generate();
            var order = new Order(orderId, customerId);
            
            foreach (var item in items)
            {
                order.AddItem(item.ProductId, item.Price, item.Quantity);
            }
            
            order.Confirm();
            await _orderRepository.Save(order);
            
            return order;
        }
        
        public async Task&lt;Order&gt; GetOrderWithCustomerInfo(OrderId orderId)
        {
            var order = await _orderRepository.FindById(orderId);
            if (order == null)
            {
                throw new OrderNotFoundException($&quot;Order with ID {orderId} not found&quot;);
            }
            
            // Get customer information from customer context
            var customerProfile = await _customerService.GetCustomerProfile(order.CustomerId);
            
            // Return order with customer information
            return order;
        }
    }
}
</code></pre>
<p><strong>Java Example - Customer-Supplier Integration</strong></p>
<pre><code class="language-java">// Customer Context (Supplier)
package com.ecommerce.customer;

public interface CustomerService {
    Customer getCustomer(CustomerId customerId);
    boolean isCustomerActive(CustomerId customerId);
    CustomerProfile getCustomerProfile(CustomerId customerId);
}

@Service
public class CustomerServiceImpl implements CustomerService {
    private final CustomerRepository customerRepository;
    
    public CustomerServiceImpl(CustomerRepository customerRepository) {
        this.customerRepository = Objects.requireNonNull(customerRepository, &quot;Customer repository cannot be null&quot;);
    }
    
    @Override
    public Customer getCustomer(CustomerId customerId) {
        return customerRepository.findById(customerId)
            .orElseThrow(() -&gt; new CustomerNotFoundException(&quot;Customer with ID &quot; + customerId + &quot; not found&quot;));
    }
    
    @Override
    public boolean isCustomerActive(CustomerId customerId) {
        Customer customer = getCustomer(customerId);
        return customer.getStatus() == CustomerStatus.ACTIVE;
    }
    
    @Override
    public CustomerProfile getCustomerProfile(CustomerId customerId) {
        Customer customer = getCustomer(customerId);
        return CustomerProfile.builder()
            .customerId(customer.getId())
            .name(customer.getName())
            .email(customer.getEmail())
            .status(customer.getStatus())
            .createdAt(customer.getCreatedAt())
            .build();
    }
}

// Published language for customer data
@Data
@Builder
public class CustomerProfile {
    private CustomerId customerId;
    private String name;
    private EmailAddress email;
    private CustomerStatus status;
    private LocalDateTime createdAt;
}

// Order Context (Customer)
package com.ecommerce.order;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final CustomerService customerService; // Dependency on customer context
    
    public OrderService(OrderRepository orderRepository, CustomerService customerService) {
        this.orderRepository = Objects.requireNonNull(orderRepository, &quot;Order repository cannot be null&quot;);
        this.customerService = Objects.requireNonNull(customerService, &quot;Customer service cannot be null&quot;);
    }
    
    public Order createOrder(CustomerId customerId, List&lt;OrderItem&gt; items) {
        // Validate customer exists and is active
        if (!customerService.isCustomerActive(customerId)) {
            throw new InvalidCustomerException(&quot;Customer &quot; + customerId + &quot; is not active&quot;);
        }
        
        // Get customer profile for order
        CustomerProfile customerProfile = customerService.getCustomerProfile(customerId);
        
        // Create order
        OrderId orderId = OrderId.generate();
        Order order = new Order(orderId, customerId);
        
        for (OrderItem item : items) {
            order.addItem(item.getProductId(), item.getPrice(), item.getQuantity());
        }
        
        order.confirm();
        orderRepository.save(order);
        
        return order;
    }
    
    public Order getOrderWithCustomerInfo(OrderId orderId) {
        Order order = orderRepository.findById(orderId)
            .orElseThrow(() -&gt; new OrderNotFoundException(&quot;Order with ID &quot; + orderId + &quot; not found&quot;));
        
        // Get customer information from customer context
        CustomerProfile customerProfile = customerService.getCustomerProfile(order.getCustomerId());
        
        // Return order with customer information
        return order;
    }
}
</code></pre>
<h4>2. Anti-Corruption Layer Pattern Implementation</h4>
<p><strong>C# Example - Anti-Corruption Layer</strong></p>
<pre><code class="language-csharp">// Legacy System Integration
namespace OrderContext
{
    // Internal domain model
    public class Order
    {
        public OrderId Id { get; private set; }
        public CustomerId CustomerId { get; private set; }
        public OrderStatus Status { get; private set; }
        public Money TotalAmount { get; private set; }
        public List&lt;OrderItem&gt; Items { get; private set; }
        
        // Domain logic here...
    }
    
    // Anti-corruption layer for legacy system
    public class LegacyOrderAdapter
    {
        private readonly ILegacyOrderService _legacyOrderService;
        
        public LegacyOrderAdapter(ILegacyOrderService legacyOrderService)
        {
            _legacyOrderService = legacyOrderService ?? throw new ArgumentNullException(nameof(legacyOrderService));
        }
        
        public async Task&lt;Order&gt; GetOrderFromLegacySystem(string legacyOrderNumber)
        {
            // Get data from legacy system
            var legacyOrder = await _legacyOrderService.GetOrder(legacyOrderNumber);
            
            // Translate to domain model
            return TranslateToDomainModel(legacyOrder);
        }
        
        public async Task&lt;string&gt; CreateOrderInLegacySystem(Order order)
        {
            // Translate domain model to legacy format
            var legacyOrder = TranslateToLegacyFormat(order);
            
            // Create in legacy system
            var legacyOrderNumber = await _legacyOrderService.CreateOrder(legacyOrder);
            
            return legacyOrderNumber;
        }
        
        private Order TranslateToDomainModel(LegacyOrderData legacyOrder)
        {
            return new Order(
                new OrderId(legacyOrder.OrderNumber),
                new CustomerId(legacyOrder.CustomerCode)
            )
            {
                Status = MapStatus(legacyOrder.Status),
                TotalAmount = new Money(legacyOrder.Total, MapCurrency(legacyOrder.Currency)),
                Items = legacyOrder.Items.Select(item =&gt; new OrderItem(
                    new ProductId(item.ProductCode),
                    new Money(item.Price, MapCurrency(legacyOrder.Currency)),
                    item.Quantity
                )).ToList()
            };
        }
        
        private LegacyOrderData TranslateToLegacyFormat(Order order)
        {
            return new LegacyOrderData
            {
                OrderNumber = order.Id.Value,
                CustomerCode = order.CustomerId.Value,
                Status = MapStatusToLegacy(order.Status),
                Total = order.TotalAmount.Amount,
                Currency = MapCurrencyToLegacy(order.TotalAmount.Currency),
                Items = order.Items.Select(item =&gt; new LegacyOrderItemData
                {
                    ProductCode = item.ProductId.Value,
                    Price = item.Price.Amount,
                    Quantity = item.Quantity
                }).ToList()
            };
        }
        
        private OrderStatus MapStatus(string legacyStatus)
        {
            return legacyStatus switch
            {
                &quot;PENDING&quot; =&gt; OrderStatus.Draft,
                &quot;CONFIRMED&quot; =&gt; OrderStatus.Confirmed,
                &quot;SHIPPED&quot; =&gt; OrderStatus.Shipped,
                &quot;DELIVERED&quot; =&gt; OrderStatus.Delivered,
                &quot;CANCELLED&quot; =&gt; OrderStatus.Cancelled,
                _ =&gt; OrderStatus.Draft
            };
        }
        
        private string MapStatusToLegacy(OrderStatus status)
        {
            return status switch
            {
                OrderStatus.Draft =&gt; &quot;PENDING&quot;,
                OrderStatus.Confirmed =&gt; &quot;CONFIRMED&quot;,
                OrderStatus.Shipped =&gt; &quot;SHIPPED&quot;,
                OrderStatus.Delivered =&gt; &quot;DELIVERED&quot;,
                OrderStatus.Cancelled =&gt; &quot;CANCELLED&quot;,
                _ =&gt; &quot;PENDING&quot;
            };
        }
        
        private Currency MapCurrency(string legacyCurrency)
        {
            return legacyCurrency switch
            {
                &quot;USD&quot; =&gt; Currency.USD,
                &quot;EUR&quot; =&gt; Currency.EUR,
                &quot;GBP&quot; =&gt; Currency.GBP,
                _ =&gt; Currency.USD
            };
        }
        
        private string MapCurrencyToLegacy(Currency currency)
        {
            return currency switch
            {
                Currency.USD =&gt; &quot;USD&quot;,
                Currency.EUR =&gt; &quot;EUR&quot;,
                Currency.GBP =&gt; &quot;GBP&quot;,
                _ =&gt; &quot;USD&quot;
            };
        }
    }
    
    // Legacy system data contracts
    public class LegacyOrderData
    {
        public string OrderNumber { get; set; }
        public string CustomerCode { get; set; }
        public string Status { get; set; }
        public decimal Total { get; set; }
        public string Currency { get; set; }
        public List&lt;LegacyOrderItemData&gt; Items { get; set; }
    }
    
    public class LegacyOrderItemData
    {
        public string ProductCode { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
    }
}
</code></pre>
<p><strong>TypeScript Example - Anti-Corruption Layer</strong></p>
<pre><code class="language-typescript">// Legacy System Integration
export namespace OrderContext {
    // Internal domain model
    export class Order {
        private readonly id: OrderId;
        private readonly customerId: CustomerId;
        private status: OrderStatus;
        private totalAmount: Money;
        private readonly items: OrderItem[] = [];
        
        constructor(id: OrderId, customerId: CustomerId) {
            this.id = id;
            this.customerId = customerId;
            this.status = OrderStatus.Draft;
            this.totalAmount = Money.zero();
        }
        
        // Domain logic here...
    }
    
    // Anti-corruption layer for legacy system
    export class LegacyOrderAdapter {
        constructor(private legacyOrderService: ILegacyOrderService) {}
        
        async getOrderFromLegacySystem(legacyOrderNumber: string): Promise&lt;Order&gt; {
            // Get data from legacy system
            const legacyOrder = await this.legacyOrderService.getOrder(legacyOrderNumber);
            
            // Translate to domain model
            return this.translateToDomainModel(legacyOrder);
        }
        
        async createOrderInLegacySystem(order: Order): Promise&lt;string&gt; {
            // Translate domain model to legacy format
            const legacyOrder = this.translateToLegacyFormat(order);
            
            // Create in legacy system
            const legacyOrderNumber = await this.legacyOrderService.createOrder(legacyOrder);
            
            return legacyOrderNumber;
        }
        
        private translateToDomainModel(legacyOrder: LegacyOrderData): Order {
            const order = new Order(
                new OrderId(legacyOrder.orderNumber),
                new CustomerId(legacyOrder.customerCode)
            );
            
            order.status = this.mapStatus(legacyOrder.status);
            order.totalAmount = new Money(legacyOrder.total, this.mapCurrency(legacyOrder.currency));
            order.items = legacyOrder.items.map(item =&gt; new OrderItem(
                new ProductId(item.productCode),
                new Money(item.price, this.mapCurrency(legacyOrder.currency)),
                item.quantity
            ));
            
            return order;
        }
        
        private translateToLegacyFormat(order: Order): LegacyOrderData {
            return {
                orderNumber: order.getId().getValue(),
                customerCode: order.getCustomerId().getValue(),
                status: this.mapStatusToLegacy(order.getStatus()),
                total: order.getTotalAmount().getAmount(),
                currency: this.mapCurrencyToLegacy(order.getTotalAmount().getCurrency()),
                items: order.getItems().map(item =&gt; ({
                    productCode: item.getProductId().getValue(),
                    price: item.getPrice().getAmount(),
                    quantity: item.getQuantity()
                }))
            };
        }
        
        private mapStatus(legacyStatus: string): OrderStatus {
            switch (legacyStatus) {
                case &quot;PENDING&quot;: return OrderStatus.Draft;
                case &quot;CONFIRMED&quot;: return OrderStatus.Confirmed;
                case &quot;SHIPPED&quot;: return OrderStatus.Shipped;
                case &quot;DELIVERED&quot;: return OrderStatus.Delivered;
                case &quot;CANCELLED&quot;: return OrderStatus.Cancelled;
                default: return OrderStatus.Draft;
            }
        }
        
        private mapStatusToLegacy(status: OrderStatus): string {
            switch (status) {
                case OrderStatus.Draft: return &quot;PENDING&quot;;
                case OrderStatus.Confirmed: return &quot;CONFIRMED&quot;;
                case OrderStatus.Shipped: return &quot;SHIPPED&quot;;
                case OrderStatus.Delivered: return &quot;DELIVERED&quot;;
                case OrderStatus.Cancelled: return &quot;CANCELLED&quot;;
                default: return &quot;PENDING&quot;;
            }
        }
        
        private mapCurrency(legacyCurrency: string): Currency {
            switch (legacyCurrency) {
                case &quot;USD&quot;: return Currency.USD;
                case &quot;EUR&quot;: return Currency.EUR;
                case &quot;GBP&quot;: return Currency.GBP;
                default: return Currency.USD;
            }
        }
        
        private mapCurrencyToLegacy(currency: Currency): string {
            switch (currency) {
                case Currency.USD: return &quot;USD&quot;;
                case Currency.EUR: return &quot;EUR&quot;;
                case Currency.GBP: return &quot;GBP&quot;;
                default: return &quot;USD&quot;;
            }
        }
    }
    
    // Legacy system data contracts
    export interface LegacyOrderData {
        orderNumber: string;
        customerCode: string;
        status: string;
        total: number;
        currency: string;
        items: LegacyOrderItemData[];
    }
    
    export interface LegacyOrderItemData {
        productCode: string;
        price: number;
        quantity: number;
    }
}
</code></pre>
<h4>3. Published Language Pattern Implementation</h4>
<p><strong>C# Example - Published Language</strong></p>
<pre><code class="language-csharp">// Shared Contracts for Context Communication
namespace SharedContracts
{
    // Published language for customer data exchange
    public class CustomerDataContract
    {
        public string CustomerId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
    
    // Published language for order events
    public class OrderEventContract
    {
        public string OrderId { get; set; }
        public string CustomerId { get; set; }
        public string EventType { get; set; }
        public DateTime Timestamp { get; set; }
        public Dictionary&lt;string, object&gt; Data { get; set; }
    }
    
    // Published language for product data exchange
    public class ProductDataContract
    {
        public string ProductId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public string Currency { get; set; }
        public string Category { get; set; }
        public bool IsActive { get; set; }
    }
}

// Usage in Order context
namespace OrderContext
{
    public class OrderEventPublisher
    {
        private readonly IEventBus _eventBus;
        
        public OrderEventPublisher(IEventBus eventBus)
        {
            _eventBus = eventBus ?? throw new ArgumentNullException(nameof(eventBus));
        }
        
        public async Task PublishOrderConfirmed(Order order)
        {
            var eventData = new OrderEventContract
            {
                OrderId = order.Id.Value,
                CustomerId = order.CustomerId.Value,
                EventType = &quot;OrderConfirmed&quot;,
                Timestamp = DateTime.UtcNow,
                Data = new Dictionary&lt;string, object&gt;
                {
                    [&quot;TotalAmount&quot;] = order.TotalAmount.Amount,
                    [&quot;Currency&quot;] = order.TotalAmount.Currency.Code,
                    [&quot;ItemCount&quot;] = order.Items.Count
                }
            };
            
            await _eventBus.PublishAsync(&quot;order.confirmed&quot;, eventData);
        }
        
        public async Task PublishOrderShipped(Order order, string trackingNumber)
        {
            var eventData = new OrderEventContract
            {
                OrderId = order.Id.Value,
                CustomerId = order.CustomerId.Value,
                EventType = &quot;OrderShipped&quot;,
                Timestamp = DateTime.UtcNow,
                Data = new Dictionary&lt;string, object&gt;
                {
                    [&quot;TrackingNumber&quot;] = trackingNumber,
                    [&quot;ShippedAt&quot;] = DateTime.UtcNow
                }
            };
            
            await _eventBus.PublishAsync(&quot;order.shipped&quot;, eventData);
        }
    }
    
    public class OrderService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly OrderEventPublisher _eventPublisher;
        
        public OrderService(IOrderRepository orderRepository, OrderEventPublisher eventPublisher)
        {
            _orderRepository = orderRepository ?? throw new ArgumentNullException(nameof(orderRepository));
            _eventPublisher = eventPublisher ?? throw new ArgumentNullException(nameof(eventPublisher));
        }
        
        public async Task&lt;Order&gt; ConfirmOrder(OrderId orderId)
        {
            var order = await _orderRepository.FindById(orderId);
            if (order == null)
            {
                throw new OrderNotFoundException($&quot;Order with ID {orderId} not found&quot;);
            }
            
            order.Confirm();
            await _orderRepository.Save(order);
            
            // Publish event using published language
            await _eventPublisher.PublishOrderConfirmed(order);
            
            return order;
        }
    }
}

// Usage in Customer context
namespace CustomerContext
{
    public class CustomerEventSubscriber
    {
        private readonly ICustomerRepository _customerRepository;
        
        public CustomerEventSubscriber(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository ?? throw new ArgumentNullException(nameof(customerRepository));
        }
        
        public async Task HandleOrderConfirmed(OrderEventContract eventData)
        {
            var customerId = new CustomerId(eventData.CustomerId);
            var customer = await _customerRepository.FindById(customerId);
            
            if (customer != null)
            {
                // Update customer statistics
                customer.IncrementOrderCount();
                await _customerRepository.Save(customer);
            }
        }
    }
}
</code></pre>
<h4>4. Shared Kernel Pattern Implementation</h4>
<p><strong>C# Example - Shared Kernel</strong></p>
<pre><code class="language-csharp">// Shared Kernel - Common concepts used by multiple contexts
namespace SharedKernel
{
    // Shared value objects
    public class Money
    {
        public decimal Amount { get; private set; }
        public Currency Currency { get; private set; }
        
        public Money(decimal amount, Currency currency)
        {
            if (amount &lt; 0)
                throw new ArgumentException(&quot;Amount cannot be negative&quot;);
                
            Amount = amount;
            Currency = currency ?? throw new ArgumentNullException(nameof(currency));
        }
        
        public Money Add(Money other)
        {
            if (other == null) throw new ArgumentNullException(nameof(other));
            if (Currency != other.Currency)
                throw new InvalidOperationException(&quot;Cannot add different currencies&quot;);
                
            return new Money(Amount + other.Amount, Currency);
        }
        
        public Money Multiply(decimal factor)
        {
            if (factor &lt; 0)
                throw new ArgumentException(&quot;Factor cannot be negative&quot;);
                
            return new Money(Amount * factor, Currency);
        }
        
        public override bool Equals(object obj)
        {
            return obj is Money other &amp;&amp; 
                   Amount == other.Amount &amp;&amp; 
                   Currency == other.Currency;
        }
        
        public override int GetHashCode()
        {
            return HashCode.Combine(Amount, Currency);
        }
        
        public static Money Zero(Currency currency) =&gt; new Money(0, currency);
    }
    
    public enum Currency
    {
        USD,
        EUR,
        GBP,
        JPY
    }
    
    // Shared identifiers
    public class CustomerId
    {
        public string Value { get; private set; }
        
        public CustomerId(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException(&quot;Customer ID cannot be null or empty&quot;);
                
            Value = value;
        }
        
        public static CustomerId Generate() =&gt; new CustomerId(Guid.NewGuid().ToString());
        
        public override bool Equals(object obj)
        {
            return obj is CustomerId other &amp;&amp; Value == other.Value;
        }
        
        public override int GetHashCode()
        {
            return Value.GetHashCode();
        }
        
        public override string ToString() =&gt; Value;
    }
    
    public class OrderId
    {
        public string Value { get; private set; }
        
        public OrderId(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException(&quot;Order ID cannot be null or empty&quot;);
                
            Value = value;
        }
        
        public static OrderId Generate() =&gt; new OrderId(Guid.NewGuid().ToString());
        
        public override bool Equals(object obj)
        {
            return obj is OrderId other &amp;&amp; Value == other.Value;
        }
        
        public override int GetHashCode()
        {
            return Value.GetHashCode();
        }
        
        public override string ToString() =&gt; Value;
    }
    
    public class ProductId
    {
        public string Value { get; private set; }
        
        public ProductId(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException(&quot;Product ID cannot be null or empty&quot;);
                
            Value = value;
        }
        
        public static ProductId Generate() =&gt; new ProductId(Guid.NewGuid().ToString());
        
        public override bool Equals(object obj)
        {
            return obj is ProductId other &amp;&amp; Value == other.Value;
        }
        
        public override int GetHashCode()
        {
            return Value.GetHashCode();
        }
        
        public override string ToString() =&gt; Value;
    }
}

// Usage in Customer Context
namespace CustomerContext
{
    public class Customer
    {
        public CustomerId Id { get; private set; }
        public string Name { get; private set; }
        public EmailAddress Email { get; private set; }
        public CustomerStatus Status { get; private set; }
        public Money TotalSpent { get; private set; } // Uses shared Money
        
        public Customer(CustomerId id, string name, EmailAddress email)
        {
            Id = id ?? throw new ArgumentNullException(nameof(id));
            Name = name ?? throw new ArgumentNullException(nameof(name));
            Email = email ?? throw new ArgumentNullException(nameof(email));
            Status = CustomerStatus.Active;
            TotalSpent = Money.Zero(Currency.USD); // Uses shared Money and Currency
        }
        
        public void AddToTotalSpent(Money amount)
        {
            if (amount == null) throw new ArgumentNullException(nameof(amount));
            TotalSpent = TotalSpent.Add(amount);
        }
    }
}

// Usage in Order Context
namespace OrderContext
{
    public class Order
    {
        public OrderId Id { get; private set; }
        public CustomerId CustomerId { get; private set; } // Uses shared CustomerId
        public OrderStatus Status { get; private set; }
        public Money TotalAmount { get; private set; } // Uses shared Money
        private readonly List&lt;OrderItem&gt; _items = new List&lt;OrderItem&gt;();
        
        public Order(OrderId id, CustomerId customerId)
        {
            Id = id ?? throw new ArgumentNullException(nameof(id));
            CustomerId = customerId ?? throw new ArgumentNullException(nameof(customerId));
            Status = OrderStatus.Draft;
            TotalAmount = Money.Zero(Currency.USD); // Uses shared Money and Currency
        }
        
        public void AddItem(ProductId productId, Money price, int quantity)
        {
            if (productId == null) throw new ArgumentNullException(nameof(productId));
            if (price == null) throw new ArgumentNullException(nameof(price));
            
            var item = new OrderItem(productId, price, quantity);
            _items.Add(item);
            RecalculateTotal();
        }
        
        private void RecalculateTotal()
        {
            TotalAmount = _items.Aggregate(Money.Zero(Currency.USD), (total, item) =&gt; total.Add(item.TotalPrice));
        }
    }
    
    public class OrderItem
    {
        public ProductId ProductId { get; private set; } // Uses shared ProductId
        public Money Price { get; private set; } // Uses shared Money
        public int Quantity { get; private set; }
        
        public OrderItem(ProductId productId, Money price, int quantity)
        {
            ProductId = productId ?? throw new ArgumentNullException(nameof(productId));
            Price = price ?? throw new ArgumentNullException(nameof(price));
            Quantity = quantity;
        }
        
        public Money TotalPrice =&gt; Price.Multiply(Quantity);
    }
}
</code></pre>
<h3>5. Context Integration Testing Patterns</h3>
<p><strong>C# Example - Integration Testing</strong></p>
<pre><code class="language-csharp">// Integration tests for context relationships
namespace EcommerceApp.Tests.Integration
{
    [TestClass]
    public class ContextIntegrationTests
    {
        private ICustomerService _customerService;
        private IOrderService _orderService;
        private IProductService _productService;
        
        [TestInitialize]
        public void Setup()
        {
            // Setup test dependencies
            _customerService = new CustomerService(new InMemoryCustomerRepository());
            _orderService = new OrderService(new InMemoryOrderRepository(), _customerService);
            _productService = new ProductService(new InMemoryProductRepository());
        }
        
        [TestMethod]
        public async Task CreateOrder_WithValidCustomer_ShouldSucceed()
        {
            // Arrange
            var customer = await _customerService.RegisterCustomer(&quot;John Doe&quot;, new EmailAddress(&quot;john@example.com&quot;));
            var product = await _productService.CreateProduct(&quot;Test Product&quot;, new Money(10.00m, Currency.USD));
            
            // Act
            var order = await _orderService.CreateOrder(customer.Id, new List&lt;OrderItem&gt;
            {
                new OrderItem(product.Id, product.Price, 2)
            });
            
            // Assert
            Assert.IsNotNull(order);
            Assert.AreEqual(customer.Id, order.CustomerId);
            Assert.AreEqual(OrderStatus.Confirmed, order.Status);
            Assert.AreEqual(new Money(20.00m, Currency.USD), order.TotalAmount);
        }
        
        [TestMethod]
        public async Task CreateOrder_WithInactiveCustomer_ShouldFail()
        {
            // Arrange
            var customer = await _customerService.RegisterCustomer(&quot;John Doe&quot;, new EmailAddress(&quot;john@example.com&quot;));
            customer.Deactivate();
            
            // Act &amp; Assert
            await Assert.ThrowsExceptionAsync&lt;InvalidCustomerException&gt;(async () =&gt;
            {
                await _orderService.CreateOrder(customer.Id, new List&lt;OrderItem&gt;());
            });
        }
        
        [TestMethod]
        public async Task OrderConfirmation_ShouldUpdateCustomerStatistics()
        {
            // Arrange
            var customer = await _customerService.RegisterCustomer(&quot;John Doe&quot;, new EmailAddress(&quot;john@example.com&quot;));
            var order = await _orderService.CreateOrder(customer.Id, new List&lt;OrderItem&gt;());
            
            // Act
            await _orderService.ConfirmOrder(order.Id);
            
            // Assert
            var updatedCustomer = await _customerService.GetCustomer(customer.Id);
            Assert.AreEqual(1, updatedCustomer.OrderCount);
            Assert.AreEqual(order.TotalAmount, updatedCustomer.TotalSpent);
        }
    }
}
</code></pre>
<h3>6. Context Monitoring and Health Checks</h3>
<p><strong>C# Example - Context Health Monitoring</strong></p>
<pre><code class="language-csharp">// Context health monitoring
namespace EcommerceApp.Infrastructure.Monitoring
{
    public class ContextHealthChecker
    {
        private readonly ICustomerService _customerService;
        private readonly IOrderService _orderService;
        private readonly IProductService _productService;
        
        public ContextHealthChecker(
            ICustomerService customerService,
            IOrderService orderService,
            IProductService productService)
        {
            _customerService = customerService ?? throw new ArgumentNullException(nameof(customerService));
            _orderService = orderService ?? throw new ArgumentNullException(nameof(orderService));
            _productService = productService ?? throw new ArgumentNullException(nameof(productService));
        }
        
        public async Task&lt;ContextHealthReport&gt; CheckHealth()
        {
            var report = new ContextHealthReport
            {
                Timestamp = DateTime.UtcNow,
                Contexts = new List&lt;ContextHealth&gt;()
            };
            
            // Check Customer Context
            var customerHealth = await CheckCustomerContextHealth();
            report.Contexts.Add(customerHealth);
            
            // Check Order Context
            var orderHealth = await CheckOrderContextHealth();
            report.Contexts.Add(orderHealth);
            
            // Check Product Context
            var productHealth = await CheckProductContextHealth();
            report.Contexts.Add(productHealth);
            
            // Check Context Integration
            var integrationHealth = await CheckContextIntegrationHealth();
            report.Contexts.Add(integrationHealth);
            
            return report;
        }
        
        private async Task&lt;ContextHealth&gt; CheckCustomerContextHealth()
        {
            try
            {
                var startTime = DateTime.UtcNow;
                var customer = await _customerService.GetCustomer(CustomerId.Generate());
                var responseTime = DateTime.UtcNow - startTime;
                
                return new ContextHealth
                {
                    ContextName = &quot;Customer&quot;,
                    Status = &quot;Healthy&quot;,
                    ResponseTime = responseTime,
                    LastChecked = DateTime.UtcNow
                };
            }
            catch (Exception ex)
            {
                return new ContextHealth
                {
                    ContextName = &quot;Customer&quot;,
                    Status = &quot;Unhealthy&quot;,
                    Error = ex.Message,
                    LastChecked = DateTime.UtcNow
                };
            }
        }
        
        private async Task&lt;ContextHealth&gt; CheckOrderContextHealth()
        {
            try
            {
                var startTime = DateTime.UtcNow;
                var order = await _orderService.GetOrder(OrderId.Generate());
                var responseTime = DateTime.UtcNow - startTime;
                
                return new ContextHealth
                {
                    ContextName = &quot;Order&quot;,
                    Status = &quot;Healthy&quot;,
                    ResponseTime = responseTime,
                    LastChecked = DateTime.UtcNow
                };
            }
            catch (Exception ex)
            {
                return new ContextHealth
                {
                    ContextName = &quot;Order&quot;,
                    Status = &quot;Unhealthy&quot;,
                    Error = ex.Message,
                    LastChecked = DateTime.UtcNow
                };
            }
        }
        
        private async Task&lt;ContextHealth&gt; CheckProductContextHealth()
        {
            try
            {
                var startTime = DateTime.UtcNow;
                var product = await _productService.GetProduct(ProductId.Generate());
                var responseTime = DateTime.UtcNow - startTime;
                
                return new ContextHealth
                {
                    ContextName = &quot;Product&quot;,
                    Status = &quot;Healthy&quot;,
                    ResponseTime = responseTime,
                    LastChecked = DateTime.UtcNow
                };
            }
            catch (Exception ex)
            {
                return new ContextHealth
                {
                    ContextName = &quot;Product&quot;,
                    Status = &quot;Unhealthy&quot;,
                    Error = ex.Message,
                    LastChecked = DateTime.UtcNow
                };
            }
        }
        
        private async Task&lt;ContextHealth&gt; CheckContextIntegrationHealth()
        {
            try
            {
                var startTime = DateTime.UtcNow;
                
                // Test cross-context integration
                var customer = await _customerService.RegisterCustomer(&quot;Test Customer&quot;, new EmailAddress(&quot;test@example.com&quot;));
                var product = await _productService.CreateProduct(&quot;Test Product&quot;, new Money(10.00m, Currency.USD));
                var order = await _orderService.CreateOrder(customer.Id, new List&lt;OrderItem&gt;
                {
                    new OrderItem(product.Id, product.Price, 1)
                });
                
                var responseTime = DateTime.UtcNow - startTime;
                
                return new ContextHealth
                {
                    ContextName = &quot;Integration&quot;,
                    Status = &quot;Healthy&quot;,
                    ResponseTime = responseTime,
                    LastChecked = DateTime.UtcNow
                };
            }
            catch (Exception ex)
            {
                return new ContextHealth
                {
                    ContextName = &quot;Integration&quot;,
                    Status = &quot;Unhealthy&quot;,
                    Error = ex.Message,
                    LastChecked = DateTime.UtcNow
                };
            }
        }
    }
    
    public class ContextHealthReport
    {
        public DateTime Timestamp { get; set; }
        public List&lt;ContextHealth&gt; Contexts { get; set; }
    }
    
    public class ContextHealth
    {
        public string ContextName { get; set; }
        public string Status { get; set; }
        public TimeSpan ResponseTime { get; set; }
        public string Error { get; set; }
        public DateTime LastChecked { get; set; }
    }
}
</code></pre>
<h2>Common Pitfalls and How to Avoid Them</h2>
<h3>1. Tight Coupling Between Contexts</h3>
<p><strong>Problem</strong>: Contexts become too tightly coupled</p>
<pre><code class="language-csharp">// Bad - Tight coupling
namespace OrderContext
{
    public class Order
    {
        public Customer Customer { get; set; } // Direct reference to customer
        public Product Product { get; set; }   // Direct reference to product
        // Order knows too much about other contexts
    }
}
</code></pre>
<p><strong>Solution</strong>: Use references and interfaces</p>
<pre><code class="language-csharp">// Good - Loose coupling
namespace OrderContext
{
    public class Order
    {
        public OrderId Id { get; private set; }
        public CustomerId CustomerId { get; private set; } // Reference only
        public List&lt;OrderItem&gt; Items { get; private set; } // Owned by order context
        
        // Order only knows about its own concepts
    }
}
</code></pre>
<h3>2. Inconsistent Data Models</h3>
<p><strong>Problem</strong>: Same concept represented differently across contexts</p>
<pre><code class="language-csharp">// Bad - Inconsistent models
namespace CustomerContext
{
    public class Customer
    {
        public string Id { get; set; }
        public string Name { get; set; }
    }
}

namespace OrderContext
{
    public class Customer
    {
        public int CustomerId { get; set; }
        public string CustomerName { get; set; }
        public string Email { get; set; }
    }
}
</code></pre>
<p><strong>Solution</strong>: Use shared kernel or published language</p>
<pre><code class="language-csharp">// Good - Consistent models
namespace SharedKernel
{
    public class CustomerId
    {
        public string Value { get; private set; }
        public CustomerId(string value) { Value = value; }
    }
}

namespace CustomerContext
{
    public class Customer
    {
        public CustomerId Id { get; private set; }
        public string Name { get; private set; }
        public EmailAddress Email { get; private set; }
    }
}

namespace OrderContext
{
    public class Order
    {
        public OrderId Id { get; private set; }
        public CustomerId CustomerId { get; private set; } // Uses shared CustomerId
        // Order doesn&#39;t need full customer details
    }
}
</code></pre>
<h3>3. Poor Error Handling Across Contexts</h3>
<p><strong>Problem</strong>: Errors are not handled properly across context boundaries</p>
<pre><code class="language-csharp">// Bad - Poor error handling
namespace OrderContext
{
    public class OrderService
    {
        public async Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items)
        {
            var customer = await _customerService.GetCustomer(customerId);
            // What if customer service is down?
            // What if customer doesn&#39;t exist?
            
            var order = new Order(OrderId.Generate(), customerId);
            // Implementation...
        }
    }
}
</code></pre>
<p><strong>Solution</strong>: Implement proper error handling</p>
<pre><code class="language-csharp">// Good - Proper error handling
namespace OrderContext
{
    public class OrderService
    {
        public async Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items)
        {
            try
            {
                var customer = await _customerService.GetCustomer(customerId);
                if (customer == null)
                {
                    throw new CustomerNotFoundException($&quot;Customer with ID {customerId} not found&quot;);
                }
                
                if (customer.Status != CustomerStatus.Active)
                {
                    throw new InvalidCustomerException($&quot;Customer {customerId} is not active&quot;);
                }
                
                var order = new Order(OrderId.Generate(), customerId);
                // Implementation...
                
                return order;
            }
            catch (CustomerServiceException ex)
            {
                throw new OrderCreationException(&quot;Failed to create order due to customer service error&quot;, ex);
            }
            catch (Exception ex)
            {
                throw new OrderCreationException(&quot;Failed to create order&quot;, ex);
            }
        }
    }
}
</code></pre>
<h3>4. Lack of Context Monitoring</h3>
<p><strong>Problem</strong>: No visibility into context health and performance</p>
<pre><code class="language-csharp">// Bad - No monitoring
namespace OrderContext
{
    public class OrderService
    {
        public async Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items)
        {
            // No monitoring or logging
            var order = new Order(OrderId.Generate(), customerId);
            // Implementation...
        }
    }
}
</code></pre>
<p><strong>Solution</strong>: Implement comprehensive monitoring</p>
<pre><code class="language-csharp">// Good - Comprehensive monitoring
namespace OrderContext
{
    public class OrderService
    {
        private readonly ILogger&lt;OrderService&gt; _logger;
        private readonly IMetricsCollector _metricsCollector;
        
        public OrderService(ILogger&lt;OrderService&gt; logger, IMetricsCollector metricsCollector)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _metricsCollector = metricsCollector ?? throw new ArgumentNullException(nameof(metricsCollector));
        }
        
        public async Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items)
        {
            using var activity = _metricsCollector.StartActivity(&quot;OrderService.CreateOrder&quot;);
            
            try
            {
                _logger.LogInformation(&quot;Creating order for customer {CustomerId}&quot;, customerId);
                
                var order = new Order(OrderId.Generate(), customerId);
                // Implementation...
                
                _metricsCollector.IncrementCounter(&quot;orders.created&quot;);
                _logger.LogInformation(&quot;Order {OrderId} created successfully&quot;, order.Id);
                
                return order;
            }
            catch (Exception ex)
            {
                _metricsCollector.IncrementCounter(&quot;orders.creation.failed&quot;);
                _logger.LogError(ex, &quot;Failed to create order for customer {CustomerId}&quot;, customerId);
                throw;
            }
        }
    }
}
</code></pre>
<h2>Advanced Topics</h2>
<h3>1. Context Versioning and Evolution</h3>
<p><strong>C# Example - Context Versioning</strong></p>
<pre><code class="language-csharp">// Context versioning
namespace OrderContext.V1
{
    public interface IOrderService
    {
        Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items);
    }
}

namespace OrderContext.V2
{
    public interface IOrderService
    {
        Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items, ShippingAddress shippingAddress);
    }
}

// Versioned context implementation
namespace OrderContext
{
    public class VersionedOrderService : IOrderService
    {
        private readonly IOrderServiceV1 _orderServiceV1;
        private readonly IOrderServiceV2 _orderServiceV2;
        
        public VersionedOrderService(IOrderServiceV1 orderServiceV1, IOrderServiceV2 orderServiceV2)
        {
            _orderServiceV1 = orderServiceV1 ?? throw new ArgumentNullException(nameof(orderServiceV1));
            _orderServiceV2 = orderServiceV2 ?? throw new ArgumentNullException(nameof(orderServiceV2));
        }
        
        public async Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items, ShippingAddress shippingAddress = null)
        {
            if (shippingAddress != null)
            {
                return await _orderServiceV2.CreateOrder(customerId, items, shippingAddress);
            }
            else
            {
                return await _orderServiceV1.CreateOrder(customerId, items);
            }
        }
    }
}
</code></pre>
<h3>2. Context Performance Optimization</h3>
<p><strong>C# Example - Performance Optimization</strong></p>
<pre><code class="language-csharp">// Context performance optimization
namespace OrderContext
{
    public class OptimizedOrderService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly ICustomerService _customerService;
        private readonly IProductService _productService;
        private readonly ICache _cache;
        
        public OptimizedOrderService(
            IOrderRepository orderRepository,
            ICustomerService customerService,
            IProductService productService,
            ICache cache)
        {
            _orderRepository = orderRepository ?? throw new ArgumentNullException(nameof(orderRepository));
            _customerService = customerService ?? throw new ArgumentNullException(nameof(customerService));
            _productService = productService ?? throw new ArgumentNullException(nameof(productService));
            _cache = cache ?? throw new ArgumentNullException(nameof(cache));
        }
        
        public async Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items)
        {
            // Cache customer validation
            var cacheKey = $&quot;customer:{customerId}:active&quot;;
            var isCustomerActive = await _cache.GetAsync&lt;bool&gt;(cacheKey);
            
            if (!isCustomerActive.HasValue)
            {
                isCustomerActive = await _customerService.IsCustomerActive(customerId);
                await _cache.SetAsync(cacheKey, isCustomerActive.Value, TimeSpan.FromMinutes(5));
            }
            
            if (!isCustomerActive.Value)
            {
                throw new InvalidCustomerException($&quot;Customer {customerId} is not active&quot;);
            }
            
            // Batch product validation
            var productIds = items.Select(item =&gt; item.ProductId).ToList();
            var products = await _productService.GetProducts(productIds);
            
            // Create order
            var order = new Order(OrderId.Generate(), customerId);
            foreach (var item in items)
            {
                var product = products.FirstOrDefault(p =&gt; p.Id == item.ProductId);
                if (product == null)
                {
                    throw new ProductNotFoundException($&quot;Product {item.ProductId} not found&quot;);
                }
                
                order.AddItem(item.ProductId, product.Price, item.Quantity);
            }
            
            order.Confirm();
            await _orderRepository.Save(order);
            
            return order;
        }
    }
}
</code></pre>
<h3>3. Context Security and Authorization</h3>
<p><strong>C# Example - Context Security</strong></p>
<pre><code class="language-csharp">// Context security and authorization
namespace OrderContext
{
    public class SecureOrderService
    {
        private readonly IOrderRepository _orderRepository;
        private readonly ICustomerService _customerService;
        private readonly IAuthorizationService _authorizationService;
        private readonly IAuditLogger _auditLogger;
        
        public SecureOrderService(
            IOrderRepository orderRepository,
            ICustomerService customerService,
            IAuthorizationService authorizationService,
            IAuditLogger auditLogger)
        {
            _orderRepository = orderRepository ?? throw new ArgumentNullException(nameof(orderRepository));
            _customerService = customerService ?? throw new ArgumentNullException(nameof(customerService));
            _authorizationService = authorizationService ?? throw new ArgumentNullException(nameof(authorizationService));
            _auditLogger = auditLogger ?? throw new ArgumentNullException(nameof(auditLogger));
        }
        
        public async Task&lt;Order&gt; CreateOrder(CustomerId customerId, List&lt;OrderItem&gt; items, string userId)
        {
            // Check authorization
            if (!await _authorizationService.CanCreateOrder(userId, customerId))
            {
                throw new UnauthorizedException($&quot;User {userId} is not authorized to create orders for customer {customerId}&quot;);
            }
            
            // Validate customer
            var customer = await _customerService.GetCustomer(customerId);
            if (customer == null)
            {
                throw new CustomerNotFoundException($&quot;Customer with ID {customerId} not found&quot;);
            }
            
            // Create order
            var order = new Order(OrderId.Generate(), customerId);
            foreach (var item in items)
            {
                order.AddItem(item.ProductId, item.Price, item.Quantity);
            }
            
            order.Confirm();
            await _orderRepository.Save(order);
            
            // Audit log
            await _auditLogger.LogAsync(new AuditEvent
            {
                UserId = userId,
                Action = &quot;CreateOrder&quot;,
                ResourceId = order.Id.Value,
                Timestamp = DateTime.UtcNow,
                Details = $&quot;Order created for customer {customerId}&quot;
            });
            
            return order;
        }
        
        public async Task&lt;Order&gt; GetOrder(OrderId orderId, string userId)
        {
            var order = await _orderRepository.FindById(orderId);
            if (order == null)
            {
                throw new OrderNotFoundException($&quot;Order with ID {orderId} not found&quot;);
            }
            
            // Check authorization
            if (!await _authorizationService.CanAccessOrder(userId, order))
            {
                throw new UnauthorizedException($&quot;User {userId} is not authorized to access order {orderId}&quot;);
            }
            
            return order;
        }
    }
}
</code></pre>
<h2>Summary</h2>
<p>Context mapping is essential for managing the complexity of large systems with multiple bounded contexts. By understanding how to:</p>
<ul>
<li><strong>Map relationships</strong> between different bounded contexts</li>
<li><strong>Choose appropriate patterns</strong> for each relationship type</li>
<li><strong>Implement integration</strong> using well-defined interfaces and patterns</li>
<li><strong>Handle data consistency</strong> across context boundaries</li>
<li><strong>Test integration</strong> both in isolation and end-to-end</li>
<li><strong>Monitor context health</strong> and performance</li>
<li><strong>Evolve contexts</strong> as understanding deepens</li>
<li><strong>Avoid common pitfalls</strong> that lead to poor integration</li>
</ul>
<p>Teams can build maintainable, scalable systems that truly reflect business reality. The key is to start with clear relationship mapping, choose appropriate patterns, implement stable interfaces, handle consistency properly, and monitor the health of the entire system.</p>
<p><strong>Next</strong>: <a href="../5-Strategic-Patterns/README.md">Strategic Patterns</a> builds upon context mapping by providing guidance on organizing domain-driven systems at a high level.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/4-Context-Mapping/README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"4-Context-Mapping\",\"README\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/4-Context-Mapping/README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
