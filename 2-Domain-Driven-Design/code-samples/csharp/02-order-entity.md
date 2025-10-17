# Order Entity with Business Logic - C# Example

**Section**: [Domain Entities - Business Logic Encapsulation](../introduction-to-the-domain.md#business-logic-encapsulation)

**Navigation**: [← Previous: Customer Entity](./01-customer-entity.cs) | [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Money Value Object →](./03-money-value-object.cs)

---

```csharp
// C# Example - Order Entity with Business Logic
public class Order
{
    public OrderId Id { get; private set; }
    public CustomerId CustomerId { get; private set; }
    public OrderStatus Status { get; private set; }
    public Money TotalAmount { get; private set; }
    private readonly List<OrderItem> _items = new List<OrderItem>();
    
    public IReadOnlyList<OrderItem> Items => _items.AsReadOnly();
    
    public Order(OrderId id, CustomerId customerId)
    {
        Id = id ?? throw new ArgumentNullException(nameof(id));
        CustomerId = customerId ?? throw new ArgumentNullException(nameof(customerId));
        Status = OrderStatus.Draft;
        TotalAmount = Money.Zero;
    }
    
    public void AddItem(Product product, int quantity)
    {
        if (Status != OrderStatus.Draft)
            throw new InvalidOperationException("Cannot modify confirmed order");
            
        if (quantity <= 0)
            throw new ArgumentException("Quantity must be positive");
            
        var existingItem = _items.FirstOrDefault(i => i.ProductId == product.Id);
        if (existingItem != null)
        {
            existingItem.UpdateQuantity(existingItem.Quantity + quantity);
        }
        else
        {
            _items.Add(new OrderItem(product.Id, product.Price, quantity));
        }
        
        RecalculateTotal();
    }
    
    public void Confirm()
    {
        if (Status != OrderStatus.Draft)
            throw new InvalidOperationException("Only draft orders can be confirmed");
            
        if (!_items.Any())
            throw new InvalidOperationException("Cannot confirm empty order");
            
        Status = OrderStatus.Confirmed;
    }
    
    private void RecalculateTotal()
    {
        TotalAmount = _items.Sum(item => item.TotalPrice);
    }
}
```

## Key Concepts Demonstrated

- **Rich Domain Model**: Contains both data and behavior
- **Business Rules**: Enforces order modification rules and validation
- **Encapsulation**: Private methods for internal calculations
- **State Management**: Order status transitions with validation
- **Collection Management**: Protected collection with controlled access
- **Domain Logic**: Business rules like "cannot modify confirmed order"

## Business Rules Encapsulated

1. **Order Modification**: Only draft orders can be modified
2. **Quantity Validation**: Quantities must be positive
3. **Order Confirmation**: Only non-empty draft orders can be confirmed
4. **Item Management**: Handles both new items and quantity updates
5. **Total Calculation**: Automatically recalculates totals when items change

## Related Concepts

- [Value Objects](../../1-introduction-to-the-domain.md#value-objects) - Money, OrderId, CustomerId
- [Domain Services](../../1-introduction-to-the-domain.md#domain-services) - Complex order operations
- [Unit Testing](../../1-introduction-to-the-domain.md#domain-driven-design-and-unit-testing) - Testing business rules

/*
 * Navigation:
 * Previous: 01-customer-entity.md
 * Next: 03-money-value-object.md
 *
 * Back to: [Domain Entities - Business Logic Encapsulation](../../1-introduction-to-the-domain.md#business-logic-encapsulation)
 */
