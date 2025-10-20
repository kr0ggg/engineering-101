1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/5-Strategic-Patterns/README","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"5-Strategic-Patterns\",\"README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T151fb,<h1>Strategic Patterns</h1>
<h2>Name</h2>
<p><strong>Strategic Patterns</strong> - Organizing Domain-Driven Systems</p>
<h2>Goal of the Concept</h2>
<p>Strategic patterns provide guidance on how to organize and structure domain-driven systems at a high level. They help teams make architectural decisions that support domain modeling and create systems that are maintainable, scalable, and aligned with business needs.</p>
<h2>Theoretical Foundation</h2>
<h3>Strategic Design</h3>
<p>Strategic patterns are part of strategic design, which focuses on high-level architectural decisions rather than low-level implementation details. These patterns help teams organize their systems around domain concepts.</p>
<h3>Domain-Driven Architecture</h3>
<p>Strategic patterns support domain-driven architecture by ensuring that the system structure reflects the domain structure. This alignment makes the system easier to understand and maintain.</p>
<h3>Organizational Alignment</h3>
<p>Strategic patterns often align with organizational structure, reflecting how different teams and departments work together. This alignment helps create systems that match the organization&#39;s communication patterns.</p>
<h3>System Evolution</h3>
<p>Strategic patterns support system evolution by providing a framework for making architectural decisions as the system grows and requirements change.</p>
<h2>Consequences of Poor Strategic Design</h2>
<h3>Unique Strategic Design Issues</h3>
<p><strong>Architectural Confusion</strong></p>
<ul>
<li>System structure doesn&#39;t reflect domain structure</li>
<li>Teams struggle to understand system organization</li>
<li>Changes become difficult to implement</li>
<li>System becomes hard to maintain and extend</li>
</ul>
<p><strong>Misaligned Priorities</strong></p>
<ul>
<li>Resources are spent on less important areas</li>
<li>Critical business functionality is under-resourced</li>
<li>System doesn&#39;t serve business needs effectively</li>
<li>Technical debt accumulates in important areas</li>
</ul>
<p><strong>Scalability Problems</strong></p>
<ul>
<li>System can&#39;t scale to meet growing demands</li>
<li>Performance bottlenecks in critical areas</li>
<li>Teams can&#39;t work independently</li>
<li>System becomes a constraint on business growth</li>
</ul>
<h2>Impact on System Architecture</h2>
<h3>Architectural Benefits</h3>
<p><strong>Clear Organization</strong></p>
<ul>
<li>System structure reflects domain structure</li>
<li>Clear boundaries and responsibilities</li>
<li>Easier to understand and navigate</li>
<li>Better separation of concerns</li>
</ul>
<p><strong>Scalable Design</strong></p>
<ul>
<li>System can grow to meet new demands</li>
<li>Teams can work independently</li>
<li>New functionality can be added easily</li>
<li>Performance can be optimized in critical areas</li>
</ul>
<h3>Architectural Challenges</h3>
<p><strong>Complexity Management</strong></p>
<ul>
<li>Large systems can become complex</li>
<li>Balancing simplicity with functionality</li>
<li>Managing relationships between components</li>
<li>Ensuring consistency across the system</li>
</ul>
<h2>Role in Domain-Driven Design</h2>
<p>Strategic patterns are essential to Domain-Driven Design because they:</p>
<ul>
<li><strong>Organize systems</strong> around domain concepts</li>
<li><strong>Guide architectural decisions</strong> that support domain modeling</li>
<li><strong>Enable system evolution</strong> as understanding deepens</li>
<li><strong>Support team organization</strong> and collaboration</li>
<li><strong>Ensure business alignment</strong> in system design</li>
</ul>
<h2>How to Apply Strategic Patterns</h2>
<h3>1. Identify Core Domain</h3>
<p><strong>What it means</strong>: The core domain is the part of the system that provides the most business value and competitive advantage. It&#39;s where the most effort should be focused.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify the most important business functionality</li>
<li>Look for areas that provide competitive advantage</li>
<li>Find functionality that is unique to the business</li>
<li>Consider areas that are most critical to business success</li>
</ul>
<p><strong>Example</strong>: In an e-commerce system, the core domain might be the order processing and fulfillment system, as this is what directly generates revenue and provides competitive advantage.</p>
<h3>2. Identify Generic Subdomains</h3>
<p><strong>What it means</strong>: Generic subdomains are areas that are common across many businesses and don&#39;t provide competitive advantage. They can often be implemented using off-the-shelf solutions.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Look for functionality that is common across industries</li>
<li>Identify areas that don&#39;t provide competitive advantage</li>
<li>Find functionality that can be implemented with standard solutions</li>
<li>Consider areas that are not unique to the business</li>
</ul>
<p><strong>Example</strong>: In an e-commerce system, generic subdomains might include user authentication, basic reporting, and email notifications, as these are common across many businesses.</p>
<h3>3. Identify Supporting Subdomains</h3>
<p><strong>What it means</strong>: Supporting subdomains are important to the business but don&#39;t provide competitive advantage. They need to be implemented well but don&#39;t require the same level of investment as the core domain.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify functionality that is important but not unique</li>
<li>Look for areas that support the core domain</li>
<li>Find functionality that needs to be implemented well</li>
<li>Consider areas that are necessary but not differentiating</li>
</ul>
<p><strong>Example</strong>: In an e-commerce system, supporting subdomains might include customer management, product catalog, and basic analytics, as these support the core domain but don&#39;t provide competitive advantage.</p>
<h3>4. Design System Architecture</h3>
<p><strong>What it means</strong>: Design the overall system architecture to reflect the domain structure and support the different types of subdomains appropriately.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Design architecture around domain boundaries</li>
<li>Allocate resources based on subdomain importance</li>
<li>Choose appropriate technologies for each subdomain</li>
<li>Plan for independent evolution of different areas</li>
</ul>
<p><strong>Example</strong>: The core domain might use custom, high-performance technologies, while generic subdomains might use standard, off-the-shelf solutions.</p>
<h3>5. Plan for Evolution</h3>
<p><strong>What it means</strong>: Design the system to evolve as understanding of the domain deepens and business needs change.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Design for independent evolution of different areas</li>
<li>Plan for changes in subdomain classification</li>
<li>Consider how the system might grow</li>
<li>Design for team organization and collaboration</li>
</ul>
<p><strong>Example</strong>: The system might start with a simple architecture and evolve to a more complex, distributed architecture as the business grows.</p>
<h2>Strategic Patterns</h2>
<h3>1. Core Domain Pattern</h3>
<p><strong>What it means</strong>: The core domain is the most important part of the system, where the most effort and resources should be focused. It represents the business&#39;s competitive advantage.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Highest priority for development and maintenance</li>
<li>Requires the most skilled developers</li>
<li>Uses the most appropriate technologies</li>
<li>Gets the most attention and resources</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>When you have limited resources</li>
<li>When you need to focus on competitive advantage</li>
<li>When you want to maximize business value</li>
<li>When you need to differentiate from competitors</li>
</ul>
<p><strong>Example</strong>: In a financial services company, the core domain might be risk assessment and portfolio management, as these provide competitive advantage.</p>
<h3>2. Generic Subdomain Pattern</h3>
<p><strong>What it means</strong>: Generic subdomains are common across many businesses and don&#39;t provide competitive advantage. They can often be implemented using off-the-shelf solutions.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Common across many businesses</li>
<li>Can use standard solutions</li>
<li>Requires less custom development</li>
<li>Lower priority for resources</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>When functionality is common across industries</li>
<li>When you want to minimize development effort</li>
<li>When you don&#39;t need competitive advantage</li>
<li>When you want to focus resources elsewhere</li>
</ul>
<p><strong>Example</strong>: User authentication, basic reporting, and email notifications are often generic subdomains that can be implemented with standard solutions.</p>
<h3>3. Supporting Subdomain Pattern</h3>
<p><strong>What it means</strong>: Supporting subdomains are important to the business but don&#39;t provide competitive advantage. They need to be implemented well but don&#39;t require the same level of investment as the core domain.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Important to the business</li>
<li>Needs to be implemented well</li>
<li>Doesn&#39;t provide competitive advantage</li>
<li>Medium priority for resources</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>When functionality is important but not unique</li>
<li>When you need to support the core domain</li>
<li>When you want to implement well but not over-invest</li>
<li>When you need to balance resources</li>
</ul>
<p><strong>Example</strong>: Customer management, product catalog, and basic analytics are often supporting subdomains that need to be implemented well but don&#39;t provide competitive advantage.</p>
<h3>4. Domain-Driven Architecture Pattern</h3>
<p><strong>What it means</strong>: The system architecture is organized around domain concepts rather than technical concerns. This ensures that the system structure reflects the domain structure.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Architecture reflects domain structure</li>
<li>Domain concepts drive architectural decisions</li>
<li>Technical concerns are secondary</li>
<li>System is organized around business concepts</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>When you want to align system with business</li>
<li>When you need to support domain modeling</li>
<li>When you want to make the system easier to understand</li>
<li>When you need to support business evolution</li>
</ul>
<p><strong>Example</strong>: A system might be organized around bounded contexts like Customer Management, Order Processing, and Inventory Management rather than technical layers.</p>
<h3>5. Team Organization Pattern</h3>
<p><strong>What it means</strong>: Teams are organized around domain concepts rather than technical concerns. This helps teams develop deep domain expertise and work more effectively.</p>
<p><strong>Characteristics</strong>:</p>
<ul>
<li>Teams are organized around domain areas</li>
<li>Teams develop deep domain expertise</li>
<li>Communication is more effective</li>
<li>Teams can work independently</li>
</ul>
<p><strong>When to use</strong>:</p>
<ul>
<li>When you want to develop domain expertise</li>
<li>When you need to improve team communication</li>
<li>When you want to enable independent work</li>
<li>When you need to support domain modeling</li>
</ul>
<p><strong>Example</strong>: Teams might be organized around bounded contexts like Customer Team, Order Team, and Inventory Team rather than Frontend Team, Backend Team, and Database Team.</p>
<h2>Examples of Strategic Pattern Application</h2>
<h3>E-commerce System Example</h3>
<p><strong>Core Domain</strong>: Order Processing and Fulfillment</p>
<ul>
<li><strong>Why</strong>: Directly generates revenue and provides competitive advantage</li>
<li><strong>Investment</strong>: High - custom algorithms, high performance, reliability</li>
<li><strong>Team</strong>: Most skilled developers, domain experts</li>
<li><strong>Technology</strong>: Custom solutions, high-performance technologies</li>
</ul>
<p><strong>Supporting Subdomains</strong>: Customer Management, Product Catalog, Analytics</p>
<ul>
<li><strong>Why</strong>: Important but not unique to the business</li>
<li><strong>Investment</strong>: Medium - well-implemented but not over-engineered</li>
<li><strong>Team</strong>: Good developers, some domain expertise</li>
<li><strong>Technology</strong>: Standard solutions with some customization</li>
</ul>
<p><strong>Generic Subdomains</strong>: User Authentication, Email Notifications, Basic Reporting</p>
<ul>
<li><strong>Why</strong>: Common across many businesses</li>
<li><strong>Investment</strong>: Low - standard solutions, minimal customization</li>
<li><strong>Team</strong>: Standard developers, minimal domain expertise</li>
<li><strong>Technology</strong>: Off-the-shelf solutions, standard technologies</li>
</ul>
<h3>Banking System Example</h3>
<p><strong>Core Domain</strong>: Risk Assessment and Portfolio Management</p>
<ul>
<li><strong>Why</strong>: Provides competitive advantage in financial services</li>
<li><strong>Investment</strong>: High - custom algorithms, regulatory compliance</li>
<li><strong>Team</strong>: Most skilled developers, financial domain experts</li>
<li><strong>Technology</strong>: Custom solutions, high-performance computing</li>
</ul>
<p><strong>Supporting Subdomains</strong>: Account Management, Transaction Processing, Customer Service</p>
<ul>
<li><strong>Why</strong>: Important but not unique to the business</li>
<li><strong>Investment</strong>: Medium - well-implemented but not over-engineered</li>
<li><strong>Team</strong>: Good developers, some domain expertise</li>
<li><strong>Technology</strong>: Standard solutions with some customization</li>
</ul>
<p><strong>Generic Subdomains</strong>: User Authentication, Basic Reporting, Email Notifications</p>
<ul>
<li><strong>Why</strong>: Common across many businesses</li>
<li><strong>Investment</strong>: Low - standard solutions, minimal customization</li>
<li><strong>Team</strong>: Standard developers, minimal domain expertise</li>
<li><strong>Technology</strong>: Off-the-shelf solutions, standard technologies</li>
</ul>
<h2>How This Concept Helps with System Design</h2>
<ol>
<li><strong>Clear Priorities</strong>: Resources are allocated based on business importance</li>
<li><strong>Focused Investment</strong>: Most effort goes to areas that provide competitive advantage</li>
<li><strong>Appropriate Solutions</strong>: Different types of subdomains get appropriate solutions</li>
<li><strong>Scalable Architecture</strong>: System can grow to meet new demands</li>
<li><strong>Business Alignment</strong>: System structure reflects business structure</li>
</ol>
<h2>How This Concept Helps with Development</h2>
<ol>
<li><strong>Resource Allocation</strong>: Resources are allocated based on business value</li>
<li><strong>Team Organization</strong>: Teams are organized around domain concepts</li>
<li><strong>Technology Choices</strong>: Appropriate technologies are chosen for each subdomain</li>
<li><strong>Independent Work</strong>: Teams can work independently on their areas</li>
<li><strong>Faster Development</strong>: Focused effort leads to faster development</li>
</ol>
<h2>Common Patterns and Anti-patterns</h2>
<h3>Patterns</h3>
<p><strong>Core Domain Focus</strong></p>
<ul>
<li>Most resources go to the core domain</li>
<li>Core domain gets the best developers and technologies</li>
<li>Core domain is the highest priority</li>
</ul>
<p><strong>Appropriate Investment</strong></p>
<ul>
<li>Different subdomains get appropriate levels of investment</li>
<li>Generic subdomains use standard solutions</li>
<li>Supporting subdomains are implemented well but not over-engineered</li>
</ul>
<p><strong>Domain-Driven Organization</strong></p>
<ul>
<li>Teams are organized around domain concepts</li>
<li>Architecture reflects domain structure</li>
<li>Technical concerns are secondary to domain concerns</li>
</ul>
<h3>Anti-patterns</h3>
<p><strong>Everything is Core</strong></p>
<ul>
<li>Treating all functionality as equally important</li>
<li>Over-investing in areas that don&#39;t provide competitive advantage</li>
<li>Wasting resources on generic functionality</li>
</ul>
<p><strong>Technical Organization</strong></p>
<ul>
<li>Organizing teams around technical concerns</li>
<li>Architecture driven by technical rather than domain concerns</li>
<li>Teams don&#39;t develop domain expertise</li>
</ul>
<p><strong>Uniform Investment</strong></p>
<ul>
<li>Investing the same amount in all areas</li>
<li>Not prioritizing based on business value</li>
<li>Missing opportunities for competitive advantage</li>
</ul>
<h2>Summary</h2>
<p>Strategic patterns provide guidance for organizing domain-driven systems at a high level. By identifying core domains, generic subdomains, and supporting subdomains, teams can:</p>
<ul>
<li><strong>Focus resources</strong> on areas that provide competitive advantage</li>
<li><strong>Choose appropriate solutions</strong> for different types of functionality</li>
<li><strong>Organize teams</strong> around domain concepts</li>
<li><strong>Design architectures</strong> that support domain modeling</li>
<li><strong>Plan for evolution</strong> as understanding deepens</li>
</ul>
<p>The key to successful strategic design is identifying the core domain, allocating resources appropriately, organizing teams around domain concepts, and designing architectures that support domain modeling. This creates a foundation for building systems that truly serve business needs.</p>
<h2>Exercise 1: Identify Strategic Patterns</h2>
<h3>Objective</h3>
<p>Analyze a business domain and identify core domains, generic subdomains, and supporting subdomains.</p>
<h3>Task</h3>
<p>Choose a business domain and analyze it to identify different types of subdomains.</p>
<ol>
<li><strong>Map Business Functionality</strong>: List all business functionality</li>
<li><strong>Identify Core Domain</strong>: Find functionality that provides competitive advantage</li>
<li><strong>Identify Generic Subdomains</strong>: Find functionality that is common across industries</li>
<li><strong>Identify Supporting Subdomains</strong>: Find functionality that is important but not unique</li>
<li><strong>Plan Resource Allocation</strong>: Plan how to allocate resources to different subdomains</li>
</ol>
<h3>Deliverables</h3>
<ul>
<li>Map of all business functionality</li>
<li>Identification of core domain with rationale</li>
<li>List of generic subdomains with solutions</li>
<li>List of supporting subdomains with investment levels</li>
<li>Resource allocation plan</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Choose a business domain you understand well</li>
<li>Map all business functionality</li>
<li>Identify what provides competitive advantage</li>
<li>Find common functionality across industries</li>
<li>Plan resource allocation based on importance</li>
</ol>
<hr>
<h2>Exercise 2: Design Strategic Architecture</h2>
<h3>Objective</h3>
<p>Design a strategic architecture that reflects the identified subdomains and supports domain modeling.</p>
<h3>Task</h3>
<p>Take the subdomain analysis from Exercise 1 and design a strategic architecture.</p>
<ol>
<li><strong>Design System Architecture</strong>: Create architecture that reflects domain structure</li>
<li><strong>Plan Team Organization</strong>: Organize teams around domain concepts</li>
<li><strong>Choose Technologies</strong>: Select appropriate technologies for each subdomain</li>
<li><strong>Plan Resource Allocation</strong>: Allocate resources based on subdomain importance</li>
<li><strong>Design for Evolution</strong>: Plan how the system will evolve over time</li>
</ol>
<h3>Success Criteria</h3>
<ul>
<li>Architecture reflects domain structure</li>
<li>Teams are organized around domain concepts</li>
<li>Appropriate technologies are chosen for each subdomain</li>
<li>Resources are allocated based on business value</li>
<li>System is designed for evolution</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Use your subdomain analysis from Exercise 1</li>
<li>Design architecture around domain boundaries</li>
<li>Organize teams around domain concepts</li>
<li>Choose technologies based on subdomain needs</li>
<li>Plan for system evolution</li>
</ol>
<h3>Implementation Best Practices</h3>
<h4>Strategic Design</h4>
<ol>
<li><strong>Core Domain Focus</strong>: Focus most resources on the core domain</li>
<li><strong>Appropriate Investment</strong>: Invest appropriately in different subdomains</li>
<li><strong>Domain-Driven Organization</strong>: Organize teams around domain concepts</li>
<li><strong>Business Alignment</strong>: Ensure system structure reflects business structure</li>
</ol>
<h4>Architecture Design</h4>
<ol>
<li><strong>Domain Boundaries</strong>: Design architecture around domain boundaries</li>
<li><strong>Independent Evolution</strong>: Allow different areas to evolve independently</li>
<li><strong>Appropriate Technologies</strong>: Choose technologies based on subdomain needs</li>
<li><strong>Scalable Design</strong>: Design for growth and evolution</li>
</ol>
<h3>Learning Objectives</h3>
<p>After completing both exercises, you should be able to:</p>
<ul>
<li>Identify core domains, generic subdomains, and supporting subdomains</li>
<li>Design strategic architectures that reflect domain structure</li>
<li>Organize teams around domain concepts</li>
<li>Allocate resources based on business value</li>
<li>Plan for system evolution</li>
</ul>
<p><strong>Congratulations!</strong> You have now learned all five strategic design concepts of Domain-Driven Design. These concepts work together to create systems that are maintainable, scalable, and aligned with business needs. Apply them thoughtfully in your projects to build better software.</p>
<h2>Implementation Patterns and Code Examples</h2>
<h3>Strategic Pattern Implementation Examples</h3>
<h4>1. Core Domain Pattern Implementation</h4>
<p><strong>C# Example - Core Domain Focus</strong></p>
<pre><code class="language-csharp">// Core Domain: Order Processing and Fulfillment
namespace EcommerceApp.CoreDomain
{
    // Core domain gets the most investment and attention
    public class OrderProcessingEngine
    {
        private readonly IOrderRepository _orderRepository;
        private readonly IInventoryService _inventoryService;
        private readonly IPricingEngine _pricingEngine;
        private readonly IFulfillmentService _fulfillmentService;
        
