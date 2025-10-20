1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"11-testing-anti-patterns\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T5c31,<h1>Testing Anti-Patterns - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid">Testing Anti-Patterns to Avoid</a></p>
<p><strong>Navigation</strong>: <a href="./10-customer-service-tests.md">← Previous: Customer Service Tests</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - Testing Anti-Patterns to Avoid
// File: 2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns.java

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;
import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.time.LocalDateTime;
import java.util.List;

// ❌ BAD: Testing Infrastructure Concerns
@DisplayName(&quot;Testing Anti-Patterns - Infrastructure Concerns&quot;)
class BadInfrastructureTests {
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing database connection&quot;)
    void badTestDatabaseConnection() {
        // ❌ This is testing infrastructure, not business logic
        DatabaseConnection connection = new DatabaseConnection();
        assertTrue(connection.isConnected());
        
        // ❌ This test will break if database is down
        // ❌ This test doesn&#39;t verify business rules
        // ❌ This test is slow and unreliable
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing file system operations&quot;)
    void badTestFileSystemOperations() {
        // ❌ This is testing infrastructure, not business logic
        FileService fileService = new FileService();
        String result = fileService.readFile(&quot;test.txt&quot;);
        
        // ❌ This test depends on file system state
        // ❌ This test will break if file doesn&#39;t exist
        // ❌ This test doesn&#39;t verify business rules
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing network operations&quot;)
    void badTestNetworkOperations() {
        // ❌ This is testing infrastructure, not business logic
        HttpClient httpClient = new HttpClient();
        HttpResponse response = httpClient.get(&quot;https://api.example.com/data&quot;);
        
        // ❌ This test depends on network connectivity
        // ❌ This test will break if API is down
        // ❌ This test doesn&#39;t verify business rules
    }
}

// ❌ BAD: Testing Implementation Details
@DisplayName(&quot;Testing Anti-Patterns - Implementation Details&quot;)
class BadImplementationDetailTests {
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing private method behavior&quot;)
    void badTestPrivateMethodBehavior() {
        // ❌ This is testing implementation details
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        
        // ❌ Using reflection to test private methods
        Method privateMethod = Order.class.getDeclaredMethod(&quot;calculateTotal&quot;);
        privateMethod.setAccessible(true);
        Money result = (Money) privateMethod.invoke(order);
        
        // ❌ This test will break if implementation changes
        // ❌ This test doesn&#39;t verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing internal state&quot;)
    void badTestInternalState() {
        // ❌ This is testing implementation details
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        
        // ❌ Testing internal fields directly
        Field itemsField = Order.class.getDeclaredField(&quot;items&quot;);
        itemsField.setAccessible(true);
        List&lt;OrderItem&gt; items = (List&lt;OrderItem&gt;) itemsField.get(order);
        
        // ❌ This test will break if internal structure changes
        // ❌ This test doesn&#39;t verify business behavior
        // ❌ This test is brittle and hard to maintain
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing method call order&quot;)
    void badTestMethodCallOrder() {
        // ❌ This is testing implementation details
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        
        // ❌ Testing that methods are called in specific order
        order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(10.00, &quot;USD&quot;));
        order.addItem(ProductId.of(&quot;product-2&quot;), 2, Money.of(15.00, &quot;USD&quot;));
        
        // ❌ This test will break if implementation changes
        // ❌ This test doesn&#39;t verify business behavior
        // ❌ This test is hard to maintain
    }
}

// ❌ BAD: Over-Mocking
@DisplayName(&quot;Testing Anti-Patterns - Over-Mocking&quot;)
class BadOverMockingTests {
    
