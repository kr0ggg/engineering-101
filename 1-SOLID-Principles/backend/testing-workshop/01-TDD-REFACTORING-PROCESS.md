# Test-Driven Refactoring Process for Backend Development

## Overview

Test-Driven Refactoring is a disciplined approach to improving code design while maintaining functionality. This guide shows you how to safely refactor code to follow SOLID principles using tests as your safety net.

## The Process

```
1. Write Characterization Tests
   ↓
2. Ensure All Tests Pass (Green)
   ↓
3. Identify Code Smells
   ↓
4. Plan Refactoring
   ↓
5. Refactor One Thing
   ↓
6. Run Tests (Must Stay Green)
   ↓
7. Commit
   ↓
8. Repeat Steps 5-7
   ↓
9. Review and Clean Up
```

## Step 1: Write Characterization Tests

**Goal**: Document current behavior, even if it's wrong.

Characterization tests capture what the code *actually does*, not what it *should do*. They serve as a safety net during refactoring.

### Example: C# EcommerceManager

```csharp
using Xunit;
using Moq;
using FluentAssertions;

namespace EcommerceApp.Tests
{
    public class EcommerceManagerCharacterizationTests
    {
        private readonly Mock<IDbConnection> _mockConnection;
        private readonly EcommerceManager _manager;

        public EcommerceManagerCharacterizationTests()
        {
            _mockConnection = new Mock<IDbConnection>();
            _manager = new EcommerceManager(_mockConnection.Object);
        }

        [Fact]
        public void CreateCustomer_ShouldSaveToDatabase()
        {
            // Arrange
            var customer = new Customer 
            { 
                Id = 1, 
                Name = "John Doe", 
                Email = "john@example.com" 
            };

            // Act
            _manager.CreateCustomer(customer);

            // Assert - Document what it actually does
            _mockConnection.Verify(
                c => c.Execute(
                    It.Is<string>(sql => sql.Contains("INSERT INTO customers")),
                    It.IsAny<object>()
                ),
                Times.Once
            );
        }

        [Fact]
        public void ProcessOrder_ShouldCalculateTotalAndSendEmail()
        {
            // Arrange
            var order = new Order 
            { 
                Id = 1, 
                CustomerId = 1,
                Items = new List<OrderItem>
                {
                    new OrderItem { ProductId = 1, Quantity = 2, Price = 10.00m }
                }
            };

            // Act
            var result = _manager.ProcessOrder(order);

            // Assert - Document current behavior
            result.Total.Should().Be(20.00m);
            // Note: This test documents that ProcessOrder does too much
        }
    }
}
```

### Example: Java EcommerceManager

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

class EcommerceManagerCharacterizationTest {
    
    @Mock
    private Connection connection;
    
    private EcommerceManager manager;
    
    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        manager = new EcommerceManager(connection);
    }
    
    @Test
    void createCustomer_shouldSaveToDatabase() {
        // Arrange
        Customer customer = new Customer(1, "John Doe", "john@example.com");
        
        // Act
        manager.createCustomer(customer);
        
        // Assert - Document what it actually does
        verify(connection).execute(
            contains("INSERT INTO customers"),
            any()
        );
    }
}
```

### Example: Python EcommerceManager

```python
import pytest
from unittest.mock import Mock, patch
from ecommerce_manager import EcommerceManager
from models import Customer, Order, OrderItem

class TestEcommerceManagerCharacterization:
    
    @pytest.fixture
    def mock_connection(self):
        return Mock()
    
    @pytest.fixture
    def manager(self, mock_connection):
        return EcommerceManager(mock_connection)
    
    def test_create_customer_saves_to_database(self, manager, mock_connection):
        # Arrange
        customer = Customer(id=1, name="John Doe", email="john@example.com")
        
        # Act
        manager.create_customer(customer)
        
        # Assert - Document what it actually does
        mock_connection.execute.assert_called_once()
        args = mock_connection.execute.call_args[0]
        assert "INSERT INTO customers" in args[0]
```

### Example: TypeScript EcommerceManager

```typescript
import { EcommerceManager } from './EcommerceManager';
import { Customer, Order, OrderItem } from './models';

