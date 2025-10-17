# Python Code Samples - Domain-Driven Design

This directory contains all Python code samples from the Domain-Driven Design course, organized for easy navigation and learning.

## 📚 Code Samples Overview

### **Domain Entities**
1. [Customer Entity](./01-customer-entity.md) - Basic entity with identity management

### **Value Objects**
2. [Money Value Object](./02-money-value-object.md) - Immutable monetary calculations

## 🎯 Learning Path

### **For Beginners**
Start with entities and value objects to understand basic DDD concepts:
1. Customer Entity → Money Value Object

### **For Intermediate Developers**
Focus on advanced Python features and patterns:
1. Study dataclasses and type hints
2. Explore Pythonic DDD patterns

### **For Advanced Developers**
Compare Python implementation with other languages:
1. Compare with C#, Java, and TypeScript implementations
2. Explore Python-specific DDD patterns and libraries

## 🛠️ Technologies Used

- **Language**: Python 3.8+
- **Features**: Dataclasses, type hints, Decimal for precision
- **Patterns**: Domain-Driven Design, Dataclass Pattern
- **Benefits**: Clean syntax, automatic method generation, precise calculations

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
3. **Python Best Practices**: Using Python-specific features effectively
4. **Type Safety**: Leveraging type hints for better code quality

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

## 📝 Python Benefits for DDD

- **Clean Syntax**: Concise and readable code
- **Dataclasses**: Reduced boilerplate with automatic method generation
- **Type Hints**: Better IDE support and documentation
- **Decimal Precision**: Accurate monetary calculations
- **Rich Standard Library**: Built-in validation and error handling
- **Duck Typing**: Flexible object-oriented programming

## 🔧 Python DDD Patterns

- **Frozen Dataclasses**: For immutable value objects
- **Regular Dataclasses**: For mutable entities
- **Type Hints**: For better code documentation and IDE support
- **Decimal**: For precise monetary calculations
- **ValueError**: For domain validation errors

---

**Navigation**: [← Back to Code Samples](../) | [← Back to Introduction](../../1-introduction-to-the-domain.md)
