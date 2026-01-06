# Python Testing Patterns for SOLID Principles

## Overview

This guide covers common testing patterns for Python backend development, specifically focused on testing code that follows SOLID principles using pytest, pytest-mock, and assertpy.

## Testing Stack

- **pytest** - Test framework
- **pytest-mock** - Mocking utilities
- **assertpy** - Assertion library

## Basic Test Structure

### Arrange-Act-Assert (AAA) Pattern

```python
def test_method_name_condition_expected_result():
    # Arrange - Set up test data and dependencies
    dependency = Mock()
    sut = SystemUnderTest(dependency)
    
    # Act - Execute the method being tested
    result = sut.method_to_test()
    
    # Assert - Verify the expected outcome
    assert_that(result).is_equal_to(expected_value)
```

### Using @pytest.mark.parametrize

```python
@pytest.mark.parametrize("price,quantity,expected", [
    (10.00, 2, 20.00),
    (15.00, 3, 45.00),
    (0.00, 5, 0.00)
])
def test_calculate_total_multiplies_price_by_quantity(price, quantity, expected):
    # Arrange
    calculator = PriceCalculator()
    
    # Act
    result = calculator.calculate_total(price, quantity)
    
    # Assert
    assert_that(result).is_equal_to(expected)
```

## Testing SOLID Principles

### 1. Single Responsibility Principle (SRP)

Test each responsibility independently.

#### After SRP - Focused Classes

```python
# Easy to test - single responsibility
class CustomerValidator:
    def validate(self, customer: Customer) -> ValidationResult:
        if not customer.email:
            return ValidationResult.failure("Email is required")
        
        if not self._is_valid_email(customer.email):
            return ValidationResult.failure("Invalid email format")
        
        return ValidationResult.success()

# Focused test
def test_validate_fails_when_email_empty():
    # Arrange
    validator = CustomerValidator()
    customer = Customer(id=1, name="John", email="")
    
    # Act
    result = validator.validate(customer)
    
    # Assert
    assert_that(result.is_valid).is_false()
    assert_that(result.errors).contains("Email is required")

@pytest.mark.parametrize("invalid_email", [
    "invalid",
    "@example.com",
    "user@"
])
def test_validate_fails_when_email_invalid(invalid_email):
    # Arrange
    validator = CustomerValidator()
    customer = Customer(id=1, name="John", email=invalid_email)
    
    # Act
    result = validator.validate(customer)
    
    # Assert
    assert_that(result.is_valid).is_false()
    assert_that(result.errors).contains("Invalid email format")
```

### 2. Open/Closed Principle (OCP)

Test base behavior and extensions independently.

#### Strategy Pattern Testing

```python
# Interface
from abc import ABC, abstractmethod

class DiscountStrategy(ABC):
    @abstractmethod
    def apply_discount(self, original_price: Money) -> Money:
        pass

# Implementation
class PercentageDiscount(DiscountStrategy):
    def __init__(self, percentage: float):
        self.percentage = percentage
    
    def apply_discount(self, original_price: Money) -> Money:
        discount = original_price.amount * (self.percentage / 100)
        return Money(original_price.amount - discount)

# Test base contract
class DiscountStrategyContractTest:
    @pytest.fixture
    def strategy(self):
        raise NotImplementedError("Subclasses must implement")
    
    def test_apply_discount_does_not_return_negative_price(self, strategy):
        # Arrange
        price = Money(10.00)
        
        # Act
        result = strategy.apply_discount(price)
        
        # Assert
        assert_that(result.amount).is_greater_than_or_equal_to(0)

# Test specific implementation
class TestPercentageDiscount(DiscountStrategyContractTest):
    @pytest.fixture
    def strategy(self):
        return PercentageDiscount(10)
    
    @pytest.mark.parametrize("original,percentage,expected", [
        (100.00, 10, 90.00),
        (50.00, 20, 40.00),
        (75.00, 15, 63.75)
    ])
    def test_apply_discount_calculates_correct_percentage(
        self, original, percentage, expected
    ):
        # Arrange
        strategy = PercentageDiscount(percentage)
        price = Money(original)
        
        # Act
        result = strategy.apply_discount(price)
        
        # Assert
        assert_that(result.amount).is_equal_to(expected)
```

