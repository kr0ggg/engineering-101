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

**Next**: [Strategic Patterns](../5-Strategic-Patterns/README.md) builds upon context mapping by providing guidance on organizing domain-driven systems at a high level.
