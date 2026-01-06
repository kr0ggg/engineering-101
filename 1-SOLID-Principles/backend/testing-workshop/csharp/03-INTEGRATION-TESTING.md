# C# Integration Testing with Testcontainers

## Overview

Integration tests verify that multiple components work together correctly. This guide covers integration testing in C# using Testcontainers for real database testing.

## Why Integration Tests?

- Verify database queries work correctly
- Test actual data persistence
- Catch SQL errors and schema issues
- Validate transactions and concurrency
- Test against real infrastructure

## Setup

```bash
dotnet add package Testcontainers
dotnet add package Testcontainers.PostgreSql
```

## Basic Testcontainers Setup

### Database Fixture

```csharp
using Testcontainers.PostgreSql;
using Xunit;
using Npgsql;

public class DatabaseFixture : IAsyncLifetime
{
    private readonly PostgreSqlContainer _container;

    public DatabaseFixture()
    {
        _container = new PostgreSqlBuilder()
            .WithImage("postgres:16")
            .WithDatabase("ecommerce_test")
            .WithUsername("test")
            .WithPassword("test")
            .WithCleanUp(true)
            .Build();
    }

    public string ConnectionString => _container.GetConnectionString();

    public async Task InitializeAsync()
    {
        await _container.StartAsync();
        await RunMigrations();
    }

    private async Task RunMigrations()
    {
        await using var connection = new NpgsqlConnection(ConnectionString);
        await connection.OpenAsync();

        var createTableSql = @"
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
        ";

        await using var command = new NpgsqlCommand(createTableSql, connection);
        await command.ExecuteNonQueryAsync();
    }

    public async Task DisposeAsync()
    {
        await _container.DisposeAsync();
    }
}

[CollectionDefinition("Database")]
public class DatabaseCollection : ICollectionFixture<DatabaseFixture>
{
}
```

### Repository Integration Test

```csharp
[Collection("Database")]
public class CustomerRepositoryIntegrationTests
{
    private readonly DatabaseFixture _fixture;

    public CustomerRepositoryIntegrationTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task Save_ShouldPersistCustomerToDatabase()
    {
        // Arrange
        await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
        await connection.OpenAsync();
        var repository = new CustomerRepository(connection);
        var customer = new Customer
        {
            Name = "John Doe",
            Email = "john@example.com",
            IsActive = true
        };

        // Act
        await repository.SaveAsync(customer);

        // Assert
        var retrieved = await repository.FindByEmailAsync("john@example.com");
        retrieved.Should().NotBeNull();
        retrieved!.Name.Should().Be("John Doe");
        retrieved.Email.Should().Be("john@example.com");
        retrieved.IsActive.Should().BeTrue();
    }

    [Fact]
    public async Task FindById_ShouldReturnNull_WhenCustomerNotExists()
    {
        // Arrange
        await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
        await connection.OpenAsync();
        var repository = new CustomerRepository(connection);

        // Act
        var result = await repository.FindByIdAsync(999);

        // Assert
        result.Should().BeNull();
    }

    [Fact]
    public async Task Update_ShouldModifyExistingCustomer()
    {
        // Arrange
        await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
        await connection.OpenAsync();
        var repository = new CustomerRepository(connection);
        var customer = new Customer
        {
            Name = "John Doe",
            Email = "john@example.com"
        };
        await repository.SaveAsync(customer);

        // Act
        customer.Name = "Jane Doe";
        await repository.UpdateAsync(customer);

        // Assert
        var updated = await repository.FindByIdAsync(customer.Id);
        updated!.Name.Should().Be("Jane Doe");
    }

    [Fact]
    public async Task Delete_ShouldRemoveCustomer()
    {
        // Arrange
        await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
        await connection.OpenAsync();
        var repository = new CustomerRepository(connection);
        var customer = new Customer
        {
            Name = "John Doe",
            Email = "john@example.com"
        };
        await repository.SaveAsync(customer);

        // Act
        await repository.DeleteAsync(customer.Id);

        // Assert
        var deleted = await repository.FindByIdAsync(customer.Id);
        deleted.Should().BeNull();
    }
}
```

## Transaction Testing

