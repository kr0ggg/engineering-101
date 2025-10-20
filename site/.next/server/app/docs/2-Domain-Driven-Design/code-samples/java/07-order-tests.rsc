1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/java/07-order-tests","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"07-order-tests\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T9288,<h1>Order Tests - Java Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable">Pure Domain Logic is Easily Testable</a></p>
<p><strong>Navigation</strong>: <a href="./06-customer-module.md">← Previous: Customer Module</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Java Index</a></p>
<hr>
<pre><code class="language-java">// Java Example - Order Tests (JUnit 5) - Domain Entity Testing
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
@DisplayName(&quot;Order Entity Tests&quot;)
class OrderTest {
    
    private OrderId orderId;
    private CustomerId customerId;
    private Order order;
    
    @BeforeEach
    void setUp() {
        orderId = OrderId.generate();
        customerId = CustomerId.of(&quot;customer-123&quot;);
        order = new Order(orderId, customerId);
    }
    
    @Nested
    @DisplayName(&quot;Order Creation Tests&quot;)
    class OrderCreationTests {
        
        @Test
        @DisplayName(&quot;Should create order with valid data&quot;)
        void shouldCreateOrderWithValidData() {
            // Assert
            assertThat(order.getId()).isEqualTo(orderId);
            assertThat(order.getCustomerId()).isEqualTo(customerId);
            assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
            assertThat(order.canBeModified()).isTrue();
            assertThat(order.canBeConfirmed()).isFalse();
            assertThat(order.getItemCount()).isEqualTo(0);
            assertThat(order.getTotalAmount()).isEqualTo(Money.zero(&quot;USD&quot;));
        }
        
        @Test
        @DisplayName(&quot;Should create order with creation date&quot;)
        void shouldCreateOrderWithCreationDate() {
            // Arrange
            LocalDateTime createdAt = LocalDateTime.now().minusHours(1);
            Order orderWithDate = new Order(orderId, customerId, createdAt);
            
            // Assert
            assertThat(orderWithDate.getCreatedAt()).isEqualTo(createdAt);
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when order ID is null&quot;)
        void shouldThrowExceptionWhenOrderIdIsNull() {
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                new Order(null, customerId);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when customer ID is null&quot;)
        void shouldThrowExceptionWhenCustomerIdIsNull() {
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                new Order(orderId, null);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when creation date is null&quot;)
        void shouldThrowExceptionWhenCreationDateIsNull() {
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                new Order(orderId, customerId, null);
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Add Item Tests&quot;)
    class AddItemTests {
        
        @Test
        @DisplayName(&quot;Should add item to draft order&quot;)
        void shouldAddItemToDraftOrder() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            int quantity = 2;
            Money unitPrice = Money.of(15.99, &quot;USD&quot;);
            
            // Act
            order.addItem(productId, quantity, unitPrice);
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(1);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, &quot;USD&quot;));
            assertThat(order.hasItem(productId)).isTrue();
            
