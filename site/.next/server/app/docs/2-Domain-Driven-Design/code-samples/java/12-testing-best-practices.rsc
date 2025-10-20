1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"12-testing-best-practices\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T7aed,<h1>Testing Best Practices - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing">Best Practices for DDD Unit Testing</a></p>
<p><strong>Navigation</strong>: <a href="./11-testing-anti-patterns.md">← Previous: Testing Anti-Patterns</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - Testing Best Practices for DDD Unit Testing
// File: 2-Domain-Driven-Design/code-samples/java/12-testing-best-practices.java

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

// ✅ GOOD: Testing Best Practices for DDD Unit Testing
@DisplayName(&quot;Testing Best Practices for DDD Unit Testing&quot;)
class TestingBestPracticesTest {
    
    @Nested
    @DisplayName(&quot;Test Behavior, Not Implementation&quot;)
    class TestBehaviorNotImplementationTests {
        
        @Test
        @DisplayName(&quot;✅ GOOD: Test business behavior&quot;)
        void shouldCalculateOrderTotalCorrectly() {
            // ✅ Test what the system does, not how it does it
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
            order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(25.50, &quot;USD&quot;));
            
            // ✅ Test business behavior
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(57.48, &quot;USD&quot;));
            assertThat(order.canBeConfirmed()).isTrue();
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Test business rules&quot;)
        void shouldEnforceMinimumOrderAmount() {
            // ✅ Test business rules
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(5.00, &quot;USD&quot;)); // Below $10 minimum
            
            // ✅ Test business rule enforcement
            assertThat(order.canBeConfirmed()).isFalse();
            
            order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(10.00, &quot;USD&quot;));
            assertThat(order.canBeConfirmed()).isTrue();
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Test value object behavior&quot;)
        void shouldHandleMoneyOperationsCorrectly() {
            // ✅ Test value object behavior
            Money money1 = Money.of(100.00, &quot;USD&quot;);
            Money money2 = Money.of(50.00, &quot;USD&quot;);
            
            // ✅ Test value object operations
            Money sum = money1.add(money2);
            Money difference = money1.subtract(money2);
            Money product = money1.multiply(2.0);
            
            assertThat(sum).isEqualTo(Money.of(150.00, &quot;USD&quot;));
            assertThat(difference).isEqualTo(Money.of(50.00, &quot;USD&quot;));
            assertThat(product).isEqualTo(Money.of(200.00, &quot;USD&quot;));
        }
    }
    
    @Nested
    @DisplayName(&quot;Use Descriptive Test Names&quot;)
    class UseDescriptiveTestNamesTests {
        
        @Test
        @DisplayName(&quot;✅ GOOD: Should register customer with valid name and email&quot;)
        void shouldRegisterCustomerWithValidNameAndEmail() {
            // ✅ Test name describes the behavior
            CustomerRepository mockRepository = mock(CustomerRepository.class);
            EmailService mockEmailService = mock(EmailService.class);
            
            CustomerService customerService = new CustomerService(mockRepository, mockEmailService);
            
            when(mockRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            doNothing().when(mockRepository).save(any(Customer.class));
            doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            Customer customer = customerService.registerCustomer(&quot;John Doe&quot;, &quot;john.doe@example.com&quot;);
            
            assertThat(customer.getName()).isEqualTo(&quot;John Doe&quot;);
            assertThat(customer.getEmail().getValue()).isEqualTo(&quot;john.doe@example.com&quot;);
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Should throw exception when email already exists&quot;)
        void shouldThrowExceptionWhenEmailAlreadyExists() {
            // ✅ Test name describes the expected behavior
            CustomerRepository mockRepository = mock(CustomerRepository.class);
            EmailService mockEmailService = mock(EmailService.class);
            
            CustomerService customerService = new CustomerService(mockRepository, mockEmailService);
            
            Customer existingCustomer = new Customer(
                CustomerId.generate(), 
                &quot;Jane Doe&quot;, 
                EmailAddress.of(&quot;john.doe@example.com&quot;)
            );
            when(mockRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.of(existingCustomer));
            
            assertThrows(IllegalArgumentException.class, () -&gt; {
                customerService.registerCustomer(&quot;John Doe&quot;, &quot;john.doe@example.com&quot;);
            });
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Should apply VIP customer discount&quot;)
        void shouldApplyVipCustomerDiscount() {
            // ✅ Test name describes the business behavior
            PricingService pricingService = new PricingService(
                mock(TaxCalculator.class),
                mock(ShippingCalculator.class),
                mock(DiscountRuleRepository.class)
            );
            
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(100.00, &quot;USD&quot;));
            
            Customer customer = new Customer(CustomerId.of(&quot;customer-123&quot;), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
            customer.activate();
            customer.recordOrder(Money.of(1000, &quot;USD&quot;)); // Make VIP
            
            Address address = new Address(&quot;123 Main St&quot;, &quot;Anytown&quot;, &quot;CA&quot;, &quot;US&quot;, &quot;12345&quot;);
            
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Test Edge Cases&quot;)
    class TestEdgeCasesTests {
        
        @Test
        @DisplayName(&quot;✅ GOOD: Test boundary conditions&quot;)
        void shouldHandleBoundaryConditions() {
            // ✅ Test boundary conditions
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            
            // Test minimum order amount
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(10.00, &quot;USD&quot;)); // Exactly $10
            assertThat(order.canBeConfirmed()).isTrue();
            
            order.removeItem(ProductId.of(&quot;product-1&quot;));
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(9.99, &quot;USD&quot;)); // Just below $10
            assertThat(order.canBeConfirmed()).isFalse();
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Test error conditions&quot;)
        void shouldHandleErrorConditions() {
            // ✅ Test error conditions
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            
            // Test adding item to confirmed order
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            
            assertThrows(IllegalStateException.class, () -&gt; {
                order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(10.00, &quot;USD&quot;));
            });
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Test null and empty values&quot;)
        void shouldHandleNullAndEmptyValues() {
            // ✅ Test null and empty values
            assertThrows(IllegalArgumentException.class, () -&gt; {
                new Order(null, CustomerId.of(&quot;customer-123&quot;));
            });
            
            assertThrows(IllegalArgumentException.class, () -&gt; {
                new Order(OrderId.generate(), null);
            });
            
            assertThrows(IllegalArgumentException.class, () -&gt; {
                Money.of(-10.0, &quot;USD&quot;);
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Use Proper Mocking&quot;)
    class UseProperMockingTests {
        
        @Test
        @DisplayName(&quot;✅ GOOD: Mock external dependencies&quot;)
        void shouldMockExternalDependencies() {
            // ✅ Mock external dependencies
            CustomerRepository mockRepository = mock(CustomerRepository.class);
            EmailService mockEmailService = mock(EmailService.class);
            
            CustomerService customerService = new CustomerService(mockRepository, mockEmailService);
            
            // ✅ Mock external dependencies, not domain objects
            when(mockRepository.findByEmail(any(EmailAddress.class)))
                .thenReturn(Optional.empty());
            doNothing().when(mockRepository).save(any(Customer.class));
            doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
            
            Customer customer = customerService.registerCustomer(&quot;John Doe&quot;, &quot;john.doe@example.com&quot;);
            
            assertThat(customer.getName()).isEqualTo(&quot;John Doe&quot;);
            
            // ✅ Verify interactions with mocks
            verify(mockRepository).findByEmail(any(EmailAddress.class));
            verify(mockRepository).save(customer);
            verify(mockEmailService).sendWelcomeEmail(customer);
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Don&#39;t mock domain objects&quot;)
        void shouldNotMockDomainObjects() {
            // ✅ Don&#39;t mock domain objects
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            Customer customer = new Customer(CustomerId.of(&quot;customer-123&quot;), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
            customer.activate();
            
            // ✅ Use real domain objects
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(100.00, &quot;USD&quot;));
            
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(100.00, &quot;USD&quot;));
            assertThat(customer.isActive()).isTrue();
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Don&#39;t mock value objects&quot;)
        void shouldNotMockValueObjects() {
            // ✅ Don&#39;t mock value objects
            Money money1 = Money.of(100.00, &quot;USD&quot;);
            Money money2 = Money.of(50.00, &quot;USD&quot;);
            EmailAddress email = EmailAddress.of(&quot;john.doe@example.com&quot;);
            
            // ✅ Use real value objects
            Money sum = money1.add(money2);
            assertThat(sum).isEqualTo(Money.of(150.00, &quot;USD&quot;));
            
            assertThat(email.getValue()).isEqualTo(&quot;john.doe@example.com&quot;);
            assertThat(email.getDomain()).isEqualTo(&quot;example.com&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Keep Tests Focused&quot;)
    class KeepTestsFocusedTests {
        
        @Test
        @DisplayName(&quot;✅ GOOD: Test one thing at a time&quot;)
        void shouldTestOneThingAtATime() {
            // ✅ Test one thing at a time
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            
            // Test adding item
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            assertThat(order.getItemCount()).isEqualTo(1);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(15.99, &quot;USD&quot;));
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Test specific business rule&quot;)
        void shouldTestSpecificBusinessRule() {
            // ✅ Test specific business rule
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            
            // Test minimum order amount rule
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(5.00, &quot;USD&quot;)); // Below $10 minimum
            assertThat(order.canBeConfirmed()).isFalse();
            
            order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(10.00, &quot;USD&quot;));
            assertThat(order.canBeConfirmed()).isTrue();
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Test specific value object behavior&quot;)
        void shouldTestSpecificValueObjectBehavior() {
            // ✅ Test specific value object behavior
            Money money = Money.of(100.00, &quot;USD&quot;);
            
            // Test addition
            Money sum = money.add(Money.of(50.00, &quot;USD&quot;));
            assertThat(sum).isEqualTo(Money.of(150.00, &quot;USD&quot;));
            
            // Test subtraction
            Money difference = money.subtract(Money.of(25.00, &quot;USD&quot;));
            assertThat(difference).isEqualTo(Money.of(75.00, &quot;USD&quot;));
        }
    }
    
    @Nested
    @DisplayName(&quot;Use Parameterized Tests&quot;)
    class UseParameterizedTestsTests {
        
        @ParameterizedTest
        @ValueSource(strings = {&quot;USD&quot;, &quot;EUR&quot;, &quot;GBP&quot;, &quot;JPY&quot;, &quot;CAD&quot;, &quot;AUD&quot;})
        @DisplayName(&quot;✅ GOOD: Test with different currencies&quot;)
        void shouldCreateMoneyWithDifferentCurrencies(String currency) {
            // ✅ Test with different currencies
            Money money = Money.of(100.0, currency);
            
            assertThat(money.getAmount()).isEqualTo(100.0);
            assertThat(money.getCurrency()).isEqualTo(currency);
        }
        
        @ParameterizedTest
        @CsvSource({
            &quot;VIP, 0.15&quot;,
            &quot;Premium, 0.10&quot;,
            &quot;Standard, 0.05&quot;,
            &quot;Basic, 0.0&quot;
        })
        @DisplayName(&quot;✅ GOOD: Test different customer types&quot;)
        void shouldApplyCorrectDiscountForCustomerType(String customerType, double expectedDiscount) {
            // ✅ Test different customer types
            Customer customer = new Customer(CustomerId.generate(), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
            customer.activate();
            
            // Set customer type based on total spent
            switch (customerType) {
                case &quot;VIP&quot;:
                    customer.recordOrder(Money.of(1000, &quot;USD&quot;));
                    break;
                case &quot;Premium&quot;:
                    customer.recordOrder(Money.of(500, &quot;USD&quot;));
                    break;
                default:
                    // Standard or Basic
                    break;
            }
            
            assertThat(customer.getCustomerType()).isEqualTo(customerType);
        }
        
        @ParameterizedTest
        @CsvSource({
            &quot;100.0, 50.0, 150.0&quot;,
            &quot;0.0, 100.0, 100.0&quot;,
            &quot;25.50, 75.25, 100.75&quot;,
            &quot;999.99, 0.01, 1000.0&quot;
        })
        @DisplayName(&quot;✅ GOOD: Test money addition with different values&quot;)
        void shouldAddMoneyWithDifferentValues(double amount1, double amount2, double expected) {
            // ✅ Test money addition with different values
            Money money1 = Money.of(amount1, &quot;USD&quot;);
            Money money2 = Money.of(amount2, &quot;USD&quot;);
            
            Money result = money1.add(money2);
            
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Use Test Data Builders&quot;)
    class UseTestDataBuildersTests {
        
        @Test
        @DisplayName(&quot;✅ GOOD: Use test data builders&quot;)
        void shouldUseTestDataBuilders() {
            // ✅ Use test data builders
            Order order = OrderTestDataBuilder.anOrder()
                .withCustomerId(&quot;customer-123&quot;)
                .withItem(&quot;product-1&quot;, 2, 15.99)
                .withItem(&quot;product-2&quot;, 1, 25.50)
                .build();
            
            assertThat(order.getCustomerId().getValue()).isEqualTo(&quot;customer-123&quot;);
            assertThat(order.getItemCount()).isEqualTo(2);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(57.48, &quot;USD&quot;));
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Use test data builders for complex objects&quot;)
        void shouldUseTestDataBuildersForComplexObjects() {
            // ✅ Use test data builders for complex objects
            Customer customer = CustomerTestDataBuilder.aCustomer()
                .withName(&quot;John Doe&quot;)
                .withEmail(&quot;john.doe@example.com&quot;)
                .withStatus(CustomerStatus.ACTIVE)
                .withTotalSpent(1000.0)
                .build();
            
            assertThat(customer.getName()).isEqualTo(&quot;John Doe&quot;);
            assertThat(customer.getEmail().getValue()).isEqualTo(&quot;john.doe@example.com&quot;);
            assertThat(customer.getStatus()).isEqualTo(CustomerStatus.ACTIVE);
            assertThat(customer.isVip()).isTrue();
        }
    }
    
    @Nested
    @DisplayName(&quot;Use AssertJ for Better Assertions&quot;)
    class UseAssertJForBetterAssertionsTests {
        
        @Test
        @DisplayName(&quot;✅ GOOD: Use AssertJ for better assertions&quot;)
        void shouldUseAssertJForBetterAssertions() {
            // ✅ Use AssertJ for better assertions
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
            
            // ✅ AssertJ provides better error messages
            assertThat(order.getItemCount()).isEqualTo(2);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, &quot;USD&quot;));
            assertThat(order.canBeConfirmed()).isTrue();
            assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
        }
        
        @Test
        @DisplayName(&quot;✅ GOOD: Use AssertJ for collection assertions&quot;)
        void shouldUseAssertJForCollectionAssertions() {
            // ✅ Use AssertJ for collection assertions
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
            order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(25.50, &quot;USD&quot;));
            
            List&lt;OrderItem&gt; items = order.getItems();
            
            // ✅ AssertJ provides better collection assertions
            assertThat(items).hasSize(2);
            assertThat(items).extracting(OrderItem::getProductId)
                .extracting(ProductId::getValue)
                .containsExactlyInAnyOrder(&quot;product-1&quot;, &quot;product-2&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Use Nested Tests for Organization&quot;)
    class UseNestedTestsForOrganizationTests {
        
        @Nested
        @DisplayName(&quot;Order Creation Tests&quot;)
        class OrderCreationTests {
            
            @Test
            @DisplayName(&quot;✅ GOOD: Should create order with valid data&quot;)
            void shouldCreateOrderWithValidData() {
                Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
                
                assertThat(order.getId()).isNotNull();
                assertThat(order.getCustomerId().getValue()).isEqualTo(&quot;customer-123&quot;);
                assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
                assertThat(order.getItemCount()).isEqualTo(0);
            }
            
            @Test
            @DisplayName(&quot;✅ GOOD: Should throw exception when order ID is null&quot;)
            void shouldThrowExceptionWhenOrderIdIsNull() {
                assertThrows(IllegalArgumentException.class, () -&gt; {
                    new Order(null, CustomerId.of(&quot;customer-123&quot;));
                });
            }
        }
        
        @Nested
        @DisplayName(&quot;Order Item Management Tests&quot;)
        class OrderItemManagementTests {
            
            @Test
            @DisplayName(&quot;✅ GOOD: Should add item to order&quot;)
            void shouldAddItemToOrder() {
                Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
                
                order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
                
                assertThat(order.getItemCount()).isEqualTo(1);
                assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, &quot;USD&quot;));
            }
            
            @Test
            @DisplayName(&quot;✅ GOOD: Should remove item from order&quot;)
            void shouldRemoveItemFromOrder() {
                Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
                order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
                
                order.removeItem(ProductId.of(&quot;product-1&quot;));
                
                assertThat(order.getItemCount()).isEqualTo(0);
                assertThat(order.getTotalAmount()).isEqualTo(Money.of(0.0, &quot;USD&quot;));
            }
        }
    }
}

