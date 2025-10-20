1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/1-Bounded-Contexts/README","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"1-Bounded-Contexts\",\"README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:Tb554,<h1>Bounded Contexts</h1>
<h2>Name</h2>
<p><strong>Bounded Contexts</strong> - The Foundation of Domain-Driven Design</p>
<h2>Goal of the Concept</h2>
<p>A bounded context defines the boundary within which a particular domain model is valid and meaningful. It represents the scope of a domain model and helps manage complexity by creating clear boundaries between different parts of the system.</p>
<h2>Theoretical Foundation</h2>
<h3>Eric Evans&#39; Original Definition</h3>
<p>Eric Evans introduced bounded contexts as a way to manage the complexity of large domain models. He recognized that trying to create a single, unified model for an entire enterprise leads to confusion and complexity that makes the model unusable.</p>
<h3>Context and Meaning</h3>
<p>The concept is based on the linguistic principle that the meaning of words depends on their context. The same term can have different meanings in different contexts, and trying to force a single meaning across all contexts leads to confusion and miscommunication.</p>
<h3>Complexity Management</h3>
<p>Bounded contexts provide a way to manage complexity by:</p>
<ul>
<li>Limiting the scope of any single model</li>
<li>Allowing different teams to work independently</li>
<li>Enabling different models to evolve at their own pace</li>
<li>Providing clear boundaries for testing and validation</li>
</ul>
<h3>Organizational Alignment</h3>
<p>Bounded contexts often align with organizational boundaries, reflecting how different teams or departments think about the same concepts differently. This alignment helps create software that matches the organization&#39;s structure and communication patterns.</p>
<h2>Consequences of Not Using Bounded Contexts</h2>
<h3>Unique Bounded Context Issues</h3>
<p><strong>Model Confusion</strong></p>
<ul>
<li>Different parts of the system use the same terms with different meanings</li>
<li>Developers and business stakeholders become confused about concepts</li>
<li>The domain model becomes inconsistent and hard to understand</li>
<li>Changes in one area unexpectedly affect other areas</li>
</ul>
<p><strong>Team Coordination Problems</strong></p>
<ul>
<li>Teams step on each other&#39;s toes when working on shared models</li>
<li>Integration becomes complex and error-prone</li>
<li>Knowledge sharing becomes difficult</li>
<li>Different teams make conflicting assumptions</li>
</ul>
<p><strong>Technical Complexity</strong></p>
<ul>
<li>Large, monolithic models become hard to maintain</li>
<li>Testing becomes complex due to unclear boundaries</li>
<li>Performance issues arise from overly complex models</li>
<li>Refactoring becomes risky and time-consuming</li>
</ul>
<h2>Impact on System Architecture</h2>
<h3>Architectural Benefits</h3>
<p><strong>Clear Boundaries</strong></p>
<ul>
<li>Well-defined interfaces between different parts of the system</li>
<li>Clear ownership and responsibility for different areas</li>
<li>Easier to understand system structure and dependencies</li>
<li>Better separation of concerns</li>
</ul>
<p><strong>Independent Evolution</strong></p>
<ul>
<li>Different contexts can evolve at their own pace</li>
<li>Changes in one context don&#39;t necessarily affect others</li>
<li>Teams can work independently on their contexts</li>
<li>Easier to scale development efforts</li>
</ul>
<h3>Architectural Challenges</h3>
<p><strong>Integration Complexity</strong></p>
<ul>
<li>Need to manage communication between contexts</li>
<li>Data consistency across boundaries becomes complex</li>
<li>Performance considerations for cross-context operations</li>
<li>Error handling and recovery across boundaries</li>
</ul>
<h2>Role in Domain-Driven Design</h2>
<p>Bounded contexts are fundamental to Domain-Driven Design because they:</p>
<ul>
<li><strong>Define the scope</strong> of domain models and ubiquitous language</li>
<li><strong>Enable team autonomy</strong> by providing clear boundaries</li>
<li><strong>Support model evolution</strong> by allowing independent development</li>
<li><strong>Facilitate communication</strong> by creating shared understanding within boundaries</li>
<li><strong>Manage complexity</strong> by breaking large problems into smaller, manageable pieces</li>
</ul>
<h2>How to Identify Bounded Contexts</h2>
<h3>1. Look for Language Differences</h3>
<p><strong>What it means</strong>: Different teams or departments use the same terms with different meanings, or they have different vocabularies for the same concepts.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Interview different teams about the same business concepts</li>
<li>Look for terms that mean different things in different areas</li>
<li>Identify vocabulary that is specific to certain groups</li>
<li>Notice when the same concept is described differently</li>
</ul>
<p><strong>Example</strong>: In an e-commerce system, &quot;customer&quot; might mean different things to the sales team (prospect, lead, client) versus the support team (user with issues) versus the accounting team (entity that owes money).</p>
<h3>2. Identify Organizational Boundaries</h3>
<p><strong>What it means</strong>: Different teams or departments have different responsibilities and ways of working, which often leads to different mental models.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Map the organizational structure and responsibilities</li>
<li>Identify teams that work independently</li>
<li>Look for different reporting structures or metrics</li>
<li>Notice different tools and processes used by different groups</li>
</ul>
<p><strong>Example</strong>: The marketing team thinks about &quot;campaigns&quot; and &quot;leads,&quot; while the sales team thinks about &quot;opportunities&quot; and &quot;deals.&quot; These represent different bounded contexts even though they&#39;re related.</p>
<h3>3. Find Model Inconsistencies</h3>
<p><strong>What it means</strong>: When you try to create a unified model, you find contradictions or conflicts that can&#39;t be resolved without losing important distinctions.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Attempt to create a single model for related concepts</li>
<li>Look for contradictions or conflicts in the model</li>
<li>Identify concepts that have different attributes in different areas</li>
<li>Notice when the same entity behaves differently in different contexts</li>
</ul>
<p><strong>Example</strong>: A &quot;product&quot; in the catalog context has different attributes and behaviors than a &quot;product&quot; in the inventory context, even though they refer to the same physical item.</p>
<h3>4. Recognize Different Lifecycles</h3>
<p><strong>What it means</strong>: Different parts of the system have different rates of change, different stakeholders, or different business rules.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify areas that change at different rates</li>
<li>Look for different stakeholders with different priorities</li>
<li>Notice different business rules or validation requirements</li>
<li>Find areas with different performance or scalability requirements</li>
</ul>
<p><strong>Example</strong>: User authentication changes slowly and has strict security requirements, while content management changes frequently and has flexible requirements.</p>
<h3>5. Analyze Data Dependencies</h3>
<p><strong>What it means</strong>: Different parts of the system need different views of the same data, or they need to access data at different times or frequencies.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Map data flows and dependencies</li>
<li>Identify different data access patterns</li>
<li>Look for different data consistency requirements</li>
<li>Notice different data retention or archival needs</li>
</ul>
<p><strong>Example</strong>: The order processing system needs real-time inventory data, while the reporting system can work with daily snapshots of the same data.</p>
<h2>Examples of Bounded Context Identification</h2>
<h3>E-commerce System Example</h3>
<p><strong>Customer Context</strong></p>
<ul>
<li>Focus: Customer relationship management</li>
<li>Key concepts: Customer, Contact, Communication Preferences</li>
<li>Language: &quot;customer,&quot; &quot;contact,&quot; &quot;engagement&quot;</li>
<li>Boundaries: Customer data, preferences, communication history</li>
</ul>
<p><strong>Order Context</strong></p>
<ul>
<li>Focus: Order processing and fulfillment</li>
<li>Key concepts: Order, OrderItem, ShippingAddress, Payment</li>
<li>Language: &quot;order,&quot; &quot;cart,&quot; &quot;checkout,&quot; &quot;fulfillment&quot;</li>
<li>Boundaries: Order lifecycle, payment processing, shipping</li>
</ul>
<p><strong>Inventory Context</strong></p>
<ul>
<li>Focus: Product availability and stock management</li>
<li>Key concepts: Product, Stock, Warehouse, Supplier</li>
<li>Language: &quot;inventory,&quot; &quot;stock,&quot; &quot;warehouse,&quot; &quot;supplier&quot;</li>
<li>Boundaries: Stock levels, warehouse operations, supplier relationships</li>
</ul>
<p><strong>Catalog Context</strong></p>
<ul>
<li>Focus: Product information and presentation</li>
<li>Key concepts: Product, Category, Price, Description</li>
<li>Language: &quot;catalog,&quot; &quot;product,&quot; &quot;category,&quot; &quot;pricing&quot;</li>
<li>Boundaries: Product information, categorization, pricing rules</li>
</ul>
<h3>Banking System Example</h3>
<p><strong>Account Management Context</strong></p>
<ul>
<li>Focus: Account lifecycle and basic operations</li>
<li>Key concepts: Account, AccountHolder, Balance, Transaction</li>
<li>Language: &quot;account,&quot; &quot;balance,&quot; &quot;transaction,&quot; &quot;statement&quot;</li>
<li>Boundaries: Account creation, balance inquiries, basic transactions</li>
</ul>
<p><strong>Loan Processing Context</strong></p>
<ul>
<li>Focus: Loan applications and approvals</li>
<li>Key concepts: LoanApplication, CreditCheck, Approval, Terms</li>
<li>Language: &quot;loan,&quot; &quot;application,&quot; &quot;credit,&quot; &quot;approval&quot;</li>
<li>Boundaries: Loan application process, credit evaluation, approval workflow</li>
</ul>
<p><strong>Payment Processing Context</strong></p>
<ul>
<li>Focus: Payment execution and settlement</li>
<li>Key concepts: Payment, PaymentMethod, Settlement, Clearing</li>
<li>Language: &quot;payment,&quot; &quot;settlement,&quot; &quot;clearing,&quot; &quot;routing&quot;</li>
<li>Boundaries: Payment execution, settlement processes, clearing operations</li>
</ul>
<h2>How This Concept Helps with System Design</h2>
<ol>
<li><strong>Clear Boundaries</strong>: Each context has well-defined responsibilities and interfaces</li>
<li><strong>Team Autonomy</strong>: Different teams can work independently on their contexts</li>
<li><strong>Model Clarity</strong>: Each context has a clear, focused domain model</li>
<li><strong>Reduced Complexity</strong>: Large problems are broken into manageable pieces</li>
<li><strong>Better Communication</strong>: Teams share a common language within their context</li>
</ol>
<h2>How This Concept Helps with Development</h2>
<ol>
<li><strong>Independent Development</strong>: Teams can work on their contexts without coordination</li>
<li><strong>Focused Testing</strong>: Each context can be tested independently</li>
<li><strong>Easier Refactoring</strong>: Changes are contained within context boundaries</li>
<li><strong>Clear Ownership</strong>: Each context has clear ownership and responsibility</li>
<li><strong>Scalable Development</strong>: Multiple teams can work in parallel</li>
</ol>
<h2>Common Patterns and Anti-patterns</h2>
<h3>Patterns</h3>
<p><strong>Shared Kernel</strong></p>
<ul>
<li>Two teams share a small, common model</li>
<li>Used when contexts are closely related but need some independence</li>
<li>Requires close coordination between teams</li>
</ul>
<p><strong>Customer-Supplier</strong></p>
<ul>
<li>One context provides services to another</li>
<li>Clear upstream-downstream relationship</li>
<li>Supplier context has more control over the interface</li>
</ul>
<p><strong>Conformist</strong></p>
<ul>
<li>Downstream context conforms to upstream model</li>
<li>Used when the downstream context has less influence</li>
<li>Simpler integration but less flexibility</li>
</ul>
<p><strong>Anti-Corruption Layer</strong></p>
<ul>
<li>Downstream context translates upstream model to its own model</li>
<li>Used when upstream model doesn&#39;t fit downstream needs</li>
<li>More complex but provides better isolation</li>
</ul>
<h3>Anti-patterns</h3>
<p><strong>Big Ball of Mud</strong></p>
<ul>
<li>No clear boundaries between different areas</li>
<li>Everything is connected to everything else</li>
<li>Difficult to understand, test, or modify</li>
</ul>
<p><strong>Anemic Domain Model</strong></p>
<ul>
<li>Context has no behavior, only data</li>
<li>Business logic is scattered throughout the system</li>
<li>Difficult to understand business rules</li>
</ul>
<p><strong>God Context</strong></p>
<ul>
<li>One context tries to handle everything</li>
<li>Becomes too large and complex</li>
<li>Difficult to maintain and evolve</li>
</ul>
<h2>Summary</h2>
<p>Bounded contexts are the foundation of Domain-Driven Design, providing a way to manage complexity by creating clear boundaries around domain models. By identifying and defining bounded contexts, teams can:</p>
<ul>
<li><strong>Work independently</strong> on different parts of the system</li>
<li><strong>Maintain clear models</strong> that reflect business reality</li>
<li><strong>Communicate effectively</strong> using shared language within boundaries</li>
<li><strong>Evolve systems</strong> incrementally without affecting other areas</li>
<li><strong>Scale development</strong> efforts across multiple teams</li>
</ul>
<p>The key to successful bounded context identification is looking for differences in language, organizational structure, model requirements, and system behavior. Once identified, bounded contexts provide the foundation for all other Domain-Driven Design practices.</p>
<h2>Exercise 1: Identify Bounded Contexts</h2>
<h3>Objective</h3>
<p>Analyze a complex business domain and identify potential bounded contexts.</p>
<h3>Task</h3>
<p>Choose a business domain (e-commerce, banking, healthcare, etc.) and identify 3-5 potential bounded contexts.</p>
<ol>
<li><strong>Map the Domain</strong>: Create a high-level map of the business domain</li>
<li><strong>Identify Language Differences</strong>: Look for terms that mean different things in different areas</li>
<li><strong>Find Organizational Boundaries</strong>: Identify different teams or departments</li>
<li><strong>Look for Model Inconsistencies</strong>: Find concepts that behave differently in different areas</li>
<li><strong>Document Contexts</strong>: Create a brief description of each identified context</li>
</ol>
<h3>Deliverables</h3>
<ul>
<li>Domain map showing different areas</li>
<li>List of identified bounded contexts with descriptions</li>
<li>Analysis of language differences between contexts</li>
<li>Rationale for context boundaries</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Choose a business domain you&#39;re familiar with</li>
<li>Map out the main business processes and areas</li>
<li>Interview different stakeholders about key concepts</li>
<li>Look for differences in terminology and understanding</li>
<li>Identify natural boundaries in the domain</li>
</ol>
<hr>
<h2>Exercise 2: Define Context Boundaries</h2>
<h3>Objective</h3>
<p>Define clear boundaries and responsibilities for identified bounded contexts.</p>
<h3>Task</h3>
<p>Take the bounded contexts from Exercise 1 and define their boundaries, responsibilities, and interfaces.</p>
<ol>
<li><strong>Define Responsibilities</strong>: Clearly state what each context is responsible for</li>
<li><strong>Identify Key Concepts</strong>: List the main domain concepts in each context</li>
<li><strong>Define Interfaces</strong>: Specify how contexts will interact with each other</li>
<li><strong>Document Dependencies</strong>: Map dependencies between contexts</li>
<li><strong>Validate Boundaries</strong>: Ensure boundaries make sense and are maintainable</li>
</ol>
<h3>Success Criteria</h3>
<ul>
<li>Clear, well-defined boundaries for each context</li>
<li>Minimal dependencies between contexts</li>
<li>Clear ownership and responsibility</li>
<li>Practical interfaces for context interaction</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Use your identified contexts from Exercise 1</li>
<li>Define what each context is responsible for</li>
<li>Identify the key concepts and entities in each context</li>
<li>Design simple interfaces for context interaction</li>
<li>Validate that boundaries are practical and maintainable</li>
</ol>
<h3>Implementation Best Practices</h3>
<h4>Context Definition</h4>
<ol>
<li><strong>Clear Responsibilities</strong>: Each context should have a single, clear responsibility</li>
<li><strong>Minimal Dependencies</strong>: Contexts should be as independent as possible</li>
<li><strong>Stable Interfaces</strong>: Interfaces between contexts should be stable and well-defined</li>
<li><strong>Ownership</strong>: Each context should have clear ownership and decision-making authority</li>
</ol>
<h4>Documentation</h4>
<ol>
<li><strong>Context Map</strong>: Visual representation of contexts and their relationships</li>
<li><strong>Responsibility Matrix</strong>: Clear definition of what each context owns</li>
<li><strong>Interface Specifications</strong>: Detailed specifications of context interfaces</li>
<li><strong>Dependency Graph</strong>: Map of dependencies between contexts</li>
</ol>
<h3>Learning Objectives</h3>
<p>After completing both exercises, you should be able to:</p>
<ul>
<li>Identify potential bounded contexts in complex domains</li>
<li>Define clear boundaries and responsibilities</li>
<li>Design interfaces between contexts</li>
<li>Understand the trade-offs in context design</li>
<li>Apply bounded context concepts to real projects</li>
</ul>
<h2>Implementation Patterns and Code Examples</h2>
<h3>Context Implementation Patterns</h3>
<h4>1. Context as Separate Modules/Packages</h4>
<p><strong>C# Example - Separate Assemblies</strong></p>
<pre><code class="language-csharp">// CustomerContext assembly
namespace CustomerContext
{
    public class Customer
    {
        public CustomerId Id { get; private set; }
        public string Name { get; private set; }
        public EmailAddress Email { get; private set; }
        public CustomerStatus Status { get; private set; }
        