        public OrderProcessingEngine(
            IOrderRepository orderRepository,
            IInventoryService inventoryService,
            IPricingEngine pricingEngine,
            IFulfillmentService fulfillmentService)
        {
            _orderRepository = orderRepository ?? throw new ArgumentNullException(nameof(orderRepository));
            _inventoryService = inventoryService ?? throw new ArgumentNullException(nameof(inventoryService));
            _pricingEngine = pricingEngine ?? throw new ArgumentNullException(nameof(pricingEngine));
            _fulfillmentService = fulfillmentService ?? throw new ArgumentNullException(nameof(fulfillmentService));
        }
        
        public async Task&lt;OrderProcessingResult&gt; ProcessOrder(Order order)
        {
            // Core domain logic - this is where competitive advantage lies
            var inventoryCheck = await _inventoryService.CheckAvailability(order.Items);
            if (!inventoryCheck.IsAvailable)
            {
                return OrderProcessingResult.Failed(&quot;Inventory not available&quot;);
            }
            
            // Advanced pricing logic - core domain
            var pricingResult = await _pricingEngine.CalculateOptimalPricing(order);
            order.ApplyPricing(pricingResult);
            
            // Fulfillment optimization - core domain
            var fulfillmentPlan = await _fulfillmentService.CreateOptimalFulfillmentPlan(order);
            order.SetFulfillmentPlan(fulfillmentPlan);
            
            // Save order
            await _orderRepository.Save(order);
            
            return OrderProcessingResult.Success(order);
        }
    }
    
