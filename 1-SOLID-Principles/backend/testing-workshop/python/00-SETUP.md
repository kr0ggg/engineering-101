# Python Testing Setup Guide

## Overview

This guide walks you through setting up a complete testing environment for Python backend development using pytest, pytest-mock, and Testcontainers.

## Prerequisites

- **Python 3.10 or later**
  - Download: https://www.python.org/downloads/
  - Verify: `python --version`

- **pip** (usually included with Python)
  - Verify: `pip --version`

- **IDE** (choose one):
  - PyCharm (Community or Professional)
  - VS Code with Python extension
  - Sublime Text with Python plugins

- **Docker Desktop** (for integration tests)
  - Download: https://docs.docker.com/get-docker/
  - Required for Testcontainers

## Project Structure

```
ecommerce-app/
├── src/
│   └── ecommerce/
│       ├── __init__.py
│       ├── services/
│       ├── repositories/
│       └── models/
├── tests/
│   ├── __init__.py
│   ├── services/
│   ├── repositories/
│   ├── integration/
│   └── helpers/
├── requirements.txt
├── requirements-dev.txt
└── pytest.ini
```

## Step 1: Create Virtual Environment

```bash
# Create virtual environment
python -m venv venv

# Activate (macOS/Linux)
source venv/bin/activate

# Activate (Windows)
venv\Scripts\activate

# Verify activation
which python  # Should show venv path
```

## Step 2: Install Testing Packages

Create `requirements-dev.txt`:

```txt
# Testing framework
pytest==7.4.3
pytest-cov==4.1.0
pytest-asyncio==0.21.1
pytest-xdist==3.5.0

# Mocking
pytest-mock==3.12.0

# Assertions
assertpy==1.1

# Test data
faker==20.1.0

# Integration testing
testcontainers==3.7.1
testcontainers[postgresql]==3.7.1

# Database
psycopg2-binary==2.9.9
```

Install packages:

```bash
pip install -r requirements-dev.txt
```

## Step 3: Configure pytest

Create `pytest.ini`:

```ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = 
    -v
    --strict-markers
    --tb=short
    --cov=src
    --cov-report=html
    --cov-report=term-missing
markers =
    unit: Unit tests
    integration: Integration tests
    slow: Slow running tests
```

Create `setup.cfg` for coverage:

```ini
[coverage:run]
source = src
omit = 
    */tests/*
    */venv/*
    */__pycache__/*

[coverage:report]
exclude_lines =
    pragma: no cover
    def __repr__
    raise AssertionError
    raise NotImplementedError
    if __name__ == .__main__.:
```

## Step 4: Write Your First Test

Create `tests/services/test_customer_service.py`:

```python
import pytest
from unittest.mock import Mock
from assertpy import assert_that

from src.ecommerce.services.customer_service import CustomerService
from src.ecommerce.models.customer import Customer
from src.ecommerce.repositories.customer_repository import CustomerRepository


class TestCustomerService:
    
    @pytest.fixture
    def mock_repository(self):
        return Mock(spec=CustomerRepository)
    
    @pytest.fixture
    def service(self, mock_repository):
        return CustomerService(mock_repository)
    
    def test_create_customer_should_save_to_repository(self, service, mock_repository):
        # Arrange
        customer = Customer(id=1, name="John Doe", email="john@example.com")
        
        # Act
        service.create_customer(customer)
        
        # Assert
        mock_repository.save.assert_called_once()
        saved_customer = mock_repository.save.call_args[0][0]
        assert_that(saved_customer.name).is_equal_to("John Doe")
        assert_that(saved_customer.email).is_equal_to("john@example.com")
    
    @pytest.mark.parametrize("invalid_name", [
        "",
        None,
        "   ",
        "\t",
        "\n"
    ])
    def test_create_customer_should_raise_error_when_name_invalid(
        self, service, invalid_name
    ):
        # Arrange
        customer = Customer(id=1, name=invalid_name, email="john@example.com")
        
        # Act & Assert
        with pytest.raises(ValueError) as exc_info:
            service.create_customer(customer)
        
        assert_that(str(exc_info.value)).contains("Name is required")
    
    def test_get_customer_should_return_customer_when_exists(
        self, service, mock_repository
    ):
        # Arrange
        expected = Customer(id=1, name="John Doe", email="john@example.com")
        mock_repository.find_by_id.return_value = expected
        
        # Act
        result = service.get_customer(1)
        
        # Assert
        assert_that(result).is_not_none()
        assert_that(result.name).is_equal_to("John Doe")
        assert_that(result.email).is_equal_to("john@example.com")
```