        public Customer(CustomerId id, string name, EmailAddress email)
        {
            Id = id ?? throw new ArgumentNullException(nameof(id));
            Name = name ?? throw new ArgumentNullException(nameof(name));
            Email = email ?? throw new ArgumentNullException(nameof(email));
            Status = CustomerStatus.Active;
        }
        
        public void UpdateEmail(EmailAddress newEmail)
        {
            if (newEmail == null) throw new ArgumentNullException(nameof(newEmail));
            Email = newEmail;
        }
        
        public bool CanPlaceOrder()
        {
            return Status == CustomerStatus.Active;
        }
    }
    
    public class CustomerService
    {
        private readonly ICustomerRepository _customerRepository;
        
        public CustomerService(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository ?? throw new ArgumentNullException(nameof(customerRepository));
        }
        
        public async Task&lt;Customer&gt; RegisterCustomer(string name, EmailAddress email)
        {
            var existingCustomer = await _customerRepository.FindByEmail(email);
            if (existingCustomer != null)
            {
                throw new CustomerAlreadyExistsException($&quot;Customer with email {email} already exists&quot;);
            }
            
            var customerId = CustomerId.Generate();
            var customer = new Customer(customerId, name, email);
            
            await _customerRepository.Save(customer);
            return customer;
        }
    }
}

