# Single Responsibility Principle (SRP) Testing Workshop

## Objective

Learn to identify SRP violations, write characterization tests, and refactor code into focused, testable components while maintaining functionality.

## Prerequisites

- Complete [Testing Philosophy](../00-TESTING-PHILOSOPHY.md)
- Complete [TDD Refactoring Process](../01-TDD-REFACTORING-PROCESS.md)
- Understand your language's testing framework

## The Problem

The `EcommerceManager` class in the reference application violates SRP by handling multiple responsibilities:
- Customer validation
- Order processing
- Inventory management
- Email notifications
- Logging

## Workshop Steps

### Step 1: Write Characterization Tests (30 minutes)

Before refactoring, write tests that capture current behavior.

**Task**: Create tests for `EcommerceManager.createCustomer()`

```java
// Java example
@Test
void createCustomer_shouldValidateAndSaveCustomer() {
    // Arrange
    EcommerceManager manager = new EcommerceManager();
    Customer customer = new Customer("John", "john@example.com");
    
    // Act
    Result result = manager.createCustomer(customer);
    
    // Assert
    assertTrue(result.isSuccess());
    // Verify customer was saved
    // Verify email was sent
    // Verify log entry was created
}

@Test
void createCustomer_shouldFailWithInvalidEmail() {
    // Test validation
}
```

**Deliverable**: Test suite with 80%+ coverage of current behavior

### Step 2: Identify Responsibilities (15 minutes)

Analyze the code and list all responsibilities:

1. **Validation**: Email format, required fields
2. **Persistence**: Save to database
3. **Notification**: Send welcome email
4. **Logging**: Record activity
5. **Business Logic**: Customer creation rules

**Task**: Document each responsibility and its dependencies

### Step 3: Extract Validation (45 minutes)

Create a focused `CustomerValidator` class.

**Before**:
```java
public class EcommerceManager {
    public Result createCustomer(Customer customer) {
        // Validation logic mixed with other concerns
        if (customer.getEmail() == null || !customer.getEmail().contains("@")) {
            return Result.failure("Invalid email");
        }
        // ... more code
    }
}
```

**After**:
```java
public class CustomerValidator {
    public ValidationResult validate(Customer customer) {
        if (customer.getEmail() == null) {
            return ValidationResult.failure("Email is required");
        }
        if (!isValidEmail(customer.getEmail())) {
            return ValidationResult.failure("Invalid email format");
        }
        return ValidationResult.success();
    }
    
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
}
```

**Tests**:
```java
@Test
void validate_shouldFailWhenEmailIsNull() {
    CustomerValidator validator = new CustomerValidator();
    Customer customer = new Customer("John", null);
    
    ValidationResult result = validator.validate(customer);
    
    assertFalse(result.isValid());
    assertTrue(result.getErrors().contains("Email is required"));
}

@ParameterizedTest
@ValueSource(strings = {"invalid", "@example.com", "user@", "user"})
void validate_shouldFailWithInvalidEmailFormat(String invalidEmail) {
    CustomerValidator validator = new CustomerValidator();
    Customer customer = new Customer("John", invalidEmail);
    
    ValidationResult result = validator.validate(customer);
    
    assertFalse(result.isValid());
}
```

**Deliverable**: `CustomerValidator` class with comprehensive tests

### Step 4: Extract Notification (45 minutes)

Create a focused `CustomerNotificationService` class.

**After**:
```java
public class CustomerNotificationService {
    private final EmailService emailService;
    
    public CustomerNotificationService(EmailService emailService) {
        this.emailService = emailService;
    }
    
    public void sendWelcomeEmail(Customer customer) {
        String subject = "Welcome to our store!";
        String body = String.format("Hello %s, welcome!", customer.getName());
        emailService.send(customer.getEmail(), subject, body);
    }
}
```

**Tests**:
```java
@Test
void sendWelcomeEmail_shouldSendEmailWithCorrectContent() {
    EmailService mockEmailService = mock(EmailService.class);
    CustomerNotificationService service = new CustomerNotificationService(mockEmailService);
    Customer customer = new Customer("John", "john@example.com");
    
    service.sendWelcomeEmail(customer);
    
    verify(mockEmailService).send(
        eq("john@example.com"),
        eq("Welcome to our store!"),
        contains("Hello John")
    );
}
```

**Deliverable**: `CustomerNotificationService` class with tests

### Step 5: Extract Repository (45 minutes)

Create a focused `CustomerRepository` class.

**After**:
```java
public class CustomerRepository {
    private final Connection connection;
    
    public CustomerRepository(Connection connection) {
        this.connection = connection;
    }
    
    public void save(Customer customer) throws SQLException {
        String sql = "INSERT INTO customers (name, email) VALUES (?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, customer.getName());
            stmt.setString(2, customer.getEmail());
            stmt.executeUpdate();
        }
    }
    
    public Customer findByEmail(String email) throws SQLException {
        // Implementation
    }
}
```

