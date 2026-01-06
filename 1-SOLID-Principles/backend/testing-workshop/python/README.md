# Python Testing Guide for SOLID Principles

## Overview

Comprehensive testing resources for Python backend development using pytest, pytest-mock, and Testcontainers.

## Testing Stack

- **pytest** - Test framework
- **pytest-mock** - Mocking utilities (wraps unittest.mock)
- **assertpy** - Fluent assertions
- **Testcontainers** - Integration testing

## Guide Structure

1. **[Setup](./00-SETUP.md)** - Complete Python testing environment setup
2. **[Testing Patterns](./01-TESTING-PATTERNS.md)** - SOLID principle testing patterns
3. **[Mocking with pytest-mock](./02-MOCKING.md)** - Comprehensive mocking guide
4. **[Integration Testing](./03-INTEGRATION-TESTING.md)** - Testcontainers integration

## Quick Start

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # macOS/Linux
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements-dev.txt

# Run tests
pytest
pytest --cov=src --cov-report=html
pytest -n auto  # Parallel execution
```

## Key Concepts

- Use fixtures for setup/teardown
- Use `@pytest.mark.parametrize` for multiple test cases
- Use `assertpy` for fluent assertions
- Use Testcontainers for real database testing
- Follow AAA pattern (Arrange-Act-Assert)

## Next Steps

1. Complete [Setup](./00-SETUP.md)
2. Learn [Testing Patterns](./01-TESTING-PATTERNS.md)
3. Master [pytest-mock](./02-MOCKING.md)
4. Apply to [SOLID Workshops](../README.md#solid-principle-testing-workshops)