// OrderContext assembly
namespace OrderContext
{
    public class Order
    {
        public OrderId Id { get; private set; }
        public CustomerId CustomerId { get; private set; } // Reference to customer
        public OrderStatus Status { get; private set; }
        public Money TotalAmount { get; private set; }
        private readonly List&lt;OrderItem&gt; _items = new List&lt;OrderItem&gt;();
        
        public Order(OrderId id, CustomerId customerId)
        {
            Id = id ?? throw new ArgumentNullException(nameof(id));
            CustomerId = customerId ?? throw new ArgumentNullException(nameof(customerId));
            Status = OrderStatus.Draft;
            TotalAmount = Money.Zero;
        }
        
        public void AddItem(ProductId productId, Money price, int quantity)
        {
            if (Status != OrderStatus.Draft)
                throw new InvalidOperationException(&quot;Cannot modify confirmed order&quot;);
                
            var item = new OrderItem(productId, price, quantity);
            _items.Add(item);
            RecalculateTotal();
        }
        
        public void Confirm()
        {
            if (Status != OrderStatus.Draft)
                throw new InvalidOperationException(&quot;Only draft orders can be confirmed&quot;);
                
            if (!_items.Any())
                throw new InvalidOperationException(&quot;Cannot confirm empty order&quot;);
                
            Status = OrderStatus.Confirmed;
        }
        
