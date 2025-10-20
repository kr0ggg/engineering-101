# Money Tests - Python Example

**Section**: [Value Objects Enable Comprehensive Testing](../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing)

**Navigation**: [← Previous: Order Tests](./07-order-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Money Tests (pytest) - Value Object Testing
# File: 2-Domain-Driven-Design/code-samples/python/08-money-tests.py

import pytest
from decimal import Decimal

# Import the domain objects
from money_value_object import Money

class TestMoney:
    """Test class for Money value object"""
    
    def test_create_money_with_valid_amount(self):
        """Test creating money with valid amount"""
        # Arrange
        amount = 100.50
        currency = "USD"
        
        # Act
        money = Money(amount, currency)
        
        # Assert
        assert money.amount == amount
        assert money.currency == currency
    
    def test_create_money_with_zero_amount(self):
        """Test creating money with zero amount"""
        # Arrange
        amount = 0.0
        currency = "USD"
        
        # Act
        money = Money(amount, currency)
        
        # Assert
        assert money.amount == amount
        assert money.currency == currency
    
    def test_create_money_with_negative_amount_raises_error(self):
        """Test that creating money with negative amount raises error"""
        # Arrange
        amount = -10.0
        currency = "USD"
        
        # Act & Assert
        with pytest.raises(ValueError, match="Amount cannot be negative"):
            Money(amount, currency)
    
    def test_create_money_with_empty_currency_raises_error(self):
        """Test that creating money with empty currency raises error"""
        # Arrange
        amount = 100.0
        currency = ""
        
        # Act & Assert
        with pytest.raises(ValueError, match="Currency cannot be empty"):
            Money(amount, currency)
    
    def test_create_money_with_none_currency_raises_error(self):
        """Test that creating money with None currency raises error"""
        # Arrange
        amount = 100.0
        currency = None
        
        # Act & Assert
        with pytest.raises(ValueError, match="Currency cannot be empty"):
            Money(amount, currency)
    
    def test_create_money_with_whitespace_currency_raises_error(self):
        """Test that creating money with whitespace currency raises error"""
        # Arrange
        amount = 100.0
        currency = "   "
        
        # Act & Assert
        with pytest.raises(ValueError, match="Currency cannot be empty"):
            Money(amount, currency)
    
    def test_add_money_same_currency(self):
        """Test adding money with same currency"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(25.75, "USD")
        
        # Act
        result = money1.add(money2)
        
        # Assert
        assert result.amount == 126.25
        assert result.currency == "USD"
        assert result is not money1  # Should return new instance
        assert result is not money2  # Should return new instance
    
    def test_add_money_different_currencies_raises_error(self):
        """Test that adding money with different currencies raises error"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(25.75, "EUR")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot add different currencies"):
            money1.add(money2)
    
    def test_subtract_money_same_currency(self):
        """Test subtracting money with same currency"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(25.75, "USD")
        
        # Act
        result = money1.subtract(money2)
        
        # Assert
        assert result.amount == 74.75
        assert result.currency == "USD"
        assert result is not money1  # Should return new instance
        assert result is not money2  # Should return new instance
    
    def test_subtract_money_different_currencies_raises_error(self):
        """Test that subtracting money with different currencies raises error"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(25.75, "EUR")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot subtract different currencies"):
            money1.subtract(money2)
    
    def test_multiply_money_by_positive_factor(self):
        """Test multiplying money by positive factor"""
        # Arrange
        money = Money(100.50, "USD")
        factor = 2.5
        
        # Act
        result = money.multiply(factor)
        
        # Assert
        assert result.amount == 251.25
        assert result.currency == "USD"
        assert result is not money  # Should return new instance
    
    def test_multiply_money_by_zero(self):
        """Test multiplying money by zero"""
        # Arrange
        money = Money(100.50, "USD")
        factor = 0.0
        
        # Act
        result = money.multiply(factor)
        
        # Assert
        assert result.amount == 0.0
        assert result.currency == "USD"
    
    def test_multiply_money_by_negative_factor_raises_error(self):
        """Test that multiplying money by negative factor raises error"""
        # Arrange
        money = Money(100.50, "USD")
        factor = -1.5
        
        # Act & Assert
        with pytest.raises(ValueError, match="Factor cannot be negative"):
            money.multiply(factor)
    
    def test_divide_money_by_positive_factor(self):
        """Test dividing money by positive factor"""
        # Arrange
        money = Money(100.50, "USD")
        factor = 2.0
        
        # Act
        result = money.divide(factor)
        
        # Assert
        assert result.amount == 50.25
        assert result.currency == "USD"
        assert result is not money  # Should return new instance
    
    def test_divide_money_by_zero_raises_error(self):
        """Test that dividing money by zero raises error"""
        # Arrange
        money = Money(100.50, "USD")
        factor = 0.0
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot divide by zero"):
            money.divide(factor)
    
    def test_divide_money_by_negative_factor_raises_error(self):
        """Test that dividing money by negative factor raises error"""
        # Arrange
        money = Money(100.50, "USD")
        factor = -2.0
        
        # Act & Assert
        with pytest.raises(ValueError, match="Factor cannot be negative"):
            money.divide(factor)
    
    def test_money_equality_same_values(self):
        """Test money equality with same values"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.50, "USD")
        
        # Act & Assert
        assert money1 == money2
        assert money1.equals(money2) is True
    
    def test_money_equality_different_amounts(self):
        """Test money equality with different amounts"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.51, "USD")
        
        # Act & Assert
        assert money1 != money2
        assert money1.equals(money2) is False
    
    def test_money_equality_different_currencies(self):
        """Test money equality with different currencies"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.50, "EUR")
        
        # Act & Assert
        assert money1 != money2
        assert money1.equals(money2) is False
    
    def test_money_hash_consistency(self):
        """Test that money hash is consistent"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.50, "USD")
        
        # Act & Assert
        assert hash(money1) == hash(money2)
    
    def test_money_hash_different_values(self):
        """Test that money hash is different for different values"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.51, "USD")
        
        # Act & Assert
        assert hash(money1) != hash(money2)
    
    def test_money_string_representation(self):
        """Test money string representation"""
        # Arrange
        money = Money(100.50, "USD")
        
        # Act
        money_str = str(money)
        
        # Assert
        assert "USD" in money_str
        assert "100.50" in money_str
    
    def test_money_repr_representation(self):
        """Test money repr representation"""
        # Arrange
        money = Money(100.50, "USD")
        
        # Act
        money_repr = repr(money)
        
        # Assert
        assert "Money" in money_repr
        assert "100.5" in money_repr
        assert "USD" in money_repr
    
    def test_money_immutability(self):
        """Test that money is immutable"""
        # Arrange
        money = Money(100.50, "USD")
        
        # Act & Assert
        # Money should be immutable (frozen dataclass)
        with pytest.raises(AttributeError):
            money.amount = 200.0
        
        with pytest.raises(AttributeError):
            money.currency = "EUR"
    
    def test_money_factory_methods(self):
        """Test money factory methods"""
        # Test zero factory
        zero_usd = Money.zero("USD")
        assert zero_usd.amount == 0.0
        assert zero_usd.currency == "USD"
        
        # Test from_amount factory
        amount_usd = Money.from_amount(100.50, "USD")
        assert amount_usd.amount == 100.50
        assert amount_usd.currency == "USD"
    
    def test_money_comparison_operations(self):
        """Test money comparison operations"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(200.75, "USD")
        money3 = Money(100.50, "USD")
        
        # Act & Assert
        assert money1 < money2
        assert money2 > money1
        assert money1 <= money3
        assert money1 >= money3
        assert money1 == money3
        assert money1 != money2
    
    def test_money_comparison_different_currencies_raises_error(self):
        """Test that comparing money with different currencies raises error"""
        # Arrange
        money1 = Money(100.50, "USD")
        money2 = Money(100.50, "EUR")
        
        # Act & Assert
        with pytest.raises(ValueError, match="Cannot compare different currencies"):
            money1 < money2
        
        with pytest.raises(ValueError, match="Cannot compare different currencies"):
            money1 > money2
    
    def test_money_rounding_operations(self):
        """Test money rounding operations"""
        # Arrange
        money = Money(100.567, "USD")
        
        # Act
        rounded = money.round_to_cents()
        
        # Assert
        assert rounded.amount == 100.57
        assert rounded.currency == "USD"
    
    def test_money_absolute_value(self):
        """Test money absolute value"""
        # Arrange
        money = Money(-100.50, "USD")
        
        # Act
        absolute = money.abs()
        
        # Assert
        assert absolute.amount == 100.50
        assert absolute.currency == "USD"
    
    def test_money_negation(self):
        """Test money negation"""
        # Arrange
        money = Money(100.50, "USD")
        
        # Act
        negated = money.negate()
        
        # Assert
        assert negated.amount == -100.50
        assert negated.currency == "USD"
    
    def test_money_percentage_calculation(self):
        """Test money percentage calculation"""
        # Arrange
        money = Money(100.00, "USD")
        percentage = 15.0  # 15%
        
        # Act
        result = money.percentage(percentage)
        
        # Assert
        assert result.amount == 15.00
        assert result.currency == "USD"
    
    def test_money_percentage_with_negative_percentage_raises_error(self):
        """Test that percentage calculation with negative percentage raises error"""
        # Arrange
        money = Money(100.00, "USD")
        percentage = -15.0
        
        # Act & Assert
        with pytest.raises(ValueError, match="Percentage cannot be negative"):
            money.percentage(percentage)
    
    def test_money_currency_validation(self):
        """Test money currency validation"""
        # Test valid currencies
        valid_currencies = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD"]
        for currency in valid_currencies:
            money = Money(100.0, currency)
            assert money.currency == currency
        
        # Test invalid currencies
        invalid_currencies = ["", "   ", None, "INVALID", "123"]
        for currency in invalid_currencies:
            with pytest.raises(ValueError):
                Money(100.0, currency)
    
    def test_money_precision_handling(self):
        """Test money precision handling"""
        # Arrange
        money = Money(100.123456789, "USD")
        
        # Act
        rounded = money.round_to_cents()
        
        # Assert
        assert rounded.amount == 100.12
    
    def test_money_arithmetic_chain(self):
        """Test chaining money arithmetic operations"""
        # Arrange
        money1 = Money(100.00, "USD")
        money2 = Money(50.00, "USD")
        money3 = Money(25.00, "USD")
        
        # Act
        result = money1.add(money2).subtract(money3).multiply(2.0)
        
        # Assert
        assert result.amount == 250.00
        assert result.currency == "USD"
    
    def test_money_with_decimal_precision(self):
        """Test money with decimal precision"""
        # Arrange
        money = Money(100.123456789, "USD")
        
        # Act
        result = money.round_to_cents()
        
        # Assert
        assert result.amount == 100.12
        assert result.currency == "USD"