            OrderItem item = order.getItemByProductId(productId);
            assertThat(item).isNotNull();
            assertThat(item.getQuantity()).isEqualTo(quantity);
            assertThat(item.getUnitPrice()).isEqualTo(unitPrice);
        }
        
        @Test
        @DisplayName(&quot;Should update quantity when adding existing item&quot;)
        void shouldUpdateQuantityWhenAddingExistingItem() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            Money unitPrice = Money.of(15.99, &quot;USD&quot;);
            
            // Act
            order.addItem(productId, 2, unitPrice);
            order.addItem(productId, 3, unitPrice);
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(1);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(79.95, &quot;USD&quot;)); // 5 * 15.99
            
            OrderItem item = order.getItemByProductId(productId);
            assertThat(item.getQuantity()).isEqualTo(5);
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when adding item to confirmed order&quot;)
        void shouldThrowExceptionWhenAddingItemToConfirmedOrder() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            
            ProductId productId = ProductId.of(&quot;product-2&quot;);
            int quantity = 1;
            Money unitPrice = Money.of(10.00, &quot;USD&quot;);
            
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.addItem(productId, quantity, unitPrice);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when quantity is zero&quot;)
        void shouldThrowExceptionWhenQuantityIsZero() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            int quantity = 0;
            Money unitPrice = Money.of(15.99, &quot;USD&quot;);
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                order.addItem(productId, quantity, unitPrice);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when quantity is negative&quot;)
        void shouldThrowExceptionWhenQuantityIsNegative() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            int quantity = -1;
            Money unitPrice = Money.of(15.99, &quot;USD&quot;);
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                order.addItem(productId, quantity, unitPrice);
            });
        }
        
        @Test
        @DisplayName(&quot;Should add multiple items to order&quot;)
        void shouldAddMultipleItemsToOrder() {
            // Act
            order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
            order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(25.50, &quot;USD&quot;));
            order.addItem(ProductId.of(&quot;product-3&quot;), 3, Money.of(10.00, &quot;USD&quot;));
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(3);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(82.48, &quot;USD&quot;)); // 31.98 + 25.50 + 30.00
        }
    }
    
    @Nested
    @DisplayName(&quot;Remove Item Tests&quot;)
    class RemoveItemTests {
        
        @Test
        @DisplayName(&quot;Should remove item from draft order&quot;)
        void shouldRemoveItemFromDraftOrder() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            order.addItem(productId, 2, Money.of(15.99, &quot;USD&quot;));
            
            // Act
            order.removeItem(productId);
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(0);
            assertThat(order.getTotalAmount()).isEqualTo(Money.zero(&quot;USD&quot;));
            assertThat(order.hasItem(productId)).isFalse();
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when removing item from confirmed order&quot;)
        void shouldThrowExceptionWhenRemovingItemFromConfirmedOrder() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            order.addItem(productId, 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.removeItem(productId);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when removing non-existent item&quot;)
        void shouldThrowExceptionWhenRemovingNonExistentItem() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                order.removeItem(productId);
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Update Item Tests&quot;)
    class UpdateItemTests {
        
        @Test
        @DisplayName(&quot;Should update item quantity in draft order&quot;)
        void shouldUpdateItemQuantityInDraftOrder() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            order.addItem(productId, 2, Money.of(15.99, &quot;USD&quot;));
            
            // Act
            order.updateItemQuantity(productId, 5);
            
            // Assert
            OrderItem item = order.getItemByProductId(productId);
            assertThat(item.getQuantity()).isEqualTo(5);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(79.95, &quot;USD&quot;)); // 5 * 15.99
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when updating item in confirmed order&quot;)
        void shouldThrowExceptionWhenUpdatingItemInConfirmedOrder() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            order.addItem(productId, 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.updateItemQuantity(productId, 5);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when updating non-existent item&quot;)
        void shouldThrowExceptionWhenUpdatingNonExistentItem() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                order.updateItemQuantity(productId, 5);
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when quantity is zero&quot;)
        void shouldThrowExceptionWhenQuantityIsZero() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            order.addItem(productId, 2, Money.of(15.99, &quot;USD&quot;));
            
            // Act &amp; Assert
            assertThrows(IllegalArgumentException.class, () -&gt; {
                order.updateItemQuantity(productId, 0);
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Order Confirmation Tests&quot;)
    class OrderConfirmationTests {
        
        @Test
        @DisplayName(&quot;Should confirm order with valid items&quot;)
        void shouldConfirmOrderWithValidItems() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
            
            // Act
            order.confirm();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CONFIRMED);
            assertThat(order.canBeModified()).isFalse();
            assertThat(order.canBeShipped()).isTrue();
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when confirming empty order&quot;)
        void shouldThrowExceptionWhenConfirmingEmptyOrder() {
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.confirm();
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when confirming order with low amount&quot;)
        void shouldThrowExceptionWhenConfirmingOrderWithLowAmount() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(5.00, &quot;USD&quot;)); // Below $10 minimum
            
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.confirm();
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when confirming non-draft order&quot;)
        void shouldThrowExceptionWhenConfirmingNonDraftOrder() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.confirm();
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Order State Transition Tests&quot;)
    class OrderStateTransitionTests {
        
        @Test
        @DisplayName(&quot;Should follow correct state transitions&quot;)
        void shouldFollowCorrectStateTransitions() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            
            // Act &amp; Assert - Draft state
            assertThat(order.canBeModified()).isTrue();
            assertThat(order.canBeConfirmed()).isTrue();
            assertThat(order.canBeShipped()).isFalse();
            
            // Act &amp; Assert - Confirmed state
            order.confirm();
            assertThat(order.canBeModified()).isFalse();
            assertThat(order.canBeConfirmed()).isFalse();
            assertThat(order.canBeShipped()).isTrue();
            assertThat(order.canBeCancelled()).isTrue();
            
            // Act &amp; Assert - Shipped state
            order.ship();
            assertThat(order.canBeModified()).isFalse();
            assertThat(order.canBeConfirmed()).isFalse();
            assertThat(order.canBeShipped()).isFalse();
            assertThat(order.canBeDelivered()).isTrue();
            assertThat(order.canBeCancelled()).isFalse();
            
            // Act &amp; Assert - Delivered state
            order.deliver();
            assertThat(order.canBeModified()).isFalse();
            assertThat(order.canBeConfirmed()).isFalse();
            assertThat(order.canBeShipped()).isFalse();
            assertThat(order.canBeDelivered()).isFalse();
            assertThat(order.canBeCancelled()).isFalse();
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when shipping non-confirmed order&quot;)
        void shouldThrowExceptionWhenShippingNonConfirmedOrder() {
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.ship();
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when delivering non-shipped order&quot;)
        void shouldThrowExceptionWhenDeliveringNonShippedOrder() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.deliver();
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Order Cancellation Tests&quot;)
    class OrderCancellationTests {
        
        @Test
        @DisplayName(&quot;Should cancel draft order&quot;)
        void shouldCancelDraftOrder() {
            // Act
            order.cancel();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CANCELLED);
        }
        
        @Test
        @DisplayName(&quot;Should cancel confirmed order&quot;)
        void shouldCancelConfirmedOrder() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            
            // Act
            order.cancel();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CANCELLED);
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when cancelling shipped order&quot;)
        void shouldThrowExceptionWhenCancellingShippedOrder() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            order.ship();
            
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.cancel();
            });
        }
        
        @Test
        @DisplayName(&quot;Should throw exception when cancelling delivered order&quot;)
        void shouldThrowExceptionWhenCancellingDeliveredOrder() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            order.ship();
            order.deliver();
            
            // Act &amp; Assert
            assertThrows(IllegalStateException.class, () -&gt; {
                order.cancel();
            });
        }
    }
    
    @Nested
    @DisplayName(&quot;Order Total Calculation Tests&quot;)
    class OrderTotalCalculationTests {
        
        @Test
        @DisplayName(&quot;Should calculate total for single item&quot;)
        void shouldCalculateTotalForSingleItem() {
            // Act
            order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
            
            // Assert
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(31.98, &quot;USD&quot;));
        }
        
        @Test
        @DisplayName(&quot;Should calculate total for multiple items&quot;)
        void shouldCalculateTotalForMultipleItems() {
            // Act
            order.addItem(ProductId.of(&quot;product-1&quot;), 2, Money.of(15.99, &quot;USD&quot;));
            order.addItem(ProductId.of(&quot;product-2&quot;), 1, Money.of(25.50, &quot;USD&quot;));
            order.addItem(ProductId.of(&quot;product-3&quot;), 3, Money.of(10.00, &quot;USD&quot;));
            
            // Assert
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(82.48, &quot;USD&quot;)); // 31.98 + 25.50 + 30.00
        }
        
        @Test
        @DisplayName(&quot;Should return zero total for empty order&quot;)
        void shouldReturnZeroTotalForEmptyOrder() {
            // Assert
            assertThat(order.getTotalAmount()).isEqualTo(Money.zero(&quot;USD&quot;));
        }
    }
    
    @Nested
    @DisplayName(&quot;Order Domain Events Tests&quot;)
    class OrderDomainEventsTests {
        
        @Test
        @DisplayName(&quot;Should raise order confirmed event&quot;)
        void shouldRaiseOrderConfirmedEvent() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            
            // Act
            order.confirm();
            
            // Assert
            List&lt;String&gt; events = order.getDomainEvents();
            assertThat(events).contains(&quot;OrderConfirmed&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should raise order shipped event&quot;)
        void shouldRaiseOrderShippedEvent() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            
            // Act
            order.ship();
            
            // Assert
            List&lt;String&gt; events = order.getDomainEvents();
            assertThat(events).contains(&quot;OrderConfirmed&quot;, &quot;OrderShipped&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should raise order delivered event&quot;)
        void shouldRaiseOrderDeliveredEvent() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            order.ship();
            
            // Act
            order.deliver();
            
            // Assert
            List&lt;String&gt; events = order.getDomainEvents();
            assertThat(events).contains(&quot;OrderConfirmed&quot;, &quot;OrderShipped&quot;, &quot;OrderDelivered&quot;);
        }
        
        @Test
        @DisplayName(&quot;Should raise order cancelled event&quot;)
        void shouldRaiseOrderCancelledEvent() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
            order.confirm();
            
            // Act
            order.cancel();
            
            // Assert
            List&lt;String&gt; events = order.getDomainEvents();
            assertThat(events).contains(&quot;OrderConfirmed&quot;, &quot;OrderCancelled&quot;);
        }
    }
    
    @Nested
    @DisplayName(&quot;Order Equality Tests&quot;)
    class OrderEqualityTests {
        
        @Test
        @DisplayName(&quot;Should be equal when order IDs are same&quot;)
        void shouldBeEqualWhenOrderIdsAreSame() {
            // Arrange
            OrderId sameOrderId = OrderId.of(orderId.getValue());
            Order sameOrder = new Order(sameOrderId, customerId);
            
            // Assert
            assertThat(order).isEqualTo(sameOrder);
            assertThat(order.hashCode()).isEqualTo(sameOrder.hashCode());
        }
        
        @Test
        @DisplayName(&quot;Should not be equal when order IDs are different&quot;)
        void shouldNotBeEqualWhenOrderIdsAreDifferent() {
            // Arrange
            OrderId differentOrderId = OrderId.generate();
            Order differentOrder = new Order(differentOrderId, customerId);
            
            // Assert
            assertThat(order).isNotEqualTo(differentOrder);
        }
    }
    
    @Nested
    @DisplayName(&quot;Order Helper Method Tests&quot;)
    class OrderHelperMethodTests {
        
        @Test
        @DisplayName(&quot;Should find item by product ID&quot;)
        void shouldFindItemByProductId() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            order.addItem(productId, 2, Money.of(15.99, &quot;USD&quot;));
            
            // Act
            OrderItem item = order.getItemByProductId(productId);
            
            // Assert
            assertThat(item).isNotNull();
            assertThat(item.getProductId()).isEqualTo(productId);
            assertThat(item.getQuantity()).isEqualTo(2);
        }
        
        @Test
        @DisplayName(&quot;Should return null when item not found&quot;)
        void shouldReturnNullWhenItemNotFound() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            
            // Act
            OrderItem item = order.getItemByProductId(productId);
            
            // Assert
            assertThat(item).isNull();
        }
        
        @Test
        @DisplayName(&quot;Should check if order has item&quot;)
        void shouldCheckIfOrderHasItem() {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            order.addItem(productId, 2, Money.of(15.99, &quot;USD&quot;));
            
            // Act &amp; Assert
            assertThat(order.hasItem(productId)).isTrue();
            assertThat(order.hasItem(ProductId.of(&quot;product-2&quot;))).isFalse();
        }
    }
    
    @Nested
    @DisplayName(&quot;Order Edge Case Tests&quot;)
    class OrderEdgeCaseTests {
        
        @Test
        @DisplayName(&quot;Should handle minimum order amount&quot;)
        void shouldHandleMinimumOrderAmount() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(10.00, &quot;USD&quot;)); // Exactly $10
            
            // Act
            order.confirm();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CONFIRMED);
        }
        
        @Test
        @DisplayName(&quot;Should handle large order amounts&quot;)
        void shouldHandleLargeOrderAmounts() {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 100, Money.of(100.00, &quot;USD&quot;)); // $10,000
            
            // Act
            order.confirm();
            
            // Assert
            assertThat(order.getStatus()).isEqualTo(OrderStatus.CONFIRMED);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(10000.00, &quot;USD&quot;));
        }
        
        @Test
        @DisplayName(&quot;Should handle many items&quot;)
        void shouldHandleManyItems() {
            // Act
            for (int i = 1; i &lt;= 100; i++) {
                order.addItem(ProductId.of(&quot;product-&quot; + i), 1, Money.of(1.00, &quot;USD&quot;));
            }
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(100);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(100.00, &quot;USD&quot;));
        }
    }
    
    @Nested
    @DisplayName(&quot;Order Parameterized Tests&quot;)
    class OrderParameterizedTests {
        
        @ParameterizedTest
        @ValueSource(ints = {1, 2, 5, 10, 100})
        @DisplayName(&quot;Should add item with different quantities&quot;)
        void shouldAddItemWithDifferentQuantities(int quantity) {
            // Arrange
            ProductId productId = ProductId.of(&quot;product-1&quot;);
            Money unitPrice = Money.of(10.00, &quot;USD&quot;);
            
            // Act
            order.addItem(productId, quantity, unitPrice);
            
            // Assert
            assertThat(order.getItemCount()).isEqualTo(1);
            assertThat(order.getTotalAmount()).isEqualTo(Money.of(quantity * 10.00, &quot;USD&quot;));
        }
        
        @ParameterizedTest
        @CsvSource({
            &quot;10.00, true&quot;,
            &quot;9.99, false&quot;,
            &quot;100.00, true&quot;,
            &quot;0.01, false&quot;
        })
        @DisplayName(&quot;Should validate minimum order amount&quot;)
        void shouldValidateMinimumOrderAmount(double amount, boolean canConfirm) {
            // Arrange
            order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(amount, &quot;USD&quot;));
            
            // Act &amp; Assert
            if (canConfirm) {
                assertDoesNotThrow(() -&gt; order.confirm());
                assertThat(order.getStatus()).isEqualTo(OrderStatus.CONFIRMED);
            } else {
                assertThrows(IllegalStateException.class, () -&gt; order.confirm());
                assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
            }
        }
    }
}

