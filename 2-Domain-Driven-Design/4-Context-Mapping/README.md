# Context Mapping

## Name
**Context Mapping** - Managing Relationships Between Bounded Contexts

## Goal of the Concept
Context mapping defines the relationships between different bounded contexts and how they interact. It helps manage the complexity of large systems by clearly defining how different parts communicate, what dependencies exist, and how to handle integration challenges.

## Theoretical Foundation

### Integration Complexity
Context mapping addresses the reality that large systems are composed of multiple bounded contexts that need to interact. Without clear mapping, these interactions become chaotic and unmanageable.

### Relationship Patterns
Eric Evans identified several patterns for context relationships, each with different characteristics, trade-offs, and implementation strategies. These patterns provide guidance for managing different types of relationships.

### Strategic Design
Context mapping is a strategic design tool that helps teams make high-level architectural decisions about how different parts of the system should interact and what level of coupling is acceptable.

### Organizational Alignment
Context mapping often reflects organizational structure, with different teams owning different contexts and needing to coordinate their work through well-defined interfaces.

## Consequences of Poor Context Mapping

### Unique Context Mapping Issues

**Integration Chaos**
- Different contexts interact in unpredictable ways
- Changes in one context break other contexts
- Integration becomes a source of bugs and failures
- System becomes hard to understand and maintain

**Coupling Problems**
- Contexts become tightly coupled despite boundaries
- Changes cascade across context boundaries
- Teams can't work independently
- System becomes fragile and hard to modify

**Communication Breakdown**
- Teams don't understand how their context relates to others
- Integration requirements are unclear
- Dependencies are hidden or misunderstood
- Coordination becomes difficult and error-prone

## Impact on System Architecture

### Architectural Benefits

**Clear Integration Points**
- Well-defined interfaces between contexts
- Clear understanding of dependencies
- Predictable integration behavior
- Easier to test and validate

**Team Autonomy**
- Teams can work independently on their contexts
- Clear boundaries reduce coordination overhead
- Different contexts can evolve at different rates
- Easier to scale development efforts

### Architectural Challenges

**Integration Complexity**
- Managing communication between contexts
- Handling data consistency across boundaries
- Performance considerations for cross-context operations
- Error handling and recovery across boundaries

## Role in Domain-Driven Design

Context mapping is essential to Domain-Driven Design because it:

- **Defines relationships** between different bounded contexts
- **Manages integration complexity** in large systems
- **Enables team autonomy** by providing clear boundaries
- **Supports strategic design** decisions about system architecture
- **Facilitates communication** between different teams

## How to Map Context Relationships

### 1. Identify Context Relationships
**What it means**: Determine how different bounded contexts need to interact with each other. This includes understanding data flow, dependencies, and communication patterns.

**How to do it**:
- Map data flow between contexts
- Identify which contexts depend on others
- Understand the direction of dependencies
- Look for shared concepts or data

**Example**: In an e-commerce system, the Order context might need customer information from the Customer context, and the Inventory context might need to know about orders to update stock levels.

### 2. Choose Relationship Patterns
**What it means**: Select appropriate patterns for each relationship based on the nature of the interaction, the level of coupling acceptable, and the organizational structure.

**How to do it**:
- Understand the characteristics of each pattern
- Consider the trade-offs of different patterns
- Match patterns to relationship needs
- Consider organizational constraints

**Example**: A Customer-Supplier relationship might be appropriate when one context provides services to another, while a Shared Kernel might be used when two contexts need to share some common concepts.

### 3. Define Integration Interfaces
**What it means**: Create clear interfaces for communication between contexts, including data formats, protocols, and error handling.

**How to do it**:
- Design stable interfaces between contexts
- Define data formats and protocols
- Specify error handling and recovery
- Document integration requirements

**Example**: The Order context might expose a REST API for other contexts to query order information, with clear data formats and error codes.

### 4. Handle Data Consistency
**What it means**: Manage data consistency across context boundaries, which is often the most challenging aspect of context integration.

**How to do it**:
- Choose appropriate consistency models
- Implement eventual consistency where needed
- Handle data synchronization
- Manage conflicts and reconciliation

**Example**: When an order is placed, the Inventory context might be updated asynchronously, with eventual consistency between the Order and Inventory contexts.

### 5. Plan for Evolution
**What it means**: Design context relationships to evolve over time as the system grows and requirements change.

**How to do it**:
- Design interfaces to be extensible
- Plan for versioning and backward compatibility
- Consider how relationships might change
- Design for independent evolution

**Example**: The Customer context might evolve its data model while maintaining backward compatibility with the Order context through versioned APIs.

## Context Relationship Patterns

### 1. Shared Kernel
**What it means**: Two teams share a small, common model that both teams depend on. This pattern is used when contexts are closely related but need some independence.

