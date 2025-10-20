1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"13-domain-modeling-best-practices\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T44ab,<h1>Domain Modeling Best Practices - TypeScript Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling">Best Practices for Domain Modeling</a></p>
<p><strong>Navigation</strong>: <a href="./12-testing-best-practices.md">← Previous: Testing Best Practices</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to TypeScript Index</a></p>
<hr>
<pre><code class="language-typescript">// TypeScript Example - Domain Modeling Best Practices
// File: 2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices.ts

// ✅ GOOD: Pure Domain Logic
export class Order {
    private _items: OrderItem[] = [];
    private _status: OrderStatus = OrderStatus.Draft;

    constructor(
        public readonly id: OrderId,
        public readonly customerId: CustomerId,
        public readonly createdAt: Date = new Date()
    ) {}

    // ✅ Business logic encapsulated in domain object
    addItem(productId: ProductId, quantity: number, unitPrice: Money): void {
        if (this._status !== OrderStatus.Draft) {
            throw new Error(&#39;Cannot modify confirmed order&#39;);
        }

        if (quantity &lt;= 0) {
            throw new Error(&#39;Quantity must be positive&#39;);
        }

        // Business rule: Check if item already exists
        const existingItemIndex = this._items.findIndex(
            item =&gt; item.productId.equals(productId)
        );

        if (existingItemIndex &gt;= 0) {
            // Update existing item quantity
            const existingItem = this._items[existingItemIndex];
            const newQuantity = existingItem.quantity + quantity;
            this._items[existingItemIndex] = new OrderItem(
                productId,
                newQuantity,
                unitPrice
            );
        } else {
            // Add new item
            this._items.push(new OrderItem(productId, quantity, unitPrice));
        }
    }

    // ✅ Business rules as methods
    canBeModified(): boolean {
        return this._status === OrderStatus.Draft;
    }

    canBeConfirmed(): boolean {
        return this._status === OrderStatus.Draft &amp;&amp; this._items.length &gt; 0;
    }
}

// ✅ GOOD: Rich Domain Models with Behavior
export class Customer {
    private _status: CustomerStatus = CustomerStatus.Pending;

    constructor(
        public readonly id: CustomerId,
        public readonly name: string,
        public readonly email: EmailAddress,
        public readonly createdAt: Date = new Date()
    ) {}

    // ✅ Behavior encapsulated with data
    activate(): void {
        if (this._status === CustomerStatus.Suspended) {
            throw new Error(&#39;Cannot activate suspended customer&#39;);
        }
        this._status = CustomerStatus.Active;
    }

    isActive(): boolean {
        return this._status === CustomerStatus.Active;
    }

    canPlaceOrders(): boolean {
        return this._status === CustomerStatus.Active;
    }

    // ✅ Immutable updates return new instances
    updateEmail(newEmail: EmailAddress): Customer {
        return new Customer(this.id, this.name, newEmail, this.createdAt);
    }
}

// ✅ GOOD: Validation at Domain Boundaries
export class EmailAddress {
    private readonly value: string;

    constructor(email: string) {
        if (!email || email.trim().length === 0) {
            throw new Error(&#39;Email address cannot be empty&#39;);
        }

        const trimmedEmail = email.trim().toLowerCase();
        
        if (!this.isValidEmail(trimmedEmail)) {
            throw new Error(`Invalid email address format: ${email}`);
        }

        this.value = trimmedEmail;
    }

    private isValidEmail(email: string): boolean {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    // ✅ Self-validating value object
    equals(other: EmailAddress): boolean {
        return this.value === other.value;
    }
}

// ✅ GOOD: Value Objects for Complex Types
export class Money {
    constructor(
        public readonly amount: number,
        public readonly currency: string
    ) {
        if (amount &lt; 0) {
            throw new Error(&#39;Amount cannot be negative&#39;);
        }
        if (!currency || currency.trim().length === 0) {
            throw new Error(&#39;Currency cannot be empty&#39;);
        }
    }

    // ✅ Immutable operations return new instances
    add(other: Money): Money {
        if (this.currency !== other.currency) {
            throw new Error(&#39;Cannot add different currencies&#39;);
        }
        return new Money(this.amount + other.amount, this.currency);
    }

    multiply(factor: number): Money {
        if (factor &lt; 0) {
            throw new Error(&#39;Factor cannot be negative&#39;);
        }
        return new Money(this.amount * factor, this.currency);
    }

    // ✅ Value-based equality
    equals(other: Money): boolean {
        return this.amount === other.amount &amp;&amp; this.currency === other.currency;
    }

    // ✅ Factory methods for common values
    static zero(currency: string): Money {
        return new Money(0, currency);
    }

    static fromAmount(amount: number, currency: string): Money {
        return new Money(amount, currency);
    }
}

// ✅ GOOD: Design for Testability
export class PricingService {
    // ✅ Stateless service - no instance variables
    calculateOrderTotal(
        order: Order,
        customer: Customer,
        shippingAddress: Address
    ): Money {
        if (!customer.isActive()) {
            throw new Error(&#39;Cannot calculate pricing for inactive customer&#39;);
        }

        // ✅ Pure function - same inputs always produce same outputs
        let total = order.totalAmount;
        total = this.applyCustomerDiscount(total, customer);
        total = this.applyBulkDiscount(total, order);
        
        const tax = this.calculateTax(total, shippingAddress);
        const shipping = this.calculateShipping(order, shippingAddress);
        
        return total.add(tax).add(shipping);
    }

    // ✅ Private methods for complex calculations
    private applyCustomerDiscount(total: Money, customer: Customer): Money {
        const discountRate = this.getCustomerDiscountRate(customer.type);
        const discountAmount = total.multiply(discountRate);
        return total.subtract(discountAmount);
    }

    private getCustomerDiscountRate(customerType: string): number {
        switch (customerType) {
            case &#39;VIP&#39;: return 0.15;
            case &#39;Premium&#39;: return 0.10;
            case &#39;Standard&#39;: return 0.05;
            default: return 0.05;
        }
    }
}

// ✅ GOOD: Clear Domain Interfaces
export interface ICustomerRepository {
    findById(id: CustomerId): Promise&lt;Customer | null&gt;;
    findByEmail(email: EmailAddress): Promise&lt;Customer | null&gt;;
    save(customer: Customer): Promise&lt;void&gt;;
    delete(id: CustomerId): Promise&lt;void&gt;;
}

// ✅ GOOD: Domain Service with Clear Responsibilities
export class CustomerService {
    constructor(
        private readonly customerRepository: ICustomerRepository,
        private readonly emailService: IEmailService
    ) {}

    // ✅ Single responsibility per method
    async registerCustomer(
        name: string,
        email: EmailAddress
    ): Promise&lt;Customer&gt; {
        // Check if customer already exists
        const existingCustomer = await this.customerRepository.findByEmail(email);
        if (existingCustomer) {
            throw new Error(&#39;Customer with this email already exists&#39;);
        }

        // Create new customer
        const customerId = CustomerId.generate();
        const customer = new Customer(customerId, name, email);
        customer.activate();

        // Save and notify
        await this.customerRepository.save(customer);
        await this.emailService.sendWelcomeEmail(customer);

        return customer;
    }
}

// ❌ BAD: Anemic Domain Model
export class BadOrder {
    // ❌ Only data, no behavior
    public id: string;
    public customerId: string;
    public items: any[];
    public status: string;
    public totalAmount: number;

    constructor(id: string, customerId: string) {
        this.id = id;
        this.customerId = customerId;
        this.items = [];
        this.status = &#39;Draft&#39;;
        this.totalAmount = 0;
    }

    // ❌ Business logic in external service
    addItem(productId: string, quantity: number, unitPrice: number): void {
        // Business logic should be in the domain object
        if (this.status !== &#39;Draft&#39;) {
            throw new Error(&#39;Cannot modify confirmed order&#39;);
        }
        // ... rest of logic
    }
}

// ❌ BAD: Primitive Obsession
export class BadCustomer {
    // ❌ Using primitives instead of value objects
    public id: string;
    public name: string;
    public email: string; // Should be EmailAddress
    public status: string; // Should be CustomerStatus enum
    public createdAt: string; // Should be Date

    constructor(id: string, name: string, email: string) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.status = &#39;Pending&#39;;
        this.createdAt = new Date().toISOString();
    }
}

// ❌ BAD: Validation Scattered
export class BadOrderService {
    // ❌ Validation logic spread across layers
    async createOrder(orderData: any): Promise&lt;void&gt; {
        // Validation in service layer
        if (!orderData.customerId) {
            throw new Error(&#39;Customer ID is required&#39;);
        }
        
        if (!orderData.items || orderData.items.length === 0) {
            throw new Error(&#39;Order must have items&#39;);
        }

        // More validation scattered throughout
        for (const item of orderData.items) {
            if (item.quantity &lt;= 0) {
                throw new Error(&#39;Invalid quantity&#39;);
            }
        }
    }
}

// ✅ GOOD: Domain Events for Significant Changes
export class OrderConfirmedEvent {
    constructor(
        public readonly orderId: OrderId,
        public readonly customerId: CustomerId,
        public readonly totalAmount: Money,
        public readonly occurredAt: Date = new Date()
    ) {}
}

export class Order {
    // ... existing code ...

    confirm(): void {
        if (this._status !== OrderStatus.Draft) {
            throw new Error(&#39;Order is not in draft status&#39;);
        }

        if (this._items.length === 0) {
            throw new Error(&#39;Cannot confirm empty order&#39;);
        }

        this._status = OrderStatus.Confirmed;
        
        // ✅ Domain event for significant business event
        DomainEvents.raise(new OrderConfirmedEvent(
            this.id,
            this.customerId,
            this.totalAmount
        ));
    }
}

// ✅ GOOD: Aggregate Root Pattern
export class OrderAggregate {
    private _order: Order;
    private _items: OrderItem[] = [];
    private _events: DomainEvent[] = [];

    constructor(order: Order) {
        this._order = order;
    }

    // ✅ Aggregate enforces business rules
    addItem(productId: ProductId, quantity: number, unitPrice: Money): void {
        // Business rules enforced at aggregate level
        if (!this._order.canBeModified()) {
            throw new Error(&#39;Cannot modify confirmed order&#39;);
        }

        const item = new OrderItem(productId, quantity, unitPrice);
        this._items.push(item);
        
        // Update order total
        this._order.updateTotal(this.calculateTotal());
    }

    private calculateTotal(): Money {
        return this._items.reduce(
            (total, item) =&gt; total.add(item.totalPrice),
            Money.zero(&#39;USD&#39;)
        );
    }

    // ✅ Aggregate manages domain events
    getUncommittedEvents(): DomainEvent[] {
        return [...this._events];
    }

    markEventsAsCommitted(): void {
        this._events = [];
    }
}

// ✅ GOOD: Specification Pattern for Complex Business Rules
export class OrderSpecification {
    canBeConfirmed(order: Order): boolean {
        return order.status === OrderStatus.Draft &amp;&amp;
               order.items.length &gt; 0 &amp;&amp;
               order.totalAmount.amount &gt; 0;
    }

    canBeShipped(order: Order): boolean {
        return order.status === OrderStatus.Confirmed &amp;&amp;
               this.hasValidShippingAddress(order);
    }

    private hasValidShippingAddress(order: Order): boolean {
        // Complex business rule logic
        return true; // Simplified for example
    }
}

// ✅ GOOD: Factory Pattern for Complex Object Creation
export class CustomerFactory {
    static createStandardCustomer(
        name: string,
        email: EmailAddress
    ): Customer {
        const customerId = CustomerId.generate();
        const customer = new Customer(customerId, name, email);
        customer.activate();
        return customer;
    }

    static createVipCustomer(
        name: string,
        email: EmailAddress
    ): Customer {
        const customerId = CustomerId.generate();
        const customer = new Customer(customerId, name, email);
        customer.activate();
        // Additional VIP setup logic
        return customer;
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Best Practices for Domain Modeling</h3>
<h4>1. <strong>Keep Domain Logic Pure</strong></h4>
<ul>
<li>✅ Domain objects should not depend on external frameworks</li>
<li>✅ Business rules are encapsulated in domain objects</li>
<li>✅ Pure functions for calculations and transformations</li>
</ul>
<h4>2. <strong>Use Rich Domain Models</strong></h4>
<ul>
<li>✅ Domain objects contain both data and behavior</li>
<li>✅ Business logic is contained within the objects that own the data</li>
<li>✅ Methods express business operations clearly</li>
</ul>
<h4>3. <strong>Validate at Domain Boundaries</strong></h4>
<ul>
<li>✅ Domain objects validate their state and enforce business rules</li>
<li>✅ Validation happens at the domain boundary</li>
<li>✅ Clear error messages for business rule violations</li>
</ul>
<h4>4. <strong>Use Value Objects for Complex Types</strong></h4>
<ul>
<li>✅ Value objects represent complex concepts and ensure consistency</li>
<li>✅ Immutable objects with value-based equality</li>
<li>✅ Factory methods for common values</li>
</ul>
<h4>5. <strong>Design for Testability</strong></h4>
<ul>
<li>✅ Minimize external dependencies</li>
<li>✅ Clear interfaces for dependencies</li>
<li>✅ Pure functions where possible</li>
<li>✅ Dependency injection for external services</li>
</ul>
<h3>Domain Modeling Patterns</h3>
<h4><strong>Aggregate Root Pattern</strong></h4>
<ul>
<li>✅ Encapsulates business rules and invariants</li>
<li>✅ Manages domain events</li>
<li>✅ Controls access to aggregate members</li>
</ul>
<h4><strong>Domain Events</strong></h4>
<ul>
<li>✅ Communicate significant business events</li>
<li>✅ Enable loose coupling between aggregates</li>
<li>✅ Support eventual consistency</li>
</ul>
<h4><strong>Specification Pattern</strong></h4>
<ul>
<li>✅ Encapsulate complex business rules</li>
<li>✅ Reusable business logic</li>
<li>✅ Clear expression of business constraints</li>
</ul>
<h4><strong>Factory Pattern</strong></h4>
<ul>
<li>✅ Complex object creation logic</li>
<li>✅ Consistent object initialization</li>
<li>✅ Hide creation complexity</li>
</ul>
<h3>TypeScript Benefits for Domain Modeling</h3>
<ul>
<li><strong>Type Safety</strong>: Compile-time checking of business rules</li>
<li><strong>Interfaces</strong>: Clear contracts for dependencies</li>
<li><strong>Enums</strong>: Type-safe status and state management</li>
<li><strong>Generics</strong>: Reusable patterns for value objects</li>
<li><strong>Readonly Properties</strong>: Immutable domain objects</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Anemic Domain Model</strong></h4>
<ul>
<li>❌ Domain objects contain only data</li>
<li>❌ Business logic in external services</li>
<li>❌ No encapsulation of business rules</li>
</ul>
<h4><strong>Primitive Obsession</strong></h4>
<ul>
<li>❌ Using primitives instead of domain types</li>
<li>❌ No type safety for business concepts</li>
<li>❌ Scattered validation logic</li>
</ul>
<h4><strong>Validation Scattered</strong></h4>
<ul>
<li>❌ Validation logic spread across layers</li>
<li>❌ Inconsistent business rule enforcement</li>
<li>❌ Hard to maintain and test</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Example of good entity design</li>
<li><a href="./03-order-entity.md">Order Entity</a> - Rich domain model example</li>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Value object best practices</li>
<li><a href="./04-email-address-value-object.md">EmailAddress Value Object</a> - Validation example</li>
<li><a href="../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling">Domain Modeling</a> - Domain modeling concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 12-testing-best-practices.md</li>
<li>Next: N/A</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling">Best Practices for Domain Modeling</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"13-domain-modeling-best-practices"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"13-domain-modeling-best-practices\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
