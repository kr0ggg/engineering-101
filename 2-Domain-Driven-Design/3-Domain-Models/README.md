# Domain Models

## Name
**Domain Models** - The Heart of Domain-Driven Design

## Goal of the Concept
Domain models represent the essential concepts and relationships in the business domain. They serve as the foundation for all software design decisions and should reflect the true nature of the business, capturing both data and behavior that represents business rules and processes.

## Theoretical Foundation

### Model-Driven Design
Domain models are the core of model-driven design, where the software structure directly reflects the domain structure. This approach ensures that the code represents business reality rather than technical convenience.

### Rich Domain Models
Domain models should be rich in behavior, not just data containers. They should encapsulate business rules and processes, making the system easier to understand and maintain.

### Domain Logic Encapsulation
Business logic should be encapsulated within domain models rather than scattered throughout the application. This ensures that business rules are centralized and consistent.

### Conceptual Integrity
Domain models should maintain conceptual integrity, meaning that the model should be internally consistent and reflect a coherent understanding of the domain.

## Consequences of Poor Domain Models

### Unique Domain Model Issues

**Anemic Domain Models**
- Models contain only data without behavior
- Business logic is scattered throughout the application
- The system becomes hard to understand and maintain
- Business rules are duplicated and inconsistent

**Technical Models**
- Models reflect technical concerns rather than business concepts
- The system becomes disconnected from business reality
- Changes to business requirements require major technical changes
- The system becomes hard to modify and extend

**Inconsistent Models**
- Different parts of the system use different models for the same concepts
- Business rules are implemented differently in different areas
- The system becomes unpredictable and hard to debug
- Knowledge about the domain is lost

## Impact on System Design

### Design Benefits

**Business Alignment**
- The system structure reflects business structure
- Business rules are centralized and consistent
- The system is easier to understand for business stakeholders
- Changes to business requirements are easier to implement

**Maintainability**
- Business logic is encapsulated and centralized
- The system is easier to modify and extend
- Bugs are easier to find and fix
- The system is more predictable

### Design Challenges

**Complexity Management**
- Rich domain models can become complex
- Balancing richness with simplicity
- Managing relationships between models
- Ensuring models remain focused and cohesive

## Role in Domain-Driven Design

Domain models are central to Domain-Driven Design because they:

- **Represent business concepts** in a form that can be implemented in code
- **Encapsulate business logic** and rules
- **Provide a foundation** for all other design decisions
- **Enable communication** between business and technical teams
- **Support evolution** as understanding of the domain deepens

## How to Build Effective Domain Models

### 1. Identify Entities
**What it means**: Entities are objects that have a distinct identity that persists over time, even if their attributes change. They represent concepts that the business cares about as individuals.

**How to do it**:
- Look for concepts that have a unique identity
- Identify objects that the business tracks over time
- Find concepts that have a lifecycle
- Look for objects that can be referenced by other objects

**Example**: In an e-commerce system, "Customer," "Order," and "Product" are entities because they have unique identities that persist over time and can be referenced by other objects.

### 2. Define Value Objects
**What it means**: Value objects are objects that are defined by their attributes rather than their identity. They represent concepts that are equal if they have the same attributes.

**How to do it**:
- Look for concepts that are defined by their attributes
- Identify objects that don't have a unique identity
- Find concepts that are immutable
- Look for objects that can be compared by value

**Example**: "Money," "Address," and "Email" are value objects because they are defined by their attributes and don't have a unique identity.

### 3. Design Aggregates
**What it means**: Aggregates are clusters of related objects that are treated as a unit for data changes. They define consistency boundaries and ensure data integrity.

**How to do it**:
- Identify groups of related objects that must be consistent
- Define aggregate roots that control access to the aggregate
- Ensure aggregates are the right size (not too large or too small)
- Design aggregates to maintain consistency

**Example**: An "Order" aggregate might include OrderItems, ShippingAddress, and PaymentInformation, with Order as the aggregate root.

### 4. Implement Domain Services
**What it means**: Domain services contain business logic that doesn't naturally belong to any entity or value object. They represent operations that involve multiple domain objects.

**How to do it**:
- Identify business operations that don't belong to a single object
- Look for operations that involve multiple domain concepts
- Find business logic that is stateless
- Ensure services represent domain concepts, not technical concerns

**Example**: A "PricingService" might calculate prices based on customer type, product category, and current promotions.

### 5. Capture Business Rules
**What it means**: Business rules should be explicitly represented in the domain model, either as methods on entities/value objects or as domain services.

**How to do it**:
- Identify business rules and constraints
- Represent rules as methods or properties
- Ensure rules are enforced consistently
- Make rules explicit and visible

**Example**: A "Customer" entity might have a method `CanPlaceOrder()` that checks if the customer is in good standing and has a valid payment method.

## Examples of Domain Model Design

### E-commerce System Example

**Entities**
```csharp
public class Customer
{
    public CustomerId Id { get; private set; }
    public CustomerStatus Status { get; private set; }
    public PaymentMethod PrimaryPaymentMethod { get; private set; }
    
    public bool CanPlaceOrder()
    {
        return Status == CustomerStatus.Active && 
               PrimaryPaymentMethod != null && 
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
    public List<OrderItem> Items { get; private set; }
    
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
        TotalAmount = Items.Sum(item => item.TotalPrice);
    }
}
```

**Value Objects**
```csharp
public class Money
{
    public decimal Amount { get; private set; }
    public Currency Currency { get; private set; }
    
    public Money(decimal amount, Currency currency)
    {
        if (amount < 0)
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
        return Amount == other.Amount && Currency == other.Currency;
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
```

