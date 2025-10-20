# Order Tests - Java Example

**Section**: [Pure Domain Logic is Easily Testable](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable)

**Navigation**: [← Previous: Customer Module](./06-customer-module.md) | [← Back to Introduction](../../1-introduction-to-the-domain.md) | [← Back to Java Index](./README.md)

---

```java
// Java Example - Order Tests (JUnit 5) - Domain Entity Testing
// File: 2-Domain-Driven-Design/code-samples/java/07-order-tests.java

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;
import static org.assertj.core.api.Assertions.*;

import java.time.LocalDateTime;

// ✅ GOOD: Comprehensive Order Entity Tests
@DisplayName("Order Entity Tests")
class OrderTest {
    
    private OrderId orderId;
    private CustomerId customerId;
    private Order order;
    
    @BeforeEach
    void setUp() {
        orderId = OrderId.generate();
        customerId = CustomerId.of("customer-123");
        order = new Order(orderId, customerId);
    }
    
    @Nested
    @DisplayName("Order Creation Tests")
    class OrderCreationTests {
        
        @Test
        @DisplayName("Should create order with valid data")
        void shouldCreateOrderWithValidData() {
            // Assert
            assertThat(order.getId()).isEqualTo(orderId);
            assertThat(order.getCustomerId()).isEqualTo(customerId);
            assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
            assertThat(order.canBeModified()).isTrue();
            assertThat(order.canBeConfirmed()).isFalse();
            assertThat(order.getItemCount()).isEqualTo(0);
            assertThat(order.getTotalAmount()).isEqualTo(Money.zero("USD"));
        }
        
        @Test
        @DisplayName("Should create order with creation date")
        void shouldCreateOrderWithCreationDate() {
            // Arrange
            LocalDateTime createdAt = LocalDateTime.now().minusHours(1);
            Order orderWithDate = new Order(orderId, customerId, createdAt);
            
            // Assert
            assertThat(orderWithDate.getCreatedAt()).isEqualTo(createdAt);
        }
        
        @Test
        @DisplayName("Should throw exception when order ID is null")
        void shouldThrowExceptionWhenOrderIdIsNull() {
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                new Order(null, customerId);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when customer ID is null")
        void shouldThrowExceptionWhenCustomerIdIsNull() {
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                new Order(orderId, null);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when creation date is null")
        void shouldThrowExceptionWhenCreationDateIsNull() {
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                new Order(orderId, customerId, null);
            });
        }
    }
    
    @Nested
    @DisplayName("Add Item Tests")
    class AddItemTests {
        
        @Test
        @DisplayName("Should add item to draft order")
        void shouldAddItemToDraftOrder() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            int quantity = 2;
            Money unitPrice = Money.of(15.99, "USD");
            
            // Act
            order.addItem(productId, quantity, unitPrice);
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(1);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, "USD"));
            assertThat(order.hasItem(productId)).isTrue();
            
            OrderItem item = order.getItemByProductId(productId);
            assertThat(item).isNotNull();
            assertThat(item.getQuantity()).isEqualTo(quantity);
            assertThat(item.getUnitPrice()).isEqualTo(unitPrice);
        }
        
        @Test
        @DisplayName("Should update quantity when adding existing item")
        void shouldUpdateQuantityWhenAddingExistingItem() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            Money unitPrice = Money.of(15.99, "USD");
            
            // Act
            order.addItem(productId, 2, unitPrice);
            order.addItem(productId, 3, unitPrice);
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(1);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(79.95, "USD")); // 5 * 15.99
            
            OrderItem item = order.getItemByProductId(productId);
            assertThat(item.getQuantity()).isEqualTo(5);
        }
        
        @Test
        @DisplayName("Should throw exception when adding item to confirmed order")
        void shouldThrowExceptionWhenAddingItemToConfirmedOrder() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            
            ProductId productId = ProductId.of("product-2");
            int quantity = 1;
            Money unitPrice = Money.of(10.00, "USD");
            
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.addItem(productId, quantity, unitPrice);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when quantity is zero")
        void shouldThrowExceptionWhenQuantityIsZero() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            int quantity = 0;
            Money unitPrice = Money.of(15.99, "USD");
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                order.addItem(productId, quantity, unitPrice);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when quantity is negative")
        void shouldThrowExceptionWhenQuantityIsNegative() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            int quantity = -1;
            Money unitPrice = Money.of(15.99, "USD");
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                order.addItem(productId, quantity, unitPrice);
            });
        }
        
        @Test
        @DisplayName("Should add multiple items to order")
        void shouldAddMultipleItemsToOrder() {
            // Act
            order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
            order.addItem(ProductId.of("product-2"), 1, Money.of(25.50, "USD"));
            order.addItem(ProductId.of("product-3"), 3, Money.of(10.00, "USD"));
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(3);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(82.48, "USD")); // 31.98 + 25.50 + 30.00
        }
    }
    
    @Nested
    @DisplayName("Remove Item Tests")
    class RemoveItemTests {
        
        @Test
        @DisplayName("Should remove item from draft order")
        void shouldRemoveItemFromDraftOrder() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            order.addItem(productId, 2, Money.of(15.99, "USD"));
            
            // Act
            order.removeItem(productId);
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(0);
            assertThat(order.getTotalAmount()).isEqualTo(Money.zero("USD"));
            assertThat(order.hasItem(productId)).isFalse();
        }
        
        @Test
        @DisplayName("Should throw exception when removing item from confirmed order")
        void shouldThrowExceptionWhenRemovingItemFromConfirmedOrder() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            order.addItem(productId, 1, Money.of(15.99, "USD"));
            order.confirm();
            
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.removeItem(productId);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when removing non-existent item")
        void shouldThrowExceptionWhenRemovingNonExistentItem() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                order.removeItem(productId);
            });
        }
    }
    
    @Nested
    @DisplayName("Update Item Tests")
    class UpdateItemTests {
        
        @Test
        @DisplayName("Should update item quantity in draft order")
        void shouldUpdateItemQuantityInDraftOrder() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            order.addItem(productId, 2, Money.of(15.99, "USD"));
            
            // Act
            order.updateItemQuantity(productId, 5);
            
            // Assert
            OrderItem item = order.getItemByProductId(productId);
            assertThat(item.getQuantity()).isEqualTo(5);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(79.95, "USD")); // 5 * 15.99
        }
        
        @Test
        @DisplayName("Should throw exception when updating item in confirmed order")
        void shouldThrowExceptionWhenUpdatingItemInConfirmedOrder() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            order.addItem(productId, 1, Money.of(15.99, "USD"));
            order.confirm();
            
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.updateItemQuantity(productId, 5);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when updating non-existent item")
        void shouldThrowExceptionWhenUpdatingNonExistentItem() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                order.updateItemQuantity(productId, 5);
            });
        }
        
        @Test
        @DisplayName("Should throw exception when quantity is zero")
        void shouldThrowExceptionWhenQuantityIsZero() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            order.addItem(productId, 2, Money.of(15.99, "USD"));
            
            // Act & Assert
            assertThrows(IllegalArgumentException.class, () -> {
                order.updateItemQuantity(productId, 0);
            });
        }
    }
    
    @Nested
    @DisplayName("Order Confirmation Tests")
    class OrderConfirmationTests {
        
        @Test
        @DisplayName("Should confirm order with valid items")
        void shouldConfirmOrderWithValidItems() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
            
            // Act
            order.confirm();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CONFIRMED);
            assertThat(order.canBeModified()).isFalse();
            assertThat(order.canBeShipped()).isTrue();
        }
        
        @Test
        @DisplayName("Should throw exception when confirming empty order")
        void shouldThrowExceptionWhenConfirmingEmptyOrder() {
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.confirm();
            });
        }
        
        @Test
        @DisplayName("Should throw exception when confirming order with low amount")
        void shouldThrowExceptionWhenConfirmingOrderWithLowAmount() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(5.00, "USD")); // Below $10 minimum
            
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.confirm();
            });
        }
        
        @Test
        @DisplayName("Should throw exception when confirming non-draft order")
        void shouldThrowExceptionWhenConfirmingNonDraftOrder() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.confirm();
            });
        }
    }
    
    @Nested
    @DisplayName("Order State Transition Tests")
    class OrderStateTransitionTests {
        
        @Test
        @DisplayName("Should follow correct state transitions")
        void shouldFollowCorrectStateTransitions() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            
            // Act & Assert - Draft state
            assertThat(order.canBeModified()).isTrue();
            assertThat(order.canBeConfirmed()).isTrue();
            assertThat(order.canBeShipped()).isFalse();
            
            // Act & Assert - Confirmed state
            order.confirm();
            assertThat(order.canBeModified()).isFalse();
            assertThat(order.canBeConfirmed()).isFalse();
            assertThat(order.canBeShipped()).isTrue();
            assertThat(order.canBeCancelled()).isTrue();
            
            // Act & Assert - Shipped state
            order.ship();
            assertThat(order.canBeModified()).isFalse();
            assertThat(order.canBeConfirmed()).isFalse();
            assertThat(order.canBeShipped()).isFalse();
            assertThat(order.canBeDelivered()).isTrue();
            assertThat(order.canBeCancelled()).isFalse();
            
            // Act & Assert - Delivered state
            order.deliver();
            assertThat(order.canBeModified()).isFalse();
            assertThat(order.canBeConfirmed()).isFalse();
            assertThat(order.canBeShipped()).isFalse();
            assertThat(order.canBeDelivered()).isFalse();
            assertThat(order.canBeCancelled()).isFalse();
        }
        
        @Test
        @DisplayName("Should throw exception when shipping non-confirmed order")
        void shouldThrowExceptionWhenShippingNonConfirmedOrder() {
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.ship();
            });
        }
        
        @Test
        @DisplayName("Should throw exception when delivering non-shipped order")
        void shouldThrowExceptionWhenDeliveringNonShippedOrder() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.deliver();
            });
        }
    }
    
    @Nested
    @DisplayName("Order Cancellation Tests")
    class OrderCancellationTests {
        
        @Test
        @DisplayName("Should cancel draft order")
        void shouldCancelDraftOrder() {
            // Act
            order.cancel();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CANCELLED);
        }
        
        @Test
        @DisplayName("Should cancel confirmed order")
        void shouldCancelConfirmedOrder() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            
            // Act
            order.cancel();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CANCELLED);
        }
        
        @Test
        @DisplayName("Should throw exception when cancelling shipped order")
        void shouldThrowExceptionWhenCancellingShippedOrder() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            order.ship();
            
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.cancel();
            });
        }
        
        @Test
        @DisplayName("Should throw exception when cancelling delivered order")
        void shouldThrowExceptionWhenCancellingDeliveredOrder() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            order.ship();
            order.deliver();
            
            // Act & Assert
            assertThrows(IllegalStateException.class, () -> {
                order.cancel();
            });
        }
    }
    
    @Nested
    @DisplayName("Order Total Calculation Tests")
    class OrderTotalCalculationTests {
        
        @Test
        @DisplayName("Should calculate total for single item")
        void shouldCalculateTotalForSingleItem() {
            // Act
            order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
            
            // Assert
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, "USD"));
        }
        
        @Test
        @DisplayName("Should calculate total for multiple items")
        void shouldCalculateTotalForMultipleItems() {
            // Act
            order.addItem(ProductId.of("product-1"), 2, Money.of(15.99, "USD"));
            order.addItem(ProductId.of("product-2"), 1, Money.of(25.50, "USD"));
            order.addItem(ProductId.of("product-3"), 3, Money.of(10.00, "USD"));
            
            // Assert
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(82.48, "USD")); // 31.98 + 25.50 + 30.00
        }
        
        @Test
        @DisplayName("Should return zero total for empty order")
        void shouldReturnZeroTotalForEmptyOrder() {
            // Assert
            assertThat(order.getTotalAmount()).isEqualTo(Money.zero("USD"));
        }
    }
    
    @Nested
    @DisplayName("Order Domain Events Tests")
    class OrderDomainEventsTests {
        
        @Test
        @DisplayName("Should raise order confirmed event")
        void shouldRaiseOrderConfirmedEvent() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            
            // Act
            order.confirm();
            
            // Assert
            List<String> events = order.getDomainEvents();
            assertThat(events).contains("OrderConfirmed");
        }
        
        @Test
        @DisplayName("Should raise order shipped event")
        void shouldRaiseOrderShippedEvent() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            
            // Act
            order.ship();
            
            // Assert
            List<String> events = order.getDomainEvents();
            assertThat(events).contains("OrderConfirmed", "OrderShipped");
        }
        
        @Test
        @DisplayName("Should raise order delivered event")
        void shouldRaiseOrderDeliveredEvent() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            order.ship();
            
            // Act
            order.deliver();
            
            // Assert
            List<String> events = order.getDomainEvents();
            assertThat(events).contains("OrderConfirmed", "OrderShipped", "OrderDelivered");
        }
        
        @Test
        @DisplayName("Should raise order cancelled event")
        void shouldRaiseOrderCancelledEvent() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
            order.confirm();
            
            // Act
            order.cancel();
            
            // Assert
            List<String> events = order.getDomainEvents();
            assertThat(events).contains("OrderConfirmed", "OrderCancelled");
        }
    }
    
    @Nested
    @DisplayName("Order Equality Tests")
    class OrderEqualityTests {
        
        @Test
        @DisplayName("Should be equal when order IDs are same")
        void shouldBeEqualWhenOrderIdsAreSame() {
            // Arrange
            OrderId sameOrderId = OrderId.of(orderId.getValue());
            Order sameOrder = new Order(sameOrderId, customerId);
            
            // Assert
            assertThat(order).isEqualTo(sameOrder);
            assertThat(order.hashCode()).isEqualTo(sameOrder.hashCode());
        }
        
        @Test
        @DisplayName("Should not be equal when order IDs are different")
        void shouldNotBeEqualWhenOrderIdsAreDifferent() {
            // Arrange
            OrderId differentOrderId = OrderId.generate();
            Order differentOrder = new Order(differentOrderId, customerId);
            
            // Assert
            assertThat(order).isNotEqualTo(differentOrder);
        }
    }
    
    @Nested
    @DisplayName("Order Helper Method Tests")
    class OrderHelperMethodTests {
        
        @Test
        @DisplayName("Should find item by product ID")
        void shouldFindItemByProductId() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            order.addItem(productId, 2, Money.of(15.99, "USD"));
            
            // Act
            OrderItem item = order.getItemByProductId(productId);
            
            // Assert
            assertThat(item).isNotNull();
            assertThat(item.getProductId()).isEqualTo(productId);
            assertThat(item.getQuantity()).isEqualTo(2);
        }
        
        @Test
        @DisplayName("Should return null when item not found")
        void shouldReturnNullWhenItemNotFound() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            
            // Act
            OrderItem item = order.getItemByProductId(productId);
            
            // Assert
            assertThat(item).isNull();
        }
        
        @Test
        @DisplayName("Should check if order has item")
        void shouldCheckIfOrderHasItem() {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            order.addItem(productId, 2, Money.of(15.99, "USD"));
            
            // Act & Assert
            assertThat(order.hasItem(productId)).isTrue();
            assertThat(order.hasItem(ProductId.of("product-2"))).isFalse();
        }
    }
    
    @Nested
    @DisplayName("Order Edge Case Tests")
    class OrderEdgeCaseTests {
        
        @Test
        @DisplayName("Should handle minimum order amount")
        void shouldHandleMinimumOrderAmount() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(10.00, "USD")); // Exactly $10
            
            // Act
            order.confirm();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CONFIRMED);
        }
        
        @Test
        @DisplayName("Should handle large order amounts")
        void shouldHandleLargeOrderAmounts() {
            // Arrange
            order.addItem(ProductId.of("product-1"), 100, Money.of(100.00, "USD")); // $10,000
            
            // Act
            order.confirm();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CONFIRMED);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(10000.00, "USD"));
        }
        
        @Test
        @DisplayName("Should handle many items")
        void shouldHandleManyItems() {
            // Act
            for (int i = 1; i <= 100; i++) {
                order.addItem(ProductId.of("product-" + i), 1, Money.of(1.00, "USD"));
            }
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(100);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(100.00, "USD"));
        }
    }
    
    @Nested
    @DisplayName("Order Parameterized Tests")
    class OrderParameterizedTests {
        
        @ParameterizedTest
        @ValueSource(ints = {1, 2, 5, 10, 100})
        @DisplayName("Should add item with different quantities")
        void shouldAddItemWithDifferentQuantities(int quantity) {
            // Arrange
            ProductId productId = ProductId.of("product-1");
            Money unitPrice = Money.of(10.00, "USD");
            
            // Act
            order.addItem(productId, quantity, unitPrice);
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(1);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(quantity * 10.00, "USD"));
        }
        
        @ParameterizedTest
        @CsvSource({
            "10.00, true",
            "9.99, false",
            "100.00, true",
            "0.01, false"
        })
        @DisplayName("Should validate minimum order amount")
        void shouldValidateMinimumOrderAmount(double amount, boolean canConfirm) {
            // Arrange
            order.addItem(ProductId.of("product-1"), 1, Money.of(amount, "USD"));
            
            // Act & Assert
            if (canConfirm) {
                assertDoesNotThrow(() -> order.confirm());
                assertThat(order.getStatus()).isEqualTo(OrderStatus.CONFIRMED);
            } else {
                assertThrows(IllegalStateException.class, () -> order.confirm());
                assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
            }
        }
    }
}

// ✅ GOOD: Order Factory Tests
@DisplayName("Order Factory Tests")
class OrderFactoryTest {
    
    @Test
    @DisplayName("Should create draft order")
    void shouldCreateDraftOrder() {
        // Arrange
        CustomerId customerId = CustomerId.of("customer-123");
        
        // Act
        Order order = OrderFactory.createDraftOrder(customerId);
        
        // Assert
        assertThat(order.getCustomerId()).isEqualTo(customerId);
        assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
        assertThat(order.getItemCount()).isEqualTo(0);
    }
    
    @Test
    @DisplayName("Should create order from cart items")
    void shouldCreateOrderFromCartItems() {
        // Arrange
        CustomerId customerId = CustomerId.of("customer-123");
        List<CartItem> cartItems = List.of(
            new CartItem("product-1", 2, 15.99),
            new CartItem("product-2", 1, 25.50)
        );
        
        // Act
        Order order = OrderFactory.createOrderFromCart(customerId, cartItems);
        
        // Assert
        assertThat(order.getCustomerId()).isEqualTo(customerId);
        assertThat(order.getItemCount()).isEqualTo(2);
        assertThat(order.getTotalAmount()).isEqualTo(Money.of(57.48, "USD"));
    }
}

// ✅ GOOD: Order Specification Tests
@DisplayName("Order Specification Tests")
class OrderSpecificationTest {
    
    private OrderSpecification orderSpec;
    
    @BeforeEach
    void setUp() {
        orderSpec = new OrderSpecification();
    }
    
    @Test
    @DisplayName("Should confirm order when all criteria are met")
    void shouldConfirmOrderWhenAllCriteriaAreMet() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
        
        // Act & Assert
        assertThat(orderSpec.canBeConfirmed(order)).isTrue();
    }
    
    @Test
    @DisplayName("Should not confirm order when criteria are not met")
    void shouldNotConfirmOrderWhenCriteriaAreNotMet() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        
        // Act & Assert
        assertThat(orderSpec.canBeConfirmed(order)).isFalse();
    }
    
    @Test
    @DisplayName("Should ship order when all criteria are met")
    void shouldShipOrderWhenAllCriteriaAreMet() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        order.addItem(ProductId.of("product-1"), 1, Money.of(15.99, "USD"));
        order.confirm();
        
        // Act & Assert
        assertThat(orderSpec.canBeShipped(order)).isTrue();
    }
    
    @Test
    @DisplayName("Should not ship order when criteria are not met")
    void shouldNotShipOrderWhenCriteriaAreNotMet() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.of("customer-123"));
        
        // Act & Assert
        assertThat(orderSpec.canBeShipped(order)).isFalse();
    }
}

// Helper classes for testing
class CartItem {
    private final String productId;
    private final int quantity;
    private final double unitPrice;
    
    public CartItem(String productId, int quantity, double unitPrice) {
        this.productId = productId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }
    
    public String getProductId() { return productId; }
    public int getQuantity() { return quantity; }
    public double getUnitPrice() { return unitPrice; }
}

// Example usage
public class OrderTestExample {
    public static void main(String[] args) {
        // Create order
        CustomerId customerId = CustomerId.of("customer-123");
        Order order = OrderFactory.createDraftOrder(customerId);
        
        // Add items
        ProductId product1 = ProductId.of("product-1");
        ProductId product2 = ProductId.of("product-2");
        
        order.addItem(product1, 2, Money.of(15.99, "USD"));
        order.addItem(product2, 1, Money.of(25.50, "USD"));
        
        System.out.println("Order created: " + order);
        System.out.println("Total amount: " + order.getTotalAmount());
        System.out.println("Can be confirmed: " + order.canBeConfirmed());
        
        // Confirm order
        order.confirm();
        System.out.println("Order confirmed: " + order);
        System.out.println("Can be shipped: " + order.canBeShipped());
        
        // Ship order
        order.ship();
        System.out.println("Order shipped: " + order);
        System.out.println("Can be delivered: " + order.canBeDelivered());
        
        // Deliver order
        order.deliver();
        System.out.println("Order delivered: " + order);
        
        // Test specification
        OrderSpecification orderSpec = new OrderSpecification();
        System.out.println("Order can be confirmed: " + orderSpec.canBeConfirmed(order));
        System.out.println("Order can be shipped: " + orderSpec.canBeShipped(order));
    }
}
```

