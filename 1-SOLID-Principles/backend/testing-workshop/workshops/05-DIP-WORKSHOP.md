# Dependency Inversion Principle (DIP) Testing Workshop

## Objective

Learn to identify DIP violations, write testable code using dependency injection, and refactor concrete dependencies to abstractions.

## The Problem

The `OrderService` directly instantiates its dependencies, making it hard to test and tightly coupled to concrete implementations.

## Workshop Steps

### Step 1: Identify DIP Violation (15 minutes)

**Current Implementation**:
```java
public class OrderService {
    private final ProductRepository productRepository = new ProductRepository();
    private final EmailService emailService = new EmailService();
    private final PaymentGateway paymentGateway = new PaymentGateway();
    
    public Order createOrder(int customerId, List<OrderItem> items) {
        // Uses concrete dependencies
        List<Product> products = productRepository.findByIds(items);
        Money total = calculateTotal(items, products);
        paymentGateway.processPayment(total);
        emailService.sendOrderConfirmation(customerId);
        return new Order(customerId, items, total);
    }
}
```

**Problems**:
- Hard to test (needs real database, email, payment gateway)
- Tightly coupled to concrete implementations
- Can't swap implementations
- Violates DIP (depends on low-level modules)

### Step 2: Attempt to Test (20 minutes)

**Current Test Challenges**:
```java
@Test
void createOrder_shouldProcessOrder() {
    OrderService service = new OrderService();
    // Problem: Uses real ProductRepository (needs database)
    // Problem: Uses real EmailService (sends real emails)
    // Problem: Uses real PaymentGateway (charges real money!)
    
    // Can't test without real infrastructure
}
```

### Step 3: Create Abstractions (30 minutes)

```java
public interface IProductRepository {
    List<Product> findByIds(List<Integer> ids);
}

public interface IEmailService {
    void sendOrderConfirmation(int customerId);
}

public interface IPaymentGateway {
    PaymentResult processPayment(Money amount);
}
```

### Step 4: Refactor to Use Dependency Injection (45 minutes)

**After**:
```java
public class OrderService {
    private final IProductRepository productRepository;
    private final IEmailService emailService;
    private final IPaymentGateway paymentGateway;
    
    public OrderService(
        IProductRepository productRepository,
        IEmailService emailService,
        IPaymentGateway paymentGateway
    ) {
        this.productRepository = productRepository;
        this.emailService = emailService;
        this.paymentGateway = paymentGateway;
    }
    
    public Order createOrder(int customerId, List<OrderItem> items) {
        List<Product> products = productRepository.findByIds(items);
        Money total = calculateTotal(items, products);
        
        PaymentResult payment = paymentGateway.processPayment(total);
        if (!payment.isSuccess()) {
            throw new PaymentException("Payment failed");
        }
        
        emailService.sendOrderConfirmation(customerId);
        return new Order(customerId, items, total);
    }
}
```

### Step 5: Write Testable Tests (45 minutes)

**Now Easy to Test**:
```java
@Test
void createOrder_shouldProcessOrderSuccessfully() {
    // Arrange - Mock all dependencies
    IProductRepository mockProductRepo = mock(IProductRepository.class);
    IEmailService mockEmailService = mock(IEmailService.class);
    IPaymentGateway mockPaymentGateway = mock(IPaymentGateway.class);
    
    List<Product> products = Arrays.asList(
        new Product(1, "Widget", new Money(10)),
        new Product(2, "Gadget", new Money(20))
    );
    when(mockProductRepo.findByIds(anyList())).thenReturn(products);
    when(mockPaymentGateway.processPayment(any())).thenReturn(PaymentResult.success());
    
    OrderService service = new OrderService(
        mockProductRepo,
        mockEmailService,
        mockPaymentGateway
    );
    
    List<OrderItem> items = Arrays.asList(
        new OrderItem(1, 2),
        new OrderItem(2, 1)
    );
    
    // Act
    Order order = service.createOrder(100, items);
    
    // Assert
    assertNotNull(order);
    assertEquals(new Money(40), order.getTotal());
    verify(mockPaymentGateway).processPayment(new Money(40));
    verify(mockEmailService).sendOrderConfirmation(100);
}

@Test
void createOrder_shouldThrowExceptionWhenPaymentFails() {
    // Arrange
    IProductRepository mockProductRepo = mock(IProductRepository.class);
    IEmailService mockEmailService = mock(IEmailService.class);
    IPaymentGateway mockPaymentGateway = mock(IPaymentGateway.class);
    
    when(mockProductRepo.findByIds(anyList())).thenReturn(Arrays.asList(
        new Product(1, "Widget", new Money(10))
    ));
    when(mockPaymentGateway.processPayment(any())).thenReturn(PaymentResult.failure());
    
    OrderService service = new OrderService(
        mockProductRepo,
        mockEmailService,
        mockPaymentGateway
    );
    
    // Act & Assert
    assertThrows(PaymentException.class, () -> 
        service.createOrder(100, Arrays.asList(new OrderItem(1, 1)))
    );
    
    // Verify email was NOT sent
    verify(mockEmailService, never()).sendOrderConfirmation(anyInt());
}
```

