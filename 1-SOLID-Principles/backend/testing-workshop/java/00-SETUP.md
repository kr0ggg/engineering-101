# Java Testing Setup Guide

## Overview

This guide walks you through setting up a complete testing environment for Java backend development using JUnit 5, Mockito, AssertJ, and Testcontainers.

## Prerequisites

- **Java JDK 17 or later**
  - Download: https://adoptium.net/
  - Verify: `java -version`

- **Maven 3.8+ or Gradle 7.0+**
  - Maven: https://maven.apache.org/download.cgi
  - Gradle: https://gradle.org/install/
  - Verify: `mvn -version` or `gradle -version`

- **IDE** (choose one):
  - IntelliJ IDEA (Community or Ultimate)
  - Eclipse with Java EE
  - VS Code with Java Extension Pack

- **Docker Desktop** (for integration tests)
  - Download: https://docs.docker.com/get-docker/
  - Required for Testcontainers

## Project Structure

```
ecommerce-app/
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/example/ecommerce/
│   │           ├── service/
│   │           ├── repository/
│   │           └── model/
│   └── test/
│       └── java/
│           └── com/example/ecommerce/
│               ├── service/
│               ├── repository/
│               └── testhelpers/
├── pom.xml (Maven)
└── build.gradle (Gradle)
```

## Step 1: Create Test Project

### Using Maven

Create `pom.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>ecommerce-app</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <junit.version>5.10.1</junit.version>
        <mockito.version>5.8.0</mockito.version>
        <assertj.version>3.24.2</assertj.version>
        <testcontainers.version>1.19.3</testcontainers.version>
    </properties>

    <dependencies>
        <!-- JUnit 5 -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>${junit.version}</version>
            <scope>test</scope>
        </dependency>

        <!-- Mockito -->
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>${mockito.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-junit-jupiter</artifactId>
            <version>${mockito.version}</version>
            <scope>test</scope>
        </dependency>

        <!-- AssertJ -->
        <dependency>
            <groupId>org.assertj</groupId>
            <artifactId>assertj-core</artifactId>
            <version>${assertj.version}</version>
            <scope>test</scope>
        </dependency>

        <!-- Testcontainers -->
        <dependency>
            <groupId>org.testcontainers</groupId>
            <artifactId>testcontainers</artifactId>
            <version>${testcontainers.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.testcontainers</groupId>
            <artifactId>postgresql</artifactId>
            <version>${testcontainers.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.testcontainers</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>${testcontainers.version}</version>
            <scope>test</scope>
        </dependency>

        <!-- PostgreSQL Driver -->
        <dependency>
            <groupId>org.postgresql</groupId>
            <artifactId>postgresql</artifactId>
            <version>42.7.1</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.3</version>
            </plugin>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>0.8.11</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>prepare-agent</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>report</id>
                        <phase>test</phase>
                        <goals>
                            <goal>report</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

### Using Gradle

Create `build.gradle`:

```groovy
plugins {
    id 'java'
    id 'jacoco'
}

group = 'com.example'
version = '1.0-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    // JUnit 5
    testImplementation 'org.junit.jupiter:junit-jupiter:5.10.1'
    
    // Mockito
    testImplementation 'org.mockito:mockito-core:5.8.0'
    testImplementation 'org.mockito:mockito-junit-jupiter:5.8.0'
    
    // AssertJ
    testImplementation 'org.assertj:assertj-core:3.24.2'
    
    // Testcontainers
    testImplementation 'org.testcontainers:testcontainers:1.19.3'
    testImplementation 'org.testcontainers:postgresql:1.19.3'
    testImplementation 'org.testcontainers:junit-jupiter:1.19.3'
    
    // PostgreSQL
    implementation 'org.postgresql:postgresql:42.7.1'
}

test {
    useJUnitPlatform()
    finalizedBy jacocoTestReport
}

jacoco {
    toolVersion = "0.8.11"
}

jacocoTestReport {
    dependsOn test
    reports {
        xml.required = true
        html.required = true
    }
}
```

## Step 2: Write Your First Test

Create `src/test/java/com/example/ecommerce/service/CustomerServiceTest.java`:

```java
package com.example.ecommerce.service;