// ✅ GOOD: Test Data Builders
class OrderTestDataBuilder {
    private OrderId orderId;
    private CustomerId customerId;
    private List&lt;OrderItem&gt; items = new ArrayList&lt;&gt;();
    
    public static OrderTestDataBuilder anOrder() {
        return new OrderTestDataBuilder();
    }
    
    public OrderTestDataBuilder withCustomerId(String customerId) {
        this.customerId = CustomerId.of(customerId);
        return this;
    }
    
    public OrderTestDataBuilder withItem(String productId, int quantity, double unitPrice) {
        this.items.add(new OrderItem(
            ProductId.of(productId),
            quantity,
            Money.of(unitPrice, &quot;USD&quot;)
        ));
        return this;
    }
    
    public Order build() {
        if (orderId == null) {
            orderId = OrderId.generate();
        }
        if (customerId == null) {
            customerId = CustomerId.of(&quot;customer-123&quot;);
        }
        
        Order order = new Order(orderId, customerId);
        for (OrderItem item : items) {
            order.addItem(item.getProductId(), item.getQuantity(), item.getUnitPrice());
        }
        
        return order;
    }
}

class CustomerTestDataBuilder {
    private CustomerId customerId;
    private String name;
    private EmailAddress email;
    private CustomerStatus status;
    private Money totalSpent;
    
