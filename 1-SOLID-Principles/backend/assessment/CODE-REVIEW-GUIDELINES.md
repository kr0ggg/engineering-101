# Backend Code Review Guidelines for SOLID Principles

## Overview

This guide provides standardized criteria for reviewing backend code submissions. Use this alongside the assessment checklist to ensure consistent, thorough code reviews.

## Review Process

### 1. Initial Review (5-10 minutes)

- [ ] Clone/pull the student's branch
- [ ] Run tests: `mvn test` / `gradle test` / `pytest` / `npm test`
- [ ] Check test coverage
- [ ] Review project structure
- [ ] Identify which SOLID principles are being addressed

### 2. Deep Review (20-30 minutes)

- [ ] Review code quality for each principle
- [ ] Check test quality and coverage
- [ ] Verify refactoring was done incrementally (git history)
- [ ] Review documentation and comments
- [ ] Check for code smells and anti-patterns

### 3. Feedback (10-15 minutes)

- [ ] Provide specific, actionable feedback
- [ ] Highlight what was done well
- [ ] Identify areas for improvement
- [ ] Suggest next steps

## Review Criteria by Principle

### Single Responsibility Principle (SRP)

#### What to Look For

**✅ Good Signs**:
- Classes have one clear responsibility
- Methods are focused and do one thing
- Easy to describe what a class does in one sentence
- Changes to one feature don't affect unrelated code
- Tests are focused and easy to write

**❌ Red Flags**:
- Classes with multiple responsibilities
- Methods that do multiple unrelated things
- "Manager" or "Handler" classes that do everything
- Difficult to test without mocking many dependencies
- Changes ripple across unrelated code

#### Example Comments

**Positive**:
```
✅ Excellent SRP implementation! The CustomerValidator class has a single, 
clear responsibility. The validation logic is well-separated from persistence 
and business logic. Tests are focused and easy to understand.
```

**Needs Improvement**:
```
⚠️ The OrderService class is handling too many responsibilities:
- Order validation
- Inventory management
- Payment processing
- Email notifications

Consider extracting these into separate classes:
- OrderValidator
- InventoryService
- PaymentService
- NotificationService

This will make the code easier to test and maintain.
```

### Open/Closed Principle (OCP)

#### What to Look For

**✅ Good Signs**:
- Uses interfaces/abstract classes for extensibility
- New features added without modifying existing code
- Strategy pattern or similar design patterns used
- Dependency injection for flexibility
- Configuration-driven behavior

**❌ Red Flags**:
- Long if/else or switch statements for type checking
- Modifying existing classes to add new features
- Hard-coded dependencies
- Tight coupling between classes
- No use of polymorphism where appropriate

#### Example Comments

**Positive**:
```
✅ Great use of the Strategy pattern for discount calculations! Adding new 
discount types (like SeasonalDiscount) doesn't require modifying existing 
code. The DiscountCalculator is properly closed for modification but open 
for extension.
```

**Needs Improvement**:
```
⚠️ The PaymentProcessor uses a large switch statement to handle different 
payment types:

switch (paymentType) {
  case "CREDIT_CARD": // ...
  case "PAYPAL": // ...
  case "BANK_TRANSFER": // ...
}

Consider using the Strategy pattern:
- Create IPaymentMethod interface
- Implement CreditCardPayment, PayPalPayment, BankTransferPayment
- Use dependency injection to select the appropriate implementation

This makes adding new payment methods much easier.
```

### Liskov Substitution Principle (LSP)

#### What to Look For

**✅ Good Signs**:
- Derived classes can replace base classes without breaking functionality
- Overridden methods maintain base class contracts
- No unexpected exceptions in derived classes
- Preconditions not strengthened in derived classes
- Postconditions not weakened in derived classes

**❌ Red Flags**:
- Derived classes throw exceptions not in base class
- Overridden methods change expected behavior
- Type checking before using derived classes
- Empty implementations that violate contracts
- Derived classes require special handling

#### Example Comments

**Positive**:
```
✅ Excellent LSP adherence! All repository implementations (CustomerRepository, 
OrderRepository, ProductRepository) can be used interchangeably through the 
IRepository<T> interface. Each maintains the same contracts and error handling 
behavior.
```

**Needs Improvement**:
```
⚠️ The ReadOnlyRepository violates LSP by throwing UnsupportedOperationException 
for save() and delete() methods:

class ReadOnlyRepository extends Repository {
  @Override
  public void save(Entity e) {
    throw new UnsupportedOperationException("Read-only repository");
  }
}

This breaks the contract of the base Repository class. Consider:
- Creating separate IReadRepository and IWriteRepository interfaces
- Or using composition instead of inheritance
```