    // Core domain value objects
    public class OrderProcessingResult
    {
        public bool IsSuccess { get; private set; }
        public Order Order { get; private set; }
        public string ErrorMessage { get; private set; }
        
        private OrderProcessingResult(bool isSuccess, Order order, string errorMessage)
        {
            IsSuccess = isSuccess;
            Order = order;
            ErrorMessage = errorMessage;
        }
        
        public static OrderProcessingResult Success(Order order) =&gt; new OrderProcessingResult(true, order, null);
        public static OrderProcessingResult Failed(string errorMessage) =&gt; new OrderProcessingResult(false, null, errorMessage);
    }
    
    // Core domain services
    public interface IPricingEngine
    {
        Task&lt;PricingResult&gt; CalculateOptimalPricing(Order order);
    }
    
    public class AdvancedPricingEngine : IPricingEngine
    {
        public async Task&lt;PricingResult&gt; CalculateOptimalPricing(Order order)
        {
            // Advanced pricing algorithms - core domain
            var basePrice = order.Items.Sum(item =&gt; item.Price * item.Quantity);
            var discounts = await CalculateDiscounts(order);
            var taxes = await CalculateTaxes(order);
            var shipping = await CalculateShipping(order);
            
            return new PricingResult(basePrice, discounts, taxes, shipping);
        }
        
        private async Task&lt;decimal&gt; CalculateDiscounts(Order order)
        {
            // Complex discount logic - core domain
            // This is where competitive advantage lies
            return 0; // Simplified for example
        }
        
        private async Task&lt;decimal&gt; CalculateTaxes(Order order)
        {
            // Tax calculation logic
            return 0; // Simplified for example
        }
        
        private async Task&lt;decimal&gt; CalculateShipping(Order order)
        {
            // Shipping calculation logic
            return 0; // Simplified for example
        }
    }
}
</code></pre>
<p><strong>Java Example - Core Domain Focus</strong></p>
<pre><code class="language-java">// Core Domain: Order Processing and Fulfillment
package com.ecommerce.coredomain;

@Service
public class OrderProcessingEngine {
    private final OrderRepository orderRepository;
    private final InventoryService inventoryService;
    private final PricingEngine pricingEngine;
    private final FulfillmentService fulfillmentService;
    
    public OrderProcessingEngine(
            OrderRepository orderRepository,
            InventoryService inventoryService,
            PricingEngine pricingEngine,
            FulfillmentService fulfillmentService) {
        this.orderRepository = Objects.requireNonNull(orderRepository, &quot;Order repository cannot be null&quot;);
        this.inventoryService = Objects.requireNonNull(inventoryService, &quot;Inventory service cannot be null&quot;);
        this.pricingEngine = Objects.requireNonNull(pricingEngine, &quot;Pricing engine cannot be null&quot;);
        this.fulfillmentService = Objects.requireNonNull(fulfillmentService, &quot;Fulfillment service cannot be null&quot;);
    }
    
    public OrderProcessingResult processOrder(Order order) {
        // Core domain logic - this is where competitive advantage lies
        InventoryCheckResult inventoryCheck = inventoryService.checkAvailability(order.getItems());
        if (!inventoryCheck.isAvailable()) {
            return OrderProcessingResult.failed(&quot;Inventory not available&quot;);
        }
        
        // Advanced pricing logic - core domain
        PricingResult pricingResult = pricingEngine.calculateOptimalPricing(order);
        order.applyPricing(pricingResult);
        
        // Fulfillment optimization - core domain
        FulfillmentPlan fulfillmentPlan = fulfillmentService.createOptimalFulfillmentPlan(order);
        order.setFulfillmentPlan(fulfillmentPlan);
        
        // Save order
        orderRepository.save(order);
        
        return OrderProcessingResult.success(order);
    }
}

// Core domain value objects
@Data
@AllArgsConstructor
public class OrderProcessingResult {
    private final boolean isSuccess;
    private final Order order;
    private final String errorMessage;
    
    public static OrderProcessingResult success(Order order) {
        return new OrderProcessingResult(true, order, null);
    }
    
    public static OrderProcessingResult failed(String errorMessage) {
        return new OrderProcessingResult(false, null, errorMessage);
    }
}

// Core domain services
public interface PricingEngine {
    PricingResult calculateOptimalPricing(Order order);
}

@Service
public class AdvancedPricingEngine implements PricingEngine {
    @Override
    public PricingResult calculateOptimalPricing(Order order) {
        // Advanced pricing algorithms - core domain
        BigDecimal basePrice = order.getItems().stream()
            .map(item -&gt; item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())))
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        BigDecimal discounts = calculateDiscounts(order);
        BigDecimal taxes = calculateTaxes(order);
        BigDecimal shipping = calculateShipping(order);
        
        return new PricingResult(basePrice, discounts, taxes, shipping);
    }
    
    private BigDecimal calculateDiscounts(Order order) {
        // Complex discount logic - core domain
        // This is where competitive advantage lies
        return BigDecimal.ZERO; // Simplified for example
    }
    
    private BigDecimal calculateTaxes(Order order) {
        // Tax calculation logic
        return BigDecimal.ZERO; // Simplified for example
    }
    
    private BigDecimal calculateShipping(Order order) {
        // Shipping calculation logic
        return BigDecimal.ZERO; // Simplified for example
    }
}
</code></pre>
<h4>2. Generic Subdomain Pattern Implementation</h4>
<p><strong>C# Example - Generic Subdomain</strong></p>
<pre><code class="language-csharp">// Generic Subdomain: User Authentication
namespace EcommerceApp.GenericSubdomains
{
    // Generic subdomain - common across many businesses
    public class AuthenticationService
    {
        private readonly IUserRepository _userRepository;
        private readonly IPasswordHasher _passwordHasher;
        private readonly ITokenGenerator _tokenGenerator;
        