describe('EcommerceManager - Characterization Tests', () => {
  let mockConnection: any;
  let manager: EcommerceManager;

  beforeEach(() => {
    mockConnection = {
      execute: jest.fn(),
      query: jest.fn(),
    };
    manager = new EcommerceManager(mockConnection);
  });

  it('should save customer to database', async () => {
    // Arrange
    const customer: Customer = {
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
    };

    // Act
    await manager.createCustomer(customer);

    // Assert - Document what it actually does
    expect(mockConnection.execute).toHaveBeenCalledWith(
      expect.stringContaining('INSERT INTO customers'),
      expect.any(Object)
    );
  });
});
```

## Step 2: Ensure All Tests Pass

Run your test suite and verify everything is green:

```bash
# C#
dotnet test

# Java
mvn test

# Python
pytest

# TypeScript
npm test
```

**If tests fail**: Fix them before proceeding. You need a stable baseline.

## Step 3: Identify Code Smells

Look for violations of SOLID principles:

### Common Code Smells

**God Class**:
```csharp
// ❌ One class doing everything
public class EcommerceManager
{
    public void CreateCustomer(Customer customer) { }
    public void ProcessOrder(Order order) { }
    public void SendEmail(string to, string subject) { }
    public void GenerateInvoice(Order order) { }
    public void UpdateInventory(int productId, int quantity) { }
    // ... 20 more methods
}
```

**Feature Envy**:
```java
// ❌ Method uses more data from another class
public class OrderService {
    public BigDecimal calculateTotal(Order order) {
        BigDecimal total = BigDecimal.ZERO;
        for (OrderItem item : order.getItems()) {
            total = total.add(
                item.getProduct().getPrice()
                    .multiply(new BigDecimal(item.getQuantity()))
            );
        }
        return total;
    }
}
```

**Long Method**:
```python
# ❌ Method doing too much
def process_order(self, order):
    # Validate order (10 lines)
    # Calculate total (15 lines)
    # Process payment (20 lines)
    # Update inventory (10 lines)
    # Send email (15 lines)
    # Generate invoice (20 lines)
    # 90 lines total!
```

**Primitive Obsession**:
```typescript
// ❌ Using primitives instead of domain objects
function createCustomer(
  id: number,
  name: string,
  email: string,
  street: string,
  city: string,
  state: string,
  zip: string
) {
  // Too many primitive parameters
}
```

## Step 4: Plan Refactoring

Identify what to extract and in what order:

### Example Plan for EcommerceManager

1. **Extract Repository** (Data Access)
   - CustomerRepository
   - OrderRepository
   - ProductRepository

2. **Extract Services** (Business Logic)
   - PriceCalculator
   - InventoryService
   - EmailService

3. **Extract Value Objects** (Domain Concepts)
   - Money
   - EmailAddress
   - CustomerId

4. **Apply Dependency Injection**
   - Inject repositories into services
   - Inject services into manager

## Step 5: Refactor One Thing

Make one small change at a time.

### Example: Extract CustomerRepository (C#)

**Before**:
```csharp
public class EcommerceManager
{
    private readonly IDbConnection _connection;
    
    public void CreateCustomer(Customer customer)
    {
        _connection.Execute(
            "INSERT INTO customers (id, name, email) VALUES (@Id, @Name, @Email)",
            customer
        );
    }
}
```

**After**:
```csharp
// New CustomerRepository class
public class CustomerRepository
{
    private readonly IDbConnection _connection;
    
    public CustomerRepository(IDbConnection connection)
    {
        _connection = connection;
    }
    
    public void Save(Customer customer)
    {
        _connection.Execute(
            "INSERT INTO customers (id, name, email) VALUES (@Id, @Name, @Email)",
            customer
        );
    }
}

// Updated EcommerceManager
public class EcommerceManager
{
    private readonly CustomerRepository _customerRepository;
    
    public EcommerceManager(CustomerRepository customerRepository)
    {
        _customerRepository = customerRepository;
    }
    
    public void CreateCustomer(Customer customer)
    {
        _customerRepository.Save(customer);
    }
}
```

## Step 6: Run Tests

After each refactoring, run your tests:

```bash
# Run tests
dotnet test  # or mvn test, pytest, npm test