**Domain Services**
```csharp
public class PricingService
{
    public Money CalculatePrice(Product product, Customer customer, int quantity)
    {
        var basePrice = product.Price.Multiply(quantity);
        
        if (customer.IsPremium())
        {
            basePrice = basePrice.ApplyDiscount(0.1m); // 10% discount
        }
        
        if (quantity >= 10)
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
        return availableQuantity >= quantity;
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
```

### Banking System Example

**Entities**
```csharp
public class Account
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
        
        if (amount.Amount <= 0)
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
        
        if (amount.Amount <= 0)
        {
            throw new InvalidWithdrawalAmountException();
        }
        
        if (AvailableBalance.Amount < amount.Amount)
        {
            throw new InsufficientFundsException();
        }
        
        Balance = Balance.Subtract(amount);
        AvailableBalance = AvailableBalance.Subtract(amount);
    }
    
    public bool CanWithdraw(Money amount)
    {
        return Status == AccountStatus.Active && 
               AvailableBalance.Amount >= amount.Amount;
    }
}
```

## How This Concept Helps with System Design

1. **Business Alignment**: The system structure reflects business structure
2. **Centralized Logic**: Business rules are encapsulated in domain models
3. **Consistency**: Business rules are enforced consistently throughout the system
4. **Maintainability**: Changes to business rules are localized to domain models
5. **Testability**: Domain models can be tested independently

## How This Concept Helps with Development

1. **Clear Structure**: The system has a clear, understandable structure
2. **Easier Debugging**: Business logic is centralized and easier to trace
3. **Better Testing**: Domain models can be tested in isolation
4. **Faster Development**: Business rules are implemented once and reused
5. **Easier Maintenance**: Changes to business rules are localized

## Common Patterns and Anti-patterns

### Patterns

**Rich Domain Models**
- Models contain both data and behavior
- Business logic is encapsulated in domain objects
- Models represent business concepts accurately

**Aggregate Design**
- Groups of related objects are treated as units
- Consistency boundaries are well-defined
- Aggregate roots control access to aggregates

**Domain Services**
- Business logic that doesn't belong to entities
- Stateless operations on domain objects
- Represent domain concepts, not technical concerns

### Anti-patterns

**Anemic Domain Models**
- Models contain only data without behavior
- Business logic is scattered throughout the application
- Models don't represent business concepts

**God Objects**
- Single objects that try to do everything
- Violate single responsibility principle
- Become hard to understand and maintain

**Technical Models**
- Models reflect technical concerns rather than business concepts
- Business logic is implemented based on technical convenience
- System becomes disconnected from business reality

## Summary

Domain models are the heart of Domain-Driven Design, representing business concepts in a form that can be implemented in code. By building rich domain models that encapsulate business logic and rules, teams can:

- **Create systems** that truly reflect business reality
- **Centralize business logic** in a maintainable way
- **Build software** that is easier to understand and modify
- **Ensure consistency** in business rule implementation
- **Support evolution** as understanding of the domain deepens

The key to successful domain modeling is identifying entities, defining value objects, designing aggregates, implementing domain services, and capturing business rules explicitly. This creates a foundation for all other Domain-Driven Design practices.

## Exercise 1: Design Domain Models

### Objective
Design domain models for a specific business domain, focusing on entities, value objects, and business rules.

### Task
Choose a business domain and design domain models that represent the key business concepts.

1. **Identify Entities**: Find concepts that have unique identities
2. **Define Value Objects**: Identify concepts defined by their attributes
3. **Design Aggregates**: Group related objects into consistency boundaries
4. **Implement Business Rules**: Represent business logic in the models
5. **Design Domain Services**: Identify operations that don't belong to entities

### Deliverables
- Entity designs with identity and behavior
- Value object designs with immutability
- Aggregate designs with consistency boundaries
- Domain service designs for complex operations
- Business rule implementations

### Getting Started
1. Choose a business domain you understand well
2. Identify the key business concepts
3. Determine which concepts are entities vs. value objects
4. Design aggregates that maintain consistency
5. Implement business rules as methods or services

---

## Exercise 2: Implement Domain Models

### Objective
Implement the designed domain models in code, ensuring they capture business logic and rules.

### Task
Take the domain model designs from Exercise 1 and implement them in code.

1. **Implement Entities**: Create classes with identity and behavior
2. **Implement Value Objects**: Create immutable classes with value equality
3. **Implement Aggregates**: Ensure consistency boundaries are maintained
4. **Implement Domain Services**: Create stateless services for complex operations
5. **Add Business Rules**: Implement business logic as methods and properties

### Success Criteria
- Entities have clear identity and behavior
- Value objects are immutable and comparable by value
- Aggregates maintain consistency boundaries
- Domain services are stateless and focused
- Business rules are implemented and enforced

### Getting Started
1. Use your domain model designs from Exercise 1
2. Implement entities with identity and behavior
3. Create value objects that are immutable
4. Implement aggregates with consistency boundaries
5. Add domain services for complex operations

### Implementation Best Practices

#### Domain Model Design
1. **Rich Models**: Include both data and behavior in domain models
2. **Business Logic**: Encapsulate business rules in domain objects
3. **Consistency**: Ensure business rules are enforced consistently
4. **Immutability**: Use immutable value objects where appropriate

#### Code Organization
1. **Aggregate Boundaries**: Organize code around aggregate boundaries
2. **Domain Services**: Separate domain services from application services
3. **Business Rules**: Make business rules explicit and visible
4. **Testing**: Design models to be easily testable

### Learning Objectives
After completing both exercises, you should be able to:
- Design domain models that represent business concepts
- Implement entities, value objects, and aggregates
- Encapsulate business logic in domain models
- Design domain services for complex operations
- Build maintainable and testable domain models

**Next**: [Context Mapping](../4-Context-Mapping/README.md) builds upon domain models by defining how different bounded contexts interact and communicate.