    @Test
    @DisplayName(&quot;❌ BAD: Mocking domain objects&quot;)
    void badMockDomainObjects() {
        // ❌ This is over-mocking
        Order mockOrder = mock(Order.class);
        Customer mockCustomer = mock(Customer.class);
        Money mockMoney = mock(Money.class);
        
        when(mockOrder.getTotalAmount()).thenReturn(mockMoney);
        when(mockMoney.getAmount()).thenReturn(100.0);
        when(mockCustomer.getCustomerType()).thenReturn(&quot;VIP&quot;);
        
        // ❌ This test doesn&#39;t verify real business logic
        // ❌ This test is hard to maintain
        // ❌ This test doesn&#39;t catch real bugs
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Mocking value objects&quot;)
    void badMockValueObjects() {
        // ❌ This is over-mocking
        Money mockMoney = mock(Money.class);
        EmailAddress mockEmail = mock(EmailAddress.class);
        
        when(mockMoney.getAmount()).thenReturn(100.0);
        when(mockMoney.getCurrency()).thenReturn(&quot;USD&quot;);
        when(mockEmail.getValue()).thenReturn(&quot;test@example.com&quot;);
        
        // ❌ Value objects should be tested with real instances
        // ❌ This test doesn&#39;t verify real behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Mocking everything&quot;)
    void badMockEverything() {
        // ❌ This is over-mocking
        Order mockOrder = mock(Order.class);
        Customer mockCustomer = mock(Customer.class);
        Money mockMoney = mock(Money.class);
        EmailAddress mockEmail = mock(EmailAddress.class);
        Address mockAddress = mock(Address.class);
        
        // ❌ Mocking everything makes tests meaningless
        // ❌ This test doesn&#39;t verify real behavior
        // ❌ This test is hard to maintain
    }
}

// ❌ BAD: Testing Implementation Instead of Behavior
@DisplayName(&quot;Testing Anti-Patterns - Implementation vs Behavior&quot;)
class BadImplementationVsBehaviorTests {
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing method implementation&quot;)
    void badTestMethodImplementation() {
        // ❌ This is testing implementation, not behavior
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        
        // ❌ Testing that specific methods are called
        order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(10.00, &quot;USD&quot;));
        
        // ❌ This test will break if implementation changes
        // ❌ This test doesn&#39;t verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing data structure details&quot;)
    void badTestDataStructureDetails() {
        // ❌ This is testing implementation, not behavior
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(10.00, &quot;USD&quot;));
        
        // ❌ Testing internal data structure
        List&lt;OrderItem&gt; items = order.getItems();
        assertThat(items).hasSize(1);
        assertThat(items.get(0).getProductId().getValue()).isEqualTo(&quot;product-1&quot;);
        
        // ❌ This test will break if implementation changes
        // ❌ This test doesn&#39;t verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing algorithm details&quot;)
    void badTestAlgorithmDetails() {
        // ❌ This is testing implementation, not behavior
        PricingService pricingService = new PricingService(
            mock(TaxCalculator.class),
            mock(ShippingCalculator.class),
            mock(DiscountRuleRepository.class)
        );
        
        // ❌ Testing that specific algorithm is used
        // ❌ This test will break if algorithm changes
        // ❌ This test doesn&#39;t verify business behavior
        // ❌ This test is hard to maintain
    }
}

// ❌ BAD: Brittle Tests
@DisplayName(&quot;Testing Anti-Patterns - Brittle Tests&quot;)
class BadBrittleTests {
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing exact string values&quot;)
    void badTestExactStringValues() {
        // ❌ This is brittle testing
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        
        // ❌ Testing exact string representation
        String orderString = order.toString();
        assertThat(orderString).isEqualTo(&quot;Order{id=123, customerId=customer-123, status=Draft, items=0, total=$0.00}&quot;);
        
        // ❌ This test will break if toString() format changes
        // ❌ This test doesn&#39;t verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing exact date values&quot;)
    void badTestExactDateValues() {
        // ❌ This is brittle testing
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        
        // ❌ Testing exact date values
        LocalDateTime createdAt = order.getCreatedAt();
        assertThat(createdAt).isEqualTo(LocalDateTime.of(2024, 1, 1, 12, 0, 0));
        
        // ❌ This test will break if date changes
        // ❌ This test doesn&#39;t verify business behavior
        // ❌ This test is hard to maintain
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Testing exact numeric values&quot;)
    void badTestExactNumericValues() {
        // ❌ This is brittle testing
        Money money = Money.of(100.50, &quot;USD&quot;);
        
        // ❌ Testing exact numeric values
        assertThat(money.getAmount()).isEqualTo(100.50);
        
        // ❌ This test will break if precision changes
        // ❌ This test doesn&#39;t verify business behavior
        // ❌ This test is hard to maintain
    }
}

