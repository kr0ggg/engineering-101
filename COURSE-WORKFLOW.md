# Course Material Workflow

## Getting Started

### 1. Fork the Repository

1. Navigate to the original repository on GitHub:
   ```
   https://github.com/kr0ggg/engineering-101.git
   ```

2. Click the "Fork" button in the top-right corner of the repository page
   - This creates a copy of the repository in your own GitHub account
   - You'll now have your own version at: `https://github.com/YOUR-USERNAME/engineering-101.git`

3. Clone your forked repository to your local machine:
   ```bash
   git clone https://github.com/YOUR-USERNAME/engineering-101.git
   cd engineering-101
   ```

### 2. Grant Access to Instructor

To allow the instructor (kr0ggg) to review your work and provide feedback:

1. Go to your forked repository on GitHub
2. Click on **Settings** (top menu bar)
3. Navigate to **Collaborators** (left sidebar)
4. Click **Add people**
5. Search for and add: `kr0ggg`
6. Select **Write** access level (allows the instructor to review and comment on your work)
7. Click **Add [username] to this repository**

**Note**: The instructor will be able to review your branches, provide feedback, and help you throughout the course.

---

## Course Structure

This course is divided into two main sections:

1. **SOLID Principles** - Foundation of clean code design
2. **Domain-Driven Design** - Strategic design patterns for complex domains

Each section contains multiple exercises that build upon each other. You'll work through each exercise on a dedicated branch, allowing you to track your progress and easily reference previous work.

---

## SOLID Principles Course

### Overview

The SOLID principles are five design principles that make software designs more understandable, flexible, and maintainable. Each exercise builds on the previous one, allowing you to progressively improve your code design skills.

### Exercise Structure

You'll work through 5 exercises, each focusing on one SOLID principle:

1. **Single Responsibility Principle (SRP)** - Each class should have one reason to change
2. **Open/Closed Principle (OCP)** - Open for extension, closed for modification
3. **Liskov Substitution Principle (LSP)** - Derived classes must be substitutable for their base classes
4. **Interface Segregation Principle (ISP)** - Clients should not depend on interfaces they don't use
5. **Dependency Inversion Principle (DIP)** - Depend on abstractions, not concretions

### Setting Up the Reference Application

Before starting the exercises, you need to set up and run the reference application. This e-commerce application intentionally violates all SOLID principles, providing you with real code to refactor.

#### Prerequisites

**Required Software:**
- **Docker** - For PostgreSQL database (required for all languages)
  - Download: https://docs.docker.com/get-docker/
  - Ensure Docker Desktop is running before starting

**Language-Specific Requirements** (choose one):

- **C# (.NET)**:
  - .NET SDK 8.0 or later
  - Download: https://dotnet.microsoft.com/download

- **Java**:
  - JDK 11 or later
  - Maven 3.6 or later
  - Download JDK: https://adoptium.net/
  - Download Maven: https://maven.apache.org/install.html

- **Python**:
  - Python 3.8 or later
  - Download: https://www.python.org/downloads/

- **TypeScript**:
  - Node.js 16+ and npm
  - Download: https://nodejs.org/

#### Initial Setup Steps

1. **Start the PostgreSQL Database**:
   ```bash
   cd MarkDown/1-SOLID-Principles/reference-application
   docker-compose up -d postgres
   ```
   
   This will:
   - Start PostgreSQL on port 5432
   - Create the `bounteous_ecom` database
   - Load initial schema and sample data
   - Start Adminer web interface on port 8080 (optional, for database browsing)

2. **Verify Database is Running**:
   ```bash
   docker ps
   ```
   
   You should see `ecom-postgres` container running.

3. **Choose Your Language**:
   Select the language you're most comfortable with or that matches your project needs. You'll work in this language throughout all SOLID exercises.

4. **Run Initial Build and Tests**:
   
   **For C# (.NET)**:
   ```bash
   cd MarkDown/1-SOLID-Principles/reference-application/Dotnet
   ./build-and-test.sh
   ```
   
   **For Java**:
   ```bash
   cd MarkDown/1-SOLID-Principles/reference-application/Java
   ./build-and-test.sh
   ```
   
   **For Python**:
   ```bash
   cd MarkDown/1-SOLID-Principles/reference-application/Python
   ./build-and-test.sh
   ```
   
   **For TypeScript**:
   ```bash
   cd MarkDown/1-SOLID-Principles/reference-application/TypeScript
   ./build-and-test.sh
   ```

5. **Verify Tests Pass**:
   - All unit tests should pass initially
   - The application connects to the database successfully
   - You see test output confirming everything works

#### Understanding the Reference Application

The reference application is an e-commerce system that:
- Manages customers, products, orders, and invoices
- Connects to a PostgreSQL database
- Has a single `EcommerceManager` class that violates all SOLID principles
- Includes comprehensive unit tests that verify the current behavior

**Key Points:**
- The code is intentionally poorly designed to give you practice refactoring
- All existing tests must continue to pass after your refactoring
- You may need to refactor tests as you apply SOLID principles
- You should create additional tests as you break down responsibilities

