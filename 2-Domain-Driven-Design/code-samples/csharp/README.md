# C# Code Samples - Domain-Driven Design

This directory contains all C# code samples from the Domain-Driven Design course, organized for easy navigation and learning.

## 📚 Code Samples Overview

### **Domain Entities**
1. [Customer Entity](./01-customer-entity.cs) - Basic entity with identity management
2. [Order Entity](./02-order-entity.cs) - Rich domain model with business logic

### **Value Objects**
3. [Money Value Object](./03-money-value-object.cs) - Immutable monetary calculations
4. [EmailAddress Value Object](./04-email-address-value-object.cs) - Self-validating email

### **Domain Services**
5. [Pricing Service](./05-pricing-service.cs) - Complex business calculations
6. [Customer Module](./06-customer-module.cs) - Organized domain module

### **Unit Testing Examples**
7. [Order Tests](./07-order-tests.cs) - Testing domain entities (xUnit)
8. [Money Tests](./08-money-tests.cs) - Testing value objects (xUnit)
9. [Pricing Service Tests](./09-pricing-service-tests.cs) - Testing domain services (xUnit)
10. [Customer Service Tests](./10-customer-service-tests.cs) - Testing with mocks (xUnit + Moq)

### **Testing Best Practices**
11. [Testing Anti-Patterns](./11-testing-anti-patterns.cs) - What to avoid
12. [Testing Best Practices](./12-testing-best-practices.cs) - Good testing patterns

### **Domain Modeling**
13. [Domain Modeling Best Practices](./13-domain-modeling-best-practices.cs) - Design principles

## 🎯 Learning Path

### **For Beginners**
Start with entities and value objects to understand basic DDD concepts:
1. Customer Entity → Order Entity → Money Value Object → EmailAddress Value Object

### **For Intermediate Developers**
Focus on services and testing:
1. Pricing Service → Customer Module → Order Tests → Money Tests

### **For Advanced Developers**
Dive into testing patterns and best practices:
1. Customer Service Tests → Testing Anti-Patterns → Testing Best Practices → Domain Modeling Best Practices

## 🛠️ Technologies Used

- **Framework**: .NET (C#)
- **Testing**: xUnit
- **Mocking**: Moq
- **Patterns**: Domain-Driven Design, Repository Pattern, Dependency Injection

## 📖 Related Documentation

- [Main Introduction](../introduction-to-the-domain.md) - Complete DDD concepts
- [Java Samples](../java/) - Same concepts in Java
- [TypeScript Samples](../typescript/) - Same concepts in TypeScript
- [Python Samples](../python/) - Same concepts in Python

## 🔗 Navigation

Each code sample includes:
- **Section Reference**: Link to the specific section in the main documentation
- **Previous/Next Navigation**: Easy movement between samples
- **Key Concepts**: Explanation of what the code demonstrates
- **Related Concepts**: Links to related samples and documentation

## 💡 Key Learning Objectives

By studying these samples, you'll learn:

1. **Domain Entities**: How to model business concepts with identity
2. **Value Objects**: Creating immutable, self-validating objects
3. **Domain Services**: Handling complex business operations
4. **Module Organization**: Structuring domain code effectively
5. **Unit Testing**: Testing domain logic with xUnit and Moq
6. **Best Practices**: Avoiding common pitfalls and following good patterns

## 🚀 Getting Started

1. **Read the Main Introduction**: Start with [introduction-to-the-domain.md](../introduction-to-the-domain.md)
2. **Choose Your Path**: Follow the learning path that matches your experience level
3. **Study the Code**: Each sample includes detailed explanations and context
4. **Practice**: Try implementing similar patterns in your own projects
5. **Explore Other Languages**: Compare implementations across different languages

---

**Navigation**: [← Back to Code Samples](../) | [← Back to Introduction](../introduction-to-the-domain.md)
