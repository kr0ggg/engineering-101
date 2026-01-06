# SOLID Principles - Testing and Assessment Guide

## Overview

This guide provides an overview of the testing workshops and assessment tools available for the SOLID Principles course. Resources are organized by track (Backend/Frontend) with language-specific support.

## Quick Navigation

### Backend Track
- **Testing Workshop**: [`backend/testing-workshop/`](./backend/testing-workshop/README.md)
- **Assessment Tools**: [`backend/assessment/`](./backend/assessment/CHECKLIST.md)
- **Supported Languages**: C#, Java, Python, TypeScript

### Frontend Track
- **Testing Workshop**: [`frontend/testing-workshop/`](./frontend/testing-workshop/README.md)
- **Assessment Tools**: [`frontend/assessment/`](./frontend/assessment/CHECKLIST.md)
- **Technology**: React & TypeScript

---

## Backend Testing Workshop

### Location
`backend/testing-workshop/`

### Structure

#### Core Concepts (Language-Agnostic)
- [Testing Philosophy](./backend/testing-workshop/00-TESTING-PHILOSOPHY.md)
- [TDD Refactoring Process](./backend/testing-workshop/01-TDD-REFACTORING-PROCESS.md)
- [Test Doubles Explained](./backend/testing-workshop/02-TEST-DOUBLES.md)
- [Best Practices](./backend/testing-workshop/03-BEST-PRACTICES.md)

#### Language-Specific Guides

**C# (.NET)**
- Setup and Configuration
- Testing Patterns with xUnit
- Mocking with Moq
- Integration Testing with Testcontainers

**Java**
- Setup and Configuration
- Testing Patterns with JUnit 5
- Mocking with Mockito
- Integration Testing with Testcontainers

**Python**
- Setup and Configuration
- Testing Patterns with pytest
- Mocking with pytest-mock
- Integration Testing with Testcontainers

**TypeScript (Node.js)**
- Setup and Configuration
- Testing Patterns with Jest
- Mocking with Jest
- Integration Testing with Testcontainers

#### SOLID Principle Workshops
Each principle has a dedicated testing workshop:
1. Single Responsibility Principle (SRP)
2. Open/Closed Principle (OCP)
3. Liskov Substitution Principle (LSP)
4. Interface Segregation Principle (ISP)
5. Dependency Inversion Principle (DIP)

### Getting Started (Backend)

1. **Choose Your Language**: C#, Java, Python, or TypeScript
2. **Read Core Concepts**: Understand testing philosophy and TDD
3. **Complete Language Setup**: Follow your language's setup guide
4. **Start with SRP**: Begin with the SRP testing workshop
5. **Progress Through Principles**: Complete all 5 principles

---

## Frontend Testing Workshop

### Location
`frontend/testing-workshop/`

### Structure

#### Core Concepts
- [Testing Philosophy](./frontend/testing-workshop/00-TESTING-PHILOSOPHY.md)
- [TDD Refactoring Process](./frontend/testing-workshop/01-TDD-REFACTORING-PROCESS.md)
- [React Testing Library Guide](./frontend/testing-workshop/02-REACT-TESTING-LIBRARY.md)
- [Best Practices](./frontend/testing-workshop/03-BEST-PRACTICES.md)

#### SOLID Principle Workshops
Each principle has a dedicated testing workshop:
1. Single Responsibility Principle (SRP)
2. Open/Closed Principle (OCP)
3. Liskov Substitution Principle (LSP)
4. Interface Segregation Principle (ISP)
5. Dependency Inversion Principle (DIP)

### Getting Started (Frontend)

1. **Setup React Application**: Install and run the reference app
2. **Read Core Concepts**: Understand testing philosophy and React Testing Library
3. **Start with SRP**: Begin with the SRP testing workshop
4. **Progress Through Principles**: Complete all 5 principles
5. **Use Assessment Tools**: Validate your work after each principle

---

## Assessment Tools

### Backend Assessment

**Location**: `backend/assessment/CHECKLIST.md`

**Features**:
- 139 assessment criteria across all 5 SOLID principles
- Language-specific criteria for C#, Java, Python, TypeScript
- Quantitative scoring system (target: 80%+)
- Code quality metrics tracking
- Peer and instructor review sections
- Red flags and anti-patterns
- Action items template

**Criteria Breakdown**:
- SRP: 34 criteria
- OCP: 25 criteria
- LSP: 25 criteria
- ISP: 27 criteria
- DIP: 28 criteria

### Frontend Assessment

**Location**: `frontend/assessment/CHECKLIST.md`

**Features**:
- 121 assessment criteria across all 5 SOLID principles
- React and TypeScript-specific criteria
- Component and hook assessment
- Quantitative scoring system (target: 80%+)
- Code quality metrics tracking
- Peer and instructor review sections
- React anti-patterns
- Action items template

**Criteria Breakdown**:
- SRP: 28 criteria
- OCP: 23 criteria
- LSP: 23 criteria
- ISP: 22 criteria
- DIP: 25 criteria

---

## Learning Path

### Backend Developers

```
1. Choose Language (C#, Java, Python, or TypeScript)
   ↓
2. Read Backend Testing Philosophy
   ↓
3. Complete Language-Specific Setup
   ↓
4. Learn TDD Refactoring Process
   ↓
5. Work Through SRP Testing Workshop
   ↓
6. Complete SRP Assessment Checklist
   ↓
7. Repeat for OCP, LSP, ISP, DIP
   ↓
8. Request Instructor Review
```

### Frontend Developers