#### Database Access (Optional)

If you want to browse the database:
- Open http://localhost:8080 in your browser
- Server: `postgres`
- Username: `postgres`
- Password: `postgres123`
- Database: `bounteous_ecom`

#### Stopping the Database

When you're done working:
```bash
cd MarkDown/1-SOLID-Principles/reference-application
docker-compose down
```

### Testing Requirements

**Critical**: After each exercise, all unit tests must pass. This ensures your refactoring maintains existing functionality.

#### Test Strategy

1. **Run Tests Frequently**:
   - Run tests after each significant refactoring step
   - Don't wait until the end of an exercise
   - Catch issues early when they're easier to fix

2. **Tests May Need Refactoring**:
   - As you break down classes and apply SOLID principles, tests may need updates
   - Test structure should reflect your new class organization
   - Update test names and organization to match refactored code

3. **Create New Tests**:
   - As you extract new classes and responsibilities, create tests for them
   - Test new interfaces and abstractions you create
   - Ensure new code has adequate test coverage

4. **Test Behavior, Not Implementation**:
   - Focus on testing business behavior, not internal implementation
   - Tests should verify the `EcommerceManager` interface still works correctly
   - Avoid tests that are too tightly coupled to implementation details

#### Running Tests

**During Development** (run frequently):
```bash
# C#
cd MarkDown/1-SOLID-Principles/reference-application/Dotnet
dotnet test

# Java
cd MarkDown/1-SOLID-Principles/reference-application/Java
mvn test

# Python
cd MarkDown/1-SOLID-Principles/reference-application/Python
source venv/bin/activate  # if not already activated
pytest tests/

# TypeScript
cd MarkDown/1-SOLID-Principles/reference-application/TypeScript
npm test
```

**Full Build and Test** (before committing):
```bash
# Use the build-and-test.sh script for your language
./build-and-test.sh
```

### Working Through SOLID Principles

Follow the course material in `MarkDown/1-SOLID-Principles/` to work through each exercise:

1. **Single Responsibility Principle** - `1-Single-class-reponsibility-principle/`
2. **Open/Closed Principle** - `2-Open-closed-principle/`
3. **Liskov Substitution Principle** - `3-Liskov-substitution-principle/`
4. **Interface Segregation Principle** - `4-Interface-segregation-principle/`
5. **Dependency Inversion Principle** - `5-Dependency-segregation-principle/`

**Key Points**:
- Create a branch for each exercise (e.g., `exercise-1-single-responsibility`)
- Each exercise builds on the previous one
- Work in your chosen language throughout all exercises
- **All tests must pass** after each refactoring
- You may need to refactor tests and create new ones as you apply SOLID principles
- Since this is your fork, manage branches and merges as you see fit

---

## Domain-Driven Design Course

### Overview

Domain-Driven Design focuses on creating software that reflects a deep understanding of the business domain. This course covers strategic design patterns that help organize complex systems.

### Exercise Structure

You'll work through 5 exercises covering key DDD concepts:

1. **Bounded Contexts** - Defining clear boundaries for domain models
2. **Ubiquitous Language** - Building a shared vocabulary
3. **Domain Models** - Core concepts and relationships
4. **Context Mapping** - Relationships between contexts
5. **Strategic Patterns** - High-level domain organization

### Code Implementation Requirements

**Important**: For each DDD exercise, you should create actual code implementations based on the code samples provided. The code samples demonstrate domain entities, value objects, domain services, and testing patterns.