        private void RecalculateTotal()
        {
            TotalAmount = _items.Sum(item =&gt; item.TotalPrice);
        }
    }
}
</code></pre>
<p><strong>Java Example - Separate Packages</strong></p>
<pre><code class="language-java">// Customer context package
package com.ecommerce.customer;

public class Customer {
    private final CustomerId id;
    private String name;
    private EmailAddress email;
    private CustomerStatus status;
    
    public Customer(CustomerId id, String name, EmailAddress email) {
        this.id = Objects.requireNonNull(id, &quot;Customer ID cannot be null&quot;);
        this.name = Objects.requireNonNull(name, &quot;Customer name cannot be null&quot;);
        this.email = Objects.requireNonNull(email, &quot;Customer email cannot be null&quot;);
        this.status = CustomerStatus.ACTIVE;
    }
    
    public void updateEmail(EmailAddress newEmail) {
        if (newEmail == null) throw new IllegalArgumentException(&quot;Email cannot be null&quot;);
        this.email = newEmail;
    }
    
    public boolean canPlaceOrder() {
        return status == CustomerStatus.ACTIVE;
    }
    
    // Getters
    public CustomerId getId() { return id; }
    public String getName() { return name; }
    public EmailAddress getEmail() { return email; }
    public CustomerStatus getStatus() { return status; }
}

