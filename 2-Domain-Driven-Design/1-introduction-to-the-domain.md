# Introduction to the Domain

## 📚 Code Samples

This document contains comprehensive code examples in multiple programming languages. For easier navigation and focused learning, all code samples have been organized into individual files:

- **[📁 All Code Samples](./code-samples/)** - Complete collection organized by language
- **[🔷 C# Samples](./code-samples/csharp/)** - .NET with xUnit and Moq (13 examples)
- **[☕ Java Samples](./code-samples/java/)** - Java with JUnit 5 and Mockito (4 examples)
- **[🔷 TypeScript Samples](./code-samples/typescript/)** - TypeScript with strong typing (2 examples)
- **[🐍 Python Samples](./code-samples/python/)** - Python with dataclasses and type hints (2 examples)

Each code sample includes:
- **Section Reference**: Link back to the specific section in this document
- **Navigation**: Previous/Next links for easy movement
- **Key Concepts**: Detailed explanation of what the code demonstrates
- **Related Concepts**: Links to related samples and documentation

## Overview

The domain is the heart of Domain-Driven Design (DDD). It represents the business area that your software is designed to serve. Understanding the domain is crucial for building software that truly meets business needs and provides value to users.

This document introduces key concepts for expressing the domain in software, including model-driven design, domain isolation through layered architecture, domain entities, value objects, services, modules, and separation of concerns.

## What is a Domain?

A **domain** is the sphere of knowledge, influence, or activity that your software addresses. It encompasses:
- **Business concepts** and terminology
- **Business rules** and constraints  
- **Business processes** and workflows
- **Business relationships** and dependencies
- **Business goals** and objectives

In Domain-Driven Design, the domain is not just the data or the user interface—it's the complete understanding of the business problem space that your software is trying to solve.

### Domain vs. Technical Concerns

It's important to distinguish between domain concerns and technical concerns:

**Domain Concerns** (What the business cares about):
- Customer registration and management
- Order processing and fulfillment
- Inventory tracking and management
- Payment processing and billing
- Product catalog and pricing

**Technical Concerns** (How we implement the domain):
- Database design and optimization
- User interface frameworks
- Network protocols and APIs
- Caching strategies
- Security implementations

The goal of Domain-Driven Design is to keep domain concerns separate from technical concerns, allowing the domain to drive the design while technical concerns support it.

## Model-Driven Design

Model-driven design is the practice of creating software that directly reflects the domain model. The domain model becomes the blueprint for the software structure, ensuring that the code represents business reality rather than technical convenience.

### Principles of Model-Driven Design

1. **The Model Drives the Code**: The domain model should be the primary influence on code structure
2. **Business Logic in the Model**: Business rules and logic should be encapsulated in domain objects
3. **Consistent Representation**: The same domain concepts should be represented consistently throughout the system
4. **Evolutionary Design**: The model evolves as understanding of the domain deepens

### Benefits of Model-Driven Design

- **Business Alignment**: Software structure matches business structure
- **Maintainability**: Changes to business rules are localized to domain objects
- **Understandability**: Code is easier to understand for both developers and business stakeholders
- **Testability**: Business logic can be tested independently of technical concerns

## Domain Isolation and Layered Architecture

Domain isolation is achieved through layered architecture, which separates different concerns into distinct layers. This separation ensures that domain logic remains pure and independent of technical implementation details.

### Traditional Layered Architecture

```
┌─────────────────────────────────────┐
│           Presentation Layer        │  ← User Interface, Controllers, Views
├─────────────────────────────────────┤
│           Application Layer         │  ← Use Cases, Application Services
├─────────────────────────────────────┤
│             Domain Layer            │  ← Business Logic, Domain Models
├─────────────────────────────────────┤
│          Infrastructure Layer       │  ← Database, External Services, Frameworks
└─────────────────────────────────────┘
```

### Layer Responsibilities

#### Presentation Layer
- **Purpose**: Handles user interaction and presentation
- **Responsibilities**: 
  - User interface components
  - Input validation and formatting
  - Response formatting
  - User experience concerns
- **Dependencies**: Can depend on Application Layer

#### Application Layer
- **Purpose**: Orchestrates domain operations and coordinates between layers
- **Responsibilities**:
  - Use case implementation
  - Transaction management
  - Security and authorization
  - Integration with external systems
- **Dependencies**: Can depend on Domain Layer and Infrastructure Layer

#### Domain Layer
- **Purpose**: Contains the core business logic and domain models
- **Responsibilities**:
  - Business rules and constraints
  - Domain entities and value objects
  - Domain services
  - Business process modeling
- **Dependencies**: Should not depend on other layers (pure domain)

#### Infrastructure Layer
- **Purpose**: Provides technical capabilities and external integrations
- **Responsibilities**:
  - Database access and persistence
  - External service integration
  - Framework-specific implementations
  - Technical utilities and helpers
- **Dependencies**: Can depend on Domain Layer (through interfaces)

### Benefits of Layered Architecture

1. **Separation of Concerns**: Each layer has a single, well-defined responsibility
2. **Domain Isolation**: Domain logic is protected from technical changes
3. **Testability**: Each layer can be tested independently
4. **Maintainability**: Changes in one layer don't necessarily affect others
5. **Flexibility**: Technical implementations can be changed without affecting domain logic

## Domain Entities

Domain entities are objects that have a distinct identity that persists over time. They represent concepts that the business cares about as individuals, even if their attributes change.

### Characteristics of Entities

1. **Unique Identity**: Each entity has a unique identifier that distinguishes it from other entities
2. **Lifecycle**: Entities have a lifecycle (creation, modification, deletion)
3. **Mutable State**: Entities can change their state over time
4. **Business Meaning**: Entities represent important business concepts

### Entity Design Principles

#### Identity Management

**Code Samples**: [C#](./code-samples/csharp/01-customer-entity.cs) | [Java](./code-samples/java/01-customer-entity.java) | [TypeScript](./code-samples/typescript/01-customer-entity.ts) | [Python](./code-samples/python/01-customer-entity.py)

#### Business Logic Encapsulation

**Code Samples**: [C#](./code-samples/csharp/02-order-entity.cs)

Entities should contain business logic related to their state and behavior.

## Value Objects

Value objects are objects that are defined by their attributes rather than their identity. They represent concepts that are equal if they have the same attributes, and they are typically immutable.

### Characteristics of Value Objects

1. **No Identity**: Value objects don't have a unique identifier
2. **Immutable**: Once created, value objects cannot be changed
3. **Value Equality**: Two value objects are equal if they have the same attributes
4. **Self-Validating**: Value objects validate their own state

### Value Object Design Principles

#### Immutability

**Code Samples**: [C#](./code-samples/csharp/03-money-value-object.cs) | [Java](./code-samples/java/02-money-value-object.java) | [TypeScript](./code-samples/typescript/02-money-value-object.ts) | [Python](./code-samples/python/02-money-value-object.py)

#### Self-Validation

**Code Samples**: [C#](./code-samples/csharp/04-email-address-value-object.cs)

## Domain Services

Domain services contain business logic that doesn't naturally belong to any entity or value object. They represent operations that involve multiple domain objects or complex business rules.

### When to Use Domain Services

1. **Cross-Entity Operations**: Operations that involve multiple entities
2. **Complex Business Rules**: Rules that are too complex for a single entity
3. **Stateless Operations**: Operations that don't maintain state
4. **Domain-Specific Calculations**: Complex calculations that are part of the domain

### Domain Service Design Principles

**Code Samples**: [C#](./code-samples/csharp/05-pricing-service.cs) | [Java](./code-samples/java/03-inventory-service.java)

## Modules and Separation of Concerns

Modules provide a way to organize related domain concepts together. They help manage complexity by grouping related functionality and providing clear boundaries within the domain layer.

### Module Design Principles

1. **High Cohesion**: Modules should contain related concepts
2. **Low Coupling**: Modules should have minimal dependencies on each other
3. **Clear Interfaces**: Module boundaries should be well-defined
4. **Domain-Driven**: Modules should reflect domain concepts, not technical concerns

### Example Module Organization

```
Domain/
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
```

### Module Implementation Example

**Code Samples**: [C#](./code-samples/csharp/06-customer-module.cs)

## Domain-Driven Design and Unit Testing

Domain-Driven Design significantly improves the ability to write effective unit tests by creating a clear separation between business logic and technical concerns. This separation makes it easier to test business rules in isolation, leading to more reliable and maintainable test suites.

### How DDD Improves Unit Testing

#### 1. **Pure Domain Logic is Easily Testable**

**Code Samples**: [C#](./code-samples/csharp/07-order-tests.cs) | [Java](./code-samples/java/04-order-tests.java)

Domain objects contain pure business logic without external dependencies, making them ideal for unit testing.

#### 2. **Value Objects Enable Comprehensive Testing**

**Code Samples**: [C#](./code-samples/csharp/08-money-tests.cs)

Value objects are immutable and self-validating, making them perfect for thorough testing.

#### 3. **Domain Services Enable Focused Testing**

**Code Samples**: [C#](./code-samples/csharp/09-pricing-service-tests.cs)

Domain services can be tested independently with mocked dependencies.

#### 4. **Testable Business Rules**

**Code Samples**: [C#](./code-samples/csharp/07-order-tests.cs) (see business rule tests)

Business rules are encapsulated in domain objects, making them easy to test.

#### 5. **Isolated Testing with Dependency Injection**

**Code Samples**: [C#](./code-samples/csharp/10-customer-service-tests.cs)

Domain services can be tested with mocked dependencies.

### Benefits of DDD for Unit Testing

#### 1. **Fast Test Execution**
- Domain objects have no external dependencies
- Tests run quickly without database or network calls
- Enables rapid feedback during development

#### 2. **Reliable Tests**
- Pure domain logic is deterministic
- No flaky tests due to external dependencies
- Tests are consistent across different environments

#### 3. **Comprehensive Coverage**
- Business rules are encapsulated and easily testable
- Edge cases can be thoroughly tested
- Complex business scenarios can be modeled and tested

#### 4. **Maintainable Test Suite**
- Tests are focused on business logic
- Changes to technical implementation don't break domain tests
- Tests serve as living documentation of business rules

#### 5. **Clear Test Intent**
- Tests clearly express business requirements
- Domain language makes tests readable to business stakeholders
- Tests validate business rules, not technical implementation

### Testing Anti-Patterns to Avoid

**Code Samples**: [C#](./code-samples/csharp/11-testing-anti-patterns.cs)

### Best Practices for DDD Unit Testing

**Code Samples**: [C#](./code-samples/csharp/12-testing-best-practices.cs)

## Best Practices for Domain Modeling

**Code Samples**: [C#](./code-samples/csharp/13-domain-modeling-best-practices.cs)

### 1. Keep Domain Logic Pure

Domain objects should not depend on external frameworks or infrastructure concerns.

### 2. Use Rich Domain Models

Domain objects should contain both data and behavior.

### 3. Validate at Domain Boundaries

Domain objects should validate their state and enforce business rules.

### 4. Use Value Objects for Complex Types

Use value objects to represent complex concepts and ensure consistency.

## Summary

The domain is the heart of Domain-Driven Design, representing the business knowledge that drives software design. By understanding and properly modeling the domain through:

- **Model-driven design** that reflects business reality
- **Layered architecture** that isolates domain concerns
- **Rich entities** that encapsulate business logic
- **Immutable value objects** that ensure consistency
- **Domain services** that handle complex operations
- **Well-organized modules** that manage complexity

We can build software that truly serves business needs while maintaining technical excellence. The key is to keep the domain pure, focused, and free from technical concerns, allowing business logic to drive the design while technical implementation supports it.

This foundation enables teams to build maintainable, testable, and understandable software that evolves with business needs and provides real value to users.