# Check for failures
# If any test fails, undo the change and try again
```

**Tests must stay green!** If they turn red:
1. Undo the change
2. Analyze why it failed
3. Make a smaller change
4. Try again

## Step 7: Commit

Commit after each successful refactoring:

```bash
git add .
git commit -m "Extract CustomerRepository from EcommerceManager"
```

**Why commit frequently?**
- Easy to revert if something goes wrong
- Clear history of changes
- Smaller, reviewable commits

## Step 8: Repeat

Continue extracting responsibilities:

### Iteration 2: Extract PriceCalculator

**Test First**:
```csharp
public class PriceCalculatorTests
{
    [Theory]
    [InlineData(10.00, 2, 20.00)]
    [InlineData(15.50, 3, 46.50)]
    public void CalculateItemTotal_ShouldReturnCorrectAmount(
        decimal price, 
        int quantity, 
        decimal expected)
    {
        // Arrange
        var calculator = new PriceCalculator();
        var money = new Money(price, Currency.USD);

        // Act
        var result = calculator.CalculateItemTotal(money, quantity);

        // Assert
        result.Amount.Should().Be(expected);
    }
}
```

**Then Refactor**:
```csharp
public class PriceCalculator
{
    public Money CalculateItemTotal(Money price, int quantity)
    {
        return new Money(price.Amount * quantity, price.Currency);
    }
    
    public Money CalculateOrderTotal(IEnumerable<OrderItem> items)
    {
        var total = 0m;
        foreach (var item in items)
        {
            total += item.Price.Amount * item.Quantity;
        }
        return new Money(total, Currency.USD);
    }
}
```

**Run Tests & Commit**:
```bash
dotnet test
git commit -m "Extract PriceCalculator for order calculations"
```

## Step 9: Review and Clean Up

After all refactoring:

### Review Checklist

- [ ] All tests pass
- [ ] Code follows SOLID principles
- [ ] Each class has single responsibility
- [ ] Dependencies are injected
- [ ] No code duplication
- [ ] Clear naming
- [ ] Proper error handling

### Clean Up Tests

Remove or update characterization tests:

```csharp
// Before: Characterization test
[Fact]
public void ProcessOrder_ShouldCalculateTotalAndSendEmail()
{
    var result = _manager.ProcessOrder(order);
    result.Total.Should().Be(20.00m);
    // This test was documenting bad design
}

// After: Focused unit tests
[Fact]
public void PriceCalculator_ShouldCalculateOrderTotal()
{
    var calculator = new PriceCalculator();
    var result = calculator.CalculateOrderTotal(items);
    result.Amount.Should().Be(20.00m);
}

[Fact]
public void EmailService_ShouldSendOrderConfirmation()
{
    var service = new EmailService(mockSmtp);
    service.SendOrderConfirmation(order);
    mockSmtp.Verify(s => s.Send(It.IsAny<Email>()), Times.Once);
}
```

## Common Pitfalls

### ❌ Refactoring Without Tests

```csharp
// Dangerous: No tests to catch breakage
public void RefactorEverything()
{
    // Change 500 lines of code
    // Hope nothing breaks
}
```

**Solution**: Write characterization tests first.

### ❌ Making Too Many Changes at Once

```csharp
// Dangerous: Can't identify what broke
public void BigBangRefactor()
{
    // Extract 5 classes
    // Change 10 methods
    // Rename everything
    // Tests fail - which change broke it?
}
```

**Solution**: One change at a time, test after each.

### ❌ Ignoring Failing Tests

```bash
# Dangerous: Proceeding with red tests
$ dotnet test
Failed: 3 tests
$ git commit -m "Refactored code"  # DON'T DO THIS!
```

**Solution**: Keep tests green always.

### ❌ Not Committing Frequently

```bash
# Dangerous: Lose work if something goes wrong
# 2 hours of refactoring, no commits
# Something breaks, can't easily revert
```

**Solution**: Commit after each successful refactoring.

## Best Practices

### ✅ Start Small

Begin with the easiest extraction:

```csharp
// Easy: Extract simple utility method
public class StringUtils
{
    public static string FormatEmail(string email)
    {
        return email.Trim().ToLower();
    }
}
```

### ✅ Use IDE Refactoring Tools

Most IDEs have safe refactoring tools:
- Extract Method
- Extract Class
- Rename
- Move

These tools update all references automatically.

### ✅ Keep Tests Fast

```csharp
// Fast: Mock external dependencies
var mockDb = new Mock<IDbConnection>();
var repository = new CustomerRepository(mockDb.Object);

// Slow: Use real database
var realDb = new SqlConnection(connectionString);
var repository = new CustomerRepository(realDb);
```

### ✅ Refactor in Small Sessions

- 30-60 minutes per session
- Take breaks
- Review progress
- Don't rush

## Example: Complete Refactoring Session

### Starting Point

```csharp
public class EcommerceManager
{
    private readonly IDbConnection _connection;
    
