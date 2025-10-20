# Pricing Service Tests - Java Example

**Section**: [Testable Business Rules](../../1-introduction-to-the-domain.md#testable-business-rules)

**Navigation**: [← Previous: Money Tests](./08-money-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Pricing Service Tests (JUnit 5) - Domain Service Testing
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
@DisplayName("Pricing Service Tests")
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
    @DisplayName("Calculate Order Total Tests")
    class CalculateOrderTotalTests {
        
        @Test
        @DisplayName("Should calculate order total with active customer")
        void shouldCalculateOrderTotalWithActiveCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createActiveCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Standard")).thenReturn(0.05);
            when(mockDiscountRuleRepository.getBulkDiscountRate(100.0)).thenReturn(0.0);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(8.00, "USD"));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, "USD"));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo("USD");
            assertThat(total.getAmount()).isGreaterThan(0);
            
            // Verify dependencies were called
            verify(mockTaxCalculator).calculateTax(any(Money.class), eq(address));
            verify(mockShippingCalculator).calculateShipping(eq(order), eq(address));
        }
        
        @Test
        @DisplayName("Should throw exception when customer is inactive")
        void shouldThrowExceptionWhenCustomerIsInactive() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createInactiveCustomer();
            Address address = createAddress();
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                pricingService.calculateOrderTotal(order, customer, address);
            });
        }
        
        @Test
        @DisplayName("Should apply customer discount")
        void shouldApplyCustomerDiscount() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createVipCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("VIP")).thenReturn(0.15);
            when(mockDiscountRuleRepository.getBulkDiscountRate(85.0)).thenReturn(0.0);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(6.80, "USD"));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, "USD"));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo("USD");
            
            // Verify discount was applied
            verify(mockDiscountRuleRepository).getCustomerDiscountRate("VIP");
        }
        
        @Test
        @DisplayName("Should apply bulk discount")
        void shouldApplyBulkDiscount() {
            // Arrange
            Order order = createOrderWithAmount(1200.0);
            Customer customer = createActiveCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Standard")).thenReturn(0.05);
            when(mockDiscountRuleRepository.getBulkDiscountRate(1200.0)).thenReturn(0.10);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(86.40, "USD"));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, "USD"));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo("USD");
            
            // Verify bulk discount was applied
            verify(mockDiscountRuleRepository).getBulkDiscountRate(1200.0);
        }
    }
    
    @Nested
    @DisplayName("Calculate Discount Amount Tests")
    class CalculateDiscountAmountTests {
        
        @Test
        @DisplayName("Should calculate discount amount for VIP customer")
        void shouldCalculateDiscountAmountForVipCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("VIP")).thenReturn(0.15);
            when(mockDiscountRuleRepository.getBulkDiscountRate(85.0)).thenReturn(0.0);
            
            // Act
            Money discount = pricingService.calculateDiscountAmount(order, customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getCurrency()).isEqualTo("USD");
            assertThat(discount.getAmount()).isGreaterThan(0);
        }
        
        @Test
        @DisplayName("Should calculate discount amount for premium customer")
        void shouldCalculateDiscountAmountForPremiumCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Premium")).thenReturn(0.10);
            when(mockDiscountRuleRepository.getBulkDiscountRate(90.0)).thenReturn(0.0);
            
            // Act
            Money discount = pricingService.calculateDiscountAmount(order, customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getCurrency()).isEqualTo("USD");
            assertThat(discount.getAmount()).isGreaterThan(0);
        }
        
        @Test
        @DisplayName("Should calculate discount amount for standard customer")
        void shouldCalculateDiscountAmountForStandardCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Standard")).thenReturn(0.05);
            when(mockDiscountRuleRepository.getBulkDiscountRate(95.0)).thenReturn(0.0);
            
            // Act
            Money discount = pricingService.calculateDiscountAmount(order, customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getCurrency()).isEqualTo("USD");
            assertThat(discount.getAmount()).isGreaterThan(0);
        }
        
        @Test
        @DisplayName("Should calculate discount amount for basic customer")
        void shouldCalculateDiscountAmountForBasicCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Basic")).thenReturn(0.0);
            when(mockDiscountRuleRepository.getBulkDiscountRate(100.0)).thenReturn(0.0);
            
            // Act
            Money discount = pricingService.calculateDiscountAmount(order, customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getCurrency()).isEqualTo("USD");
            assertThat(discount.getAmount()).isEqualTo(0.0);
        }
    }
    
    @Nested
    @DisplayName("Get Available Discounts Tests")
    class GetAvailableDiscountsTests {
        
        @Test
        @DisplayName("Should get available discounts for VIP customer")
        void shouldGetAvailableDiscountsForVipCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("VIP")).thenReturn(0.15);
            when(mockDiscountRuleRepository.getBulkDiscountRate(85.0)).thenReturn(0.0);
            
            // Act
            List<Discount> discounts = pricingService.getAvailableDiscounts(order, customer);
            
            // Assert
            assertThat(discounts).isNotNull();
            assertThat(discounts).isNotEmpty();
            
            // Verify discount types
            assertThat(discounts).anyMatch(d -> d.getName().contains("VIP"));
        }
        
        @Test
        @DisplayName("Should get available discounts for premium customer")
        void shouldGetAvailableDiscountsForPremiumCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Premium")).thenReturn(0.10);
            when(mockDiscountRuleRepository.getBulkDiscountRate(90.0)).thenReturn(0.0);
            
            // Act
            List<Discount> discounts = pricingService.getAvailableDiscounts(order, customer);
            
            // Assert
            assertThat(discounts).isNotNull();
            assertThat(discounts).isNotEmpty();
            
            // Verify discount types
            assertThat(discounts).anyMatch(d -> d.getName().contains("Premium"));
        }
        
        @Test
        @DisplayName("Should get available discounts for standard customer")
        void shouldGetAvailableDiscountsForStandardCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Standard")).thenReturn(0.05);
            when(mockDiscountRuleRepository.getBulkDiscountRate(95.0)).thenReturn(0.0);
            
            // Act
            List<Discount> discounts = pricingService.getAvailableDiscounts(order, customer);
            
            // Assert
            assertThat(discounts).isNotNull();
            assertThat(discounts).isNotEmpty();
            
            // Verify discount types
            assertThat(discounts).anyMatch(d -> d.getName().contains("Standard"));
        }
        
        @Test
        @DisplayName("Should get available discounts for basic customer")
        void shouldGetAvailableDiscountsForBasicCustomer() {
            // Arrange
            Order order = createOrderWithItems();
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Basic")).thenReturn(0.0);
            when(mockDiscountRuleRepository.getBulkDiscountRate(100.0)).thenReturn(0.0);
            
            // Act
            List<Discount> discounts = pricingService.getAvailableDiscounts(order, customer);
            
            // Assert
            assertThat(discounts).isNotNull();
            // Basic customers might not have discounts
        }
    }
    
    @Nested
    @DisplayName("Apply Customer Discount Tests")
    class ApplyCustomerDiscountTests {
        
        @Test
        @DisplayName("Should apply VIP customer discount")
        void shouldApplyVipCustomerDiscount() {
            // Arrange
            Money amount = Money.of(100.00, "USD");
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("VIP")).thenReturn(0.15);
            
            // Act
            Money discountedAmount = pricingService.applyCustomerDiscount(amount, customer);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(85.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should apply premium customer discount")
        void shouldApplyPremiumCustomerDiscount() {
            // Arrange
            Money amount = Money.of(100.00, "USD");
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Premium")).thenReturn(0.10);
            
            // Act
            Money discountedAmount = pricingService.applyCustomerDiscount(amount, customer);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(90.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should apply standard customer discount")
        void shouldApplyStandardCustomerDiscount() {
            // Arrange
            Money amount = Money.of(100.00, "USD");
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Standard")).thenReturn(0.05);
            
            // Act
            Money discountedAmount = pricingService.applyCustomerDiscount(amount, customer);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(95.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should apply basic customer discount")
        void shouldApplyBasicCustomerDiscount() {
            // Arrange
            Money amount = Money.of(100.00, "USD");
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Basic")).thenReturn(0.0);
            
            // Act
            Money discountedAmount = pricingService.applyCustomerDiscount(amount, customer);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(100.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Apply Bulk Discount Tests")
    class ApplyBulkDiscountTests {
        
        @Test
        @DisplayName("Should apply bulk discount for orders over $1000")
        void shouldApplyBulkDiscountForOrdersOver1000() {
            // Arrange
            Money amount = Money.of(1200.00, "USD");
            Order order = createOrderWithAmount(1200.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(1200.0)).thenReturn(0.10);
            
            // Act
            Money discountedAmount = pricingService.applyBulkDiscount(amount, order);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(1080.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should apply bulk discount for orders over $500")
        void shouldApplyBulkDiscountForOrdersOver500() {
            // Arrange
            Money amount = Money.of(600.00, "USD");
            Order order = createOrderWithAmount(600.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(600.0)).thenReturn(0.05);
            
            // Act
            Money discountedAmount = pricingService.applyBulkDiscount(amount, order);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(570.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should apply bulk discount for orders over $100")
        void shouldApplyBulkDiscountForOrdersOver100() {
            // Arrange
            Money amount = Money.of(150.00, "USD");
            Order order = createOrderWithAmount(150.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(150.0)).thenReturn(0.02);
            
            // Act
            Money discountedAmount = pricingService.applyBulkDiscount(amount, order);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(147.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should not apply bulk discount for orders under $100")
        void shouldNotApplyBulkDiscountForOrdersUnder100() {
            // Arrange
            Money amount = Money.of(50.00, "USD");
            Order order = createOrderWithAmount(50.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(50.0)).thenReturn(0.0);
            
            // Act
            Money discountedAmount = pricingService.applyBulkDiscount(amount, order);
            
            // Assert
            assertThat(discountedAmount.getAmount()).isEqualTo(50.00);
            assertThat(discountedAmount.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Apply Shipping Discount Tests")
    class ApplyShippingDiscountTests {
        
        @Test
        @DisplayName("Should apply free shipping for orders over $50")
        void shouldApplyFreeShippingForOrdersOver50() {
            // Arrange
            Money shipping = Money.of(5.99, "USD");
            Money orderAmount = Money.of(75.00, "USD");
            
            // Act
            Money discountedShipping = pricingService.applyShippingDiscount(shipping, orderAmount);
            
            // Assert
            assertThat(discountedShipping.getAmount()).isEqualTo(0.00);
            assertThat(discountedShipping.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should apply 50% shipping discount for orders over $25")
        void shouldApply50PercentShippingDiscountForOrdersOver25() {
            // Arrange
            Money shipping = Money.of(5.99, "USD");
            Money orderAmount = Money.of(30.00, "USD");
            
            // Act
            Money discountedShipping = pricingService.applyShippingDiscount(shipping, orderAmount);
            
            // Assert
            assertThat(discountedShipping.getAmount()).isEqualTo(2.995);
            assertThat(discountedShipping.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should not apply shipping discount for orders under $25")
        void shouldNotApplyShippingDiscountForOrdersUnder25() {
            // Arrange
            Money shipping = Money.of(5.99, "USD");
            Money orderAmount = Money.of(20.00, "USD");
            
            // Act
            Money discountedShipping = pricingService.applyShippingDiscount(shipping, orderAmount);
            
            // Assert
            assertThat(discountedShipping.getAmount()).isEqualTo(5.99);
            assertThat(discountedShipping.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Get Customer Discount Rate Tests")
    class GetCustomerDiscountRateTests {
        
        @Test
        @DisplayName("Should get VIP customer discount rate")
        void shouldGetVipCustomerDiscountRate() {
            // Arrange
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("VIP")).thenReturn(0.15);
            
            // Act
            double discountRate = pricingService.getCustomerDiscountRate(customer.getCustomerType());
            
            // Assert
            assertThat(discountRate).isEqualTo(0.15);
        }
        
        @Test
        @DisplayName("Should get premium customer discount rate")
        void shouldGetPremiumCustomerDiscountRate() {
            // Arrange
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Premium")).thenReturn(0.10);
            
            // Act
            double discountRate = pricingService.getCustomerDiscountRate(customer.getCustomerType());
            
            // Assert
            assertThat(discountRate).isEqualTo(0.10);
        }
        
        @Test
        @DisplayName("Should get standard customer discount rate")
        void shouldGetStandardCustomerDiscountRate() {
            // Arrange
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Standard")).thenReturn(0.05);
            
            // Act
            double discountRate = pricingService.getCustomerDiscountRate(customer.getCustomerType());
            
            // Assert
            assertThat(discountRate).isEqualTo(0.05);
        }
        
        @Test
        @DisplayName("Should get basic customer discount rate")
        void shouldGetBasicCustomerDiscountRate() {
            // Arrange
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Basic")).thenReturn(0.0);
            
            // Act
            double discountRate = pricingService.getCustomerDiscountRate(customer.getCustomerType());
            
            // Assert
            assertThat(discountRate).isEqualTo(0.0);
        }
    }
    
    @Nested
    @DisplayName("Get Customer Type Discount Tests")
    class GetCustomerTypeDiscountTests {
        
        @Test
        @DisplayName("Should get VIP customer type discount")
        void shouldGetVipCustomerTypeDiscount() {
            // Arrange
            Customer customer = createVipCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("VIP")).thenReturn(0.15);
            
            // Act
            Discount discount = pricingService.getCustomerTypeDiscount(customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo("VIP Customer Discount");
            assertThat(discount.getType()).isEqualTo("percentage");
            assertThat(discount.getValue()).isEqualTo(0.15);
            assertThat(discount.getDescription()).contains("VIP");
        }
        
        @Test
        @DisplayName("Should get premium customer type discount")
        void shouldGetPremiumCustomerTypeDiscount() {
            // Arrange
            Customer customer = createPremiumCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Premium")).thenReturn(0.10);
            
            // Act
            Discount discount = pricingService.getCustomerTypeDiscount(customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo("Premium Customer Discount");
            assertThat(discount.getType()).isEqualTo("percentage");
            assertThat(discount.getValue()).isEqualTo(0.10);
            assertThat(discount.getDescription()).contains("Premium");
        }
        
        @Test
        @DisplayName("Should get standard customer type discount")
        void shouldGetStandardCustomerTypeDiscount() {
            // Arrange
            Customer customer = createActiveCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Standard")).thenReturn(0.05);
            
            // Act
            Discount discount = pricingService.getCustomerTypeDiscount(customer);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo("Standard Customer Discount");
            assertThat(discount.getType()).isEqualTo("percentage");
            assertThat(discount.getValue()).isEqualTo(0.05);
            assertThat(discount.getDescription()).contains("Standard");
        }
        
        @Test
        @DisplayName("Should not get basic customer type discount")
        void shouldNotGetBasicCustomerTypeDiscount() {
            // Arrange
            Customer customer = createBasicCustomer();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Basic")).thenReturn(0.0);
            
            // Act
            Discount discount = pricingService.getCustomerTypeDiscount(customer);
            
            // Assert
            assertThat(discount).isNull();
        }
    }
    
    @Nested
    @DisplayName("Get Bulk Discount Tests")
    class GetBulkDiscountTests {
        
        @Test
        @DisplayName("Should get bulk discount for orders over $1000")
        void shouldGetBulkDiscountForOrdersOver1000() {
            // Arrange
            Order order = createOrderWithAmount(1200.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(1200.0)).thenReturn(0.10);
            
            // Act
            Discount discount = pricingService.getBulkDiscount(order);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo("Bulk Discount");
            assertThat(discount.getType()).isEqualTo("percentage");
            assertThat(discount.getValue()).isEqualTo(0.10);
            assertThat(discount.getDescription()).contains("10%");
        }
        
        @Test
        @DisplayName("Should get bulk discount for orders over $500")
        void shouldGetBulkDiscountForOrdersOver500() {
            // Arrange
            Order order = createOrderWithAmount(600.00);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(600.0)).thenReturn(0.05);
            
            // Act
            Discount discount = pricingService.getBulkDiscount(order);
            
            // Assert
            assertThat(discount).isNotNull();
            assertThat(discount.getName()).isEqualTo("Bulk Discount");
            assertThat(discount.getType()).isEqualTo("percentage");
            assertThat(discount.getValue()).isEqualTo(0.05);
            assertThat(discount.getDescription()).contains("5%");
        }
        
        @Test
        @DisplayName("Should not get bulk discount for orders under $500")
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
    @DisplayName("Get Seasonal Discount Tests")
    class GetSeasonalDiscountTests {
        
        @Test
        @DisplayName("Should get holiday discount during December")
        void shouldGetHolidayDiscountDuringDecember() {
            // Arrange
            // Mock LocalDateTime to return December
            try (MockedStatic<LocalDateTime> mockedLocalDateTime = mockStatic(LocalDateTime.class)) {
                LocalDateTime mockDateTime = mock(LocalDateTime.class);
                when(mockDateTime.getMonthValue()).thenReturn(12);
                mockedLocalDateTime.when(LocalDateTime::now).thenReturn(mockDateTime);
                
                // Act
                Discount discount = pricingService.getSeasonalDiscount();
                
                // Assert
                assertThat(discount).isNotNull();
                assertThat(discount.getName()).isEqualTo("Holiday Discount");
                assertThat(discount.getType()).isEqualTo("percentage");
                assertThat(discount.getValue()).isEqualTo(0.08);
                assertThat(discount.getDescription()).contains("holiday");
            }
        }
        
        @Test
        @DisplayName("Should not get seasonal discount during non-holiday season")
        void shouldNotGetSeasonalDiscountDuringNonHolidaySeason() {
            // Arrange
            // Mock LocalDateTime to return March
            try (MockedStatic<LocalDateTime> mockedLocalDateTime = mockStatic(LocalDateTime.class)) {
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
    @DisplayName("Get Product Discounts Tests")
    class GetProductDiscountsTests {
        
        @Test
        @DisplayName("Should get product discounts for sale items")
        void shouldGetProductDiscountsForSaleItems() {
            // Arrange
            Order order = createOrderWithSaleItems();
            
            // Act
            List<Discount> discounts = pricingService.getProductDiscounts(order);
            
            // Assert
            assertThat(discounts).isNotEmpty();
            assertThat(discounts).allMatch(d -> d.getName().equals("Sale Item Discount"));
            assertThat(discounts).allMatch(d -> d.getType().equals("percentage"));
            assertThat(discounts).allMatch(d -> d.getValue() == 0.20);
            assertThat(discounts).allMatch(d -> d.getDescription().contains("sale"));
        }
        
        @Test
        @DisplayName("Should not get product discounts for non-sale items")
        void shouldNotGetProductDiscountsForNonSaleItems() {
            // Arrange
            Order order = createOrderWithItems();
            
            // Act
            List<Discount> discounts = pricingService.getProductDiscounts(order);
            
            // Assert
            assertThat(discounts).isEmpty();
        }
    }
    
    @Nested
    @DisplayName("Pricing Service Integration Tests")
    class PricingServiceIntegrationTests {
        
        @Test
        @DisplayName("Should calculate complete order total with all discounts")
        void shouldCalculateCompleteOrderTotalWithAllDiscounts() {
            // Arrange
            Order order = createOrderWithAmount(1200.00);
            Customer customer = createVipCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("VIP")).thenReturn(0.15);
            when(mockDiscountRuleRepository.getBulkDiscountRate(1020.0)).thenReturn(0.10);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(73.44, "USD"));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, "USD"));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo("USD");
            assertThat(total.getAmount()).isGreaterThan(0);
            
            // Verify all dependencies were called
            verify(mockDiscountRuleRepository).getCustomerDiscountRate("VIP");
            verify(mockDiscountRuleRepository).getBulkDiscountRate(1020.0);
            verify(mockTaxCalculator).calculateTax(any(Money.class), eq(address));
            verify(mockShippingCalculator).calculateShipping(eq(order), eq(address));
        }
        
        @Test
        @DisplayName("Should handle complex discount scenarios")
        void shouldHandleComplexDiscountScenarios() {
            // Arrange
            Order order = createOrderWithAmount(600.00);
            Customer customer = createPremiumCustomer();
            Address address = createAddress();
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getCustomerDiscountRate("Premium")).thenReturn(0.10);
            when(mockDiscountRuleRepository.getBulkDiscountRate(540.0)).thenReturn(0.05);
            when(mockTaxCalculator.calculateTax(any(Money.class), any(Address.class)))
                .thenReturn(Money.of(38.88, "USD"));
            when(mockShippingCalculator.calculateShipping(any(Order.class), any(Address.class)))
                .thenReturn(Money.of(5.99, "USD"));
            
            // Act
            Money total = pricingService.calculateOrderTotal(order, customer, address);
            
            // Assert
            assertThat(total).isNotNull();
            assertThat(total.getCurrency()).isEqualTo("USD");
            assertThat(total.getAmount()).isGreaterThan(0);
        }
    }
    
    @Nested
    @DisplayName("Pricing Service Parameterized Tests")
    class PricingServiceParameterizedTests {
        
        @ParameterizedTest
        @CsvSource({
            "VIP, 0.15",
            "Premium, 0.10",
            "Standard, 0.05",
            "Basic, 0.0",
            "Unknown, 0.0"
        })
        @DisplayName("Should get correct customer discount rates")
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
            "1200.0, 0.10",
            "600.0, 0.05",
            "150.0, 0.02",
            "50.0, 0.0"
        })
        @DisplayName("Should get correct bulk discount rates")
        void shouldGetCorrectBulkDiscountRates(double amount, double expectedRate) {
            // Arrange
            Order order = createOrderWithAmount(amount);
            
            // Mock dependencies
            when(mockDiscountRuleRepository.getBulkDiscountRate(amount)).thenReturn(expectedRate);
            
            // Act
            Discount discount = pricingService.getBulkDiscount(order);
            
            // Assert
            if (expectedRate > 0) {
                assertThat(discount).isNotNull();
                assertThat(discount.getValue()).isEqualTo(expectedRate);
            } else {
                assertThat(discount).isNull();
            }
        }
        
        @ParameterizedTest
        @CsvSource({
            "75.0, 0.0",
            "30.0, 0.5",
            "20.0, 1.0"
        })
        @DisplayName("Should apply correct shipping discounts")
        void shouldApplyCorrectShippingDiscounts(double orderAmount, double expectedDiscount) {
            // Arrange
            Money shipping = Money.of(5.99, "USD");
            Money orderAmountMoney = Money.of(orderAmount, "USD");
            
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
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
        order.addItem(ProductId.of("product-2"), 1, Money.of(25.50, "USD"));
        return order;
    }
    
    private Order createOrderWithAmount(double amount) {
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("product-1"), 1, Money.of(amount, "USD"));
        return order;
    }
    
    private Order createOrderWithSaleItems() {
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("SALE-product-1"), 2, Money.of(15.99, "USD"));
        order.addItem(ProductId.of("SALE-product-2"), 1, Money.of(25.50, "USD"));
        return order;
    }
    
    private Customer createActiveCustomer() {
        Customer customer = new Customer(CustomerId.generate(), "John Doe", EmailAddress.of("john.doe@example.com"));
        customer.activate();
        return customer;
    }
    
    private Customer createInactiveCustomer() {
        Customer customer = new Customer(CustomerId.generate(), "John Doe", EmailAddress.of("john.doe@example.com"));
        customer.deactivate();
        return customer;
    }
    
    private Customer createVipCustomer() {
        Customer customer = new Customer(CustomerId.generate(), "John Doe", EmailAddress.of("john.doe@example.com"));
        customer.activate();
        customer.recordOrder(Money.of(1000, "USD")); // Make VIP
        return customer;
    }
    
    private Customer createPremiumCustomer() {
        Customer customer = new Customer(CustomerId.generate(), "John Doe", EmailAddress.of("john.doe@example.com"));
        customer.activate();
        customer.recordOrder(Money.of(500, "USD")); // Make Premium
        return customer;
    }
    
    private Customer createBasicCustomer() {
        Customer customer = new Customer(CustomerId.generate(), "John Doe", EmailAddress.of("john.doe@example.com"));
        customer.activate();
        return customer;
    }
    
    private Customer createCustomerWithType(String customerType) {
        Customer customer = new Customer(CustomerId.generate(), "John Doe", EmailAddress.of("john.doe@example.com"));
        customer.activate();
        
        switch (customerType) {
            case "VIP":
                customer.recordOrder(Money.of(1000, "USD"));
                break;
            case "Premium":
                customer.recordOrder(Money.of(500, "USD"));
                break;
            default:
                // Standard or Basic
                break;
        }
        
        return customer;
    }
    
    private Address createAddress() {
        return new Address("123 Main St", "Anytown", "CA", "US", "12345");
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
        CustomerId customerId = CustomerId.of("customer-123");
        Order order = new Order(OrderId.generate(), customerId);
        order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
        order.addItem(ProductId.of("product-2"), 1, Money.of(25.50, "USD"));
        order.confirm();
        
        // Create customer
        Customer customer = new Customer(customerId, "John Doe", EmailAddress.of("john.doe@example.com"));
        customer.activate();
        
        // Create shipping address
        Address address = new Address("123 Main St", "Anytown", "CA", "US", "12345");
        
        // Calculate order total
        Money total = pricingService.calculateOrderTotal(order, customer, address);
        System.out.println("Order total: " + total);
        
        // Calculate discount amount
        Money discount = pricingService.calculateDiscountAmount(order, customer);
        System.out.println("Discount amount: " + discount);
        
        // Get available discounts
        List<Discount> discounts = pricingService.getAvailableDiscounts(order, customer);
        System.out.println("Available discounts:");
        for (Discount discountItem : discounts) {
            System.out.println("  " + discountItem);
        }
    }
}
```

## Key Concepts Demonstrated

### Testable Business Rules

#### 1. **Domain Service Testing**
- ✅ Tests focus on business logic without external dependencies
- ✅ Complex business rules are tested in isolation
- ✅ Service behavior is verified through comprehensive test cases

#### 2. **Business Rule Validation**
- ✅ Tests verify business rules are enforced correctly
- ✅ Different customer types get appropriate discounts
- ✅ Bulk discounts are applied based on order amounts

#### 3. **Service Composition Testing**
- ✅ Individual services (TaxCalculator, ShippingCalculator) are tested
- ✅ Service interactions are verified
- ✅ Complex calculations are broken down into testable components

#### 4. **Mock Usage**
- ✅ External dependencies are mocked for isolated testing
- ✅ Test data is created using helper methods
- ✅ Tests focus on business logic, not infrastructure

### Pricing Service Testing Principles

#### **Test Business Rules**
- ✅ Customer discount rates are tested for all customer types
- ✅ Bulk discount thresholds are verified
- ✅ Shipping discount rules are tested

#### **Test Edge Cases**
- ✅ Boundary conditions (exactly $100, $500, $1000)
- ✅ Error conditions (inactive customers)
- ✅ Different address types (US, Canada, International)

#### **Test Service Composition**
- ✅ Individual services are tested separately
- ✅ Service interactions are verified
- ✅ Complex calculations are broken down

#### **Test Mocking**
- ✅ External dependencies are properly mocked
- ✅ Test data is created using helper methods
- ✅ Tests remain focused on business logic

### Java Testing Benefits
- **JUnit 5**: Modern testing framework with annotations
- **Mockito**: Powerful mocking framework
- **AssertJ**: Fluent assertions for better readability
- **Parameterized Tests**: Test multiple scenarios efficiently
- **Nested Tests**: Organize tests by functionality
- **Error Handling**: Clear exception messages for business rules

### Common Anti-Patterns to Avoid

#### **Testing Implementation Details**
- ❌ Tests that verify internal implementation
- ❌ Tests that break when implementation changes
- ❌ Tests that don't verify business behavior

#### **Over-Mocking**
- ❌ Mocking everything instead of testing real behavior
- ❌ Tests that don't verify actual business logic
- ❌ Tests that are hard to maintain

#### **Incomplete Test Coverage**
- ❌ Tests that don't cover all business rules
- ❌ Tests that miss edge cases
- ❌ Tests that don't verify error conditions

## Related Concepts

- [Pricing Service](./05-pricing-service.md) - Service being tested
- [Order Tests](./07-order-tests.md) - Tests that use Pricing Service
- [Money Tests](./08-money-tests.md) - Tests for Money value object
- [Testable Business Rules](../../1-introduction-to-the-domain.md#testable-business-rules) - Testing concepts

/*
 * Navigation:
 * Previous: 08-money-tests.md
 * Next: 10-customer-service-tests.md
 *
 * Back to: [Testable Business Rules](../../1-introduction-to-the-domain.md#testable-business-rules)
 */