// ✅ GOOD: Order Factory Tests
@DisplayName(&quot;Order Factory Tests&quot;)
class OrderFactoryTest {
    
    @Test
    @DisplayName(&quot;Should create draft order&quot;)
    void shouldCreateDraftOrder() {
        // Arrange
        CustomerId customerId = CustomerId.of(&quot;customer-123&quot;);
        
        // Act
        Order order = OrderFactory.createDraftOrder(customerId);
        
        // Assert
        assertThat(order.getCustomerId()).isEqualTo(customerId);
        assertThat(order.getStatus()).isEqualTo(OrderStatus.DRAFT);
        assertThat(order.getItemCount()).isEqualTo(0);
    }
    
    @Test
    @DisplayName(&quot;Should create order from cart items&quot;)
    void shouldCreateOrderFromCartItems() {
        // Arrange
        CustomerId customerId = CustomerId.of(&quot;customer-123&quot;);
        List&lt;CartItem&gt; cartItems = List.of(
            new CartItem(&quot;product-1&quot;, 2, 15.99),
            new CartItem(&quot;product-2&quot;, 1, 25.50)
        );
        
        // Act
        Order order = OrderFactory.createOrderFromCart(customerId, cartItems);
        
        // Assert
        assertThat(order.getCustomerId()).isEqualTo(customerId);
        assertThat(order.getItemCount()).isEqualTo(2);
        assertThat(order.getTotalAmount()).isEqualTo(Money.of(57.48, &quot;USD&quot;));
    }
}

