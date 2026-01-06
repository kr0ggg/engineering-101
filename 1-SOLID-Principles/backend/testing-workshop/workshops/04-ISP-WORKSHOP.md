# Interface Segregation Principle (ISP) Testing Workshop

## Objective

Learn to identify ISP violations, write focused interface tests, and refactor fat interfaces into role-specific interfaces that clients actually need.

## The Problem

The `ICustomerService` interface has too many methods, forcing implementations to provide methods they don't use and clients to depend on methods they don't need.

## Workshop Steps

### Step 1: Identify Fat Interface (15 minutes)

**Current Implementation**:
```java
public interface ICustomerService {
    // Read operations
    Customer findById(int id);
    Customer findByEmail(String email);
    List<Customer> findAll();
    List<Customer> findActive();
    
    // Write operations
    void save(Customer customer);
    void update(Customer customer);
    void delete(int id);
    
    // Validation
    ValidationResult validate(Customer customer);
    
    // Notifications
    void sendWelcomeEmail(Customer customer);
    void sendPasswordReset(Customer customer);
    
    // Reporting
    Report generateCustomerReport();
    Statistics getCustomerStatistics();
}
```

**Problem**: 13 methods - too many responsibilities!

### Step 2: Analyze Client Usage (20 minutes)

**Task**: Document which clients use which methods

```java
// CustomerDisplayController - only needs read operations
public class CustomerDisplayController {
    private final ICustomerService service;
    
    public void showCustomer(int id) {
        Customer customer = service.findById(id);
        // Only uses findById, findByEmail, findAll
    }
}

// CustomerManagementController - needs read + write
public class CustomerManagementController {
    private final ICustomerService service;
    
    public void createCustomer(Customer customer) {
        service.save(customer);
        // Uses save, update, delete, validate
    }
}
```

### Step 3: Extract Focused Interfaces (30 minutes)

```java
public interface ICustomerReader {
    Customer findById(int id);
    Customer findByEmail(String email);
    List<Customer> findAll();
    List<Customer> findActive();
}

public interface ICustomerWriter {
    void save(Customer customer);
    void update(Customer customer);
    void delete(int id);
}

public interface ICustomerValidator {
    ValidationResult validate(Customer customer);
}

public interface ICustomerNotifier {
    void sendWelcomeEmail(Customer customer);
    void sendPasswordReset(Customer customer);
}

public interface ICustomerReporter {
    Report generateCustomerReport();
    Statistics getCustomerStatistics();
}
```

### Step 4: Write Interface Tests (45 minutes)

**Reader Tests**:
```java
@Test
void findById_shouldReturnCustomerWhenExists() {
    ICustomerReader reader = mock(ICustomerReader.class);
    when(reader.findById(1)).thenReturn(new Customer(1, "John", "john@example.com"));
    
    Customer customer = reader.findById(1);
    
    assertNotNull(customer);
    assertEquals("John", customer.getName());
}

@Test
void findAll_shouldReturnList() {
    ICustomerReader reader = mock(ICustomerReader.class);
    when(reader.findAll()).thenReturn(Arrays.asList(
        new Customer(1, "John", "john@example.com"),
        new Customer(2, "Jane", "jane@example.com")
    ));
    
    List<Customer> customers = reader.findAll();
    
    assertEquals(2, customers.size());
}
```

**Writer Tests**:
```java
@Test
void save_shouldPersistCustomer() {
    ICustomerWriter writer = mock(ICustomerWriter.class);
    Customer customer = new Customer(1, "John", "john@example.com");
    
    assertDoesNotThrow(() -> writer.save(customer));
    
    verify(writer).save(customer);
}
```

### Step 5: Implement Focused Services (45 minutes)