    public void CreateCustomer(Customer customer)
    {
        // Validate
        if (string.IsNullOrEmpty(customer.Email))
            throw new ArgumentException("Email required");
            
        // Save
        _connection.Execute(
            "INSERT INTO customers (id, name, email) VALUES (@Id, @Name, @Email)",
            customer
        );
        
        // Send welcome email
        var smtp = new SmtpClient();
        smtp.Send(customer.Email, "Welcome!", "Thanks for joining!");
    }
}
```

### Session 1: Extract Validation (15 minutes)

```csharp
// 1. Write test for validator
[Fact]
public void Validate_ShouldThrowException_WhenEmailEmpty()
{
    var validator = new CustomerValidator();
    var customer = new Customer { Email = "" };
    
    Assert.Throws<ValidationException>(() => validator.Validate(customer));
}

// 2. Extract validator
public class CustomerValidator
{
    public void Validate(Customer customer)
    {
        if (string.IsNullOrEmpty(customer.Email))
            throw new ValidationException("Email required");
    }
}

// 3. Update manager
public void CreateCustomer(Customer customer)
{
    _validator.Validate(customer);
    _connection.Execute(...);
    var smtp = new SmtpClient();
    smtp.Send(...);
}

// 4. Run tests, commit
```

### Session 2: Extract Repository (15 minutes)

```csharp
// 1. Write test for repository
[Fact]
public void Save_ShouldInsertCustomer()
{
    var mockDb = new Mock<IDbConnection>();
    var repository = new CustomerRepository(mockDb.Object);
    
    repository.Save(customer);
    
    mockDb.Verify(db => db.Execute(...), Times.Once);
}

// 2. Extract repository
public class CustomerRepository
{
    public void Save(Customer customer)
    {
        _connection.Execute(
            "INSERT INTO customers (id, name, email) VALUES (@Id, @Name, @Email)",
            customer
        );
    }
}

// 3. Update manager
public void CreateCustomer(Customer customer)
{
    _validator.Validate(customer);
    _repository.Save(customer);
    var smtp = new SmtpClient();
    smtp.Send(...);
}

// 4. Run tests, commit
```

### Session 3: Extract Email Service (15 minutes)

```csharp
// 1. Write test for email service
[Fact]
public void SendWelcomeEmail_ShouldSendEmail()
{
    var mockSmtp = new Mock<ISmtpClient>();
    var service = new EmailService(mockSmtp.Object);
    
    service.SendWelcomeEmail(customer);
    
    mockSmtp.Verify(s => s.Send(...), Times.Once);
}

// 2. Extract email service
public class EmailService
{
    public void SendWelcomeEmail(Customer customer)
    {
        _smtp.Send(customer.Email, "Welcome!", "Thanks for joining!");
    }
}

// 3. Update manager
public void CreateCustomer(Customer customer)
{
    _validator.Validate(customer);
    _repository.Save(customer);
    _emailService.SendWelcomeEmail(customer);
}

// 4. Run tests, commit
```

### Final Result

```csharp
public class EcommerceManager
{
    private readonly CustomerValidator _validator;
    private readonly CustomerRepository _repository;
    private readonly EmailService _emailService;
    
    public EcommerceManager(
        CustomerValidator validator,
        CustomerRepository repository,
        EmailService emailService)
    {
        _validator = validator;
        _repository = repository;
        _emailService = emailService;
    }
    
    public void CreateCustomer(Customer customer)
    {
        _validator.Validate(customer);
        _repository.Save(customer);
        _emailService.SendWelcomeEmail(customer);
    }
}
```

**Result**:
- ✅ Each class has single responsibility
- ✅ All dependencies injected
- ✅ Easy to test each component
- ✅ All tests pass
- ✅ 3 focused commits

## Summary

Test-Driven Refactoring is:
1. **Safe** - Tests catch breakage
2. **Incremental** - Small changes at a time
3. **Reversible** - Easy to undo with git
4. **Confidence-building** - Green tests give assurance

**Remember**: 
- Write tests first
- Refactor one thing at a time
- Keep tests green
- Commit frequently

## Next Steps

1. Practice with [Language-Specific Testing Guides](./README.md#language-specific-guides)
2. Apply to [SOLID Principle Workshops](./README.md#solid-principle-testing-workshops)
3. Use [Assessment Checklist](../assessment/CHECKLIST.md) to validate your work

---

**Key Takeaway**: Tests are your safety net. With good tests, you can refactor fearlessly.