### Interface Segregation Principle (ISP)

#### What to Look For

**✅ Good Signs**:
- Small, focused interfaces
- Clients only depend on methods they use
- No "fat" interfaces with many methods
- Role-based interfaces (IReader, IWriter, etc.)
- Easy to implement interfaces without unused methods

**❌ Red Flags**:
- Large interfaces with many methods
- Implementations with empty/stub methods
- Clients forced to depend on unused methods
- Single interface for multiple responsibilities
- Difficult to implement without violating SRP

#### Example Comments

**Positive**:
```
✅ Great interface segregation! Separating ICustomerReader and ICustomerWriter 
allows components to depend only on what they need. The CustomerDisplayService 
only needs ICustomerReader, making it easier to test and more focused.
```

**Needs Improvement**:
```
⚠️ The IRepository interface has too many methods (15+), forcing implementations 
to provide methods they don't need:

interface IRepository {
  void save(T entity);
  void delete(int id);
  T findById(int id);
  List<T> findAll();
  List<T> findByName(String name);
  // ... 10 more methods
}

Consider splitting into focused interfaces:
- IBasicRepository (save, delete, findById)
- IQueryRepository (findAll, findByName, etc.)
- ISearchRepository (search, filter, etc.)
```

### Dependency Inversion Principle (DIP)

#### What to Look For

**✅ Good Signs**:
- Depends on abstractions (interfaces/abstract classes)
- Uses dependency injection
- High-level modules don't depend on low-level modules
- Easy to swap implementations
- Testable with mocks

**❌ Red Flags**:
- Direct instantiation of concrete classes
- Depends on implementation details
- Hard-coded dependencies
- Difficult to test without real dependencies
- Tight coupling to specific implementations

#### Example Comments

**Positive**:
```
✅ Excellent DIP implementation! The OrderService depends on abstractions 
(IProductRepository, IPriceCalculator, IEmailService) rather than concrete 
implementations. This makes the code highly testable and flexible. Constructor 
injection is used consistently.
```

**Needs Improvement**:
```
⚠️ The CustomerService directly instantiates its dependencies:

class CustomerService {
  private final CustomerRepository repository = new CustomerRepository();
  private final EmailService emailService = new EmailService();
}

This violates DIP and makes testing difficult. Refactor to:

class CustomerService {
  private final ICustomerRepository repository;
  private final IEmailService emailService;
  
  public CustomerService(ICustomerRepository repository, IEmailService emailService) {
    this.repository = repository;
    this.emailService = emailService;
  }
}
```

## Test Quality Review

### What to Look For

**✅ Good Test Characteristics**:
- Tests are independent and can run in any order
- Clear Arrange-Act-Assert structure
- Descriptive test names
- Tests behavior, not implementation
- Good coverage of edge cases
- Fast execution (< 1 second per test)
- Uses appropriate test doubles (mocks, stubs, fakes)

**❌ Test Anti-Patterns**:
- Tests depend on execution order
- Testing private methods
- Testing implementation details
- Slow tests (> 5 seconds)
- Brittle tests that break on refactoring
- No assertions or meaningless assertions
- Duplicate test code

### Example Comments

**Positive**:
```
✅ Excellent test coverage! Tests are well-organized, independent, and follow 
AAA pattern. Good use of test doubles to isolate units. Edge cases are covered 
(null inputs, empty lists, boundary conditions). Test names clearly describe 
what is being tested.
```

**Needs Improvement**:
```
⚠️ Several test quality issues:

1. Tests are testing implementation details:
   expect(component.state.loading).toBe(true);
   
2. Tests depend on execution order (shared state)

3. Missing edge case tests:
   - What happens with null input?
   - What happens with empty list?
   - What happens when API fails?

4. Test names are unclear:
   test('test1', () => {})
   test('works', () => {})

Suggestions:
- Test behavior: expect(screen.getByText('Loading...')).toBeInTheDocument()
- Make tests independent with beforeEach setup
- Add edge case coverage
- Use descriptive names: 'should display error when API fails'
```

## Language-Specific Considerations

### C# (.NET)

**Look For**:
- Proper use of interfaces and dependency injection
- xUnit test organization with Theory/InlineData
- Moq for mocking
- Async/await patterns
- LINQ usage appropriately

**Common Issues**:
- Not using async/await consistently
- Improper disposal of resources
- Over-use of static classes
- Not using nullable reference types

### Java

**Look For**:
- Proper use of interfaces and abstract classes
- JUnit 5 features (@ParameterizedTest, @Nested)
- Mockito for mocking
- Stream API usage
- Proper exception handling

