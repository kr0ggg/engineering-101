# Customer Module - Python Example

**Section**: [Modules and Separation of Concerns](../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns)

**Navigation**: [← Previous: Pricing Service](./05-pricing-service.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Customer Module with Separation of Concerns
# File: 2-Domain-Driven-Design/code-samples/python/06-customer-module.py

from abc import ABC, abstractmethod
from typing import List, Optional, Dict, Any
from dataclasses import dataclass, field
from datetime import datetime
import uuid

# ✅ GOOD: Customer Module - Well-Organized Domain Layer
class CustomerModule:
    """Customer module containing all customer-related domain logic"""
    
    def __init__(self):
        self._customer_repository = CustomerRepository()
        self._email_service = EmailService()
        self._customer_service = CustomerService(
            self._customer_repository,
            self._email_service
        )
        self._customer_factory = CustomerFactory()
        self._customer_specification = CustomerSpecification()
    
    def register_customer(self, name: str, email: str) -> 'Customer':
        """Register a new customer"""
        return self._customer_service.register_customer(name, email)
    
    def activate_customer(self, customer_id: str) -> None:
        """Activate a customer"""
        customer = self._customer_repository.find_by_id(customer_id)
        if customer:
            customer.activate()
            self._customer_repository.save(customer)
    
    def deactivate_customer(self, customer_id: str) -> None:
        """Deactivate a customer"""
        customer = self._customer_repository.find_by_id(customer_id)
        if customer:
            customer.deactivate()
            self._customer_repository.save(customer)
    
    def get_customer_info(self, customer_id: str) -> Optional[Dict[str, Any]]:
        """Get customer information"""
        customer = self._customer_repository.find_by_id(customer_id)
        if customer:
            return {
                'id': customer.id.value,
                'name': customer.name,
                'email': customer.email.value,
                'status': customer.status.value,
                'created_at': customer.created_at.isoformat(),
                'is_active': customer.is_active()
            }
        return None

# ✅ GOOD: Customer Entity
class CustomerStatus(Enum):
    PENDING = "Pending"
    ACTIVE = "Active"
    SUSPENDED = "Suspended"
    INACTIVE = "Inactive"

@dataclass(frozen=True)
class CustomerId:
    """Value object for Customer identity"""
    value: str
    
    @classmethod
    def generate(cls) -> 'CustomerId':
        return cls(str(uuid.uuid4()))
    
    def __str__(self) -> str:
        return self.value

@dataclass(frozen=True)
class EmailAddress:
    """Value object for email address"""
    value: str
    
    def __post_init__(self):
        if not self._is_valid_email(self.value):
            raise ValueError(f"Invalid email address: {self.value}")
    
    def _is_valid_email(self, email: str) -> bool:
        import re
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return re.match(pattern, email) is not None
    
    def __str__(self) -> str:
        return self.value

class Customer:
    """Customer entity with rich behavior"""
    
    def __init__(
        self,
        customer_id: CustomerId,
        name: str,
        email: EmailAddress,
        created_at: Optional[datetime] = None
    ):
        self._id = customer_id
        self._name = name
        self._email = email
        self._created_at = created_at or datetime.utcnow()
        self._status = CustomerStatus.PENDING
        self._last_activity = None
        self._orders_count = 0
        self._total_spent = Money(0, 'USD')
    
    # Identity properties
    @property
    def id(self) -> CustomerId:
        return self._id
    
    @property
    def name(self) -> str:
        return self._name
    
    @property
    def email(self) -> EmailAddress:
        return self._email
    
    @property
    def created_at(self) -> datetime:
        return self._created_at
    
    @property
    def status(self) -> CustomerStatus:
        return self._status
    
    @property
    def last_activity(self) -> Optional[datetime]:
        return self._last_activity
    
    @property
    def orders_count(self) -> int:
        return self._orders_count
    
    @property
    def total_spent(self) -> Money:
        return self._total_spent
    
    # Business operations
    def activate(self) -> None:
        """Activate the customer"""
        if self._status == CustomerStatus.SUSPENDED:
            raise ValueError("Cannot activate suspended customer")
        self._status = CustomerStatus.ACTIVE
        self._last_activity = datetime.utcnow()
    
    def deactivate(self) -> None:
        """Deactivate the customer"""
        self._status = CustomerStatus.INACTIVE
        self._last_activity = datetime.utcnow()
    
    def suspend(self) -> None:
        """Suspend the customer"""
        self._status = CustomerStatus.SUSPENDED
        self._last_activity = datetime.utcnow()
    
    def update_email(self, new_email: EmailAddress) -> None:
        """Update customer email"""
        if self._status == CustomerStatus.SUSPENDED:
            raise ValueError("Cannot update email for suspended customer")
        self._email = new_email
        self._last_activity = datetime.utcnow()
    
    def update_name(self, new_name: str) -> None:
        """Update customer name"""
        if not new_name or not new_name.strip():
            raise ValueError("Name cannot be empty")
        self._name = new_name.strip()
        self._last_activity = datetime.utcnow()
    
    def record_order(self, order_amount: Money) -> None:
        """Record a new order"""
        if self._status != CustomerStatus.ACTIVE:
            raise ValueError("Only active customers can place orders")
        self._orders_count += 1
        self._total_spent = self._total_spent.add(order_amount)
        self._last_activity = datetime.utcnow()
    
    # Business rules
    def is_active(self) -> bool:
        """Check if customer is active"""
        return self._status == CustomerStatus.ACTIVE
    
    def can_place_orders(self) -> bool:
        """Check if customer can place orders"""
        return self._status == CustomerStatus.ACTIVE
    
    def is_vip(self) -> bool:
        """Check if customer is VIP"""
        return self._total_spent.amount >= 1000
    
    def is_premium(self) -> bool:
        """Check if customer is premium"""
        return self._total_spent.amount >= 500
    
    def get_customer_type(self) -> str:
        """Get customer type based on spending"""
        if self.is_vip():
            return 'VIP'
        elif self.is_premium():
            return 'Premium'
        else:
            return 'Standard'
    
    def __str__(self) -> str:
        return f"Customer(id={self._id}, name={self._name}, email={self._email}, status={self._status.value})"

# ✅ GOOD: Customer Repository Interface
class CustomerRepository(ABC):
    """Abstract base class for customer repository"""
    
    @abstractmethod
    def find_by_id(self, customer_id: str) -> Optional[Customer]:
        """Find customer by ID"""
        pass
    
    @abstractmethod
    def find_by_email(self, email: str) -> Optional[Customer]:
        """Find customer by email"""
        pass
    
    @abstractmethod
    def save(self, customer: Customer) -> None:
        """Save customer"""
        pass
    
    @abstractmethod
    def delete(self, customer_id: str) -> None:
        """Delete customer"""
        pass
    
    @abstractmethod
    def find_all(self) -> List[Customer]:
        """Find all customers"""
        pass

# ✅ GOOD: In-Memory Customer Repository Implementation
class InMemoryCustomerRepository(CustomerRepository):
    """In-memory implementation of customer repository"""
    
    def __init__(self):
        self._customers: Dict[str, Customer] = {}
    
    def find_by_id(self, customer_id: str) -> Optional[Customer]:
        return self._customers.get(customer_id)
    
    def find_by_email(self, email: str) -> Optional[Customer]:
        for customer in self._customers.values():
            if customer.email.value == email:
                return customer
        return None
    
    def save(self, customer: Customer) -> None:
        self._customers[customer.id.value] = customer
    
    def delete(self, customer_id: str) -> None:
        if customer_id in self._customers:
            del self._customers[customer_id]
    
    def find_all(self) -> List[Customer]:
        return list(self._customers.values())

# ✅ GOOD: Customer Service
class CustomerService:
    """Domain service for customer operations"""
    
    def __init__(self, repository: CustomerRepository, email_service: 'EmailService'):
        self._repository = repository
        self._email_service = email_service
    
    def register_customer(self, name: str, email: str) -> Customer:
        """Register a new customer"""
        # Validate input
        if not name or not name.strip():
            raise ValueError("Name cannot be empty")
        
        # Check if customer already exists
        existing_customer = self._repository.find_by_email(email)
        if existing_customer:
            raise ValueError("Customer with this email already exists")
        
        # Create new customer
        customer_id = CustomerId.generate()
        email_address = EmailAddress(email)
        customer = Customer(customer_id, name.strip(), email_address)
        
        # Activate customer
        customer.activate()
        
        # Save customer
        self._repository.save(customer)
        
        # Send welcome email
        self._email_service.send_welcome_email(customer)
        
        return customer
    
    def update_customer_email(self, customer_id: str, new_email: str) -> None:
        """Update customer email"""
        customer = self._repository.find_by_id(customer_id)
        if not customer:
            raise ValueError("Customer not found")
        
        # Check if new email already exists
        existing_customer = self._repository.find_by_email(new_email)
        if existing_customer and existing_customer.id != customer.id:
            raise ValueError("Email already in use")
        
        # Update email
        new_email_address = EmailAddress(new_email)
        customer.update_email(new_email_address)
        
        # Save changes
        self._repository.save(customer)
        
        # Send email change notification
        self._email_service.send_email_change_notification(customer)
    
    def suspend_customer(self, customer_id: str, reason: str) -> None:
        """Suspend a customer"""
        customer = self._repository.find_by_id(customer_id)
        if not customer:
            raise ValueError("Customer not found")
        
        customer.suspend()
        self._repository.save(customer)
        
        # Send suspension notification
        self._email_service.send_suspension_notification(customer, reason)

# ✅ GOOD: Email Service Interface
class EmailService(ABC):
    """Abstract base class for email service"""
    
    @abstractmethod
    def send_welcome_email(self, customer: Customer) -> None:
        """Send welcome email to customer"""
        pass
    
    @abstractmethod
    def send_email_change_notification(self, customer: Customer) -> None:
        """Send email change notification"""
        pass
    
    @abstractmethod
    def send_suspension_notification(self, customer: Customer, reason: str) -> None:
        """Send suspension notification"""
        pass

# ✅ GOOD: Mock Email Service Implementation
class MockEmailService(EmailService):
    """Mock implementation of email service for testing"""
    
    def __init__(self):
        self._sent_emails = []
    
    def send_welcome_email(self, customer: Customer) -> None:
        self._sent_emails.append({
            'type': 'welcome',
            'customer_id': customer.id.value,
            'email': customer.email.value,
            'timestamp': datetime.utcnow()
        })
    
    def send_email_change_notification(self, customer: Customer) -> None:
        self._sent_emails.append({
            'type': 'email_change',
            'customer_id': customer.id.value,
            'email': customer.email.value,
            'timestamp': datetime.utcnow()
        })
    
    def send_suspension_notification(self, customer: Customer, reason: str) -> None:
        self._sent_emails.append({
            'type': 'suspension',
            'customer_id': customer.id.value,
            'email': customer.email.value,
            'reason': reason,
            'timestamp': datetime.utcnow()
        })
    
    def get_sent_emails(self) -> List[Dict[str, Any]]:
        return self._sent_emails.copy()

# ✅ GOOD: Customer Factory
class CustomerFactory:
    """Factory for creating customers with different strategies"""
    
    @staticmethod
    def create_standard_customer(name: str, email: str) -> Customer:
        """Create a standard customer"""
        customer_id = CustomerId.generate()
        email_address = EmailAddress(email)
        customer = Customer(customer_id, name, email_address)
        customer.activate()
        return customer
    
    @staticmethod
    def create_vip_customer(name: str, email: str) -> Customer:
        """Create a VIP customer"""
        customer_id = CustomerId.generate()
        email_address = EmailAddress(email)
        customer = Customer(customer_id, name, email_address)
        customer.activate()
        # VIP customers start with some benefits
        customer._total_spent = Money(1000, 'USD')  # Start as VIP
        return customer
    
    @staticmethod
    def create_customer_from_data(data: Dict[str, Any]) -> Customer:
        """Create customer from data dictionary"""
        customer_id = CustomerId(data['id'])
        email_address = EmailAddress(data['email'])
        customer = Customer(customer_id, data['name'], email_address)
        
        # Set status
        if data.get('status') == 'Active':
            customer.activate()
        elif data.get('status') == 'Suspended':
            customer.suspend()
        elif data.get('status') == 'Inactive':
            customer.deactivate()
        
        return customer

# ✅ GOOD: Customer Specification
class CustomerSpecification:
    """Specification for customer-related business rules"""
    
    def is_eligible_for_vip(self, customer: Customer) -> bool:
        """Check if customer is eligible for VIP status"""
        return (customer.is_active() and
                customer.total_spent.amount >= 1000 and
                customer.orders_count >= 10)
    
    def is_eligible_for_premium(self, customer: Customer) -> bool:
        """Check if customer is eligible for premium status"""
        return (customer.is_active() and
                customer.total_spent.amount >= 500 and
                customer.orders_count >= 5)
    
    def can_be_suspended(self, customer: Customer) -> bool:
        """Check if customer can be suspended"""
        return customer.status in [CustomerStatus.ACTIVE, CustomerStatus.PENDING]
    
    def is_inactive_for_too_long(self, customer: Customer, days: int = 365) -> bool:
        """Check if customer has been inactive for too long"""
        if not customer.last_activity:
            return True
        
        days_since_activity = (datetime.utcnow() - customer.last_activity).days
        return days_since_activity > days
    
    def meets_minimum_requirements(self, customer: Customer) -> bool:
        """Check if customer meets minimum requirements"""
        return (customer.name and
                customer.email and
                customer.status != CustomerStatus.SUSPENDED)

# ✅ GOOD: Customer Module Configuration
class CustomerModuleConfig:
    """Configuration for customer module"""
    
    def __init__(self):
        self.vip_threshold = 1000.0
        self.premium_threshold = 500.0
        self.inactive_threshold_days = 365
        self.max_orders_per_day = 10
        self.auto_suspend_threshold = 5  # failed login attempts
    
    def get_customer_type_thresholds(self) -> Dict[str, float]:
        """Get customer type thresholds"""
        return {
            'VIP': self.vip_threshold,
            'Premium': self.premium_threshold,
            'Standard': 0.0
        }

# ❌ BAD: Anemic Customer Module
class BadCustomerModule:
    """Example of anemic customer module - only data, no behavior"""
    
    def __init__(self):
        self.customers = []
        self.email_service = None
        self.repository = None
    
    def add_customer(self, name: str, email: str):
        # ❌ Business logic scattered, no domain concepts
        customer = {
            'id': str(uuid.uuid4()),
            'name': name,
            'email': email,
            'status': 'Pending'
        }
        self.customers.append(customer)
        return customer

# ❌ BAD: Module with External Dependencies
class BadCustomerModuleWithDependencies:
    """Example of module with external dependencies"""
    
    def __init__(self, database, cache, logger):
        self.database = database  # ❌ External dependency
        self.cache = cache        # ❌ External dependency
        self.logger = logger      # ❌ External dependency
    
    def create_customer(self, data):
        # ❌ Business logic mixed with infrastructure concerns
        self.logger.info("Creating customer")
        result = self.database.insert(data)
        self.cache.set(f"customer:{data['id']}", data)
        return result

# Example usage
if __name__ == "__main__":
    # Create customer module
    customer_module = CustomerModule()
    
    try:
        # Register a new customer
        customer = customer_module.register_customer("John Doe", "john.doe@example.com")
        print(f"Customer registered: {customer}")
        
        # Get customer info
        customer_info = customer_module.get_customer_info(customer.id.value)
        print(f"Customer info: {customer_info}")
        
        # Activate customer
        customer_module.activate_customer(customer.id.value)
        print(f"Customer activated: {customer.is_active()}")
        
        # Update customer email
        customer_service = customer_module._customer_service
        customer_service.update_customer_email(customer.id.value, "john.doe.new@example.com")
        print(f"Email updated: {customer.email}")
        
    except ValueError as e:
        print(f"Error: {e}")
```

## Key Concepts Demonstrated

### Modules and Separation of Concerns

#### 1. **Module Organization**
- ✅ Customer module contains all customer-related domain logic
- ✅ Clear separation of concerns within the module
- ✅ Module has a single responsibility

#### 2. **Domain Layer Structure**
- ✅ Entities, value objects, and services are organized
- ✅ Repository interfaces define data access contracts
- ✅ Domain services handle complex business logic

#### 3. **Dependency Management**
- ✅ Module depends on abstractions, not concrete implementations
- ✅ Dependencies are injected through constructor
- ✅ Easy to test and maintain

#### 4. **Module Interface**
- ✅ Module provides a clean interface to the outside world
- ✅ Complex operations are encapsulated
- ✅ Module hides internal complexity

### Customer Module Design Principles

#### **Single Responsibility**
- ✅ Customer module only handles customer-related operations
- ✅ Each class within the module has a single responsibility
- ✅ Clear separation of concerns

#### **Dependency Inversion**
- ✅ Module depends on abstractions, not concrete implementations
- ✅ Repository and service interfaces define contracts
- ✅ Easy to swap implementations

#### **Domain-Driven Design**
- ✅ Module is organized around domain concepts
- ✅ Business logic is encapsulated in domain objects
- ✅ Domain services handle complex operations

#### **Testability**
- ✅ Module can be easily tested in isolation
- ✅ Dependencies can be mocked
- ✅ Pure domain logic is testable

### Python Benefits for Module Organization
- **Packages**: Clean module organization with `__init__.py`
- **Abstract Base Classes**: Clear interfaces for dependencies
- **Type Hints**: Better IDE support and documentation
- **Dataclasses**: Clean, concise class definitions
- **Properties**: Clean access to encapsulated data
- **Error Handling**: Clear exception messages for business rules

### Common Anti-Patterns to Avoid

#### **Anemic Module**
- ❌ Module contains only data, no behavior
- ❌ Business logic scattered across multiple classes
- ❌ No encapsulation of business rules

#### **Module with External Dependencies**
- ❌ Module depends on external frameworks
- ❌ Business logic mixed with infrastructure concerns
- ❌ Hard to test and maintain

#### **God Module**
- ❌ Single module with too many responsibilities
- ❌ Hard to understand and maintain
- ❌ Violates Single Responsibility Principle

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Basic entity design
- [Order Entity](./03-order-entity.md) - Entity with business logic
- [Pricing Service](./05-pricing-service.md) - Domain service example
- [Modules and Separation of Concerns](../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns) - Module concepts

/*
 * Navigation:
 * Previous: 05-pricing-service.md
 * Next: 07-order-tests.md
 *
 * Back to: [Modules and Separation of Concerns](../../1-introduction-to-the-domain.md#modules-and-separation-of-concerns)
 */
