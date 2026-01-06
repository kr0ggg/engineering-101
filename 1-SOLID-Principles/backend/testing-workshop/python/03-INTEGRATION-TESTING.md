# Python Integration Testing with Testcontainers

## Overview

Integration tests verify that multiple components work together correctly. This guide covers integration testing in Python using Testcontainers for real database testing.

## Setup

```bash
pip install testcontainers[postgresql]
pip install psycopg2-binary
```

## Basic Testcontainers Setup

### Database Test Base

```python
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
            
            CREATE TABLE orders (
                id SERIAL PRIMARY KEY,
                customer_id INTEGER REFERENCES customers(id),
                total DECIMAL(10, 2) NOT NULL,
                status VARCHAR(50) NOT NULL,
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

### Repository Integration Test

```python
import pytest
from assertpy import assert_that

@pytest.mark.integration
class TestCustomerRepositoryIntegration:
    
    def test_save_persists_customer_to_database(self, db_connection):
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
    
    def test_find_by_id_returns_none_when_not_exists(self, db_connection):
        # Arrange
        repository = CustomerRepository(db_connection)
        
        # Act
        result = repository.find_by_id(999)
        
        # Assert
        assert_that(result).is_none()
    
    def test_update_modifies_existing_customer(self, db_connection):
        # Arrange
        repository = CustomerRepository(db_connection)
        customer = Customer(id=None, name="John Doe", email="john@example.com")
        repository.save(customer)
        
        # Act
        customer.name = "Jane Doe"
        repository.update(customer)
        
        # Assert
        updated = repository.find_by_id(customer.id)
        assert_that(updated.name).is_equal_to("Jane Doe")
    
    def test_delete_removes_customer(self, db_connection):
        # Arrange
        repository = CustomerRepository(db_connection)
        customer = Customer(id=None, name="John Doe", email="john@example.com")
        repository.save(customer)
        
        # Act
        repository.delete(customer.id)
        
        # Assert
        deleted = repository.find_by_id(customer.id)
        assert_that(deleted).is_none()
```

## Transaction Testing

```python
@pytest.mark.integration
class TestTransactions:
    
    def test_transaction_rollback_on_error(self, db_connection):
        # Arrange
        db_connection.autocommit = False
        repository = CustomerRepository(db_connection)
        customer = Customer(id=None, name="John Doe", email="john@example.com")
        
        try:
            # Act
            repository.save(customer)
            raise RuntimeError("Simulated error")
        except RuntimeError:
            db_connection.rollback()
        
        # Assert - Customer should not exist
        result = repository.find_by_email("john@example.com")
        assert_that(result).is_none()
    
    def test_transaction_commit_successfully(self, db_connection):
        # Arrange
        db_connection.autocommit = False
        repository = CustomerRepository(db_connection)
        customer = Customer(id=None, name="John Doe", email="john@example.com")
        
        # Act
        repository.save(customer)
        db_connection.commit()
        
        # Assert - Customer should exist
        result = repository.find_by_email("john@example.com")
        assert_that(result).is_not_none()
```

## Testing Multiple Containers

```python
from testcontainers.redis import RedisContainer

@pytest.fixture(scope="session")
def redis_container():
    with RedisContainer("redis:7") as redis:
        yield redis

@pytest.fixture(scope="session")
def multi_container_setup(postgres_container, redis_container):
    return {
        'postgres': postgres_container,
        'redis': redis_container
    }

def test_with_multiple_containers(multi_container_setup):
    # Test with both PostgreSQL and Redis
    assert multi_container_setup['postgres'].get_exposed_port(5432)
    assert multi_container_setup['redis'].get_exposed_port(6379)
```

## Performance Testing

```python
import time

@pytest.mark.integration
@pytest.mark.slow
def test_bulk_insert_completes_in_reasonable_time(db_connection):
    # Arrange
    repository = CustomerRepository(db_connection)
    customers = [
        Customer(id=None, name=f"Customer {i}", email=f"customer{i}@example.com")
        for i in range(1, 1001)
    ]
    
    # Act
    start_time = time.time()
    for customer in customers:
        repository.save(customer)
    duration = time.time() - start_time
    
    # Assert
    assert_that(duration).is_less_than(5.0)  # 5 seconds