**Common Issues**:
- Not closing resources (use try-with-resources)
- Catching generic Exception
- Not using Optional appropriately
- Mutable collections in public APIs

### Python

**Look For**:
- Proper use of abstract base classes (ABC)
- pytest fixtures and parametrize
- Type hints for clarity
- Pythonic code (list comprehensions, context managers)
- pytest-mock for mocking

**Common Issues**:
- Missing type hints
- Not using context managers
- Mutable default arguments
- Not following PEP 8

### TypeScript

**Look For**:
- Strong typing (avoid `any`)
- Interface usage
- Jest test organization
- Proper async/await
- Type guards where needed

**Common Issues**:
- Overuse of `any` type
- Not using strict mode
- Missing error handling
- Not leveraging TypeScript features

## Grading Rubric

### Excellent (90-100%)

- All SOLID principles correctly applied
- Clean, maintainable code
- Comprehensive test coverage (>90%)
- Well-documented
- No code smells
- Proper error handling
- Good git history (incremental commits)

### Good (80-89%)

- Most SOLID principles correctly applied
- Generally clean code with minor issues
- Good test coverage (75-90%)
- Adequate documentation
- Few code smells
- Basic error handling
- Reasonable git history

### Satisfactory (70-79%)

- Some SOLID principles applied
- Code works but has quality issues
- Moderate test coverage (60-75%)
- Minimal documentation
- Several code smells
- Inconsistent error handling
- Poor git history

### Needs Improvement (<70%)

- SOLID principles not applied or misunderstood
- Code quality issues
- Low test coverage (<60%)
- No documentation
- Many code smells
- No error handling
- No meaningful git history

## Feedback Template

```markdown
# Code Review: [Student Name] - [Principle]

## Summary
[Brief overview of submission]

## Strengths
- [What was done well]
- [Positive aspects]
- [Good practices observed]

## Areas for Improvement

### Critical Issues
- [ ] [Issue 1 with specific example]
- [ ] [Issue 2 with specific example]

### Suggestions
- [ ] [Suggestion 1]
- [ ] [Suggestion 2]

## SOLID Principles Assessment

### Single Responsibility Principle: [Score/5]
[Comments]

### Open/Closed Principle: [Score/5]
[Comments]

### Liskov Substitution Principle: [Score/5]
[Comments]

### Interface Segregation Principle: [Score/5]
[Comments]

### Dependency Inversion Principle: [Score/5]
[Comments]

## Test Quality: [Score/5]
[Comments]

## Overall Grade: [Score/100]

## Next Steps
1. [Action item 1]
2. [Action item 2]
3. [Action item 3]

## Resources
- [Link to relevant documentation]
- [Link to example code]
```

## Common Review Scenarios

### Scenario 1: Good Code, Poor Tests

**Feedback**:
```
Your implementation of SOLID principles is excellent, but test coverage needs 
improvement. Current coverage: 45%. Target: 80%+.

Missing tests for:
- Edge cases (null, empty, boundary values)
- Error conditions
- Integration between components

Next steps:
1. Add tests for CustomerValidator edge cases
2. Add integration tests for OrderService
3. Ensure all public methods have tests
```

### Scenario 2: Over-Engineering

**Feedback**:
```
While your code demonstrates understanding of design patterns, it may be 
over-engineered for this problem. The AbstractFactoryBuilderStrategy adds 
complexity without clear benefit.

Consider:
- YAGNI (You Aren't Gonna Need It) principle
- Simpler solutions that still follow SOLID
- Balance between flexibility and simplicity

The goal is clean, maintainable code, not maximum pattern usage.
```

### Scenario 3: Misunderstood Principle

**Feedback**:
```
I see you've attempted to apply OCP, but there's a misunderstanding. You've 
made all methods final to "close" them for modification, but this prevents 
extension entirely.

OCP means:
- Open for extension (can add new behavior)
- Closed for modification (don't change existing code)

Example: Use interfaces/abstract classes to allow new implementations without 
modifying existing code.

Resources:
- [Link to OCP explanation]
- [Link to Strategy pattern example]
```

## Summary

**Effective Code Reviews**:
- Be specific and constructive
- Provide examples
- Highlight both strengths and weaknesses
- Give actionable feedback
- Link to resources
- Encourage learning

**Review Checklist**:
- [ ] All SOLID principles addressed
- [ ] Code quality is good
- [ ] Tests are comprehensive
- [ ] Documentation is adequate
- [ ] Git history shows incremental work
- [ ] No major code smells
- [ ] Error handling is appropriate
- [ ] Language-specific best practices followed

---

**Key Takeaway**: Code reviews are teaching opportunities. Be thorough, specific, and constructive to help students improve.