// ❌ BAD: Test Data Pollution
@DisplayName(&quot;Testing Anti-Patterns - Test Data Pollution&quot;)
class BadTestDataPollutionTests {
    
    @Test
    @DisplayName(&quot;❌ BAD: Using shared test data&quot;)
    void badUseSharedTestData() {
        // ❌ This is test data pollution
        Order order = SharedTestData.getOrder();
        Customer customer = SharedTestData.getCustomer();
        
        // ❌ Shared test data can cause test interference
        // ❌ Tests may fail due to data from other tests
        // ❌ Tests are not isolated
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Using static test data&quot;)
    void badUseStaticTestData() {
        // ❌ This is test data pollution
        Order order = TestData.ORDER_1;
        Customer customer = TestData.CUSTOMER_1;
        
        // ❌ Static test data can cause test interference
        // ❌ Tests may fail due to data from other tests
        // ❌ Tests are not isolated
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Using database test data&quot;)
    void badUseDatabaseTestData() {
        // ❌ This is test data pollution
        Order order = orderRepository.findById(&quot;test-order-1&quot;);
        Customer customer = customerRepository.findById(&quot;test-customer-1&quot;);
        
        // ❌ Database test data can cause test interference
        // ❌ Tests may fail due to data from other tests
        // ❌ Tests are not isolated
    }
}

// ❌ BAD: Test Naming
@DisplayName(&quot;Testing Anti-Patterns - Test Naming&quot;)
class BadTestNamingTests {
    
    @Test
    @DisplayName(&quot;❌ BAD: Unclear test names&quot;)
    void test1() {
        // ❌ This test name is unclear
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        assertThat(order).isNotNull();
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Implementation-focused test names&quot;)
    void testAddItemMethod() {
        // ❌ This test name focuses on implementation
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(10.00, &quot;USD&quot;));
        assertThat(order.getItemCount()).isEqualTo(1);
    }
    
    @Test
    @DisplayName(&quot;❌ BAD: Vague test names&quot;)
    void testOrder() {
        // ❌ This test name is vague
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        assertThat(order).isNotNull();
    }
}

// ✅ GOOD: Proper Testing Examples
@DisplayName(&quot;Proper Testing Examples&quot;)
class GoodTestingExamples {
    