        public AuthenticationService(
            IUserRepository userRepository,
            IPasswordHasher passwordHasher,
            ITokenGenerator tokenGenerator)
        {
            _userRepository = userRepository ?? throw new ArgumentNullException(nameof(userRepository));
            _passwordHasher = passwordHasher ?? throw new ArgumentNullException(nameof(passwordHasher));
            _tokenGenerator = tokenGenerator ?? throw new ArgumentNullException(nameof(tokenGenerator));
        }
        
        public async Task&lt;AuthenticationResult&gt; AuthenticateUser(string email, string password)
        {
            // Standard authentication logic - generic subdomain
            var user = await _userRepository.FindByEmail(email);
            if (user == null)
            {
                return AuthenticationResult.Failed(&quot;User not found&quot;);
            }
            
            if (!_passwordHasher.VerifyPassword(password, user.PasswordHash))
            {
                return AuthenticationResult.Failed(&quot;Invalid password&quot;);
            }
            
            var token = _tokenGenerator.GenerateToken(user);
            return AuthenticationResult.Success(token, user);
        }
        
        public async Task&lt;RegistrationResult&gt; RegisterUser(string email, string password, string name)
        {
            // Standard registration logic - generic subdomain
            var existingUser = await _userRepository.FindByEmail(email);
            if (existingUser != null)
            {
                return RegistrationResult.Failed(&quot;User already exists&quot;);
            }
            
            var passwordHash = _passwordHasher.HashPassword(password);
            var user = new User(email, name, passwordHash);
            
            await _userRepository.Save(user);
            
            return RegistrationResult.Success(user);
        }
    }
    
    // Generic subdomain value objects
    public class AuthenticationResult
    {
        public bool IsSuccess { get; private set; }
        public string Token { get; private set; }
        public User User { get; private set; }
        public string ErrorMessage { get; private set; }
        
        private AuthenticationResult(bool isSuccess, string token, User user, string errorMessage)
        {
            IsSuccess = isSuccess;
            Token = token;
            User = user;
            ErrorMessage = errorMessage;
        }
        
        public static AuthenticationResult Success(string token, User user) =&gt; new AuthenticationResult(true, token, user, null);
        public static AuthenticationResult Failed(string errorMessage) =&gt; new AuthenticationResult(false, null, null, errorMessage);
    }
    
    public class RegistrationResult
    {
        public bool IsSuccess { get; private set; }
        public User User { get; private set; }
        public string ErrorMessage { get; private set; }
        
        private RegistrationResult(bool isSuccess, User user, string errorMessage)
        {
            IsSuccess = isSuccess;
            User = user;
            ErrorMessage = errorMessage;
        }
        
        public static RegistrationResult Success(User user) =&gt; new RegistrationResult(true, user, null);
        public static RegistrationResult Failed(string errorMessage) =&gt; new RegistrationResult(false, null, errorMessage);
    }
}

// Generic Subdomain: Email Notifications
namespace EcommerceApp.GenericSubdomains
{
    public class EmailNotificationService
    {
        private readonly IEmailProvider _emailProvider;
        private readonly IEmailTemplateEngine _templateEngine;
        
        public EmailNotificationService(IEmailProvider emailProvider, IEmailTemplateEngine templateEngine)
        {
            _emailProvider = emailProvider ?? throw new ArgumentNullException(nameof(emailProvider));
            _templateEngine = templateEngine ?? throw new ArgumentNullException(nameof(templateEngine));
        }
        
        public async Task SendOrderConfirmationEmail(Order order, Customer customer)
        {
            // Standard email logic - generic subdomain
            var template = await _templateEngine.GetTemplate(&quot;OrderConfirmation&quot;);
            var content = template.Render(new { Order = order, Customer = customer });
            
            var email = new Email
            {
                To = customer.Email,
                Subject = &quot;Order Confirmation&quot;,
                Content = content
            };
            
            await _emailProvider.SendEmail(email);
        }
        
        public async Task SendPasswordResetEmail(User user, string resetToken)
        {
            // Standard email logic - generic subdomain
            var template = await _templateEngine.GetTemplate(&quot;PasswordReset&quot;);
            var content = template.Render(new { User = user, ResetToken = resetToken });
            
            var email = new Email
            {
                To = user.Email,
                Subject = &quot;Password Reset&quot;,
                Content = content
            };
            
            await _emailProvider.SendEmail(email);
        }
    }
}
</code></pre>
<p><strong>TypeScript Example - Generic Subdomain</strong></p>
<pre><code class="language-typescript">// Generic Subdomain: User Authentication
export namespace GenericSubdomains {
    export class AuthenticationService {
        constructor(
            private userRepository: IUserRepository,
            private passwordHasher: IPasswordHasher,
            private tokenGenerator: ITokenGenerator
        ) {}
        
        async authenticateUser(email: string, password: string): Promise&lt;AuthenticationResult&gt; {
            // Standard authentication logic - generic subdomain
            const user = await this.userRepository.findByEmail(email);
            if (!user) {
                return AuthenticationResult.failed(&quot;User not found&quot;);
            }
            
            if (!this.passwordHasher.verifyPassword(password, user.passwordHash)) {
                return AuthenticationResult.failed(&quot;Invalid password&quot;);
            }
            
            const token = this.tokenGenerator.generateToken(user);
            return AuthenticationResult.success(token, user);
        }
        
        async registerUser(email: string, password: string, name: string): Promise&lt;RegistrationResult&gt; {
            // Standard registration logic - generic subdomain
            const existingUser = await this.userRepository.findByEmail(email);
            if (existingUser) {
                return RegistrationResult.failed(&quot;User already exists&quot;);
            }
            
            const passwordHash = this.passwordHasher.hashPassword(password);
            const user = new User(email, name, passwordHash);
            
            await this.userRepository.save(user);
            
            return RegistrationResult.success(user);
        }
    }
    
    // Generic subdomain value objects
    export class AuthenticationResult {
        private constructor(
            public readonly isSuccess: boolean,
            public readonly token: string | null,
            public readonly user: User | null,
            public readonly errorMessage: string | null
        ) {}
        
        static success(token: string, user: User): AuthenticationResult {
            return new AuthenticationResult(true, token, user, null);
        }
        
        static failed(errorMessage: string): AuthenticationResult {
            return new AuthenticationResult(false, null, null, errorMessage);
        }
    }
    
    export class RegistrationResult {
        private constructor(
            public readonly isSuccess: boolean,
            public readonly user: User | null,
            public readonly errorMessage: string | null
        ) {}
        
        static success(user: User): RegistrationResult {
            return new RegistrationResult(true, user, null);
        }
        
        static failed(errorMessage: string): RegistrationResult {
            return new RegistrationResult(false, null, errorMessage);
        }
    }
}

// Generic Subdomain: Email Notifications
export namespace GenericSubdomains {
    export class EmailNotificationService {
        constructor(
            private emailProvider: IEmailProvider,
            private templateEngine: IEmailTemplateEngine
        ) {}
        
        async sendOrderConfirmationEmail(order: Order, customer: Customer): Promise&lt;void&gt; {
            // Standard email logic - generic subdomain
            const template = await this.templateEngine.getTemplate(&quot;OrderConfirmation&quot;);
            const content = template.render({ order, customer });
            
            const email: Email = {
                to: customer.email,
                subject: &quot;Order Confirmation&quot;,
                content: content
            };
            
            await this.emailProvider.sendEmail(email);
        }
        
        async sendPasswordResetEmail(user: User, resetToken: string): Promise&lt;void&gt; {
            // Standard email logic - generic subdomain
            const template = await this.templateEngine.getTemplate(&quot;PasswordReset&quot;);
            const content = template.render({ user, resetToken });
            
            const email: Email = {
                to: user.email,
                subject: &quot;Password Reset&quot;,
                content: content
            };
            
            await this.emailProvider.sendEmail(email);
        }
    }
}
</code></pre>
<h4>3. Supporting Subdomain Pattern Implementation</h4>
<p><strong>C# Example - Supporting Subdomain</strong></p>
<pre><code class="language-csharp">// Supporting Subdomain: Customer Management
namespace EcommerceApp.SupportingSubdomains
{
    // Supporting subdomain - important but not unique
    public class CustomerManagementService
    {
        private readonly ICustomerRepository _customerRepository;
        private readonly ICustomerValidationService _validationService;
        private readonly ICustomerAnalyticsService _analyticsService;
        
        public CustomerManagementService(
            ICustomerRepository customerRepository,
            ICustomerValidationService validationService,
            ICustomerAnalyticsService analyticsService)
        {
            _customerRepository = customerRepository ?? throw new ArgumentNullException(nameof(customerRepository));
            _validationService = validationService ?? throw new ArgumentNullException(nameof(validationService));
            _analyticsService = analyticsService ?? throw new ArgumentNullException(nameof(analyticsService));
        }
        
        public async Task&lt;Customer&gt; CreateCustomer(CustomerRegistrationData registrationData)
        {
            // Supporting subdomain logic - important but not unique
            var validationResult = await _validationService.ValidateRegistrationData(registrationData);
            if (!validationResult.IsValid)
            {
                throw new InvalidCustomerDataException(validationResult.ErrorMessage);
            }
            
            var customer = new Customer(
                CustomerId.Generate(),
                registrationData.Name,
                registrationData.Email,
                registrationData.Phone
            );
            
            await _customerRepository.Save(customer);
            
            // Track customer creation for analytics
            await _analyticsService.TrackCustomerCreated(customer);
            
            return customer;
        }
        