**Characteristics**:
- Small, shared model between contexts
- Requires close coordination between teams
- Changes to shared model affect both contexts
- Provides consistency for shared concepts

**When to use**:
- Contexts are closely related
- Some concepts must be shared
- Teams can coordinate closely
- Consistency is more important than independence

**Example**: The Customer and Order contexts might share a common CustomerId concept to ensure consistency in customer identification.

### 2. Customer-Supplier
**What it means**: One context (supplier) provides services to another context (customer). The supplier has more control over the interface, but the customer's needs influence the design.

**Characteristics**:
- Clear upstream-downstream relationship
- Supplier controls the interface
- Customer needs influence supplier design
- Supplier provides services to customer

**When to use**:
- One context provides services to another
- Clear dependency direction
- Supplier can influence customer needs
- Customer depends on supplier capabilities

**Example**: The Payment context provides payment processing services to the Order context, with the Payment context controlling the payment interface.

### 3. Conformist
**What it means**: The downstream context conforms to the upstream model without modification. This pattern is used when the downstream context has little influence over the upstream design.

**Characteristics**:
- Downstream context uses upstream model as-is
- Minimal customization or adaptation
- Upstream context has full control
- Simple integration but limited flexibility

**When to use**:
- Downstream context has little influence
- Upstream model is suitable for downstream needs
- Simplicity is more important than customization
- Upstream context is stable and well-designed

**Example**: The Reporting context might conform to the Order context's data model for generating reports, using the same data structures.

### 4. Anti-Corruption Layer
**What it means**: The downstream context translates the upstream model to its own model, protecting itself from changes in the upstream context.

**Characteristics**:
- Translation layer between contexts
- Downstream context maintains its own model
- Protects downstream from upstream changes
- More complex but provides better isolation

**When to use**:
- Upstream model doesn't fit downstream needs
- Downstream context needs protection from upstream changes
- Downstream context has specific requirements
- Isolation is more important than simplicity

**Example**: The Order context might translate customer data from the Customer context into its own customer model to maintain its specific requirements.

### 5. Open Host Service
**What it means**: The upstream context provides a well-defined service interface that multiple downstream contexts can use.

**Characteristics**:
- Well-defined service interface
- Multiple downstream contexts can use the service
- Upstream context controls the interface
- Service is designed for reuse

**When to use**:
- Multiple contexts need the same service
- Service can be standardized
- Upstream context can provide stable interface
- Reuse is more important than customization

**Example**: The Customer context might provide a customer lookup service that multiple other contexts can use to get customer information.

### 6. Published Language
**What it means**: A well-documented, shared language is used for communication between contexts, often implemented as a shared data format or API specification.

**Characteristics**:
- Well-documented, shared language
- Used for communication between contexts
- Often implemented as shared formats
- Provides consistency and clarity

**When to use**:
- Multiple contexts need to communicate
- Communication needs to be standardized
- Consistency is important
- Language can be shared and documented

**Example**: A shared JSON schema might be used for customer data exchange between the Customer and Order contexts.

## Examples of Context Mapping

### E-commerce System Example

**Context Map**
```
[Customer Context] --Customer-Supplier--> [Order Context]
[Order Context] --Customer-Supplier--> [Payment Context]
[Order Context] --Customer-Supplier--> [Inventory Context]
[Order Context] --Customer-Supplier--> [Shipping Context]
[Customer Context] --Open Host Service--> [Marketing Context]
[Order Context] --Anti-Corruption Layer--> [Legacy System]
```

**Relationship Details**
- **Customer-Order**: Customer context provides customer information to Order context
- **Order-Payment**: Order context requests payment processing from Payment context
- **Order-Inventory**: Order context requests inventory updates from Inventory context
- **Order-Shipping**: Order context provides shipping information to Shipping context
- **Customer-Marketing**: Customer context provides customer data service to Marketing context
- **Order-Legacy**: Order context translates data for legacy system integration

### Banking System Example

**Context Map**
```
[Account Management] --Shared Kernel--> [Transaction Processing]
[Account Management] --Customer-Supplier--> [Loan Processing]
[Transaction Processing] --Customer-Supplier--> [Payment Processing]
[Account Management] --Open Host Service--> [Reporting Context]
[Loan Processing] --Anti-Corruption Layer--> [Credit Bureau]
```

**Relationship Details**
- **Account-Transaction**: Shared kernel for account and transaction concepts
- **Account-Loan**: Account context provides account information to Loan context
- **Transaction-Payment**: Transaction context requests payment processing
- **Account-Reporting**: Account context provides account data service
- **Loan-Credit Bureau**: Loan context translates data for credit bureau integration

## How This Concept Helps with System Design