# Test fixtures
@pytest.fixture
def sample_money():
    """Fixture for creating sample money"""
    return Money(100.50, "USD")

@pytest.fixture
def sample_money_eur():
    """Fixture for creating sample money in EUR"""
    return Money(100.50, "EUR")

# Parametrized tests
@pytest.mark.parametrize("amount1,amount2,expected", [
    (100.0, 50.0, 150.0),
    (0.0, 100.0, 100.0),
    (25.50, 75.25, 100.75),
    (999.99, 0.01, 1000.0)
])
def test_money_addition(amount1, amount2, expected):
    """Test money addition with different parameters"""
    # Arrange
    money1 = Money(amount1, "USD")
    money2 = Money(amount2, "USD")
    
    # Act
    result = money1.add(money2)
    
    # Assert
    assert result.amount == expected
    assert result.currency == "USD"

@pytest.mark.parametrize("amount1,amount2,expected", [
    (100.0, 50.0, 50.0),
    (100.0, 100.0, 0.0),
    (25.50, 75.25, -49.75),
    (999.99, 0.01, 999.98)
])
def test_money_subtraction(amount1, amount2, expected):
    """Test money subtraction with different parameters"""
    # Arrange
    money1 = Money(amount1, "USD")
    money2 = Money(amount2, "USD")
    
    # Act
    result = money1.subtract(money2)
    
    # Assert
    assert result.amount == expected
    assert result.currency == "USD"