### 3. Liskov Substitution Principle (LSP)

Test that derived classes can substitute base classes.

#### Repository Pattern Testing

```python
# Base repository contract tests
class RepositoryContractTest:
    @pytest.fixture
    def repository(self):
        raise NotImplementedError("Subclasses must implement")
    
    @pytest.fixture
    def create_entity(self):
        raise NotImplementedError("Subclasses must implement")
    
    def test_save_persists_entity(self, repository, create_entity):
        # Arrange
        entity = create_entity(1)
        
        # Act
        repository.save(entity)
        
        # Assert
        retrieved = repository.find_by_id(entity.id)
        assert_that(retrieved).is_not_none()
    
    def test_find_by_id_returns_none_when_not_exists(self, repository):
        # Act
        result = repository.find_by_id(999)
        
        # Assert
        assert_that(result).is_none()

# Concrete implementation tests
class TestCustomerRepository(RepositoryContractTest):
    @pytest.fixture
    def repository(self, mock_connection):
        return CustomerRepository(mock_connection)
    
    @pytest.fixture
    def create_entity(self):
        return lambda id: Customer(id=id, name="John Doe", email="john@example.com")
    
    @pytest.fixture
    def mock_connection(self):
        return Mock()
```

### 4. Interface Segregation Principle (ISP)

Test focused interfaces independently.

#### After ISP - Focused Interfaces

```python
# Focused interfaces
class CustomerReader(ABC):
    @abstractmethod
    def find_by_id(self, id: int) -> Optional[Customer]:
        pass
    
    @abstractmethod
    def find_by_email(self, email: str) -> Optional[Customer]:
        pass

class CustomerWriter(ABC):
    @abstractmethod
    def save(self, customer: Customer) -> None:
        pass
    
    @abstractmethod
    def delete(self, id: int) -> None:
        pass

# Test only what you need
def test_get_customer_uses_reader():
    # Arrange - Only mock what's needed
    mock_reader = Mock(spec=CustomerReader)
    mock_reader.find_by_id.return_value = Customer(
        id=1, name="John", email="john@example.com"
    )
    
    service = CustomerDisplayService(mock_reader)
    
    # Act
    result = service.get_customer(1)
    
    # Assert
    assert_that(result).is_not_none()

def test_create_customer_uses_writer():
    # Arrange - Only mock what's needed
    mock_writer = Mock(spec=CustomerWriter)
    service = CustomerManagementService(mock_writer)
    customer = Customer(id=1, name="John", email="john@example.com")
    
    # Act
    service.create_customer(customer)
    
    # Assert
    mock_writer.save.assert_called_once_with(customer)
```

### 5. Dependency Inversion Principle (DIP)

Test against abstractions using dependency injection.

#### Testing with Injected Dependencies

```python
# Service depends on abstraction
class OrderService:
    def __init__(
        self,
        product_repository: ProductRepository,
        price_calculator: PriceCalculator,
        email_service: EmailService
    ):
        self.product_repository = product_repository
        self.price_calculator = price_calculator
        self.email_service = email_service
    
    def create_order(self, customer_id: int, items: List[OrderItem]) -> Order:
        # Load products
        product_ids = [item.product_id for item in items]
        products = self.product_repository.find_by_ids(product_ids)
        
        # Calculate total
        total = self.price_calculator.calculate_total(items, products)
        
        # Create order
        order = Order(customer_id=customer_id, items=items, total=total)
        
        # Send confirmation
        self.email_service.send_order_confirmation(order)
        
        return order

# Easy to test with mocks
def test_create_order_calculates_total_and_sends_email():
    # Arrange
    mock_product_repo = Mock(spec=ProductRepository)
    mock_calculator = Mock(spec=PriceCalculator)
    mock_email_service = Mock(spec=EmailService)
    
    products = [
        Product(id=1, name="Product 1", price=Money(10.00)),
        Product(id=2, name="Product 2", price=Money(20.00))
    ]
    
    mock_product_repo.find_by_ids.return_value = products
    mock_calculator.calculate_total.return_value = Money(40.00)
    
    service = OrderService(
        mock_product_repo,
        mock_calculator,
        mock_email_service
    )
    
    items = [
        OrderItem(product_id=1, quantity=2),
        OrderItem(product_id=2, quantity=1)
    ]
    
    # Act
    order = service.create_order(1, items)
    
    # Assert
    assert_that(order.total.amount).is_equal_to(40.00)
    mock_email_service.send_order_confirmation.assert_called_once()
```

