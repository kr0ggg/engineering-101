# Backend Testing Workshop

## Overview

This workshop teaches you how to write effective tests while applying SOLID principles to backend applications. The workshop supports multiple programming languages: **C#, Java, Python, and TypeScript**.

## Workshop Structure

### Core Concepts (Language-Agnostic)
- [Testing Philosophy](./00-TESTING-PHILOSOPHY.md)
- [Test-Driven Refactoring Process](./01-TDD-REFACTORING-PROCESS.md)
- [Test Doubles Explained](./02-TEST-DOUBLES.md)
- [Testing Best Practices](./03-BEST-PRACTICES.md)

### Language-Specific Guides

Choose your language and follow the complete testing guide:

#### C# (.NET)
- [C# Testing Setup](./csharp/00-SETUP.md)
- [C# Testing Patterns](./csharp/01-TESTING-PATTERNS.md)
- [C# Mocking with Moq](./csharp/02-MOCKING.md)
- [C# Integration Testing](./csharp/03-INTEGRATION-TESTING.md)

#### Java
- [Java Testing Setup](./java/00-SETUP.md)
- [Java Testing Patterns](./java/01-TESTING-PATTERNS.md)
- [Java Mocking with Mockito](./java/02-MOCKING.md)
- [Java Integration Testing](./java/03-INTEGRATION-TESTING.md)

#### Python
- [Python Testing Setup](./python/00-SETUP.md)
- [Python Testing Patterns](./python/01-TESTING-PATTERNS.md)
- [Python Mocking](./python/02-MOCKING.md)
- [Python Integration Testing](./python/03-INTEGRATION-TESTING.md)

#### TypeScript (Node.js)
- [TypeScript Testing Setup](./typescript/00-SETUP.md)
- [TypeScript Testing Patterns](./typescript/01-TESTING-PATTERNS.md)
- [TypeScript Mocking with Jest](./typescript/02-MOCKING.md)
- [TypeScript Integration Testing](./typescript/03-INTEGRATION-TESTING.md)

### SOLID Principle Testing Workshops

Each SOLID principle has a dedicated testing workshop:

1. [Single Responsibility Principle Testing](./srp/README.md)
2. [Open/Closed Principle Testing](./ocp/README.md)
3. [Liskov Substitution Principle Testing](./lsp/README.md)
4. [Interface Segregation Principle Testing](./isp/README.md)
5. [Dependency Inversion Principle Testing](./dip/README.md)

## Quick Start

### 1. Choose Your Language

Select the language you're working with for the SOLID exercises:
- C# (.NET)
- Java
- Python
- TypeScript (Node.js)

### 2. Complete Setup

Follow the setup guide for your chosen language to install testing tools and configure your environment.

### 3. Learn Core Concepts

Read through the language-agnostic core concepts to understand the testing philosophy and approach.

### 4. Follow Language-Specific Guide

Work through your language's testing patterns and examples.

### 5. Apply to SOLID Principles

Complete the testing workshops for each SOLID principle, using your chosen language.

## Testing Stack by Language

### C# (.NET)
- **xUnit** - Test framework
- **Moq** - Mocking library
- **FluentAssertions** - Assertion library
- **Testcontainers** - Integration testing

### Java
- **JUnit 5** - Test framework
- **Mockito** - Mocking library
- **AssertJ** - Fluent assertions
- **Testcontainers** - Integration testing

### Python
- **pytest** - Test framework
- **pytest-mock** - Mocking utilities
- **unittest.mock** - Built-in mocking
- **Testcontainers** - Integration testing

### TypeScript (Node.js)
- **Jest** - Test framework and mocking
- **ts-jest** - TypeScript support
- **supertest** - HTTP testing
- **Testcontainers** - Integration testing

## Learning Path

```
1. Read Testing Philosophy
   ↓
2. Understand TDD Refactoring Process
   ↓
3. Learn Test Doubles
   ↓
4. Complete Language Setup
   ↓
5. Study Language-Specific Patterns
   ↓
6. Apply to SRP Exercise
   ↓
7. Continue through OCP, LSP, ISP, DIP
   ↓
8. Use Assessment Checklist
```

## Key Principles

### Test Behavior, Not Implementation
Write tests that verify what the code does, not how it does it.

### Follow Arrange-Act-Assert
Structure every test consistently:
1. **Arrange** - Set up test data
2. **Act** - Execute the behavior
3. **Assert** - Verify the outcome

### Keep Tests Independent
Each test should run independently without relying on other tests.

### Write Descriptive Names
Test names should clearly describe what is being tested and the expected outcome.

### Test One Thing
Each test should verify one specific behavior or condition.

## Running Tests

### C# (.NET)
```bash
cd backend/reference-application/Dotnet
dotnet test
dotnet test --filter "FullyQualifiedName~CustomerService"
dotnet test /p:CollectCoverage=true
```

### Java
```bash
cd backend/reference-application/Java
mvn test
mvn test -Dtest=CustomerServiceTest
mvn test jacoco:report
```

### Python
```bash
cd backend/reference-application/Python
source venv/bin/activate
pytest
pytest tests/test_customer_service.py
pytest --cov=src --cov-report=html
```

### TypeScript (Node.js)
```bash
cd backend/reference-application/TypeScript
npm test
npm test -- CustomerService.test
npm test -- --coverage
```

## Resources

### Core Documentation
- [Testing Philosophy](./00-TESTING-PHILOSOPHY.md)
- [TDD Refactoring Process](./01-TDD-REFACTORING-PROCESS.md)
- [Test Doubles](./02-TEST-DOUBLES.md)
- [Best Practices](./03-BEST-PRACTICES.md)

### Language Guides
- [C# Guide](./csharp/README.md)
- [Java Guide](./java/README.md)
- [Python Guide](./python/README.md)
- [TypeScript Guide](./typescript/README.md)

### Assessment
- [Backend Assessment Checklist](../assessment/CHECKLIST.md)
- [Code Review Guidelines](../assessment/CODE-REVIEW-GUIDELINES.md)

### Reference
- [Backend Testing Guide](../TESTING-GUIDE.md)
- [Reference Application](../reference-application/README.md)

## Support

If you encounter issues:
1. Check the troubleshooting section in your language guide
2. Review the testing best practices
3. Consult the assessment checklist
4. Ask for help from instructor or peers

## Next Steps

1. **Choose your language** from the options above
2. **Complete the setup** for your chosen language
3. **Read core concepts** to understand the approach
4. **Start with SRP** testing workshop
5. **Progress through** all SOLID principles

---

**Ready to begin?** Choose your language and start with the setup guide!
