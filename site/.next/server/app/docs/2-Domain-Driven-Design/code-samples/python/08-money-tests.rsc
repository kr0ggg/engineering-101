1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/08-money-tests","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"08-money-tests\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T6352,<h1>Money Tests - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing">Value Objects Enable Comprehensive Testing</a></p>
<p><strong>Navigation</strong>: <a href="./07-order-tests.md">← Previous: Order Tests</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - Money Tests (pytest) - Value Object Testing
# File: 2-Domain-Driven-Design/code-samples/python/08-money-tests.py

import pytest
from decimal import Decimal

# Import the domain objects
from money_value_object import Money

class TestMoney:
    &quot;&quot;&quot;Test class for Money value object&quot;&quot;&quot;
    
    def test_create_money_with_valid_amount(self):
        &quot;&quot;&quot;Test creating money with valid amount&quot;&quot;&quot;
        # Arrange
        amount = 100.50
        currency = &quot;USD&quot;
        
        # Act
        money = Money(amount, currency)
        
        # Assert
        assert money.amount == amount
        assert money.currency == currency
    
    def test_create_money_with_zero_amount(self):
        &quot;&quot;&quot;Test creating money with zero amount&quot;&quot;&quot;
        # Arrange
        amount = 0.0
        currency = &quot;USD&quot;
        
        # Act
        money = Money(amount, currency)
        
        # Assert
        assert money.amount == amount
        assert money.currency == currency
    
    def test_create_money_with_negative_amount_raises_error(self):
        &quot;&quot;&quot;Test that creating money with negative amount raises error&quot;&quot;&quot;
        # Arrange
        amount = -10.0
        currency = &quot;USD&quot;
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Amount cannot be negative&quot;):
            Money(amount, currency)
    
    def test_create_money_with_empty_currency_raises_error(self):
        &quot;&quot;&quot;Test that creating money with empty currency raises error&quot;&quot;&quot;
        # Arrange
        amount = 100.0
        currency = &quot;&quot;
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Currency cannot be empty&quot;):
            Money(amount, currency)
    
    def test_create_money_with_none_currency_raises_error(self):
        &quot;&quot;&quot;Test that creating money with None currency raises error&quot;&quot;&quot;
        # Arrange
        amount = 100.0
        currency = None
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Currency cannot be empty&quot;):
            Money(amount, currency)
    
    def test_create_money_with_whitespace_currency_raises_error(self):
        &quot;&quot;&quot;Test that creating money with whitespace currency raises error&quot;&quot;&quot;
        # Arrange
        amount = 100.0
        currency = &quot;   &quot;
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Currency cannot be empty&quot;):
            Money(amount, currency)
    
    def test_add_money_same_currency(self):
        &quot;&quot;&quot;Test adding money with same currency&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(25.75, &quot;USD&quot;)
        
        # Act
        result = money1.add(money2)
        
        # Assert
        assert result.amount == 126.25
        assert result.currency == &quot;USD&quot;
        assert result is not money1  # Should return new instance
        assert result is not money2  # Should return new instance
    
    def test_add_money_different_currencies_raises_error(self):
        &quot;&quot;&quot;Test that adding money with different currencies raises error&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(25.75, &quot;EUR&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot add different currencies&quot;):
            money1.add(money2)
    
    def test_subtract_money_same_currency(self):
        &quot;&quot;&quot;Test subtracting money with same currency&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(25.75, &quot;USD&quot;)
        
        # Act
        result = money1.subtract(money2)
        
        # Assert
        assert result.amount == 74.75
        assert result.currency == &quot;USD&quot;
        assert result is not money1  # Should return new instance
        assert result is not money2  # Should return new instance
    
    def test_subtract_money_different_currencies_raises_error(self):
        &quot;&quot;&quot;Test that subtracting money with different currencies raises error&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(25.75, &quot;EUR&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot subtract different currencies&quot;):
            money1.subtract(money2)
    
    def test_multiply_money_by_positive_factor(self):
        &quot;&quot;&quot;Test multiplying money by positive factor&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        factor = 2.5
        
        # Act
        result = money.multiply(factor)
        
        # Assert
        assert result.amount == 251.25
        assert result.currency == &quot;USD&quot;
        assert result is not money  # Should return new instance
    
    def test_multiply_money_by_zero(self):
        &quot;&quot;&quot;Test multiplying money by zero&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        factor = 0.0
        
        # Act
        result = money.multiply(factor)
        
        # Assert
        assert result.amount == 0.0
        assert result.currency == &quot;USD&quot;
    
    def test_multiply_money_by_negative_factor_raises_error(self):
        &quot;&quot;&quot;Test that multiplying money by negative factor raises error&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        factor = -1.5
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Factor cannot be negative&quot;):
            money.multiply(factor)
    
    def test_divide_money_by_positive_factor(self):
        &quot;&quot;&quot;Test dividing money by positive factor&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        factor = 2.0
        
        # Act
        result = money.divide(factor)
        
        # Assert
        assert result.amount == 50.25
        assert result.currency == &quot;USD&quot;
        assert result is not money  # Should return new instance
    
    def test_divide_money_by_zero_raises_error(self):
        &quot;&quot;&quot;Test that dividing money by zero raises error&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        factor = 0.0
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot divide by zero&quot;):
            money.divide(factor)
    
    def test_divide_money_by_negative_factor_raises_error(self):
        &quot;&quot;&quot;Test that dividing money by negative factor raises error&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        factor = -2.0
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Factor cannot be negative&quot;):
            money.divide(factor)
    
    def test_money_equality_same_values(self):
        &quot;&quot;&quot;Test money equality with same values&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.50, &quot;USD&quot;)
        
        # Act &amp; Assert
        assert money1 == money2
        assert money1.equals(money2) is True
    
    def test_money_equality_different_amounts(self):
        &quot;&quot;&quot;Test money equality with different amounts&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.51, &quot;USD&quot;)
        
        # Act &amp; Assert
        assert money1 != money2
        assert money1.equals(money2) is False
    
    def test_money_equality_different_currencies(self):
        &quot;&quot;&quot;Test money equality with different currencies&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.50, &quot;EUR&quot;)
        
        # Act &amp; Assert
        assert money1 != money2
        assert money1.equals(money2) is False
    
    def test_money_hash_consistency(self):
        &quot;&quot;&quot;Test that money hash is consistent&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.50, &quot;USD&quot;)
        
        # Act &amp; Assert
        assert hash(money1) == hash(money2)
    
    def test_money_hash_different_values(self):
        &quot;&quot;&quot;Test that money hash is different for different values&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.51, &quot;USD&quot;)
        
        # Act &amp; Assert
        assert hash(money1) != hash(money2)
    
    def test_money_string_representation(self):
        &quot;&quot;&quot;Test money string representation&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        
        # Act
        money_str = str(money)
        
        # Assert
        assert &quot;USD&quot; in money_str
        assert &quot;100.50&quot; in money_str
    
    def test_money_repr_representation(self):
        &quot;&quot;&quot;Test money repr representation&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        
        # Act
        money_repr = repr(money)
        
        # Assert
        assert &quot;Money&quot; in money_repr
        assert &quot;100.5&quot; in money_repr
        assert &quot;USD&quot; in money_repr
    
    def test_money_immutability(self):
        &quot;&quot;&quot;Test that money is immutable&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        
        # Act &amp; Assert
        # Money should be immutable (frozen dataclass)
        with pytest.raises(AttributeError):
            money.amount = 200.0
        
        with pytest.raises(AttributeError):
            money.currency = &quot;EUR&quot;
    
    def test_money_factory_methods(self):
        &quot;&quot;&quot;Test money factory methods&quot;&quot;&quot;
        # Test zero factory
        zero_usd = Money.zero(&quot;USD&quot;)
        assert zero_usd.amount == 0.0
        assert zero_usd.currency == &quot;USD&quot;
        
        # Test from_amount factory
        amount_usd = Money.from_amount(100.50, &quot;USD&quot;)
        assert amount_usd.amount == 100.50
        assert amount_usd.currency == &quot;USD&quot;
    
    def test_money_comparison_operations(self):
        &quot;&quot;&quot;Test money comparison operations&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(200.75, &quot;USD&quot;)
        money3 = Money(100.50, &quot;USD&quot;)
        
        # Act &amp; Assert
        assert money1 &lt; money2
        assert money2 &gt; money1
        assert money1 &lt;= money3
        assert money1 &gt;= money3
        assert money1 == money3
        assert money1 != money2
    
    def test_money_comparison_different_currencies_raises_error(self):
        &quot;&quot;&quot;Test that comparing money with different currencies raises error&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.50, &quot;USD&quot;)
        money2 = Money(100.50, &quot;EUR&quot;)
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Cannot compare different currencies&quot;):
            money1 &lt; money2
        
        with pytest.raises(ValueError, match=&quot;Cannot compare different currencies&quot;):
            money1 &gt; money2
    
    def test_money_rounding_operations(self):
        &quot;&quot;&quot;Test money rounding operations&quot;&quot;&quot;
        # Arrange
        money = Money(100.567, &quot;USD&quot;)
        
        # Act
        rounded = money.round_to_cents()
        
        # Assert
        assert rounded.amount == 100.57
        assert rounded.currency == &quot;USD&quot;
    
    def test_money_absolute_value(self):
        &quot;&quot;&quot;Test money absolute value&quot;&quot;&quot;
        # Arrange
        money = Money(-100.50, &quot;USD&quot;)
        
        # Act
        absolute = money.abs()
        
        # Assert
        assert absolute.amount == 100.50
        assert absolute.currency == &quot;USD&quot;
    
    def test_money_negation(self):
        &quot;&quot;&quot;Test money negation&quot;&quot;&quot;
        # Arrange
        money = Money(100.50, &quot;USD&quot;)
        
        # Act
        negated = money.negate()
        
        # Assert
        assert negated.amount == -100.50
        assert negated.currency == &quot;USD&quot;
    
    def test_money_percentage_calculation(self):
        &quot;&quot;&quot;Test money percentage calculation&quot;&quot;&quot;
        # Arrange
        money = Money(100.00, &quot;USD&quot;)
        percentage = 15.0  # 15%
        
        # Act
        result = money.percentage(percentage)
        
        # Assert
        assert result.amount == 15.00
        assert result.currency == &quot;USD&quot;
    
    def test_money_percentage_with_negative_percentage_raises_error(self):
        &quot;&quot;&quot;Test that percentage calculation with negative percentage raises error&quot;&quot;&quot;
        # Arrange
        money = Money(100.00, &quot;USD&quot;)
        percentage = -15.0
        
        # Act &amp; Assert
        with pytest.raises(ValueError, match=&quot;Percentage cannot be negative&quot;):
            money.percentage(percentage)
    
    def test_money_currency_validation(self):
        &quot;&quot;&quot;Test money currency validation&quot;&quot;&quot;
        # Test valid currencies
        valid_currencies = [&quot;USD&quot;, &quot;EUR&quot;, &quot;GBP&quot;, &quot;JPY&quot;, &quot;CAD&quot;, &quot;AUD&quot;]
        for currency in valid_currencies:
            money = Money(100.0, currency)
            assert money.currency == currency
        
        # Test invalid currencies
        invalid_currencies = [&quot;&quot;, &quot;   &quot;, None, &quot;INVALID&quot;, &quot;123&quot;]
        for currency in invalid_currencies:
            with pytest.raises(ValueError):
                Money(100.0, currency)
    
    def test_money_precision_handling(self):
        &quot;&quot;&quot;Test money precision handling&quot;&quot;&quot;
        # Arrange
        money = Money(100.123456789, &quot;USD&quot;)
        
        # Act
        rounded = money.round_to_cents()
        
        # Assert
        assert rounded.amount == 100.12
    
    def test_money_arithmetic_chain(self):
        &quot;&quot;&quot;Test chaining money arithmetic operations&quot;&quot;&quot;
        # Arrange
        money1 = Money(100.00, &quot;USD&quot;)
        money2 = Money(50.00, &quot;USD&quot;)
        money3 = Money(25.00, &quot;USD&quot;)
        
        # Act
        result = money1.add(money2).subtract(money3).multiply(2.0)
        
        # Assert
        assert result.amount == 250.00
        assert result.currency == &quot;USD&quot;
    
    def test_money_with_decimal_precision(self):
        &quot;&quot;&quot;Test money with decimal precision&quot;&quot;&quot;
        # Arrange
        money = Money(100.123456789, &quot;USD&quot;)
        
        # Act
        result = money.round_to_cents()
        
        # Assert
        assert result.amount == 100.12
        assert result.currency == &quot;USD&quot;