    public static CustomerTestDataBuilder aCustomer() {
        return new CustomerTestDataBuilder();
    }
    
    public CustomerTestDataBuilder withName(String name) {
        this.name = name;
        return this;
    }
    
    public CustomerTestDataBuilder withEmail(String email) {
        this.email = EmailAddress.of(email);
        return this;
    }
    
    public CustomerTestDataBuilder withStatus(CustomerStatus status) {
        this.status = status;
        return this;
    }
    
    public CustomerTestDataBuilder withTotalSpent(double amount) {
        this.totalSpent = Money.of(amount, &quot;USD&quot;);
        return this;
    }
    
    public Customer build() {
        if (customerId == null) {
            customerId = CustomerId.generate();
        }
        if (name == null) {
            name = &quot;John Doe&quot;;
        }
        if (email == null) {
            email = EmailAddress.of(&quot;john.doe@example.com&quot;);
        }
        
        Customer customer = new Customer(customerId, name, email);
        
        if (status != null) {
            switch (status) {
                case ACTIVE:
                    customer.activate();
                    break;
                case INACTIVE:
                    customer.deactivate();
                    break;
                case SUSPENDED:
                    customer.suspend();
                    break;
            }
        }
        
        if (totalSpent != null) {
            customer.recordOrder(totalSpent);
        }
        
        return customer;
    }
}