1. **Clear Integration Points**: Well-defined interfaces between contexts
2. **Manageable Complexity**: Large systems broken into manageable pieces
3. **Team Autonomy**: Teams can work independently on their contexts
4. **Predictable Behavior**: Integration behavior is well-defined and predictable
5. **Scalable Architecture**: System can grow by adding new contexts

## How This Concept Helps with Development

1. **Independent Development**: Teams can work on their contexts independently
2. **Clear Dependencies**: Dependencies between contexts are explicit
3. **Easier Testing**: Each context can be tested independently
4. **Better Coordination**: Teams understand how their work affects others
5. **Faster Development**: Reduced coordination overhead

## Common Patterns and Anti-patterns

### Patterns

**Clear Relationship Patterns**
- Use established patterns for context relationships
- Choose patterns based on relationship characteristics
- Document relationship patterns and rationale

**Stable Interfaces**
- Design interfaces to be stable and well-defined
- Version interfaces for evolution
- Provide clear documentation

**Appropriate Coupling**
- Choose coupling level based on relationship needs
- Balance independence with integration needs
- Consider organizational constraints

### Anti-patterns

**Big Ball of Mud**
- No clear boundaries between contexts
- Everything is connected to everything else
- Difficult to understand or modify

**Tight Coupling**
- Contexts are too tightly coupled
- Changes cascade across boundaries
- Teams can't work independently

**Hidden Dependencies**
- Dependencies are not explicit or documented
- Integration requirements are unclear
- Changes have unexpected effects

## Summary

Context mapping is essential for managing the complexity of large systems with multiple bounded contexts. By identifying relationships, choosing appropriate patterns, and defining clear interfaces, teams can:

- **Manage integration complexity** in large systems
- **Enable team autonomy** through clear boundaries
- **Support system evolution** through well-designed relationships
- **Facilitate communication** between different teams
- **Build maintainable systems** with clear integration points

The key to successful context mapping is understanding the nature of relationships, choosing appropriate patterns, defining stable interfaces, handling data consistency, and planning for evolution. This creates a foundation for building large, maintainable systems.

## Exercise 1: Map Context Relationships

### Objective
Analyze a complex system and map the relationships between different bounded contexts.

### Task
Choose a complex business domain and map the relationships between different bounded contexts.

1. **Identify Contexts**: List all bounded contexts in the system
2. **Map Relationships**: Identify how contexts interact with each other
3. **Choose Patterns**: Select appropriate relationship patterns for each interaction
4. **Document Dependencies**: Map dependencies and data flow
5. **Create Context Map**: Visualize the relationships between contexts

### Deliverables
- List of identified bounded contexts
- Relationship analysis between contexts
- Pattern selection for each relationship
- Dependency mapping
- Visual context map

### Getting Started
1. Choose a complex business domain
2. Identify all bounded contexts
3. Analyze how contexts interact
4. Choose appropriate relationship patterns
5. Create a visual map of relationships

---

## Exercise 2: Design Integration Interfaces

### Objective
Design integration interfaces for the mapped context relationships.

### Task
Take the context relationships from Exercise 1 and design integration interfaces.

1. **Design Interfaces**: Create interfaces for each context relationship
2. **Define Data Formats**: Specify data formats for communication
3. **Handle Errors**: Design error handling and recovery
4. **Plan Consistency**: Design data consistency strategies
5. **Document Integration**: Create integration documentation

### Success Criteria
- Clear interfaces for each relationship
- Well-defined data formats
- Appropriate error handling
- Data consistency strategies
- Complete integration documentation

### Getting Started
1. Use your context relationships from Exercise 1
2. Design interfaces for each relationship
3. Define data formats and protocols
4. Plan error handling and recovery
5. Document integration requirements

### Implementation Best Practices

#### Interface Design
1. **Stable Interfaces**: Design interfaces to be stable and well-defined
2. **Clear Contracts**: Define clear contracts for each interface
3. **Versioning**: Plan for interface versioning and evolution
4. **Documentation**: Provide clear documentation for each interface

#### Integration Patterns
1. **Appropriate Patterns**: Choose patterns based on relationship characteristics
2. **Consistency Models**: Choose appropriate consistency models
3. **Error Handling**: Design robust error handling and recovery
4. **Performance**: Consider performance implications of integration

### Learning Objectives
After completing both exercises, you should be able to:
- Map relationships between bounded contexts
- Choose appropriate relationship patterns
- Design integration interfaces
- Handle data consistency across boundaries
- Plan for system evolution

## Implementation Patterns and Code Examples

### Context Integration Implementation Patterns

#### 1. Customer-Supplier Pattern Implementation