        public async Task&lt;Customer&gt; UpdateCustomer(CustomerId customerId, CustomerUpdateData updateData)
        {
            var customer = await _customerRepository.FindById(customerId);
            if (customer == null)
            {
                throw new CustomerNotFoundException($&quot;Customer with ID {customerId} not found&quot;);
            }
            
            // Supporting subdomain logic - important but not unique
            var validationResult = await _validationService.ValidateUpdateData(updateData);
            if (!validationResult.IsValid)
            {
                throw new InvalidCustomerDataException(validationResult.ErrorMessage);
            }
            
            customer.UpdateProfile(updateData.Name, updateData.Phone);
            await _customerRepository.Save(customer);
            
            // Track customer update for analytics
            await _analyticsService.TrackCustomerUpdated(customer);
            
            return customer;
        }
        
        public async Task&lt;CustomerProfile&gt; GetCustomerProfile(CustomerId customerId)
        {
            var customer = await _customerRepository.FindById(customerId);
            if (customer == null)
            {
                throw new CustomerNotFoundException($&quot;Customer with ID {customerId} not found&quot;);
            }
            
            // Supporting subdomain logic - important but not unique
            var analytics = await _analyticsService.GetCustomerAnalytics(customerId);
            
            return new CustomerProfile
            {
                CustomerId = customer.Id,
                Name = customer.Name,
                Email = customer.Email,
                Phone = customer.Phone,
                CreatedAt = customer.CreatedAt,
                LastOrderDate = analytics.LastOrderDate,
                TotalOrders = analytics.TotalOrders,
                TotalSpent = analytics.TotalSpent
            };
        }
    }
    
    // Supporting subdomain value objects
    public class CustomerProfile
    {
        public CustomerId CustomerId { get; set; }
        public string Name { get; set; }
        public EmailAddress Email { get; set; }
        public PhoneNumber Phone { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? LastOrderDate { get; set; }
        public int TotalOrders { get; set; }
        public Money TotalSpent { get; set; }
    }
    
    public class CustomerRegistrationData
    {
        public string Name { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
    }
    
    public class CustomerUpdateData
    {
        public string Name { get; set; }
        public string Phone { get; set; }
    }
}

// Supporting Subdomain: Product Catalog
namespace EcommerceApp.SupportingSubdomains
{
    public class ProductCatalogService
    {
        private readonly IProductRepository _productRepository;
        private readonly IProductSearchService _searchService;
        private readonly IProductRecommendationService _recommendationService;
        
        public ProductCatalogService(
            IProductRepository productRepository,
            IProductSearchService searchService,
            IProductRecommendationService recommendationService)
        {
            _productRepository = productRepository ?? throw new ArgumentNullException(nameof(productRepository));
            _searchService = searchService ?? throw new ArgumentNullException(nameof(searchService));
            _recommendationService = recommendationService ?? throw new ArgumentNullException(nameof(recommendationService));
        }
        
        public async Task&lt;Product&gt; CreateProduct(ProductCreationData creationData)
        {
            // Supporting subdomain logic - important but not unique
            var product = new Product(
                ProductId.Generate(),
                creationData.Name,
                creationData.Description,
                creationData.Price,
                creationData.Category
            );
            
            await _productRepository.Save(product);
            
            // Index product for search
            await _searchService.IndexProduct(product);
            
            return product;
        }
        
        public async Task&lt;List&lt;Product&gt;&gt; SearchProducts(string searchTerm, ProductSearchFilters filters)
        {
            // Supporting subdomain logic - important but not unique
            var searchResults = await _searchService.SearchProducts(searchTerm, filters);
            
            return searchResults.Select(result =&gt; result.Product).ToList();
        }
        
        public async Task&lt;List&lt;Product&gt;&gt; GetProductRecommendations(CustomerId customerId, int count = 10)
        {
            // Supporting subdomain logic - important but not unique
            var recommendations = await _recommendationService.GetRecommendations(customerId, count);
            
            return recommendations.Select(rec =&gt; rec.Product).ToList();
        }
    }
}
</code></pre>
<h4>4. Domain-Driven Architecture Pattern Implementation</h4>
<p><strong>C# Example - Domain-Driven Architecture</strong></p>
<pre><code class="language-csharp">// Domain-Driven Architecture - organized around domain concepts
namespace EcommerceApp.Architecture
{
    // Architecture organized around domain concepts
    public class DomainDrivenArchitecture
    {
        // Core Domain - highest priority
        public IOrderProcessingService OrderProcessingService { get; }
        public IPricingEngine PricingEngine { get; }
        public IFulfillmentService FulfillmentService { get; }
        
        // Supporting Subdomains - medium priority
        public ICustomerManagementService CustomerManagementService { get; }
        public IProductCatalogService ProductCatalogService { get; }
        public IAnalyticsService AnalyticsService { get; }
        
        // Generic Subdomains - lowest priority
        public IAuthenticationService AuthenticationService { get; }
        public IEmailNotificationService EmailNotificationService { get; }
        public IReportingService ReportingService { get; }
        
        public DomainDrivenArchitecture(
            IOrderProcessingService orderProcessingService,
            IPricingEngine pricingEngine,
            IFulfillmentService fulfillmentService,
            ICustomerManagementService customerManagementService,
            IProductCatalogService productCatalogService,
            IAnalyticsService analyticsService,
            IAuthenticationService authenticationService,
            IEmailNotificationService emailNotificationService,
            IReportingService reportingService)
        {
            // Core domain services - highest priority
            OrderProcessingService = orderProcessingService ?? throw new ArgumentNullException(nameof(orderProcessingService));
            PricingEngine = pricingEngine ?? throw new ArgumentNullException(nameof(pricingEngine));
            FulfillmentService = fulfillmentService ?? throw new ArgumentNullException(nameof(fulfillmentService));
            
            // Supporting subdomain services - medium priority
            CustomerManagementService = customerManagementService ?? throw new ArgumentNullException(nameof(customerManagementService));
            ProductCatalogService = productCatalogService ?? throw new ArgumentNullException(nameof(productCatalogService));
            AnalyticsService = analyticsService ?? throw new ArgumentNullException(nameof(analyticsService));
            
            // Generic subdomain services - lowest priority
            AuthenticationService = authenticationService ?? throw new ArgumentNullException(nameof(authenticationService));
            EmailNotificationService = emailNotificationService ?? throw new ArgumentNullException(nameof(emailNotificationService));
            ReportingService = reportingService ?? throw new ArgumentNullException(nameof(reportingService));
        }
        
        public async Task&lt;OrderProcessingResult&gt; ProcessOrder(Order order)
        {
            // Core domain logic - highest priority
            var result = await OrderProcessingService.ProcessOrder(order);
            
            if (result.IsSuccess)
            {
                // Supporting subdomain logic - medium priority
                await AnalyticsService.TrackOrderProcessed(order);
                
                // Generic subdomain logic - lowest priority
                await EmailNotificationService.SendOrderConfirmationEmail(order, order.Customer);
            }
            
            return result;
        }
    }
    
    // Domain-driven configuration
    public class DomainDrivenConfiguration
    {
        public CoreDomainConfiguration CoreDomain { get; set; }
        public SupportingSubdomainConfiguration SupportingSubdomains { get; set; }
        public GenericSubdomainConfiguration GenericSubdomains { get; set; }
    }
    
    public class CoreDomainConfiguration
    {
        public bool EnableAdvancedPricing { get; set; } = true;
        public bool EnableFulfillmentOptimization { get; set; } = true;
        public int MaxConcurrentOrders { get; set; } = 1000;
        public TimeSpan OrderProcessingTimeout { get; set; } = TimeSpan.FromMinutes(5);
    }
    
    public class SupportingSubdomainConfiguration
    {
        public bool EnableCustomerAnalytics { get; set; } = true;
        public bool EnableProductRecommendations { get; set; } = true;
        public int MaxSearchResults { get; set; } = 100;
    }
    
    public class GenericSubdomainConfiguration
    {
        public bool EnableEmailNotifications { get; set; } = true;
        public bool EnableBasicReporting { get; set; } = true;
        public string DefaultEmailProvider { get; set; } = &quot;SMTP&quot;;
    }
}
</code></pre>
<h4>5. Team Organization Pattern Implementation</h4>
<p><strong>C# Example - Team Organization</strong></p>
<pre><code class="language-csharp">// Team Organization - organized around domain concepts
namespace EcommerceApp.TeamOrganization
{
    // Core Domain Team - most skilled developers
    public class CoreDomainTeam
    {
        public string TeamName { get; } = &quot;Order Processing Team&quot;;
        public string Domain { get; } = &quot;Order Processing and Fulfillment&quot;;
        public TeamPriority Priority { get; } = TeamPriority.Highest;
        public List&lt;string&gt; Responsibilities { get; }
        
        public CoreDomainTeam()
        {
            Responsibilities = new List&lt;string&gt;
            {
                &quot;Order processing algorithms&quot;,
                &quot;Pricing engine optimization&quot;,
                &quot;Fulfillment optimization&quot;,
                &quot;Performance optimization&quot;,
                &quot;Scalability improvements&quot;
            };
        }
        
        public async Task&lt;OrderProcessingResult&gt; ProcessOrder(Order order)
        {
            // Core domain team handles the most complex logic
            // This team has the most skilled developers
            // This team gets the most resources and attention
            return await ProcessOrderWithAdvancedAlgorithms(order);
        }
        
