# Python Mocking with pytest-mock

## Overview

pytest-mock is a pytest plugin that provides a convenient wrapper around Python's built-in `unittest.mock`. This guide covers everything you need to know about mocking in Python tests.

## Installation

```bash
pip install pytest-mock
```

## Basic Mocking Concepts

### Creating Mocks

```python
from unittest.mock import Mock

# Create mock object
mock_repository = Mock()

# Create mock with spec (type checking)
mock_repository = Mock(spec=CustomerRepository)

# Using pytest-mock fixture
def test_example(mocker):
    mock_repository = mocker.Mock(spec=CustomerRepository)
```

### Setup Return Values

```python
# Setup method to return specific value
mock_repository.find_by_id.return_value = Customer(id=1, name="John")

# Setup with side_effect for multiple calls
mock_repository.find_by_id.side_effect = [customer1, customer2, customer3]

# Setup to raise exception
mock_repository.save.side_effect = DatabaseException("Connection failed")
```

### Verify Method Calls

```python
# Verify method was called
mock_repository.save.assert_called_once()

# Verify with specific arguments
mock_repository.save.assert_called_with(customer)

# Verify never called
mock_repository.delete.assert_not_called()
```

## Setup Patterns

### Basic Setup

```python
def test_get_customer_returns_customer_when_exists():
    # Arrange
    mock_repository = Mock(spec=CustomerRepository)
    mock_repository.find_by_id.return_value = Customer(
        id=1, name="John Doe", email="john@example.com"
    )
    
    service = CustomerService(mock_repository)
    
    # Act
    result = service.get_customer(1)
    
    # Assert
    assert_that(result).is_not_none()
    assert_that(result.name).is_equal_to("John Doe")
```

### Using pytest-mock Fixture

```python
def test_save_customer_calls_repository(mocker):
    # Arrange
    mock_repository = mocker.Mock(spec=CustomerRepository)
    service = CustomerService(mock_repository)
    customer = Customer(id=1, name="John", email="john@example.com")
    
    # Act
    service.save_customer(customer)
    
    # Assert
    mock_repository.save.assert_called_once_with(customer)
```

### Setup with side_effect

```python
def test_save_customer_assigns_id(mocker):
    # Arrange
    saved_customer = None
    
    def save_side_effect(customer):
        nonlocal saved_customer
        saved_customer = customer
    
    mock_repository = mocker.Mock(spec=CustomerRepository)
    mock_repository.save.side_effect = save_side_effect
    
    service = CustomerService(mock_repository)
    customer = Customer(id=None, name="John", email="john@example.com")
    
    # Act
    service.save_customer(customer)
    
    # Assert
    assert_that(saved_customer).is_not_none()
    assert_that(saved_customer.name).is_equal_to("John")
```

### Setup Sequential Returns

```python
def test_get_customer_retries_on_failure(mocker):
    # Arrange
    mock_repository = mocker.Mock(spec=CustomerRepository)
    mock_repository.find_by_id.side_effect = [
        None,  # First call returns None
        None,  # Second call returns None
        Customer(id=1, name="John", email="john@example.com")  # Third succeeds
    ]
    
    service = CustomerService(mock_repository)
    
    # Act
    result = service.get_customer_with_retry(1)
    
    # Assert
    assert_that(result).is_not_none()
    assert mock_repository.find_by_id.call_count == 3
```

## Argument Matching

### Using unittest.mock.ANY

```python
from unittest.mock import ANY

# Match any value
mock_repository.save.assert_called_with(ANY)

# Match specific type
mock_repository.save.assert_called_with(
    unittest.mock.ANY  # or use isinstance check in side_effect
)
```

### Custom Argument Matching

```python
def test_update_customer_with_specific_values(mocker):
    # Arrange
    mock_repository = mocker.Mock(spec=CustomerRepository)
    service = CustomerService(mock_repository)
    customer = Customer(id=1, name="Updated Name", email="john@example.com")
    
    # Act
    service.update_customer(customer)
    
    # Assert
    # Get the actual call arguments
    call_args = mock_repository.update.call_args[0][0]
    assert_that(call_args.id).is_equal_to(1)
    assert_that(call_args.name).is_equal_to("Updated Name")
```

## Exception Handling

### Setup to Raise Exception