**C# Example - Customer-Supplier Integration**
```csharp
// Customer Context (Supplier)
namespace CustomerContext
{
    public interface ICustomerService
    {
        Task<Customer> GetCustomer(CustomerId customerId);
        Task<bool> IsCustomerActive(CustomerId customerId);
        Task<CustomerProfile> GetCustomerProfile(CustomerId customerId);
    }
    
    public class CustomerService : ICustomerService
    {
        private readonly ICustomerRepository _customerRepository;
        
        public CustomerService(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository ?? throw new ArgumentNullException(nameof(customerRepository));
        }
        
        public async Task<Customer> GetCustomer(CustomerId customerId)
        {
            var customer = await _customerRepository.FindById(customerId);
            if (customer == null)
            {
                throw new CustomerNotFoundException($"Customer with ID {customerId} not found");
            }
            
            return customer;
        }
        
        public async Task<bool> IsCustomerActive(CustomerId customerId)
        {
            var customer = await GetCustomer(customerId);
            return customer.Status == CustomerStatus.Active;
        }
        
        public async Task<CustomerProfile> GetCustomerProfile(CustomerId customerId)
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
        
        public async Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items)
        {
            // Validate customer exists and is active
            if (!await _customerService.IsCustomerActive(customerId))
            {
                throw new InvalidCustomerException($"Customer {customerId} is not active");
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
        
        public async Task<Order> GetOrderWithCustomerInfo(OrderId orderId)
        {
            var order = await _orderRepository.FindById(orderId);
            if (order == null)
            {
                throw new OrderNotFoundException($"Order with ID {orderId} not found");
            }
            
            // Get customer information from customer context
            var customerProfile = await _customerService.GetCustomerProfile(order.CustomerId);
            
            // Return order with customer information
            return order;
        }
    }
}
```

**Java Example - Customer-Supplier Integration**
```java
// Customer Context (Supplier)
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
        this.customerRepository = Objects.requireNonNull(customerRepository, "Customer repository cannot be null");
    }
    
    @Override
    public Customer getCustomer(CustomerId customerId) {
        return customerRepository.findById(customerId)
            .orElseThrow(() -> new CustomerNotFoundException("Customer with ID " + customerId + " not found"));
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
        this.orderRepository = Objects.requireNonNull(orderRepository, "Order repository cannot be null");
        this.customerService = Objects.requireNonNull(customerService, "Customer service cannot be null");
    }
    
    public Order createOrder(CustomerId customerId, List<OrderItem> items) {
        // Validate customer exists and is active
        if (!customerService.isCustomerActive(customerId)) {
            throw new InvalidCustomerException("Customer " + customerId + " is not active");
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
            .orElseThrow(() -> new OrderNotFoundException("Order with ID " + orderId + " not found"));
        
        // Get customer information from customer context
        CustomerProfile customerProfile = customerService.getCustomerProfile(order.getCustomerId());
        
        // Return order with customer information
        return order;
    }
}
```

#### 2. Anti-Corruption Layer Pattern Implementation

**C# Example - Anti-Corruption Layer**
```csharp
// Legacy System Integration
namespace OrderContext
{
    // Internal domain model
    public class Order
    {
        public OrderId Id { get; private set; }
        public CustomerId CustomerId { get; private set; }
        public OrderStatus Status { get; private set; }
        public Money TotalAmount { get; private set; }
        public List<OrderItem> Items { get; private set; }
        
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
        
        public async Task<Order> GetOrderFromLegacySystem(string legacyOrderNumber)
        {
            // Get data from legacy system
            var legacyOrder = await _legacyOrderService.GetOrder(legacyOrderNumber);
            
            // Translate to domain model
            return TranslateToDomainModel(legacyOrder);
        }
        
        public async Task<string> CreateOrderInLegacySystem(Order order)
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
                Items = legacyOrder.Items.Select(item => new OrderItem(
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
                Items = order.Items.Select(item => new LegacyOrderItemData
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
                "PENDING" => OrderStatus.Draft,
                "CONFIRMED" => OrderStatus.Confirmed,
                "SHIPPED" => OrderStatus.Shipped,
                "DELIVERED" => OrderStatus.Delivered,
                "CANCELLED" => OrderStatus.Cancelled,
                _ => OrderStatus.Draft
            };
        }
        
        private string MapStatusToLegacy(OrderStatus status)
        {
            return status switch
            {
                OrderStatus.Draft => "PENDING",
                OrderStatus.Confirmed => "CONFIRMED",
                OrderStatus.Shipped => "SHIPPED",
                OrderStatus.Delivered => "DELIVERED",
                OrderStatus.Cancelled => "CANCELLED",
                _ => "PENDING"
            };
        }
        
        private Currency MapCurrency(string legacyCurrency)
        {
            return legacyCurrency switch
            {
                "USD" => Currency.USD,
                "EUR" => Currency.EUR,
                "GBP" => Currency.GBP,
                _ => Currency.USD
            };
        }
        
        private string MapCurrencyToLegacy(Currency currency)
        {
            return currency switch
            {
                Currency.USD => "USD",
                Currency.EUR => "EUR",
                Currency.GBP => "GBP",
                _ => "USD"
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
        public List<LegacyOrderItemData> Items { get; set; }
    }
    
    public class LegacyOrderItemData
    {
        public string ProductCode { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }
    }
}
```

