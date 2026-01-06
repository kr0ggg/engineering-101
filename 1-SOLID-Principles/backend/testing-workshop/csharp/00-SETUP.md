# C# Testing Setup Guide

## Overview

This guide walks you through setting up a complete testing environment for C# (.NET) backend development. You'll configure xUnit, Moq, FluentAssertions, and other essential testing tools.

## Prerequisites

- **.NET SDK 8.0 or later**
  - Download: https://dotnet.microsoft.com/download
  - Verify: `dotnet --version`

- **IDE** (choose one):
  - Visual Studio 2022 (Community, Professional, or Enterprise)
  - Visual Studio Code with C# extension
  - JetBrains Rider

- **Docker Desktop** (for integration tests)
  - Download: https://docs.docker.com/get-docker/
  - Required for PostgreSQL database

## Project Structure

```
EcommerceApp/
├── src/
│   └── EcommerceApp/
│       ├── EcommerceApp.csproj
│       ├── Services/
│       ├── Repositories/
│       └── Models/
└── tests/
    └── EcommerceApp.Tests/
        ├── EcommerceApp.Tests.csproj
        ├── Services/
        ├── Repositories/
        └── TestHelpers/
```

## Step 1: Create Test Project

### Using .NET CLI

```bash
# Navigate to your solution directory
cd backend/reference-application/Dotnet

# Create test project
dotnet new xunit -n EcommerceApp.Tests -o tests/EcommerceApp.Tests

# Add reference to main project
cd tests/EcommerceApp.Tests
dotnet add reference ../../src/EcommerceApp/EcommerceApp.csproj

# Add to solution
cd ../..
dotnet sln add tests/EcommerceApp.Tests/EcommerceApp.Tests.csproj
```

### Using Visual Studio

1. Right-click solution → Add → New Project
2. Select "xUnit Test Project"
3. Name: `EcommerceApp.Tests`
4. Right-click test project → Add → Project Reference
5. Select `EcommerceApp` project

## Step 2: Install Testing Packages

### Add NuGet Packages

```bash
cd tests/EcommerceApp.Tests

# Core testing framework (already included)
# dotnet add package xunit

# Test runner (already included)
# dotnet add package xunit.runner.visualstudio

# Mocking library
dotnet add package Moq

# Fluent assertions
dotnet add package FluentAssertions

# Test data generation
dotnet add package AutoFixture
dotnet add package AutoFixture.Xunit2

# Integration testing
dotnet add package Testcontainers
dotnet add package Testcontainers.PostgreSql

# Code coverage
dotnet add package coverlet.collector
```

### Verify Package Installation

Your `EcommerceApp.Tests.csproj` should look like this:

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <IsPackable>false</IsPackable>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="AutoFixture" Version="4.18.1" />
    <PackageReference Include="AutoFixture.Xunit2" Version="4.18.1" />
    <PackageReference Include="coverlet.collector" Version="6.0.0" />
    <PackageReference Include="FluentAssertions" Version="6.12.0" />
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.8.0" />
    <PackageReference Include="Moq" Version="4.20.70" />
    <PackageReference Include="Testcontainers" Version="3.7.0" />
    <PackageReference Include="Testcontainers.PostgreSql" Version="3.7.0" />
    <PackageReference Include="xunit" Version="2.6.6" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.5.6" />
  </ItemGroup>

  <ItemGroup>
    <ProjectReference Include="..\..\src\EcommerceApp\EcommerceApp.csproj" />
  </ItemGroup>

</Project>
```

## Step 3: Configure Test Settings

### Create xunit.runner.json

```bash
cd tests/EcommerceApp.Tests
```

Create `xunit.runner.json`:

```json
{
  "$schema": "https://xunit.net/schema/current/xunit.runner.schema.json",
  "methodDisplay": "method",
  "methodDisplayOptions": "all",
  "diagnosticMessages": false,
  "internalDiagnosticMessages": false,
  "maxParallelThreads": 4,
  "parallelizeAssembly": true,
  "parallelizeTestCollections": true
}
```

Update `.csproj` to include it:

```xml
<ItemGroup>
  <Content Include="xunit.runner.json" CopyToOutputDirectory="PreserveNewest" />
</ItemGroup>
```

### Configure Code Coverage

Create `coverlet.runsettings`:

```xml
<?xml version="1.0" encoding="utf-8" ?>
<RunSettings>
  <DataCollectionRunSettings>
    <DataCollectors>
      <DataCollector friendlyName="XPlat Code Coverage">
        <Configuration>
          <Format>cobertura,opencover</Format>
          <Exclude>[*.Tests]*</Exclude>
          <ExcludeByAttribute>Obsolete,GeneratedCodeAttribute,CompilerGeneratedAttribute</ExcludeByAttribute>
        </Configuration>
      </DataCollector>
    </DataCollectors>
  </DataCollectionRunSettings>