```python
def test_save_customer_handles_database_exception(mocker):
    # Arrange
    mock_repository = mocker.Mock(spec=CustomerRepository)
    mock_repository.save.side_effect = DatabaseException("Connection failed")
    
    service = CustomerService(mock_repository)
    customer = Customer(id=1, name="John", email="john@example.com")
    
    # Act & Assert
    with pytest.raises(DatabaseException) as exc_info:
        service.save_customer(customer)
    
    assert_that(str(exc_info.value)).contains("Connection failed")
```

## Patching

### Using mocker.patch

```python
def test_send_email_calls_smtp(mocker):
    # Arrange
    mock_smtp = mocker.patch('email_service.smtplib.SMTP')
    service = EmailService()
    
    # Act
    service.send_email("to@example.com", "Subject", "Body")
    
    # Assert
    mock_smtp.assert_called_once()
```

### Patching Object Attributes

```python
def test_get_config_value(mocker):
    # Arrange
    mocker.patch.object(Config, 'DATABASE_URL', 'test-database-url')
    
    # Act
    result = get_database_connection()
    
    # Assert
    assert_that(result.url).is_equal_to('test-database-url')
```

### Patching with Context Manager

```python
def test_with_context_manager(mocker):
    with mocker.patch('module.function') as mock_func:
        mock_func.return_value = 'mocked'
        result = module.function()
        assert_that(result).is_equal_to('mocked')
```

## Verification

### Verify Method Called

```python
def test_process_order_sends_email(mocker):
    # Arrange
    mock_email_service = mocker.Mock(spec=EmailService)
    service = OrderService(mock_email_service)
    order = Order(id=1, customer_id=100, total=Money(50.00))
    
    # Act
    service.process_order(order)
    
    # Assert
    mock_email_service.send_order_confirmation.assert_called_once()
```

### Verify Call Count

```python
# Verify called exactly once
mock.method.assert_called_once()

# Verify called exactly N times
assert mock.method.call_count == 3

# Verify never called
mock.method.assert_not_called()
```

### Verify Call Arguments

```python
# Verify with exact arguments
mock.method.assert_called_with(arg1, arg2)

# Verify with keyword arguments
mock.method.assert_called_with(name="John", email="john@example.com")

# Get all calls
calls = mock.method.call_args_list
assert len(calls) == 2
```

### Verify Call Order

```python
def test_methods_called_in_order(mocker):
    # Arrange
    mock_repository = mocker.Mock(spec=CustomerRepository)
    mock_email = mocker.Mock(spec=EmailService)
    service = CustomerService(mock_repository, mock_email)
    
    # Act
    service.create_customer(customer)
    
    # Assert
    manager = mocker.Mock()
    manager.attach_mock(mock_repository, 'repository')
    manager.attach_mock(mock_email, 'email')
    
    expected_calls = [
        mocker.call.repository.save(customer),
        mocker.call.email.send_welcome_email(customer)
    ]
    assert manager.mock_calls == expected_calls
```

## Advanced Patterns

### Spy Objects

```python
def test_spy_on_real_object(mocker):
    # Create real object
    real_service = CustomerService(real_repository)
    
    # Spy on specific method
    spy = mocker.spy(real_service, 'validate_customer')
    
    # Act
    real_service.create_customer(customer)
    
    # Assert - real method was called
    spy.assert_called_once_with(customer)
```

### Partial Mocking

```python
def test_partial_mock(mocker):
    # Create real service
    service = CustomerService(mock_repository)
    
    # Mock only one method
    mocker.patch.object(service, 'is_valid_customer', return_value=True)
    
    # Other methods use real implementation
    result = service.create_customer("John", "john@example.com")
    
    assert_that(result).is_not_none()
```

### Mock Properties

```python
def test_mock_property(mocker):
    # Arrange
    mock_config = mocker.Mock()
    type(mock_config).connection_string = mocker.PropertyMock(
        return_value="test-connection"
    )
    
    service = DatabaseService(mock_config)
    
    # Act
    result = service.get_connection_string()
    
    # Assert
    assert_that(result).is_equal_to("test-connection")
```

### Mock Context Managers

```python
def test_mock_context_manager(mocker):
    # Arrange
    mock_connection = mocker.Mock()
    mock_connection.__enter__.return_value = mock_connection
    mock_connection.__exit__.return_value = None
    
    mocker.patch('database.get_connection', return_value=mock_connection)
    
    # Act
    with database.get_connection() as conn:
        conn.execute("SELECT * FROM customers")
    
    # Assert
    mock_connection.execute.assert_called_once()
```