        private async Task&lt;OrderProcessingResult&gt; ProcessOrderWithAdvancedAlgorithms(Order order)
        {
            // Advanced algorithms - core domain team responsibility
            // This is where competitive advantage lies
            return OrderProcessingResult.Success(order);
        }
    }
    
    // Supporting Subdomain Team - good developers
    public class SupportingSubdomainTeam
    {
        public string TeamName { get; } = &quot;Customer Management Team&quot;;
        public string Domain { get; } = &quot;Customer Management&quot;;
        public TeamPriority Priority { get; } = TeamPriority.Medium;
        public List&lt;string&gt; Responsibilities { get; }
        
        public SupportingSubdomainTeam()
        {
            Responsibilities = new List&lt;string&gt;
            {
                &quot;Customer profile management&quot;,
                &quot;Customer analytics&quot;,
                &quot;Customer support features&quot;,
                &quot;Customer data validation&quot;,
                &quot;Customer reporting&quot;
            };
        }
        
        public async Task&lt;Customer&gt; ManageCustomer(CustomerId customerId, CustomerUpdateData updateData)
        {
            // Supporting subdomain team handles important but not unique logic
            // This team has good developers with some domain expertise
            // This team gets medium priority and resources
            return await UpdateCustomerProfile(customerId, updateData);
        }
        
        private async Task&lt;Customer&gt; UpdateCustomerProfile(CustomerId customerId, CustomerUpdateData updateData)
        {
            // Important but not unique logic - supporting subdomain team responsibility
            // This supports the core domain but doesn&#39;t provide competitive advantage
            return new Customer(customerId, updateData.Name, updateData.Email);
        }
    }
    
    // Generic Subdomain Team - standard developers
    public class GenericSubdomainTeam
    {
        public string TeamName { get; } = &quot;Authentication Team&quot;;
        public string Domain { get; } = &quot;User Authentication&quot;;
        public TeamPriority Priority { get; } = TeamPriority.Lowest;
        public List&lt;string&gt; Responsibilities { get; }
        
        public GenericSubdomainTeam()
        {
            Responsibilities = new List&lt;string&gt;
            {
                &quot;User authentication&quot;,
                &quot;Password management&quot;,
                &quot;Session management&quot;,
                &quot;Security compliance&quot;,
                &quot;Standard authentication features&quot;
            };
        }
        
        public async Task&lt;AuthenticationResult&gt; AuthenticateUser(string email, string password)
        {
            // Generic subdomain team handles common functionality
            // This team has standard developers with minimal domain expertise
            // This team gets lowest priority and resources
            return await PerformStandardAuthentication(email, password);
        }
        
        private async Task&lt;AuthenticationResult&gt; PerformStandardAuthentication(string email, string password)
        {
            // Common functionality - generic subdomain team responsibility
            // This is common across many businesses and doesn&#39;t provide competitive advantage
            return AuthenticationResult.Success(&quot;token&quot;, new User(email, &quot;name&quot;));
        }
    }
    
    public enum TeamPriority
    {
        Highest,
        Medium,
        Lowest
    }
}
</code></pre>
<h3>6. Strategic Pattern Testing Patterns</h3>
<p><strong>C# Example - Strategic Pattern Testing</strong></p>
<pre><code class="language-csharp">// Strategic pattern testing
namespace EcommerceApp.Tests.StrategicPatterns
{
    [TestClass]
    public class StrategicPatternTests
    {
        [TestClass]
        public class CoreDomainTests
        {
            [TestMethod]
            public async Task ProcessOrder_WithValidOrder_ShouldSucceed()
            {
                // Arrange
                var orderProcessingService = new OrderProcessingService(
                    new InMemoryOrderRepository(),
                    new InMemoryInventoryService(),
                    new AdvancedPricingEngine(),
                    new FulfillmentService()
                );
                
                var order = new Order(OrderId.Generate(), CustomerId.Generate());
                order.AddItem(ProductId.Generate(), new Money(10.00m, Currency.USD), 2);
                
                // Act
                var result = await orderProcessingService.ProcessOrder(order);
                
                // Assert
                Assert.IsTrue(result.IsSuccess);
                Assert.IsNotNull(result.Order);
            }
            
            [TestMethod]
            public async Task ProcessOrder_WithInvalidOrder_ShouldFail()
            {
                // Arrange
                var orderProcessingService = new OrderProcessingService(
                    new InMemoryOrderRepository(),
                    new InMemoryInventoryService(),
                    new AdvancedPricingEngine(),
                    new FulfillmentService()
                );
                
                var order = new Order(OrderId.Generate(), CustomerId.Generate());
                // Order has no items
                
                // Act
                var result = await orderProcessingService.ProcessOrder(order);
                
                // Assert
                Assert.IsFalse(result.IsSuccess);
                Assert.IsNotNull(result.ErrorMessage);
            }
        }
        
        [TestClass]
        public class SupportingSubdomainTests
        {
            [TestMethod]
            public async Task CreateCustomer_WithValidData_ShouldSucceed()
            {
                // Arrange
                var customerManagementService = new CustomerManagementService(
                    new InMemoryCustomerRepository(),
                    new CustomerValidationService(),
                    new CustomerAnalyticsService()
                );
                
                var registrationData = new CustomerRegistrationData
                {
                    Name = &quot;John Doe&quot;,
                    Email = &quot;john@example.com&quot;,
                    Phone = &quot;555-1234&quot;
                };
                
                // Act
                var customer = await customerManagementService.CreateCustomer(registrationData);
                
                // Assert
                Assert.IsNotNull(customer);
                Assert.AreEqual(&quot;John Doe&quot;, customer.Name);
                Assert.AreEqual(&quot;john@example.com&quot;, customer.Email.Value);
            }
            
            [TestMethod]
            public async Task CreateCustomer_WithInvalidData_ShouldFail()
            {
                // Arrange
                var customerManagementService = new CustomerManagementService(
                    new InMemoryCustomerRepository(),
                    new CustomerValidationService(),
                    new CustomerAnalyticsService()
                );
                
                var registrationData = new CustomerRegistrationData
                {
                    Name = &quot;&quot;, // Invalid name
                    Email = &quot;invalid-email&quot;, // Invalid email
                    Phone = &quot;123&quot; // Invalid phone
                };
                
                // Act &amp; Assert
                await Assert.ThrowsExceptionAsync&lt;InvalidCustomerDataException&gt;(async () =&gt;
                {
                    await customerManagementService.CreateCustomer(registrationData);
                });
            }
        }
        
        [TestClass]
        public class GenericSubdomainTests
        {
            [TestMethod]
            public async Task AuthenticateUser_WithValidCredentials_ShouldSucceed()
            {
                // Arrange
                var authenticationService = new AuthenticationService(
                    new InMemoryUserRepository(),
                    new PasswordHasher(),
                    new TokenGenerator()
                );
                
                var user = new User(&quot;john@example.com&quot;, &quot;John Doe&quot;, &quot;hashedpassword&quot;);
                await authenticationService.RegisterUser(&quot;john@example.com&quot;, &quot;password&quot;, &quot;John Doe&quot;);
                
                // Act
                var result = await authenticationService.AuthenticateUser(&quot;john@example.com&quot;, &quot;password&quot;);
                
                // Assert
                Assert.IsTrue(result.IsSuccess);
                Assert.IsNotNull(result.Token);
                Assert.IsNotNull(result.User);
            }
            
