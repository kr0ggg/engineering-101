# SOLID Principles: Backend Development Track

## Overview

This track focuses on applying SOLID principles to **backend/server-side development**. You'll learn how to write clean, maintainable code for APIs, services, and backend systems.

## Target Audience

- Backend developers
- API developers
- Server-side engineers
- Full-stack developers working on backend code

## Technologies Covered

This track includes examples and reference applications in:

- **C# (.NET)**: Full-featured implementation with comprehensive testing
- **Java**: Maven-based project with JUnit testing
- **TypeScript**: Node.js implementation with Jest testing
- **Python**: Modern Python with pytest and coverage reporting

## Reference Application

The backend reference application is an **e-commerce system** that connects to a PostgreSQL database. It demonstrates SOLID principles through a real-world backend application.

### Application Features

- Customer management
- Product catalog
- Shopping cart operations
- Order processing
- Invoice generation
- Database operations

### Architecture

The application centers around an `EcommerceManager` class that intentionally violates all SOLID principles. Your exercises will involve refactoring this code to follow SOLID principles while maintaining functionality.

**Location**: [`reference-application/`](./reference-application/README.md)

## The Five SOLID Principles

### 1. [Single Responsibility Principle](./1-Single-class-reponsibility-principle/README.md)
**Goal**: Each class should have only one reason to change.

**Backend Focus**:
- Separating data access from business logic
- Isolating service responsibilities
- Creating focused repository classes
- Extracting validation logic

**Exercise**: Refactor `EcommerceManager` to separate product management, customer management, cart operations, and order processing into focused classes.

### 2. [Open/Closed Principle](./2-Open-closed-principle/README.md)
**Goal**: Software entities should be open for extension but closed for modification.

**Backend Focus**:
- Using interfaces and abstract classes
- Strategy pattern for algorithms
- Template method pattern
- Plugin architecture

**Exercise**: Make the e-commerce system extensible for new payment methods, shipping providers, and discount strategies without modifying existing code.

### 3. [Liskov Substitution Principle](./3-Liskov-substitution-principle/README.md)
**Goal**: Derived classes must be substitutable for their base classes.

**Backend Focus**:
- Proper inheritance hierarchies
- Interface implementations
- Polymorphic behavior
- Contract compliance

**Exercise**: Ensure all repository implementations, service classes, and data access objects can be substituted without breaking functionality.

### 4. [Interface Segregation Principle](./4-Interface-segregation-principle/README.md)
**Goal**: Clients should not depend on interfaces they don't use.

**Backend Focus**:
- Focused service interfaces
- Minimal repository contracts
- Segregated data access interfaces
- Client-specific abstractions

**Exercise**: Break down fat interfaces into focused, client-specific interfaces for repositories, services, and data access.

### 5. [Dependency Inversion Principle](./5-Dependency-segregation-principle/README.md)
**Goal**: Depend on abstractions, not concretions.

**Backend Focus**:
- Dependency injection
- Service abstractions
- Repository pattern
- Inversion of Control (IoC)

**Exercise**: Refactor the application to depend on interfaces rather than concrete implementations, enabling easy testing and swapping of implementations.

## Prerequisites

Before starting this track, you should have:

- **Basic understanding of object-oriented programming**
- **Experience with at least one backend language** (C#, Java, Python, or TypeScript)
- **Familiarity with unit testing**
- **Understanding of database concepts**

## Setup Instructions

### 1. Choose Your Language

Select the language you're most comfortable with or that matches your project needs:
- C# (.NET)
- Java
- Python
- TypeScript (Node.js)

### 2. Set Up the Reference Application

Navigate to the reference application for your chosen language:

```bash
cd backend/reference-application/[YourLanguage]
```

Follow the language-specific README for setup instructions.

### 3. Start the Database

The reference application uses PostgreSQL. Start it with Docker:

```bash
cd backend/reference-application
docker-compose up -d postgres
```

### 4. Run Initial Tests

Verify everything is set up correctly:

```bash
# For C#
cd Dotnet && ./build-and-test.sh

# For Java
cd Java && ./build-and-test.sh

# For Python
cd Python && ./build-and-test.sh

# For TypeScript
cd TypeScript && ./build-and-test.sh
```

All tests should pass initially.

## Working Through the Exercises

### Development Workflow

1. **Create a Branch**: Start by creating a new branch for your work
   ```bash
   git checkout -b your-name/solid-principles-exercise
   ```

2. **Work on Your Branch**: Make all your changes on your personal branch

3. **Commit Frequently**: Check in your work often with meaningful commit messages

4. **Run Tests Regularly**: Execute unit tests frequently to ensure your changes don't break existing functionality

5. **Refactor Incrementally**: Apply one principle at a time, testing after each change

### Exercise Structure

Each principle has:
- **Theory Section**: Understanding the principle
- **Violation Examples**: Real code that violates the principle
- **Refactored Examples**: SOLID-compliant code
- **Hands-on Exercise**: Refactor the reference application
- **Success Criteria**: How to know you've succeeded

## Learning Path

Work through the principles in order:

1. **Single Responsibility Principle** → Start here
2. **Open/Closed Principle** → Builds on SRP
3. **Liskov Substitution Principle** → Builds on OCP
4. **Interface Segregation Principle** → Builds on LSP
5. **Dependency Inversion Principle** → Builds on ISP

Each principle builds upon the previous ones, creating a comprehensive approach to clean code design.

## Success Criteria

After completing all exercises, you should be able to:

- ✅ Identify SOLID principle violations in backend code
- ✅ Refactor code to follow SOLID principles
- ✅ Design clean service and repository layers
- ✅ Write testable, maintainable backend code
- ✅ Apply SOLID principles to your own projects

## Additional Resources

- **Reference Application**: [`reference-application/README.md`](./reference-application/README.md)
- **Main Course Overview**: [`../0-README.md`](../0-README.md)
- **Frontend Track**: [`../frontend/README.md`](../frontend/README.md) (for comparison)

---

**Ready to begin?** Start with the [Single Responsibility Principle](./1-Single-class-reponsibility-principle/README.md)!