# Test fixtures
@pytest.fixture
def sample_money():
    &quot;&quot;&quot;Fixture for creating sample money&quot;&quot;&quot;
    return Money(100.50, &quot;USD&quot;)

@pytest.fixture
def sample_money_eur():
    &quot;&quot;&quot;Fixture for creating sample money in EUR&quot;&quot;&quot;
    return Money(100.50, &quot;EUR&quot;)

# Parametrized tests
@pytest.mark.parametrize(&quot;amount1,amount2,expected&quot;, [
    (100.0, 50.0, 150.0),
    (0.0, 100.0, 100.0),
    (25.50, 75.25, 100.75),
    (999.99, 0.01, 1000.0)
])
def test_money_addition(amount1, amount2, expected):
    &quot;&quot;&quot;Test money addition with different parameters&quot;&quot;&quot;
    # Arrange
    money1 = Money(amount1, &quot;USD&quot;)
    money2 = Money(amount2, &quot;USD&quot;)
    
    # Act
    result = money1.add(money2)
    
    # Assert
    assert result.amount == expected
    assert result.currency == &quot;USD&quot;

@pytest.mark.parametrize(&quot;amount1,amount2,expected&quot;, [
    (100.0, 50.0, 50.0),
    (100.0, 100.0, 0.0),
    (25.50, 75.25, -49.75),
    (999.99, 0.01, 999.98)
])
def test_money_subtraction(amount1, amount2, expected):
    &quot;&quot;&quot;Test money subtraction with different parameters&quot;&quot;&quot;
    # Arrange
    money1 = Money(amount1, &quot;USD&quot;)
    money2 = Money(amount2, &quot;USD&quot;)
    
    # Act
    result = money1.subtract(money2)
    
    # Assert
    assert result.amount == expected
    assert result.currency == &quot;USD&quot;