            [TestMethod]
            public async Task AuthenticateUser_WithInvalidCredentials_ShouldFail()
            {
                // Arrange
                var authenticationService = new AuthenticationService(
                    new InMemoryUserRepository(),
                    new PasswordHasher(),
                    new TokenGenerator()
                );
                
                // Act
                var result = await authenticationService.AuthenticateUser(&quot;john@example.com&quot;, &quot;wrongpassword&quot;);
                
                // Assert
                Assert.IsFalse(result.IsSuccess);
                Assert.IsNotNull(result.ErrorMessage);
            }
        }
    }
}
</code></pre>
<h2>Common Pitfalls and How to Avoid Them</h2>
<h3>1. Treating Everything as Core Domain</h3>
<p><strong>Problem</strong>: Treating all functionality as equally important</p>
<pre><code class="language-csharp">// Bad - Everything is core domain
namespace EcommerceApp
{
    public class EverythingIsCoreService
    {
        public async Task&lt;Result&gt; ProcessOrder(Order order)
        {
            // This is core domain - correct
            var orderResult = await ProcessOrderWithAdvancedAlgorithms(order);
            
            // This is generic subdomain - should not be core
            var emailResult = await SendStandardEmail(order);
            
            // This is supporting subdomain - should not be core
            var analyticsResult = await TrackStandardAnalytics(order);
            
            // All treated equally - wrong
            return Result.Success();
        }
    }
}
</code></pre>
<p><strong>Solution</strong>: Focus resources on core domain</p>
<pre><code class="language-csharp">// Good - Focus on core domain
namespace EcommerceApp
{
    public class CoreDomainFocusedService
    {
        public async Task&lt;OrderProcessingResult&gt; ProcessOrder(Order order)
        {
            // Core domain - highest priority and resources
            var orderResult = await ProcessOrderWithAdvancedAlgorithms(order);
            
            // Supporting subdomain - medium priority
            await _analyticsService.TrackOrderProcessed(order);
            
            // Generic subdomain - lowest priority
            await _emailService.SendOrderConfirmationEmail(order);
            
            return orderResult;
        }
    }
}
</code></pre>
<h3>2. Under-investing in Core Domain</h3>
<p><strong>Problem</strong>: Not investing enough in core domain</p>
<pre><code class="language-csharp">// Bad - Under-investing in core domain
namespace EcommerceApp
{
    public class UnderInvestedCoreDomainService
    {
        public async Task&lt;OrderProcessingResult&gt; ProcessOrder(Order order)
        {
            // Core domain logic is too simple
            // No advanced algorithms
            // No optimization
            // No competitive advantage
            
            var total = order.Items.Sum(item =&gt; item.Price * item.Quantity);
            order.SetTotal(total);
            
            return OrderProcessingResult.Success(order);
        }
    }
}
</code></pre>
<p><strong>Solution</strong>: Invest appropriately in core domain</p>
<pre><code class="language-csharp">// Good - Appropriate investment in core domain
namespace EcommerceApp
{
    public class WellInvestedCoreDomainService
    {
        public async Task&lt;OrderProcessingResult&gt; ProcessOrder(Order order)
        {
            // Core domain logic is sophisticated
            // Advanced algorithms
            // Optimization
            // Competitive advantage
            
            var pricingResult = await _advancedPricingEngine.CalculateOptimalPricing(order);
            order.ApplyPricing(pricingResult);
            
            var fulfillmentPlan = await _fulfillmentService.CreateOptimalFulfillmentPlan(order);
            order.SetFulfillmentPlan(fulfillmentPlan);
            
            return OrderProcessingResult.Success(order);
        }
    }
}
</code></pre>
<h3>3. Over-investing in Generic Subdomains</h3>
<p><strong>Problem</strong>: Spending too much on generic functionality</p>
<pre><code class="language-csharp">// Bad - Over-investing in generic subdomains
namespace EcommerceApp
{
    public class OverInvestedGenericService
    {
        public async Task&lt;AuthenticationResult&gt; AuthenticateUser(string email, string password)
        {
            // Generic subdomain logic is too complex
            // Custom authentication algorithms
            // Advanced security features
            // Over-engineered for common functionality
            
            var securityAnalysis = await _advancedSecurityAnalyzer.AnalyzeSecurity(email);
            var riskAssessment = await _riskAssessmentEngine.AssessRisk(email);
            var customAuthResult = await _customAuthenticationEngine.Authenticate(email, password);
            
            return AuthenticationResult.Success(&quot;token&quot;, new User(email, &quot;name&quot;));
        }
    }
}
</code></pre>
<p><strong>Solution</strong>: Use standard solutions for generic subdomains</p>
<pre><code class="language-csharp">// Good - Standard solutions for generic subdomains
namespace EcommerceApp
{
    public class StandardGenericService
    {
        public async Task&lt;AuthenticationResult&gt; AuthenticateUser(string email, string password)
        {
            // Generic subdomain logic is standard
            // Standard authentication
            // Standard security features
            // Appropriate for common functionality
            
            var user = await _userRepository.FindByEmail(email);
            if (user == null || !_passwordHasher.VerifyPassword(password, user.PasswordHash))
            {
                return AuthenticationResult.Failed(&quot;Invalid credentials&quot;);
            }
            
            var token = _tokenGenerator.GenerateToken(user);
            return AuthenticationResult.Success(token, user);
        }
    }
}
</code></pre>
<h3>4. Poor Team Organization</h3>
<p><strong>Problem</strong>: Organizing teams around technical concerns</p>
<pre><code class="language-csharp">// Bad - Technical team organization
namespace EcommerceApp
{
    public class TechnicalTeamOrganization
    {
        // Teams organized around technical concerns
        public class FrontendTeam { }
        public class BackendTeam { }
        public class DatabaseTeam { }
        public class DevOpsTeam { }
        
        // Teams don&#39;t develop domain expertise
        // Teams don&#39;t understand business context
        // Teams can&#39;t work independently
    }
}
</code></pre>
<p><strong>Solution</strong>: Organize teams around domain concepts</p>
<pre><code class="language-csharp">// Good - Domain-driven team organization
namespace EcommerceApp
{
    public class DomainDrivenTeamOrganization
    {
        // Teams organized around domain concepts
        public class OrderProcessingTeam { }
        public class CustomerManagementTeam { }
        public class ProductCatalogTeam { }
        public class AuthenticationTeam { }
        
        // Teams develop domain expertise
        // Teams understand business context
        // Teams can work independently
    }
}
</code></pre>
<h2>Advanced Topics</h2>
<h3>1. Strategic Pattern Evolution</h3>
<p><strong>C# Example - Strategic Pattern Evolution</strong></p>
<pre><code class="language-csharp">// Strategic pattern evolution
namespace EcommerceApp.StrategicEvolution
{
    public class StrategicPatternEvolutionService
    {
        public async Task&lt;EvolutionResult&gt; EvolveStrategicPatterns(EvolutionRequest request)
        {
            // Strategic patterns evolve as understanding deepens
            var currentPatterns = await _patternRepository.GetCurrentPatterns();
            var evolutionPlan = await _evolutionPlanner.CreateEvolutionPlan(currentPatterns, request);
            
            // Execute evolution plan
            var evolutionResult = await ExecuteEvolutionPlan(evolutionPlan);
            
            return evolutionResult;
        }
        
        private async Task&lt;EvolutionResult&gt; ExecuteEvolutionPlan(EvolutionPlan plan)
        {
            var results = new List&lt;EvolutionStepResult&gt;();
            
            foreach (var step in plan.Steps)
            {
                var stepResult = await ExecuteEvolutionStep(step);
                results.Add(stepResult);
            }
            
            return new EvolutionResult(results);
        }
        
        private async Task&lt;EvolutionStepResult&gt; ExecuteEvolutionStep(EvolutionStep step)
        {
            switch (step.Type)
            {
                case EvolutionStepType.PromoteToCore:
                    return await PromoteToCoreDomain(step);
                case EvolutionStepType.DemoteToSupporting:
                    return await DemoteToSupportingSubdomain(step);
                case EvolutionStepType.MoveToGeneric:
                    return await MoveToGenericSubdomain(step);
                default:
                    throw new InvalidOperationException($&quot;Unknown evolution step type: {step.Type}&quot;);
            }
        }
        
        private async Task&lt;EvolutionStepResult&gt; PromoteToCoreDomain(EvolutionStep step)
        {
            // Promote functionality to core domain
            // This happens when functionality becomes competitive advantage
            await _domainRepository.PromoteToCore(step.DomainId);
            return EvolutionStepResult.Success($&quot;Promoted {step.DomainId} to core domain&quot;);
        }
        
        private async Task&lt;EvolutionStepResult&gt; DemoteToSupportingSubdomain(EvolutionStep step)
        {
            // Demote functionality to supporting subdomain
            // This happens when functionality is important but not unique
            await _domainRepository.DemoteToSupporting(step.DomainId);
            return EvolutionStepResult.Success($&quot;Demoted {step.DomainId} to supporting subdomain&quot;);
        }
        
        private async Task&lt;EvolutionStepResult&gt; MoveToGenericSubdomain(EvolutionStep step)
        {
            // Move functionality to generic subdomain
            // This happens when functionality becomes common across industries
            await _domainRepository.MoveToGeneric(step.DomainId);
            return EvolutionStepResult.Success($&quot;Moved {step.DomainId} to generic subdomain&quot;);
        }
    }
    
    public class EvolutionRequest
    {
        public string Reason { get; set; }
        public List&lt;string&gt; AffectedDomains { get; set; }
        public EvolutionType Type { get; set; }
    }
    
    public enum EvolutionType
    {
        PromoteToCore,
        DemoteToSupporting,
        MoveToGeneric
    }
    
    public class EvolutionPlan
    {
        public List&lt;EvolutionStep&gt; Steps { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
    }
    
    public class EvolutionStep
    {
        public string DomainId { get; set; }
        public EvolutionStepType Type { get; set; }
        public string Reason { get; set; }
    }
    
    public enum EvolutionStepType
    {
        PromoteToCore,
        DemoteToSupporting,
        MoveToGeneric
    }
}
</code></pre>
<h3>2. Strategic Pattern Monitoring</h3>
<p><strong>C# Example - Strategic Pattern Monitoring</strong></p>
<pre><code class="language-csharp">// Strategic pattern monitoring
namespace EcommerceApp.StrategicMonitoring
{
    public class StrategicPatternMonitoringService
    {
        public async Task&lt;StrategicPatternReport&gt; GenerateStrategicPatternReport()
        {
            var report = new StrategicPatternReport
            {
                GeneratedAt = DateTime.UtcNow,
                Patterns = new List&lt;StrategicPatternMetrics&gt;()
            };
            
            // Monitor core domain
            var coreDomainMetrics = await MonitorCoreDomain();
            report.Patterns.Add(coreDomainMetrics);
            
            // Monitor supporting subdomains
            var supportingSubdomainMetrics = await MonitorSupportingSubdomains();
            report.Patterns.AddRange(supportingSubdomainMetrics);
            
            // Monitor generic subdomains
            var genericSubdomainMetrics = await MonitorGenericSubdomains();
            report.Patterns.AddRange(genericSubdomainMetrics);
            
            return report;
        }
        