    @Test
    @DisplayName(&quot;✅ GOOD: Testing business behavior&quot;)
    void goodTestBusinessBehavior() {
        // ✅ This tests business behavior
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
        
        // ✅ Testing business behavior, not implementation
        assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, &quot;USD&quot;));
        assertThat(order.canBeConfirmed()).isTrue();
    }
    
    @Test
    @DisplayName(&quot;✅ GOOD: Testing business rules&quot;)
    void goodTestBusinessRules() {
        // ✅ This tests business rules
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(5.00, &quot;USD&quot;)); // Below $10 minimum
        
        // ✅ Testing business rules, not implementation
        assertThat(order.canBeConfirmed()).isFalse();
        
        order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(10.00, &quot;USD&quot;));
        assertThat(order.canBeConfirmed()).isTrue();
    }
    
    @Test
    @DisplayName(&quot;✅ GOOD: Testing value object behavior&quot;)
    void goodTestValueObjectBehavior() {
        // ✅ This tests value object behavior
        Money money1 = Money.of(100.00, &quot;USD&quot;);
        Money money2 = Money.of(50.00, &quot;USD&quot;);
        
        // ✅ Testing value object behavior, not implementation
        Money result = money1.add(money2);
        assertThat(result).isEqualTo(Money.of(150.00, &quot;USD&quot;));
        assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
    }
    
    @Test
    @DisplayName(&quot;✅ GOOD: Testing domain service behavior&quot;)
    void goodTestDomainServiceBehavior() {
        // ✅ This tests domain service behavior
        PricingService pricingService = new PricingService(
            mock(TaxCalculator.class),
            mock(ShippingCalculator.class),
            mock(DiscountRuleRepository.class)
        );
        
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(100.00, &quot;USD&quot;));
        
        Customer customer = new Customer(CustomerId.of(&quot;customer-123&quot;), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
        customer.activate();
        
        Address address = new Address(&quot;123 Main St&quot;, &quot;Anytown&quot;, &quot;CA&quot;, &quot;US&quot;, &quot;12345&quot;);
        
        // ✅ Testing domain service behavior, not implementation
        Money total = pricingService.calculateOrderTotal(order, customer, address);
        assertThat(total).isNotNull();
        assertThat(total.getCurrency()).isEqualTo(&quot;USD&quot;);
    }
    
    @Test
    @DisplayName(&quot;✅ GOOD: Testing with proper mocking&quot;)
    void goodTestWithProperMocking() {
        // ✅ This uses proper mocking
        CustomerRepository mockRepository = mock(CustomerRepository.class);
        EmailService mockEmailService = mock(EmailService.class);
        
        CustomerService customerService = new CustomerService(mockRepository, mockEmailService);
        
        // ✅ Mocking external dependencies, not domain objects
        when(mockRepository.findByEmail(any(EmailAddress.class)))
            .thenReturn(Optional.empty());
        doNothing().when(mockRepository).save(any(Customer.class));
        doNothing().when(mockEmailService).sendWelcomeEmail(any(Customer.class));
        
        // ✅ Testing business behavior
        Customer customer = customerService.registerCustomer(&quot;John Doe&quot;, &quot;john.doe@example.com&quot;);
        assertThat(customer.getName()).isEqualTo(&quot;John Doe&quot;);
        assertThat(customer.getEmail().getValue()).isEqualTo(&quot;john.doe@example.com&quot;);
    }
    
    @Test
    @DisplayName(&quot;✅ GOOD: Testing with descriptive names&quot;)
    void shouldRegisterCustomerWithValidNameAndEmail() {
        // ✅ This test name describes the behavior
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
}