// Order context package
package com.ecommerce.order;

public class Order {
    private final OrderId id;
    private final CustomerId customerId; // Reference to customer
    private OrderStatus status;
    private Money totalAmount;
    private final List&lt;OrderItem&gt; items = new ArrayList&lt;&gt;();
    
    public Order(OrderId id, CustomerId customerId) {
        this.id = Objects.requireNonNull(id, &quot;Order ID cannot be null&quot;);
        this.customerId = Objects.requireNonNull(customerId, &quot;Customer ID cannot be null&quot;);
        this.status = OrderStatus.DRAFT;
        this.totalAmount = Money.zero();
    }
    
    public void addItem(ProductId productId, Money price, int quantity) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException(&quot;Cannot modify confirmed order&quot;);
        }
        
        OrderItem item = new OrderItem(productId, price, quantity);
        items.add(item);
        recalculateTotal();
    }
    
    public void confirm() {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException(&quot;Only draft orders can be confirmed&quot;);
        }
        
        if (items.isEmpty()) {
            throw new IllegalStateException(&quot;Cannot confirm empty order&quot;);
        }
        
        this.status = OrderStatus.CONFIRMED;
    }
    
    private void recalculateTotal() {
        this.totalAmount = items.stream()
            .map(OrderItem::getTotalPrice)
            .reduce(Money.zero(), Money::add);
    }
}
</code></pre>
<p><strong>TypeScript Example - Separate Modules</strong></p>
<pre><code class="language-typescript">// Customer context module
export namespace CustomerContext {
    export class Customer {
        private readonly id: CustomerId;
        private name: string;
        private email: EmailAddress;
        private status: CustomerStatus;
        
        constructor(id: CustomerId, name: string, email: EmailAddress) {
            if (!id) throw new Error(&quot;Customer ID cannot be null&quot;);
            if (!name) throw new Error(&quot;Customer name cannot be null&quot;);
            if (!email) throw new Error(&quot;Customer email cannot be null&quot;);
            
            this.id = id;
            this.name = name;
            this.email = email;
            this.status = CustomerStatus.Active;
        }
        
        updateEmail(newEmail: EmailAddress): void {
            if (!newEmail) throw new Error(&quot;Email cannot be null&quot;);
            this.email = newEmail;
        }
        
        canPlaceOrder(): boolean {
            return this.status === CustomerStatus.Active;
        }
        
        // Getters
        getId(): CustomerId { return this.id; }
        getName(): string { return this.name; }
        getEmail(): EmailAddress { return this.email; }
        getStatus(): CustomerStatus { return this.status; }
    }
    
    export class CustomerService {
        constructor(private customerRepository: ICustomerRepository) {}
        
        async registerCustomer(name: string, email: EmailAddress): Promise&lt;Customer&gt; {
            const existingCustomer = await this.customerRepository.findByEmail(email);
            if (existingCustomer) {
                throw new Error(`Customer with email ${email} already exists`);
            }
            
            const customerId = CustomerId.generate();
            const customer = new Customer(customerId, name, email);
            
            await this.customerRepository.save(customer);
            return customer;
        }
    }
}

// Order context module
export namespace OrderContext {
    export class Order {
        private readonly id: OrderId;
        private readonly customerId: CustomerId; // Reference to customer
        private status: OrderStatus;
        private totalAmount: Money;
        private readonly items: OrderItem[] = [];
        