        private async Task&lt;StrategicPatternMetrics&gt; MonitorCoreDomain()
        {
            return new StrategicPatternMetrics
            {
                PatternType = StrategicPatternType.CoreDomain,
                Name = &quot;Order Processing&quot;,
                ResourceAllocation = 60, // 60% of resources
                TeamSize = 8, // 8 developers
                SkillLevel = SkillLevel.High, // High skill level
                InvestmentLevel = InvestmentLevel.High, // High investment
                PerformanceMetrics = await GetCoreDomainPerformanceMetrics()
            };
        }
        
        private async Task&lt;List&lt;StrategicPatternMetrics&gt;&gt; MonitorSupportingSubdomains()
        {
            var metrics = new List&lt;StrategicPatternMetrics&gt;();
            
            metrics.Add(new StrategicPatternMetrics
            {
                PatternType = StrategicPatternType.SupportingSubdomain,
                Name = &quot;Customer Management&quot;,
                ResourceAllocation = 25, // 25% of resources
                TeamSize = 4, // 4 developers
                SkillLevel = SkillLevel.Medium, // Medium skill level
                InvestmentLevel = InvestmentLevel.Medium, // Medium investment
                PerformanceMetrics = await GetSupportingSubdomainPerformanceMetrics(&quot;Customer Management&quot;)
            });
            
            return metrics;
        }
        
        private async Task&lt;List&lt;StrategicPatternMetrics&gt;&gt; MonitorGenericSubdomains()
        {
            var metrics = new List&lt;StrategicPatternMetrics&gt;();
            
            metrics.Add(new StrategicPatternMetrics
            {
                PatternType = StrategicPatternType.GenericSubdomain,
                Name = &quot;Authentication&quot;,
                ResourceAllocation = 15, // 15% of resources
                TeamSize = 2, // 2 developers
                SkillLevel = SkillLevel.Low, // Low skill level
                InvestmentLevel = InvestmentLevel.Low, // Low investment
                PerformanceMetrics = await GetGenericSubdomainPerformanceMetrics(&quot;Authentication&quot;)
            });
            
            return metrics;
        }
        
        private async Task&lt;PerformanceMetrics&gt; GetCoreDomainPerformanceMetrics()
        {
            return new PerformanceMetrics
            {
                ResponseTime = TimeSpan.FromMilliseconds(100), // Fast response time
                Throughput = 1000, // High throughput
                ErrorRate = 0.01, // Low error rate
                Availability = 0.999 // High availability
            };
        }
        
        private async Task&lt;PerformanceMetrics&gt; GetSupportingSubdomainPerformanceMetrics(string subdomain)
        {
            return new PerformanceMetrics
            {
                ResponseTime = TimeSpan.FromMilliseconds(500), // Medium response time
                Throughput = 500, // Medium throughput
                ErrorRate = 0.05, // Medium error rate
                Availability = 0.99 // Medium availability
            };
        }
        
        private async Task&lt;PerformanceMetrics&gt; GetGenericSubdomainPerformanceMetrics(string subdomain)
        {
            return new PerformanceMetrics
            {
                ResponseTime = TimeSpan.FromMilliseconds(1000), // Slow response time
                Throughput = 100, // Low throughput
                ErrorRate = 0.1, // High error rate
                Availability = 0.95 // Low availability
            };
        }
    }
    
    public class StrategicPatternReport
    {
        public DateTime GeneratedAt { get; set; }
        public List&lt;StrategicPatternMetrics&gt; Patterns { get; set; }
    }
    
    public class StrategicPatternMetrics
    {
        public StrategicPatternType PatternType { get; set; }
        public string Name { get; set; }
        public int ResourceAllocation { get; set; } // Percentage
        public int TeamSize { get; set; }
        public SkillLevel SkillLevel { get; set; }
        public InvestmentLevel InvestmentLevel { get; set; }
        public PerformanceMetrics PerformanceMetrics { get; set; }
    }
    
    public enum StrategicPatternType
    {
        CoreDomain,
        SupportingSubdomain,
        GenericSubdomain
    }
    
    public enum SkillLevel
    {
        Low,
        Medium,
        High
    }
    
    public enum InvestmentLevel
    {
        Low,
        Medium,
        High
    }
    
    public class PerformanceMetrics
    {
        public TimeSpan ResponseTime { get; set; }
        public int Throughput { get; set; }
        public double ErrorRate { get; set; }
        public double Availability { get; set; }
    }
}
</code></pre>
<h3>3. Strategic Pattern Governance</h3>
<p><strong>C# Example - Strategic Pattern Governance</strong></p>
<pre><code class="language-csharp">// Strategic pattern governance
namespace EcommerceApp.StrategicGovernance
{
    public class StrategicPatternGovernanceService
    {
        public async Task&lt;GovernanceResult&gt; EnforceStrategicPatterns(GovernanceRequest request)
        {
            // Enforce strategic patterns across the organization
            var violations = await _violationDetector.DetectViolations(request);
            var enforcementActions = await _enforcementPlanner.PlanEnforcementActions(violations);
            
            // Execute enforcement actions
            var enforcementResult = await ExecuteEnforcementActions(enforcementActions);
            
            return enforcementResult;
        }
        
        private async Task&lt;GovernanceResult&gt; ExecuteEnforcementActions(List&lt;EnforcementAction&gt; actions)
        {
            var results = new List&lt;EnforcementActionResult&gt;();
            
            foreach (var action in actions)
            {
                var result = await ExecuteEnforcementAction(action);
                results.Add(result);
            }
            
            return new GovernanceResult(results);
        }
        
        private async Task&lt;EnforcementActionResult&gt; ExecuteEnforcementAction(EnforcementAction action)
        {
            switch (action.Type)
            {
                case EnforcementActionType.ResourceReallocation:
                    return await ReallocateResources(action);
                case EnforcementActionType.TeamReorganization:
                    return await ReorganizeTeam(action);
                case EnforcementActionType.TechnologyChange:
                    return await ChangeTechnology(action);
                default:
                    throw new InvalidOperationException($&quot;Unknown enforcement action type: {action.Type}&quot;);
            }
        }
        
        private async Task&lt;EnforcementActionResult&gt; ReallocateResources(EnforcementAction action)
        {
            // Reallocate resources based on strategic patterns
            await _resourceManager.ReallocateResources(action.DomainId, action.ResourceAllocation);
            return EnforcementActionResult.Success($&quot;Reallocated resources for {action.DomainId}&quot;);
        }
        
        private async Task&lt;EnforcementActionResult&gt; ReorganizeTeam(EnforcementAction action)
        {
            // Reorganize team based on strategic patterns
            await _teamManager.ReorganizeTeam(action.TeamId, action.TeamStructure);
            return EnforcementActionResult.Success($&quot;Reorganized team {action.TeamId}&quot;);
        }
        
        private async Task&lt;EnforcementActionResult&gt; ChangeTechnology(EnforcementAction action)
        {
            // Change technology based on strategic patterns
            await _technologyManager.ChangeTechnology(action.DomainId, action.Technology);
            return EnforcementActionResult.Success($&quot;Changed technology for {action.DomainId}&quot;);
        }
    }
    
    public class GovernanceRequest
    {
        public string OrganizationId { get; set; }
        public List&lt;string&gt; DomainIds { get; set; }
        public GovernanceType Type { get; set; }
    }
    
    public enum GovernanceType
    {
        ResourceAllocation,
        TeamOrganization,
        TechnologyChoice
    }
    
    public class EnforcementAction
    {
        public string DomainId { get; set; }
        public EnforcementActionType Type { get; set; }
        public int ResourceAllocation { get; set; }
        public string TeamId { get; set; }
        public TeamStructure TeamStructure { get; set; }
        public string Technology { get; set; }
    }
    
    public enum EnforcementActionType
    {
        ResourceReallocation,
        TeamReorganization,
        TechnologyChange
    }
    
    public class TeamStructure
    {
        public int TeamSize { get; set; }
        public SkillLevel RequiredSkillLevel { get; set; }
        public List&lt;string&gt; Responsibilities { get; set; }
    }
}
</code></pre>
<h2>Summary</h2>
<p>Strategic patterns provide guidance for organizing domain-driven systems at a high level. By understanding how to:</p>
<ul>
<li><strong>Identify core domains</strong> that provide competitive advantage</li>
<li><strong>Recognize generic subdomains</strong> that are common across industries</li>
<li><strong>Understand supporting subdomains</strong> that are important but not unique</li>
<li><strong>Design domain-driven architectures</strong> that reflect domain structure</li>
<li><strong>Organize teams</strong> around domain concepts</li>
<li><strong>Allocate resources</strong> based on business value</li>
<li><strong>Monitor strategic patterns</strong> and their effectiveness</li>
<li><strong>Govern strategic patterns</strong> across the organization</li>
<li><strong>Evolve strategic patterns</strong> as understanding deepens</li>
<li><strong>Avoid common pitfalls</strong> that lead to poor strategic design</li>
</ul>
<p>Teams can build maintainable, scalable systems that truly serve business needs. The key to successful strategic design is identifying the core domain, allocating resources appropriately, organizing teams around domain concepts, and designing architectures that support domain modeling.</p>
<p><strong>Next Steps</strong>: Consider exploring tactical patterns, implementation techniques, and advanced DDD topics to deepen your understanding of Domain-Driven Design.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/5-Strategic-Patterns/README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"5-Strategic-Patterns\",\"README\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/5-Strategic-Patterns/README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
