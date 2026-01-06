# Java Mocking with Mockito

## Overview

Mockito is the most popular mocking framework for Java. This guide covers everything you need to know about using Mockito to create test doubles for your Java tests.

## Installation

```xml
<!-- Maven -->
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-core</artifactId>
    <version>5.8.0</version>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.mockito</groupId>
    <artifactId>mockito-junit-jupiter</artifactId>
    <version>5.8.0</version>
    <scope>test</scope>
</dependency>
```

## Basic Mockito Concepts

### Creating Mocks

```java
// Using @Mock annotation
@ExtendWith(MockitoExtension.class)
class CustomerServiceTest {
    @Mock
    private CustomerRepository mockRepository;
    
    @Test
    void test() {
        // Use mockRepository
    }
}

// Using mock() method
CustomerRepository mockRepository = mock(CustomerRepository.class);
```

### Setup Return Values

```java
// Setup method to return specific value
when(mockRepository.findById(1))
    .thenReturn(new Customer(1, "John", "john@example.com"));

// Multiple calls
when(mockRepository.findById(anyInt()))
    .thenReturn(customer1)
    .thenReturn(customer2)
    .thenReturn(customer3);
```

### Verify Method Calls

```java
// Verify method was called
verify(mockRepository).save(any(Customer.class));

// Verify with times
verify(mockRepository, times(1)).save(any(Customer.class));
verify(mockRepository, never()).delete(anyInt());
```

## Setup Patterns

### Basic Setup

```java
@Test
void getCustomer_shouldReturnCustomer_whenExists() {
    // Arrange
    when(mockRepository.findById(1))
        .thenReturn(new Customer(1, "John Doe", "john@example.com"));
    
    CustomerService service = new CustomerService(mockRepository);
    
    // Act
    Customer result = service.getCustomer(1);
    
    // Assert
    assertThat(result).isNotNull();
    assertThat(result.getName()).isEqualTo("John Doe");
}
```

### Setup with Any Parameter

```java
@Test
void saveCustomer_shouldCallRepository() {
    // Arrange
    CustomerService service = new CustomerService(mockRepository);
    Customer customer = new Customer(1, "John", "john@example.com");
    
    // Act
    service.saveCustomer(customer);
    
    // Assert
    verify(mockRepository).save(any(Customer.class));
}
```

### Setup with Specific Parameter Matching

```java
@Test
void updateCustomer_shouldUpdateSpecificCustomer() {
    // Arrange
    CustomerService service = new CustomerService(mockRepository);
    Customer customer = new Customer(1, "Updated Name", "john@example.com");
    
    // Act
    service.updateCustomer(customer);
    
    // Assert
    verify(mockRepository).update(argThat(c -> 
        c.getId() == 1 && c.getName().equals("Updated Name")
    ));
}
```

### Setup with Answer

```java
@Test
void saveCustomer_shouldAssignId() {
    // Arrange
    AtomicReference<Customer> savedCustomer = new AtomicReference<>();
    
    doAnswer(invocation -> {
        savedCustomer.set(invocation.getArgument(0));
        return null;
    }).when(mockRepository).save(any(Customer.class));
    
    CustomerService service = new CustomerService(mockRepository);
    Customer customer = new Customer(0, "John", "john@example.com");
    
    // Act
    service.saveCustomer(customer);
    
    // Assert
    assertThat(savedCustomer.get()).isNotNull();
    assertThat(savedCustomer.get().getName()).isEqualTo("John");
}
```

### Setup Sequential Returns

```java
@Test
void getCustomer_shouldRetryOnFailure() {
    // Arrange
    when(mockRepository.findById(1))
        .thenReturn(null)  // First call returns null
        .thenReturn(null)  // Second call returns null
        .thenReturn(new Customer(1, "John", "john@example.com"));  // Third succeeds
    
    CustomerService service = new CustomerService(mockRepository);
    
    // Act
    Customer result = service.getCustomerWithRetry(1);
    
    // Assert
    assertThat(result).isNotNull();
    verify(mockRepository, times(3)).findById(1);
}
```

## Argument Matching

### ArgumentMatchers

```java
// Any value of type
when(mockRepository.save(any(Customer.class))).thenReturn(customer);

// Any int
when(mockRepository.findById(anyInt())).thenReturn(customer);

// Any string
when(mockRepository.findByEmail(anyString())).thenReturn(customer);

// Any list
when(mockRepository.saveAll(anyList())).thenReturn(customers);

// Specific value
when(mockRepository.findById(eq(1))).thenReturn(customer);

// Null value
when(mockRepository.save(isNull())).thenThrow(IllegalArgumentException.class);

// Not null
when(mockRepository.save(notNull())).thenReturn(customer);
```