## Step 5: Run Tests

```bash
# Run all tests
pytest

# Run with coverage
pytest --cov=src --cov-report=html

# Run specific test file
pytest tests/services/test_customer_service.py

# Run specific test
pytest tests/services/test_customer_service.py::TestCustomerService::test_create_customer_should_save_to_repository

# Run tests matching pattern
pytest -k "customer"

# Run tests by marker
pytest -m unit

# Run in parallel
pytest -n auto

# Run with verbose output
pytest -v

# Run and stop on first failure
pytest -x

# Run last failed tests
pytest --lf
```

## Step 6: Configure Test Helpers

### Test Base Class

```python
# tests/helpers/test_base.py
import pytest


class TestBase:
    """Base class for all tests with common setup/teardown"""
    
    @pytest.fixture(autouse=True)
    def setup_method(self):
        """Run before each test method"""
        # Common setup
        yield
        # Common teardown
```

### Test Data Builders

```python
# tests/helpers/builders.py
from src.ecommerce.models.customer import Customer


class CustomerBuilder:
    def __init__(self):
        self._id = 1
        self._name = "John Doe"
        self._email = "john@example.com"
        self._is_active = True
    
    def with_id(self, id: int):
        self._id = id
        return self
    
    def with_name(self, name: str):
        self._name = name
        return self
    
    def with_email(self, email: str):
        self._email = email
        return self
    
    def inactive(self):
        self._is_active = False
        return self
    
    def build(self) -> Customer:
        return Customer(
            id=self._id,
            name=self._name,
            email=self._email,
            is_active=self._is_active
        )
```

Usage:

```python
def test_process_order_should_fail_when_customer_inactive(service):
    customer = CustomerBuilder().with_id(1).inactive().build()
    
    with pytest.raises(ValueError):
        service.process_order(customer, order)
```

### Fixtures

```python
# tests/conftest.py
import pytest
from unittest.mock import Mock


@pytest.fixture
def mock_customer_repository():
    return Mock()


@pytest.fixture
def sample_customer():
    return Customer(id=1, name="John Doe", email="john@example.com")


@pytest.fixture
def customer_builder():
    return CustomerBuilder()
```

## Step 7: Integration Test Setup

### Testcontainers Configuration

```python
# tests/integration/conftest.py
import pytest
from testcontainers.postgres import PostgresContainer
import psycopg2


@pytest.fixture(scope="session")
def postgres_container():
    with PostgresContainer("postgres:16") as postgres:
        yield postgres


@pytest.fixture(scope="session")
def db_connection(postgres_container):
    connection = psycopg2.connect(
        host=postgres_container.get_container_host_ip(),
        port=postgres_container.get_exposed_port(5432),
        database=postgres_container.POSTGRES_DB,
        user=postgres_container.POSTGRES_USER,
        password=postgres_container.POSTGRES_PASSWORD
    )
    
    # Run migrations
    with connection.cursor() as cursor:
        cursor.execute("""
            CREATE TABLE customers (
                id SERIAL PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                email VARCHAR(255) NOT NULL UNIQUE,
                is_active BOOLEAN DEFAULT true,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        """)
    connection.commit()
    
    yield connection
    
    connection.close()


@pytest.fixture
def db_cursor(db_connection):
    cursor = db_connection.cursor()
    yield cursor
    db_connection.rollback()  # Rollback after each test
    cursor.close()
```

### Integration Test Example