@pytest.mark.parametrize("amount,factor,expected", [
    (100.0, 2.0, 200.0),
    (100.0, 0.5, 50.0),
    (100.0, 1.0, 100.0),
    (100.0, 0.0, 0.0)
])
def test_money_multiplication(amount, factor, expected):
    """Test money multiplication with different parameters"""
    # Arrange
    money = Money(amount, "USD")
    
    # Act
    result = money.multiply(factor)
    
    # Assert
    assert result.amount == expected
    assert result.currency == "USD"

@pytest.mark.parametrize("amount,factor,expected", [
    (100.0, 2.0, 50.0),
    (100.0, 4.0, 25.0),
    (100.0, 1.0, 100.0),
    (100.0, 0.5, 200.0)
])
def test_money_division(amount, factor, expected):
    """Test money division with different parameters"""
    # Arrange
    money = Money(amount, "USD")
    
    # Act
    result = money.divide(factor)
    
    # Assert
    assert result.amount == expected
    assert result.currency == "USD"

@pytest.mark.parametrize("amount,percentage,expected", [
    (100.0, 10.0, 10.0),
    (100.0, 15.0, 15.0),
    (100.0, 0.0, 0.0),
    (100.0, 100.0, 100.0)
])
def test_money_percentage(amount, percentage, expected):
    """Test money percentage calculation with different parameters"""
    # Arrange
    money = Money(amount, "USD")
    
    # Act
    result = money.percentage(percentage)
    
    # Assert
    assert result.amount == expected
    assert result.currency == "USD"