**TypeScript Example - Anti-Corruption Layer**
```typescript
// Legacy System Integration
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
        
        async getOrderFromLegacySystem(legacyOrderNumber: string): Promise<Order> {
            // Get data from legacy system
            const legacyOrder = await this.legacyOrderService.getOrder(legacyOrderNumber);
            
            // Translate to domain model
            return this.translateToDomainModel(legacyOrder);
        }
        
        async createOrderInLegacySystem(order: Order): Promise<string> {
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
            order.items = legacyOrder.items.map(item => new OrderItem(
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
                items: order.getItems().map(item => ({
                    productCode: item.getProductId().getValue(),
                    price: item.getPrice().getAmount(),
                    quantity: item.getQuantity()
                }))
            };
        }
        
        private mapStatus(legacyStatus: string): OrderStatus {
            switch (legacyStatus) {
                case "PENDING": return OrderStatus.Draft;
                case "CONFIRMED": return OrderStatus.Confirmed;
                case "SHIPPED": return OrderStatus.Shipped;
                case "DELIVERED": return OrderStatus.Delivered;
                case "CANCELLED": return OrderStatus.Cancelled;
                default: return OrderStatus.Draft;
            }
        }
        
        private mapStatusToLegacy(status: OrderStatus): string {
            switch (status) {
                case OrderStatus.Draft: return "PENDING";
                case OrderStatus.Confirmed: return "CONFIRMED";
                case OrderStatus.Shipped: return "SHIPPED";
                case OrderStatus.Delivered: return "DELIVERED";
                case OrderStatus.Cancelled: return "CANCELLED";
                default: return "PENDING";
            }
        }
        
        private mapCurrency(legacyCurrency: string): Currency {
            switch (legacyCurrency) {
                case "USD": return Currency.USD;
                case "EUR": return Currency.EUR;
                case "GBP": return Currency.GBP;
                default: return Currency.USD;
            }
        }
        
        private mapCurrencyToLegacy(currency: Currency): string {
            switch (currency) {
                case Currency.USD: return "USD";
                case Currency.EUR: return "EUR";
                case Currency.GBP: return "GBP";
                default: return "USD";
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
```

#### 3. Published Language Pattern Implementation

**C# Example - Published Language**
```csharp
// Shared Contracts for Context Communication
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
                EventType = "OrderConfirmed",
                Timestamp = DateTime.UtcNow,
                Data = new Dictionary<string, object>
                {
                    ["TotalAmount"] = order.TotalAmount.Amount,
                    ["Currency"] = order.TotalAmount.Currency.Code,
                    ["ItemCount"] = order.Items.Count
                }
            };
            
            await _eventBus.PublishAsync("order.confirmed", eventData);
        }
        
        public async Task PublishOrderShipped(Order order, string trackingNumber)
        {
            var eventData = new OrderEventContract
            {
                OrderId = order.Id.Value,
                CustomerId = order.CustomerId.Value,
                EventType = "OrderShipped",
                Timestamp = DateTime.UtcNow,
                Data = new Dictionary<string, object>
                {
                    ["TrackingNumber"] = trackingNumber,
                    ["ShippedAt"] = DateTime.UtcNow
                }
            };
            
            await _eventBus.PublishAsync("order.shipped", eventData);
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
        
        public async Task<Order> ConfirmOrder(OrderId orderId)
        {
            var order = await _orderRepository.FindById(orderId);
            if (order == null)
            {
                throw new OrderNotFoundException($"Order with ID {orderId} not found");
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
```

#### 4. Shared Kernel Pattern Implementation