## Key Concepts Demonstrated

### Pure Domain Logic is Easily Testable

#### 1. **Comprehensive Test Coverage**
- ✅ Tests cover all public methods and properties
- ✅ Edge cases and error conditions are tested
- ✅ State transitions and business rules are verified

#### 2. **Business Rule Testing**
- ✅ Tests verify business rules are enforced
- ✅ Invalid operations are properly rejected
- ✅ Business logic behavior is consistent

#### 3. **State Management Testing**
- ✅ Order state transitions are tested
- ✅ State-dependent operations are verified
- ✅ Invalid state transitions are prevented

#### 4. **Domain Event Testing**
- ✅ Domain events are raised correctly
- ✅ Events reflect significant business changes
- ✅ Event sequence is verified

### Order Entity Testing Principles

#### **Test Business Rules**
- ✅ Order confirmation rules are tested
- ✅ Item addition rules are verified
- ✅ State transition rules are tested

#### **Test Error Conditions**
- ✅ Invalid inputs are properly rejected
- ✅ Business rule violations are handled
- ✅ Error messages are clear and descriptive

#### **Test State Transitions**
- ✅ Order state transitions are tested
- ✅ State-dependent operations are verified
- ✅ Invalid transitions are prevented

#### **Test Edge Cases**
- ✅ Boundary conditions are tested
- ✅ Large orders are handled
- ✅ Many items are supported