```python
# tests/integration/test_customer_repository.py
import pytest
from assertpy import assert_that

from src.ecommerce.repositories.customer_repository import CustomerRepository
from src.ecommerce.models.customer import Customer


@pytest.mark.integration
class TestCustomerRepositoryIntegration:
    
    def test_save_should_persist_customer_to_database(self, db_connection):
        # Arrange
        repository = CustomerRepository(db_connection)
        customer = Customer(id=None, name="John Doe", email="john@example.com")
        
        # Act
        repository.save(customer)
        
        # Assert
        retrieved = repository.find_by_email("john@example.com")
        assert_that(retrieved).is_not_none()
        assert_that(retrieved.name).is_equal_to("John Doe")
        assert_that(retrieved.email).is_equal_to("john@example.com")
    
    def test_find_by_id_should_return_none_when_not_exists(self, db_connection):
        # Arrange
        repository = CustomerRepository(db_connection)
        
        # Act
        result = repository.find_by_id(999)
        
        # Assert
        assert_that(result).is_none()
```

## Step 8: Continuous Integration

### GitHub Actions

Create `.github/workflows/python-tests.yml`:

```yaml
name: Python Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.11'
        cache: 'pip'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements-dev.txt
    
    - name: Run tests
      run: pytest --cov=src --cov-report=xml
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        files: ./coverage.xml
```

## Troubleshooting

### Issue: Tests Not Discovered

**Solution**: Ensure files and functions follow naming conventions:

```python
# ✅ Correct
# File: test_customer_service.py
class TestCustomerService:
    def test_create_customer(self):
        pass

# ❌ Wrong - missing test_ prefix
# File: customer_service.py
class CustomerService:
    def create_customer(self):
        pass
```

### Issue: Import Errors

**Solution**: Add project root to PYTHONPATH:

```bash
# Option 1: Set environment variable
export PYTHONPATH="${PYTHONPATH}:${PWD}"

# Option 2: Install package in editable mode
pip install -e .
```

### Issue: Testcontainers Not Starting

**Solution**: Ensure Docker is running:

```bash
# Check Docker
docker ps

# If not running, start Docker Desktop
```

### Issue: Slow Tests

**Solution**: Run tests in parallel:

```bash
# Install pytest-xdist
pip install pytest-xdist

# Run with auto-detected CPU count
pytest -n auto

# Run with specific number of workers
pytest -n 4
```

## Best Practices

### ✅ Do's

- Use fixtures for setup/teardown
- Use `pytest.mark.parametrize` for multiple test cases
- Use `assertpy` for fluent assertions
- Keep tests independent
- Use descriptive test names

### ❌ Don'ts

- Don't test private methods directly
- Don't share state between tests
- Don't use `time.sleep()` in tests
- Don't ignore failing tests
- Don't test framework code

## Quick Reference

### Common Commands

```bash
pytest                      # Run all tests
pytest -v                   # Verbose output
pytest -k "pattern"         # Run tests matching pattern
pytest -m marker            # Run tests with marker
pytest -x                   # Stop on first failure
pytest --lf                 # Run last failed
pytest -n auto              # Parallel execution
pytest --cov=src            # With coverage
```

### Common Fixtures

```python
@pytest.fixture
def sample_data():
    return {"key": "value"}

@pytest.fixture(scope="session")
def database():
    # Setup once for all tests
    yield db
    # Teardown

@pytest.fixture(autouse=True)
def reset_state():
    # Runs before each test automatically
    pass
```

### Common Assertions (assertpy)

```python
assert_that(actual).is_equal_to(expected)
assert_that(actual).is_not_none()
assert_that(actual).is_instance_of(Customer)
assert_that(list).is_length(3)
assert_that(list).contains(item)
assert_that(lambda: func()).raises(Exception)
```

### Common Mock Patterns

```python
# Setup return value
mock.method.return_value = value

# Setup with side effect
mock.method.side_effect = [value1, value2]

# Verify call
mock.method.assert_called_once()
mock.method.assert_called_with(arg)
mock.method.assert_not_called()
```

## Next Steps

1. Review [Python Testing Patterns](./01-TESTING-PATTERNS.md)
2. Learn [Python Mocking with pytest-mock](./02-MOCKING.md)
3. Explore [Python Integration Testing](./03-INTEGRATION-TESTING.md)
4. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**You're now ready to write tests in Python!** Start with simple unit tests and gradually move to more complex scenarios.