</RunSettings>
```

## Step 4: Write Your First Test

### Create a Simple Test

Create `tests/EcommerceApp.Tests/Services/CustomerServiceTests.cs`:

```csharp
using Xunit;
using Moq;
using FluentAssertions;
using EcommerceApp.Services;
using EcommerceApp.Models;
using EcommerceApp.Repositories;

namespace EcommerceApp.Tests.Services;

public class CustomerServiceTests
{
    [Fact]
    public void CreateCustomer_ShouldSaveToRepository()
    {
        // Arrange
        var mockRepository = new Mock<ICustomerRepository>();
        var service = new CustomerService(mockRepository.Object);
        var customer = new Customer 
        { 
            Id = 1, 
            Name = "John Doe", 
            Email = "john@example.com" 
        };

        // Act
        service.CreateCustomer(customer);

        // Assert
        mockRepository.Verify(
            r => r.Save(It.Is<Customer>(c => c.Id == 1 && c.Name == "John Doe")),
            Times.Once
        );
    }

    [Theory]
    [InlineData("")]
    [InlineData(null)]
    [InlineData("   ")]
    public void CreateCustomer_ShouldThrowException_WhenNameInvalid(string invalidName)
    {
        // Arrange
        var mockRepository = new Mock<ICustomerRepository>();
        var service = new CustomerService(mockRepository.Object);
        var customer = new Customer { Name = invalidName, Email = "john@example.com" };

        // Act & Assert
        var exception = Assert.Throws<ArgumentException>(() => 
            service.CreateCustomer(customer)
        );
        exception.Message.Should().Contain("Name is required");
    }
}
```

## Step 5: Run Tests

### Using .NET CLI

```bash
# Run all tests
dotnet test

# Run with detailed output
dotnet test --logger "console;verbosity=detailed"

# Run specific test
dotnet test --filter "FullyQualifiedName~CustomerServiceTests"

# Run tests in parallel
dotnet test --parallel

# Run with coverage
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura

# Generate HTML coverage report
dotnet test /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
dotnet tool install -g dotnet-reportgenerator-globaltool
reportgenerator -reports:coverage.opencover.xml -targetdir:coverage-report
```

### Using Visual Studio

1. **Test Explorer**: View → Test Explorer
2. **Run All Tests**: Click "Run All" button
3. **Run Specific Test**: Right-click test → Run
4. **Debug Test**: Right-click test → Debug
5. **Code Coverage**: Test → Analyze Code Coverage

### Using VS Code

1. Install "C# Dev Kit" extension
2. Open Test Explorer (beaker icon in sidebar)
3. Click "Run All Tests" or run individual tests
4. View results in Test Explorer

## Step 6: Configure Test Helpers

### Create Test Base Class

Create `tests/EcommerceApp.Tests/TestHelpers/TestBase.cs`:

```csharp
using Xunit;

namespace EcommerceApp.Tests.TestHelpers;

public abstract class TestBase : IDisposable
{
    protected TestBase()
    {
        // Setup code that runs before each test
    }

    public void Dispose()
    {
        // Cleanup code that runs after each test
        GC.SuppressFinalize(this);
    }
}
```

### Create Test Data Builders

Create `tests/EcommerceApp.Tests/TestHelpers/CustomerBuilder.cs`:

```csharp
using EcommerceApp.Models;

namespace EcommerceApp.Tests.TestHelpers;

public class CustomerBuilder
{
    private int _id = 1;
    private string _name = "John Doe";
    private string _email = "john@example.com";
    private bool _isActive = true;

    public CustomerBuilder WithId(int id)
    {
        _id = id;
        return this;
    }

    public CustomerBuilder WithName(string name)
    {
        _name = name;
        return this;
    }

    public CustomerBuilder WithEmail(string email)
    {
        _email = email;
        return this;
    }

    public CustomerBuilder Inactive()
    {
        _isActive = false;
        return this;
    }

    public Customer Build()
    {
        return new Customer
        {
            Id = _id,
            Name = _name,
            Email = _email,
            IsActive = _isActive
        };
    }
}
```

Usage:

```csharp
[Fact]
public void ProcessOrder_ShouldFail_WhenCustomerInactive()
{
    var customer = new CustomerBuilder()
        .WithId(1)
        .Inactive()
        .Build();

    Assert.Throws<InvalidOperationException>(() => 
        _service.ProcessOrder(customer, order)
    );
}
```

## Step 7: Integration Test Setup

### Configure Testcontainers

Create `tests/EcommerceApp.Tests/Integration/DatabaseFixture.cs`:

```csharp
using Testcontainers.PostgreSql;
using Xunit;

namespace EcommerceApp.Tests.Integration;

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
            .Build();
    }

    public string ConnectionString => _container.GetConnectionString();

    public async Task InitializeAsync()
    {
        await _container.StartAsync();
        
        // Run migrations here
        // await RunMigrations(ConnectionString);
    }

    public async Task DisposeAsync()
    {
        await _container.DisposeAsync();
    }
}

