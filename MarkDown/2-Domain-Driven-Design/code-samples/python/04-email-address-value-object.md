# EmailAddress Value Object - Python Example

**Section**: [Self-Validation](../../1-introduction-to-the-domain.md#self-validation)

**Navigation**: [← Previous: Order Entity](./03-order-entity.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - EmailAddress Value Object with Self-Validation
# File: 2-Domain-Driven-Design/code-samples/python/04-email-address-value-object.py

import re
from typing import Optional
from dataclasses import dataclass
import hashlib

# ✅ GOOD: Self-Validating Value Object
@dataclass(frozen=True)
class EmailAddress:
    """Value object representing an email address with validation"""
    
    _value: str
    
    def __post_init__(self):
        """Validate email address during construction"""
        if not self._value or not self._value.strip():
            raise ValueError("Email address cannot be empty")
        
        trimmed_email = self._value.strip().lower()
        
        if not self._is_valid_email(trimmed_email):
            raise ValueError(f"Invalid email address format: {self._value}")
        
        # Update the frozen dataclass field
        object.__setattr__(self, '_value', trimmed_email)
    
    @property
    def value(self) -> str:
        """Get the email address value"""
        return self._value
    
    @property
    def domain(self) -> str:
        """Extract the domain part of the email"""
        return self._value.split('@')[1]
    
    @property
    def local_part(self) -> str:
        """Extract the local part of the email"""
        return self._value.split('@')[0]
    
    @property
    def is_gmail(self) -> bool:
        """Check if this is a Gmail address"""
        return self.domain == 'gmail.com'
    
    @property
    def is_corporate(self) -> bool:
        """Check if this is a corporate email address"""
        corporate_domains = ['company.com', 'corp.com', 'business.org']
        return self.domain in corporate_domains
    
    @property
    def is_disposable(self) -> bool:
        """Check if this is a disposable email address"""
        disposable_domains = [
            '10minutemail.com', 'tempmail.org', 'guerrillamail.com',
            'mailinator.com', 'throwaway.email'
        ]
        return self.domain in disposable_domains
    
    def normalize(self) -> 'EmailAddress':
        """Return normalized version of email address"""
        # Gmail addresses can be normalized by removing dots and plus aliases
        if self.is_gmail:
            local = self.local_part.replace('.', '')
            if '+' in local:
                local = local.split('+')[0]
            normalized_value = f"{local}@{self.domain}"
            return EmailAddress(normalized_value)
        
        return self
    
    def get_hash(self) -> str:
        """Get a hash of the email address for privacy"""
        return hashlib.sha256(self._value.encode()).hexdigest()[:16]
    
    def mask(self) -> str:
        """Return a masked version of the email for display"""
        local_part = self.local_part
        domain = self.domain
        
        if len(local_part) <= 2:
            masked_local = '*' * len(local_part)
        else:
            masked_local = local_part[0] + '*' * (len(local_part) - 2) + local_part[-1]
        
        return f"{masked_local}@{domain}"
    
    def __str__(self) -> str:
        return self._value
    
    def __repr__(self) -> str:
        return f"EmailAddress('{self._value}')"
    
    def __eq__(self, other) -> bool:
        if not isinstance(other, EmailAddress):
            return False
        return self._value == other._value
    
    def __hash__(self) -> int:
        return hash(self._value)
    
    @staticmethod
    def _is_valid_email(email: str) -> bool:
        """Validate email address format using regex"""
        # RFC 5322 compliant regex (simplified)
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return re.match(pattern, email) is not None
    
    @classmethod
    def create(cls, email: str) -> 'EmailAddress':
        """Factory method for creating email addresses"""
        return cls(email)
    
    @classmethod
    def create_gmail(cls, local_part: str) -> 'EmailAddress':
        """Create a Gmail address"""
        return cls(f"{local_part}@gmail.com")
    
    @classmethod
    def create_corporate(cls, local_part: str, domain: str) -> 'EmailAddress':
        """Create a corporate email address"""
        return cls(f"{local_part}@{domain}")

# ✅ GOOD: Email Validation Service
class EmailValidationService:
    """Domain service for complex email validation"""
    
    def __init__(self):
        self._blacklisted_domains = {
            'spam.com', 'fake-email.com', 'invalid.org'
        }
        self._corporate_domains = {
            'company.com', 'corp.com', 'business.org'
        }
    
    def is_valid_for_registration(self, email: EmailAddress) -> bool:
        """Check if email is valid for user registration"""
        if email.is_disposable:
            return False
        
        if email.domain in self._blacklisted_domains:
            return False
        
        return True
    
    def is_corporate_email(self, email: EmailAddress) -> bool:
        """Check if email is from a corporate domain"""
        return email.domain in self._corporate_domains
    
    def get_email_category(self, email: EmailAddress) -> str:
        """Categorize email address"""
        if email.is_gmail:
            return "personal"
        elif email.is_corporate:
            return "corporate"
        elif email.is_disposable:
            return "disposable"
        else:
            return "other"

# ✅ GOOD: Email Address Specification
class EmailSpecification:
    """Specification for email-related business rules"""
    
    def is_valid_for_customer_registration(self, email: EmailAddress) -> bool:
        """Check if email meets customer registration requirements"""
        return (not email.is_disposable and
                not email.is_gmail or email.local_part.count('.') <= 2)
    
    def is_valid_for_business_account(self, email: EmailAddress) -> bool:
        """Check if email is valid for business account"""
        return (not email.is_disposable and
                not email.is_gmail and
                email.domain not in ['yahoo.com', 'hotmail.com', 'outlook.com'])
    
    def requires_verification(self, email: EmailAddress) -> bool:
        """Check if email requires verification"""
        return (email.is_gmail or
                email.is_corporate or
                email.domain in ['yahoo.com', 'hotmail.com', 'outlook.com'])

# ✅ GOOD: Email Address Factory
class EmailAddressFactory:
    """Factory for creating email addresses with different strategies"""
    
    @staticmethod
    def create_personal_email(local_part: str, domain: str) -> EmailAddress:
        """Create a personal email address"""
        return EmailAddress(f"{local_part}@{domain}")
    
    @staticmethod
    def create_business_email(first_name: str, last_name: str, company_domain: str) -> EmailAddress:
        """Create a business email address"""
        local_part = f"{first_name.lower()}.{last_name.lower()}"
        return EmailAddress(f"{local_part}@{company_domain}")
    
    @staticmethod
    def create_support_email(company_domain: str) -> EmailAddress:
        """Create a support email address"""
        return EmailAddress(f"support@{company_domain}")
    
    @staticmethod
    def create_noreply_email(company_domain: str) -> EmailAddress:
        """Create a no-reply email address"""
        return EmailAddress(f"noreply@{company_domain}")

# ✅ GOOD: Email Address Repository Interface
class EmailAddressRepository:
    """Repository interface for email address operations"""
    
    def exists(self, email: EmailAddress) -> bool:
        """Check if email address already exists"""
        raise NotImplementedError
    
    def is_verified(self, email: EmailAddress) -> bool:
        """Check if email address is verified"""
        raise NotImplementedError
    
    def mark_as_verified(self, email: EmailAddress) -> None:
        """Mark email address as verified"""
        raise NotImplementedError

# ✅ GOOD: Email Address Service
class EmailAddressService:
    """Domain service for email address operations"""
    
    def __init__(self, repository: EmailAddressRepository):
        self._repository = repository
        self._validation_service = EmailValidationService()
    
    def register_email(self, email: EmailAddress) -> bool:
        """Register a new email address"""
        if not self._validation_service.is_valid_for_registration(email):
            raise ValueError("Email address is not valid for registration")
        
        if self._repository.exists(email):
            raise ValueError("Email address already exists")
        
        # Email is valid and unique
        return True
    
    def verify_email(self, email: EmailAddress) -> None:
        """Verify an email address"""
        if not self._repository.exists(email):
            raise ValueError("Email address not found")
        
        self._repository.mark_as_verified(email)
    
    def get_email_info(self, email: EmailAddress) -> dict:
        """Get information about an email address"""
        return {
            'email': email.value,
            'domain': email.domain,
            'local_part': email.local_part,
            'is_gmail': email.is_gmail,
            'is_corporate': email.is_corporate,
            'is_disposable': email.is_disposable,
            'category': self._validation_service.get_email_category(email),
            'masked': email.mask(),
            'hash': email.get_hash()
        }

# ❌ BAD: Primitive Obsession
class BadCustomer:
    """Example of primitive obsession - using string instead of EmailAddress"""
    
    def __init__(self, name: str, email: str):
        self.name = name
        self.email = email  # ❌ Using primitive string
    
    def send_email(self, subject: str, body: str):
        # ❌ No validation, no type safety
        if '@' not in self.email:
            raise ValueError("Invalid email")
        # ... rest of logic

# ❌ BAD: Validation Scattered
class BadEmailValidator:
    """Example of scattered validation logic"""
    
    def validate_email(self, email: str) -> bool:
        # ❌ Validation logic scattered across multiple classes
        if not email:
            return False
        
        if '@' not in email:
            return False
        
        # More validation logic scattered elsewhere
        return True

# Example usage
if __name__ == "__main__":
    # Create email addresses
    try:
        email1 = EmailAddress("john.doe@company.com")
        email2 = EmailAddress("jane.smith@gmail.com")
        email3 = EmailAddress("support@business.org")
        
        print(f"Email 1: {email1}")
        print(f"Domain: {email1.domain}")
        print(f"Is corporate: {email1.is_corporate}")
        print(f"Masked: {email1.mask()}")
        
        print(f"\nEmail 2: {email2}")
        print(f"Is Gmail: {email2.is_gmail}")
        print(f"Normalized: {email2.normalize()}")
        
        print(f"\nEmail 3: {email3}")
        print(f"Is corporate: {email3.is_corporate}")
        
        # Test validation
        try:
            bad_email = EmailAddress("invalid-email")
        except ValueError as e:
            print(f"\nValidation error: {e}")
        
        # Test equality
        email4 = EmailAddress("john.doe@company.com")
        print(f"\nEmail1 == Email4: {email1 == email4}")
        
        # Test factory methods
        gmail = EmailAddress.create_gmail("test.user")
        print(f"\nGmail created: {gmail}")
        
        corporate = EmailAddress.create_corporate("admin", "company.com")
        print(f"Corporate created: {corporate}")
        
    except ValueError as e:
        print(f"Error: {e}")
```

## Key Concepts Demonstrated

### Self-Validation

#### 1. **Validation at Construction**
- ✅ Email address is validated when created
- ✅ Invalid email addresses cannot be created
- ✅ Validation happens at the domain boundary

#### 2. **Rich Value Object Behavior**
- ✅ Email address has useful methods and properties
- ✅ Business logic is encapsulated in the value object
- ✅ Methods express business operations clearly

#### 3. **Immutability**
- ✅ Email address cannot be modified after creation
- ✅ All operations return new instances
- ✅ Thread-safe and predictable behavior

#### 4. **Value-Based Equality**
- ✅ Two email addresses are equal if they have the same value
- ✅ Hash code is based on the value
- ✅ Can be used as dictionary keys

### EmailAddress Value Object Design Principles

#### **Self-Validation**
- ✅ Email address validates itself during construction
- ✅ Invalid email addresses cannot be created
- ✅ Clear error messages for validation failures

#### **Rich Behavior**
- ✅ Email address has useful methods and properties
- ✅ Business logic is encapsulated in the value object
- ✅ Methods express business operations clearly

#### **Immutability**
- ✅ Email address cannot be modified after creation
- ✅ All operations return new instances
- ✅ Thread-safe and predictable behavior

#### **Value-Based Equality**
- ✅ Two email addresses are equal if they have the same value
- ✅ Hash code is based on the value
- ✅ Can be used as dictionary keys

### Python Benefits for Value Objects
- **Dataclasses**: Clean, concise class definitions with `@dataclass`
- **Frozen Dataclasses**: Immutable objects with `frozen=True`
- **Type Hints**: Better IDE support and documentation
- **Properties**: Clean access to encapsulated data
- **Method Chaining**: Fluent interfaces for operations
- **Error Handling**: Clear exception messages for validation

### Common Anti-Patterns to Avoid

#### **Primitive Obsession**
- ❌ Using primitives instead of domain types
- ❌ No type safety for business concepts
- ❌ Scattered validation logic

#### **Validation Scattered**
- ❌ Validation logic spread across multiple classes
- ❌ Inconsistent validation rules
- ❌ Hard to maintain and test

#### **Mutable Value Objects**
- ❌ Value objects that can be modified
- ❌ Unpredictable behavior
- ❌ Thread safety issues

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Entity using EmailAddress
- [Order Entity](./03-order-entity.md) - Entity with business logic
- [Money Value Object](./02-money-value-object.md) - Another value object example
- [Self-Validation](../../1-introduction-to-the-domain.md#self-validation) - Self-validation concepts

/*
 * Navigation:
 * Previous: 03-order-entity.md
 * Next: 05-pricing-service.md
 *
 * Back to: [Self-Validation](../../1-introduction-to-the-domain.md#self-validation)
 */
