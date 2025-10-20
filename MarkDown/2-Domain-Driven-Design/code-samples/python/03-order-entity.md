# Order Entity - Python Example

**Section**: [Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation)

**Navigation**: [← Previous: Customer Entity](./01-customer-entity.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Python Index](./README.md)

---

```python
# Python Example - Order Entity with Business Logic Encapsulation
# File: 2-Domain-Driven-Design/code-samples/python/03-order-entity.py

from datetime import datetime
from typing import List, Optional
from dataclasses import dataclass, field
from enum import Enum
import uuid

# ✅ GOOD: Rich Domain Model with Behavior
class OrderStatus(Enum):
    DRAFT = "Draft"
    CONFIRMED = "Confirmed"
    SHIPPED = "Shipped"
    DELIVERED = "Delivered"
    CANCELLED = "Cancelled"

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
    
    def multiply(self, factor: float) -> 'Money':
        if factor < 0:
            raise ValueError("Factor cannot be negative")
        return Money(self.amount * factor, self.currency)
    
    def __str__(self) -> str:
        return f"{self.currency} {self.amount:.2f}"

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
            return Money(0, "USD")
        
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
    
    def remove_item(self, product_id: ProductId) -> None:
        """Remove an item from the order"""
        if self._status != OrderStatus.DRAFT:
            raise ValueError("Cannot modify confirmed order")
        
        item_index = self._find_item_index(product_id)
        if item_index >= 0:
            del self._items[item_index]
        else:
            raise ValueError("Item not found in order")
    
    def update_item_quantity(self, product_id: ProductId, new_quantity: int) -> None:
        """Update the quantity of an existing item"""
        if self._status != OrderStatus.DRAFT:
            raise ValueError("Cannot modify confirmed order")
        
        if new_quantity <= 0:
            raise ValueError("Quantity must be positive")
        
        item_index = self._find_item_index(product_id)
        if item_index >= 0:
            existing_item = self._items[item_index]
            updated_item = OrderItem(product_id, new_quantity, existing_item.unit_price)
            self._items[item_index] = updated_item
        else:
            raise ValueError("Item not found in order")
    
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
    
    def ship(self) -> None:
        """Mark the order as shipped"""
        if self._status != OrderStatus.CONFIRMED:
            raise ValueError("Order must be confirmed before shipping")
        
        self._status = OrderStatus.SHIPPED
        self._shipped_at = datetime.utcnow()
    
    def deliver(self) -> None:
        """Mark the order as delivered"""
        if self._status != OrderStatus.SHIPPED:
            raise ValueError("Order must be shipped before delivery")
        
        self._status = OrderStatus.DELIVERED
    
    def cancel(self) -> None:
        """Cancel the order"""
        if self._status in [OrderStatus.SHIPPED, OrderStatus.DELIVERED]:
            raise ValueError("Cannot cancel shipped or delivered order")
        
        self._status = OrderStatus.CANCELLED
    
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
    
    # ✅ String representation for debugging
    def __str__(self) -> str:
        return (f"Order(id={self._id}, customer_id={self._customer_id}, "
                f"status={self._status.value}, items={len(self._items)}, "
                f"total={self.total_amount})")
    
    def __repr__(self) -> str:
        return self.__str__()

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

# ✅ GOOD: Domain Service for Complex Business Logic
class OrderPricingService:
    """Domain service for complex pricing calculations"""
    
    def calculate_discount(self, order: Order, customer_type: str) -> Money:
        """Calculate discount based on customer type and order amount"""
        base_amount = order.total_amount
        
        if customer_type == "VIP":
            discount_rate = 0.15
        elif customer_type == "Premium":
            discount_rate = 0.10
        elif customer_type == "Standard":
            discount_rate = 0.05
        else:
            discount_rate = 0.0
        
        discount_amount = base_amount.multiply(discount_rate)
        return discount_amount
    
    def calculate_shipping(self, order: Order, shipping_address: str) -> Money:
        """Calculate shipping cost based on order and destination"""
        base_shipping = Money(5.99, "USD")
        
        # Free shipping for orders over $50
        if order.total_amount.amount >= 50.0:
            return Money(0, "USD")
        
        # Additional cost for heavy items
        total_weight = sum(item.quantity * 0.5 for item in order.items)  # Simplified
        if total_weight > 10:
            return base_shipping.add(Money(2.99, "USD"))
        
        return base_shipping

# ✅ GOOD: Factory for Complex Object Creation
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

# Example usage
if __name__ == "__main__":
    # Create order
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
    
    # Ship order
    order.ship()
    print(f"Order shipped: {order}")
    print(f"Can be delivered: {order.can_be_delivered()}")
    
    # Deliver order
    order.deliver()
    print(f"Order delivered: {order}")
```

## Key Concepts Demonstrated

### Business Logic Encapsulation

#### 1. **Rich Domain Models**
- ✅ Domain objects contain both data and behavior
- ✅ Business logic is encapsulated within the objects that own the data
- ✅ Methods express business operations clearly

#### 2. **Business Rules as Methods**
- ✅ Business rules are expressed as methods on domain objects
- ✅ Validation happens at the domain boundary
- ✅ Clear error messages for business rule violations

#### 3. **State Management**
- ✅ Order status is managed through business operations
- ✅ State transitions are controlled by business rules
- ✅ Invalid state transitions are prevented

#### 4. **Domain Events**
- ✅ Significant business events are captured
- ✅ Events can be used for integration and notifications
- ✅ Domain events maintain consistency

### Order Entity Design Principles

#### **Identity Management**
- ✅ Order has a unique identity (OrderId)
- ✅ Identity is immutable and generated
- ✅ Identity distinguishes orders from each other

#### **Business Logic Encapsulation**
- ✅ Order contains all business rules for order management
- ✅ Operations like add_item, confirm, ship are methods
- ✅ Business rules prevent invalid operations

#### **State Management**
- ✅ Order status is managed through business operations
- ✅ State transitions follow business rules
- ✅ Invalid transitions are prevented

#### **Value Objects**
- ✅ OrderId, CustomerId, ProductId are value objects
- ✅ Money is a value object with business operations
- ✅ OrderItem is a value object representing order line items

### Python Benefits for Domain Modeling
- **Dataclasses**: Clean, concise class definitions
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

#### **God Object**
- ❌ Single object with too many responsibilities
- ❌ Hard to understand and maintain
- ❌ Violates Single Responsibility Principle

## Related Concepts

- [Customer Entity](./01-customer-entity.md) - Basic entity design
- [Money Value Object](./02-money-value-object.md) - Value object example
- [EmailAddress Value Object](./04-email-address-value-object.md) - Validation example
- [Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation) - Business logic concepts

/*
 * Navigation:
 * Previous: 01-customer-entity.md
 * Next: 04-email-address-value-object.md
 *
 * Back to: [Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation)
 */
