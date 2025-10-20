1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/3-Domain-Models/README","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"3-Domain-Models\",\"README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T5060,<h1>Domain Models</h1>
<h2>Name</h2>
<p><strong>Domain Models</strong> - The Heart of Domain-Driven Design</p>
<h2>Goal of the Concept</h2>
<p>Domain models represent the essential concepts and relationships in the business domain. They serve as the foundation for all software design decisions and should reflect the true nature of the business, capturing both data and behavior that represents business rules and processes.</p>
<h2>Theoretical Foundation</h2>
<h3>Model-Driven Design</h3>
<p>Domain models are the core of model-driven design, where the software structure directly reflects the domain structure. This approach ensures that the code represents business reality rather than technical convenience.</p>
<h3>Rich Domain Models</h3>
<p>Domain models should be rich in behavior, not just data containers. They should encapsulate business rules and processes, making the system easier to understand and maintain.</p>
<h3>Domain Logic Encapsulation</h3>
<p>Business logic should be encapsulated within domain models rather than scattered throughout the application. This ensures that business rules are centralized and consistent.</p>
<h3>Conceptual Integrity</h3>
<p>Domain models should maintain conceptual integrity, meaning that the model should be internally consistent and reflect a coherent understanding of the domain.</p>
<h2>Consequences of Poor Domain Models</h2>
<h3>Unique Domain Model Issues</h3>
<p><strong>Anemic Domain Models</strong></p>
<ul>
<li>Models contain only data without behavior</li>
<li>Business logic is scattered throughout the application</li>
<li>The system becomes hard to understand and maintain</li>
<li>Business rules are duplicated and inconsistent</li>
</ul>
<p><strong>Technical Models</strong></p>
<ul>
<li>Models reflect technical concerns rather than business concepts</li>
<li>The system becomes disconnected from business reality</li>
<li>Changes to business requirements require major technical changes</li>
<li>The system becomes hard to modify and extend</li>
</ul>
<p><strong>Inconsistent Models</strong></p>
<ul>
<li>Different parts of the system use different models for the same concepts</li>
<li>Business rules are implemented differently in different areas</li>
<li>The system becomes unpredictable and hard to debug</li>
<li>Knowledge about the domain is lost</li>
</ul>
<h2>Impact on System Design</h2>
<h3>Design Benefits</h3>
<p><strong>Business Alignment</strong></p>
<ul>
<li>The system structure reflects business structure</li>
<li>Business rules are centralized and consistent</li>
<li>The system is easier to understand for business stakeholders</li>
<li>Changes to business requirements are easier to implement</li>
</ul>
<p><strong>Maintainability</strong></p>
<ul>
<li>Business logic is encapsulated and centralized</li>
<li>The system is easier to modify and extend</li>
<li>Bugs are easier to find and fix</li>
<li>The system is more predictable</li>
</ul>
<h3>Design Challenges</h3>
<p><strong>Complexity Management</strong></p>
<ul>
<li>Rich domain models can become complex</li>
<li>Balancing richness with simplicity</li>
<li>Managing relationships between models</li>
<li>Ensuring models remain focused and cohesive</li>
</ul>
<h2>Role in Domain-Driven Design</h2>
<p>Domain models are central to Domain-Driven Design because they:</p>
<ul>
<li><strong>Represent business concepts</strong> in a form that can be implemented in code</li>
<li><strong>Encapsulate business logic</strong> and rules</li>
<li><strong>Provide a foundation</strong> for all other design decisions</li>
<li><strong>Enable communication</strong> between business and technical teams</li>
<li><strong>Support evolution</strong> as understanding of the domain deepens</li>
</ul>
<h2>How to Build Effective Domain Models</h2>
<h3>1. Identify Entities</h3>
<p><strong>What it means</strong>: Entities are objects that have a distinct identity that persists over time, even if their attributes change. They represent concepts that the business cares about as individuals.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Look for concepts that have a unique identity</li>
<li>Identify objects that the business tracks over time</li>
<li>Find concepts that have a lifecycle</li>
<li>Look for objects that can be referenced by other objects</li>
</ul>
<p><strong>Example</strong>: In an e-commerce system, &quot;Customer,&quot; &quot;Order,&quot; and &quot;Product&quot; are entities because they have unique identities that persist over time and can be referenced by other objects.</p>
<h3>2. Define Value Objects</h3>
<p><strong>What it means</strong>: Value objects are objects that are defined by their attributes rather than their identity. They represent concepts that are equal if they have the same attributes.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Look for concepts that are defined by their attributes</li>
<li>Identify objects that don&#39;t have a unique identity</li>
<li>Find concepts that are immutable</li>
<li>Look for objects that can be compared by value</li>
</ul>
<p><strong>Example</strong>: &quot;Money,&quot; &quot;Address,&quot; and &quot;Email&quot; are value objects because they are defined by their attributes and don&#39;t have a unique identity.</p>
<h3>3. Design Aggregates</h3>
<p><strong>What it means</strong>: Aggregates are clusters of related objects that are treated as a unit for data changes. They define consistency boundaries and ensure data integrity.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify groups of related objects that must be consistent</li>
<li>Define aggregate roots that control access to the aggregate</li>
<li>Ensure aggregates are the right size (not too large or too small)</li>
<li>Design aggregates to maintain consistency</li>
</ul>
<p><strong>Example</strong>: An &quot;Order&quot; aggregate might include OrderItems, ShippingAddress, and PaymentInformation, with Order as the aggregate root.</p>
<h3>4. Implement Domain Services</h3>
<p><strong>What it means</strong>: Domain services contain business logic that doesn&#39;t naturally belong to any entity or value object. They represent operations that involve multiple domain objects.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify business operations that don&#39;t belong to a single object</li>
<li>Look for operations that involve multiple domain concepts</li>
<li>Find business logic that is stateless</li>
<li>Ensure services represent domain concepts, not technical concerns</li>
</ul>
<p><strong>Example</strong>: A &quot;PricingService&quot; might calculate prices based on customer type, product category, and current promotions.</p>
<h3>5. Capture Business Rules</h3>
<p><strong>What it means</strong>: Business rules should be explicitly represented in the domain model, either as methods on entities/value objects or as domain services.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify business rules and constraints</li>
<li>Represent rules as methods or properties</li>
<li>Ensure rules are enforced consistently</li>
<li>Make rules explicit and visible</li>
</ul>
<p><strong>Example</strong>: A &quot;Customer&quot; entity might have a method <code>CanPlaceOrder()</code> that checks if the customer is in good standing and has a valid payment method.</p>
<h2>Examples of Domain Model Design</h2>
<h3>E-commerce System Example</h3>
<p><strong>Entities</strong></p>
<pre><code class="language-csharp">public class Customer
{
    public CustomerId Id { get; private set; }
    public CustomerStatus Status { get; private set; }
    public PaymentMethod PrimaryPaymentMethod { get; private set; }
    
    public bool CanPlaceOrder()
    {
        return Status == CustomerStatus.Active &amp;&amp; 
               PrimaryPaymentMethod != null &amp;&amp; 
               PrimaryPaymentMethod.IsValid;
    }
    
    public void UpdatePaymentMethod(PaymentMethod newMethod)
    {
        if (newMethod.IsValid)
        {
            PrimaryPaymentMethod = newMethod;
        }
        else
        {
            throw new InvalidPaymentMethodException();
        }
    }
}