import com.example.ecommerce.model.Customer;
import com.example.ecommerce.repository.CustomerRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.NullAndEmptySource;
import org.junit.jupiter.params.provider.ValueSource;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CustomerServiceTest {

    @Mock
    private CustomerRepository mockRepository;

    private CustomerService service;

    @BeforeEach
    void setUp() {
        service = new CustomerService(mockRepository);
    }

    @Test
    void createCustomer_shouldSaveToRepository() {
        // Arrange
        Customer customer = new Customer(1, "John Doe", "john@example.com");

        // Act
        service.createCustomer(customer);

        // Assert
        verify(mockRepository).save(argThat(c ->
            c.getId() == 1 &&
            c.getName().equals("John Doe") &&
            c.getEmail().equals("john@example.com")
        ));
    }

    @ParameterizedTest
    @NullAndEmptySource
    @ValueSource(strings = {"  ", "\t", "\n"})
    void createCustomer_shouldThrowException_whenNameInvalid(String invalidName) {
        // Arrange
        Customer customer = new Customer(1, invalidName, "john@example.com");

        // Act & Assert
        assertThatThrownBy(() -> service.createCustomer(customer))
            .isInstanceOf(IllegalArgumentException.class)
            .hasMessageContaining("Name is required");
    }

    @Test
    void getCustomer_shouldReturnCustomer_whenExists() {
        // Arrange
        Customer expected = new Customer(1, "John Doe", "john@example.com");
        when(mockRepository.findById(1)).thenReturn(expected);

        // Act
        Customer result = service.getCustomer(1);

        // Assert
        assertThat(result)
            .isNotNull()
            .extracting(Customer::getName, Customer::getEmail)
            .containsExactly("John Doe", "john@example.com");
    }
}
```

## Step 3: Run Tests

### Using Maven

```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=CustomerServiceTest

# Run specific test method
mvn test -Dtest=CustomerServiceTest#createCustomer_shouldSaveToRepository

# Run with coverage
mvn test jacoco:report

# Skip tests
mvn install -DskipTests
```

### Using Gradle

```bash
# Run all tests
gradle test

# Run specific test class
gradle test --tests CustomerServiceTest

# Run specific test method
gradle test --tests CustomerServiceTest.createCustomer_shouldSaveToRepository

# Run with coverage
gradle test jacocoTestReport

# Skip tests
gradle build -x test
```

### Using IDE

**IntelliJ IDEA**:
1. Right-click test class → Run
2. Click green arrow next to test method
3. View results in Run window
4. Generate coverage: Run → Run with Coverage

**Eclipse**:
1. Right-click test class → Run As → JUnit Test
2. View results in JUnit view
3. Coverage: Run → Coverage As → JUnit Test

## Step 4: Configure Test Helpers

### Test Base Class

```java
package com.example.ecommerce.testhelpers;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;

public abstract class TestBase {

    @BeforeEach
    void setUpBase() {
        // Common setup
    }

    @AfterEach
    void tearDownBase() {
        // Common cleanup
    }
}
```

### Test Data Builders

```java
package com.example.ecommerce.testhelpers;

import com.example.ecommerce.model.Customer;

public class CustomerBuilder {
    private int id = 1;
    private String name = "John Doe";
    private String email = "john@example.com";
    private boolean isActive = true;

    public CustomerBuilder withId(int id) {
        this.id = id;
        return this;
    }

    public CustomerBuilder withName(String name) {
        this.name = name;
        return this;
    }

    public CustomerBuilder withEmail(String email) {
        this.email = email;
        return this;
    }

    public CustomerBuilder inactive() {
        this.isActive = false;
        return this;
    }

    public Customer build() {
        return new Customer(id, name, email, isActive);
    }
}
```

Usage:

```java
@Test
void processOrder_shouldFail_whenCustomerInactive() {
    Customer customer = new CustomerBuilder()
        .withId(1)
        .inactive()
        .build();

    assertThatThrownBy(() -> service.processOrder(customer, order))
        .isInstanceOf(IllegalStateException.class);
}
```

## Step 5: Integration Test Setup

### Testcontainers Configuration

```java
package com.example.ecommerce.integration;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

@Testcontainers
public abstract class DatabaseTestBase {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16")
        .withDatabaseName("ecommerce_test")
        .withUsername("test")
        .withPassword("test");

    protected static Connection connection;

    @BeforeAll
    static void setUpDatabase() throws SQLException {
        postgres.start();
        connection = DriverManager.getConnection(
            postgres.getJdbcUrl(),
            postgres.getUsername(),
            postgres.getPassword()
        );
        runMigrations();
    }

    @AfterAll
    static void tearDownDatabase() throws SQLException {
        if (connection != null) {
            connection.close();
        }
        postgres.stop();
    }