@pytest.mark.parametrize(&quot;amount,factor,expected&quot;, [
    (100.0, 2.0, 200.0),
    (100.0, 0.5, 50.0),
    (100.0, 1.0, 100.0),
    (100.0, 0.0, 0.0)
])
def test_money_multiplication(amount, factor, expected):
    &quot;&quot;&quot;Test money multiplication with different parameters&quot;&quot;&quot;
    # Arrange
    money = Money(amount, &quot;USD&quot;)
    
    # Act
    result = money.multiply(factor)
    
    # Assert
    assert result.amount == expected
    assert result.currency == &quot;USD&quot;

@pytest.mark.parametrize(&quot;amount,factor,expected&quot;, [
    (100.0, 2.0, 50.0),
    (100.0, 4.0, 25.0),
    (100.0, 1.0, 100.0),
    (100.0, 0.5, 200.0)
])
def test_money_division(amount, factor, expected):
    &quot;&quot;&quot;Test money division with different parameters&quot;&quot;&quot;
    # Arrange
    money = Money(amount, &quot;USD&quot;)
    
    # Act
    result = money.divide(factor)
    
    # Assert
    assert result.amount == expected
    assert result.currency == &quot;USD&quot;

@pytest.mark.parametrize(&quot;amount,percentage,expected&quot;, [
    (100.0, 10.0, 10.0),
    (100.0, 15.0, 15.0),
    (100.0, 0.0, 0.0),
    (100.0, 100.0, 100.0)
])
def test_money_percentage(amount, percentage, expected):
    &quot;&quot;&quot;Test money percentage calculation with different parameters&quot;&quot;&quot;
    # Arrange
    money = Money(amount, &quot;USD&quot;)
    
    # Act
    result = money.percentage(percentage)
    
    # Assert
    assert result.amount == expected
    assert result.currency == &quot;USD&quot;