**C# Example - Shared Kernel**
```csharp
// Shared Kernel - Common concepts used by multiple contexts
namespace SharedKernel
{
    // Shared value objects
    public class Money
    {
        public decimal Amount { get; private set; }
        public Currency Currency { get; private set; }
        
        public Money(decimal amount, Currency currency)
        {
            if (amount < 0)
                throw new ArgumentException("Amount cannot be negative");
                
            Amount = amount;
            Currency = currency ?? throw new ArgumentNullException(nameof(currency));
        }
        
        public Money Add(Money other)
        {
            if (other == null) throw new ArgumentNullException(nameof(other));
            if (Currency != other.Currency)
                throw new InvalidOperationException("Cannot add different currencies");
                
            return new Money(Amount + other.Amount, Currency);
        }
        
        public Money Multiply(decimal factor)
        {
            if (factor < 0)
                throw new ArgumentException("Factor cannot be negative");
                
            return new Money(Amount * factor, Currency);
        }
        
        public override bool Equals(object obj)
        {
            return obj is Money other && 
                   Amount == other.Amount && 
                   Currency == other.Currency;
        }
        
        public override int GetHashCode()
        {
            return HashCode.Combine(Amount, Currency);
        }
        
        public static Money Zero(Currency currency) => new Money(0, currency);
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
                throw new ArgumentException("Customer ID cannot be null or empty");
                
            Value = value;
        }
        
        public static CustomerId Generate() => new CustomerId(Guid.NewGuid().ToString());
        
        public override bool Equals(object obj)
        {
            return obj is CustomerId other && Value == other.Value;
        }
        
        public override int GetHashCode()
        {
            return Value.GetHashCode();
        }
        
        public override string ToString() => Value;
    }
    
    public class OrderId
    {
        public string Value { get; private set; }
        
        public OrderId(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("Order ID cannot be null or empty");
                
            Value = value;
        }
        
        public static OrderId Generate() => new OrderId(Guid.NewGuid().ToString());
        
        public override bool Equals(object obj)
        {
            return obj is OrderId other && Value == other.Value;
        }
        
        public override int GetHashCode()
        {
            return Value.GetHashCode();
        }
        
        public override string ToString() => Value;
    }
    
    public class ProductId
    {
        public string Value { get; private set; }
        
        public ProductId(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("Product ID cannot be null or empty");
                
            Value = value;
        }
        
        public static ProductId Generate() => new ProductId(Guid.NewGuid().ToString());
        
        public override bool Equals(object obj)
        {
            return obj is ProductId other && Value == other.Value;
        }
        
        public override int GetHashCode()
        {
            return Value.GetHashCode();
        }
        
        public override string ToString() => Value;
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
        private readonly List<OrderItem> _items = new List<OrderItem>();
        
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
            TotalAmount = _items.Aggregate(Money.Zero(Currency.USD), (total, item) => total.Add(item.TotalPrice));
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
        
        public Money TotalPrice => Price.Multiply(Quantity);
    }
}
```

### 5. Context Integration Testing Patterns

**C# Example - Integration Testing**
```csharp
// Integration tests for context relationships
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
            var customer = await _customerService.RegisterCustomer("John Doe", new EmailAddress("john@example.com"));
            var product = await _productService.CreateProduct("Test Product", new Money(10.00m, Currency.USD));
            
            // Act
            var order = await _orderService.CreateOrder(customer.Id, new List<OrderItem>
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
            var customer = await _customerService.RegisterCustomer("John Doe", new EmailAddress("john@example.com"));
            customer.Deactivate();
            
            // Act & Assert
            await Assert.ThrowsExceptionAsync<InvalidCustomerException>(async () =>
            {
                await _orderService.CreateOrder(customer.Id, new List<OrderItem>());
            });
        }
        
        [TestMethod]
        public async Task OrderConfirmation_ShouldUpdateCustomerStatistics()
        {
            // Arrange
            var customer = await _customerService.RegisterCustomer("John Doe", new EmailAddress("john@example.com"));
            var order = await _orderService.CreateOrder(customer.Id, new List<OrderItem>());
            
            // Act
            await _orderService.ConfirmOrder(order.Id);
            
            // Assert
            var updatedCustomer = await _customerService.GetCustomer(customer.Id);
            Assert.AreEqual(1, updatedCustomer.OrderCount);
            Assert.AreEqual(order.TotalAmount, updatedCustomer.TotalSpent);
        }
    }
}
```

### 6. Context Monitoring and Health Checks

