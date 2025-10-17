# TypeScript Code Samples - Domain-Driven Design

This directory contains all TypeScript code samples from the Domain-Driven Design course, organized for easy navigation and learning.

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
7. [Order Tests](./07-order-tests.md) - Order tests with Jest
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
Focus on advanced TypeScript features and patterns:
1. Study Order Entity → Pricing Service → Customer Module
2. Explore unit testing with Jest → Testing Best Practices

### **For Advanced Developers**
Compare TypeScript implementation with other languages:
1. Compare with C#, Java, and Python implementations
2. Explore Domain Modeling Best Practices
3. Study Testing Anti-Patterns to avoid common mistakes

## 🛠️ Technologies Used

- **Language**: TypeScript
- **Testing**: Jest testing framework
- **Features**: Strong typing, access modifiers, readonly fields
- **Patterns**: Domain-Driven Design, Module Pattern, Dependency Injection
- **Benefits**: Compile-time type checking, IntelliSense support, Rich testing ecosystem

## 📖 Related Documentation

- [Main Introduction](../../1-introduction-to-the-domain.md) - Complete DDD concepts
- [C# Samples](../csharp/) - Same concepts in C#
- [Java Samples](../java/) - Same concepts in Java
- [Python Samples](../python/) - Same concepts in Python

## 🔗 Navigation

Each code sample includes:
- **Section Reference**: Link to the specific section in the main documentation
- **Previous/Next Navigation**: Easy movement between samples
- **Key Concepts**: Explanation of what the code demonstrates
- **Related Concepts**: Links to related samples and documentation

## 💡 Key Learning Objectives

By studying these samples, you'll learn:

1. **Domain Entities**: How to model business concepts with identity in TypeScript
2. **Value Objects**: Creating immutable, self-validating objects
3. **Domain Services**: Implementing business logic in stateless services
4. **Module Organization**: Structuring TypeScript projects for maintainability
5. **Unit Testing**: Testing domain logic with Jest framework
6. **Testing Best Practices**: Writing effective tests for domain models
7. **TypeScript Best Practices**: Using TypeScript-specific features effectively
8. **Type Safety**: Leveraging TypeScript's type system for domain modeling

## 🚀 Getting Started

1. **Read the Main Introduction**: Start with [1-introduction-to-the-domain.md](../../1-introduction-to-the-domain.md)
2. **Choose Your Path**: Follow the learning path that matches your experience level
3. **Study the Code**: Each sample includes detailed explanations and context
4. **Practice**: Try implementing similar patterns in your own TypeScript projects
5. **Explore Other Languages**: Compare implementations across different languages

## 🔧 TypeScript-Specific Features Demonstrated

- **Access Modifiers**: `private` and `readonly` keywords
- **Type Annotations**: Explicit typing for parameters and return values
- **Static Methods**: Factory methods for common operations
- **Module System**: Clean export/import patterns
- **Error Handling**: Custom error messages for validation
- **Type Safety**: Compile-time type checking benefits
- **Jest Testing**: Unit testing with mocking and assertions
- **Interface Segregation**: Clean contracts for dependencies
- **Generic Types**: Reusable patterns for value objects
- **Enum Types**: Type-safe status and state management

## 📝 TypeScript Benefits for DDD

- **Type Safety**: Prevents runtime errors with compile-time checking
- **IntelliSense**: Better IDE support with type information
- **Refactoring**: Safer refactoring with type system
- **Documentation**: Types serve as inline documentation
- **Maintainability**: Easier to maintain with strong typing
- **Testing**: Rich testing ecosystem with Jest
- **Mocking**: Easy dependency mocking for unit tests
- **Error Prevention**: Catch domain logic errors at compile time

---

**Navigation**: [← Back to Code Samples](../) | [← Back to Introduction](../../1-introduction-to-the-domain.md)