## Testing with Multiple Mocks

```python
def test_process_order_coordinates_services(mocker):
    # Arrange
    mock_product_repo = mocker.Mock(spec=ProductRepository)
    mock_inventory = mocker.Mock(spec=InventoryService)
    mock_payment = mocker.Mock(spec=PaymentService)
    mock_email = mocker.Mock(spec=EmailService)
    
    product = Product(id=1, name="Product", price=Money(10.00))
    mock_product_repo.find_by_id.return_value = product
    mock_inventory.check_availability.return_value = True
    mock_payment.process_payment.return_value = PaymentResult(
        success=True, transaction_id="txn_123"
    )
    
    service = OrderService(
        mock_product_repo,
        mock_inventory,
        mock_payment,
        mock_email
    )
    
    order = Order(id=1, items=[OrderItem(product_id=1, quantity=2)])
    
    # Act
    result = service.process_order(order)
    
    # Assert
    assert_that(result.success).is_true()
    mock_inventory.check_availability.assert_called_once_with(1, 2)
    mock_payment.process_payment.assert_called_once()
    mock_email.send_order_confirmation.assert_called_once()
```

## Common Patterns

### Repository Pattern

```python
def test_get_customer_uses_repository(mocker):
    # Arrange
    mock_repository = mocker.Mock(spec=CustomerRepository)
    mock_repository.find_by_id.return_value = Customer(
        id=1, name="John", email="john@example.com"
    )
    
    service = CustomerService(mock_repository)
    
    # Act
    result = service.get_customer(1)
    
    # Assert
    assert_that(result).is_not_none()
    mock_repository.find_by_id.assert_called_once_with(1)
```

### Fixtures for Mocks

```python
@pytest.fixture
def mock_customer_repository(mocker):
    return mocker.Mock(spec=CustomerRepository)

@pytest.fixture
def mock_email_service(mocker):
    return mocker.Mock(spec=EmailService)

@pytest.fixture
def customer_service(mock_customer_repository, mock_email_service):
    return CustomerService(mock_customer_repository, mock_email_service)

def test_create_customer(customer_service, mock_customer_repository):
    # Test uses fixtures
    customer = Customer(id=1, name="John", email="john@example.com")
    customer_service.create_customer(customer)
    mock_customer_repository.save.assert_called_once()
```

## Best Practices

### ✅ Do's

```python
# Use spec for type safety
mock = Mock(spec=CustomerRepository)

# Verify important interactions
mock.critical_method.assert_called_once()

# Use descriptive variable names
mock_customer_repository = Mock(spec=CustomerRepository)

# Setup only what you need
mock.get_data.return_value = data
```

### ❌ Don'ts

```python
# Don't mock what you don't own
mock_requests = Mock(spec=requests)  # Bad - mock your wrapper instead

# Don't over-verify
assert mock.log_debug.call_count == 5  # Too brittle

# Don't mock value objects
mock_money = Mock(spec=Money)  # Bad - use real Money

# Don't use Mock() without spec
mock = Mock()  # Bad - no type checking
```

## Troubleshooting

### Mock Not Working

```python
# Problem: Mock doesn't match call
mock.method.return_value = value
mock.method(different_arg)  # Returns None!

# Solution: Check arguments or use ANY
from unittest.mock import ANY
mock.method.return_value = value
mock.method(ANY)  # Now works
```

### AttributeError on Mock

```python
# Problem: Accessing undefined attribute
mock = Mock()
mock.undefined_method()  # Creates new mock automatically

# Solution: Use spec
mock = Mock(spec=CustomerRepository)
mock.undefined_method()  # Raises AttributeError
```

## Summary

**Key pytest-mock Concepts**:
- Setup return values with `.return_value`
- Setup multiple returns with `.side_effect`
- Verify calls with `.assert_called_once()`
- Use `mocker` fixture for patching
- Use `spec` for type safety
- Mock interfaces, not concrete classes

## Next Steps

1. Review [Testing Patterns](./01-TESTING-PATTERNS.md)
2. Learn [Integration Testing](./03-INTEGRATION-TESTING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: pytest-mock makes mocking in Python simple and Pythonic. Use it to isolate your code under test and verify important interactions.