### Custom Matchers with argThat

```java
// Match with predicate
verify(mockRepository).save(argThat(c -> 
    c.getEmail().contains("@") && c.isActive()
));

// Match collection
verify(mockRepository).saveAll(argThat(list -> 
    list.size() == 3 && list.stream().allMatch(Customer::isActive)
));
```

## Exception Handling

### Setup to Throw Exception

```java
@Test
void saveCustomer_shouldHandleDatabaseException() {
    // Arrange
    when(mockRepository.save(any(Customer.class)))
        .thenThrow(new DatabaseException("Connection failed"));
    
    CustomerService service = new CustomerService(mockRepository);
    Customer customer = new Customer(1, "John", "john@example.com");
    
    // Act & Assert
    assertThatThrownBy(() -> service.saveCustomer(customer))
        .isInstanceOf(DatabaseException.class)
        .hasMessageContaining("Connection failed");
}
```

### Using doThrow for void methods

```java
@Test
void deleteCustomer_shouldHandleException() {
    // Arrange
    doThrow(new DatabaseException("Cannot delete"))
        .when(mockRepository).delete(anyInt());
    
    CustomerService service = new CustomerService(mockRepository);
    
    // Act & Assert
    assertThatThrownBy(() -> service.deleteCustomer(1))
        .isInstanceOf(DatabaseException.class);
}
```

## Verification

### Verify Method Called

```java
@Test
void processOrder_shouldSendEmail() {
    // Arrange
    EmailService mockEmailService = mock(EmailService.class);
    OrderService service = new OrderService(mockEmailService);
    Order order = new Order(1, 100, new BigDecimal("50.00"));
    
    // Act
    service.processOrder(order);
    
    // Assert
    verify(mockEmailService).sendOrderConfirmation(argThat(o -> o.getId() == 1));
}
```

### Verify with Times

```java
// Verify called exactly once
verify(mock).method();
verify(mock, times(1)).method();

// Verify called exactly N times
verify(mock, times(3)).method();

// Verify never called
verify(mock, never()).method();

// Verify at least once
verify(mock, atLeastOnce()).method();

// Verify at most N times
verify(mock, atMost(5)).method();

// Verify at least N times
verify(mock, atLeast(2)).method();
```

### Verify Order of Calls

```java
@Test
void processOrder_shouldCallMethodsInOrder() {
    // Arrange
    InOrder inOrder = inOrder(mockRepository, mockEmailService);
    
    // Act
    service.processOrder(order);
    
    // Assert
    inOrder.verify(mockRepository).save(any(Order.class));
    inOrder.verify(mockEmailService).sendConfirmation(any(Order.class));
}
```

### Verify No More Interactions

```java
@Test
void service_shouldOnlyCallExpectedMethods() {
    // Act
    service.doSomething();
    
    // Assert
    verify(mockRepository).findById(1);
    verifyNoMoreInteractions(mockRepository);
}
```

## Advanced Patterns

### Spy Objects

```java
// Spy wraps a real object
List<String> list = new ArrayList<>();
List<String> spyList = spy(list);

// Real method is called
spyList.add("one");
assertThat(spyList).hasSize(1);

// Can stub specific methods
when(spyList.size()).thenReturn(100);
assertThat(spyList.size()).isEqualTo(100);
```

### Partial Mocking

```java
@Test
void partialMock_shouldCallRealMethod() {
    // Arrange
    CustomerService service = spy(new CustomerService(mockRepository));
    
    // Stub one method
    doReturn(true).when(service).isValidCustomer(any(Customer.class));
    
    // Other methods call real implementation
    Customer result = service.createCustomer("John", "john@example.com");
    
    assertThat(result).isNotNull();
}
```

### Capturing Arguments

```java
@Test
void saveCustomer_shouldSetTimestamp() {
    // Arrange
    ArgumentCaptor<Customer> captor = ArgumentCaptor.forClass(Customer.class);
    CustomerService service = new CustomerService(mockRepository);
    
    // Act
    service.saveCustomer(new Customer(1, "John", "john@example.com"));
    
    // Assert
    verify(mockRepository).save(captor.capture());
    Customer captured = captor.getValue();
    assertThat(captured.getCreatedAt()).isNotNull();
}
```

### Mock Final Classes

```java
// Mockito can mock final classes (since version 2.1.0)
final class FinalClass {
    public String method() {
        return "real";
    }
}

@Test
void canMockFinalClass() {
    FinalClass mock = mock(FinalClass.class);
    when(mock.method()).thenReturn("mocked");
    
    assertThat(mock.method()).isEqualTo("mocked");
}
```