## Advanced Testing Patterns

### Fixtures for Shared Setup

```python
@pytest.fixture
def customer_repository(db_connection):
    return CustomerRepository(db_connection)

@pytest.fixture
def sample_customer():
    return Customer(id=1, name="John Doe", email="john@example.com")

@pytest.fixture(scope="session")
def database():
    # Setup once for all tests
    db = create_test_database()
    yield db
    # Teardown
    db.close()

@pytest.fixture(autouse=True)
def reset_state():
    # Runs before each test automatically
    clear_cache()
```

### Custom Assertions

```python
class CustomerAssertions:
    @staticmethod
    def assert_valid_customer(customer: Customer):
        assert_that(customer).is_not_none()
        assert_that(customer.id).is_not_none()
        assert_that(customer.name).is_not_empty()
        assert_that(customer.email).is_not_none()
        assert_that(customer.email).contains("@")

# Usage
def test_create_customer_returns_valid_customer():
    customer = service.create_customer("John", "john@example.com")
    CustomerAssertions.assert_valid_customer(customer)
```

### Test Data Builders

```python
class OrderBuilder:
    def __init__(self):
        self._id = 1
        self._customer_id = 1
        self._items = []
        self._total = Money(0)
    
    def with_id(self, id: int):
        self._id = id
        return self
    
    def for_customer(self, customer_id: int):
        self._customer_id = customer_id
        return self
    
    def with_item(self, product_id: int, quantity: int):
        self._items.append(OrderItem(product_id, quantity))
        return self
    
    def with_total(self, total: Money):
        self._total = total
        return self
    
    def build(self) -> Order:
        return Order(
            id=self._id,
            customer_id=self._customer_id,
            items=self._items,
            total=self._total
        )

# Usage
def test_process_order_handles_multiple_items():
    order = (OrderBuilder()
        .for_customer(1)
        .with_item(1, 2)
        .with_item(2, 1)
        .with_total(Money(40.00))
        .build())
    
    result = service.process_order(order)
    assert_that(result).is_true()
```

### Markers for Test Organization

```python
# Define markers in pytest.ini
# [pytest]
# markers =
#     unit: Unit tests
#     integration: Integration tests
#     slow: Slow running tests

@pytest.mark.unit
def test_calculate_total():
    # Fast unit test
    pass

@pytest.mark.integration
def test_save_to_database():
    # Integration test
    pass

@pytest.mark.slow
def test_bulk_operation():
    # Slow test
    pass

# Run specific markers:
# pytest -m unit
# pytest -m "not slow"
```

## Summary

**Key Testing Patterns**:
- Use AAA pattern consistently
- Test each SOLID principle appropriately
- Use `@pytest.mark.parametrize` for multiple test cases
- Create contract tests for LSP
- Use focused interfaces for ISP
- Inject dependencies for DIP
- Use fixtures for setup/teardown
- Use test builders for complex objects

## Next Steps

1. Review [Mocking with pytest-mock](./02-MOCKING.md)
2. Learn [Integration Testing](./03-INTEGRATION-TESTING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Good testing patterns make your tests maintainable and your code more testable. Follow SOLID principles in both production and test code.
