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

**Next**: [Ubiquitous Language](../2-Ubiquitous-Language/README.md) builds upon bounded contexts by developing shared language within each context boundary.