## Testing with Multiple Mocks

```java
@ExtendWith(MockitoExtension.class)
class OrderServiceTest {
    @Mock
    private ProductRepository mockProductRepo;
    
    @Mock
    private InventoryService mockInventory;
    
    @Mock
    private PaymentService mockPayment;
    
    @Mock
    private EmailService mockEmail;
    
    @InjectMocks
    private OrderService service;
    
    @Test
    void processOrder_shouldCoordinateServices() {
        // Arrange
        Product product = new Product(1, "Product", new BigDecimal("10.00"));
        when(mockProductRepo.findById(1)).thenReturn(product);
        when(mockInventory.checkAvailability(1, 2)).thenReturn(true);
        when(mockPayment.processPayment(any(BigDecimal.class)))
            .thenReturn(new PaymentResult(true, "txn_123"));
        
        Order order = new Order(1, Arrays.asList(new OrderItem(1, 2)));
        
        // Act
        OrderResult result = service.processOrder(order);
        
        // Assert
        assertThat(result.isSuccess()).isTrue();
        verify(mockInventory).checkAvailability(1, 2);
        verify(mockPayment).processPayment(new BigDecimal("20.00"));
        verify(mockEmail).sendOrderConfirmation(any(Order.class));
    }
}
```

## Common Patterns

### Repository Pattern

```java
@Test
void getCustomer_shouldUseRepository() {
    // Arrange
    when(mockRepository.findById(1))
        .thenReturn(new Customer(1, "John", "john@example.com"));
    
    CustomerService service = new CustomerService(mockRepository);
    
    // Act
    Customer result = service.getCustomer(1);
    
    // Assert
    assertThat(result).isNotNull();
    verify(mockRepository).findById(1);
}
```

### Unit of Work Pattern

```java
@Test
void saveChanges_shouldCommitTransaction() {
    // Arrange
    UnitOfWork mockUnitOfWork = mock(UnitOfWork.class);
    CustomerRepository mockRepository = mock(CustomerRepository.class);
    
    when(mockUnitOfWork.getCustomers()).thenReturn(mockRepository);
    
    CustomerService service = new CustomerService(mockUnitOfWork);
    Customer customer = new Customer(1, "John", "john@example.com");
    
    // Act
    service.createCustomer(customer);
    
    // Assert
    verify(mockRepository).add(customer);
    verify(mockUnitOfWork).commit();
}
```

## Best Practices

### ✅ Do's

```java
// Use ArgumentMatchers for flexible matching
verify(mock).method(any(Customer.class));

// Verify important interactions
verify(mock).criticalMethod();

// Use descriptive variable names
CustomerRepository mockCustomerRepository = mock(CustomerRepository.class);

// Setup only what you need
when(mock.getData()).thenReturn(data);
```

### ❌ Don'ts

```java
// Don't mock what you don't own
HttpClient mockHttpClient = mock(HttpClient.class); // Bad

// Don't over-verify
verify(mock, times(5)).logDebug(anyString()); // Too brittle

// Don't mock value objects
Money mockMoney = mock(Money.class); // Bad - use real Money

// Don't use lenient() unless necessary
lenient().when(mock.method()).thenReturn(value); // Usually indicates design issue
```

## Troubleshooting

### Setup Not Working

```java
// Problem: Setup doesn't match call
when(mock.method(1)).thenReturn(value);
mock.method(2); // Different parameter!

// Solution: Use ArgumentMatchers
when(mock.method(anyInt())).thenReturn(value);
```

### Verify Failing

```java
// Problem: Verification too strict
verify(mock).method(argThat(c -> c.getId() == 1 && c.getName().equals("John")));

// Solution: Verify only what matters
verify(mock).method(argThat(c -> c.getId() == 1));
```

### UnnecessaryStubbingException

```java
// Problem: Stubbed but never used
when(mock.unusedMethod()).thenReturn(value); // Never called

// Solution: Remove unused stubs or use lenient()
lenient().when(mock.unusedMethod()).thenReturn(value);
```

## Summary

**Key Mockito Concepts**:
- Setup return values with `when().thenReturn()`
- Match parameters with `any()`, `eq()`, `argThat()`
- Verify calls with `verify()`
- Use `@Mock` and `@InjectMocks` for cleaner tests
- Capture arguments with `ArgumentCaptor`
- Mock interfaces, not concrete classes

## Next Steps

1. Review [Testing Patterns](./01-TESTING-PATTERNS.md)
2. Learn [Integration Testing](./03-INTEGRATION-TESTING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Mockito makes it easy to create test doubles. Use it to isolate your code under test and verify important interactions.
