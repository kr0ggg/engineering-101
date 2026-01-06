# Customer Service Tests - Python Example

**Section**: [Isolated Testing with Dependency Injection](../../1-introduction-to-the-domain.md#isolated-testing-with-dependency-injection)

**Navigation**: [← Previous: Pricing Service Tests](./09-pricing-service-tests.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Customer Service Tests (pytest) - Mocked Dependencies
# File: 2-Domain-Driven-Design/code-samples/python/10-customer-service-tests.py

import pytest
from unittest.mock import Mock, patch, MagicMock
from datetime import datetime

# Import the domain objects
from customer_module import CustomerService, Customer, CustomerId, EmailAddress, CustomerStatus
from customer_module import CustomerRepository, EmailService

class TestCustomerService:
    """Test class for CustomerService domain service"""
    
    def test_register_customer_success(self):
        """Test successful customer registration"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = "John Doe"
        email = "john.doe@example.com"
        
        # Mock repository to return None (customer doesn't exist)
        mock_repository.find_by_email.return_value = None
        
        # Act
        customer = customer_service.register_customer(name, email)
        
        # Assert
        assert isinstance(customer, Customer)
        assert customer.name == name
        assert customer.email.value == email
        assert customer.is_active() is True
        
        # Verify repository was called
        mock_repository.find_by_email.assert_called_once_with(email)
        mock_repository.save.assert_called_once_with(customer)
        
        # Verify email service was called
        mock_email_service.send_welcome_email.assert_called_once_with(customer)
    
    def test_register_customer_with_empty_name_raises_error(self):
        """Test that registering customer with empty name raises error"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = ""
        email = "john.doe@example.com"
        
        # Act & Assert
        with pytest.raises(ValueError, match="Name cannot be empty"):
            customer_service.register_customer(name, email)
        
        # Verify repository was not called
        mock_repository.find_by_email.assert_not_called()
        mock_repository.save.assert_not_called()
    
    def test_register_customer_with_whitespace_name_raises_error(self):
        """Test that registering customer with whitespace name raises error"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = "   "
        email = "john.doe@example.com"
        
        # Act & Assert
        with pytest.raises(ValueError, match="Name cannot be empty"):
            customer_service.register_customer(name, email)
    
    def test_register_customer_with_existing_email_raises_error(self):
        """Test that registering customer with existing email raises error"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = "John Doe"
        email = "john.doe@example.com"
        
        # Mock repository to return existing customer
        existing_customer = Mock(spec=Customer)
        mock_repository.find_by_email.return_value = existing_customer
        
        # Act & Assert
        with pytest.raises(ValueError, match="Customer with this email already exists"):
            customer_service.register_customer(name, email)
        
        # Verify repository was called but save was not
        mock_repository.find_by_email.assert_called_once_with(email)
        mock_repository.save.assert_not_called()
    
    def test_register_customer_with_invalid_email_raises_error(self):
        """Test that registering customer with invalid email raises error"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = "John Doe"
        email = "invalid-email"
        
        # Act & Assert
        with pytest.raises(ValueError, match="Invalid email address"):
            customer_service.register_customer(name, email)
        
        # Verify repository was not called
        mock_repository.find_by_email.assert_not_called()
        mock_repository.save.assert_not_called()
    
    def test_update_customer_email_success(self):
        """Test successful customer email update"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "customer-123"
        new_email = "john.doe.new@example.com"
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Mock repository to return None (new email doesn't exist)
        mock_repository.find_by_email.return_value = None
        
        # Act
        customer_service.update_customer_email(customer_id, new_email)
        
        # Assert
        # Verify customer's update_email method was called
        existing_customer.update_email.assert_called_once()
        
        # Verify repository was called
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.find_by_email.assert_called_once_with(new_email)
        mock_repository.save.assert_called_once_with(existing_customer)
        
        # Verify email service was called
        mock_email_service.send_email_change_notification.assert_called_once_with(existing_customer)
    
    def test_update_customer_email_customer_not_found_raises_error(self):
        """Test that updating email for non-existent customer raises error"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "non-existent-customer"
        new_email = "john.doe.new@example.com"
        
        # Mock repository to return None (customer doesn't exist)
        mock_repository.find_by_id.return_value = None
        
        # Act & Assert
        with pytest.raises(ValueError, match="Customer not found"):
            customer_service.update_customer_email(customer_id, new_email)
        
        # Verify repository was called but save was not
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.save.assert_not_called()
    
    def test_update_customer_email_email_already_exists_raises_error(self):
        """Test that updating email to existing email raises error"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "customer-123"
        new_email = "existing@example.com"
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Mock repository to return different customer (email exists)
        different_customer = Mock(spec=Customer)
        different_customer.id = CustomerId("different-customer")
        mock_repository.find_by_email.return_value = different_customer
        
        # Act & Assert
        with pytest.raises(ValueError, match="Email already in use"):
            customer_service.update_customer_email(customer_id, new_email)
        
        # Verify repository was called but save was not
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.find_by_email.assert_called_once_with(new_email)
        mock_repository.save.assert_not_called()
    
    def test_update_customer_email_with_invalid_email_raises_error(self):
        """Test that updating email with invalid email raises error"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "customer-123"
        new_email = "invalid-email"
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Act & Assert
        with pytest.raises(ValueError, match="Invalid email address"):
            customer_service.update_customer_email(customer_id, new_email)
        
        # Verify repository was called but save was not
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.save.assert_not_called()
    
    def test_suspend_customer_success(self):
        """Test successful customer suspension"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "customer-123"
        reason = "Violation of terms of service"
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Act
        customer_service.suspend_customer(customer_id, reason)
        
        # Assert
        # Verify customer's suspend method was called
        existing_customer.suspend.assert_called_once()
        
        # Verify repository was called
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.save.assert_called_once_with(existing_customer)
        
        # Verify email service was called
        mock_email_service.send_suspension_notification.assert_called_once_with(existing_customer, reason)
    
    def test_suspend_customer_not_found_raises_error(self):
        """Test that suspending non-existent customer raises error"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "non-existent-customer"
        reason = "Violation of terms of service"
        
        # Mock repository to return None (customer doesn't exist)
        mock_repository.find_by_id.return_value = None
        
        # Act & Assert
        with pytest.raises(ValueError, match="Customer not found"):
            customer_service.suspend_customer(customer_id, reason)
        
        # Verify repository was called but save was not
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.save.assert_not_called()
    
    def test_suspend_customer_with_empty_reason(self):
        """Test suspending customer with empty reason"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "customer-123"
        reason = ""
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Act
        customer_service.suspend_customer(customer_id, reason)
        
        # Assert
        # Verify customer's suspend method was called
        existing_customer.suspend.assert_called_once()
        
        # Verify repository was called
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.save.assert_called_once_with(existing_customer)
        
        # Verify email service was called with empty reason
        mock_email_service.send_suspension_notification.assert_called_once_with(existing_customer, reason)
    
    def test_register_customer_name_trimming(self):
        """Test that customer name is trimmed during registration"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = "  John Doe  "  # Name with leading/trailing whitespace
        email = "john.doe@example.com"
        
        # Mock repository to return None (customer doesn't exist)
        mock_repository.find_by_email.return_value = None
        
        # Act
        customer = customer_service.register_customer(name, email)
        
        # Assert
        assert customer.name == "John Doe"  # Name should be trimmed
        assert customer.email.value == email
    
    def test_register_customer_email_normalization(self):
        """Test that customer email is normalized during registration"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = "John Doe"
        email = "  JOHN.DOE@EXAMPLE.COM  "  # Email with case and whitespace
        
        # Mock repository to return None (customer doesn't exist)
        mock_repository.find_by_email.return_value = None
        
        # Act
        customer = customer_service.register_customer(name, email)
        
        # Assert
        assert customer.email.value == "john.doe@example.com"  # Email should be normalized
    
    def test_customer_service_dependency_injection(self):
        """Test that CustomerService properly uses injected dependencies"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        
        # Act
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        # Assert
        assert customer_service._repository is mock_repository
        assert customer_service._email_service is mock_email_service
    
    def test_customer_service_with_none_dependencies_raises_error(self):
        """Test that CustomerService raises error with None dependencies"""
        # Act & Assert
        with pytest.raises(TypeError):
            CustomerService(None, Mock(spec=EmailService))
        
        with pytest.raises(TypeError):
            CustomerService(Mock(spec=CustomerRepository), None)
    
    def test_customer_service_with_wrong_dependency_types_raises_error(self):
        """Test that CustomerService raises error with wrong dependency types"""
        # Act & Assert
        with pytest.raises(TypeError):
            CustomerService("not_a_repository", Mock(spec=EmailService))
        
        with pytest.raises(TypeError):
            CustomerService(Mock(spec=CustomerRepository), "not_an_email_service")

class TestCustomerServiceIntegration:
    """Integration tests for CustomerService"""
    
    def test_complete_customer_registration_flow(self):
        """Test complete customer registration flow"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        name = "John Doe"
        email = "john.doe@example.com"
        
        # Mock repository to return None (customer doesn't exist)
        mock_repository.find_by_email.return_value = None
        
        # Act
        customer = customer_service.register_customer(name, email)
        
        # Assert
        assert isinstance(customer, Customer)
        assert customer.name == name
        assert customer.email.value == email
        assert customer.is_active() is True
        
        # Verify all interactions
        mock_repository.find_by_email.assert_called_once_with(email)
        mock_repository.save.assert_called_once_with(customer)
        mock_email_service.send_welcome_email.assert_called_once_with(customer)
    
    def test_complete_customer_email_update_flow(self):
        """Test complete customer email update flow"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "customer-123"
        new_email = "john.doe.new@example.com"
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Mock repository to return None (new email doesn't exist)
        mock_repository.find_by_email.return_value = None
        
        # Act
        customer_service.update_customer_email(customer_id, new_email)
        
        # Assert
        # Verify all interactions
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        mock_repository.find_by_email.assert_called_once_with(new_email)
        existing_customer.update_email.assert_called_once()
        mock_repository.save.assert_called_once_with(existing_customer)
        mock_email_service.send_email_change_notification.assert_called_once_with(existing_customer)
    
    def test_complete_customer_suspension_flow(self):
        """Test complete customer suspension flow"""
        # Arrange
        mock_repository = Mock(spec=CustomerRepository)
        mock_email_service = Mock(spec=EmailService)
        customer_service = CustomerService(mock_repository, mock_email_service)
        
        customer_id = "customer-123"
        reason = "Violation of terms of service"
        
        # Mock existing customer
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        
        # Act
        customer_service.suspend_customer(customer_id, reason)
        
        # Assert
        # Verify all interactions
        mock_repository.find_by_id.assert_called_once_with(customer_id)
        existing_customer.suspend.assert_called_once()
        mock_repository.save.assert_called_once_with(existing_customer)
        mock_email_service.send_suspension_notification.assert_called_once_with(existing_customer, reason)

# Test fixtures
@pytest.fixture
def mock_repository():
    """Fixture for creating mock repository"""
    return Mock(spec=CustomerRepository)

@pytest.fixture
def mock_email_service():
    """Fixture for creating mock email service"""
    return Mock(spec=EmailService)

@pytest.fixture
def customer_service(mock_repository, mock_email_service):
    """Fixture for creating customer service with mocked dependencies"""
    return CustomerService(mock_repository, mock_email_service)

# Parametrized tests
@pytest.mark.parametrize("name,email,should_succeed", [
    ("John Doe", "john.doe@example.com", True),
    ("Jane Smith", "jane.smith@company.com", True),
    ("", "john.doe@example.com", False),
    ("   ", "john.doe@example.com", False),
    ("John Doe", "", False),
    ("John Doe", "invalid-email", False),
    ("John Doe", "john.doe@example.com", True),  # Duplicate email case
])
def test_register_customer_validation(name, email, should_succeed):
    """Test customer registration validation with different parameters"""
    # Arrange
    mock_repository = Mock(spec=CustomerRepository)
    mock_email_service = Mock(spec=EmailService)
    customer_service = CustomerService(mock_repository, mock_email_service)
    
    # Mock repository behavior
    if should_succeed:
        mock_repository.find_by_email.return_value = None
    else:
        if email == "john.doe@example.com" and name == "John Doe":
            # Simulate duplicate email case
            existing_customer = Mock(spec=Customer)
            mock_repository.find_by_email.return_value = existing_customer
        else:
            mock_repository.find_by_email.return_value = None
    
    # Act & Assert
    if should_succeed:
        customer = customer_service.register_customer(name, customer_email)
        assert isinstance(customer, Customer)
        assert customer.name == name.strip()
        assert customer.email.value == email.strip().lower()
    else:
        with pytest.raises(ValueError):
            customer_service.register_customer(name, email)

@pytest.mark.parametrize("customer_id,new_email,should_succeed", [
    ("customer-123", "john.doe.new@example.com", True),
    ("customer-123", "jane.smith@company.com", True),
    ("non-existent", "john.doe.new@example.com", False),
    ("customer-123", "", False),
    ("customer-123", "invalid-email", False),
    ("customer-123", "existing@example.com", False),  # Duplicate email case
])
def test_update_customer_email_validation(customer_id, new_email, should_succeed):
    """Test customer email update validation with different parameters"""
    # Arrange
    mock_repository = Mock(spec=CustomerRepository)
    mock_email_service = Mock(spec=EmailService)
    customer_service = CustomerService(mock_repository, mock_email_service)
    
    # Mock repository behavior
    if should_succeed:
        existing_customer = Mock(spec=Customer)
        existing_customer.id = CustomerId(customer_id)
        mock_repository.find_by_id.return_value = existing_customer
        mock_repository.find_by_email.return_value = None
    else:
        if customer_id == "non-existent":
            mock_repository.find_by_id.return_value = None
        else:
            existing_customer = Mock(spec=Customer)
            existing_customer.id = CustomerId(customer_id)
            mock_repository.find_by_id.return_value = existing_customer
            
            if new_email == "existing@example.com":
                different_customer = Mock(spec=Customer)
                different_customer.id = CustomerId("different-customer")
                mock_repository.find_by_email.return_value = different_customer
            else:
                mock_repository.find_by_email.return_value = None
    
    # Act & Assert
    if should_succeed:
        customer_service.update_customer_email(customer_id, new_email)
        existing_customer.update_email.assert_called_once()
        mock_repository.save.assert_called_once_with(existing_customer)
    else:
        with pytest.raises(ValueError):
            customer_service.update_customer_email(customer_id, new_email)
```

## Key Concepts Demonstrated

### Isolated Testing with Dependency Injection

#### 1. **Dependency Injection Testing**
- ✅ Dependencies are injected through constructor
- ✅ Dependencies are mocked for isolated testing
- ✅ Service behavior is tested without external dependencies

#### 2. **Mock Usage**
- ✅ External dependencies are properly mocked
- ✅ Mock behavior is configured for test scenarios
- ✅ Mock interactions are verified

#### 3. **Service Isolation**
- ✅ Service logic is tested in isolation
- ✅ No external system dependencies
- ✅ Fast and reliable test execution

#### 4. **Integration Testing**
- ✅ Complete workflows are tested
- ✅ Service interactions are verified
- ✅ End-to-end scenarios are covered

### Customer Service Testing Principles

#### **Test Business Rules**
- ✅ Customer registration rules are tested
- ✅ Email update rules are verified
- ✅ Customer suspension rules are tested

#### **Test Error Conditions**
- ✅ Invalid inputs are properly rejected
- ✅ Business rule violations are handled
- ✅ Error messages are clear and descriptive

#### **Test Dependency Interactions**
- ✅ Repository interactions are verified
- ✅ Email service interactions are tested
- ✅ Service composition is validated

#### **Test Mocking**
- ✅ Dependencies are properly mocked
- ✅ Mock behavior is configured correctly
- ✅ Mock interactions are verified

### Python Testing Benefits
- **pytest**: Powerful testing framework with fixtures and parametrization
- **unittest.mock**: Built-in mocking capabilities
- **Type Hints**: Better IDE support and documentation
- **Fixtures**: Reusable test data and setup
- **Parametrized Tests**: Test multiple scenarios efficiently
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

- [Customer Module](./06-customer-module.md) - Module containing Customer Service
- [Customer Entity](./01-customer-entity.md) - Entity used by Customer Service
- [EmailAddress Value Object](./04-email-address-value-object.md) - Value object used by Customer Service
- [Isolated Testing with Dependency Injection](../../1-introduction-to-the-domain.md#isolated-testing-with-dependency-injection) - Testing concepts

/*
 * Navigation:
 * Previous: 09-pricing-service-tests.md
 * Next: 11-testing-anti-patterns.md
 *
 * Back to: [Isolated Testing with Dependency Injection](../../1-introduction-to-the-domain.md#isolated-testing-with-dependency-injection)
 */
