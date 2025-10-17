# Java Code Samples - Domain-Driven Design

This directory contains all Java code samples from the Domain-Driven Design course, organized for easy navigation and learning.

## 📚 Code Samples Overview

### **Domain Entities**
1. [Customer Entity](./01-customer-entity.java) - Basic entity with identity management

### **Value Objects**
2. [Money Value Object](./02-money-value-object.java) - Immutable monetary calculations

### **Domain Services**
3. [Inventory Service](./03-inventory-service.java) - Inventory management operations

### **Unit Testing Examples**
4. [Order Tests](./04-order-tests.java) - Testing domain entities (JUnit 5)

## 🎯 Learning Path

### **For Beginners**
Start with entities and value objects to understand basic DDD concepts:
1. Customer Entity → Money Value Object → Inventory Service

### **For Intermediate Developers**
Focus on services and testing:
1. Inventory Service → Order Tests

### **For Advanced Developers**
Explore testing patterns and best practices:
1. Order Tests → Compare with other language implementations

## 🛠️ Technologies Used

- **Language**: Java
- **Testing**: JUnit 5
- **Mocking**: Mockito
- **Patterns**: Domain-Driven Design, Repository Pattern
- **Features**: BigDecimal for monetary calculations, Optional for null safety

## 📖 Related Documentation

- [Main Introduction](../introduction-to-the-domain.md) - Complete DDD concepts
- [C# Samples](../csharp/) - Same concepts in C#
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

1. **Domain Entities**: How to model business concepts with identity in Java
2. **Value Objects**: Creating immutable, self-validating objects with BigDecimal
3. **Domain Services**: Handling complex business operations
4. **Unit Testing**: Testing domain logic with JUnit 5 and Mockito
5. **Java Best Practices**: Using Java-specific features effectively

## 🚀 Getting Started

1. **Read the Main Introduction**: Start with [introduction-to-the-domain.md](../introduction-to-the-domain.md)
2. **Choose Your Path**: Follow the learning path that matches your experience level
3. **Study the Code**: Each sample includes detailed explanations and context
4. **Practice**: Try implementing similar patterns in your own Java projects
5. **Explore Other Languages**: Compare implementations across different languages

## ☕ Java-Specific Features Demonstrated

- **BigDecimal**: Precise decimal arithmetic for monetary calculations
- **Objects.requireNonNull()**: Built-in null validation
- **Final Fields**: Immutable instance variables
- **JUnit 5**: Modern testing framework with lambda support
- **Mockito**: Powerful mocking framework
- **Exception Handling**: Proper use of Java exceptions

---

**Navigation**: [← Back to Code Samples](../) | [← Back to Introduction](../introduction-to-the-domain.md)
