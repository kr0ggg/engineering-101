# Bounded Contexts

## Name
**Bounded Contexts** - The Foundation of Domain-Driven Design

## Goal of the Concept
A bounded context defines the boundary within which a particular domain model is valid and meaningful. It represents the scope of a domain model and helps manage complexity by creating clear boundaries between different parts of the system.

## Theoretical Foundation

### Eric Evans' Original Definition
Eric Evans introduced bounded contexts as a way to manage the complexity of large domain models. He recognized that trying to create a single, unified model for an entire enterprise leads to confusion and complexity that makes the model unusable.

### Context and Meaning
The concept is based on the linguistic principle that the meaning of words depends on their context. The same term can have different meanings in different contexts, and trying to force a single meaning across all contexts leads to confusion and miscommunication.

### Complexity Management
Bounded contexts provide a way to manage complexity by:
- Limiting the scope of any single model
- Allowing different teams to work independently
- Enabling different models to evolve at their own pace
- Providing clear boundaries for testing and validation

### Organizational Alignment
Bounded contexts often align with organizational boundaries, reflecting how different teams or departments think about the same concepts differently. This alignment helps create software that matches the organization's structure and communication patterns.

## Consequences of Not Using Bounded Contexts

### Unique Bounded Context Issues

**Model Confusion**
- Different parts of the system use the same terms with different meanings
- Developers and business stakeholders become confused about concepts
- The domain model becomes inconsistent and hard to understand
- Changes in one area unexpectedly affect other areas

**Team Coordination Problems**
- Teams step on each other's toes when working on shared models
- Integration becomes complex and error-prone
- Knowledge sharing becomes difficult
- Different teams make conflicting assumptions

**Technical Complexity**
- Large, monolithic models become hard to maintain
- Testing becomes complex due to unclear boundaries
- Performance issues arise from overly complex models
- Refactoring becomes risky and time-consuming

## Impact on System Architecture

### Architectural Benefits

**Clear Boundaries**
- Well-defined interfaces between different parts of the system
- Clear ownership and responsibility for different areas
- Easier to understand system structure and dependencies
- Better separation of concerns

**Independent Evolution**
- Different contexts can evolve at their own pace
- Changes in one context don't necessarily affect others
- Teams can work independently on their contexts
- Easier to scale development efforts

### Architectural Challenges

**Integration Complexity**
- Need to manage communication between contexts
- Data consistency across boundaries becomes complex
- Performance considerations for cross-context operations
- Error handling and recovery across boundaries

## Role in Domain-Driven Design

Bounded contexts are fundamental to Domain-Driven Design because they:

- **Define the scope** of domain models and ubiquitous language
- **Enable team autonomy** by providing clear boundaries
- **Support model evolution** by allowing independent development
- **Facilitate communication** by creating shared understanding within boundaries
- **Manage complexity** by breaking large problems into smaller, manageable pieces

## How to Identify Bounded Contexts

### 1. Look for Language Differences
**What it means**: Different teams or departments use the same terms with different meanings, or they have different vocabularies for the same concepts.

**How to do it**:
- Interview different teams about the same business concepts
- Look for terms that mean different things in different areas
- Identify vocabulary that is specific to certain groups
- Notice when the same concept is described differently

**Example**: In an e-commerce system, "customer" might mean different things to the sales team (prospect, lead, client) versus the support team (user with issues) versus the accounting team (entity that owes money).

### 2. Identify Organizational Boundaries
**What it means**: Different teams or departments have different responsibilities and ways of working, which often leads to different mental models.

**How to do it**:
- Map the organizational structure and responsibilities
- Identify teams that work independently
- Look for different reporting structures or metrics
- Notice different tools and processes used by different groups

**Example**: The marketing team thinks about "campaigns" and "leads," while the sales team thinks about "opportunities" and "deals." These represent different bounded contexts even though they're related.

### 3. Find Model Inconsistencies
**What it means**: When you try to create a unified model, you find contradictions or conflicts that can't be resolved without losing important distinctions.

**How to do it**:
- Attempt to create a single model for related concepts
- Look for contradictions or conflicts in the model
- Identify concepts that have different attributes in different areas
- Notice when the same entity behaves differently in different contexts

**Example**: A "product" in the catalog context has different attributes and behaviors than a "product" in the inventory context, even though they refer to the same physical item.