// Example usage
public class TestingAntiPatternsExample {
    public static void main(String[] args) {
        System.out.println(&quot;Testing Anti-Patterns to Avoid:&quot;);
        System.out.println(&quot;1. ❌ Testing infrastructure concerns&quot;);
        System.out.println(&quot;2. ❌ Testing implementation details&quot;);
        System.out.println(&quot;3. ❌ Over-mocking&quot;);
        System.out.println(&quot;4. ❌ Testing implementation instead of behavior&quot;);
        System.out.println(&quot;5. ❌ Brittle tests&quot;);
        System.out.println(&quot;6. ❌ Test data pollution&quot;);
        System.out.println(&quot;7. ❌ Poor test naming&quot;);
        
        System.out.println(&quot;\nProper Testing Practices:&quot;);
        System.out.println(&quot;1. ✅ Test business behavior&quot;);
        System.out.println(&quot;2. ✅ Test business rules&quot;);
        System.out.println(&quot;3. ✅ Test value object behavior&quot;);
        System.out.println(&quot;4. ✅ Test domain service behavior&quot;);
        System.out.println(&quot;5. ✅ Use proper mocking&quot;);
        System.out.println(&quot;6. ✅ Use descriptive test names&quot;);
        System.out.println(&quot;7. ✅ Keep tests isolated&quot;);
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Testing Anti-Patterns to Avoid</h3>
<h4>1. <strong>Testing Infrastructure Concerns</strong></h4>
<ul>
<li>❌ Testing database connections</li>
<li>❌ Testing file system operations</li>
<li>❌ Testing network operations</li>
<li>❌ These tests are slow, unreliable, and don&#39;t verify business logic</li>
</ul>
<h4>2. <strong>Testing Implementation Details</strong></h4>
<ul>
<li>❌ Testing private methods</li>
<li>❌ Testing internal state</li>
<li>❌ Testing method call order</li>
<li>❌ These tests break when implementation changes</li>
</ul>
<h4>3. <strong>Over-Mocking</strong></h4>
<ul>
<li>❌ Mocking domain objects</li>
<li>❌ Mocking value objects</li>
<li>❌ Mocking everything</li>
<li>❌ These tests don&#39;t verify real business logic</li>
</ul>
<h4>4. <strong>Testing Implementation Instead of Behavior</strong></h4>
<ul>
<li>❌ Testing method implementation</li>
<li>❌ Testing data structure details</li>
<li>❌ Testing algorithm details</li>
<li>❌ These tests break when implementation changes</li>
</ul>
<h4>5. <strong>Brittle Tests</strong></h4>
<ul>
<li>❌ Testing exact string values</li>
<li>❌ Testing exact date values</li>
<li>❌ Testing exact numeric values</li>
<li>❌ These tests break when format changes</li>
</ul>
<h4>6. <strong>Test Data Pollution</strong></h4>
<ul>
<li>❌ Using shared test data</li>
<li>❌ Using static test data</li>
<li>❌ Using database test data</li>
<li>❌ These tests can interfere with each other</li>
</ul>
<h4>7. <strong>Poor Test Naming</strong></h4>
<ul>
<li>❌ Unclear test names</li>
<li>❌ Implementation-focused test names</li>
<li>❌ Vague test names</li>
<li>❌ These tests are hard to understand</li>
</ul>
<h3>Proper Testing Practices</h3>
<h4><strong>Test Business Behavior</strong></h4>
<ul>
<li>✅ Test what the system does, not how it does it</li>
<li>✅ Test business rules and constraints</li>
<li>✅ Test value object behavior</li>
<li>✅ Test domain service behavior</li>
</ul>
<h4><strong>Use Proper Mocking</strong></h4>
<ul>
<li>✅ Mock external dependencies</li>
<li>✅ Don&#39;t mock domain objects</li>
<li>✅ Don&#39;t mock value objects</li>
<li>✅ Focus on business logic</li>
</ul>
<h4><strong>Use Descriptive Test Names</strong></h4>
<ul>
<li>✅ Test names should describe behavior</li>
<li>✅ Test names should be clear and specific</li>
<li>✅ Test names should focus on business value</li>
<li>✅ Test names should be easy to understand</li>
</ul>
<h4><strong>Keep Tests Isolated</strong></h4>
<ul>
<li>✅ Each test should be independent</li>
<li>✅ Tests should not depend on each other</li>
<li>✅ Tests should use fresh data</li>
<li>✅ Tests should be repeatable</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./07-order-tests.md">Order Tests</a> - Proper testing examples</li>
<li><a href="./08-money-tests.md">Money Tests</a> - Value object testing</li>
<li><a href="./09-pricing-service-tests.md">Pricing Service Tests</a> - Domain service testing</li>
<li><a href="./10-customer-service-tests.md">Customer Service Tests</a> - Service testing with dependency injection</li>
<li><a href="../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid">Testing Anti-Patterns to Avoid</a> - Testing concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 10-customer-service-tests.md</li>
<li>Next: 12-testing-best-practices.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#testing-anti-patterns-to-avoid">Testing Anti-Patterns to Avoid</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"11-testing-anti-patterns"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"11-testing-anti-patterns\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