```
1. Setup React Reference Application
   ↓
2. Read Frontend Testing Philosophy
   ↓
3. Learn React Testing Library
   ↓
4. Learn TDD Refactoring Process
   ↓
5. Work Through SRP Testing Workshop
   ↓
6. Complete SRP Assessment Checklist
   ↓
7. Repeat for OCP, LSP, ISP, DIP
   ↓
8. Request Instructor Review
```

---

## Testing Stack Reference

### Backend

| Language | Test Framework | Mocking | Assertions | Integration |
|----------|---------------|---------|------------|-------------|
| C# | xUnit | Moq | FluentAssertions | Testcontainers |
| Java | JUnit 5 | Mockito | AssertJ | Testcontainers |
| Python | pytest | pytest-mock | Built-in | Testcontainers |
| TypeScript | Jest | Jest | Jest | Testcontainers |

### Frontend

| Technology | Test Framework | Component Testing | User Events | Mocking |
|------------|---------------|-------------------|-------------|---------|
| React/TypeScript | Jest | React Testing Library | @testing-library/user-event | Jest/MSW |

---

## Key Testing Principles

### 1. Test Behavior, Not Implementation
Write tests that verify what the code does, not how it does it.

### 2. Follow Arrange-Act-Assert
Structure every test consistently:
- **Arrange**: Set up test data
- **Act**: Execute the behavior
- **Assert**: Verify the outcome

### 3. Keep Tests Independent
Each test should run independently without relying on other tests.

### 4. Write Descriptive Names
Test names should clearly describe what is being tested and the expected outcome.

### 5. Test One Thing
Each test should verify one specific behavior or condition.

---

## Assessment Process

### Self-Assessment
1. Complete the exercise
2. Run all tests (ensure they pass)
3. Use the assessment checklist for your track
4. Score yourself honestly
5. Identify areas for improvement

### Peer Review
1. Share your code with a peer
2. Peer uses the assessment checklist
3. Peer provides constructive feedback
4. Discuss improvements together
5. Iterate based on feedback

### Instructor Review
1. Complete self-assessment (80%+ score)
2. Complete peer review
3. Submit for instructor review
4. Instructor uses assessment checklist
5. Receive detailed feedback and grade

---

## Running Tests

### Backend

**C# (.NET)**
```bash
cd backend/reference-application/Dotnet
dotnet test
dotnet test /p:CollectCoverage=true
```

**Java**
```bash
cd backend/reference-application/Java
mvn test
mvn test jacoco:report
```

**Python**
```bash
cd backend/reference-application/Python
pytest
pytest --cov=src --cov-report=html
```

**TypeScript**
```bash
cd backend/reference-application/TypeScript
npm test
npm test -- --coverage
```

### Frontend

**React/TypeScript**
```bash
cd frontend/reference-application/React
npm test
npm test -- --coverage
npm test -- --watch
```

---

## Coverage Targets

### Minimum Requirements
- **Overall Coverage**: 70%
- **Target Coverage**: 80-90%
- **Business Logic**: 100%

### What to Measure
- Line coverage
- Branch coverage
- Function coverage
- Statement coverage

---

## Common Issues and Solutions

### Backend

**Issue**: Tests fail after refactoring
- **Solution**: Write characterization tests first
- **Solution**: Run tests frequently during refactoring
- **Solution**: Make small, incremental changes

**Issue**: Slow test execution
- **Solution**: Mock external dependencies
- **Solution**: Use in-memory databases
- **Solution**: Parallelize test execution

**Issue**: Difficult to test code
- **Solution**: Apply SOLID principles
- **Solution**: Use dependency injection
- **Solution**: Separate concerns

### Frontend

**Issue**: "Unable to find element"
- **Solution**: Use `waitFor` for async operations
- **Solution**: Check query priorities
- **Solution**: Verify element is actually rendered

**Issue**: "Act warnings"
- **Solution**: Wrap state updates in `act`
- **Solution**: Use `waitFor` for async state changes
- **Solution**: Ensure all promises resolve

**Issue**: Tests pass individually but fail together
- **Solution**: Clean up after each test
- **Solution**: Clear mocks between tests
- **Solution**: Avoid shared state

---

## Resources

### Documentation
- [Backend Testing Workshop](./backend/testing-workshop/README.md)
- [Frontend Testing Workshop](./frontend/testing-workshop/README.md)
- [Backend Assessment Checklist](./backend/assessment/CHECKLIST.md)
- [Frontend Assessment Checklist](./frontend/assessment/CHECKLIST.md)

### External Resources
- [Test-Driven Development by Kent Beck](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530)
- [React Testing Library Documentation](https://testing-library.com/react)
- [Jest Documentation](https://jestjs.io/)
- [xUnit Documentation](https://xunit.net/)
- [JUnit 5 Documentation](https://junit.org/junit5/)
- [pytest Documentation](https://docs.pytest.org/)

---

## Support

If you need help:

1. **Check Documentation**: Review the testing workshop and assessment guides
2. **Review Examples**: Study the code examples in your language
3. **Ask Peers**: Collaborate with other students
4. **Consult Instructor**: Reach out for guidance
5. **Use Resources**: Refer to external documentation

---

## Next Steps

### For Students
1. Choose your track (Backend or Frontend)
2. Select your language (Backend only)
3. Read the testing philosophy
4. Complete the setup
5. Start with SRP testing workshop
6. Use assessment checklist after each principle
7. Request reviews as needed

### For Instructors
1. Review the assessment checklists
2. Familiarize yourself with the testing workshops
3. Customize criteria if needed
4. Prepare review templates
5. Guide students through the process
6. Provide consistent feedback using checklists

---

**Ready to begin?** Choose your track and start with the testing workshop!

- **Backend**: [Backend Testing Workshop](./backend/testing-workshop/README.md)
- **Frontend**: [Frontend Testing Workshop](./frontend/testing-workshop/README.md)