```csharp
[Collection("Database")]
public class TransactionTests
{
    private readonly DatabaseFixture _fixture;

    public TransactionTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task Transaction_ShouldRollbackOnError()
    {
        // Arrange
        await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
        await connection.OpenAsync();
        await using var transaction = await connection.BeginTransactionAsync();

        var repository = new CustomerRepository(connection, transaction);
        var customer = new Customer
        {
            Name = "John Doe",
            Email = "john@example.com"
        };

        try
        {
            // Act
            await repository.SaveAsync(customer);
            throw new Exception("Simulated error");
            await transaction.CommitAsync();
        }
        catch
        {
            await transaction.RollbackAsync();
        }

        // Assert - Customer should not exist
        var result = await repository.FindByEmailAsync("john@example.com");
        result.Should().BeNull();
    }

    [Fact]
    public async Task Transaction_ShouldCommitSuccessfully()
    {
        // Arrange
        await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
        await connection.OpenAsync();
        await using var transaction = await connection.BeginTransactionAsync();

        var repository = new CustomerRepository(connection, transaction);
        var customer = new Customer
        {
            Name = "John Doe",
            Email = "john@example.com"
        };

        // Act
        await repository.SaveAsync(customer);
        await transaction.CommitAsync();

        // Assert - Customer should exist
        var result = await repository.FindByEmailAsync("john@example.com");
        result.Should().NotBeNull();
    }
}
```

## Testing Multiple Containers

```csharp
public class MultiContainerFixture : IAsyncLifetime
{
    private readonly PostgreSqlContainer _postgresContainer;
    private readonly RedisContainer _redisContainer;

    public MultiContainerFixture()
    {
        _postgresContainer = new PostgreSqlBuilder()
            .WithImage("postgres:16")
            .Build();

        _redisContainer = new RedisBuilder()
            .WithImage("redis:7")
            .Build();
    }

    public string PostgresConnectionString => _postgresContainer.GetConnectionString();
    public string RedisConnectionString => _redisContainer.GetConnectionString();

    public async Task InitializeAsync()
    {
        await Task.WhenAll(
            _postgresContainer.StartAsync(),
            _redisContainer.StartAsync()
        );
    }

    public async Task DisposeAsync()
    {
        await Task.WhenAll(
            _postgresContainer.DisposeAsync().AsTask(),
            _redisContainer.DisposeAsync().AsTask()
        );
    }
}
```

## Performance Testing

```csharp
[Collection("Database")]
public class PerformanceTests
{
    private readonly DatabaseFixture _fixture;

    public PerformanceTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task BulkInsert_ShouldCompleteInReasonableTime()
    {
        // Arrange
        await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
        await connection.OpenAsync();
        var repository = new CustomerRepository(connection);
        var customers = Enumerable.Range(1, 1000)
            .Select(i => new Customer
            {
                Name = $"Customer {i}",
                Email = $"customer{i}@example.com"
            })
            .ToList();

        // Act
        var stopwatch = Stopwatch.StartNew();
        foreach (var customer in customers)
        {
            await repository.SaveAsync(customer);
        }
        stopwatch.Stop();

        // Assert
        stopwatch.ElapsedMilliseconds.Should().BeLessThan(5000); // 5 seconds
    }
}
```

## Data Seeding

```csharp
public class DatabaseSeeder
{
    private readonly NpgsqlConnection _connection;

    public DatabaseSeeder(NpgsqlConnection connection)
    {
        _connection = connection;
    }

    public async Task SeedTestDataAsync()
    {
        await SeedCustomersAsync();
        await SeedProductsAsync();
        await SeedOrdersAsync();
    }

    private async Task SeedCustomersAsync()
    {
        var sql = @"
            INSERT INTO customers (name, email, is_active)
            VALUES 
                ('John Doe', 'john@example.com', true),
                ('Jane Smith', 'jane@example.com', true),
                ('Bob Johnson', 'bob@example.com', false);
        ";

        await using var command = new NpgsqlCommand(sql, _connection);
        await command.ExecuteNonQueryAsync();
    }

    private async Task SeedProductsAsync()
    {
        // Seed products
    }

    private async Task SeedOrdersAsync()
    {
        // Seed orders
    }
}

// Usage in tests
[Fact]
public async Task GetActiveCustomers_ShouldReturnOnlyActive()
{
    // Arrange
    await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
    await connection.OpenAsync();
    
    var seeder = new DatabaseSeeder(connection);
    await seeder.SeedTestDataAsync();
    
    var repository = new CustomerRepository(connection);

    // Act
    var customers = await repository.FindActiveCustomersAsync();

    // Assert
    customers.Should().HaveCount(2);
    customers.Should().AllSatisfy(c => c.IsActive.Should().BeTrue());
}
```

## Testing with EF Core