**Tests**:
```java
@Test
void save_shouldPersistCustomerToDatabase() throws SQLException {
    // Use test database or mock
    Connection mockConnection = mock(Connection.class);
    PreparedStatement mockStmt = mock(PreparedStatement.class);
    when(mockConnection.prepareStatement(anyString())).thenReturn(mockStmt);
    
    CustomerRepository repository = new CustomerRepository(mockConnection);
    Customer customer = new Customer("John", "john@example.com");
    
    repository.save(customer);
    
    verify(mockStmt).setString(1, "John");
    verify(mockStmt).setString(2, "john@example.com");
    verify(mockStmt).executeUpdate();
}
```

**Deliverable**: `CustomerRepository` class with tests

### Step 6: Refactor EcommerceManager (30 minutes)

Now compose the focused classes.

**After**:
```java
public class CustomerService {
    private final CustomerValidator validator;
    private final CustomerRepository repository;
    private final CustomerNotificationService notificationService;
    
    public CustomerService(
        CustomerValidator validator,
        CustomerRepository repository,
        CustomerNotificationService notificationService
    ) {
        this.validator = validator;
        this.repository = repository;
        this.notificationService = notificationService;
    }
    
    public Result createCustomer(Customer customer) {
        // Validate
        ValidationResult validation = validator.validate(customer);
        if (!validation.isValid()) {
            return Result.failure(validation.getErrors());
        }
        
        // Save
        try {
            repository.save(customer);
        } catch (SQLException e) {
            return Result.failure("Failed to save customer");
        }
        
        // Notify
        notificationService.sendWelcomeEmail(customer);
        
        return Result.success();
    }
}
```

**Tests**:
```java
@Test
void createCustomer_shouldCoordinateAllServices() {
    // Arrange
    CustomerValidator mockValidator = mock(CustomerValidator.class);
    CustomerRepository mockRepository = mock(CustomerRepository.class);
    CustomerNotificationService mockNotification = mock(CustomerNotificationService.class);
    
    when(mockValidator.validate(any())).thenReturn(ValidationResult.success());
    
    CustomerService service = new CustomerService(
        mockValidator,
        mockRepository,
        mockNotification
    );
    
    Customer customer = new Customer("John", "john@example.com");
    
    // Act
    Result result = service.createCustomer(customer);
    
    // Assert
    assertTrue(result.isSuccess());
    verify(mockValidator).validate(customer);
    verify(mockRepository).save(customer);
    verify(mockNotification).sendWelcomeEmail(customer);
}
```

**Deliverable**: Refactored `CustomerService` with integration tests

### Step 7: Verify Original Tests Still Pass (15 minutes)

Run all original characterization tests to ensure behavior hasn't changed.

```bash
# Run all tests
mvn test  # Java
pytest    # Python
npm test  # TypeScript
dotnet test  # C#
```

**Success Criteria**: All original tests pass without modification

## Comparison

### Before SRP

**Problems**:
- 300+ lines in one class
- 5 different responsibilities
- Hard to test (need database, email, etc.)
- Changes ripple across unrelated code
- Difficult to reuse logic

### After SRP

**Benefits**:
- 5 focused classes (< 50 lines each)
- Each class has one responsibility
- Easy to test in isolation
- Changes are localized
- Reusable components

## Metrics

Track these metrics before and after:

| Metric | Before | After |
|--------|--------|-------|
| Lines per class | 300+ | < 50 |
| Responsibilities | 5 | 1 |
| Test complexity | High | Low |
| Test coverage | 60% | 95% |
| Cyclomatic complexity | 15 | 3 |

## Common Mistakes

### 1. Over-Extraction
Don't create a class for every method. Group related functionality.

### 2. Shared State
Ensure extracted classes don't share mutable state.

### 3. Breaking Encapsulation
Don't expose internal details just to make testing easier.

### 4. Forgetting Tests
Write tests for each extracted class, not just the original.

## Assessment Checklist

- [ ] All original tests still pass
- [ ] Each extracted class has one clear responsibility
- [ ] Each class has comprehensive unit tests
- [ ] Integration tests verify classes work together
- [ ] Test coverage is 80%+
- [ ] No code duplication
- [ ] Classes are < 200 lines
- [ ] Methods are < 20 lines
- [ ] Clear, descriptive names

## Next Steps

1. Apply SRP to other classes in the reference application
2. Move to [OCP Workshop](./02-OCP-WORKSHOP.md)
3. Review [Assessment Checklist](../assessment/CHECKLIST.md)

## Resources

- [Testing Philosophy](../00-TESTING-PHILOSOPHY.md)
- [TDD Refactoring Process](../01-TDD-REFACTORING-PROCESS.md)
- [Best Practices](../03-BEST-PRACTICES.md)

---

**Key Takeaway**: SRP makes code easier to understand, test, and maintain. Each class should have one reason to change.