### 4. Recognize Different Lifecycles
**What it means**: Different parts of the system have different rates of change, different stakeholders, or different business rules.

**How to do it**:
- Identify areas that change at different rates
- Look for different stakeholders with different priorities
- Notice different business rules or validation requirements
- Find areas with different performance or scalability requirements

**Example**: User authentication changes slowly and has strict security requirements, while content management changes frequently and has flexible requirements.

### 5. Analyze Data Dependencies
**What it means**: Different parts of the system need different views of the same data, or they need to access data at different times or frequencies.

**How to do it**:
- Map data flows and dependencies
- Identify different data access patterns
- Look for different data consistency requirements
- Notice different data retention or archival needs

**Example**: The order processing system needs real-time inventory data, while the reporting system can work with daily snapshots of the same data.

## Examples of Bounded Context Identification

### E-commerce System Example

**Customer Context**
- Focus: Customer relationship management
- Key concepts: Customer, Contact, Communication Preferences
- Language: "customer," "contact," "engagement"
- Boundaries: Customer data, preferences, communication history

**Order Context**
- Focus: Order processing and fulfillment
- Key concepts: Order, OrderItem, ShippingAddress, Payment
- Language: "order," "cart," "checkout," "fulfillment"
- Boundaries: Order lifecycle, payment processing, shipping

**Inventory Context**
- Focus: Product availability and stock management
- Key concepts: Product, Stock, Warehouse, Supplier
- Language: "inventory," "stock," "warehouse," "supplier"
- Boundaries: Stock levels, warehouse operations, supplier relationships

**Catalog Context**
- Focus: Product information and presentation
- Key concepts: Product, Category, Price, Description
- Language: "catalog," "product," "category," "pricing"
- Boundaries: Product information, categorization, pricing rules

### Banking System Example

**Account Management Context**
- Focus: Account lifecycle and basic operations
- Key concepts: Account, AccountHolder, Balance, Transaction
- Language: "account," "balance," "transaction," "statement"
- Boundaries: Account creation, balance inquiries, basic transactions

**Loan Processing Context**
- Focus: Loan applications and approvals
- Key concepts: LoanApplication, CreditCheck, Approval, Terms
- Language: "loan," "application," "credit," "approval"
- Boundaries: Loan application process, credit evaluation, approval workflow

**Payment Processing Context**
- Focus: Payment execution and settlement
- Key concepts: Payment, PaymentMethod, Settlement, Clearing
- Language: "payment," "settlement," "clearing," "routing"
- Boundaries: Payment execution, settlement processes, clearing operations

## How This Concept Helps with System Design

1. **Clear Boundaries**: Each context has well-defined responsibilities and interfaces
2. **Team Autonomy**: Different teams can work independently on their contexts
3. **Model Clarity**: Each context has a clear, focused domain model
4. **Reduced Complexity**: Large problems are broken into manageable pieces
5. **Better Communication**: Teams share a common language within their context

## How This Concept Helps with Development

1. **Independent Development**: Teams can work on their contexts without coordination
2. **Focused Testing**: Each context can be tested independently
3. **Easier Refactoring**: Changes are contained within context boundaries
4. **Clear Ownership**: Each context has clear ownership and responsibility
5. **Scalable Development**: Multiple teams can work in parallel

## Common Patterns and Anti-patterns

### Patterns

**Shared Kernel**
- Two teams share a small, common model
- Used when contexts are closely related but need some independence
- Requires close coordination between teams

**Customer-Supplier**
- One context provides services to another
- Clear upstream-downstream relationship
- Supplier context has more control over the interface

**Conformist**
- Downstream context conforms to upstream model
- Used when the downstream context has less influence
- Simpler integration but less flexibility

**Anti-Corruption Layer**
- Downstream context translates upstream model to its own model
- Used when upstream model doesn't fit downstream needs
- More complex but provides better isolation

### Anti-patterns

**Big Ball of Mud**
- No clear boundaries between different areas
- Everything is connected to everything else
- Difficult to understand, test, or modify

**Anemic Domain Model**
- Context has no behavior, only data
- Business logic is scattered throughout the system
- Difficult to understand business rules

**God Context**
- One context tries to handle everything
- Becomes too large and complex
- Difficult to maintain and evolve

## Summary

Bounded contexts are the foundation of Domain-Driven Design, providing a way to manage complexity by creating clear boundaries around domain models. By identifying and defining bounded contexts, teams can:

- **Work independently** on different parts of the system
- **Maintain clear models** that reflect business reality
- **Communicate effectively** using shared language within boundaries
- **Evolve systems** incrementally without affecting other areas
- **Scale development** efforts across multiple teams

The key to successful bounded context identification is looking for differences in language, organizational structure, model requirements, and system behavior. Once identified, bounded contexts provide the foundation for all other Domain-Driven Design practices.

## Exercise 1: Identify Bounded Contexts

### Objective
Analyze a complex business domain and identify potential bounded contexts.

### Task
Choose a business domain (e-commerce, banking, healthcare, etc.) and identify 3-5 potential bounded contexts.

1. **Map the Domain**: Create a high-level map of the business domain
2. **Identify Language Differences**: Look for terms that mean different things in different areas
3. **Find Organizational Boundaries**: Identify different teams or departments
4. **Look for Model Inconsistencies**: Find concepts that behave differently in different areas
5. **Document Contexts**: Create a brief description of each identified context

### Deliverables
- Domain map showing different areas
- List of identified bounded contexts with descriptions
- Analysis of language differences between contexts
- Rationale for context boundaries

### Getting Started
1. Choose a business domain you're familiar with
2. Map out the main business processes and areas
3. Interview different stakeholders about key concepts
4. Look for differences in terminology and understanding
5. Identify natural boundaries in the domain

---

## Exercise 2: Define Context Boundaries

### Objective
Define clear boundaries and responsibilities for identified bounded contexts.

### Task
Take the bounded contexts from Exercise 1 and define their boundaries, responsibilities, and interfaces.

1. **Define Responsibilities**: Clearly state what each context is responsible for
2. **Identify Key Concepts**: List the main domain concepts in each context
3. **Define Interfaces**: Specify how contexts will interact with each other
4. **Document Dependencies**: Map dependencies between contexts
5. **Validate Boundaries**: Ensure boundaries make sense and are maintainable

### Success Criteria
- Clear, well-defined boundaries for each context
- Minimal dependencies between contexts
- Clear ownership and responsibility
- Practical interfaces for context interaction

### Getting Started
1. Use your identified contexts from Exercise 1
2. Define what each context is responsible for
3. Identify the key concepts and entities in each context
4. Design simple interfaces for context interaction
5. Validate that boundaries are practical and maintainable

### Implementation Best Practices

#### Context Definition
1. **Clear Responsibilities**: Each context should have a single, clear responsibility
2. **Minimal Dependencies**: Contexts should be as independent as possible
3. **Stable Interfaces**: Interfaces between contexts should be stable and well-defined
4. **Ownership**: Each context should have clear ownership and decision-making authority

#### Documentation
1. **Context Map**: Visual representation of contexts and their relationships
2. **Responsibility Matrix**: Clear definition of what each context owns
3. **Interface Specifications**: Detailed specifications of context interfaces
4. **Dependency Graph**: Map of dependencies between contexts

### Learning Objectives
After completing both exercises, you should be able to:
- Identify potential bounded contexts in complex domains
- Define clear boundaries and responsibilities
- Design interfaces between contexts
- Understand the trade-offs in context design
- Apply bounded context concepts to real projects

## Implementation Patterns and Code Examples

### Context Implementation Patterns

#### 1. Context as Separate Modules/Packages

**C# Example - Separate Assemblies**
```csharp
// CustomerContext assembly
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
        
        public async Task<Customer> RegisterCustomer(string name, EmailAddress email)
        {
            var existingCustomer = await _customerRepository.FindByEmail(email);
            if (existingCustomer != null)
            {
                throw new CustomerAlreadyExistsException($"Customer with email {email} already exists");
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
        private readonly List<OrderItem> _items = new List<OrderItem>();
        
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
                throw new InvalidOperationException("Cannot modify confirmed order");
                
            var item = new OrderItem(productId, price, quantity);
            _items.Add(item);
            RecalculateTotal();
        }
        
        public void Confirm()
        {
            if (Status != OrderStatus.Draft)
                throw new InvalidOperationException("Only draft orders can be confirmed");
                
            if (!_items.Any())
                throw new InvalidOperationException("Cannot confirm empty order");
                
            Status = OrderStatus.Confirmed;
        }
        
        private void RecalculateTotal()
        {
            TotalAmount = _items.Sum(item => item.TotalPrice);
        }
    }
}
```

