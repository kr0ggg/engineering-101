1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"09-pricing-service-tests\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:Tc1f3,<h1>Pricing Service Tests - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#testable-business-rules">Testable Business Rules</a></p>
<p><strong>Navigation</strong>: <a href="./08-money-tests.md">← Previous: Money Tests</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - Pricing Service Tests (JUnit 5) - Domain Service Testing
// File: 2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests.java

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

// ✅ GOOD: Comprehensive Pricing Service Tests
@DisplayName(&quot;Pricing Service Tests&quot;)
class PricingServiceTest {
    
    private PricingService pricingService;
    private TaxCalculator mockTaxCalculator;
    private ShippingCalculator mockShippingCalculator;
    private DiscountRuleRepository mockDiscountRuleRepository;
    
    @BeforeEach
    void setUp() {
        mockTaxCalculator = mock(TaxCalculator.class);
        mockShippingCalculator = mock(ShippingCalculator.class);
        mockDiscountRuleRepository = mock(DiscountRuleRepository.class);
        
        pricingService = new PricingService(
            mockTaxCalculator,
            mockShippingCalculator,
            mockDiscountRuleRepository
        );
    }
    
    @Nested
    @DisplayName(&quot;Calculate Order Total Tests&quot;)
    class CalculateOrderTotalTests {
        