```

## Data Seeding

```python
class DatabaseSeeder:
    def __init__(self, connection):
        self.connection = connection
    
    def seed_test_data(self):
        self.seed_customers()
        self.seed_products()
        self.seed_orders()
    
    def seed_customers(self):
        with self.connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO customers (name, email, is_active)
                VALUES 
                    ('John Doe', 'john@example.com', true),
                    ('Jane Smith', 'jane@example.com', true),
                    ('Bob Johnson', 'bob@example.com', false)
            """)
        self.connection.commit()
    
    def seed_products(self):
        # Seed products
        pass
    
    def seed_orders(self):
        # Seed orders
        pass

# Usage in tests
@pytest.fixture
def seeded_database(db_connection):
    seeder = DatabaseSeeder(db_connection)
    seeder.seed_test_data()
    return db_connection

def test_get_active_customers_returns_only_active(seeded_database):
    # Arrange
    repository = CustomerRepository(seeded_database)
    
    # Act
    customers = repository.find_active_customers()
    
    # Assert
    assert_that(customers).is_length(2)
    assert all(c.is_active for c in customers)
```

## Cleanup Between Tests

```python
@pytest.fixture
def clean_database(db_connection):
    # Setup
    yield db_connection
    
    # Cleanup
    with db_connection.cursor() as cursor:
        cursor.execute("DELETE FROM orders")
        cursor.execute("DELETE FROM customers")
    db_connection.commit()

def test_with_clean_database(clean_database):
    # Each test starts with clean database
    repository = CustomerRepository(clean_database)
    customers = repository.find_all()
    assert_that(customers).is_empty()
```

## Best Practices

### ✅ Do's

```python
# Use session scope for containers
@pytest.fixture(scope="session")
def postgres_container():
    with PostgresContainer("postgres:16") as postgres:
        yield postgres

# Use transactions for isolation
@pytest.fixture
def db_cursor(db_connection):
    cursor = db_connection.cursor()
    yield cursor
    db_connection.rollback()  # Rollback after each test

# Mark integration tests
@pytest.mark.integration
def test_database_operation():
    pass

# Test realistic scenarios
def test_complete_order_workflow():
    # Test end-to-end workflow
    pass
```

### ❌ Don'ts

```python
# Don't share data between tests
shared_customer = None  # Bad!

# Don't use production database
connection = psycopg2.connect("production-url")  # Never!

# Don't skip cleanup
# Always clean up test data

# Don't test too much in one test
def test_everything():  # Bad - too broad
    # 100 lines of test code
    pass
```

## Running Integration Tests

```bash
# Run all tests
pytest

# Run only integration tests
pytest -m integration

# Skip integration tests
pytest -m "not integration"

# Run with coverage
pytest --cov=src --cov-report=html -m integration

# Run in parallel (fast tests only)
pytest -n auto -m "not slow"
```

## Configuration

### pytest.ini

```ini
[pytest]
markers =
    integration: Integration tests
    slow: Slow running tests
    unit: Unit tests

# Don't run slow tests by default
addopts = -m "not slow"
```

### Running Specific Tests

```bash
# Run integration tests only
pytest -m integration

# Run fast integration tests
pytest -m "integration and not slow"

# Run all tests including slow ones
pytest -m ""
```

## Summary

**Key Concepts**:
- Use Testcontainers for real database testing
- Use session-scoped fixtures for containers
- Test actual SQL queries and transactions
- Clean up data between tests
- Use realistic test scenarios
- Mark tests appropriately

## Next Steps

1. Review [Testing Patterns](./01-TESTING-PATTERNS.md)
2. Review [Mocking with pytest-mock](./02-MOCKING.md)
3. Apply to [SOLID Principle Workshops](../README.md#solid-principle-testing-workshops)

---

**Key Takeaway**: Integration tests with Testcontainers give you confidence that your code works with real infrastructure while keeping tests fast and isolated.