**Java Example - Separate Packages**
```java
// Customer context package
package com.ecommerce.customer;

public class Customer {
    private final CustomerId id;
    private String name;
    private EmailAddress email;
    private CustomerStatus status;
    
    public Customer(CustomerId id, String name, EmailAddress email) {
        this.id = Objects.requireNonNull(id, "Customer ID cannot be null");
        this.name = Objects.requireNonNull(name, "Customer name cannot be null");
        this.email = Objects.requireNonNull(email, "Customer email cannot be null");
        this.status = CustomerStatus.ACTIVE;
    }
    
    public void updateEmail(EmailAddress newEmail) {
        if (newEmail == null) throw new IllegalArgumentException("Email cannot be null");
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
    private final List<OrderItem> items = new ArrayList<>();
    
    public Order(OrderId id, CustomerId customerId) {
        this.id = Objects.requireNonNull(id, "Order ID cannot be null");
        this.customerId = Objects.requireNonNull(customerId, "Customer ID cannot be null");
        this.status = OrderStatus.DRAFT;
        this.totalAmount = Money.zero();
    }
    
    public void addItem(ProductId productId, Money price, int quantity) {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException("Cannot modify confirmed order");
        }
        
        OrderItem item = new OrderItem(productId, price, quantity);
        items.add(item);
        recalculateTotal();
    }
    
    public void confirm() {
        if (status != OrderStatus.DRAFT) {
            throw new IllegalStateException("Only draft orders can be confirmed");
        }
        
        if (items.isEmpty()) {
            throw new IllegalStateException("Cannot confirm empty order");
        }
        
        this.status = OrderStatus.CONFIRMED;
    }
    
    private void recalculateTotal() {
        this.totalAmount = items.stream()
            .map(OrderItem::getTotalPrice)
            .reduce(Money.zero(), Money::add);
    }
}
```

**TypeScript Example - Separate Modules**
```typescript
// Customer context module
export namespace CustomerContext {
    export class Customer {
        private readonly id: CustomerId;
        private name: string;
        private email: EmailAddress;
        private status: CustomerStatus;
        
        constructor(id: CustomerId, name: string, email: EmailAddress) {
            if (!id) throw new Error("Customer ID cannot be null");
            if (!name) throw new Error("Customer name cannot be null");
            if (!email) throw new Error("Customer email cannot be null");
            
            this.id = id;
            this.name = name;
            this.email = email;
            this.status = CustomerStatus.Active;
        }
        
        updateEmail(newEmail: EmailAddress): void {
            if (!newEmail) throw new Error("Email cannot be null");
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
        
        async registerCustomer(name: string, email: EmailAddress): Promise<Customer> {
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
            if (!id) throw new Error("Order ID cannot be null");
            if (!customerId) throw new Error("Customer ID cannot be null");
            
            this.id = id;
            this.customerId = customerId;
            this.status = OrderStatus.Draft;
            this.totalAmount = Money.zero();
        }
        
        addItem(productId: ProductId, price: Money, quantity: number): void {
            if (this.status !== OrderStatus.Draft) {
                throw new Error("Cannot modify confirmed order");
            }
            
            const item = new OrderItem(productId, price, quantity);
            this.items.push(item);
            this.recalculateTotal();
        }
        
        confirm(): void {
            if (this.status !== OrderStatus.Draft) {
                throw new Error("Only draft orders can be confirmed");
            }
            
            if (this.items.length === 0) {
                throw new Error("Cannot confirm empty order");
            }
            
            this.status = OrderStatus.Confirmed;
        }
        
        private recalculateTotal(): void {
            this.totalAmount = this.items.reduce((total, item) => 
                total.add(item.getTotalPrice()), Money.zero());
        }
    }
}
```

