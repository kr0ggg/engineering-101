# Java Testing Guide for SOLID Principles

## Overview

Comprehensive testing resources for Java backend development using JUnit 5, Mockito, AssertJ, and Testcontainers.

## Testing Stack

- **JUnit 5** - Test framework
- **Mockito** - Mocking library
- **AssertJ** - Fluent assertions
- **Testcontainers** - Integration testing

## Guide Structure

1. **[Setup](./00-SETUP.md)** - Complete Java testing environment setup
2. **[Testing Patterns](./01-TESTING-PATTERNS.md)** - SOLID principle testing patterns
3. **[Mocking with Mockito](./02-MOCKING.md)** - Comprehensive Mockito guide
4. **[Integration Testing](./03-INTEGRATION-TESTING.md)** - Testcontainers integration

## Quick Start

```bash
# Add dependencies to pom.xml or build.gradle
# See 00-SETUP.md for complete configuration

# Run tests
mvn test              # Maven
gradle test           # Gradle

# With coverage
mvn test jacoco:report
gradle test jacocoTestReport
```

## Key Concepts

- Use `@ExtendWith(MockitoExtension.class)` for mocks
- Use `@BeforeEach` for test setup
- Use AssertJ for fluent assertions
- Use Testcontainers for real database testing
- Follow AAA pattern (Arrange-Act-Assert)

## Next Steps

1. Complete [Setup](./00-SETUP.md)
2. Learn [Testing Patterns](./01-TESTING-PATTERNS.md)
3. Master [Mockito](./02-MOCKING.md)
4. Apply to [SOLID Workshops](../README.md#solid-principle-testing-workshops)