**C# Example - Context Health Monitoring**
```csharp
// Context health monitoring
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
        
        public async Task<ContextHealthReport> CheckHealth()
        {
            var report = new ContextHealthReport
            {
                Timestamp = DateTime.UtcNow,
                Contexts = new List<ContextHealth>()
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
        
        private async Task<ContextHealth> CheckCustomerContextHealth()
        {
            try
            {
                var startTime = DateTime.UtcNow;
                var customer = await _customerService.GetCustomer(CustomerId.Generate());
                var responseTime = DateTime.UtcNow - startTime;
                
                return new ContextHealth
                {
                    ContextName = "Customer",
                    Status = "Healthy",
                    ResponseTime = responseTime,
                    LastChecked = DateTime.UtcNow
                };
            }
            catch (Exception ex)
            {
                return new ContextHealth
                {
                    ContextName = "Customer",
                    Status = "Unhealthy",
                    Error = ex.Message,
                    LastChecked = DateTime.UtcNow
                };
            }
        }
        
        private async Task<ContextHealth> CheckOrderContextHealth()
        {
            try
            {
                var startTime = DateTime.UtcNow;
                var order = await _orderService.GetOrder(OrderId.Generate());
                var responseTime = DateTime.UtcNow - startTime;
                
                return new ContextHealth
                {
                    ContextName = "Order",
                    Status = "Healthy",
                    ResponseTime = responseTime,
                    LastChecked = DateTime.UtcNow
                };
            }
            catch (Exception ex)
            {
                return new ContextHealth
                {
                    ContextName = "Order",
                    Status = "Unhealthy",
                    Error = ex.Message,
                    LastChecked = DateTime.UtcNow
                };
            }
        }
        
        private async Task<ContextHealth> CheckProductContextHealth()
        {
            try
            {
                var startTime = DateTime.UtcNow;
                var product = await _productService.GetProduct(ProductId.Generate());
                var responseTime = DateTime.UtcNow - startTime;
                
                return new ContextHealth
                {
                    ContextName = "Product",
                    Status = "Healthy",
                    ResponseTime = responseTime,
                    LastChecked = DateTime.UtcNow
                };
            }
            catch (Exception ex)
            {
                return new ContextHealth
                {
                    ContextName = "Product",
                    Status = "Unhealthy",
                    Error = ex.Message,
                    LastChecked = DateTime.UtcNow
                };
            }
        }
        
        private async Task<ContextHealth> CheckContextIntegrationHealth()
        {
            try
            {
                var startTime = DateTime.UtcNow;
                
                // Test cross-context integration
                var customer = await _customerService.RegisterCustomer("Test Customer", new EmailAddress("test@example.com"));
                var product = await _productService.CreateProduct("Test Product", new Money(10.00m, Currency.USD));
                var order = await _orderService.CreateOrder(customer.Id, new List<OrderItem>
                {
                    new OrderItem(product.Id, product.Price, 1)
                });
                
                var responseTime = DateTime.UtcNow - startTime;
                
                return new ContextHealth
                {
                    ContextName = "Integration",
                    Status = "Healthy",
                    ResponseTime = responseTime,
                    LastChecked = DateTime.UtcNow
                };
            }
            catch (Exception ex)
            {
                return new ContextHealth
                {
                    ContextName = "Integration",
                    Status = "Unhealthy",
                    Error = ex.Message,
                    LastChecked = DateTime.UtcNow
                };
            }
        }
    }
    
    public class ContextHealthReport
    {
        public DateTime Timestamp { get; set; }
        public List<ContextHealth> Contexts { get; set; }
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
```

## Common Pitfalls and How to Avoid Them

### 1. Tight Coupling Between Contexts

**Problem**: Contexts become too tightly coupled
```csharp
// Bad - Tight coupling
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
// Good - Loose coupling
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

### 2. Inconsistent Data Models

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

### 3. Poor Error Handling Across Contexts

**Problem**: Errors are not handled properly across context boundaries
```csharp
// Bad - Poor error handling
namespace OrderContext
{
    public class OrderService
    {
        public async Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items)
        {
            var customer = await _customerService.GetCustomer(customerId);
            // What if customer service is down?
            // What if customer doesn't exist?
            
            var order = new Order(OrderId.Generate(), customerId);
            // Implementation...
        }
    }
}
```

**Solution**: Implement proper error handling
```csharp
// Good - Proper error handling
namespace OrderContext
{
    public class OrderService
    {
        public async Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items)
        {
            try
            {
                var customer = await _customerService.GetCustomer(customerId);
                if (customer == null)
                {
                    throw new CustomerNotFoundException($"Customer with ID {customerId} not found");
                }
                
                if (customer.Status != CustomerStatus.Active)
                {
                    throw new InvalidCustomerException($"Customer {customerId} is not active");
                }
                
                var order = new Order(OrderId.Generate(), customerId);
                // Implementation...
                
                return order;
            }
            catch (CustomerServiceException ex)
            {
                throw new OrderCreationException("Failed to create order due to customer service error", ex);
            }
            catch (Exception ex)
            {
                throw new OrderCreationException("Failed to create order", ex);
            }
        }
    }
}
```

### 4. Lack of Context Monitoring

**Problem**: No visibility into context health and performance
```csharp
// Bad - No monitoring
namespace OrderContext
{
    public class OrderService
    {
        public async Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items)
        {
            // No monitoring or logging
            var order = new Order(OrderId.Generate(), customerId);
            // Implementation...
        }
    }
}
```

**Solution**: Implement comprehensive monitoring
```csharp
// Good - Comprehensive monitoring
namespace OrderContext
{
    public class OrderService
    {
        private readonly ILogger<OrderService> _logger;
        private readonly IMetricsCollector _metricsCollector;
        