// ✅ GOOD: Order Specification Tests
@DisplayName(&quot;Order Specification Tests&quot;)
class OrderSpecificationTest {
    
    private OrderSpecification orderSpec;
    
    @BeforeEach
    void setUp() {
        orderSpec = new OrderSpecification();
    }
    
    @Test
    @DisplayName(&quot;Should confirm order when all criteria are met&quot;)
    void shouldConfirmOrderWhenAllCriteriaAreMet() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
        
        // Act &amp; Assert
        assertThat(orderSpec.canBeConfirmed(order)).isTrue();
    }
    
    @Test
    @DisplayName(&quot;Should not confirm order when criteria are not met&quot;)
    void shouldNotConfirmOrderWhenCriteriaAreNotMet() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        
        // Act &amp; Assert
        assertThat(orderSpec.canBeConfirmed(order)).isFalse();
    }
    
    @Test
    @DisplayName(&quot;Should ship order when all criteria are met&quot;)
    void shouldShipOrderWhenAllCriteriaAreMet() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        order.addItem(ProductId.of(&quot;product-1&quot;), 1, Money.of(15.99, &quot;USD&quot;));
        order.confirm();
        
        // Act &amp; Assert
        assertThat(orderSpec.canBeShipped(order)).isTrue();
    }
    
    @Test
    @DisplayName(&quot;Should not ship order when criteria are not met&quot;)
    void shouldNotShipOrderWhenCriteriaAreNotMet() {
        // Arrange
        Order order = new Order(OrderId.generate(), CustomerId.of(&quot;customer-123&quot;));
        
        // Act &amp; Assert
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
        CustomerId customerId = CustomerId.of(&quot;customer-123&quot;);
        Order order = OrderFactory.createDraftOrder(customerId);
        
        // Add items
        ProductId product1 = ProductId.of(&quot;product-1&quot;);
        ProductId product2 = ProductId.of(&quot;product-2&quot;);
        
        order.addItem(product1, 2, Money.of(15.99, &quot;USD&quot;));
        order.addItem(product2, 1, Money.of(25.50, &quot;USD&quot;));
        
        System.out.println(&quot;Order created: &quot; + order);
        System.out.println(&quot;Total amount: &quot; + order.getTotalAmount());
        System.out.println(&quot;Can be confirmed: &quot; + order.canBeConfirmed());
        
        // Confirm order
        order.confirm();
        System.out.println(&quot;Order confirmed: &quot; + order);
        System.out.println(&quot;Can be shipped: &quot; + order.canBeShipped());
        
        // Ship order
        order.ship();
        System.out.println(&quot;Order shipped: &quot; + order);
        System.out.println(&quot;Can be delivered: &quot; + order.canBeDelivered());
        
        // Deliver order
        order.deliver();
        System.out.println(&quot;Order delivered: &quot; + order);
        
        // Test specification
        OrderSpecification orderSpec = new OrderSpecification();
        System.out.println(&quot;Order can be confirmed: &quot; + orderSpec.canBeConfirmed(order));
        System.out.println(&quot;Order can be shipped: &quot; + orderSpec.canBeShipped(order));
    }
}
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Pure Domain Logic is Easily Testable</h3>
<h4>1. <strong>Comprehensive Test Coverage</strong></h4>
<ul>
<li>✅ Tests cover all public methods and properties</li>
<li>✅ Edge cases and error conditions are tested</li>
<li>✅ State transitions and business rules are verified</li>
</ul>
<h4>2. <strong>Business Rule Testing</strong></h4>
<ul>
<li>✅ Tests verify business rules are enforced</li>
<li>✅ Invalid operations are properly rejected</li>
<li>✅ Business logic behavior is consistent</li>
</ul>
<h4>3. <strong>State Management Testing</strong></h4>
<ul>
<li>✅ Order state transitions are tested</li>
<li>✅ State-dependent operations are verified</li>
<li>✅ Invalid state transitions are prevented</li>
</ul>
<h4>4. <strong>Domain Event Testing</strong></h4>
<ul>
<li>✅ Domain events are raised correctly</li>
<li>✅ Events reflect significant business changes</li>
<li>✅ Event sequence is verified</li>
</ul>
<h3>Order Entity Testing Principles</h3>
<h4><strong>Test Business Rules</strong></h4>
<ul>
<li>✅ Order confirmation rules are tested</li>
<li>✅ Item addition rules are verified</li>
<li>✅ State transition rules are tested</li>
</ul>
<h4><strong>Test Error Conditions</strong></h4>
<ul>
<li>✅ Invalid inputs are properly rejected</li>
<li>✅ Business rule violations are handled</li>
<li>✅ Error messages are clear and descriptive</li>
</ul>
<h4><strong>Test State Transitions</strong></h4>
<ul>
<li>✅ Order state transitions are tested</li>
<li>✅ State-dependent operations are verified</li>
<li>✅ Invalid transitions are prevented</li>
</ul>
<h4><strong>Test Edge Cases</strong></h4>
<ul>
<li>✅ Boundary conditions are tested</li>
<li>✅ Large orders are handled</li>
<li>✅ Many items are supported</li>
</ul>
<h3>Java Testing Benefits</h3>
<ul>
<li><strong>JUnit 5</strong>: Modern testing framework with annotations</li>
<li><strong>AssertJ</strong>: Fluent assertions for better readability</li>
<li><strong>Parameterized Tests</strong>: Test multiple scenarios efficiently</li>
<li><strong>Nested Tests</strong>: Organize tests by functionality</li>
<li><strong>Display Names</strong>: Clear test descriptions</li>
<li><strong>Error Handling</strong>: Clear exception messages for business rules</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Incomplete Test Coverage</strong></h4>
<ul>
<li>❌ Tests that don&#39;t cover all methods</li>
<li>❌ Tests that miss edge cases</li>
<li>❌ Tests that don&#39;t verify error conditions</li>
</ul>
<h4><strong>Testing Implementation Details</strong></h4>
<ul>
<li>❌ Tests that verify internal implementation</li>
<li>❌ Tests that break when implementation changes</li>
<li>❌ Tests that don&#39;t verify business behavior</li>
</ul>
<h4><strong>Over-Mocking</strong></h4>
<ul>
<li>❌ Mocking domain objects instead of testing real behavior</li>
<li>❌ Tests that don&#39;t verify actual business logic</li>
<li>❌ Tests that are hard to maintain</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity being tested</li>
<li><a href="./08-money-tests.md">Money Tests</a> - Value object tests</li>
<li><a href="./09-pricing-service-tests.md">Pricing Service Tests</a> - Domain service tests</li>
<li><a href="../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable">Pure Domain Logic is Easily Testable</a> - Testing concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 06-customer-module.md</li>
<li>Next: 08-money-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable">Pure Domain Logic is Easily Testable</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/java/07-order-tests","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"07-order-tests"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"java\",\"07-order-tests\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/java/07-order-tests","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