@pytest.mark.parametrize("currency", ["USD", "EUR", "GBP", "JPY", "CAD", "AUD"])
def test_money_different_currencies(currency):
    """Test money with different currencies"""
    # Arrange
    amount = 100.50
    
    # Act
    money = Money(amount, currency)
    
    # Assert
    assert money.amount == amount
    assert money.currency == currency

# Integration tests
class TestMoneyIntegration:
    """Integration tests for Money value object"""
    
    def test_money_in_order_calculation(self):
        """Test money usage in order calculations"""
        # Arrange
        order = self._create_order_with_items()
        
        # Act
        total = order.total_amount
        
        # Assert
        assert total.currency == "USD"
        assert total.amount > 0
        assert isinstance(total, Money)
    
    def test_money_in_pricing_calculation(self):
        """Test money usage in pricing calculations"""
        # Arrange
        base_price = Money(100.00, "USD")
        discount = Money(10.00, "USD")
        tax = Money(8.00, "USD")
        
        # Act
        final_price = base_price.subtract(discount).add(tax)
        
        # Assert
        assert final_price.amount == 98.00
        assert final_price.currency == "USD"
    
    def test_money_currency_conversion_simulation(self):
        """Test money currency conversion simulation"""
        # Arrange
        usd_amount = Money(100.00, "USD")
        exchange_rate = 0.85  # USD to EUR
        
        # Act
        eur_amount = Money(usd_amount.amount * exchange_rate, "EUR")
        
        # Assert
        assert eur_amount.amount == 85.00
        assert eur_amount.currency == "EUR"
    
    def _create_order_with_items(self):
        """Create order with items for testing"""
        # This would create an order with items that use Money
        # Simplified for this example
        return MockOrder()

class MockOrder:
    """Mock order for testing"""
    def __init__(self):
        self.total_amount = Money(150.00, "USD")
```

## Key Concepts Demonstrated

### Value Object Testing

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

### Python Testing Benefits
- **pytest**: Powerful testing framework with fixtures and parametrization
- **Type Hints**: Better IDE support and documentation
- **Dataclasses**: Clean, concise class definitions
- **Error Handling**: Clear exception messages for business rules
- **Fixtures**: Reusable test data and setup
- **Parametrized Tests**: Test multiple scenarios efficiently

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