public class Order
{
    public OrderId Id { get; private set; }
    public CustomerId CustomerId { get; private set; }
    public OrderStatus Status { get; private set; }
    public Money TotalAmount { get; private set; }
    public List&lt;OrderItem&gt; Items { get; private set; }
    
    public void AddItem(Product product, int quantity)
    {
        if (Status != OrderStatus.Draft)
        {
            throw new InvalidOrderStateException();
        }
        
        var item = new OrderItem(product.Id, product.Price, quantity);
        Items.Add(item);
        RecalculateTotal();
    }
    
    public void Confirm()
    {
        if (Status != OrderStatus.Draft)
        {
            throw new InvalidOrderStateException();
        }
        
        Status = OrderStatus.Confirmed;
    }
    
    private void RecalculateTotal()
    {
        TotalAmount = Items.Sum(item =&gt; item.TotalPrice);
    }
}
</code></pre>
<p><strong>Value Objects</strong></p>
<pre><code class="language-csharp">public class Money
{
    public decimal Amount { get; private set; }
    public Currency Currency { get; private set; }
    
    public Money(decimal amount, Currency currency)
    {
        if (amount &lt; 0)
            throw new InvalidMoneyAmountException();
            
        Amount = amount;
        Currency = currency;
    }
    
    public Money Add(Money other)
    {
        if (Currency != other.Currency)
            throw new CurrencyMismatchException();
            
        return new Money(Amount + other.Amount, Currency);
    }
    
    public bool Equals(Money other)
    {
        return Amount == other.Amount &amp;&amp; Currency == other.Currency;
    }
}

public class Address
{
    public string Street { get; private set; }
    public string City { get; private set; }
    public string State { get; private set; }
    public string ZipCode { get; private set; }
    public Country Country { get; private set; }
    