@pytest.mark.parametrize(&quot;currency&quot;, [&quot;USD&quot;, &quot;EUR&quot;, &quot;GBP&quot;, &quot;JPY&quot;, &quot;CAD&quot;, &quot;AUD&quot;])
def test_money_different_currencies(currency):
    &quot;&quot;&quot;Test money with different currencies&quot;&quot;&quot;
    # Arrange
    amount = 100.50
    
    # Act
    money = Money(amount, currency)
    
    # Assert
    assert money.amount == amount
    assert money.currency == currency

# Integration tests
class TestMoneyIntegration:
    &quot;&quot;&quot;Integration tests for Money value object&quot;&quot;&quot;
    
    def test_money_in_order_calculation(self):
        &quot;&quot;&quot;Test money usage in order calculations&quot;&quot;&quot;
        # Arrange
        order = self._create_order_with_items()
        
        # Act
        total = order.total_amount
        
        # Assert
        assert total.currency == &quot;USD&quot;
        assert total.amount &gt; 0
        assert isinstance(total, Money)
    
    def test_money_in_pricing_calculation(self):
        &quot;&quot;&quot;Test money usage in pricing calculations&quot;&quot;&quot;
        # Arrange
        base_price = Money(100.00, &quot;USD&quot;)
        discount = Money(10.00, &quot;USD&quot;)
        tax = Money(8.00, &quot;USD&quot;)
        
        # Act
        final_price = base_price.subtract(discount).add(tax)
        
        # Assert
        assert final_price.amount == 98.00
        assert final_price.currency == &quot;USD&quot;
    
    def test_money_currency_conversion_simulation(self):
        &quot;&quot;&quot;Test money currency conversion simulation&quot;&quot;&quot;
        # Arrange
        usd_amount = Money(100.00, &quot;USD&quot;)
        exchange_rate = 0.85  # USD to EUR
        
        # Act
        eur_amount = Money(usd_amount.amount * exchange_rate, &quot;EUR&quot;)
        
        # Assert
        assert eur_amount.amount == 85.00
        assert eur_amount.currency == &quot;EUR&quot;
    
    def _create_order_with_items(self):
        &quot;&quot;&quot;Create order with items for testing&quot;&quot;&quot;
        # This would create an order with items that use Money
        # Simplified for this example
        return MockOrder()

class MockOrder:
    &quot;&quot;&quot;Mock order for testing&quot;&quot;&quot;
    def __init__(self):
        self.total_amount = Money(150.00, &quot;USD&quot;)
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Value Object Testing</h3>
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
<h3>Python Testing Benefits</h3>
<ul>
<li><strong>pytest</strong>: Powerful testing framework with fixtures and parametrization</li>
<li><strong>Type Hints</strong>: Better IDE support and documentation</li>
<li><strong>Dataclasses</strong>: Clean, concise class definitions</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
<li><strong>Fixtures</strong>: Reusable test data and setup</li>
<li><strong>Parametrized Tests</strong>: Test multiple scenarios efficiently</li>
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
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/08-money-tests","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"08-money-tests"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"08-money-tests\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/08-money-tests","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
