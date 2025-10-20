1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/08-money-tests","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"08-money-tests\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T96c6,<h1>Money Tests - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing">Value Objects Enable Comprehensive Testing</a></p>
<p><strong>Navigation</strong>: <a href="./07-order-tests.md">← Previous: Order Tests</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - Money Tests (JUnit 5) - Value Object Testing
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
@DisplayName(&quot;Money Value Object Tests&quot;)
class MoneyTest {
    
    @Nested
    @DisplayName(&quot;Money Creation Tests&quot;)
    class MoneyCreationTests {
        
        @Test
        @DisplayName(&quot;Should create money with valid amount&quot;)
        void shouldCreateMoneyWithValidAmount() {
            // Arrange
            double amount = 100.50;
            String currency = &quot;USD&quot;;
            
            // Act
            Money money = Money.of(amount, currency);
            
            // Assert
            assertThat(money.getAmount()).isEqualTo(amount);
            assertThat(money.getCurrency()).isEqualTo(currency);
        }
        
        @Test
        @DisplayName(&quot;Should create money with zero amount&quot;)
        void shouldCreateMoneyWithZeroAmount() {
            // Arrange
            double amount = 0.0;
            String currency = &quot;USD&quot;;
            
            // Act
            Money money = Money.of(amount, currency);
            
            // Assert
            assertThat(money.getAmount()).isEqualTo(amount);
            assertThat(money.getCurrency()).isEqualTo(currency);
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when amount is negative&quot;)
        void shouldThrowExceptionWhenAmountIsNegative() {
            // Arrange
            double amount = -10.0;
            String currency = &quot;USD&quot;;
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                Money.of(amount, currency);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when currency is empty&quot;)
        void shouldThrowExceptionWhenCurrencyIsEmpty() {
            // Arrange
            double amount = 100.0;
            String currency = &quot;&quot;;
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                Money.of(amount, currency);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when currency is null&quot;)
        void shouldThrowExceptionWhenCurrencyIsNull() {
            // Arrange
            double amount = 100.0;
            String currency = null;
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                Money.of(amount, currency);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when currency is whitespace&quot;)
        void shouldThrowExceptionWhenCurrencyIsWhitespace() {
            // Arrange
            double amount = 100.0;
            String currency = &quot;   &quot;;
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                Money.of(amount, currency);
            });
        }
        
        @Test
        @DisplayName(&quot;Should normalize currency to uppercase&quot;)
        void shouldNormalizeCurrencyToUppercase() {
            // Arrange
            double amount = 100.0;
            String currency = &quot;usd&quot;;
            
            // Act
            Money money = Money.of(amount, currency);
            
            // Assert
            assertThat(money.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should trim currency whitespace&quot;)
        void shouldTrimCurrencyWhitespace() {
            // Arrange
            double amount = 100.0;
            String currency = &quot;  USD  &quot;;
            
            // Act
            Money money = Money.of(amount, currency);
            
            // Assert
            assertThat(money.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Addition Tests&quot;)
    class MoneyAdditionTests {
        
        @Test
        @DisplayName(&quot;Should add money with same currency&quot;)
        void shouldAddMoneyWithSameCurrency() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(25.75, &quot;USD&quot;);
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(126.25);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(result).isNotSameAs(money1); // Should return new instance
            assertThat(result).isNotSameAs(money2); // Should return new instance
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when adding different currencies&quot;)
        void shouldThrowExceptionWhenAddingDifferentCurrencies() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(25.75, &quot;EUR&quot;);
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                money1.add(money2);
            });
        }
        
        @Test
        @DisplayName(&quot;Should add zero amount&quot;)
        void shouldAddZeroAmount() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(0.0, &quot;USD&quot;);
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(100.50);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should add large amounts&quot;)
        void shouldAddLargeAmounts() {
            // Arrange
            Money money1 = Money.of(999999.99, &quot;USD&quot;);
            Money money2 = Money.of(0.01, &quot;USD&quot;);
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(1000000.00);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Subtraction Tests&quot;)
    class MoneySubtractionTests {
        
        @Test
        @DisplayName(&quot;Should subtract money with same currency&quot;)
        void shouldSubtractMoneyWithSameCurrency() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(25.75, &quot;USD&quot;);
            
            // Act
            Money result = money1.subtract(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(74.75);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(result).isNotSameAs(money1); // Should return new instance
            assertThat(result).isNotSameAs(money2); // Should return new instance
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when subtracting different currencies&quot;)
        void shouldThrowExceptionWhenSubtractingDifferentCurrencies() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(25.75, &quot;EUR&quot;);
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                money1.subtract(money2);
            });
        }
        
        @Test
        @DisplayName(&quot;Should subtract zero amount&quot;)
        void shouldSubtractZeroAmount() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(0.0, &quot;USD&quot;);
            
            // Act
            Money result = money1.subtract(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(100.50);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should subtract larger amount&quot;)
        void shouldSubtractLargerAmount() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(150.75, &quot;USD&quot;);
            
            // Act
            Money result = money1.subtract(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(-50.25);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Multiplication Tests&quot;)
    class MoneyMultiplicationTests {
        
        @Test
        @DisplayName(&quot;Should multiply money by positive factor&quot;)
        void shouldMultiplyMoneyByPositiveFactor() {
            // Arrange
            Money money = Money.of(100.50, &quot;USD&quot;);
            double factor = 2.5;
            
            // Act
            Money result = money.multiply(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(251.25);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(result).isNotSameAs(money); // Should return new instance
        }
        
        @Test
        @DisplayName(&quot;Should multiply money by zero&quot;)
        void shouldMultiplyMoneyByZero() {
            // Arrange
            Money money = Money.of(100.50, &quot;USD&quot;);
            double factor = 0.0;
            
            // Act
            Money result = money.multiply(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(0.0);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when multiplying by negative factor&quot;)
        void shouldThrowExceptionWhenMultiplyingByNegativeFactor() {
            // Arrange
            Money money = Money.of(100.50, &quot;USD&quot;);
            double factor = -1.5;
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                money.multiply(factor);
            });
        }
        
        @Test
        @DisplayName(&quot;Should multiply money by decimal factor&quot;)
        void shouldMultiplyMoneyByDecimalFactor() {
            // Arrange
            Money money = Money.of(100.00, &quot;USD&quot;);
            double factor = 0.15; // 15%
            
            // Act
            Money result = money.multiply(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(15.00);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Division Tests&quot;)
    class MoneyDivisionTests {
        
        @Test
        @DisplayName(&quot;Should divide money by positive factor&quot;)
        void shouldDivideMoneyByPositiveFactor() {
            // Arrange
            Money money = Money.of(100.50, &quot;USD&quot;);
            double factor = 2.0;
            
            // Act
            Money result = money.divide(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(50.25);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(result).isNotSameAs(money); // Should return new instance
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when dividing by zero&quot;)
        void shouldThrowExceptionWhenDividingByZero() {
            // Arrange
            Money money = Money.of(100.50, &quot;USD&quot;);
            double factor = 0.0;
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                money.divide(factor);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when dividing by negative factor&quot;)
        void shouldThrowExceptionWhenDividingByNegativeFactor() {
            // Arrange
            Money money = Money.of(100.50, &quot;USD&quot;);
            double factor = -2.0;
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                money.divide(factor);
            });
        }
        
        @Test
        @DisplayName(&quot;Should divide money by decimal factor&quot;)
        void shouldDivideMoneyByDecimalFactor() {
            // Arrange
            Money money = Money.of(100.00, &quot;USD&quot;);
            double factor = 0.5; // 50%
            
            // Act
            Money result = money.divide(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(200.00);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Equality Tests&quot;)
    class MoneyEqualityTests {
        
        @Test
        @DisplayName(&quot;Should be equal when amounts and currencies are same&quot;)
        void shouldBeEqualWhenAmountsAndCurrenciesAreSame() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(100.50, &quot;USD&quot;);
            
            // Act &amp; Assert
            assertThat(money1).isEqualTo(money2);
            assertThat(money1.hashCode()).isEqualTo(money2.hashCode());
        }
        
        @Test
        @DisplayName(&quot;Should not be equal when amounts are different&quot;)
        void shouldNotBeEqualWhenAmountsAreDifferent() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(100.51, &quot;USD&quot;);
            
            // Act &amp; Assert
            assertThat(money1).isNotEqualTo(money2);
        }
        
        @Test
        @DisplayName(&quot;Should not be equal when currencies are different&quot;)
        void shouldNotBeEqualWhenCurrenciesAreDifferent() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(100.50, &quot;EUR&quot;);
            
            // Act &amp; Assert
            assertThat(money1).isNotEqualTo(money2);
        }
        
        @Test
        @DisplayName(&quot;Should not be equal to null&quot;)
        void shouldNotBeEqualToString() {
            // Arrange
            Money money = Money.of(100.50, &quot;USD&quot;);
            
            // Act &amp; Assert
            assertThat(money).isNotEqualTo(null);
        }
        
        @Test
        @DisplayName(&quot;Should not be equal to different type&quot;)
        void shouldNotBeEqualToString() {
            // Arrange
            Money money = Money.of(100.50, &quot;USD&quot;);
            String string = &quot;100.50 USD&quot;;
            
            // Act &amp; Assert
            assertThat(money).isNotEqualTo(string);
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Factory Method Tests&quot;)
    class MoneyFactoryMethodTests {
        
        @Test
        @DisplayName(&quot;Should create zero money&quot;)
        void shouldCreateZeroMoney() {
            // Act
            Money zeroUsd = Money.zero(&quot;USD&quot;);
            
            // Assert
            assertThat(zeroUsd.getAmount()).isEqualTo(0.0);
            assertThat(zeroUsd.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should create zero money with different currency&quot;)
        void shouldCreateZeroMoneyWithDifferentCurrency() {
            // Act
            Money zeroEur = Money.zero(&quot;EUR&quot;);
            
            // Assert
            assertThat(zeroEur.getAmount()).isEqualTo(0.0);
            assertThat(zeroEur.getCurrency()).isEqualTo(&quot;EUR&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should create money from amount&quot;)
        void shouldCreateMoneyFromAmount() {
            // Act
            Money amountUsd = Money.fromAmount(100.50, &quot;USD&quot;);
            
            // Assert
            assertThat(amountUsd.getAmount()).isEqualTo(100.50);
            assertThat(amountUsd.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Comparison Tests&quot;)
    class MoneyComparisonTests {
        
        @Test
        @DisplayName(&quot;Should compare money amounts&quot;)
        void shouldCompareMoneyAmounts() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(200.75, &quot;USD&quot;);
            Money money3 = Money.of(100.50, &quot;USD&quot;);
            
            // Act &amp; Assert
            assertThat(money1).isLessThan(money2);
            assertThat(money2).isGreaterThan(money1);
            assertThat(money1).isLessThanOrEqualTo(money3);
            assertThat(money1).isGreaterThanOrEqualTo(money3);
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when comparing different currencies&quot;)
        void shouldThrowExceptionWhenComparingDifferentCurrencies() {
            // Arrange
            Money money1 = Money.of(100.50, &quot;USD&quot;);
            Money money2 = Money.of(100.50, &quot;EUR&quot;);
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                money1.compareTo(money2);
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Utility Method Tests&quot;)
    class MoneyUtilityMethodTests {
        
        @Test
        @DisplayName(&quot;Should round money to cents&quot;)
        void shouldRoundMoneyToCents() {
            // Arrange
            Money money = Money.of(100.567, &quot;USD&quot;);
            
            // Act
            Money rounded = money.roundToCents();
            
            // Assert
            assertThat(rounded.getAmount()).isEqualTo(100.57);
            assertThat(rounded.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should get absolute value of money&quot;)
        void shouldGetAbsoluteValueOfMoney() {
            // Arrange
            Money money = Money.of(-100.50, &quot;USD&quot;);
            
            // Act
            Money absolute = money.abs();
            
            // Assert
            assertThat(absolute.getAmount()).isEqualTo(100.50);
            assertThat(absolute.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should negate money&quot;)
        void shouldNegateMoney() {
            // Arrange
            Money money = Money.of(100.50, &quot;USD&quot;);
            
            // Act
            Money negated = money.negate();
            
            // Assert
            assertThat(negated.getAmount()).isEqualTo(-100.50);
            assertThat(negated.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should calculate percentage of money&quot;)
        void shouldCalculatePercentageOfMoney() {
            // Arrange
            Money money = Money.of(100.00, &quot;USD&quot;);
            double percentage = 15.0; // 15%
            
            // Act
            Money result = money.percentage(percentage);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(15.00);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when percentage is negative&quot;)
        void shouldThrowExceptionWhenPercentageIsNegative() {
            // Arrange
            Money money = Money.of(100.00, &quot;USD&quot;);
            double percentage = -15.0;
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                money.percentage(percentage);
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Currency Validation Tests&quot;)
    class MoneyCurrencyValidationTests {
        
        @Test
        @DisplayName(&quot;Should accept valid currencies&quot;)
        void shouldAcceptValidCurrencies() {
            // Arrange
            String[] validCurrencies = {&quot;USD&quot;, &quot;EUR&quot;, &quot;GBP&quot;, &quot;JPY&quot;, &quot;CAD&quot;, &quot;AUD&quot;};
            
            // Act &amp; Assert
            for (String currency : validCurrencies) {
                Money money = Money.of(100.0, currency);
                assertThat(money.getCurrency()).isEqualTo(currency);
            }
        }
        
        @Test
        @DisplayName(&quot;Should reject invalid currencies&quot;)
        void shouldRejectInvalidCurrencies() {
            // Arrange
            String[] invalidCurrencies = {&quot;&quot;, &quot;   &quot;, null, &quot;INVALID&quot;, &quot;123&quot;};
            
            // Act &amp; Assert
            for (String currency : invalidCurrencies) {
                assertThrows(IllegalArgumentException.class, () -&gt; {
                    Money.of(100.0, currency);
                });
            }
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Precision Tests&quot;)
    class MoneyPrecisionTests {
        
        @Test
        @DisplayName(&quot;Should handle decimal precision&quot;)
        void shouldHandleDecimalPrecision() {
            // Arrange
            Money money = Money.of(100.123456789, &quot;USD&quot;);
            
            // Act
            Money rounded = money.roundToCents();
            
            // Assert
            assertThat(rounded.getAmount()).isEqualTo(100.12);
        }
        
        @Test
        @DisplayName(&quot;Should handle floating point precision&quot;)
        void shouldHandleFloatingPointPrecision() {
            // Arrange
            Money money1 = Money.of(0.1, &quot;USD&quot;);
            Money money2 = Money.of(0.2, &quot;USD&quot;);
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(0.3);
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Arithmetic Chain Tests&quot;)
    class MoneyArithmeticChainTests {
        
        @Test
        @DisplayName(&quot;Should chain arithmetic operations&quot;)
        void shouldChainArithmeticOperations() {
            // Arrange
            Money money1 = Money.of(100.00, &quot;USD&quot;);
            Money money2 = Money.of(50.00, &quot;USD&quot;);
            Money money3 = Money.of(25.00, &quot;USD&quot;);
            
            // Act
            Money result = money1.add(money2).subtract(money3).multiply(2.0);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(250.00);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should chain operations with different currencies&quot;)
        void shouldChainOperationsWithDifferentCurrencies() {
            // Arrange
            Money money1 = Money.of(100.00, &quot;USD&quot;);
            Money money2 = Money.of(50.00, &quot;EUR&quot;);
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                money1.add(money2).subtract(Money.of(25.00, &quot;USD&quot;));
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Money Parameterized Tests&quot;)
    class MoneyParameterizedTests {
        
        @ParameterizedTest
        @CsvSource({
            &quot;100.0, 50.0, 150.0&quot;,
            &quot;0.0, 100.0, 100.0&quot;,
            &quot;25.50, 75.25, 100.75&quot;,
            &quot;999.99, 0.01, 1000.0&quot;
        })
        @DisplayName(&quot;Should add money with different parameters&quot;)
        void shouldAddMoneyWithDifferentParameters(double amount1, double amount2, double expected) {
            // Arrange
            Money money1 = Money.of(amount1, &quot;USD&quot;);
            Money money2 = Money.of(amount2, &quot;USD&quot;);
            
            // Act
            Money result = money1.add(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @ParameterizedTest
        @CsvSource({
            &quot;100.0, 50.0, 50.0&quot;,
            &quot;100.0, 100.0, 0.0&quot;,
            &quot;25.50, 75.25, -49.75&quot;,
            &quot;999.99, 0.01, 999.98&quot;
        })
        @DisplayName(&quot;Should subtract money with different parameters&quot;)
        void shouldSubtractMoneyWithDifferentParameters(double amount1, double amount2, double expected) {
            // Arrange
            Money money1 = Money.of(amount1, &quot;USD&quot;);
            Money money2 = Money.of(amount2, &quot;USD&quot;);
            
            // Act
            Money result = money1.subtract(money2);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @ParameterizedTest
        @CsvSource({
            &quot;100.0, 2.0, 200.0&quot;,
            &quot;100.0, 0.5, 50.0&quot;,
            &quot;100.0, 1.0, 100.0&quot;,
            &quot;100.0, 0.0, 0.0&quot;
        })
        @DisplayName(&quot;Should multiply money with different parameters&quot;)
        void shouldMultiplyMoneyWithDifferentParameters(double amount, double factor, double expected) {
            // Arrange
            Money money = Money.of(amount, &quot;USD&quot;);
            
            // Act
            Money result = money.multiply(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @ParameterizedTest
        @CsvSource({
            &quot;100.0, 2.0, 50.0&quot;,
            &quot;100.0, 4.0, 25.0&quot;,
            &quot;100.0, 1.0, 100.0&quot;,
            &quot;100.0, 0.5, 200.0&quot;
        })
        @DisplayName(&quot;Should divide money with different parameters&quot;)
        void shouldDivideMoneyWithDifferentParameters(double amount, double factor, double expected) {
            // Arrange
            Money money = Money.of(amount, &quot;USD&quot;);
            
            // Act
            Money result = money.divide(factor);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @ParameterizedTest
        @CsvSource({
            &quot;100.0, 10.0, 10.0&quot;,
            &quot;100.0, 15.0, 15.0&quot;,
            &quot;100.0, 0.0, 0.0&quot;,
            &quot;100.0, 100.0, 100.0&quot;
        })
        @DisplayName(&quot;Should calculate percentage with different parameters&quot;)
        void shouldCalculatePercentageWithDifferentParameters(double amount, double percentage, double expected) {
            // Arrange
            Money money = Money.of(amount, &quot;USD&quot;);
            
            // Act
            Money result = money.percentage(percentage);
            
            // Assert
            assertThat(result.getAmount()).isEqualTo(expected);
            assertThat(result.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @ParameterizedTest
        @ValueSource(strings = {&quot;USD&quot;, &quot;EUR&quot;, &quot;GBP&quot;, &quot;JPY&quot;, &quot;CAD&quot;, &quot;AUD&quot;})
        @DisplayName(&quot;Should create money with different currencies&quot;)
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
    @DisplayName(&quot;Money Integration Tests&quot;)
    class MoneyIntegrationTests {
        
        @Test
        @DisplayName(&quot;Should work with order calculations&quot;)
        void shouldWorkWithOrderCalculations() {
            // Arrange
            Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
            order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
            order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(25.50, &quot;USD&quot;));
            
            // Act
            Money total = order.getTotalAmount();
            
            // Assert
            assertThat(total.getCurrency()).isEqualTo(&quot;USD&quot;);
            assertThat(total.getAmount()).isGreaterThan(0);
            assertThat(total).isInstanceOf(Money.class);
        }
        
        @Test
        @DisplayName(&quot;Should work with pricing calculations&quot;)
        void shouldWorkWithPricingCalculations() {
            // Arrange
            Money basePrice = Money.of(100.00, &quot;USD&quot;);
            Money discount = Money.of(10.00, &quot;USD&quot;);
            Money tax = Money.of(8.00, &quot;USD&quot;);
            
            // Act
            Money finalPrice = basePrice.subtract(discount).add(tax);
            
            // Assert
            assertThat(finalPrice.getAmount()).isEqualTo(98.00);
            assertThat(finalPrice.getCurrency()).isEqualTo(&quot;USD&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should work with currency conversion simulation&quot;)
        void shouldWorkWithCurrencyConversionSimulation() {
            // Arrange
            Money usdAmount = Money.of(100.00, &quot;USD&quot;);
            double exchangeRate = 0.85; // USD to EUR
            
            // Act
            Money eurAmount = Money.of(usdAmount.getAmount() * exchangeRate, &quot;EUR&quot;);
            
            // Assert
            assertThat(eurAmount.getAmount()).isEqualTo(85.00);
            assertThat(eurAmount.getCurrency()).isEqualTo(&quot;EUR&quot;);
        }
    }
}

// ✅ GOOD: Money Factory Tests
@DisplayName(&quot;Money Factory Tests&quot;)
class MoneyFactoryTest {
    
    @Test
    @DisplayName(&quot;Should create zero money&quot;)
    void shouldCreateZeroMoney() {
        // Act
        Money zeroUsd = Money.zero(&quot;USD&quot;);
        
        // Assert
        assertThat(zeroUsd.getAmount()).isEqualTo(0.0);
        assertThat(zeroUsd.getCurrency()).isEqualTo(&quot;USD&quot;);
    }
    
    @Test
    @DisplayName(&quot;Should create zero money with different currency&quot;)
    void shouldCreateZeroMoneyWithDifferentCurrency() {
        // Act
        Money zeroEur = Money.zero(&quot;EUR&quot;);
        
        // Assert
        assertThat(zeroEur.getAmount()).isEqualTo(0.0);
        assertThat(zeroEur.getCurrency()).isEqualTo(&quot;EUR&quot;);
    }
    
    @Test
    @DisplayName(&quot;Should create money from amount&quot;)
    void shouldCreateMoneyFromAmount() {
        // Act
        Money amountUsd = Money.fromAmount(100.50, &quot;USD&quot;);
        
        // Assert
        assertThat(amountUsd.getAmount()).isEqualTo(100.50);
        assertThat(amountUsd.getCurrency()).isEqualTo(&quot;USD&quot;);
    }
}

// Example usage
public class MoneyTestExample {
    public static void main(String[] args) {
        // Create money
        Money money = Money.of(100.50, &quot;USD&quot;);
        System.out.println(&quot;Money created: &quot; + money);
        
        // Test operations
        Money added = money.add(Money.of(25.25, &quot;USD&quot;));
        System.out.println(&quot;Added: &quot; + added);
        
        Money subtracted = money.subtract(Money.of(25.25, &quot;USD&quot;));
        System.out.println(&quot;Subtracted: &quot; + subtracted);
        
        Money multiplied = money.multiply(2.0);
        System.out.println(&quot;Multiplied: &quot; + multiplied);
        
        Money divided = money.divide(2.0);
        System.out.println(&quot;Divided: &quot; + divided);
        
        // Test equality
        Money sameMoney = Money.of(100.50, &quot;USD&quot;);
        System.out.println(&quot;Equal: &quot; + money.equals(sameMoney));
        
        // Test factory methods
        Money zero = Money.zero(&quot;USD&quot;);
        System.out.println(&quot;Zero: &quot; + zero);
        
        Money fromAmount = Money.fromAmount(100.50, &quot;USD&quot;);
        System.out.println(&quot;From amount: &quot; + fromAmount);
        
        // Test utility methods
        Money rounded = money.roundToCents();
        System.out.println(&quot;Rounded: &quot; + rounded);
        
        Money absolute = money.abs();
        System.out.println(&quot;Absolute: &quot; + absolute);
        
        Money negated = money.negate();
        System.out.println(&quot;Negated: &quot; + negated);
        
        Money percentage = money.percentage(15.0);
        System.out.println(&quot;Percentage: &quot; + percentage);
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Value Objects Enable Comprehensive Testing</h3>
<h4>1. <strong>Comprehensive Testing</strong></h4>
<ul>
<li>✅ Tests cover all public methods and properties</li>
<li>✅ Edge cases and error conditions are tested</li>
<li>✅ Immutability and equality are verified</li>
</ul>
<h4>2. <strong>Business Rule Validation</strong></h4>
<ul>
<li>✅ Tests verify business rules are enforced</li>
<li>✅ Invalid operations are properly rejected</li>
<li>✅ Value object behavior is consistent</li>
</ul>
<h4>3. <strong>Immutability Testing</strong></h4>
<ul>
<li>✅ Tests verify value objects cannot be modified</li>
<li>✅ Operations return new instances</li>
<li>✅ Thread safety is maintained</li>
</ul>
<h4>4. <strong>Equality and Hash Testing</strong></h4>
<ul>
<li>✅ Tests verify value-based equality</li>
<li>✅ Hash consistency is maintained</li>
<li>✅ Value objects can be used as dictionary keys</li>
</ul>
<h3>Money Value Object Testing Principles</h3>
<h4><strong>Test All Operations</strong></h4>
<ul>
<li>✅ Addition, subtraction, multiplication, division</li>
<li>✅ Comparison operations</li>
<li>✅ Factory methods</li>
<li>✅ Utility methods</li>
</ul>
<h4><strong>Test Edge Cases</strong></h4>
<ul>
<li>✅ Zero amounts</li>
<li>✅ Negative factors</li>
<li>✅ Division by zero</li>
<li>✅ Precision handling</li>
</ul>
<h4><strong>Test Error Conditions</strong></h4>
<ul>
<li>✅ Invalid currencies</li>
<li>✅ Negative amounts</li>
<li>✅ Currency mismatches</li>
<li>✅ Invalid factors</li>
</ul>
<h4><strong>Test Immutability</strong></h4>
<ul>
<li>✅ Value objects cannot be modified</li>
<li>✅ Operations return new instances</li>
<li>✅ Original objects remain unchanged</li>
</ul>
<h3>Java Testing Benefits</h3>
<ul>
<li><strong>JUnit 5</strong>: Modern testing framework with annotations</li>
<li><strong>AssertJ</strong>: Fluent assertions for better readability</li>
<li><strong>Parameterized Tests</strong>: Test multiple scenarios efficiently</li>
<li><strong>Nested Tests</strong>: Organize tests by functionality</li>
<li><strong>Display Names</strong>: Clear test descriptions</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Incomplete Test Coverage</strong></h4>
<ul>
<li>❌ Tests that don&#39;t cover all methods</li>
<li>❌ Tests that miss edge cases</li>
<li>❌ Tests that don&#39;t verify error conditions</li>
</ul>
<h4><strong>Testing Implementation Details</strong></h4>
<ul>
<li>❌ Tests that verify internal implementation</li>
<li>❌ Tests that break when implementation changes</li>
<li>❌ Tests that don&#39;t verify business behavior</li>
</ul>
<h4><strong>Over-Mocking</strong></h4>
<ul>
<li>❌ Mocking value objects instead of testing real behavior</li>
<li>❌ Tests that don&#39;t verify actual business logic</li>
<li>❌ Tests that are hard to maintain</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Value object being tested</li>
<li><a href="./07-order-tests.md">Order Tests</a> - Tests that use Money</li>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity that uses Money</li>
<li><a href="../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing">Value Objects Enable Comprehensive Testing</a> - Testing concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 07-order-tests.md</li>
<li>Next: 09-pricing-service-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing">Value Objects Enable Comprehensive Testing</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/08-money-tests","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"08-money-tests"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"08-money-tests\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/08-money-tests","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