[CollectionDefinition("Database")]
public class DatabaseCollection : ICollectionFixture<DatabaseFixture>
{
    // This class has no code, and is never created.
    // Its purpose is simply to be the place to apply [CollectionDefinition]
}
```

### Write Integration Test

Create `tests/EcommerceApp.Tests/Integration/CustomerRepositoryIntegrationTests.cs`:

```csharp
using Xunit;
using FluentAssertions;
using EcommerceApp.Repositories;
using EcommerceApp.Models;
using Npgsql;

namespace EcommerceApp.Tests.Integration;

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
            Id = 1, 
            Name = "John Doe", 
            Email = "john@example.com" 
        };

        // Act
        await repository.SaveAsync(customer);

        // Assert
        var retrieved = await repository.FindByIdAsync(1);
        retrieved.Should().NotBeNull();
        retrieved!.Name.Should().Be("John Doe");
        retrieved.Email.Should().Be("john@example.com");
    }
}
```

## Step 8: Continuous Integration

### GitHub Actions Configuration

Create `.github/workflows/dotnet-tests.yml`:

```yaml
name: .NET Tests

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
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '8.0.x'
    
    - name: Restore dependencies
      run: dotnet restore
    
    - name: Build
      run: dotnet build --no-restore
    
    - name: Test
      run: dotnet test --no-build --verbosity normal /p:CollectCoverage=true /p:CoverletOutputFormat=cobertura
    
    - name: Code Coverage Report
      uses: codecov/codecov-action@v3
      with:
        files: ./tests/EcommerceApp.Tests/coverage.cobertura.xml
```

## Troubleshooting

### Issue: Tests Not Discovered

**Solution**: Ensure test methods are:
- Public
- Have `[Fact]` or `[Theory]` attribute
- In a public class

```csharp
// ✅ Correct
public class MyTests
{
    [Fact]
    public void MyTest() { }
}

// ❌ Wrong - not public
class MyTests
{
    [Fact]
    void MyTest() { }
}
```

### Issue: Moq Setup Not Working

**Solution**: Ensure interface is properly configured:

```csharp
// ✅ Correct
var mock = new Mock<ICustomerRepository>();
mock.Setup(r => r.FindById(It.IsAny<int>()))
    .Returns(new Customer { Id = 1 });

// ❌ Wrong - setup doesn't match call
mock.Setup(r => r.FindById(1))  // Expects exactly 1
    .Returns(new Customer { Id = 1 });
var result = repository.FindById(2);  // Called with 2
```

### Issue: Testcontainers Not Starting

**Solution**: Ensure Docker Desktop is running:

```bash
# Check Docker is running
docker ps

# If not running, start Docker Desktop
```

### Issue: Slow Test Execution

**Solution**: Enable parallel execution:

```json
// xunit.runner.json
{
  "parallelizeAssembly": true,
  "parallelizeTestCollections": true,
  "maxParallelThreads": 4
}
```

## Best Practices

### ✅ Do's

- Use `[Fact]` for single test cases
- Use `[Theory]` with `[InlineData]` for multiple test cases
- Use FluentAssertions for readable assertions
- Mock external dependencies
- Keep tests fast (< 1 second)
- Use descriptive test names

### ❌ Don'ts

- Don't test private methods directly
- Don't share state between tests
- Don't use `Thread.Sleep()` in tests
- Don't ignore failing tests
- Don't test framework code

## Quick Reference

### Common Commands

```bash
# Run all tests
dotnet test

# Run with coverage
dotnet test /p:CollectCoverage=true

# Run specific test
dotnet test --filter "FullyQualifiedName~MyTest"

# Watch mode
dotnet watch test

# List all tests
dotnet test --list-tests
```

### Common Assertions

```csharp
// FluentAssertions
result.Should().Be(expected);
result.Should().NotBeNull();
result.Should().BeOfType<Customer>();
collection.Should().HaveCount(3);
collection.Should().Contain(item);
exception.Should().BeOfType<ArgumentException>();

// xUnit
Assert.Equal(expected, actual);
Assert.NotNull(result);
Assert.True(condition);
Assert.Throws<Exception>(() => method());
```

### Common Moq Patterns

```csharp
// Setup return value
mock.Setup(m => m.Method()).Returns(value);

// Setup async return
mock.Setup(m => m.MethodAsync()).ReturnsAsync(value);

// Setup with parameters
mock.Setup(m => m.Method(It.IsAny<int>())).Returns(value);

// Verify call
mock.Verify(m => m.Method(), Times.Once);

// Verify never called
mock.Verify(m => m.Method(), Times.Never);
```

## Next Steps

1. Review [C# Testing Patterns](./01-TESTING-PATTERNS.md)
2. Learn [C# Mocking with Moq](./02-MOCKING.md)
3. Explore [C# Integration Testing](./03-INTEGRATION-TESTING.md)
4. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**You're now ready to write tests in C#!** Start with simple unit tests and gradually move to more complex scenarios.