// Example usage
public class TestingBestPracticesExample {
    public static void main(String[] args) {
        System.out.println(&quot;Testing Best Practices for DDD Unit Testing:&quot;);
        System.out.println(&quot;1. ✅ Test behavior, not implementation&quot;);
        System.out.println(&quot;2. ✅ Use descriptive test names&quot;);
        System.out.println(&quot;3. ✅ Test edge cases&quot;);
        System.out.println(&quot;4. ✅ Use proper mocking&quot;);
        System.out.println(&quot;5. ✅ Keep tests focused&quot;);
        System.out.println(&quot;6. ✅ Use parameterized tests&quot;);
        System.out.println(&quot;7. ✅ Use test data builders&quot;);
        System.out.println(&quot;8. ✅ Use AssertJ for better assertions&quot;);
        System.out.println(&quot;9. ✅ Use nested tests for organization&quot;);
        System.out.println(&quot;10. ✅ Test business rules and constraints&quot;);
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Best Practices for DDD Unit Testing</h3>
<h4>1. <strong>Test Behavior, Not Implementation</strong></h4>
<ul>
<li>✅ Test what the system does, not how it does it</li>
<li>✅ Test business rules and constraints</li>
<li>✅ Test value object behavior</li>
<li>✅ Test domain service behavior</li>
</ul>
<h4>2. <strong>Use Descriptive Test Names</strong></h4>
<ul>
<li>✅ Test names should describe behavior</li>
<li>✅ Test names should be clear and specific</li>
<li>✅ Test names should focus on business value</li>
<li>✅ Test names should be easy to understand</li>
</ul>
<h4>3. <strong>Test Edge Cases</strong></h4>
<ul>
<li>✅ Test boundary conditions</li>
<li>✅ Test error conditions</li>
<li>✅ Test null and empty values</li>
<li>✅ Test extreme values</li>
</ul>
<h4>4. <strong>Use Proper Mocking</strong></h4>
<ul>
<li>✅ Mock external dependencies</li>
<li>✅ Don&#39;t mock domain objects</li>
<li>✅ Don&#39;t mock value objects</li>
<li>✅ Focus on business logic</li>
</ul>
<h4>5. <strong>Keep Tests Focused</strong></h4>
<ul>
<li>✅ Test one thing at a time</li>
<li>✅ Test specific business rules</li>
<li>✅ Test specific value object behavior</li>
<li>✅ Keep tests simple and clear</li>
</ul>
<h4>6. <strong>Use Parameterized Tests</strong></h4>
<ul>
<li>✅ Test multiple scenarios efficiently</li>
<li>✅ Test with different input values</li>
<li>✅ Test boundary conditions</li>
<li>✅ Reduce test duplication</li>
</ul>
<h4>7. <strong>Use Test Data Builders</strong></h4>
<ul>
<li>✅ Create complex test data easily</li>
<li>✅ Make tests more readable</li>
<li>✅ Reduce test setup code</li>
<li>✅ Make tests more maintainable</li>
</ul>
<h4>8. <strong>Use AssertJ for Better Assertions</strong></h4>
<ul>
<li>✅ Better error messages</li>
<li>✅ Fluent assertion API</li>
<li>✅ Collection assertions</li>
<li>✅ Custom assertions</li>
</ul>
<h4>9. <strong>Use Nested Tests for Organization</strong></h4>
<ul>
<li>✅ Organize tests by functionality</li>
<li>✅ Group related tests together</li>
<li>✅ Make test structure clear</li>
<li>✅ Improve test readability</li>
</ul>
<h4>10. <strong>Test Business Rules and Constraints</strong></h4>
<ul>
<li>✅ Test domain invariants</li>
<li>✅ Test business constraints</li>
<li>✅ Test validation rules</li>
<li>✅ Test error conditions</li>
</ul>
<h3>Testing Best Practices Benefits</h3>
<h4><strong>Maintainability</strong></h4>
<ul>
<li>✅ Tests are easy to understand and modify</li>
<li>✅ Tests focus on business behavior</li>
<li>✅ Tests are not brittle</li>
<li>✅ Tests are well-organized</li>
</ul>
<h4><strong>Reliability</strong></h4>
<ul>
<li>✅ Tests are repeatable</li>
<li>✅ Tests are isolated</li>
<li>✅ Tests don&#39;t depend on external state</li>
<li>✅ Tests catch real bugs</li>
</ul>
<h4><strong>Readability</strong></h4>
<ul>
<li>✅ Test names are descriptive</li>
<li>✅ Test structure is clear</li>
<li>✅ Test data is well-organized</li>
<li>✅ Test assertions are clear</li>
</ul>
<h4><strong>Efficiency</strong></h4>
<ul>
<li>✅ Tests run quickly</li>
<li>✅ Tests are focused</li>
<li>✅ Tests use proper mocking</li>
<li>✅ Tests are parameterized</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./07-order-tests.md">Order Tests</a> - Proper testing examples</li>
<li><a href="./08-money-tests.md">Money Tests</a> - Value object testing</li>
<li><a href="./09-pricing-service-tests.md">Pricing Service Tests</a> - Domain service testing</li>
<li><a href="./10-customer-service-tests.md">Customer Service Tests</a> - Service testing with dependency injection</li>
<li><a href="./11-testing-anti-patterns.md">Testing Anti-Patterns</a> - What to avoid</li>
<li><a href="../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing">Best Practices for DDD Unit Testing</a> - Testing concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 11-testing-anti-patterns.md</li>
<li>Next: 13-domain-modeling-best-practices.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing">Best Practices for DDD Unit Testing</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"12-testing-best-practices"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"12-testing-best-practices\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