        @Test
        @DisplayName(&quot;Should calculate order total with active customer&quot;)
        void shouldCalculateOrderTotalWithActiveCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createActiveCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Standard&quot;)).thenReturn(0.05);
            when(mockDiscountRuleRepository.getBulkDiscountRate(100.0)).thenReturn(0.0);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(8.00, &quot;USD&quot;));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, &quot;USD&quot;));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(total.getAmount()).isGreaterThan(0);
            
            // Verify dependencies were called
            verify(mockTaxCalculator).calculateTax(any(Money.class), eq(address));
            verify(mockShippingCalculator).calculateShipping(eq(order), eq(address));
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when customer is inactive&quot;)
        void shouldThrowExceptionWhenCustomerIsInactive() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createInactiveCustomer();
            Address address = createAddress();
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                pricingService.calculateOrderTotal(order, customer, address);
            });
        }
        
        @Test
        @DisplayName(&quot;Should apply customer discount&quot;)
        void shouldApplyCustomerDiscount() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createVipCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;VIP&quot;)).thenReturn(0.15);
            when(mockDiscountRuleRepository.getBulkDiscountRate(85.0)).thenReturn(0.0);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(6.80, &quot;USD&quot;));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, &quot;USD&quot;));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo(&quot;USD&quot;);
            
            // Verify discount was applied
            verify(mockDiscountRuleRepository).getCustomerDiscountRate(&quot;VIP&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should apply bulk discount&quot;)
        void shouldApplyBulkDiscount() {
            // Arrange
            Order order = createOrderWithAmount(1200.0);
            Customer customer = createActiveCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Standard&quot;)).thenReturn(0.05);
            when(mockDiscountRuleRepository.getBulkDiscountRate(1200.0)).thenReturn(0.10);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(86.40, &quot;USD&quot;));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, &quot;USD&quot;));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo(&quot;USD&quot;);
            
            // Verify bulk discount was applied
            verify(mockDiscountRuleRepository).getBulkDiscountRate(1200.0);
        }
    }
    
    @Nested
    @DisplayName(&quot;Calculate Discount Amount Tests&quot;)
    class CalculateDiscountAmountTests {
        
        @Test
        @DisplayName(&quot;Should calculate discount amount for VIP customer&quot;)
        void shouldCalculateDiscountAmountForVipCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;VIP&quot;)).thenReturn(0.15);
            when(mockDiscountRuleRepository.getBulkDiscountRate(85.0)).thenReturn(0.0);
            
            // Act
            Money discount = pricingService.calculateDiscountAmount(order, customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(discount.getAmount()).isGreaterThan(0);
        }
        
        @Test
        @DisplayName(&quot;Should calculate discount amount for premium customer&quot;)
        void shouldCalculateDiscountAmountForPremiumCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Premium&quot;)).thenReturn(0.10);
            when(mockDiscountRuleRepository.getBulkDiscountRate(90.0)).thenReturn(0.0);
            
            // Act
            Money discount = pricingService.calculateDiscountAmount(order, customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(discount.getAmount()).isGreaterThan(0);
        }
        
        @Test
        @DisplayName(&quot;Should calculate discount amount for standard customer&quot;)
        void shouldCalculateDiscountAmountForStandardCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Standard&quot;)).thenReturn(0.05);
            when(mockDiscountRuleRepository.getBulkDiscountRate(95.0)).thenReturn(0.0);
            
            // Act
            Money discount = pricingService.calculateDiscountAmount(order, customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(discount.getAmount()).isGreaterThan(0);
        }
        
        @Test
        @DisplayName(&quot;Should calculate discount amount for basic customer&quot;)
        void shouldCalculateDiscountAmountForBasicCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Basic&quot;)).thenReturn(0.0);
            when(mockDiscountRuleRepository.getBulkDiscountRate(100.0)).thenReturn(0.0);
            
            // Act
            Money discount = pricingService.calculateDiscountAmount(order, customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(discount.getAmount()).isEqualTo(0.0);
        }
    }
    
    @Nested
    @DisplayName(&quot;Get Available Discounts Tests&quot;)
    class GetAvailableDiscountsTests {
        
        @Test
        @DisplayName(&quot;Should get available discounts for VIP customer&quot;)
        void shouldGetAvailableDiscountsForVipCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;VIP&quot;)).thenReturn(0.15);
            when(mockDiscountRuleRepository.getBulkDiscountRate(85.0)).thenReturn(0.0);
            
            // Act
            List&lt;Discount&gt; discounts = pricingService.getAvailableDiscounts(order, customer);
            
            // Assert
            assertThat(discounts).isNotNull();
            assertThat(discounts).isNotEmpty();
            
            // Verify discount types
            assertThat(discounts).anyMatch(d -&gt; d.getName().contains(&quot;VIP&quot;));
        }
        
        @Test
        @DisplayName(&quot;Should get available discounts for premium customer&quot;)
        void shouldGetAvailableDiscountsForPremiumCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Premium&quot;)).thenReturn(0.10);
            when(mockDiscountRuleRepository.getBulkDiscountRate(90.0)).thenReturn(0.0);
            
            // Act
            List&lt;Discount&gt; discounts = pricingService.getAvailableDiscounts(order, customer);
            
            // Assert
            assertThat(discounts).isNotNull();
            assertThat(discounts).isNotEmpty();
            
            // Verify discount types
            assertThat(discounts).anyMatch(d -&gt; d.getName().contains(&quot;Premium&quot;));
        }
        
        @Test
        @DisplayName(&quot;Should get available discounts for standard customer&quot;)
        void shouldGetAvailableDiscountsForStandardCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Standard&quot;)).thenReturn(0.05);
            when(mockDiscountRuleRepository.getBulkDiscountRate(95.0)).thenReturn(0.0);
            
            // Act
            List&lt;Discount&gt; discounts = pricingService.getAvailableDiscounts(order, customer);
            
            // Assert
            assertThat(discounts).isNotNull();
            assertThat(discounts).isNotEmpty();
            
            // Verify discount types
            assertThat(discounts).anyMatch(d -&gt; d.getName().contains(&quot;Standard&quot;));
        }
        
        @Test
        @DisplayName(&quot;Should get available discounts for basic customer&quot;)
        void shouldGetAvailableDiscountsForBasicCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Basic&quot;)).thenReturn(0.0);
            when(mockDiscountRuleRepository.getBulkDiscountRate(100.0)).thenReturn(0.0);
            
            // Act
            List&lt;Discount&gt; discounts = pricingService.getAvailableDiscounts(order, customer);
            
            // Assert
            assertThat(discounts).isNotNull();
            // Basic customers might not have discounts
        }
    }
    
    @Nested
    @DisplayName(&quot;Apply Customer Discount Tests&quot;)
    class ApplyCustomerDiscountTests {
        
        @Test
        @DisplayName(&quot;Should apply VIP customer discount&quot;)
        void shouldApplyVipCustomerDiscount() {
            // Arrange
            Money amount = Money.of(100.00, &quot;USD&quot;);
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;VIP&quot;)).thenReturn(0.15);
            
            // Act
            Money discountedAmount = pricingService.applyCustomerDiscount(amount, customer);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(85.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should apply premium customer discount&quot;)
        void shouldApplyPremiumCustomerDiscount() {
            // Arrange
            Money amount = Money.of(100.00, &quot;USD&quot;);
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Premium&quot;)).thenReturn(0.10);
            
            // Act
            Money discountedAmount = pricingService.applyCustomerDiscount(amount, customer);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(90.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should apply standard customer discount&quot;)
        void shouldApplyStandardCustomerDiscount() {
            // Arrange
            Money amount = Money.of(100.00, &quot;USD&quot;);
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Standard&quot;)).thenReturn(0.05);
            
            // Act
            Money discountedAmount = pricingService.applyCustomerDiscount(amount, customer);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(95.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should apply basic customer discount&quot;)
        void shouldApplyBasicCustomerDiscount() {
            // Arrange
            Money amount = Money.of(100.00, &quot;USD&quot;);
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Basic&quot;)).thenReturn(0.0);
            
            // Act
            Money discountedAmount = pricingService.applyCustomerDiscount(amount, customer);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(100.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Apply Bulk Discount Tests&quot;)
    class ApplyBulkDiscountTests {
        
        @Test
        @DisplayName(&quot;Should apply bulk discount for orders over $1000&quot;)
        void shouldApplyBulkDiscountForOrdersOver1000() {
            // Arrange
            Money amount = Money.of(1200.00, &quot;USD&quot;);
            Order order = createOrderWithAmount(1200.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(1200.0)).thenReturn(0.10);
            
            // Act
            Money discountedAmount = pricingService.applyBulkDiscount(amount, order);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(1080.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should apply bulk discount for orders over $500&quot;)
        void shouldApplyBulkDiscountForOrdersOver500() {
            // Arrange
            Money amount = Money.of(600.00, &quot;USD&quot;);
            Order order = createOrderWithAmount(600.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(600.0)).thenReturn(0.05);
            
            // Act
            Money discountedAmount = pricingService.applyBulkDiscount(amount, order);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(570.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should apply bulk discount for orders over $100&quot;)
        void shouldApplyBulkDiscountForOrdersOver100() {
            // Arrange
            Money amount = Money.of(150.00, &quot;USD&quot;);
            Order order = createOrderWithAmount(150.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(150.0)).thenReturn(0.02);
            
            // Act
            Money discountedAmount = pricingService.applyBulkDiscount(amount, order);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(147.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should not apply bulk discount for orders under $100&quot;)
        void shouldNotApplyBulkDiscountForOrdersUnder100() {
            // Arrange
            Money amount = Money.of(50.00, &quot;USD&quot;);
            Order order = createOrderWithAmount(50.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(50.0)).thenReturn(0.0);
            
            // Act
            Money discountedAmount = pricingService.applyBulkDiscount(amount, order);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(50.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Apply Shipping Discount Tests&quot;)
    class ApplyShippingDiscountTests {
        
        @Test
        @DisplayName(&quot;Should apply free shipping for orders over $50&quot;)
        void shouldApplyFreeShippingForOrdersOver50() {
            // Arrange
            Money shipping = Money.of(5.99, &quot;USD&quot;);
            Money orderAmount = Money.of(75.00, &quot;USD&quot;);
            
            // Act
            Money discountedShipping = pricingService.applyShippingDiscount(shipping, orderAmount);
            
            // Assert
            assertThat(discountedShipping.getAmount()).isEqualTo(0.00);
            assertThat(discountedShipping.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should apply 50% shipping discount for orders over $25&quot;)
        void shouldApply50PercentShippingDiscountForOrdersOver25() {
            // Arrange
            Money shipping = Money.of(5.99, &quot;USD&quot;);
            Money orderAmount = Money.of(30.00, &quot;USD&quot;);
            
            // Act
            Money discountedShipping = pricingService.applyShippingDiscount(shipping, orderAmount);
            
            // Assert
            assertThat(discountedShipping.getAmount()).isEqualTo(2.995);
            assertThat(discountedShipping.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should not apply shipping discount for orders under $25&quot;)
        void shouldNotApplyShippingDiscountForOrdersUnder25() {
            // Arrange
            Money shipping = Money.of(5.99, &quot;USD&quot;);
            Money orderAmount = Money.of(20.00, &quot;USD&quot;);
            
            // Act
            Money discountedShipping = pricingService.applyShippingDiscount(shipping, orderAmount);
            
            // Assert
            assertThat(discountedShipping.getAmount()).isEqualTo(5.99);
            assertThat(discountedShipping.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Get Customer Discount Rate Tests&quot;)
    class GetCustomerDiscountRateTests {
        
        @Test
        @DisplayName(&quot;Should get VIP customer discount rate&quot;)
        void shouldGetVipCustomerDiscountRate() {
            // Arrange
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;VIP&quot;)).thenReturn(0.15);
            
            // Act
            double discountRate = pricingService.getCustomerDiscountRate(customer.getCustomerType());
            
            // Assert
            assertThat(discountRate).isEqualTo(0.15);
        }
        
        @Test
        @DisplayName(&quot;Should get premium customer discount rate&quot;)
        void shouldGetPremiumCustomerDiscountRate() {
            // Arrange
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Premium&quot;)).thenReturn(0.10);
            
            // Act
            double discountRate = pricingService.getCustomerDiscountRate(customer.getCustomerType());
            
            // Assert
            assertThat(discountRate).isEqualTo(0.10);
        }
        
        @Test
        @DisplayName(&quot;Should get standard customer discount rate&quot;)
        void shouldGetStandardCustomerDiscountRate() {
            // Arrange
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Standard&quot;)).thenReturn(0.05);
            
            // Act
            double discountRate = pricingService.getCustomerDiscountRate(customer.getCustomerType());
            
            // Assert
            assertThat(discountRate).isEqualTo(0.05);
        }
        
        @Test
        @DisplayName(&quot;Should get basic customer discount rate&quot;)
        void shouldGetBasicCustomerDiscountRate() {
            // Arrange
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Basic&quot;)).thenReturn(0.0);
            
            // Act
            double discountRate = pricingService.getCustomerDiscountRate(customer.getCustomerType());
            
            // Assert
            assertThat(discountRate).isEqualTo(0.0);
        }
    }
    
    @Nested
    @DisplayName(&quot;Get Customer Type Discount Tests&quot;)
    class GetCustomerTypeDiscountTests {
        
        @Test
        @DisplayName(&quot;Should get VIP customer type discount&quot;)
        void shouldGetVipCustomerTypeDiscount() {
            // Arrange
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;VIP&quot;)).thenReturn(0.15);
            
            // Act
            Discount discount = pricingService.getCustomerTypeDiscount(customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo(&quot;VIP Customer Discount&quot;);
            assertThat(discount.getType()).isEqualTo(&quot;percentage&quot;);
            assertThat(discount.getValue()).isEqualTo(0.15);
            assertThat(discount.getDescription()).contains(&quot;VIP&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should get premium customer type discount&quot;)
        void shouldGetPremiumCustomerTypeDiscount() {
            // Arrange
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Premium&quot;)).thenReturn(0.10);
            
            // Act
            Discount discount = pricingService.getCustomerTypeDiscount(customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo(&quot;Premium Customer Discount&quot;);
            assertThat(discount.getType()).isEqualTo(&quot;percentage&quot;);
            assertThat(discount.getValue()).isEqualTo(0.10);
            assertThat(discount.getDescription()).contains(&quot;Premium&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should get standard customer type discount&quot;)
        void shouldGetStandardCustomerTypeDiscount() {
            // Arrange
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Standard&quot;)).thenReturn(0.05);
            
            // Act
            Discount discount = pricingService.getCustomerTypeDiscount(customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo(&quot;Standard Customer Discount&quot;);
            assertThat(discount.getType()).isEqualTo(&quot;percentage&quot;);
            assertThat(discount.getValue()).isEqualTo(0.05);
            assertThat(discount.getDescription()).contains(&quot;Standard&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should not get basic customer type discount&quot;)
        void shouldNotGetBasicCustomerTypeDiscount() {
            // Arrange
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Basic&quot;)).thenReturn(0.0);
            
            // Act
            Discount discount = pricingService.getCustomerTypeDiscount(customer);
            
            // Assert
            assertThat(discount).isNull();
        }
    }
    
    @Nested
    @DisplayName(&quot;Get Bulk Discount Tests&quot;)
    class GetBulkDiscountTests {
        
        @Test
        @DisplayName(&quot;Should get bulk discount for orders over $1000&quot;)
        void shouldGetBulkDiscountForOrdersOver1000() {
            // Arrange
            Order order = createOrderWithAmount(1200.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(1200.0)).thenReturn(0.10);
            
            // Act
            Discount discount = pricingService.getBulkDiscount(order);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo(&quot;Bulk Discount&quot;);
            assertThat(discount.getType()).isEqualTo(&quot;percentage&quot;);
            assertThat(discount.getValue()).isEqualTo(0.10);
            assertThat(discount.getDescription()).contains(&quot;10%&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should get bulk discount for orders over $500&quot;)
        void shouldGetBulkDiscountForOrdersOver500() {
            // Arrange
            Order order = createOrderWithAmount(600.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(600.0)).thenReturn(0.05);
            
            // Act
            Discount discount = pricingService.getBulkDiscount(order);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo(&quot;Bulk Discount&quot;);
            assertThat(discount.getType()).isEqualTo(&quot;percentage&quot;);
            assertThat(discount.getValue()).isEqualTo(0.05);
            assertThat(discount.getDescription()).contains(&quot;5%&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should not get bulk discount for orders under $500&quot;)
        void shouldNotGetBulkDiscountForOrdersUnder500() {
            // Arrange
            Order order = createOrderWithAmount(300.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(300.0)).thenReturn(0.0);
            
            // Act
            Discount discount = pricingService.getBulkDiscount(order);
            
            // Assert
            assertThat(discount).isNull();
        }
    }
    
    @Nested
    @DisplayName(&quot;Get Seasonal Discount Tests&quot;)
    class GetSeasonalDiscountTests {
        
        @Test
        @DisplayName(&quot;Should get holiday discount during December&quot;)
        void shouldGetHolidayDiscountDuringDecember() {
            // Arrange
            // Mock LocalDateTime to return December
            try (MockedStatic&lt;LocalDateTime&gt; mockedLocalDateTime = mockStatic(LocalDateTime.class)) {
                LocalDateTime mockDateTime = mock(LocalDateTime.class);
                when(mockDateTime.getMonthValue()).thenReturn(12);
                mockedLocalDateTime.when(LocalDateTime::now).thenReturn(mockDateTime);
                
                // Act
                Discount discount = pricingService.getSeasonalDiscount();
                
                // Assert
                assertThat(discount).isNotNull();
                assertThat(discount.getName()).isEqualTo(&quot;Holiday Discount&quot;);
                assertThat(discount.getType()).isEqualTo(&quot;percentage&quot;);
                assertThat(discount.getValue()).isEqualTo(0.08);
                assertThat(discount.getDescription()).contains(&quot;holiday&quot;);
            }
        }
        
        @Test
        @DisplayName(&quot;Should not get seasonal discount during non-holiday season&quot;)
        void shouldNotGetSeasonalDiscountDuringNonHolidaySeason() {
            // Arrange
            // Mock LocalDateTime to return March
            try (MockedStatic&lt;LocalDateTime&gt; mockedLocalDateTime = mockStatic(LocalDateTime.class)) {
                LocalDateTime mockDateTime = mock(LocalDateTime.class);
                when(mockDateTime.getMonthValue()).thenReturn(3);
                mockedLocalDateTime.when(LocalDateTime::now).thenReturn(mockDateTime);
                
                // Act
                Discount discount = pricingService.getSeasonalDiscount();
                
                // Assert
                assertThat(discount).isNull();
            }
        }
    }
    
    @Nested
    @DisplayName(&quot;Get Product Discounts Tests&quot;)
    class GetProductDiscountsTests {
        
        @Test
        @DisplayName(&quot;Should get product discounts for sale items&quot;)
        void shouldGetProductDiscountsForSaleItems() {
            // Arrange
            Order order = createOrderWithSaleItems();
            
            // Act
            List&lt;Discount&gt; discounts = pricingService.getProductDiscounts(order);
            
            // Assert
            assertThat(discounts).isNotEmpty();
            assertThat(discounts).allMatch(d -&gt; d.getName().equals(&quot;Sale Item Discount&quot;));
            assertThat(discounts).allMatch(d -&gt; d.getType().equals(&quot;percentage&quot;));
            assertThat(discounts).allMatch(d -&gt; d.getValue() == 0.20);
            assertThat(discounts).allMatch(d -&gt; d.getDescription().contains(&quot;sale&quot;));
        }
        
        @Test
        @DisplayName(&quot;Should not get product discounts for non-sale items&quot;)
        void shouldNotGetProductDiscountsForNonSaleItems() {
            // Arrange
            Order order = createOrderWithItems();
            
            // Act
            List&lt;Discount&gt; discounts = pricingService.getProductDiscounts(order);
            
            // Assert
            assertThat(discounts).isEmpty();
        }
    }
    
    @Nested
    @DisplayName(&quot;Pricing Service Integration Tests&quot;)
    class PricingServiceIntegrationTests {
        
        @Test
        @DisplayName(&quot;Should calculate complete order total with all discounts&quot;)
        void shouldCalculateCompleteOrderTotalWithAllDiscounts() {
            // Arrange
            Order order = createOrderWithAmount(1200.00);
            Customer customer = createVipCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;VIP&quot;)).thenReturn(0.15);
            when(mockDiscountRuleRepository.getBulkDiscountRate(1020.0)).thenReturn(0.10);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(73.44, &quot;USD&quot;));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, &quot;USD&quot;));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(total.getAmount()).isGreaterThan(0);
            
            // Verify all dependencies were called
            verify(mockDiscountRuleRepository).getCustomerDiscountRate(&quot;VIP&quot;);
            verify(mockDiscountRuleRepository).getBulkDiscountRate(1020.0);
            verify(mockTaxCalculator).calculateTax(any(Money.class), eq(address));
            verify(mockShippingCalculator).calculateShipping(eq(order), eq(address));
        }
        
        @Test
        @DisplayName(&quot;Should handle complex discount scenarios&quot;)
        void shouldHandleComplexDiscountScenarios() {
            // Arrange
            Order order = createOrderWithAmount(600.00);
            Customer customer = createPremiumCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(&quot;Premium&quot;)).thenReturn(0.10);
            when(mockDiscountRuleRepository.getBulkDiscountRate(540.0)).thenReturn(0.05);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(38.88, &quot;USD&quot;));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, &quot;USD&quot;));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(total.getAmount()).isGreaterThan(0);
        }
    }
    
    @Nested
    @DisplayName(&quot;Pricing Service Parameterized Tests&quot;)
    class PricingServiceParameterizedTests {
        
        @ParameterizedTest
        @CsvSource({
            &quot;VIP, 0.15&quot;,
            &quot;Premium, 0.10&quot;,
            &quot;Standard, 0.05&quot;,
            &quot;Basic, 0.0&quot;,
            &quot;Unknown, 0.0&quot;
        })
        @DisplayName(&quot;Should get correct customer discount rates&quot;)
        void shouldGetCorrectCustomerDiscountRates(String customerType, double expectedRate) {
            // Arrange
            Customer customer = createCustomerWithType(customerType);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate(customerType)).thenReturn(expectedRate);
            
            // Act
            double discountRate = pricingService.getCustomerDiscountRate(customerType);
            
            // Assert
            assertThat(discountRate).isEqualTo(expectedRate);
        }
        
        @ParameterizedTest
        @CsvSource({
            &quot;1200.0, 0.10&quot;,
            &quot;600.0, 0.05&quot;,
            &quot;150.0, 0.02&quot;,
            &quot;50.0, 0.0&quot;
        })
        @DisplayName(&quot;Should get correct bulk discount rates&quot;)
        void shouldGetCorrectBulkDiscountRates(double amount, double expectedRate) {
            // Arrange
            Order order = createOrderWithAmount(amount);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(amount)).thenReturn(expectedRate);
            
            // Act
            Discount discount = pricingService.getBulkDiscount(order);
            
            // Assert
            if (expectedRate &gt; 0) {
                assertThat(discount).isNotNull();
                assertThat(discount.getValue()).isEqualTo(expectedRate);
            } else {
                assertThat(discount).isNull();
            }
        }
        
        @ParameterizedTest
        @CsvSource({
            &quot;75.0, 0.0&quot;,
            &quot;30.0, 0.5&quot;,
            &quot;20.0, 1.0&quot;
        })
        @DisplayName(&quot;Should apply correct shipping discounts&quot;)
        void shouldApplyCorrectShippingDiscounts(double orderAmount, double expectedDiscount) {
            // Arrange
            Money shipping = Money.of(5.99, &quot;USD&quot;);
            Money orderAmountMoney = Money.of(orderAmount, &quot;USD&quot;);
            
            // Act
            Money discountedShipping = pricingService.applyShippingDiscount(shipping, orderAmountMoney);
            
            // Assert
            if (expectedDiscount == 0.0) {
                assertThat(discountedShipping.getAmount()).isEqualTo(0.0);
            } else if (expectedDiscount == 0.5) {
                assertThat(discountedShipping.getAmount()).isEqualTo(2.995);
            } else {
                assertThat(discountedShipping.getAmount()).isEqualTo(5.99);
            }
        }
    }
    
    // Helper methods for test setup
    private Order createOrderWithItems() {
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
        order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(25.50, &quot;USD&quot;));
        return order;
    }
    
    private Order createOrderWithAmount(double amount) {
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(amount, &quot;USD&quot;));
        return order;
    }
    
    private Order createOrderWithSaleItems() {
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;SALE-product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
        order.addItem(ProductId.of(&quot;SALE-product-2&quot;), 1, Money.of(25.50, &quot;USD&quot;));
        return order;
    }
    
    private Customer createActiveCustomer() {
        Customer customer = new Customer(CustomerId.generate(), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
        customer.activate();
        return customer;
    }
    
    private Customer createInactiveCustomer() {
        Customer customer = new Customer(CustomerId.generate(), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
        customer.deactivate();
        return customer;
    }
    
    private Customer createVipCustomer() {
        Customer customer = new Customer(CustomerId.generate(), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
        customer.activate();
        customer.recordOrder(Money.of(1000, &quot;USD&quot;)); // Make VIP
        return customer;
    }
    
    private Customer createPremiumCustomer() {
        Customer customer = new Customer(CustomerId.generate(), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
        customer.activate();
        customer.recordOrder(Money.of(500, &quot;USD&quot;)); // Make Premium
        return customer;
    }
    
    private Customer createBasicCustomer() {
        Customer customer = new Customer(CustomerId.generate(), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
        customer.activate();
        return customer;
    }
    
    private Customer createCustomerWithType(String customerType) {
        Customer customer = new Customer(CustomerId.generate(), &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
        customer.activate();
        
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
        
        return customer;
    }
    
    private Address createAddress() {
        return new Address(&quot;123 Main St&quot;, &quot;Anytown&quot;, &quot;CA&quot;, &quot;US&quot;, &quot;12345&quot;);
    }
}

// Example usage
public class PricingServiceTestExample {
    public static void main(String[] args) {
        // Create pricing service
        TaxCalculator taxCalculator = new TaxCalculator();
        ShippingCalculator shippingCalculator = new ShippingCalculator();
        DiscountRuleRepository discountRuleRepository = new DiscountRuleRepository();
        
        PricingService pricingService = new PricingService(
            taxCalculator,
            shippingCalculator,
            discountRuleRepository
        );
        
        // Create order
        CustomerId customerId = CustomerId.of(&quot;customer-123&quot;);
        Order order = new Order(OrderId.generate(), customerId);
        order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
        order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(25.50, &quot;USD&quot;));
        order.confirm();
        
        // Create customer
        Customer customer = new Customer(customerId, &quot;John Doe&quot;, EmailAddress.of(&quot;john.doe@example.com&quot;));
        customer.activate();
        
        // Create shipping address
        Address address = new Address(&quot;123 Main St&quot;, &quot;Anytown&quot;, &quot;CA&quot;, &quot;US&quot;, &quot;12345&quot;);
        
        // Calculate order total
        Money total = pricingService.calculateOrderTotal(order, customer, address);
        System.out.println(&quot;Order total: &quot; + total);
        
        // Calculate discount amount
        Money discount = pricingService.calculateDiscountAmount(order, customer);
        System.out.println(&quot;Discount amount: &quot; + discount);
        
        // Get available discounts
        List&lt;Discount&gt; discounts = pricingService.getAvailableDiscounts(order, customer);
        System.out.println(&quot;Available discounts:&quot;);
        for (Discount discountItem : discounts) {
            System.out.println(&quot;  &quot; + discountItem);
        }
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Testable Business Rules</h3>
<h4>1. <strong>Domain Service Testing</strong></h4>
<ul>
<li>✅ Tests focus on business logic without external dependencies</li>
<li>✅ Complex business rules are tested in isolation</li>
<li>✅ Service behavior is verified through comprehensive test cases</li>
</ul>
<h4>2. <strong>Business Rule Validation</strong></h4>
<ul>
<li>✅ Tests verify business rules are enforced correctly</li>
<li>✅ Different customer types get appropriate discounts</li>
<li>✅ Bulk discounts are applied based on order amounts</li>
</ul>
<h4>3. <strong>Service Composition Testing</strong></h4>
<ul>
<li>✅ Individual services (TaxCalculator, ShippingCalculator) are tested</li>
<li>✅ Service interactions are verified</li>
<li>✅ Complex calculations are broken down into testable components</li>
</ul>
<h4>4. <strong>Mock Usage</strong></h4>
<ul>
<li>✅ External dependencies are mocked for isolated testing</li>
<li>✅ Test data is created using helper methods</li>
<li>✅ Tests focus on business logic, not infrastructure</li>
</ul>
<h3>Pricing Service Testing Principles</h3>
<h4><strong>Test Business Rules</strong></h4>
<ul>
<li>✅ Customer discount rates are tested for all customer types</li>
<li>✅ Bulk discount thresholds are verified</li>
<li>✅ Shipping discount rules are tested</li>
</ul>
<h4><strong>Test Edge Cases</strong></h4>
<ul>
<li>✅ Boundary conditions (exactly $100, $500, $1000)</li>
<li>✅ Error conditions (inactive customers)</li>
<li>✅ Different address types (US, Canada, International)</li>
</ul>
<h4><strong>Test Service Composition</strong></h4>
<ul>
<li>✅ Individual services are tested separately</li>
<li>✅ Service interactions are verified</li>
<li>✅ Complex calculations are broken down</li>
</ul>
<h4><strong>Test Mocking</strong></h4>
<ul>
<li>✅ External dependencies are properly mocked</li>
<li>✅ Test data is created using helper methods</li>
<li>✅ Tests remain focused on business logic</li>
</ul>
<h3>Java Testing Benefits</h3>
<ul>
<li><strong>JUnit 5</strong>: Modern testing framework with annotations</li>
<li><strong>Mockito</strong>: Powerful mocking framework</li>
<li><strong>AssertJ</strong>: Fluent assertions for better readability</li>
<li><strong>Parameterized Tests</strong>: Test multiple scenarios efficiently</li>
<li><strong>Nested Tests</strong>: Organize tests by functionality</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Testing Implementation Details</strong></h4>
<ul>
<li>❌ Tests that verify internal implementation</li>
<li>❌ Tests that break when implementation changes</li>
<li>❌ Tests that don&#39;t verify business behavior</li>
</ul>
<h4><strong>Over-Mocking</strong></h4>
<ul>
<li>❌ Mocking everything instead of testing real behavior</li>
<li>❌ Tests that don&#39;t verify actual business logic</li>
<li>❌ Tests that are hard to maintain</li>
</ul>
<h4><strong>Incomplete Test Coverage</strong></h4>
<ul>
<li>❌ Tests that don&#39;t cover all business rules</li>
<li>❌ Tests that miss edge cases</li>
<li>❌ Tests that don&#39;t verify error conditions</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./05-pricing-service.md">Pricing Service</a> - Service being tested</li>
<li><a href="./07-order-tests.md">Order Tests</a> - Tests that use Pricing Service</li>
<li><a href="./08-money-tests.md">Money Tests</a> - Tests for Money value object</li>
<li><a href="../../1-introduction-to-the-domain.md#testable-business-rules">Testable Business Rules</a> - Testing concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 08-money-tests.md</li>
<li>Next: 10-customer-service-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#testable-business-rules">Testable Business Rules</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"09-pricing-service-tests"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"09-pricing-service-tests\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
