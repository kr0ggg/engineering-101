# Inventory Service - Java Example

**Section**: [Domain Services](../introduction-to-the-domain.md#domain-services)

**Navigation**: [← Previous: Money Value Object](./02-money-value-object.java) | [← Back to Introduction](../introduction-to-the-domain.md) | [Next: Order Tests →](./04-order-tests.java)

---

```java
// Java Example - Inventory Service
public class InventoryService {
    
    public boolean isProductAvailable(ProductId productId, int quantity) {
        if (productId == null) throw new IllegalArgumentException("Product ID cannot be null");
        if (quantity <= 0) throw new IllegalArgumentException("Quantity must be positive");
        
        Product product = productRepository.findById(productId);
        if (product == null) return false;
        
        int availableQuantity = getAvailableQuantity(productId);
        return availableQuantity >= quantity;
    }
    
    public void reserveProduct(ProductId productId, int quantity) {
        if (!isProductAvailable(productId, quantity)) {
            throw new InsufficientInventoryException(
                String.format("Not enough inventory for product %s. Requested: %d", 
                             productId, quantity));
        }
        
        // Reserve the inventory
        inventoryRepository.reserve(productId, quantity);
    }
    
    public void releaseReservation(ProductId productId, int quantity) {
        if (productId == null) throw new IllegalArgumentException("Product ID cannot be null");
        if (quantity <= 0) throw new IllegalArgumentException("Quantity must be positive");
        
        inventoryRepository.releaseReservation(productId, quantity);
    }
    
    public void fulfillReservation(ProductId productId, int quantity) {
        if (productId == null) throw new IllegalArgumentException("Product ID cannot be null");
        if (quantity <= 0) throw new IllegalArgumentException("Quantity must be positive");
        
        inventoryRepository.fulfillReservation(productId, quantity);
    }
    
    private int getAvailableQuantity(ProductId productId) {
        return inventoryRepository.getAvailableQuantity(productId);
    }
}
```

## Key Concepts Demonstrated

- **Domain Service**: Contains business logic that doesn't belong to entities
- **Cross-Entity Operations**: Works with Product and Inventory entities
- **Complex Business Rules**: Handles inventory management scenarios
- **Stateless**: No internal state, pure business logic
- **Repository Pattern**: Uses repository interfaces for data access
- **Business Rules**: Encapsulates inventory policies and constraints

## Business Rules Encapsulated

1. **Availability Check**: Verifies product exists and has sufficient quantity
2. **Reservation Management**: Handles inventory reservations
3. **Quantity Validation**: Ensures positive quantities
4. **Exception Handling**: Proper error handling for insufficient inventory
5. **Lifecycle Management**: Handles reservation, release, and fulfillment

## Java-Specific Features

- **String.format()**: Formatted exception messages
- **IllegalArgumentException**: Standard Java exception for invalid arguments
- **Custom Exceptions**: Domain-specific `InsufficientInventoryException`
- **Null Safety**: Consistent null checking throughout

## When to Use Domain Services

- **Cross-Entity Logic**: Operations involving multiple entities
- **Complex Calculations**: Business rules too complex for single entity
- **Stateless Operations**: No need to maintain state
- **Domain-Specific Logic**: Business rules that are part of the domain

## Service Methods

- **isProductAvailable()**: Checks if product has sufficient inventory
- **reserveProduct()**: Reserves inventory for an order
- **releaseReservation()**: Releases reserved inventory
- **fulfillReservation()**: Converts reservation to fulfillment

## Related Concepts

- [Money Value Object](./02-money-value-object.java) - Used for pricing calculations
- [Order Tests](./04-order-tests.java) - Testing domain logic
- [Domain Services](../introduction-to-the-domain.md#domain-services) - Domain service concepts
- [Repository Pattern](../introduction-to-the-domain.md#modules-and-separation-of-concerns) - Data access pattern