**Choose Your Language**:
- Select one language (C#, Java, TypeScript, or Python) for all DDD exercises
- Use the same language you chose for SOLID principles (recommended) or pick a different one
- All code samples are available in all four languages in `MarkDown/2-Domain-Driven-Design/code-samples/`

**What to Create**:
- Implement the classes shown in the code samples for your chosen language
- Create domain entities (Customer, Order, etc.)
- Create value objects (Money, EmailAddress, etc.)
- Create domain services (PricingService, InventoryService, etc.)
- Write unit tests following the testing patterns shown
- Organize code into modules as demonstrated

**Code Sample Locations**:
- C#: `MarkDown/2-Domain-Driven-Design/code-samples/csharp/`
- Java: `MarkDown/2-Domain-Driven-Design/code-samples/java/`
- TypeScript: `MarkDown/2-Domain-Driven-Design/code-samples/typescript/`
- Python: `MarkDown/2-Domain-Driven-Design/code-samples/python/`

### Working Through Domain-Driven Design

Follow the course material in `MarkDown/2-Domain-Driven-Design/` to work through each exercise:

1. **Bounded Contexts** - `1-Bounded-Contexts/`
2. **Ubiquitous Language** - `2-Ubiquitous-Language/`
3. **Domain Models** - `3-Domain-Models/`
4. **Context Mapping** - `4-Context-Mapping/`
5. **Strategic Patterns** - `5-Strategic-Patterns/`

**Key Points**:
- Create a branch for each exercise (e.g., `ddd-exercise-1-bounded-contexts`)
- Implement the classes shown in the code samples for your chosen language
- Create domain entities, value objects, and services based on the examples
- Write unit tests following the patterns in the code samples
- Since this is your fork, manage branches and merges as you see fit

---

## Learning Tips and Best Practices

### Effective Learning Strategies

1. **Read Before Coding**
   - Always read the material thoroughly before starting to code
   - Understand the "why" behind each principle or pattern
   - Review examples in multiple languages if available

2. **Incremental Progress**
   - Make small, frequent commits
   - Test after each significant change
   - Don't try to apply everything at once

3. **Compare and Reflect**
   - After each exercise, compare your solution with the original code
   - Reflect on what improved and why
   - Document your learnings in commit messages or notes

4. **Practice Across Languages**
   - If time permits, try implementing solutions in multiple languages
   - This helps you understand the principles independently of syntax

5. **Use Version Control Effectively**
   - Create branches for each exercise
   - Use meaningful commit messages
   - Tag important milestones

### When to Ask for Help

**Ask for assistance when you:**

1. **Are stuck for more than 30 minutes** on a specific problem
   - Don't spin your wheels - reach out early
   - Provide context: what you've tried, what error you're seeing, what you expected

2. **Don't understand a concept** after reading the material
   - Ask for clarification or additional examples
   - Request alternative explanations

3. **Tests are failing** and you can't figure out why
   - Share the error message and relevant code
   - Explain what you expected to happen

4. **Are unsure if your solution is correct**
   - Request a code review
   - Ask for feedback on your approach

5. **Want to explore alternative solutions**
   - Discuss different approaches
   - Get feedback on trade-offs

### How to Ask for Help

When requesting assistance:

1. **Be specific**: Describe exactly what you're trying to do
2. **Provide context**: Share relevant code snippets or error messages
3. **Show your work**: Explain what you've already tried
4. **Ask targeted questions**: Instead of "I don't understand," ask "Can you explain how X relates to Y?"

**Ways to get help:**
- Create a Pull Request and request review from `kr0ggg`
- Tag the instructor in comments on your commits
- Reach out directly through GitHub issues or discussions

### Code Quality Tips

1. **Keep It Simple**
   - Start with the simplest solution that works
   - Refactor to apply principles incrementally
   - Don't over-engineer

2. **Write Tests**
   - Ensure all existing tests pass
   - Add new tests when adding functionality
   - Use tests to verify your refactoring didn't break anything

3. **Follow Language Conventions**
   - Use proper naming conventions
   - Follow style guidelines for your chosen language
   - Keep code readable and well-commented

4. **Document Your Decisions**
   - Use commit messages to explain your changes
   - Add comments for non-obvious design decisions
   - Document why you chose a particular approach

### Progress Tracking

1. **Regular Check-ins**
   - Push your work regularly, even if incomplete
   - This allows the instructor to see your progress
   - Makes it easier to get help when needed

2. **Self-Assessment**
   - After each exercise, ask yourself:
     - Do I understand the principle/pattern?
     - Can I explain it to someone else?
     - Can I apply it to a new problem?

3. **Review Previous Work**
   - Periodically review earlier exercises
   - See how your understanding has evolved
   - Identify areas for improvement

---

## Troubleshooting

### Common Issues

**Problem**: Tests fail after refactoring
- **Solution**: Run tests frequently during refactoring, not just at the end
- **Solution**: Ensure you understand what each test is verifying
- **Solution**: Make incremental changes and test after each one

**Problem**: Git conflicts when merging
- **Solution**: Keep branches focused on single exercises
- **Solution**: Regularly pull from main to stay up to date
- **Solution**: Use `git rebase` to keep history clean (if comfortable)

**Problem**: Not sure if solution is correct
- **Solution**: Review the material again
- **Solution**: Compare with examples in the code-samples
- **Solution**: Ask for a code review

**Problem**: Overwhelmed by the amount of material
- **Solution**: Take breaks between exercises
- **Solution**: Focus on one principle/pattern at a time
- **Solution**: Don't rush - understanding is more important than speed

---

## Course Completion

Once you've completed all exercises:

1. **Final Review**
   - Review all your branches and commits
   - Reflect on your learning journey
   - Identify areas for further study

2. **Share Your Work**
   - Ensure all branches are pushed to GitHub
   - Create a summary of your learnings
   - Request final feedback from the instructor

3. **Next Steps**
   - Apply these principles to your own projects
   - Continue practicing with real-world scenarios
   - Explore advanced topics and patterns

---

## Additional Resources

- **Git Documentation**: https://git-scm.com/doc
- **GitHub Guides**: https://guides.github.com/
- **SOLID Principles**: See course materials in `MarkDown/1-SOLID-Principles/`
- **Domain-Driven Design**: See course materials in `MarkDown/2-Domain-Driven-Design/`

---

**Remember**: The goal is learning and understanding, not perfection. Take your time, ask questions, and don't hesitate to seek help when needed. Good luck with your learning journey!