    private static void runMigrations() throws SQLException {
        String createTablesSql = """
            CREATE TABLE customers (
                id SERIAL PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                email VARCHAR(255) NOT NULL UNIQUE,
                is_active BOOLEAN DEFAULT true,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            """;

        try (var statement = connection.createStatement()) {
            statement.execute(createTablesSql);
        }
    }
}
```

### Integration Test Example

```java
package com.example.ecommerce.integration;

import com.example.ecommerce.model.Customer;
import com.example.ecommerce.repository.CustomerRepository;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

class CustomerRepositoryIntegrationTest extends DatabaseTestBase {

    @Test
    void save_shouldPersistCustomerToDatabase() throws Exception {
        // Arrange
        CustomerRepository repository = new CustomerRepository(connection);
        Customer customer = new Customer(0, "John Doe", "john@example.com");

        // Act
        repository.save(customer);

        // Assert
        Customer retrieved = repository.findByEmail("john@example.com");
        assertThat(retrieved)
            .isNotNull()
            .extracting(Customer::getName, Customer::getEmail)
            .containsExactly("John Doe", "john@example.com");
    }
}
```

## Step 6: Continuous Integration

### GitHub Actions

Create `.github/workflows/java-tests.yml`:

```yaml
name: Java Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: maven
    
    - name: Run tests
      run: mvn test
    
    - name: Generate coverage report
      run: mvn jacoco:report
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        files: ./target/site/jacoco/jacoco.xml
```

## Troubleshooting

### Issue: Tests Not Discovered

**Solution**: Ensure test classes and methods follow naming conventions:

```java
// ✅ Correct
class CustomerServiceTest {
    @Test
    void shouldCreateCustomer() { }
}

// ❌ Wrong - missing Test suffix
class CustomerService {
    @Test
    void shouldCreateCustomer() { }
}
```

### Issue: Mockito Not Working

**Solution**: Add `@ExtendWith(MockitoExtension.class)`:

```java
@ExtendWith(MockitoExtension.class)
class CustomerServiceTest {
    @Mock
    private CustomerRepository mockRepository;
}
```

### Issue: Testcontainers Not Starting

**Solution**: Ensure Docker is running:

```bash
# Check Docker
docker ps

# If not running, start Docker Desktop
```

### Issue: Slow Test Execution

**Solution**: Enable parallel execution in `pom.xml`:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.2.3</version>
    <configuration>
        <parallel>methods</parallel>
        <threadCount>4</threadCount>
    </configuration>
</plugin>
```

## Best Practices

### ✅ Do's

- Use `@BeforeEach` for test setup
- Use `@ExtendWith(MockitoExtension.class)` for mocks
- Use AssertJ for fluent assertions
- Keep tests independent
- Use descriptive test names

### ❌ Don'ts

- Don't test private methods directly
- Don't share state between tests
- Don't use `Thread.sleep()` in tests
- Don't ignore failing tests
- Don't test framework code

## Quick Reference

### Common Commands

```bash
# Maven
mvn test                    # Run all tests
mvn test -Dtest=ClassName   # Run specific test
mvn clean test              # Clean and test
mvn test jacoco:report      # Generate coverage

# Gradle
gradle test                 # Run all tests
gradle test --tests Class   # Run specific test
gradle clean test           # Clean and test
gradle test jacocoTestReport # Generate coverage
```

### Common Annotations

```java
@Test                       // Mark as test method
@BeforeEach                 // Run before each test
@AfterEach                  // Run after each test
@BeforeAll                  // Run once before all tests
@AfterAll                   // Run once after all tests
@Disabled                   // Skip test
@DisplayName("...")         // Custom test name
@ParameterizedTest          // Parameterized test
@ExtendWith                 // Register extension
```

### Common Assertions (AssertJ)

```java
assertThat(actual).isEqualTo(expected);
assertThat(actual).isNotNull();
assertThat(actual).isInstanceOf(Customer.class);
assertThat(list).hasSize(3);
assertThat(list).contains(item);
assertThatThrownBy(() -> method())
    .isInstanceOf(Exception.class);
```

### Common Mockito Patterns

```java
// Setup return value
when(mock.method()).thenReturn(value);

// Setup with parameters
when(mock.method(anyInt())).thenReturn(value);

// Verify call
verify(mock).method();
verify(mock, times(2)).method();
verify(mock, never()).method();
```

## Next Steps

1. Review [Java Testing Patterns](./01-TESTING-PATTERNS.md)
2. Learn [Java Mocking with Mockito](./02-MOCKING.md)
3. Explore [Java Integration Testing](./03-INTEGRATION-TESTING.md)
4. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**You're now ready to write tests in Java!** Start with simple unit tests and gradually move to more complex scenarios.
