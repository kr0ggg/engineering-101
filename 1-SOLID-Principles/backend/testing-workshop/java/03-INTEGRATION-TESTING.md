# Java Integration Testing with Testcontainers

## Overview

Integration tests verify that multiple components work together correctly. This guide covers integration testing in Java using Testcontainers for real database testing.

## Setup

```xml
<!-- Maven -->
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>testcontainers</artifactId>
    <version>1.19.3</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>postgresql</artifactId>
    <version>1.19.3</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>1.19.3</version>
    <scope>test</scope>
</dependency>
```

## Basic Testcontainers Setup

### Database Test Base

```java
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
            
            CREATE TABLE orders (
                id SERIAL PRIMARY KEY,
                customer_id INTEGER REFERENCES customers(id),
                total DECIMAL(10, 2) NOT NULL,
                status VARCHAR(50) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            """;

        try (var statement = connection.createStatement()) {
            statement.execute(createTablesSql);
        }
    }
}
```

### Repository Integration Test

```java
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

    @Test
    void findById_shouldReturnNull_whenCustomerNotExists() throws Exception {
        // Arrange
        CustomerRepository repository = new CustomerRepository(connection);

        // Act
        Customer result = repository.findById(999);

        // Assert
        assertThat(result).isNull();
    }

    @Test
    void update_shouldModifyExistingCustomer() throws Exception {
        // Arrange
        CustomerRepository repository = new CustomerRepository(connection);
        Customer customer = new Customer(0, "John Doe", "john@example.com");
        repository.save(customer);

        // Act
        customer.setName("Jane Doe");
        repository.update(customer);

        // Assert
        Customer updated = repository.findById(customer.getId());
        assertThat(updated.getName()).isEqualTo("Jane Doe");
    }

    @Test
    void delete_shouldRemoveCustomer() throws Exception {
        // Arrange
        CustomerRepository repository = new CustomerRepository(connection);
        Customer customer = new Customer(0, "John Doe", "john@example.com");
        repository.save(customer);

        // Act
        repository.delete(customer.getId());

        // Assert
        Customer deleted = repository.findById(customer.getId());
        assertThat(deleted).isNull();
    }
}
```

## Transaction Testing

```java
class TransactionTest extends DatabaseTestBase {

    @Test
    void transaction_shouldRollbackOnError() throws Exception {
        // Arrange
        connection.setAutoCommit(false);
        CustomerRepository repository = new CustomerRepository(connection);
        Customer customer = new Customer(0, "John Doe", "john@example.com");

        try {
            // Act
            repository.save(customer);
            throw new RuntimeException("Simulated error");
        } catch (Exception e) {
            connection.rollback();
        }

        // Assert - Customer should not exist
        Customer result = repository.findByEmail("john@example.com");
        assertThat(result).isNull();
    }

    @Test
    void transaction_shouldCommitSuccessfully() throws Exception {
        // Arrange
        connection.setAutoCommit(false);
        CustomerRepository repository = new CustomerRepository(connection);
        Customer customer = new Customer(0, "John Doe", "john@example.com");

        // Act
        repository.save(customer);
        connection.commit();

        // Assert - Customer should exist
        Customer result = repository.findByEmail("john@example.com");
        assertThat(result).isNotNull();
    }
}
```

## Testing Multiple Containers

```java
@Testcontainers
class MultiContainerTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @Container
    static GenericContainer<?> redis = new GenericContainer<>("redis:7")
        .withExposedPorts(6379);

    @Test
    void shouldConnectToBothContainers() {
        // Test with both PostgreSQL and Redis
        assertThat(postgres.isRunning()).isTrue();
        assertThat(redis.isRunning()).isTrue();
    }
}
```

## Performance Testing

```java
class PerformanceTest extends DatabaseTestBase {

    @Test
    void bulkInsert_shouldCompleteInReasonableTime() throws Exception {
        // Arrange
        CustomerRepository repository = new CustomerRepository(connection);
        List<Customer> customers = IntStream.range(1, 1001)
            .mapToObj(i -> new Customer(0, "Customer " + i, "customer" + i + "@example.com"))
            .collect(Collectors.toList());

        // Act
        long startTime = System.currentTimeMillis();
        for (Customer customer : customers) {
            repository.save(customer);
        }
        long duration = System.currentTimeMillis() - startTime;

        // Assert
        assertThat(duration).isLessThan(5000); // 5 seconds
    }
}
```

## Data Seeding

```java
class DatabaseSeeder {
    private final Connection connection;

    public DatabaseSeeder(Connection connection) {
        this.connection = connection;
    }

    public void seedTestData() throws SQLException {
        seedCustomers();
        seedProducts();
        seedOrders();
    }

    private void seedCustomers() throws SQLException {
        String sql = """
            INSERT INTO customers (name, email, is_active)
            VALUES 
                ('John Doe', 'john@example.com', true),
                ('Jane Smith', 'jane@example.com', true),
                ('Bob Johnson', 'bob@example.com', false)
            """;

        try (var statement = connection.createStatement()) {
            statement.execute(sql);
        }
    }

    private void seedProducts() throws SQLException {
        // Seed products
    }

    private void seedOrders() throws SQLException {
        // Seed orders
    }
}

// Usage in tests
@Test
void getActiveCustomers_shouldReturnOnlyActive() throws Exception {
    // Arrange
    DatabaseSeeder seeder = new DatabaseSeeder(connection);
    seeder.seedTestData();
    
    CustomerRepository repository = new CustomerRepository(connection);

    // Act
    List<Customer> customers = repository.findActiveCustomers();

    // Assert
    assertThat(customers).hasSize(2);
    assertThat(customers).allMatch(Customer::isActive);
}
```

## Best Practices

### ✅ Do's

```java
// Clean up data between tests
@AfterEach
void cleanUp() throws SQLException {
    try (var statement = connection.createStatement()) {
        statement.execute("DELETE FROM orders");
        statement.execute("DELETE FROM customers");
    }
}

// Use transactions for isolation
@Test
void testWithTransaction() throws SQLException {
    connection.setAutoCommit(false);
    try {
        // Test code
        connection.commit();
    } catch (Exception e) {
        connection.rollback();
        throw e;
    }
}

// Test realistic scenarios
@Test
void createOrder_withMultipleItems() {
    // Test complete workflow
}
```

### ❌ Don'ts

```java
// Don't share data between tests
private static Customer sharedCustomer; // Bad!

// Don't use production database
Connection connection = DriverManager.getConnection("production-url"); // Never!

// Don't skip cleanup
// Always clean up test data

// Don't test too much in one test
@Test
void testEverything() { // Bad - too broad
    // 100 lines of test code
}
```

## Running Integration Tests

```bash
# Maven - run all tests
mvn test

# Maven - run only integration tests
mvn test -Dgroups="integration"

# Maven - skip integration tests
mvn test -DexcludeGroups="integration"

# Gradle - run all tests
gradle test

# Gradle - run only integration tests
gradle test --tests "*IntegrationTest"
```

## Summary

**Key Concepts**:
- Use Testcontainers for real database testing
- Create base classes for container lifecycle
- Test actual SQL queries and transactions
- Clean up data between tests
- Use realistic test scenarios

## Next Steps

1. Review [Testing Patterns](./01-TESTING-PATTERNS.md)
2. Review [Mocking with Mockito](./02-MOCKING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Integration tests with Testcontainers give you confidence that your code works with real infrastructure while keeping tests fast and isolated.
