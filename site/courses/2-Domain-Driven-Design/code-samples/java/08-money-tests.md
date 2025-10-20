# Money Tests - Java Example

**Section**: [Value Objects Enable Comprehensive Testing](../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing)

**Navigation**: [← Previous: Order Tests](./07-order-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Money Tests (JUnit 5) - Value Object Testing
// File: 2-Domain-Driven-Design/code-samples/java/08-money-tests.java

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;
import static org.assertj.core.api.Assertions.*;

import java.math.BigDecimal;
import java.math.RoundingMode;

// ✅ GOOD: Comprehensive Money Value Object Tests
@DisplayName("Money Value Object Tests")
class MoneyTest {
    
    @Nested
    @DisplayName("Money Creation Tests")
    class MoneyCreationTests {
        
        @Test
        @DisplayName("Should create money with valid amount")
        void shouldCreateMoneyWithValidAmount() {
            // Arrange
            double amount = 100.50;
            String currency = "USD";
            
            // Act
            Money money = Money.of(amount, currency);
            
            // Assert
            assertThat(money.getAmount()).isEqualTo(amount);
            assertThat(money.getCurrency()).isEqualTo(currency);
        }
        
        @Test
        @DisplayName("Should create money with zero amount")
        void shouldCreateMoneyWithZeroAmount() {
            // Arrange
            double amount = 0.0;
            String currency = "USD";
            
            // Act
            Money money = Money.of(amount, currency);
            
            // Assert
            assertThat(money.getAmount()).isEqualTo(amount);
            assertThat(money.getCurrency()).isEqualTo(currency);
        }
        
        @Test
        @DisplayName("Should throw exception when amount is negative")
        void shouldThrowExceptionWhenAmountIsNegative() {
            // Arrange
            double amount = -10.0;
            String currency = "USD";
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                Money.of(amount, currency);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when currency is empty")
        void shouldThrowExceptionWhenCurrencyIsEmpty() {
            // Arrange
            double amount = 100.0;
            String currency = "";
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                Money.of(amount, currency);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when currency is null")
        void shouldThrowExceptionWhenCurrencyIsNull() {
            // Arrange
            double amount = 100.0;
            String currency = null;
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                Money.of(amount, currency);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when currency is whitespace")
        void shouldThrowExceptionWhenCurrencyIsWhitespace() {
            // Arrange
            double amount = 100.0;
            String currency = "   ";
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                Money.of(amount, currency);
            });
        }
        
        @Test
        @DisplayName("Should normalize currency to uppercase")
        void shouldNormalizeCurrencyToUppercase() {
            // Arrange
            double amount = 100.0;
            String currency = "usd";
            
            // Act
            Money money = Money.of(amount, currency);
            
            // Assert
            assertThat(money.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should trim currency whitespace")
        void shouldTrimCurrencyWhitespace() {
            // Arrange
            double amount = 100.0;
            String currency = "  USD  ";
            
            // Act
            Money money = Money.of(amount, currency);
            
            // Assert
            assertThat(money.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Money Addition Tests")
    class MoneyAdditionTests {
        
        @Test
        @DisplayName("Should add money with same currency")
        void shouldAddMoneyWithSameCurrency() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(25.75, "USD");
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(126.25);
            assertThat(result.getCurrency()).isEqualTo("USD");
            assertThat(result).isNotSameAs(money1); // Should return new instance
            assertThat(result).isNotSameAs(money2); // Should return new instance
        }
        
        @Test
        @DisplayName("Should throw exception when adding different currencies")
        void shouldThrowExceptionWhenAddingDifferentCurrencies() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(25.75, "EUR");
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                money1.add(money2);
            });
        }
        
        @Test
        @DisplayName("Should add zero amount")
        void shouldAddZeroAmount() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(0.0, "USD");
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(100.50);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should add large amounts")
        void shouldAddLargeAmounts() {
            // Arrange
            Money money1 = Money.of(999999.99, "USD");
            Money money2 = Money.of(0.01, "USD");
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(1000000.00);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Money Subtraction Tests")
    class MoneySubtractionTests {
        
        @Test
        @DisplayName("Should subtract money with same currency")
        void shouldSubtractMoneyWithSameCurrency() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(25.75, "USD");
            
            // Act
            Money result = money1.subtract(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(74.75);
            assertThat(result.getCurrency()).isEqualTo("USD");
            assertThat(result).isNotSameAs(money1); // Should return new instance
            assertThat(result).isNotSameAs(money2); // Should return new instance
        }
        
        @Test
        @DisplayName("Should throw exception when subtracting different currencies")
        void shouldThrowExceptionWhenSubtractingDifferentCurrencies() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(25.75, "EUR");
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                money1.subtract(money2);
            });
        }
        
        @Test
        @DisplayName("Should subtract zero amount")
        void shouldSubtractZeroAmount() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(0.0, "USD");
            
            // Act
            Money result = money1.subtract(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(100.50);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should subtract larger amount")
        void shouldSubtractLargerAmount() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(150.75, "USD");
            
            // Act
            Money result = money1.subtract(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(-50.25);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Money Multiplication Tests")
    class MoneyMultiplicationTests {
        
        @Test
        @DisplayName("Should multiply money by positive factor")
        void shouldMultiplyMoneyByPositiveFactor() {
            // Arrange
            Money money = Money.of(100.50, "USD");
            double factor = 2.5;
            
            // Act
            Money result = money.multiply(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(251.25);
            assertThat(result.getCurrency()).isEqualTo("USD");
            assertThat(result).isNotSameAs(money); // Should return new instance
        }
        
        @Test
        @DisplayName("Should multiply money by zero")
        void shouldMultiplyMoneyByZero() {
            // Arrange
            Money money = Money.of(100.50, "USD");
            double factor = 0.0;
            
            // Act
            Money result = money.multiply(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(0.0);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should throw exception when multiplying by negative factor")
        void shouldThrowExceptionWhenMultiplyingByNegativeFactor() {
            // Arrange
            Money money = Money.of(100.50, "USD");
            double factor = -1.5;
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                money.multiply(factor);
            });
        }
        
        @Test
        @DisplayName("Should multiply money by decimal factor")
        void shouldMultiplyMoneyByDecimalFactor() {
            // Arrange
            Money money = Money.of(100.00, "USD");
            double factor = 0.15; // 15%
            
            // Act
            Money result = money.multiply(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(15.00);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Money Division Tests")
    class MoneyDivisionTests {
        
        @Test
        @DisplayName("Should divide money by positive factor")
        void shouldDivideMoneyByPositiveFactor() {
            // Arrange
            Money money = Money.of(100.50, "USD");
            double factor = 2.0;
            
            // Act
            Money result = money.divide(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(50.25);
            assertThat(result.getCurrency()).isEqualTo("USD");
            assertThat(result).isNotSameAs(money); // Should return new instance
        }
        
        @Test
        @DisplayName("Should throw exception when dividing by zero")
        void shouldThrowExceptionWhenDividingByZero() {
            // Arrange
            Money money = Money.of(100.50, "USD");
            double factor = 0.0;
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                money.divide(factor);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when dividing by negative factor")
        void shouldThrowExceptionWhenDividingByNegativeFactor() {
            // Arrange
            Money money = Money.of(100.50, "USD");
            double factor = -2.0;
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                money.divide(factor);
            });
        }
        
        @Test
        @DisplayName("Should divide money by decimal factor")
        void shouldDivideMoneyByDecimalFactor() {
            // Arrange
            Money money = Money.of(100.00, "USD");
            double factor = 0.5; // 50%
            
            // Act
            Money result = money.divide(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(200.00);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Money Equality Tests")
    class MoneyEqualityTests {
        
        @Test
        @DisplayName("Should be equal when amounts and currencies are same")
        void shouldBeEqualWhenAmountsAndCurrenciesAreSame() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(100.50, "USD");
            
            // Act & Assert
            assertThat(money1).isEqualTo(money2);
            assertThat(money1.hashCode()).isEqualTo(money2.hashCode());
        }
        
        @Test
        @DisplayName("Should not be equal when amounts are different")
        void shouldNotBeEqualWhenAmountsAreDifferent() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(100.51, "USD");
            
            // Act & Assert
            assertThat(money1).isNotEqualTo(money2);
        }
        
        @Test
        @DisplayName("Should not be equal when currencies are different")
        void shouldNotBeEqualWhenCurrenciesAreDifferent() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(100.50, "EUR");
            
            // Act & Assert
            assertThat(money1).isNotEqualTo(money2);
        }
        
        @Test
        @DisplayName("Should not be equal to null")
        void shouldNotBeEqualToString() {
            // Arrange
            Money money = Money.of(100.50, "USD");
            
            // Act & Assert
            assertThat(money).isNotEqualTo(null);
        }
        
        @Test
        @DisplayName("Should not be equal to different type")
        void shouldNotBeEqualToString() {
            // Arrange
            Money money = Money.of(100.50, "USD");
            String string = "100.50 USD";
            
            // Act & Assert
            assertThat(money).isNotEqualTo(string);
        }
    }
    
    @Nested
    @DisplayName("Money Factory Method Tests")
    class MoneyFactoryMethodTests {
        
        @Test
        @DisplayName("Should create zero money")
        void shouldCreateZeroMoney() {
            // Act
            Money zeroUsd = Money.zero("USD");
            
            // Assert
            assertThat(zeroUsd.getAmount()).isEqualTo(0.0);
            assertThat(zeroUsd.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should create zero money with different currency")
        void shouldCreateZeroMoneyWithDifferentCurrency() {
            // Act
            Money zeroEur = Money.zero("EUR");
            
            // Assert
            assertThat(zeroEur.getAmount()).isEqualTo(0.0);
            assertThat(zeroEur.getCurrency()).isEqualTo("EUR");
        }
        
        @Test
        @DisplayName("Should create money from amount")
        void shouldCreateMoneyFromAmount() {
            // Act
            Money amountUsd = Money.fromAmount(100.50, "USD");
            
            // Assert
            assertThat(amountUsd.getAmount()).isEqualTo(100.50);
            assertThat(amountUsd.getCurrency()).isEqualTo("USD");
        }
    }
    
    @Nested
    @DisplayName("Money Comparison Tests")
    class MoneyComparisonTests {
        
        @Test
        @DisplayName("Should compare money amounts")
        void shouldCompareMoneyAmounts() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(200.75, "USD");
            Money money3 = Money.of(100.50, "USD");
            
            // Act & Assert
            assertThat(money1).isLessThan(money2);
            assertThat(money2).isGreaterThan(money1);
            assertThat(money1).isLessThanOrEqualTo(money3);
            assertThat(money1).isGreaterThanOrEqualTo(money3);
        }
        
        @Test
        @DisplayName("Should throw exception when comparing different currencies")
        void shouldThrowExceptionWhenComparingDifferentCurrencies() {
            // Arrange
            Money money1 = Money.of(100.50, "USD");
            Money money2 = Money.of(100.50, "EUR");
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                money1.compareTo(money2);
            });
        }
    }
    
    @Nested
    @DisplayName("Money Utility Method Tests")
    class MoneyUtilityMethodTests {
        
        @Test
        @DisplayName("Should round money to cents")
        void shouldRoundMoneyToCents() {
            // Arrange
            Money money = Money.of(100.567, "USD");
            
            // Act
            Money rounded = money.roundToCents();
            
            // Assert
            assertThat(rounded.getAmount()).isEqualTo(100.57);
            assertThat(rounded.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should get absolute value of money")
        void shouldGetAbsoluteValueOfMoney() {
            // Arrange
            Money money = Money.of(-100.50, "USD");
            
            // Act
            Money absolute = money.abs();
            
            // Assert
            assertThat(absolute.getAmount()).isEqualTo(100.50);
            assertThat(absolute.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should negate money")
        void shouldNegateMoney() {
            // Arrange
            Money money = Money.of(100.50, "USD");
            
            // Act
            Money negated = money.negate();
            
            // Assert
            assertThat(negated.getAmount()).isEqualTo(-100.50);
            assertThat(negated.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should calculate percentage of money")
        void shouldCalculatePercentageOfMoney() {
            // Arrange
            Money money = Money.of(100.00, "USD");
            double percentage = 15.0; // 15%
            
            // Act
            Money result = money.percentage(percentage);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(15.00);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should throw exception when percentage is negative")
        void shouldThrowExceptionWhenPercentageIsNegative() {
            // Arrange
            Money money = Money.of(100.00, "USD");
            double percentage = -15.0;
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                money.percentage(percentage);
            });
        }
    }
    
    @Nested
    @DisplayName("Money Currency Validation Tests")
    class MoneyCurrencyValidationTests {
        
        @Test
        @DisplayName("Should accept valid currencies")
        void shouldAcceptValidCurrencies() {
            // Arrange
            String[] validCurrencies = {"USD", "EUR", "GBP", "JPY", "CAD", "AUD"};
            
            // Act & Assert
            for (String currency : validCurrencies) {
                Money money = Money.of(100.0, currency);
                assertThat(money.getCurrency()).isEqualTo(currency);
            }
        }
        
        @Test
        @DisplayName("Should reject invalid currencies")
        void shouldRejectInvalidCurrencies() {
            // Arrange
            String[] invalidCurrencies = {"", "   ", null, "INVALID", "123"};
            
            // Act & Assert
            for (String currency : invalidCurrencies) {
                assertThrows(IllegalArgumentException.class, () -> {
                    Money.of(100.0, currency);
                });
            }
        }
    }
    
    @Nested
    @DisplayName("Money Precision Tests")
    class MoneyPrecisionTests {
        
        @Test
        @DisplayName("Should handle decimal precision")
        void shouldHandleDecimalPrecision() {
            // Arrange
            Money money = Money.of(100.123456789, "USD");
            
            // Act
            Money rounded = money.roundToCents();
            
            // Assert
            assertThat(rounded.getAmount()).isEqualTo(100.12);
        }
        
        @Test
        @DisplayName("Should handle floating point precision")
        void shouldHandleFloatingPointPrecision() {
            // Arrange
            Money money1 = Money.of(0.1, "USD");
            Money money2 = Money.of(0.2, "USD");
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(0.3);
        }
    }
    
    @Nested
    @DisplayName("Money Arithmetic Chain Tests")
    class MoneyArithmeticChainTests {
        
        @Test
        @DisplayName("Should chain arithmetic operations")
        void shouldChainArithmeticOperations() {
            // Arrange
            Money money1 = Money.of(100.00, "USD");
            Money money2 = Money.of(50.00, "USD");
            Money money3 = Money.of(25.00, "USD");
            
            // Act
            Money result = money1.add(money2).subtract(money3).multiply(2.0);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(250.00);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should chain operations with different currencies")
        void shouldChainOperationsWithDifferentCurrencies() {
            // Arrange
            Money money1 = Money.of(100.00, "USD");
            Money money2 = Money.of(50.00, "EUR");
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                money1.add(money2).subtract(Money.of(25.00, "USD"));
            });
        }
    }
    
    @Nested
    @DisplayName("Money Parameterized Tests")
    class MoneyParameterizedTests {
        
        @ParameterizedTest
        @CsvSource({
            "100.0, 50.0, 150.0",
            "0.0, 100.0, 100.0",
            "25.50, 75.25, 100.75",
            "999.99, 0.01, 1000.0"
        })
        @DisplayName("Should add money with different parameters")
        void shouldAddMoneyWithDifferentParameters(double amount1, double amount2, double expected) {
            // Arrange
            Money money1 = Money.of(amount1, "USD");
            Money money2 = Money.of(amount2, "USD");
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @ParameterizedTest
        @CsvSource({
            "100.0, 50.0, 50.0",
            "100.0, 100.0, 0.0",
            "25.50, 75.25, -49.75",
            "999.99, 0.01, 999.98"
        })
        @DisplayName("Should subtract money with different parameters")
        void shouldSubtractMoneyWithDifferentParameters(double amount1, double amount2, double expected) {
            // Arrange
            Money money1 = Money.of(amount1, "USD");
            Money money2 = Money.of(amount2, "USD");
            
            // Act
            Money result = money1.subtract(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @ParameterizedTest
        @CsvSource({
            "100.0, 2.0, 200.0",
            "100.0, 0.5, 50.0",
            "100.0, 1.0, 100.0",
            "100.0, 0.0, 0.0"
        })
        @DisplayName("Should multiply money with different parameters")
        void shouldMultiplyMoneyWithDifferentParameters(double amount, double factor, double expected) {
            // Arrange
            Money money = Money.of(amount, "USD");
            
            // Act
            Money result = money.multiply(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @ParameterizedTest
        @CsvSource({
            "100.0, 2.0, 50.0",
            "100.0, 4.0, 25.0",
            "100.0, 1.0, 100.0",
            "100.0, 0.5, 200.0"
        })
        @DisplayName("Should divide money with different parameters")
        void shouldDivideMoneyWithDifferentParameters(double amount, double factor, double expected) {
            // Arrange
            Money money = Money.of(amount, "USD");
            
            // Act
            Money result = money.divide(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @ParameterizedTest
        @CsvSource({
            "100.0, 10.0, 10.0",
            "100.0, 15.0, 15.0",
            "100.0, 0.0, 0.0",
            "100.0, 100.0, 100.0"
        })
        @DisplayName("Should calculate percentage with different parameters")
        void shouldCalculatePercentageWithDifferentParameters(double amount, double percentage, double expected) {
            // Arrange
            Money money = Money.of(amount, "USD");
            
            // Act
            Money result = money.percentage(percentage);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo("USD");
        }
        
        @ParameterizedTest
        @ValueSource(strings = {"USD", "EUR", "GBP", "JPY", "CAD", "AUD"})
        @DisplayName("Should create money with different currencies")
        void shouldCreateMoneyWithDifferentCurrencies(String currency) {
            // Arrange
            double amount = 100.50;
            
            // Act
            Money money = Money.of(amount, currency);
            
            // Assert
            assertThat(money.getAmount()).isEqualTo(amount);
            assertThat(money.getCurrency()).isEqualTo(currency);
        }
    }
    
    @Nested
    @DisplayName("Money Integration Tests")
    class MoneyIntegrationTests {
        
        @Test
        @DisplayName("Should work with order calculations")
        void shouldWorkWithOrderCalculations() {
            // Arrange
            Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
            order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
            order.addItem(ProductId.of("product-2"), 1, Money.of(25.50, "USD"));
            
            // Act
            Money total = order.getTotalAmount();
            
            // Assert
            assertThat(total.getCurrency()).isEqualTo("USD");
            assertThat(total.getAmount()).isGreaterThan(0);
            assertThat(total).isInstanceOf(Money.class);
        }
        
        @Test
        @DisplayName("Should work with pricing calculations")
        void shouldWorkWithPricingCalculations() {
            // Arrange
            Money basePrice = Money.of(100.00, "USD");
            Money discount = Money.of(10.00, "USD");
            Money tax = Money.of(8.00, "USD");
            
            // Act
            Money finalPrice = basePrice.subtract(discount).add(tax);
            
            // Assert
            assertThat(finalPrice.getAmount()).isEqualTo(98.00);
            assertThat(finalPrice.getCurrency()).isEqualTo("USD");
        }
        
        @Test
        @DisplayName("Should work with currency conversion simulation")
        void shouldWorkWithCurrencyConversionSimulation() {
            // Arrange
            Money usdAmount = Money.of(100.00, "USD");
            double exchangeRate = 0.85; // USD to EUR
            
            // Act
            Money eurAmount = Money.of(usdAmount.getAmount() * exchangeRate, "EUR");
            
            // Assert
            assertThat(eurAmount.getAmount()).isEqualTo(85.00);
            assertThat(eurAmount.getCurrency()).isEqualTo("EUR");
        }
    }
}

// ✅ GOOD: Money Factory Tests
@DisplayName("Money Factory Tests")
class MoneyFactoryTest {
    
    @Test
    @DisplayName("Should create zero money")
    void shouldCreateZeroMoney() {
        // Act
        Money zeroUsd = Money.zero("USD");
        
        // Assert
        assertThat(zeroUsd.getAmount()).isEqualTo(0.0);
        assertThat(zeroUsd.getCurrency()).isEqualTo("USD");
    }
    
    @Test
    @DisplayName("Should create zero money with different currency")
    void shouldCreateZeroMoneyWithDifferentCurrency() {
        // Act
        Money zeroEur = Money.zero("EUR");
        
        // Assert
        assertThat(zeroEur.getAmount()).isEqualTo(0.0);
        assertThat(zeroEur.getCurrency()).isEqualTo("EUR");
    }
    
    @Test
    @DisplayName("Should create money from amount")
    void shouldCreateMoneyFromAmount() {
        // Act
        Money amountUsd = Money.fromAmount(100.50, "USD");
        
        // Assert
        assertThat(amountUsd.getAmount()).isEqualTo(100.50);
        assertThat(amountUsd.getCurrency()).isEqualTo("USD");
    }
}

// Example usage
public class MoneyTestExample {
    public static void main(String[] args) {
        // Create money
        Money money = Money.of(100.50, "USD");
        System.out.println("Money created: " + money);
        
        // Test operations
        Money added = money.add(Money.of(25.25, "USD"));
        System.out.println("Added: " + added);
        
        Money subtracted = money.subtract(Money.of(25.25, "USD"));
        System.out.println("Subtracted: " + subtracted);
        
        Money multiplied = money.multiply(2.0);
        System.out.println("Multiplied: " + multiplied);
        
        Money divided = money.divide(2.0);
        System.out.println("Divided: " + divided);
        
        // Test equality
        Money sameMoney = Money.of(100.50, "USD");
        System.out.println("Equal: " + money.equals(sameMoney));
        
        // Test factory methods
        Money zero = Money.zero("USD");
        System.out.println("Zero: " + zero);
        
        Money fromAmount = Money.fromAmount(100.50, "USD");
        System.out.println("From amount: " + fromAmount);
        
        // Test utility methods
        Money rounded = money.roundToCents();
        System.out.println("Rounded: " + rounded);
        
        Money absolute = money.abs();
        System.out.println("Absolute: " + absolute);
        
        Money negated = money.negate();
        System.out.println("Negated: " + negated);
        
        Money percentage = money.percentage(15.0);
        System.out.println("Percentage: " + percentage);
    }
}
```

## Key Concepts Demonstrated

### Value Objects Enable Comprehensive Testing

#### 1. **Comprehensive Testing**
- ✅ Tests cover all public methods and properties
- ✅ Edge cases and error conditions are tested
- ✅ Immutability and equality are verified

#### 2. **Business Rule Validation**
- ✅ Tests verify business rules are enforced
- ✅ Invalid operations are properly rejected
- ✅ Value object behavior is consistent

#### 3. **Immutability Testing**
- ✅ Tests verify value objects cannot be modified
- ✅ Operations return new instances
- ✅ Thread safety is maintained

#### 4. **Equality and Hash Testing**
- ✅ Tests verify value-based equality
- ✅ Hash consistency is maintained
- ✅ Value objects can be used as dictionary keys

### Money Value Object Testing Principles

#### **Test All Operations**
- ✅ Addition, subtraction, multiplication, division
- ✅ Comparison operations
- ✅ Factory methods
- ✅ Utility methods

#### **Test Edge Cases**
- ✅ Zero amounts
- ✅ Negative factors
- ✅ Division by zero
- ✅ Precision handling

#### **Test Error Conditions**
- ✅ Invalid currencies
- ✅ Negative amounts
- ✅ Currency mismatches
- ✅ Invalid factors

#### **Test Immutability**
- ✅ Value objects cannot be modified
- ✅ Operations return new instances
- ✅ Original objects remain unchanged

### Java Testing Benefits
- **JUnit 5**: Modern testing framework with annotations
- **AssertJ**: Fluent assertions for better readability
- **Parameterized Tests**: Test multiple scenarios efficiently
- **Nested Tests**: Organize tests by functionality
- **Display Names**: Clear test descriptions
- **Error Handling**: Clear exception messages for business rules

### Common Anti-Patterns to Avoid

#### **Incomplete Test Coverage**
- ❌ Tests that don't cover all methods
- ❌ Tests that miss edge cases
- ❌ Tests that don't verify error conditions

#### **Testing Implementation Details**
- ❌ Tests that verify internal implementation
- ❌ Tests that break when implementation changes
- ❌ Tests that don't verify business behavior

#### **Over-Mocking**
- ❌ Mocking value objects instead of testing real behavior
- ❌ Tests that don't verify actual business logic
- ❌ Tests that are hard to maintain

## Related Concepts

- [Money Value Object](./02-money-value-object.md) - Value object being tested
- [Order Tests](./07-order-tests.md) - Tests that use Money
- [Order Entity](./03-order-entity.md) - Entity that uses Money
- [Value Objects Enable Comprehensive Testing](../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing) - Testing concepts

/*
 * Navigation:
 * Previous: 07-order-tests.md
 * Next: 09-pricing-service-tests.md
 *
 * Back to: [Value Objects Enable Comprehensive Testing](../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing)
 */
