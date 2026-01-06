# Domain Modeling Best Practices - Python Example

**Section**: [Best Practices for Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling)

**Navigation**: [← Previous: Testing Best Practices](./12-testing-best-practices.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Domain Modeling Best Practices
# File: 2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices.py

from abc import ABC, abstractmethod
from typing import List, Optional, Dict, Any, Protocol
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
import uuid
import hashlib

# ✅ GOOD: Pure Domain Logic
@dataclass(frozen=True)
class OrderId:
    """Value object for Order identity"""
    value: str
    
    @classmethod
    def generate(cls) -> 'OrderId':
        return cls(str(uuid.uuid4()))
    
    def __str__(self) -> str:
        return self.value

@dataclass(frozen=True)
class CustomerId:
    """Value object for Customer identity"""
    value: str
    
    def __str__(self) -> str:
        return self.value

@dataclass(frozen=True)
class ProductId:
    """Value object for Product identity"""
    value: str
    
    def __str__(self) -> str:
        return self.value

@dataclass(frozen=True)
class Money:
    """Value object for monetary amounts"""
    amount: float
    currency: str
    
    def __post_init__(self):
        if self.amount < 0:
            raise ValueError("Amount cannot be negative")
        if not self.currency or not self.currency.strip():
            raise ValueError("Currency cannot be empty")
    
    def add(self, other: 'Money') -> 'Money':
        if self.currency != other.currency:
            raise ValueError("Cannot add different currencies")
        return Money(self.amount + other.amount, self.currency)
    
    def subtract(self, other: 'Money') -> 'Money':
        if self.currency != other.currency:
            raise ValueError("Cannot subtract different currencies")
        return Money(self.amount - other.amount, self.currency)
    
    def multiply(self, factor: float) -> 'Money':
        if factor < 0:
            raise ValueError("Factor cannot be negative")
        return Money(self.amount * factor, self.currency)
    
    def equals(self, other: 'Money') -> bool:
        return self.amount == other.amount and self.currency == other.currency
    
    @classmethod
    def zero(cls, currency: str) -> 'Money':
        return cls(0, currency)
    
    @classmethod
    def from_amount(cls, amount: float, currency: str) -> 'Money':
        return cls(amount, currency)
    
    def __str__(self) -> str:
        return f"{self.currency} {self.amount:.2f}"

class OrderStatus(Enum):
    DRAFT = "Draft"
    CONFIRMED = "Confirmed"
    SHIPPED = "Shipped"
    DELIVERED = "Delivered"
    CANCELLED = "Cancelled"

@dataclass(frozen=True)
class OrderItem:
    """Value object representing an order item"""
    product_id: ProductId
    quantity: int
    unit_price: Money
    
    def __post_init__(self):
        if self.quantity <= 0:
            raise ValueError("Quantity must be positive")
    
    @property
    def total_price(self) -> Money:
        return self.unit_price.multiply(self.quantity)

class Order:
    """Domain Entity representing an Order with rich behavior"""
    
    def __init__(
        self,
        order_id: OrderId,
        customer_id: CustomerId,
        created_at: Optional[datetime] = None
    ):
        self._id = order_id
        self._customer_id = customer_id
        self._created_at = created_at or datetime.utcnow()
        self._items: List[OrderItem] = []
        self._status = OrderStatus.DRAFT
        self._confirmed_at: Optional[datetime] = None
        self._shipped_at: Optional[datetime] = None
    
    # ✅ Identity properties
    @property
    def id(self) -> OrderId:
        return self._id
    
    @property
    def customer_id(self) -> CustomerId:
        return self._customer_id
    
    @property
    def created_at(self) -> datetime:
        return self._created_at
    
    @property
    def status(self) -> OrderStatus:
        return self._status
    
    @property
    def items(self) -> List[OrderItem]:
        return self._items.copy()  # Return copy to maintain encapsulation
    
    @property
    def item_count(self) -> int:
        return len(self._items)
    
    @property
    def total_amount(self) -> Money:
        """Calculate total amount for all items"""
        if not self._items:
            return Money.zero("USD")
        
        total = self._items[0].total_price
        for item in self._items[1:]:
            total = total.add(item.total_price)
        return total
    
    # ✅ Business Logic Encapsulation
    def add_item(self, product_id: ProductId, quantity: int, unit_price: Money) -> None:
        """Add an item to the order with business rule validation"""
        if self._status != OrderStatus.DRAFT:
            raise ValueError("Cannot modify confirmed order")
        
        if quantity <= 0:
            raise ValueError("Quantity must be positive")
        
        # Business rule: Check if item already exists
        existing_item_index = self._find_item_index(product_id)
        
        if existing_item_index >= 0:
            # Update existing item quantity
            existing_item = self._items[existing_item_index]
            new_quantity = existing_item.quantity + quantity
            updated_item = OrderItem(product_id, new_quantity, unit_price)
            self._items[existing_item_index] = updated_item
        else:
            # Add new item
            new_item = OrderItem(product_id, quantity, unit_price)
            self._items.append(new_item)
    
    def confirm(self) -> None:
        """Confirm the order with business rule validation"""
        if self._status != OrderStatus.DRAFT:
            raise ValueError("Order is not in draft status")
        
        if not self._items:
            raise ValueError("Cannot confirm empty order")
        
        # Business rule: Minimum order amount
        if self.total_amount.amount < 10.0:
            raise ValueError("Order amount must be at least $10.00")
        
        self._status = OrderStatus.CONFIRMED
        self._confirmed_at = datetime.utcnow()
    
    # ✅ Business Rules as Methods
    def can_be_modified(self) -> bool:
        """Check if order can be modified"""
        return self._status == OrderStatus.DRAFT
    
    def can_be_confirmed(self) -> bool:
        """Check if order can be confirmed"""
        return (self._status == OrderStatus.DRAFT and 
                len(self._items) > 0 and 
                self.total_amount.amount >= 10.0)
    
    def can_be_shipped(self) -> bool:
        """Check if order can be shipped"""
        return self._status == OrderStatus.CONFIRMED
    
    def can_be_delivered(self) -> bool:
        """Check if order can be delivered"""
        return self._status == OrderStatus.SHIPPED
    
    def can_be_cancelled(self) -> bool:
        """Check if order can be cancelled"""
        return self._status in [OrderStatus.DRAFT, OrderStatus.CONFIRMED]
    
    # ✅ Helper methods
    def _find_item_index(self, product_id: ProductId) -> int:
        """Find the index of an item by product ID"""
        for i, item in enumerate(self._items):
            if item.product_id == product_id:
                return i
        return -1
    
    def get_item_by_product_id(self, product_id: ProductId) -> Optional[OrderItem]:
        """Get an item by product ID"""
        item_index = self._find_item_index(product_id)
        return self._items[item_index] if item_index >= 0 else None
    
    def has_item(self, product_id: ProductId) -> bool:
        """Check if order contains an item with the given product ID"""
        return self._find_item_index(product_id) >= 0
    
    # ✅ Domain Events (simplified)
    def get_domain_events(self) -> List[str]:
        """Get domain events that occurred on this aggregate"""
        events = []
        if self._status == OrderStatus.CONFIRMED:
            events.append("OrderConfirmed")
        if self._status == OrderStatus.SHIPPED:
            events.append("OrderShipped")
        if self._status == OrderStatus.DELIVERED:
            events.append("OrderDelivered")
        if self._status == OrderStatus.CANCELLED:
            events.append("OrderCancelled")
        return events
    
    def __str__(self) -> str:
        return (f"Order(id={self._id}, customer_id={self._customer_id}, "
                f"status={self._status.value}, items={len(self._items)}, "
                f"total={self.total_amount})")

# ✅ GOOD: Rich Domain Models with Behavior
class CustomerStatus(Enum):
    PENDING = "Pending"
    ACTIVE = "Active"
    SUSPENDED = "Suspended"
    INACTIVE = "Inactive"

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
        self._total_spent = Money.zero('USD')
    
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

# ✅ GOOD: Validation at Domain Boundaries
@dataclass(frozen=True)
class Address:
    """Value object for address"""
    street: str
    city: str
    state: str
    country: str
    postal_code: str
    
    def __post_init__(self):
        if not self.street or not self.street.strip():
            raise ValueError("Street cannot be empty")
        if not self.city or not self.city.strip():
            raise ValueError("City cannot be empty")
        if not self.country or not self.country.strip():
            raise ValueError("Country cannot be empty")
    
    def __str__(self) -> str:
        return f"{self.street}, {self.city}, {self.state} {self.postal_code}, {self.country}"

# ✅ GOOD: Domain Service for Complex Business Logic
class PricingService:
    """Domain service for complex pricing calculations"""
    
    def __init__(self):
        self._discount_rules = DiscountRuleRepository()
        self._tax_calculator = TaxCalculator()
        self._shipping_calculator = ShippingCalculator()
    
    def calculate_order_total(
        self,
        order: Order,
        customer: Customer,
        shipping_address: Address
    ) -> Money:
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
    
    def _apply_customer_discount(self, amount: Money, customer: Customer) -> Money:
        """Apply customer-specific discount"""
        discount_rate = self._get_customer_discount_rate(customer.get_customer_type())
        discount_amount = amount.multiply(discount_rate)
        return amount.subtract(discount_amount)
    
    def _apply_bulk_discount(self, amount: Money, order: Order) -> Money:
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
    
    def _apply_shipping_discount(self, shipping: Money, order_amount: Money) -> Money:
        """Apply shipping discount based on order amount"""
        if order_amount.amount >= 50:
            return Money.zero(shipping.currency)  # Free shipping
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

# ✅ GOOD: Domain Service Interfaces
class TaxCalculator:
    """Domain service for tax calculations"""
    
    def calculate_tax(self, amount: Money, address: Address) -> Money:
        """Calculate tax based on shipping address"""
        if address.country == 'US':
            return self._calculate_us_tax(amount, address)
        elif address.country == 'CA':
            return self._calculate_canadian_tax(amount, address)
        else:
            return Money.zero(amount.currency)  # No tax for international orders
    
    def _calculate_us_tax(self, amount: Money, address: Address) -> Money:
        """Calculate US tax"""
        if address.state in ['CA', 'NY', 'TX']:
            tax_rate = 0.08  # 8% tax
        else:
            tax_rate = 0.06  # 6% tax
        
        return amount.multiply(tax_rate)
    
    def _calculate_canadian_tax(self, amount: Money, address: Address) -> Money:
        """Calculate Canadian tax"""
        if address.state in ['ON', 'BC', 'AB']:
            tax_rate = 0.13  # 13% HST
        else:
            tax_rate = 0.15  # 15% HST
        
        return amount.multiply(tax_rate)

class ShippingCalculator:
    """Domain service for shipping calculations"""
    
    def calculate_shipping(self, order: Order, address: Address) -> Money:
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
    
    def _get_base_shipping_rate(self, address: Address) -> Money:
        """Get base shipping rate"""
        if address.country == 'US':
            return Money(5.99, 'USD')
        elif address.country == 'CA':
            return Money(8.99, 'USD')
        else:
            return Money(15.99, 'USD')
    
    def _calculate_weight_charge(self, order: Order) -> Money:
        """Calculate weight-based shipping charge"""
        total_weight = sum(item.quantity * 0.5 for item in order.items)  # Simplified
        
        if total_weight > 20:
            return Money(10.00, 'USD')
        elif total_weight > 10:
            return Money(5.00, 'USD')
        else:
            return Money.zero('USD')
    
    def _calculate_distance_charge(self, address: Address) -> Money:
        """Calculate distance-based shipping charge"""
        if address.country == 'US':
            if address.state in ['AK', 'HI']:
                return Money(15.00, 'USD')
            else:
                return Money.zero('USD')
        else:
            return Money.zero('USD')

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

# ✅ GOOD: Domain Events for Significant Changes
@dataclass(frozen=True)
class OrderConfirmedEvent:
    """Domain event for order confirmation"""
    order_id: OrderId
    customer_id: CustomerId
    total_amount: Money
    occurred_at: datetime = field(default_factory=datetime.utcnow)

@dataclass(frozen=True)
class OrderShippedEvent:
    """Domain event for order shipping"""
    order_id: OrderId
    customer_id: CustomerId
    shipping_address: Address
    occurred_at: datetime = field(default_factory=datetime.utcnow)

class DomainEvents:
    """Domain events manager"""
    
    _events: List[Any] = []
    
    @classmethod
    def raise(cls, event: Any) -> None:
        """Raise a domain event"""
        cls._events.append(event)
    
    @classmethod
    def get_events(cls) -> List[Any]:
        """Get all domain events"""
        return cls._events.copy()
    
    @classmethod
    def clear_events(cls) -> None:
        """Clear all domain events"""
        cls._events.clear()

# ✅ GOOD: Aggregate Root Pattern
class OrderAggregate:
    """Aggregate root for order management"""
    
    def __init__(self, order: Order):
        self._order = order
        self._events: List[Any] = []
    
    @property
    def order(self) -> Order:
        return self._order
    
    def add_item(self, product_id: ProductId, quantity: int, unit_price: Money) -> None:
        """Add item to order with business rule validation"""
        if not self._order.can_be_modified():
            raise ValueError("Cannot modify confirmed order")
        
        self._order.add_item(product_id, quantity, unit_price)
        
        # Raise domain event
        self._events.append(f"ItemAdded: {product_id.value}, quantity: {quantity}")
    
    def confirm(self) -> None:
        """Confirm order with business rule validation"""
        if not self._order.can_be_confirmed():
            raise ValueError("Order cannot be confirmed")
        
        self._order.confirm()
        
        # Raise domain event
        event = OrderConfirmedEvent(
            self._order.id,
            self._order.customer_id,
            self._order.total_amount
        )
        self._events.append(event)
    
    def ship(self, shipping_address: Address) -> None:
        """Ship order with business rule validation"""
        if not self._order.can_be_shipped():
            raise ValueError("Order cannot be shipped")
        
        self._order._status = OrderStatus.SHIPPED
        self._order._shipped_at = datetime.utcnow()
        
        # Raise domain event
        event = OrderShippedEvent(
            self._order.id,
            self._order.customer_id,
            shipping_address
        )
        self._events.append(event)
    
    def get_uncommitted_events(self) -> List[Any]:
        """Get uncommitted domain events"""
        return self._events.copy()
    
    def mark_events_as_committed(self) -> None:
        """Mark events as committed"""
        self._events.clear()

# ✅ GOOD: Specification Pattern for Complex Business Rules
class OrderSpecification:
    """Specification for complex business rules"""
    
    def can_be_confirmed(self, order: Order) -> bool:
        """Check if order meets all confirmation criteria"""
        return (order.status == OrderStatus.DRAFT and
                len(order.items) > 0 and
                order.total_amount.amount >= 10.0 and
                self._has_valid_items(order))
    
    def can_be_shipped(self, order: Order) -> bool:
        """Check if order can be shipped"""
        return (order.status == OrderStatus.CONFIRMED and
                self._has_shipping_address(order) and
                self._all_items_in_stock(order))
    
    def _has_valid_items(self, order: Order) -> bool:
        """Check if all items are valid"""
        return all(item.quantity > 0 for item in order.items)
    
    def _has_shipping_address(self, order: Order) -> bool:
        """Check if order has valid shipping address"""
        # Simplified - would check actual address
        return True
    
    def _all_items_in_stock(self, order: Order) -> bool:
        """Check if all items are in stock"""
        # Simplified - would check inventory
        return True

# ✅ GOOD: Factory Pattern for Complex Object Creation
class OrderFactory:
    """Factory for creating orders with complex initialization"""
    
    @staticmethod
    def create_draft_order(customer_id: CustomerId) -> Order:
        """Create a new draft order"""
        order_id = OrderId.generate()
        return Order(order_id, customer_id)
    
    @staticmethod
    def create_order_from_cart(
        customer_id: CustomerId, 
        cart_items: List[tuple]
    ) -> Order:
        """Create order from shopping cart items"""
        order = OrderFactory.create_draft_order(customer_id)
        
        for product_id_str, quantity, unit_price_amount in cart_items:
            product_id = ProductId(product_id_str)
            unit_price = Money(unit_price_amount, "USD")
            order.add_item(product_id, quantity, unit_price)
        
        return order
    
    @staticmethod
    def create_order_with_items(
        customer_id: CustomerId,
        items: List[tuple]
    ) -> Order:
        """Create order with specific items"""
        order = OrderFactory.create_draft_order(customer_id)
        
        for product_id_str, quantity, unit_price_amount in items:
            product_id = ProductId(product_id_str)
            unit_price = Money(unit_price_amount, "USD")
            order.add_item(product_id, quantity, unit_price)
        
        return order

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

# ❌ BAD: Anemic Domain Model
class BadOrder:
    """Example of anemic domain model - only data, no behavior"""
    
    def __init__(self, order_id: str, customer_id: str):
        self.id = order_id
        self.customer_id = customer_id
        self.items = []
        self.status = "Draft"
        self.total_amount = 0.0
        self.created_at = datetime.utcnow()
    
    # ❌ No business logic - just data access
    def add_item(self, product_id: str, quantity: int, unit_price: float):
        # Business logic should be in the domain object
        if self.status != "Draft":
            raise ValueError("Cannot modify confirmed order")
        # ... rest of logic scattered elsewhere

# ❌ BAD: Primitive Obsession
class BadCustomer:
    """Example of primitive obsession - using primitives instead of domain types"""
    
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
    # Create order using factory
    customer_id = CustomerId("customer-123")
    order = OrderFactory.create_draft_order(customer_id)
    
    # Add items
    product1 = ProductId("product-1")
    product2 = ProductId("product-2")
    
    order.add_item(product1, 2, Money(15.99, "USD"))
    order.add_item(product2, 1, Money(25.50, "USD"))
    
    print(f"Order created: {order}")
    print(f"Total amount: {order.total_amount}")
    print(f"Can be confirmed: {order.can_be_confirmed()}")
    
    # Confirm order
    order.confirm()
    print(f"Order confirmed: {order}")
    print(f"Can be shipped: {order.can_be_shipped()}")
    
    # Create customer
    customer = CustomerFactory.create_standard_customer("John Doe", "john.doe@example.com")
    print(f"Customer created: {customer}")
    print(f"Customer type: {customer.get_customer_type()}")
    
    # Create pricing service
    pricing_service = PricingService()
    address = Address("123 Main St", "Anytown", "CA", "US", "12345")
    
    # Calculate order total
    total = pricing_service.calculate_order_total(order, customer, address)
    print(f"Order total with tax and shipping: {total}")
    
    # Test specification
    order_spec = OrderSpecification()
    print(f"Order can be confirmed: {order_spec.can_be_confirmed(order)}")
    print(f"Order can be shipped: {order_spec.can_be_shipped(order)}")
```

## Key Concepts Demonstrated

### Best Practices for Domain Modeling

#### 1. **Keep Domain Logic Pure**
- ✅ Domain objects should not depend on external frameworks
- ✅ Business rules are encapsulated in domain objects
- ✅ Pure functions for calculations and transformations

#### 2. **Use Rich Domain Models**
- ✅ Domain objects contain both data and behavior
- ✅ Business logic is contained within the objects that own the data
- ✅ Methods express business operations clearly

#### 3. **Validate at Domain Boundaries**
- ✅ Domain objects validate their state and enforce business rules
- ✅ Validation happens at the domain boundary
- ✅ Clear error messages for business rule violations

#### 4. **Use Value Objects for Complex Types**
- ✅ Value objects represent complex concepts and ensure consistency
- ✅ Immutable objects with value-based equality
- ✅ Factory methods for common values

#### 5. **Design for Testability**
- ✅ Minimize external dependencies
- ✅ Clear interfaces for dependencies
- ✅ Pure functions where possible
- ✅ Dependency injection for external services

### Domain Modeling Patterns

#### **Aggregate Root Pattern**
- ✅ Encapsulates business rules and invariants
- ✅ Manages domain events
- ✅ Controls access to aggregate members

#### **Domain Events**
- ✅ Communicate significant business events
- ✅ Enable loose coupling between aggregates
- ✅ Support eventual consistency

#### **Specification Pattern**
- ✅ Encapsulate complex business rules
- ✅ Reusable business logic
- ✅ Clear expression of business constraints

#### **Factory Pattern**
- ✅ Complex object creation logic
- ✅ Consistent object initialization
- ✅ Hide creation complexity

### Python Benefits for Domain Modeling
- **Dataclasses**: Clean, concise class definitions with `@dataclass`
- **Frozen Dataclasses**: Immutable objects with `frozen=True`
- **Type Hints**: Better IDE support and documentation
- **Enums**: Type-safe status and state management
- **Properties**: Clean access to encapsulated data
- **Method Chaining**: Fluent interfaces for operations
- **Error Handling**: Clear exception messages for business rules

### Common Anti-Patterns to Avoid

#### **Anemic Domain Model**
- ❌ Domain objects contain only data
- ❌ Business logic in external services
- ❌ No encapsulation of business rules

#### **Primitive Obsession**
- ❌ Using primitives instead of domain types
- ❌ No type safety for business concepts
- ❌ Scattered validation logic

#### **Validation Scattered**
- ❌ Validation logic spread across layers
- ❌ Inconsistent business rule enforcement
- ❌ Hard to maintain and test

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Example of good entity design
- [Order Entity](./03-order-entity.md) - Rich domain model example
- [Money Value Object](./02-money-value-object.md) - Value object best practices
- [EmailAddress Value Object](./04-email-address-value-object.md) - Validation example
- [Pricing Service](./05-pricing-service.md) - Domain service example
- [Customer Module](./06-customer-module.md) - Module organization
- [Best Practices for Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling) - Domain modeling concepts

/*
 * Navigation:
 * Previous: 12-testing-best-practices.md
 * Next: N/A
 *
 * Back to: [Best Practices for Domain Modeling](../../1-introduction-to-the-domain.md#best-practices-for-domain-modeling)
 */