### Step 6: Implement Concrete Classes (30 minutes)

```java
public class ProductRepository implements IProductRepository {
    private final Connection connection;
    
    public ProductRepository(Connection connection) {
        this.connection = connection;
    }
    
    @Override
    public List<Product> findByIds(List<Integer> ids) {
        // Real database implementation
    }
}

public class EmailService implements IEmailService {
    private final SmtpClient smtpClient;
    
    public EmailService(SmtpClient smtpClient) {
        this.smtpClient = smtpClient;
    }
    
    @Override
    public void sendOrderConfirmation(int customerId) {
        // Real email implementation
    }
}

public class PaymentGateway implements IPaymentGateway {
    private final String apiKey;
    
    public PaymentGateway(String apiKey) {
        this.apiKey = apiKey;
    }
    
    @Override
    public PaymentResult processPayment(Money amount) {
        // Real payment processing
    }
}
```

### Step 7: Configure Dependency Injection (20 minutes)

**Manual DI**:
```java
public class Application {
    public static void main(String[] args) {
        // Create dependencies
        Connection connection = createDatabaseConnection();
        IProductRepository productRepo = new ProductRepository(connection);
        
        SmtpClient smtpClient = new SmtpClient("smtp.example.com");
        IEmailService emailService = new EmailService(smtpClient);
        
        IPaymentGateway paymentGateway = new PaymentGateway("api-key");
        
        // Inject dependencies
        OrderService orderService = new OrderService(
            productRepo,
            emailService,
            paymentGateway
        );
        
        // Use service
        orderService.createOrder(100, items);
    }
}
```

**Or Use DI Framework** (Spring, Guice, etc.):
```java
@Component
public class OrderService {
    private final IProductRepository productRepository;
    private final IEmailService emailService;
    private final IPaymentGateway paymentGateway;
    
    @Autowired
    public OrderService(
        IProductRepository productRepository,
        IEmailService emailService,
        IPaymentGateway paymentGateway
    ) {
        this.productRepository = productRepository;
        this.emailService = emailService;
        this.paymentGateway = paymentGateway;
    }
}
```

### Step 8: Test with Different Implementations (15 minutes)

**Easy to Swap Implementations**:
```java
@Test
void createOrder_worksWithDifferentPaymentGateway() {
    // Use different payment gateway implementation
    IPaymentGateway stripeGateway = new StripePaymentGateway("stripe-key");
    
    OrderService service = new OrderService(
        mockProductRepo,
        mockEmailService,
        stripeGateway  // Different implementation!
    );
    
    // Service works the same way
}

@Test
void createOrder_worksWithMockImplementations() {
    // Use mocks for testing
    OrderService service = new OrderService(
        mock(IProductRepository.class),
        mock(IEmailService.class),
        mock(IPaymentGateway.class)
    );
    
    // Easy to test in isolation
}
```

## Comparison

### Before DIP
```java
// Tightly coupled to concrete classes
private final ProductRepository productRepository = new ProductRepository();
private final EmailService emailService = new EmailService();

// Hard to test
@Test
void test() {
    OrderService service = new OrderService();
    // Uses real dependencies - can't test!
}
```

### After DIP
```java
// Depends on abstractions
private final IProductRepository productRepository;
private final IEmailService emailService;

// Easy to test
@Test
void test() {
    OrderService service = new OrderService(
        mock(IProductRepository.class),
        mock(IEmailService.class),
        mock(IPaymentGateway.class)
    );
    // Full control over dependencies!
}
```

## Benefits

- ✅ Easy to test with mocks
- ✅ Easy to swap implementations
- ✅ Loose coupling
- ✅ Flexible and maintainable
- ✅ Follows other SOLID principles

## Assessment Checklist

- [ ] All dependencies are abstractions (interfaces)
- [ ] Dependencies injected via constructor
- [ ] No direct instantiation of dependencies
- [ ] Easy to test with mocks
- [ ] Easy to swap implementations
- [ ] All tests pass
- [ ] Integration tests verify real implementations

## Summary

**DIP Transformation**:
1. Identify concrete dependencies
2. Create abstractions (interfaces)
3. Inject dependencies via constructor
4. Test with mocks
5. Configure real implementations at runtime

---

**Key Takeaway**: DIP makes code testable and flexible. Depend on abstractions, not concrete implementations. Use dependency injection to provide implementations.
