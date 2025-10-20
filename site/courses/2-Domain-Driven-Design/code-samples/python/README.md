# Python Code Samples - Domain-Driven Design

This directory contains all Python code samples from the Domain-Driven Design course, organized for easy navigation and learning.

## 📚 Code Samples Overview

### **Domain Entities**
1. [Customer Entity](./01-customer-entity.md) - Basic entity with identity management
2. [Order Entity](./03-order-entity.md) - Order entity with business logic encapsulation

### **Value Objects**
3. [Money Value Object](./02-money-value-object.md) - Immutable monetary calculations
4. [EmailAddress Value Object](./04-email-address-value-object.md) - Self-validating email address

### **Domain Services**
5. [Pricing Service](./05-pricing-service.md) - Domain service with business logic

### **Modules and Organization**
6. [Customer Module](./06-customer-module.md) - Module organization and separation of concerns

### **Unit Testing Examples**
7. [Order Tests](./07-order-tests.md) - Order tests with pytest
8. [Money Tests](./08-money-tests.md) - Money value object tests
9. [Pricing Service Tests](./09-pricing-service-tests.md) - Domain service tests
10. [Customer Service Tests](./10-customer-service-tests.md) - Service tests with mocked dependencies

### **Testing Best Practices**
11. [Testing Anti-Patterns](./11-testing-anti-patterns.md) - Testing anti-patterns to avoid
12. [Testing Best Practices](./12-testing-best-practices.md) - Testing best practices

### **Domain Modeling**
13. [Domain Modeling Best Practices](./13-domain-modeling-best-practices.md) - Domain modeling best practices

## 🎯 Learning Path

### **For Beginners**
Start with entities and value objects to understand basic DDD concepts:
1. Customer Entity → Money Value Object → EmailAddress Value Object

### **For Intermediate Developers**
Focus on advanced Python features and patterns:
1. Study Order Entity → Pricing Service → Customer Module
2. Explore unit testing with pytest → Testing Best Practices

### **For Advanced Developers**
Compare Python implementation with other languages:
1. Compare with C#, Java, and TypeScript implementations
2. Explore Domain Modeling Best Practices
3. Study Testing Anti-Patterns to avoid common mistakes

## 🛠️ Technologies Used

- **Language**: Python 3.8+
- **Testing**: pytest testing framework
- **Features**: Dataclasses, type hints, Decimal for precision
- **Patterns**: Domain-Driven Design, Dataclass Pattern, Dependency Injection
- **Benefits**: Clean syntax, automatic method generation, precise calculations, Rich testing ecosystem

## 📖 Related Documentation

- [Main Introduction](../../1-introduction-to-the-domain.md) - Complete DDD concepts
- [C# Samples](../csharp/) - Same concepts in C#
- [Java Samples](../java/) - Same concepts in Java
- [TypeScript Samples](../typescript/) - Same concepts in TypeScript

## 🔗 Navigation

Each code sample includes:
- **Section Reference**: Link to the specific section in the main documentation
- **Previous/Next Navigation**: Easy movement between samples
- **Key Concepts**: Explanation of what the code demonstrates
- **Related Concepts**: Links to related samples and documentation

## 💡 Key Learning Objectives

By studying these samples, you'll learn:

1. **Domain Entities**: How to model business concepts with identity in Python
2. **Value Objects**: Creating immutable, self-validating objects with dataclasses
3. **Domain Services**: Implementing business logic in stateless services
4. **Module Organization**: Structuring Python projects for maintainability
5. **Unit Testing**: Testing domain logic with pytest framework
6. **Testing Best Practices**: Writing effective tests for domain models
7. **Python Best Practices**: Using Python-specific features effectively
8. **Type Safety**: Leveraging type hints for better code quality

## 🚀 Getting Started

1. **Read the Main Introduction**: Start with [1-introduction-to-the-domain.md](../../1-introduction-to-the-domain.md)
2. **Choose Your Path**: Follow the learning path that matches your experience level
3. **Study the Code**: Each sample includes detailed explanations and context
4. **Practice**: Try implementing similar patterns in your own Python projects
5. **Explore Other Languages**: Compare implementations across different languages

## 🐍 Python-Specific Features Demonstrated

- **Dataclasses**: `@dataclass` decorator for clean class definition
- **Frozen Dataclasses**: Immutable objects with `@dataclass(frozen=True)`
- **Type Hints**: Explicit typing with `typing` module
- **Decimal**: Precise decimal arithmetic for monetary calculations
- **Post-Init Validation**: `__post_init__` for validation after object creation
- **Class Methods**: Factory methods using `@classmethod`
- **pytest Testing**: Unit testing with fixtures and parametrization
- **unittest.mock**: Built-in mocking capabilities
- **Abstract Base Classes**: Clear interfaces for dependencies
- **Enum Types**: Type-safe status and state management

## 📝 Python Benefits for DDD

- **Clean Syntax**: Concise and readable code
- **Dataclasses**: Reduced boilerplate with automatic method generation
- **Type Hints**: Better IDE support and documentation
- **Decimal Precision**: Accurate monetary calculations
- **Rich Standard Library**: Built-in validation and error handling
- **Duck Typing**: Flexible object-oriented programming
- **Testing**: Rich testing ecosystem with pytest
- **Mocking**: Easy dependency mocking for unit tests
- **Error Prevention**: Catch domain logic errors at runtime

## 🔧 Python DDD Patterns

- **Frozen Dataclasses**: For immutable value objects
- **Regular Dataclasses**: For mutable entities
- **Type Hints**: For better code documentation and IDE support
- **Decimal**: For precise monetary calculations
- **ValueError**: For domain validation errors
- **pytest Fixtures**: For reusable test data and setup
- **unittest.mock**: For dependency mocking
- **Abstract Base Classes**: For clear interfaces
- **Factory Methods**: For complex object creation
- **Domain Events**: For significant business events

---

**Navigation**: [← Back to Code Samples](../) | [← Back to Introduction](../../1-introduction-to-the-domain.md)