**Python Example - Separate Packages**
```python
# customer_context package
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
            raise ValueError("Customer ID cannot be null")
        if not name:
            raise ValueError("Customer name cannot be null")
        if not email:
            raise ValueError("Customer email cannot be null")
            
        self.id = id
        self.name = name
        self.email = email
        self.status = CustomerStatus.ACTIVE
    
    def update_email(self, new_email: EmailAddress) -> None:
        if not new_email:
            raise ValueError("Email cannot be null")
        self.email = new_email
    
    def can_place_order(self) -> bool:
        return self.status == CustomerStatus.ACTIVE

class CustomerService:
    def __init__(self, customer_repository: ICustomerRepository):
        self.customer_repository = customer_repository
    
    async def register_customer(self, name: str, email: EmailAddress) -> Customer:
        existing_customer = await self.customer_repository.find_by_email(email)
        if existing_customer:
            raise ValueError(f"Customer with email {email} already exists")
        
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
            raise ValueError("Order ID cannot be null")
        if not customer_id:
            raise ValueError("Customer ID cannot be null")
            
        self.id = id
        self.customer_id = customer_id
        self.status = OrderStatus.DRAFT
        self.total_amount = Money.zero()
        self.items = []
    
    def add_item(self, product_id: ProductId, price: Money, quantity: int) -> None:
        if self.status != OrderStatus.DRAFT:
            raise ValueError("Cannot modify confirmed order")
        
        item = OrderItem(product_id, price, quantity)
        self.items.append(item)
        self.recalculate_total()
    
    def confirm(self) -> None:
        if self.status != OrderStatus.DRAFT:
            raise ValueError("Only draft orders can be confirmed")
        
        if not self.items:
            raise ValueError("Cannot confirm empty order")
        
        self.status = OrderStatus.CONFIRMED
    
    def recalculate_total(self) -> None:
        self.total_amount = sum(item.total_price for item in self.items)
```

### 2. Context Integration Patterns

#### Anti-Corruption Layer Pattern

When integrating with external systems or legacy code, use an anti-corruption layer to protect your domain model:

```csharp
// C# Example - Anti-Corruption Layer
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
                OrderStatus.Draft => "DRAFT",
                OrderStatus.Confirmed => "CONFIRMED",
                OrderStatus.Shipped => "SHIPPED",
                OrderStatus.Delivered => "DELIVERED",
                OrderStatus.Cancelled => "CANCELLED",
                _ => "UNKNOWN"
            };
        }
    }
}
```

#### Published Language Pattern

Use a shared language (often implemented as shared data contracts) for communication between contexts:

```csharp
// C# Example - Published Language
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
        public Dictionary<string, object> Data { get; set; }
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
                EventType = "OrderConfirmed",
                Timestamp = DateTime.UtcNow,
                Data = new Dictionary<string, object>
                {
                    ["TotalAmount"] = order.TotalAmount.Amount,
                    ["Currency"] = order.TotalAmount.Currency.Code
                }
            };
            
            // Publish to message bus or event store
            _eventBus.Publish(eventData);
        }
    }
}
```

### 3. Context Testing Strategies

#### Unit Testing Within Contexts

```csharp
// C# Example - Context Unit Tests
namespace OrderContext.Tests
{
    [TestClass]
    public class OrderTests
    {
        [TestMethod]
        public void AddItem_WhenOrderIsDraft_ShouldAddItem()
        {
            // Arrange
            var orderId = new OrderId("order-123");
            var customerId = new CustomerId("customer-456");
            var order = new Order(orderId, customerId);
            var productId = new ProductId("product-789");
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
            var productId = new ProductId("product-789");
            var price = new Money(10.00m, Currency.USD);
            
            // Act & Assert
            Assert.ThrowsException<InvalidOperationException>(() => 
                order.AddItem(productId, price, 1));
        }
        
        [TestMethod]
        public void Confirm_WhenOrderIsEmpty_ShouldThrowException()
        {
            // Arrange
            var order = CreateEmptyOrder();
            
            // Act & Assert
            Assert.ThrowsException<InvalidOperationException>(() => 
                order.Confirm());
        }
        
        private Order CreateConfirmedOrder()
        {
            var order = new Order(new OrderId("order-123"), new CustomerId("customer-456"));
            order.AddItem(new ProductId("product-789"), new Money(10.00m, Currency.USD), 1);
            order.Confirm();
            return order;
        }
        
        private Order CreateEmptyOrder()
        {
            return new Order(new OrderId("order-123"), new CustomerId("customer-456"));
        }
    }
}
```

#### Integration Testing Between Contexts