        constructor(id: OrderId, customerId: CustomerId) {
            if (!id) throw new Error(&quot;Order ID cannot be null&quot;);
            if (!customerId) throw new Error(&quot;Customer ID cannot be null&quot;);
            
            this.id = id;
            this.customerId = customerId;
            this.status = OrderStatus.Draft;
            this.totalAmount = Money.zero();
        }
        
        addItem(productId: ProductId, price: Money, quantity: number): void {
            if (this.status !== OrderStatus.Draft) {
                throw new Error(&quot;Cannot modify confirmed order&quot;);
            }
            
            const item = new OrderItem(productId, price, quantity);
            this.items.push(item);
            this.recalculateTotal();
        }
        
        confirm(): void {
            if (this.status !== OrderStatus.Draft) {
                throw new Error(&quot;Only draft orders can be confirmed&quot;);
            }
            
            if (this.items.length === 0) {
                throw new Error(&quot;Cannot confirm empty order&quot;);
            }
            
            this.status = OrderStatus.Confirmed;
        }
        
        private recalculateTotal(): void {
            this.totalAmount = this.items.reduce((total, item) =&gt; 
                total.add(item.getTotalPrice()), Money.zero());
        }
    }
}
</code></pre>
<p><strong>Python Example - Separate Packages</strong></p>
<pre><code class="language-python"># customer_context package
from dataclasses import dataclass
from typing import Optional

@dataclass(frozen=True)
class CustomerId:
    value: str

@dataclass
class Customer:
    id: CustomerId
    name: str
    email: EmailAddress
    status: CustomerStatus
    
    def __init__(self, id: CustomerId, name: str, email: EmailAddress):
        if not id:
            raise ValueError(&quot;Customer ID cannot be null&quot;)
        if not name:
            raise ValueError(&quot;Customer name cannot be null&quot;)
        if not email:
            raise ValueError(&quot;Customer email cannot be null&quot;)
            
        self.id = id
        self.name = name
        self.email = email
        self.status = CustomerStatus.ACTIVE
    
    def update_email(self, new_email: EmailAddress) -&gt; None:
        if not new_email:
            raise ValueError(&quot;Email cannot be null&quot;)
        self.email = new_email
    
    def can_place_order(self) -&gt; bool:
        return self.status == CustomerStatus.ACTIVE

class CustomerService:
    def __init__(self, customer_repository: ICustomerRepository):
        self.customer_repository = customer_repository
    
    async def register_customer(self, name: str, email: EmailAddress) -&gt; Customer:
        existing_customer = await self.customer_repository.find_by_email(email)
        if existing_customer:
            raise ValueError(f&quot;Customer with email {email} already exists&quot;)
        
        customer_id = CustomerId.generate()
        customer = Customer(customer_id, name, email)
        
        await self.customer_repository.save(customer)
        return customer

# order_context package
@dataclass(frozen=True)
class OrderId:
    value: str

@dataclass
class Order:
    id: OrderId
    customer_id: CustomerId  # Reference to customer
    status: OrderStatus
    total_amount: Money
    items: List[OrderItem]
    
    def __init__(self, id: OrderId, customer_id: CustomerId):
        if not id:
            raise ValueError(&quot;Order ID cannot be null&quot;)
        if not customer_id:
            raise ValueError(&quot;Customer ID cannot be null&quot;)
            
        self.id = id
        self.customer_id = customer_id
        self.status = OrderStatus.DRAFT
        self.total_amount = Money.zero()
        self.items = []
    
    def add_item(self, product_id: ProductId, price: Money, quantity: int) -&gt; None:
        if self.status != OrderStatus.DRAFT:
            raise ValueError(&quot;Cannot modify confirmed order&quot;)
        
        item = OrderItem(product_id, price, quantity)
        self.items.append(item)
        self.recalculate_total()
    
    def confirm(self) -&gt; None:
        if self.status != OrderStatus.DRAFT:
            raise ValueError(&quot;Only draft orders can be confirmed&quot;)
        
        if not self.items:
            raise ValueError(&quot;Cannot confirm empty order&quot;)
        
        self.status = OrderStatus.CONFIRMED
    
    def recalculate_total(self) -&gt; None:
        self.total_amount = sum(item.total_price for item in self.items)
</code></pre>
<h3>2. Context Integration Patterns</h3>
<h4>Anti-Corruption Layer Pattern</h4>
<p>When integrating with external systems or legacy code, use an anti-corruption layer to protect your domain model:</p>
<pre><code class="language-csharp">// C# Example - Anti-Corruption Layer
namespace OrderContext
{
    // Internal domain model
    public class Order
    {
        public OrderId Id { get; private set; }
        public CustomerId CustomerId { get; private set; }
        public OrderStatus Status { get; private set; }
        public Money TotalAmount { get; private set; }
        
        // Domain logic here...
    }
    
    // Anti-corruption layer for legacy system integration
    public class LegacyOrderAdapter
    {
        public LegacyOrderData ToLegacyFormat(Order order)
        {
            return new LegacyOrderData
            {
                OrderNumber = order.Id.Value,
                CustomerCode = order.CustomerId.Value,
                Status = MapStatus(order.Status),
                Total = order.TotalAmount.Amount,
                Currency = order.TotalAmount.Currency.Code
            };
        }
        
