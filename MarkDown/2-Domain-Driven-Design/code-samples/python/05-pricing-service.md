# Pricing Service - Python Example

**Section**: [Domain Services](../../1-introduction-to-the-domain.md#domain-services)

**Navigation**: [← Previous: EmailAddress Value Object](./04-email-address-value-object.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Pricing Service with Domain Service Design Principles
# File: 2-Domain-Driven-Design/code-samples/python/05-pricing-service.py

from abc import ABC, abstractmethod
from typing import List, Optional, Dict, Any
from dataclasses import dataclass
from datetime import datetime, timedelta
import uuid

# ✅ GOOD: Domain Service for Complex Business Logic
class PricingService:
    """Domain service for complex pricing calculations"""
    
    def __init__(self):
        self._discount_rules = DiscountRuleRepository()
        self._tax_calculator = TaxCalculator()
        self._shipping_calculator = ShippingCalculator()
    
    def calculate_order_total(
        self,
        order: 'Order',
        customer: 'Customer',
        shipping_address: 'Address'
    ) -> 'Money':
        """Calculate total order amount with all applicable charges"""
        if not customer.is_active():
            raise ValueError("Cannot calculate pricing for inactive customer")
        
        # Start with base order amount
        base_amount = order.total_amount
        
        # Apply customer-specific discount
        discounted_amount = self._apply_customer_discount(base_amount, customer)
        
        # Apply bulk discount
        bulk_discounted_amount = self._apply_bulk_discount(discounted_amount, order)
        
        # Calculate tax
        tax_amount = self._tax_calculator.calculate_tax(bulk_discounted_amount, shipping_address)
        
        # Calculate shipping
        shipping_amount = self._shipping_calculator.calculate_shipping(order, shipping_address)
        
        # Apply shipping discount if applicable
        final_shipping = self._apply_shipping_discount(shipping_amount, bulk_discounted_amount)
        
        # Calculate final total
        final_total = bulk_discounted_amount.add(tax_amount).add(final_shipping)
        
        return final_total
    
    def calculate_discount_amount(
        self,
        order: 'Order',
        customer: 'Customer'
    ) -> 'Money':
        """Calculate total discount amount for an order"""
        base_amount = order.total_amount
        discounted_amount = self._apply_customer_discount(base_amount, customer)
        bulk_discounted_amount = self._apply_bulk_discount(discounted_amount, order)
        
        return base_amount.subtract(bulk_discounted_amount)
    
    def get_available_discounts(
        self,
        order: 'Order',
        customer: 'Customer'
    ) -> List['Discount']:
        """Get all available discounts for an order"""
        discounts = []
        
        # Customer type discount
        customer_discount = self._get_customer_type_discount(customer)
        if customer_discount:
            discounts.append(customer_discount)
        
        # Bulk discount
        bulk_discount = self._get_bulk_discount(order)
        if bulk_discount:
            discounts.append(bulk_discount)
        
        # Seasonal discount
        seasonal_discount = self._get_seasonal_discount()
        if seasonal_discount:
            discounts.append(seasonal_discount)
        
        # Product-specific discounts
        product_discounts = self._get_product_discounts(order)
        discounts.extend(product_discounts)
        
        return discounts
    
    def _apply_customer_discount(self, amount: 'Money', customer: 'Customer') -> 'Money':
        """Apply customer-specific discount"""
        discount_rate = self._get_customer_discount_rate(customer.customer_type)
        discount_amount = amount.multiply(discount_rate)
        return amount.subtract(discount_amount)
    
    def _apply_bulk_discount(self, amount: 'Money', order: 'Order') -> 'Money':
        """Apply bulk discount based on order amount"""
        if amount.amount >= 1000:
            discount_rate = 0.10  # 10% for orders over $1000
        elif amount.amount >= 500:
            discount_rate = 0.05   # 5% for orders over $500
        elif amount.amount >= 100:
            discount_rate = 0.02   # 2% for orders over $100
        else:
            discount_rate = 0.0
        
        discount_amount = amount.multiply(discount_rate)
        return amount.subtract(discount_amount)
    
    def _apply_shipping_discount(self, shipping: 'Money', order_amount: 'Money') -> 'Money':
        """Apply shipping discount based on order amount"""
        if order_amount.amount >= 50:
            return Money(0, shipping.currency)  # Free shipping
        elif order_amount.amount >= 25:
            return shipping.multiply(0.5)  # 50% off shipping
        else:
            return shipping
    
    def _get_customer_discount_rate(self, customer_type: str) -> float:
        """Get discount rate based on customer type"""
        discount_rates = {
            'VIP': 0.15,
            'Premium': 0.10,
            'Standard': 0.05,
            'Basic': 0.0
        }
        return discount_rates.get(customer_type, 0.0)
    
    def _get_customer_type_discount(self, customer: 'Customer') -> Optional['Discount']:
        """Get customer type discount"""
        rate = self._get_customer_discount_rate(customer.customer_type)
        if rate > 0:
            return Discount(
                id=str(uuid.uuid4()),
                name=f"{customer.customer_type} Customer Discount",
                type="percentage",
                value=rate,
                description=f"{int(rate * 100)}% discount for {customer.customer_type} customers"
            )
        return None
    
    def _get_bulk_discount(self, order: 'Order') -> Optional['Discount']:
        """Get bulk discount"""
        amount = order.total_amount
        if amount.amount >= 1000:
            return Discount(
                id=str(uuid.uuid4()),
                name="Bulk Discount",
                type="percentage",
                value=0.10,
                description="10% discount for orders over $1000"
            )
        elif amount.amount >= 500:
            return Discount(
                id=str(uuid.uuid4()),
                name="Bulk Discount",
                type="percentage",
                value=0.05,
                description="5% discount for orders over $500"
            )
        return None
    
    def _get_seasonal_discount(self) -> Optional['Discount']:
        """Get seasonal discount"""
        current_month = datetime.now().month
        if current_month in [11, 12]:  # November and December
            return Discount(
                id=str(uuid.uuid4()),
                name="Holiday Discount",
                type="percentage",
                value=0.08,
                description="8% holiday discount"
            )
        return None
    
    def _get_product_discounts(self, order: 'Order') -> List['Discount']:
        """Get product-specific discounts"""
        discounts = []
        for item in order.items:
            if item.product_id.value.startswith('SALE'):
                discounts.append(Discount(
                    id=str(uuid.uuid4()),
                    name="Sale Item Discount",
                    type="percentage",
                    value=0.20,
                    description="20% discount on sale items"
                ))
        return discounts

# ✅ GOOD: Tax Calculator Domain Service
class TaxCalculator:
    """Domain service for tax calculations"""
    
    def calculate_tax(self, amount: 'Money', address: 'Address') -> 'Money':
        """Calculate tax based on shipping address"""
        if address.country == 'US':
            return self._calculate_us_tax(amount, address)
        elif address.country == 'CA':
            return self._calculate_canadian_tax(amount, address)
        else:
            return Money(0, amount.currency)  # No tax for international orders
    
    def _calculate_us_tax(self, amount: 'Money', address: 'Address') -> 'Money':
        """Calculate US tax"""
        if address.state in ['CA', 'NY', 'TX']:
            tax_rate = 0.08  # 8% tax
        else:
            tax_rate = 0.06  # 6% tax
        
        return amount.multiply(tax_rate)
    
    def _calculate_canadian_tax(self, amount: 'Money', address: 'Address') -> 'Money':
        """Calculate Canadian tax"""
        if address.province in ['ON', 'BC', 'AB']:
            tax_rate = 0.13  # 13% HST
        else:
            tax_rate = 0.15  # 15% HST
        
        return amount.multiply(tax_rate)

# ✅ GOOD: Shipping Calculator Domain Service
class ShippingCalculator:
    """Domain service for shipping calculations"""
    
    def calculate_shipping(self, order: 'Order', address: 'Address') -> 'Money':
        """Calculate shipping cost"""
        base_shipping = self._get_base_shipping_rate(address)
        
        # Add weight-based charges
        weight_charge = self._calculate_weight_charge(order)
        
        # Add distance-based charges
        distance_charge = self._calculate_distance_charge(address)
        
        # Add handling fee
        handling_fee = Money(2.99, base_shipping.currency)
        
        total_shipping = base_shipping.add(weight_charge).add(distance_charge).add(handling_fee)
        
        return total_shipping
    
    def _get_base_shipping_rate(self, address: 'Address') -> 'Money':
        """Get base shipping rate"""
        if address.country == 'US':
            return Money(5.99, 'USD')
        elif address.country == 'CA':
            return Money(8.99, 'USD')
        else:
            return Money(15.99, 'USD')
    
    def _calculate_weight_charge(self, order: 'Order') -> 'Money':
        """Calculate weight-based shipping charge"""
        total_weight = sum(item.quantity * 0.5 for item in order.items)  # Simplified
        
        if total_weight > 20:
            return Money(10.00, 'USD')
        elif total_weight > 10:
            return Money(5.00, 'USD')
        else:
            return Money(0, 'USD')
    
    def _calculate_distance_charge(self, address: 'Address') -> 'Money':
        """Calculate distance-based shipping charge"""
        if address.country == 'US':
            if address.state in ['AK', 'HI']:
                return Money(15.00, 'USD')
            else:
                return Money(0, 'USD')
        else:
            return Money(0, 'USD')

# ✅ GOOD: Discount Rule Repository
class DiscountRuleRepository:
    """Repository for discount rules"""
    
    def __init__(self):
        self._rules = {
            'customer_type': {
                'VIP': 0.15,
                'Premium': 0.10,
                'Standard': 0.05
            },
            'bulk': {
                1000: 0.10,
                500: 0.05,
                100: 0.02
            },
            'seasonal': {
                'holiday': 0.08,
                'summer': 0.05
            }
        }
    
    def get_customer_discount_rate(self, customer_type: str) -> float:
        """Get customer discount rate"""
        return self._rules['customer_type'].get(customer_type, 0.0)
    
    def get_bulk_discount_rate(self, amount: float) -> float:
        """Get bulk discount rate"""
        for threshold, rate in sorted(self._rules['bulk'].items(), reverse=True):
            if amount >= threshold:
                return rate
        return 0.0

# ✅ GOOD: Discount Value Object
@dataclass(frozen=True)
class Discount:
    """Value object representing a discount"""
    id: str
    name: str
    type: str  # 'percentage' or 'fixed'
    value: float
    description: str
    
    def apply_to(self, amount: 'Money') -> 'Money':
        """Apply discount to an amount"""
        if self.type == 'percentage':
            discount_amount = amount.multiply(self.value)
        else:  # fixed
            discount_amount = Money(self.value, amount.currency)
        
        return amount.subtract(discount_amount)

# ✅ GOOD: Pricing Strategy Interface
class PricingStrategy(ABC):
    """Abstract base class for pricing strategies"""
    
    @abstractmethod
    def calculate_price(self, base_price: 'Money', context: Dict[str, Any]) -> 'Money':
        """Calculate price using this strategy"""
        pass

# ✅ GOOD: Customer Type Pricing Strategy
class CustomerTypePricingStrategy(PricingStrategy):
    """Pricing strategy based on customer type"""
    
    def calculate_price(self, base_price: 'Money', context: Dict[str, Any]) -> 'Money':
        customer_type = context.get('customer_type', 'Basic')
        discount_rate = self._get_discount_rate(customer_type)
        discount_amount = base_price.multiply(discount_rate)
        return base_price.subtract(discount_amount)
    
    def _get_discount_rate(self, customer_type: str) -> float:
        rates = {
            'VIP': 0.15,
            'Premium': 0.10,
            'Standard': 0.05,
            'Basic': 0.0
        }
        return rates.get(customer_type, 0.0)

# ✅ GOOD: Bulk Pricing Strategy
class BulkPricingStrategy(PricingStrategy):
    """Pricing strategy based on order amount"""
    
    def calculate_price(self, base_price: 'Money', context: Dict[str, Any]) -> 'Money':
        order_amount = context.get('order_amount', 0.0)
        discount_rate = self._get_discount_rate(order_amount)
        discount_amount = base_price.multiply(discount_rate)
        return base_price.subtract(discount_amount)
    
    def _get_discount_rate(self, order_amount: float) -> float:
        if order_amount >= 1000:
            return 0.10
        elif order_amount >= 500:
            return 0.05
        elif order_amount >= 100:
            return 0.02
        else:
            return 0.0

# ✅ GOOD: Composite Pricing Strategy
class CompositePricingStrategy(PricingStrategy):
    """Composite pricing strategy that combines multiple strategies"""
    
    def __init__(self, strategies: List[PricingStrategy]):
        self._strategies = strategies
    
    def calculate_price(self, base_price: 'Money', context: Dict[str, Any]) -> 'Money':
        current_price = base_price
        for strategy in self._strategies:
            current_price = strategy.calculate_price(current_price, context)
        return current_price

# ❌ BAD: Anemic Domain Service
class BadPricingService:
    """Example of anemic domain service - only data, no behavior"""
    
    def __init__(self):
        self.discount_rate = 0.1
        self.tax_rate = 0.08
        self.shipping_rate = 5.99
    
    def calculate_total(self, order_amount: float) -> float:
        # ❌ Business logic scattered, no domain concepts
        discount = order_amount * self.discount_rate
        subtotal = order_amount - discount
        tax = subtotal * self.tax_rate
        total = subtotal + tax + self.shipping_rate
        return total

# ❌ BAD: Service with External Dependencies
class BadPricingServiceWithDependencies:
    """Example of service with external dependencies"""
    
    def __init__(self, database, cache, logger):
        self.database = database  # ❌ External dependency
        self.cache = cache        # ❌ External dependency
        self.logger = logger      # ❌ External dependency
    
    def calculate_price(self, order):
        # ❌ Business logic mixed with infrastructure concerns
        self.logger.info("Calculating price")
        data = self.database.get_pricing_data()
        cached_data = self.cache.get("pricing")
        # ... business logic mixed with infrastructure

# Example usage
if __name__ == "__main__":
    # Create pricing service
    pricing_service = PricingService()
    
    # Create mock objects for demonstration
    class MockOrder:
        def __init__(self, total_amount):
            self.total_amount = total_amount
            self.items = []
    
    class MockCustomer:
        def __init__(self, customer_type, is_active=True):
            self.customer_type = customer_type
            self._is_active = is_active
        
        def is_active(self):
            return self._is_active
    
    class MockAddress:
        def __init__(self, country, state=None, province=None):
            self.country = country
            self.state = state
            self.province = province
    
    # Test pricing calculations
    order = MockOrder(Money(500, 'USD'))
    customer = MockCustomer('Premium')
    address = MockAddress('US', 'CA')
    
    try:
        total = pricing_service.calculate_order_total(order, customer, address)
        print(f"Order total: {total}")
        
        discounts = pricing_service.get_available_discounts(order, customer)
        print(f"Available discounts: {len(discounts)}")
        for discount in discounts:
            print(f"  - {discount.name}: {discount.description}")
        
    except ValueError as e:
        print(f"Error: {e}")
```

## Key Concepts Demonstrated

### Domain Services

#### 1. **Stateless Services**
- ✅ Domain services are stateless and stateless
- ✅ No instance variables that change state
- ✅ Pure functions for calculations

#### 2. **Complex Business Logic**
- ✅ Domain services handle complex business logic
- ✅ Business logic that doesn't belong to a single entity
- ✅ Calculations that involve multiple domain objects

#### 3. **Domain Service Design Principles**
- ✅ Domain services are part of the domain layer
- ✅ They don't depend on external frameworks
- ✅ They express business operations clearly

#### 4. **Service Composition**
- ✅ Domain services can be composed together
- ✅ Each service has a single responsibility
- ✅ Services can be easily tested in isolation

### Pricing Service Design Principles

#### **Single Responsibility**
- ✅ Pricing service only handles pricing calculations
- ✅ Tax calculation is handled by TaxCalculator
- ✅ Shipping calculation is handled by ShippingCalculator

#### **Domain Service Design**
- ✅ Service is stateless and stateless
- ✅ No external dependencies
- ✅ Pure functions for calculations

#### **Business Logic Encapsulation**
- ✅ Complex pricing rules are encapsulated
- ✅ Business rules are expressed clearly
- ✅ Service methods express business operations

#### **Testability**
- ✅ Service can be easily tested in isolation
- ✅ No external dependencies to mock
- ✅ Pure functions are predictable

### Python Benefits for Domain Services
- **Type Hints**: Better IDE support and documentation
- **Abstract Base Classes**: Clear interfaces for strategies
- **Dataclasses**: Clean, concise class definitions
- **Method Chaining**: Fluent interfaces for operations
- **Error Handling**: Clear exception messages for business rules
- **Composition**: Easy to compose services together

### Common Anti-Patterns to Avoid

#### **Anemic Domain Service**
- ❌ Service contains only data, no behavior
- ❌ Business logic scattered across multiple classes
- ❌ No encapsulation of business rules

#### **Service with External Dependencies**
- ❌ Domain service depends on external frameworks
- ❌ Business logic mixed with infrastructure concerns
- ❌ Hard to test and maintain

#### **God Service**
- ❌ Single service with too many responsibilities
- ❌ Hard to understand and maintain
- ❌ Violates Single Responsibility Principle

## Related Concepts

- [Order Entity](./03-order-entity.md) - Entity used by Pricing Service
- [Customer Entity](./01-customer-entity.md) - Entity used by Pricing Service
- [Money Value Object](./02-money-value-object.md) - Value object used by Pricing Service
- [Domain Services](../../1-introduction-to-the-domain.md#domain-services) - Domain service concepts

/*
 * Navigation:
 * Previous: 04-email-address-value-object.md
 * Next: 06-customer-module.md
 *
 * Back to: [Domain Services](../../1-introduction-to-the-domain.md#domain-services)
 */