```csharp
public class EfCoreFixture : IAsyncLifetime
{
    private readonly PostgreSqlContainer _container;
    private DbContextOptions<EcommerceDbContext> _options = null!;

    public EfCoreFixture()
    {
        _container = new PostgreSqlBuilder()
            .WithImage("postgres:16")
            .Build();
    }

    public DbContextOptions<EcommerceDbContext> Options => _options;

    public async Task InitializeAsync()
    {
        await _container.StartAsync();

        _options = new DbContextOptionsBuilder<EcommerceDbContext>()
            .UseNpgsql(_container.GetConnectionString())
            .Options;

        await using var context = new EcommerceDbContext(_options);
        await context.Database.MigrateAsync();
    }

    public async Task DisposeAsync()
    {
        await _container.DisposeAsync();
    }
}

[Collection("EfCore")]
public class CustomerRepositoryEfCoreTests
{
    private readonly EfCoreFixture _fixture;

    public CustomerRepositoryEfCoreTests(EfCoreFixture fixture)
    {
        _fixture = fixture;
    }

    [Fact]
    public async Task SaveAsync_ShouldPersistCustomer()
    {
        // Arrange
        await using var context = new EcommerceDbContext(_fixture.Options);
        var repository = new CustomerRepository(context);
        var customer = new Customer
        {
            Name = "John Doe",
            Email = "john@example.com"
        };

        // Act
        await repository.SaveAsync(customer);
        await context.SaveChangesAsync();

        // Assert
        await using var verifyContext = new EcommerceDbContext(_fixture.Options);
        var saved = await verifyContext.Customers
            .FirstOrDefaultAsync(c => c.Email == "john@example.com");
        saved.Should().NotBeNull();
    }
}
```

## Best Practices

### ✅ Do's

```csharp
// Clean up data between tests
[Fact]
public async Task Test_WithCleanup()
{
    // Arrange
    await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
    await connection.OpenAsync();
    
    try
    {
        // Test code
    }
    finally
    {
        // Cleanup
        await using var cmd = new NpgsqlCommand("DELETE FROM customers", connection);
        await cmd.ExecuteNonQueryAsync();
    }
}

// Use transactions for isolation
[Fact]
public async Task Test_WithTransaction()
{
    await using var connection = new NpgsqlConnection(_fixture.ConnectionString);
    await connection.OpenAsync();
    await using var transaction = await connection.BeginTransactionAsync();
    
    try
    {
        // Test code
        await transaction.CommitAsync();
    }
    catch
    {
        await transaction.RollbackAsync();
        throw;
    }
}

// Test realistic scenarios
[Fact]
public async Task CreateOrder_WithMultipleItems()
{
    // Test complete workflow
}
```

### ❌ Don'ts

```csharp
// Don't share data between tests
private static Customer _sharedCustomer; // Bad!

// Don't use production database
var connection = new NpgsqlConnection("production-connection"); // Never!

// Don't skip cleanup
// Always clean up test data

// Don't test too much in one test
[Fact]
public async Task TestEverything() // Bad - too broad
{
    // 100 lines of test code
}
```

## Troubleshooting

### Container Not Starting

```csharp
// Add logging
var container = new PostgreSqlBuilder()
    .WithImage("postgres:16")
    .WithLogger(new ConsoleLogger())
    .Build();
```

### Connection Issues

```csharp
// Wait for container to be ready
await _container.StartAsync();
await Task.Delay(1000); // Give it a moment

// Test connection
await using var connection = new NpgsqlConnection(_container.GetConnectionString());
await connection.OpenAsync();
```

### Slow Tests

```csharp
// Reuse containers across tests
[CollectionDefinition("Database")]
public class DatabaseCollection : ICollectionFixture<DatabaseFixture>
{
}

// Use parallel execution
// xunit.runner.json
{
  "parallelizeTestCollections": true
}
```

## Running Integration Tests

```bash
# Run all tests
dotnet test

# Run only integration tests
dotnet test --filter "Category=Integration"

# Run with Docker
docker run -d -p 5432:5432 postgres:16
dotnet test

# Skip integration tests in CI
dotnet test --filter "Category!=Integration"
```

## Summary

**Key Concepts**:
- Use Testcontainers for real database testing
- Create fixtures for container lifecycle
- Test actual SQL queries and transactions
- Clean up data between tests
- Use realistic test scenarios

## Next Steps

1. Review [Testing Patterns](./01-TESTING-PATTERNS.md)
2. Review [Mocking with Moq](./02-MOCKING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Integration tests with Testcontainers give you confidence that your code works with real infrastructure while keeping tests fast and isolated.