        public Order FromLegacyFormat(LegacyOrderData legacyOrder)
        {
            return new Order(
                new OrderId(legacyOrder.OrderNumber),
                new CustomerId(legacyOrder.CustomerCode)
            );
        }
        
        private string MapStatus(OrderStatus status)
        {
            return status switch
            {
                OrderStatus.Draft =&gt; &quot;DRAFT&quot;,
                OrderStatus.Confirmed =&gt; &quot;CONFIRMED&quot;,
                OrderStatus.Shipped =&gt; &quot;SHIPPED&quot;,
                OrderStatus.Delivered =&gt; &quot;DELIVERED&quot;,
                OrderStatus.Cancelled =&gt; &quot;CANCELLED&quot;,
                _ =&gt; &quot;UNKNOWN&quot;
            };
        }
    }
}
</code></pre>
<h4>Published Language Pattern</h4>
<p>Use a shared language (often implemented as shared data contracts) for communication between contexts:</p>
<pre><code class="language-csharp">// C# Example - Published Language
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
}

// Usage in Order context
namespace OrderContext
{
    public class OrderEventPublisher
    {
        public void PublishOrderConfirmed(Order order)
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
                    [&quot;Currency&quot;] = order.TotalAmount.Currency.Code
                }
            };
            
            // Publish to message bus or event store
            _eventBus.Publish(eventData);
        }
    }
}
</code></pre>
<h3>3. Context Testing Strategies</h3>
<h4>Unit Testing Within Contexts</h4>
<pre><code class="language-csharp">// C# Example - Context Unit Tests
namespace OrderContext.Tests
{
    [TestClass]
    public class OrderTests
    {
        [TestMethod]
        public void AddItem_WhenOrderIsDraft_ShouldAddItem()
        {
            // Arrange
            var orderId = new OrderId(&quot;order-123&quot;);
            var customerId = new CustomerId(&quot;customer-456&quot;);
            var order = new Order(orderId, customerId);
            var productId = new ProductId(&quot;product-789&quot;);
            var price = new Money(10.00m, Currency.USD);
            
            // Act
            order.AddItem(productId, price, 2);
            
            // Assert
            Assert.AreEqual(1, order.Items.Count);
            Assert.AreEqual(new Money(20.00m, Currency.USD), order.TotalAmount);
        }
        
        [TestMethod]
        public void AddItem_WhenOrderIsConfirmed_ShouldThrowException()
        {
            // Arrange
            var order = CreateConfirmedOrder();
            var productId = new ProductId(&quot;product-789&quot;);
            var price = new Money(10.00m, Currency.USD);
            
            // Act &amp; Assert
            Assert.ThrowsException&lt;InvalidOperationException&gt;(() =&gt; 
                order.AddItem(productId, price, 1));
        }
        
        [TestMethod]
        public void Confirm_WhenOrderIsEmpty_ShouldThrowException()
        {
            // Arrange
            var order = CreateEmptyOrder();
            
            // Act &amp; Assert
            Assert.ThrowsException&lt;InvalidOperationException&gt;(() =&gt; 
                order.Confirm());
        }
        
        private Order CreateConfirmedOrder()
        {
            var order = new Order(new OrderId(&quot;order-123&quot;), new CustomerId(&quot;customer-456&quot;));
            order.AddItem(new ProductId(&quot;product-789&quot;), new Money(10.00m, Currency.USD), 1);
            order.Confirm();
            return order;
        }
        
        private Order CreateEmptyOrder()
        {
            return new Order(new OrderId(&quot;order-123&quot;), new CustomerId(&quot;customer-456&quot;));
        }
    }
}
</code></pre>
<h4>Integration Testing Between Contexts</h4>
<pre><code class="language-csharp">// C# Example - Cross-Context Integration Tests
[TestClass]
public class OrderCustomerIntegrationTests
{
    [TestMethod]
    public async Task CreateOrder_WithValidCustomer_ShouldSucceed()
    {
        // Arrange
        var customer = await _customerService.RegisterCustomer(&quot;John Doe&quot;, new EmailAddress(&quot;john@example.com&quot;));
        var orderId = new OrderId(&quot;order-123&quot;);
        
        // Act
        var order = new Order(orderId, customer.Id);
        order.AddItem(new ProductId(&quot;product-789&quot;), new Money(10.00m, Currency.USD), 1);
        order.Confirm();
        
        // Assert
        Assert.AreEqual(OrderStatus.Confirmed, order.Status);
        Assert.AreEqual(customer.Id, order.CustomerId);
    }
    