        public OrderService(ILogger<OrderService> logger, IMetricsCollector metricsCollector)
        {
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _metricsCollector = metricsCollector ?? throw new ArgumentNullException(nameof(metricsCollector));
        }
        
        public async Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items)
        {
            using var activity = _metricsCollector.StartActivity("OrderService.CreateOrder");
            
            try
            {
                _logger.LogInformation("Creating order for customer {CustomerId}", customerId);
                
                var order = new Order(OrderId.Generate(), customerId);
                // Implementation...
                
                _metricsCollector.IncrementCounter("orders.created");
                _logger.LogInformation("Order {OrderId} created successfully", order.Id);
                
                return order;
            }
            catch (Exception ex)
            {
                _metricsCollector.IncrementCounter("orders.creation.failed");
                _logger.LogError(ex, "Failed to create order for customer {CustomerId}", customerId);
                throw;
            }
        }
    }
}
```

## Advanced Topics

### 1. Context Versioning and Evolution

**C# Example - Context Versioning**
```csharp
// Context versioning
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
        
        public async Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items, ShippingAddress shippingAddress = null)
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
```

### 2. Context Performance Optimization

**C# Example - Performance Optimization**
```csharp
// Context performance optimization
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
        
        public async Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items)
        {
            // Cache customer validation
            var cacheKey = $"customer:{customerId}:active";
            var isCustomerActive = await _cache.GetAsync<bool>(cacheKey);
            
            if (!isCustomerActive.HasValue)
            {
                isCustomerActive = await _customerService.IsCustomerActive(customerId);
                await _cache.SetAsync(cacheKey, isCustomerActive.Value, TimeSpan.FromMinutes(5));
            }
            
            if (!isCustomerActive.Value)
            {
                throw new InvalidCustomerException($"Customer {customerId} is not active");
            }
            
            // Batch product validation
            var productIds = items.Select(item => item.ProductId).ToList();
            var products = await _productService.GetProducts(productIds);
            
            // Create order
            var order = new Order(OrderId.Generate(), customerId);
            foreach (var item in items)
            {
                var product = products.FirstOrDefault(p => p.Id == item.ProductId);
                if (product == null)
                {
                    throw new ProductNotFoundException($"Product {item.ProductId} not found");
                }
                
                order.AddItem(item.ProductId, product.Price, item.Quantity);
            }
            
            order.Confirm();
            await _orderRepository.Save(order);
            
            return order;
        }
    }
}
```

### 3. Context Security and Authorization

**C# Example - Context Security**
```csharp
// Context security and authorization
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
        
        public async Task<Order> CreateOrder(CustomerId customerId, List<OrderItem> items, string userId)
        {
            // Check authorization
            if (!await _authorizationService.CanCreateOrder(userId, customerId))
            {
                throw new UnauthorizedException($"User {userId} is not authorized to create orders for customer {customerId}");
            }
            
            // Validate customer
            var customer = await _customerService.GetCustomer(customerId);
            if (customer == null)
            {
                throw new CustomerNotFoundException($"Customer with ID {customerId} not found");
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
                Action = "CreateOrder",
                ResourceId = order.Id.Value,
                Timestamp = DateTime.UtcNow,
                Details = $"Order created for customer {customerId}"
            });
            
            return order;
        }
        
        public async Task<Order> GetOrder(OrderId orderId, string userId)
        {
            var order = await _orderRepository.FindById(orderId);
            if (order == null)
            {
                throw new OrderNotFoundException($"Order with ID {orderId} not found");
            }
            
            // Check authorization
            if (!await _authorizationService.CanAccessOrder(userId, order))
            {
                throw new UnauthorizedException($"User {userId} is not authorized to access order {orderId}");
            }
            
            return order;
        }
    }
}
```

## Summary

Context mapping is essential for managing the complexity of large systems with multiple bounded contexts. By understanding how to:

- **Map relationships** between different bounded contexts
- **Choose appropriate patterns** for each relationship type
- **Implement integration** using well-defined interfaces and patterns
- **Handle data consistency** across context boundaries
- **Test integration** both in isolation and end-to-end
- **Monitor context health** and performance
- **Evolve contexts** as understanding deepens
- **Avoid common pitfalls** that lead to poor integration

Teams can build maintainable, scalable systems that truly reflect business reality. The key is to start with clear relationship mapping, choose appropriate patterns, implement stable interfaces, handle consistency properly, and monitor the health of the entire system.

**Next**: [Strategic Patterns](../5-Strategic-Patterns/README.md) builds upon context mapping by providing guidance on organizing domain-driven systems at a high level.