### Java Testing Benefits
- **JUnit 5**: Modern testing framework with annotations
- **AssertJ**: Fluent assertions for better readability
- **Parameterized Tests**: Test multiple scenarios efficiently
- **Nested Tests**: Organize tests by functionality
- **Display Names**: Clear test descriptions
- **Error Handling**: Clear exception messages for business rules

### Common Anti-Patterns to Avoid

#### **Incomplete Test Coverage**
- ❌ Tests that don't cover all methods
- ❌ Tests that miss edge cases
- ❌ Tests that don't verify error conditions

#### **Testing Implementation Details**
- ❌ Tests that verify internal implementation
- ❌ Tests that break when implementation changes
- ❌ Tests that don't verify business behavior

#### **Over-Mocking**
- ❌ Mocking domain objects instead of testing real behavior
- ❌ Tests that don't verify actual business logic
- ❌ Tests that are hard to maintain

## Related Concepts

- [Order Entity](./03-order-entity.md) - Entity being tested
- [Money Tests](./08-money-tests.md) - Value object tests
- [Pricing Service Tests](./09-pricing-service-tests.md) - Domain service tests
- [Pure Domain Logic is Easily Testable](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable) - Testing concepts

/*
 * Navigation:
 * Previous: 06-customer-module.md
 * Next: 08-money-tests.md
 *
 * Back to: [Pure Domain Logic is Easily Testable](../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable)
 */