    [TestMethod]
    public async Task CreateOrder_WithInactiveCustomer_ShouldFail()
    {
        // Arrange
        var customer = await _customerService.RegisterCustomer(&quot;John Doe&quot;, new EmailAddress(&quot;john@example.com&quot;));
        customer.Deactivate();
        var orderId = new OrderId(&quot;order-123&quot;);
        
        // Act &amp; Assert
        Assert.ThrowsException&lt;InvalidOperationException&gt;(() =&gt; 
            new Order(orderId, customer.Id));
    }
}
</code></pre>
<h2>Common Pitfalls and How to Avoid Them</h2>
<h3>1. Context Boundaries Too Small</h3>
<p><strong>Problem</strong>: Creating too many small contexts that don&#39;t provide value</p>
<pre><code class="language-csharp">// Bad - Too granular
namespace CustomerNameContext { }
namespace CustomerEmailContext { }
namespace CustomerAddressContext { }
</code></pre>
<p><strong>Solution</strong>: Group related concepts together</p>
<pre><code class="language-csharp">// Good - Appropriate granularity
namespace CustomerContext
{
    public class Customer
    {
        public CustomerId Id { get; private set; }
        public string Name { get; private set; }
        public EmailAddress Email { get; private set; }
        public Address Address { get; private set; }
        // Related customer concepts together
    }
}
</code></pre>
<h3>2. Context Boundaries Too Large</h3>
<p><strong>Problem</strong>: Creating contexts that are too large and complex</p>
<pre><code class="language-csharp">// Bad - Too large
namespace EcommerceContext
{
    public class Customer { }
    public class Order { }
    public class Product { }
    public class Inventory { }
    public class Payment { }
    public class Shipping { }
    // Everything in one context
}
</code></pre>
<p><strong>Solution</strong>: Split into focused contexts</p>
<pre><code class="language-csharp">// Good - Focused contexts
namespace CustomerContext { public class Customer { } }
namespace OrderContext { public class Order { } }
namespace ProductContext { public class Product { } }
namespace InventoryContext { public class Inventory { } }
namespace PaymentContext { public class Payment { } }
namespace ShippingContext { public class Shipping { } }
</code></pre>
<h3>3. Leaky Context Boundaries</h3>
<p><strong>Problem</strong>: Contexts that know too much about each other</p>
<pre><code class="language-csharp">// Bad - Leaky boundaries
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
<pre><code class="language-csharp">// Good - Clean boundaries
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
<h3>4. Inconsistent Context Models</h3>
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
<h2>Advanced Topics</h2>
<h3>1. Context Evolution</h3>
<p>As your understanding of the domain deepens, contexts may need to evolve:</p>
<pre><code class="language-csharp">// Example: Splitting a context
// Before: Single EcommerceContext
namespace EcommerceContext
{
    public class Order { }
    public class Customer { }
    public class Product { }
}

// After: Split into focused contexts
namespace OrderContext
{
    public class Order { }
    public class OrderItem { }
    public class OrderService { }
}

namespace CustomerContext
{
    public class Customer { }
    public class CustomerService { }
}

namespace ProductContext
{
    public class Product { }
    public class ProductService { }
}
</code></pre>
<h3>2. Context Versioning</h3>
<p>When contexts need to evolve, consider versioning strategies:</p>
<pre><code class="language-csharp">// Example: Versioned context interfaces
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
</code></pre>
<h3>3. Context Monitoring and Metrics</h3>
<p>Monitor context health and performance:</p>
<pre><code class="language-csharp">// Example: Context metrics
public class ContextMetrics
{
    public string ContextName { get; set; }
    public int RequestCount { get; set; }
    public TimeSpan AverageResponseTime { get; set; }
    public int ErrorCount { get; set; }
    public DateTime LastUpdated { get; set; }
}

public class ContextHealthChecker
{
    public async Task&lt;ContextMetrics&gt; GetContextHealth(string contextName)
    {
        // Implementation to check context health
        return new ContextMetrics
        {
            ContextName = contextName,
            RequestCount = await GetRequestCount(contextName),
            AverageResponseTime = await GetAverageResponseTime(contextName),
            ErrorCount = await GetErrorCount(contextName),
            LastUpdated = DateTime.UtcNow
        };
    }
}
</code></pre>
<h2>Summary</h2>
<p>Bounded contexts are the foundation of Domain-Driven Design, providing a way to manage complexity by creating clear boundaries around domain models. By understanding how to:</p>
<ul>
<li><strong>Identify contexts</strong> through language differences and organizational boundaries</li>
<li><strong>Implement contexts</strong> using appropriate patterns and technologies</li>
<li><strong>Integrate contexts</strong> through well-defined interfaces and patterns</li>
<li><strong>Test contexts</strong> both in isolation and integration</li>
<li><strong>Evolve contexts</strong> as understanding deepens</li>
<li><strong>Avoid common pitfalls</strong> that lead to poor context design</li>
</ul>
<p>Teams can build maintainable, scalable systems that truly reflect business reality. The key is to start with business understanding, create focused contexts, and maintain clear boundaries while allowing for evolution as the domain becomes clearer.</p>
<p><strong>Next</strong>: <a href="../2-Ubiquitous-Language/README.md">Ubiquitous Language</a> builds upon bounded contexts by developing shared language within each context boundary.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/1-Bounded-Contexts/README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"1-Bounded-Contexts\",\"README\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/1-Bounded-Contexts/README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