```java
public class CustomerService implements 
    ICustomerReader, 
    ICustomerWriter, 
    ICustomerValidator {
    
    private final CustomerRepository repository;
    
    public CustomerService(CustomerRepository repository) {
        this.repository = repository;
    }
    
    // ICustomerReader implementation
    @Override
    public Customer findById(int id) {
        return repository.findById(id);
    }
    
    @Override
    public List<Customer> findAll() {
        return repository.findAll();
    }
    
    // ICustomerWriter implementation
    @Override
    public void save(Customer customer) {
        repository.save(customer);
    }
    
    // ICustomerValidator implementation
    @Override
    public ValidationResult validate(Customer customer) {
        if (customer.getEmail() == null) {
            return ValidationResult.failure("Email required");
        }
        return ValidationResult.success();
    }
}

public class CustomerNotificationService implements ICustomerNotifier {
    private final EmailService emailService;
    
    @Override
    public void sendWelcomeEmail(Customer customer) {
        emailService.send(customer.getEmail(), "Welcome!", "Hello " + customer.getName());
    }
    
    @Override
    public void sendPasswordReset(Customer customer) {
        // Implementation
    }
}

public class CustomerReportService implements ICustomerReporter {
    private final ICustomerReader customerReader;
    
    @Override
    public Report generateCustomerReport() {
        List<Customer> customers = customerReader.findAll();
        return new Report(customers);
    }
    
    @Override
    public Statistics getCustomerStatistics() {
        // Implementation
    }
}
```

### Step 6: Refactor Clients (30 minutes)

**Before**:
```java
public class CustomerDisplayController {
    private final ICustomerService service; // Depends on 13 methods
    
    public void showCustomer(int id) {
        Customer customer = service.findById(id);
        // Only uses 3 of 13 methods
    }
}
```

**After**:
```java
public class CustomerDisplayController {
    private final ICustomerReader reader; // Depends on 4 methods only
    
    public CustomerDisplayController(ICustomerReader reader) {
        this.reader = reader;
    }
    
    public void showCustomer(int id) {
        Customer customer = reader.findById(id);
        // Clear dependency - only needs read operations
    }
}
```

**Tests**:
```java
@Test
void showCustomer_shouldDisplayCustomer() {
    ICustomerReader mockReader = mock(ICustomerReader.class);
    when(mockReader.findById(1)).thenReturn(new Customer(1, "John", "john@example.com"));
    
    CustomerDisplayController controller = new CustomerDisplayController(mockReader);
    
    controller.showCustomer(1);
    
    verify(mockReader).findById(1);
    // Easy to test - only mock what's needed!
}
```

### Step 7: Verify Improvements (15 minutes)

**Metrics**:

| Metric | Before | After |
|--------|--------|-------|
| Interface methods | 13 | 2-4 per interface |
| Client dependencies | 13 methods | 2-4 methods |
| Test complexity | High | Low |
| Unused methods | Many | None |

## Comparison

### Before ISP
- Fat interface with 13 methods
- Clients depend on unused methods
- Hard to mock (must setup all methods)
- Implementations forced to provide unused methods
- Changes affect all clients

### After ISP
- Focused interfaces (2-4 methods each)
- Clients depend only on what they need
- Easy to mock (only relevant methods)
- Implementations provide only needed methods
- Changes are localized

## Benefits

- ✅ Clients depend only on methods they use
- ✅ Easier to test (smaller mocks)
- ✅ Easier to implement
- ✅ More flexible composition
- ✅ Better separation of concerns

## Assessment Checklist

- [ ] Fat interfaces identified and split
- [ ] Each interface has focused responsibility
- [ ] Clients updated to use specific interfaces
- [ ] All tests updated and passing
- [ ] No client depends on unused methods
- [ ] Implementations are simpler
- [ ] Test complexity reduced

## Next Steps

1. Apply ISP to other fat interfaces
2. Move to [DIP Workshop](./05-DIP-WORKSHOP.md)

---

**Key Takeaway**: ISP prevents clients from depending on methods they don't use. Create focused, role-specific interfaces.