```csharp
// C# Example - Cross-Context Integration Tests
[TestClass]
public class OrderCustomerIntegrationTests
{
    [TestMethod]
    public async Task CreateOrder_WithValidCustomer_ShouldSucceed()
    {
        // Arrange
        var customer = await _customerService.RegisterCustomer("John Doe", new EmailAddress("john@example.com"));
        var orderId = new OrderId("order-123");
        
        // Act
        var order = new Order(orderId, customer.Id);
        order.AddItem(new ProductId("product-789"), new Money(10.00m, Currency.USD), 1);
        order.Confirm();
        
        // Assert
        Assert.AreEqual(OrderStatus.Confirmed, order.Status);
        Assert.AreEqual(customer.Id, order.CustomerId);
    }
    
    [TestMethod]
    public async Task CreateOrder_WithInactiveCustomer_ShouldFail()
    {
        // Arrange
        var customer = await _customerService.RegisterCustomer("John Doe", new EmailAddress("john@example.com"));
        customer.Deactivate();
        var orderId = new OrderId("order-123");
        
        // Act & Assert
        Assert.ThrowsException<InvalidOperationException>(() => 
            new Order(orderId, customer.Id));
    }
}
```

## Common Pitfalls and How to Avoid Them

### 1. Context Boundaries Too Small

**Problem**: Creating too many small contexts that don't provide value
```csharp
// Bad - Too granular
namespace CustomerNameContext { }
namespace CustomerEmailContext { }
namespace CustomerAddressContext { }
```

**Solution**: Group related concepts together
```csharp
// Good - Appropriate granularity
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
```

### 2. Context Boundaries Too Large

**Problem**: Creating contexts that are too large and complex
```csharp
// Bad - Too large
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
```

**Solution**: Split into focused contexts
```csharp
// Good - Focused contexts
namespace CustomerContext { public class Customer { } }
namespace OrderContext { public class Order { } }
namespace ProductContext { public class Product { } }
namespace InventoryContext { public class Inventory { } }
namespace PaymentContext { public class Payment { } }
namespace ShippingContext { public class Shipping { } }
```

### 3. Leaky Context Boundaries

**Problem**: Contexts that know too much about each other
```csharp
// Bad - Leaky boundaries
namespace OrderContext
{
    public class Order
    {
        public Customer Customer { get; set; } // Direct reference to customer
        public Product Product { get; set; }   // Direct reference to product
        // Order knows too much about other contexts
    }
}
```

**Solution**: Use references and interfaces
```csharp
// Good - Clean boundaries
namespace OrderContext
{
    public class Order
    {
        public OrderId Id { get; private set; }
        public CustomerId CustomerId { get; private set; } // Reference only
        public List<OrderItem> Items { get; private set; } // Owned by order context
        
        // Order only knows about its own concepts
    }
}
```

### 4. Inconsistent Context Models

**Problem**: Same concept represented differently across contexts
```csharp
// Bad - Inconsistent models
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
```

**Solution**: Use shared kernel or published language
```csharp
// Good - Consistent models
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
        // Order doesn't need full customer details
    }
}
```

## Advanced Topics

### 1. Context Evolution

As your understanding of the domain deepens, contexts may need to evolve:

```csharp
// Example: Splitting a context
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
```

### 2. Context Versioning

When contexts need to evolve, consider versioning strategies:

```csharp
// Example: Versioned context interfaces
namespace OrderContext.V1
{
    public interface IOrderService
    {
        Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items);
    }
}

namespace OrderContext.V2
{
    public interface IOrderService
    {
        Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items, ShippingAddress shippingAddress);
    }
}
```

### 3. Context Monitoring and Metrics

Monitor context health and performance:

```csharp
// Example: Context metrics
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
    public async Task<ContextMetrics> GetContextHealth(string contextName)
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
```

## Summary

Bounded contexts are the foundation of Domain-Driven Design, providing a way to manage complexity by creating clear boundaries around domain models. By understanding how to:

- **Identify contexts** through language differences and organizational boundaries
- **Implement contexts** using appropriate patterns and technologies
- **Integrate contexts** through well-defined interfaces and patterns
- **Test contexts** both in isolation and integration
- **Evolve contexts** as understanding deepens
- **Avoid common pitfalls** that lead to poor context design

Teams can build maintainable, scalable systems that truly reflect business reality. The key is to start with business understanding, create focused contexts, and maintain clear boundaries while allowing for evolution as the domain becomes clearer.

**Next**: [Ubiquitous Language](../2-Ubiquitous-Language/README.md) builds upon bounded contexts by developing shared language within each context boundary.