    public Address(string street, string city, string state, string zipCode, Country country)
    {
        if (string.IsNullOrEmpty(street) || string.IsNullOrEmpty(city))
            throw new InvalidAddressException();
            
        Street = street;
        City = city;
        State = state;
        ZipCode = zipCode;
        Country = country;
    }
}
</code></pre>
<p><strong>Domain Services</strong></p>
<pre><code class="language-csharp">public class PricingService
{
    public Money CalculatePrice(Product product, Customer customer, int quantity)
    {
        var basePrice = product.Price.Multiply(quantity);
        
        if (customer.IsPremium())
        {
            basePrice = basePrice.ApplyDiscount(0.1m); // 10% discount
        }
        
        if (quantity &gt;= 10)
        {
            basePrice = basePrice.ApplyDiscount(0.05m); // 5% bulk discount
        }
        
        return basePrice;
    }
}

public class InventoryService
{
    public bool IsAvailable(ProductId productId, int quantity)
    {
        // Check inventory levels
        var availableQuantity = GetAvailableQuantity(productId);
        return availableQuantity &gt;= quantity;
    }
    
    public void Reserve(ProductId productId, int quantity)
    {
        if (!IsAvailable(productId, quantity))
        {
            throw new InsufficientInventoryException();
        }
        
        // Reserve the inventory
        ReserveInventory(productId, quantity);
    }
}
</code></pre>
<h3>Banking System Example</h3>
<p><strong>Entities</strong></p>
<pre><code class="language-csharp">public class Account
{
    public AccountId Id { get; private set; }
    public CustomerId CustomerId { get; private set; }
    public AccountType Type { get; private set; }
    public Money Balance { get; private set; }
    public Money AvailableBalance { get; private set; }
    public AccountStatus Status { get; private set; }
    
    public void Deposit(Money amount)
    {
        if (Status != AccountStatus.Active)
        {
            throw new InvalidAccountStateException();
        }
        
        if (amount.Amount &lt;= 0)
        {
            throw new InvalidDepositAmountException();
        }
        
        Balance = Balance.Add(amount);
        AvailableBalance = AvailableBalance.Add(amount);
    }
    
    public void Withdraw(Money amount)
    {
        if (Status != AccountStatus.Active)
        {
            throw new InvalidAccountStateException();
        }
        
        if (amount.Amount &lt;= 0)
        {
            throw new InvalidWithdrawalAmountException();
        }
        
        if (AvailableBalance.Amount &lt; amount.Amount)
        {
            throw new InsufficientFundsException();
        }
        
        Balance = Balance.Subtract(amount);
        AvailableBalance = AvailableBalance.Subtract(amount);
    }
    
    public bool CanWithdraw(Money amount)
    {
        return Status == AccountStatus.Active &amp;&amp; 
               AvailableBalance.Amount &gt;= amount.Amount;
    }
}
</code></pre>
<h2>How This Concept Helps with System Design</h2>
<ol>
<li><strong>Business Alignment</strong>: The system structure reflects business structure</li>
<li><strong>Centralized Logic</strong>: Business rules are encapsulated in domain models</li>
<li><strong>Consistency</strong>: Business rules are enforced consistently throughout the system</li>
<li><strong>Maintainability</strong>: Changes to business rules are localized to domain models</li>
<li><strong>Testability</strong>: Domain models can be tested independently</li>
</ol>
<h2>How This Concept Helps with Development</h2>
<ol>
<li><strong>Clear Structure</strong>: The system has a clear, understandable structure</li>
<li><strong>Easier Debugging</strong>: Business logic is centralized and easier to trace</li>
<li><strong>Better Testing</strong>: Domain models can be tested in isolation</li>
<li><strong>Faster Development</strong>: Business rules are implemented once and reused</li>
<li><strong>Easier Maintenance</strong>: Changes to business rules are localized</li>
</ol>
<h2>Common Patterns and Anti-patterns</h2>
<h3>Patterns</h3>
<p><strong>Rich Domain Models</strong></p>
<ul>
<li>Models contain both data and behavior</li>
<li>Business logic is encapsulated in domain objects</li>
<li>Models represent business concepts accurately</li>
</ul>
<p><strong>Aggregate Design</strong></p>
<ul>
<li>Groups of related objects are treated as units</li>
<li>Consistency boundaries are well-defined</li>
<li>Aggregate roots control access to aggregates</li>
</ul>
<p><strong>Domain Services</strong></p>
<ul>
<li>Business logic that doesn&#39;t belong to entities</li>
<li>Stateless operations on domain objects</li>
<li>Represent domain concepts, not technical concerns</li>
</ul>
<h3>Anti-patterns</h3>
<p><strong>Anemic Domain Models</strong></p>
<ul>
<li>Models contain only data without behavior</li>
<li>Business logic is scattered throughout the application</li>
<li>Models don&#39;t represent business concepts</li>
</ul>
<p><strong>God Objects</strong></p>
<ul>
<li>Single objects that try to do everything</li>
<li>Violate single responsibility principle</li>
<li>Become hard to understand and maintain</li>
</ul>
<p><strong>Technical Models</strong></p>
<ul>
<li>Models reflect technical concerns rather than business concepts</li>
<li>Business logic is implemented based on technical convenience</li>
<li>System becomes disconnected from business reality</li>
</ul>
<h2>Summary</h2>
<p>Domain models are the heart of Domain-Driven Design, representing business concepts in a form that can be implemented in code. By building rich domain models that encapsulate business logic and rules, teams can:</p>
<ul>
<li><strong>Create systems</strong> that truly reflect business reality</li>
<li><strong>Centralize business logic</strong> in a maintainable way</li>
<li><strong>Build software</strong> that is easier to understand and modify</li>
<li><strong>Ensure consistency</strong> in business rule implementation</li>
<li><strong>Support evolution</strong> as understanding of the domain deepens</li>
</ul>
<p>The key to successful domain modeling is identifying entities, defining value objects, designing aggregates, implementing domain services, and capturing business rules explicitly. This creates a foundation for all other Domain-Driven Design practices.</p>
<h2>Exercise 1: Design Domain Models</h2>
<h3>Objective</h3>
<p>Design domain models for a specific business domain, focusing on entities, value objects, and business rules.</p>
<h3>Task</h3>
<p>Choose a business domain and design domain models that represent the key business concepts.</p>
<ol>
<li><strong>Identify Entities</strong>: Find concepts that have unique identities</li>
<li><strong>Define Value Objects</strong>: Identify concepts defined by their attributes</li>
<li><strong>Design Aggregates</strong>: Group related objects into consistency boundaries</li>
<li><strong>Implement Business Rules</strong>: Represent business logic in the models</li>
<li><strong>Design Domain Services</strong>: Identify operations that don&#39;t belong to entities</li>
</ol>
<h3>Deliverables</h3>
<ul>
<li>Entity designs with identity and behavior</li>
<li>Value object designs with immutability</li>
<li>Aggregate designs with consistency boundaries</li>
<li>Domain service designs for complex operations</li>
<li>Business rule implementations</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Choose a business domain you understand well</li>
<li>Identify the key business concepts</li>
<li>Determine which concepts are entities vs. value objects</li>
<li>Design aggregates that maintain consistency</li>
<li>Implement business rules as methods or services</li>
</ol>
<hr>
<h2>Exercise 2: Implement Domain Models</h2>
<h3>Objective</h3>
<p>Implement the designed domain models in code, ensuring they capture business logic and rules.</p>
<h3>Task</h3>
<p>Take the domain model designs from Exercise 1 and implement them in code.</p>
<ol>
<li><strong>Implement Entities</strong>: Create classes with identity and behavior</li>
<li><strong>Implement Value Objects</strong>: Create immutable classes with value equality</li>
<li><strong>Implement Aggregates</strong>: Ensure consistency boundaries are maintained</li>
<li><strong>Implement Domain Services</strong>: Create stateless services for complex operations</li>
<li><strong>Add Business Rules</strong>: Implement business logic as methods and properties</li>
</ol>
<h3>Success Criteria</h3>
<ul>
<li>Entities have clear identity and behavior</li>
<li>Value objects are immutable and comparable by value</li>
<li>Aggregates maintain consistency boundaries</li>
<li>Domain services are stateless and focused</li>
<li>Business rules are implemented and enforced</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Use your domain model designs from Exercise 1</li>
<li>Implement entities with identity and behavior</li>
<li>Create value objects that are immutable</li>
<li>Implement aggregates with consistency boundaries</li>
<li>Add domain services for complex operations</li>
</ol>
<h3>Implementation Best Practices</h3>
<h4>Domain Model Design</h4>
<ol>
<li><strong>Rich Models</strong>: Include both data and behavior in domain models</li>
<li><strong>Business Logic</strong>: Encapsulate business rules in domain objects</li>
<li><strong>Consistency</strong>: Ensure business rules are enforced consistently</li>
<li><strong>Immutability</strong>: Use immutable value objects where appropriate</li>
</ol>
<h4>Code Organization</h4>
<ol>
<li><strong>Aggregate Boundaries</strong>: Organize code around aggregate boundaries</li>
<li><strong>Domain Services</strong>: Separate domain services from application services</li>
<li><strong>Business Rules</strong>: Make business rules explicit and visible</li>
<li><strong>Testing</strong>: Design models to be easily testable</li>
</ol>
<h3>Learning Objectives</h3>
<p>After completing both exercises, you should be able to:</p>
<ul>
<li>Design domain models that represent business concepts</li>
<li>Implement entities, value objects, and aggregates</li>
<li>Encapsulate business logic in domain models</li>
<li>Design domain services for complex operations</li>
<li>Build maintainable and testable domain models</li>
</ul>
<p><strong>Next</strong>: <a href="../4-Context-Mapping/README.md">Context Mapping</a> builds upon domain models by defining how different bounded contexts interact and communicate.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/3-Domain-Models/README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"3-Domain-Models\",\"README\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/3-Domain-Models/README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
