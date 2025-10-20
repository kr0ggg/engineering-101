1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/typescript/07-order-tests","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"07-order-tests\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T38af,<h1>Order Tests - TypeScript Example (Jest)</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable">Domain-Driven Design and Unit Testing - Pure Domain Logic</a></p>
<p><strong>Navigation</strong>: <a href="./06-customer-module.md">← Previous: Customer Module</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./08-money-tests.md">Next: Money Tests →</a></p>
<hr>
<pre><code class="language-typescript">// TypeScript Example - Order Tests (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/07-order-tests.ts

import { Order, OrderId, CustomerId, ProductId, OrderStatus, OrderItem } from &#39;./03-order-entity&#39;;
import { Money } from &#39;./02-money-value-object&#39;;

describe(&#39;Order Entity&#39;, () =&gt; {
    let orderId: OrderId;
    let customerId: CustomerId;
    let productId: ProductId;
    let order: Order;

    beforeEach(() =&gt; {
        orderId = new OrderId(&#39;order-123&#39;);
        customerId = new CustomerId(&#39;customer-456&#39;);
        productId = new ProductId(&#39;product-789&#39;);
        order = new Order(orderId, customerId);
    });

    describe(&#39;Order Creation&#39;, () =&gt; {
        it(&#39;should create order with correct initial state&#39;, () =&gt; {
            expect(order.id).toBe(orderId);
            expect(order.customerId).toBe(customerId);
            expect(order.status).toBe(OrderStatus.Draft);
            expect(order.items).toHaveLength(0);
            expect(order.totalAmount.equals(Money.zero(&#39;USD&#39;))).toBe(true);
            expect(order.itemCount).toBe(0);
        });

        it(&#39;should have correct creation date&#39;, () =&gt; {
            const now = new Date();
            const timeDiff = Math.abs(order.createdAt.getTime() - now.getTime());
            expect(timeDiff).toBeLessThan(1000); // Within 1 second
        });
    });

    describe(&#39;Adding Items&#39;, () =&gt; {
        it(&#39;should add item to draft order&#39;, () =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            
            order.addItem(productId, 2, unitPrice);
            
            expect(order.items).toHaveLength(1);
            expect(order.itemCount).toBe(1);
            expect(order.totalAmount.equals(Money.fromAmount(50.00, &#39;USD&#39;))).toBe(true);
        });

        it(&#39;should update quantity when adding existing product&#39;, () =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            
            order.addItem(productId, 2, unitPrice);
            order.addItem(productId, 3, unitPrice);
            
            expect(order.items).toHaveLength(1);
            expect(order.items[0].quantity).toBe(5);
            expect(order.totalAmount.equals(Money.fromAmount(125.00, &#39;USD&#39;))).toBe(true);
        });

        it(&#39;should throw error when adding item to confirmed order&#39;, () =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            
            expect(() =&gt; {
                order.addItem(productId, 1, unitPrice);
            }).toThrow(&#39;Cannot modify confirmed order&#39;);
        });

        it(&#39;should throw error for invalid quantity&#39;, () =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            
            expect(() =&gt; {
                order.addItem(productId, 0, unitPrice);
            }).toThrow(&#39;Quantity must be positive&#39;);
            
            expect(() =&gt; {
                order.addItem(productId, -1, unitPrice);
            }).toThrow(&#39;Quantity must be positive&#39;);
        });
    });

    describe(&#39;Removing Items&#39;, () =&gt; {
        beforeEach(() =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
        });

        it(&#39;should remove item from draft order&#39;, () =&gt; {
            order.removeItem(productId);
            
            expect(order.items).toHaveLength(0);
            expect(order.totalAmount.equals(Money.zero(&#39;USD&#39;))).toBe(true);
        });

        it(&#39;should not throw error when removing non-existent item&#39;, () =&gt; {
            const nonExistentProductId = new ProductId(&#39;non-existent&#39;);
            
            expect(() =&gt; {
                order.removeItem(nonExistentProductId);
            }).not.toThrow();
        });

        it(&#39;should throw error when removing item from confirmed order&#39;, () =&gt; {
            order.confirm();
            
            expect(() =&gt; {
                order.removeItem(productId);
            }).toThrow(&#39;Cannot modify confirmed order&#39;);
        });
    });

    describe(&#39;Updating Item Quantity&#39;, () =&gt; {
        beforeEach(() =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
        });

        it(&#39;should update item quantity in draft order&#39;, () =&gt; {
            order.updateItemQuantity(productId, 5);
            
            expect(order.items[0].quantity).toBe(5);
            expect(order.totalAmount.equals(Money.fromAmount(125.00, &#39;USD&#39;))).toBe(true);
        });

        it(&#39;should throw error for invalid quantity&#39;, () =&gt; {
            expect(() =&gt; {
                order.updateItemQuantity(productId, 0);
            }).toThrow(&#39;Quantity must be positive&#39;);
        });

        it(&#39;should throw error when updating confirmed order&#39;, () =&gt; {
            order.confirm();
            
            expect(() =&gt; {
                order.updateItemQuantity(productId, 5);
            }).toThrow(&#39;Cannot modify confirmed order&#39;);
        });
    });

    describe(&#39;Order Confirmation&#39;, () =&gt; {
        it(&#39;should confirm order with items&#39;, () =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
            
            order.confirm();
            
            expect(order.status).toBe(OrderStatus.Confirmed);
        });

        it(&#39;should throw error when confirming empty order&#39;, () =&gt; {
            expect(() =&gt; {
                order.confirm();
            }).toThrow(&#39;Cannot confirm empty order&#39;);
        });

        it(&#39;should throw error when confirming non-draft order&#39;, () =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            
            expect(() =&gt; {
                order.confirm();
            }).toThrow(&#39;Order is not in draft status&#39;);
        });
    });

    describe(&#39;Order Status Transitions&#39;, () =&gt; {
        beforeEach(() =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
            order.confirm();
        });

        it(&#39;should transition from confirmed to shipped&#39;, () =&gt; {
            order.ship();
            expect(order.status).toBe(OrderStatus.Shipped);
        });

        it(&#39;should transition from shipped to delivered&#39;, () =&gt; {
            order.ship();
            order.deliver();
            expect(order.status).toBe(OrderStatus.Delivered);
        });

        it(&#39;should allow cancellation before delivery&#39;, () =&gt; {
            order.cancel();
            expect(order.status).toBe(OrderStatus.Cancelled);
        });

        it(&#39;should throw error when shipping non-confirmed order&#39;, () =&gt; {
            const newOrder = new Order(new OrderId(&#39;order-456&#39;), customerId);
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            newOrder.addItem(productId, 2, unitPrice);
            
            expect(() =&gt; {
                newOrder.ship();
            }).toThrow(&#39;Order must be confirmed before shipping&#39;);
        });

        it(&#39;should throw error when delivering non-shipped order&#39;, () =&gt; {
            expect(() =&gt; {
                order.deliver();
            }).toThrow(&#39;Order must be shipped before delivery&#39;);
        });

        it(&#39;should throw error when cancelling delivered order&#39;, () =&gt; {
            order.ship();
            order.deliver();
            
            expect(() =&gt; {
                order.cancel();
            }).toThrow(&#39;Cannot cancel delivered order&#39;);
        });
    });

    describe(&#39;Business Rules&#39;, () =&gt; {
        it(&#39;should correctly identify modifiable orders&#39;, () =&gt; {
            expect(order.canBeModified()).toBe(true);
            
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            
            expect(order.canBeModified()).toBe(false);
        });

        it(&#39;should correctly identify confirmable orders&#39;, () =&gt; {
            expect(order.canBeConfirmed()).toBe(false);
            
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
            
            expect(order.canBeConfirmed()).toBe(true);
        });

        it(&#39;should correctly identify shippable orders&#39;, () =&gt; {
            expect(order.canBeShipped()).toBe(false);
            
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            
            expect(order.canBeShipped()).toBe(true);
        });

        it(&#39;should correctly identify deliverable orders&#39;, () =&gt; {
            expect(order.canBeDelivered()).toBe(false);
            
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            order.ship();
            
            expect(order.canBeDelivered()).toBe(true);
        });

        it(&#39;should correctly identify cancellable orders&#39;, () =&gt; {
            expect(order.canBeCancelled()).toBe(true);
            
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            order.addItem(productId, 2, unitPrice);
            order.confirm();
            order.ship();
            order.deliver();
            
            expect(order.canBeCancelled()).toBe(false);
        });
    });

    describe(&#39;Order Items&#39;, () =&gt; {
        it(&#39;should create order item with correct properties&#39;, () =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            const item = new OrderItem(productId, 2, unitPrice);
            
            expect(item.productId).toBe(productId);
            expect(item.quantity).toBe(2);
            expect(item.unitPrice).toBe(unitPrice);
            expect(item.totalPrice.equals(Money.fromAmount(50.00, &#39;USD&#39;))).toBe(true);
        });

        it(&#39;should throw error for invalid item quantity&#39;, () =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            
            expect(() =&gt; {
                new OrderItem(productId, 0, unitPrice);
            }).toThrow(&#39;Quantity must be positive&#39;);
        });

        it(&#39;should correctly compare order items&#39;, () =&gt; {
            const unitPrice = Money.fromAmount(25.00, &#39;USD&#39;);
            const item1 = new OrderItem(productId, 2, unitPrice);
            const item2 = new OrderItem(productId, 2, unitPrice);
            const item3 = new OrderItem(productId, 3, unitPrice);
            
            expect(item1.equals(item2)).toBe(true);
            expect(item1.equals(item3)).toBe(false);
        });
    });
});
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Pure Domain Logic Testing</h3>
<ul>
<li><strong>No External Dependencies</strong>: Tests run without databases or external services</li>
<li><strong>Fast Execution</strong>: Tests run quickly without I/O operations</li>
<li><strong>Deterministic Results</strong>: Same inputs always produce same outputs</li>
<li><strong>Easy Setup</strong>: Simple object creation and method calls</li>
</ul>
<h3>Test Categories</h3>
<ol>
<li><strong>Creation Tests</strong>: Order initialization and default state</li>
<li><strong>Item Management</strong>: Adding, removing, and updating items</li>
<li><strong>Status Transitions</strong>: Order state changes and business rules</li>
<li><strong>Business Rules</strong>: Validation of business constraints</li>
<li><strong>Edge Cases</strong>: Error conditions and boundary cases</li>
</ol>
<h3>Jest Testing Features Used</h3>
<ul>
<li><strong>describe/it blocks</strong>: Organized test structure</li>
<li><strong>beforeEach</strong>: Test setup and data preparation</li>
<li><strong>expect assertions</strong>: Clear and readable assertions</li>
<li><strong>Error testing</strong>: Verifying exception handling</li>
<li><strong>Async/await</strong>: Modern JavaScript testing patterns</li>
</ul>
<h3>Testing Best Practices Shown</h3>
<ul>
<li><strong>Descriptive Names</strong>: Test names clearly describe the scenario</li>
<li><strong>Single Responsibility</strong>: Each test focuses on one behavior</li>
<li><strong>Clear Assertions</strong>: Specific assertions about expected outcomes</li>
<li><strong>Proper Setup</strong>: Clean arrange phase with test data</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./03-order-entity.md">Order Entity</a> - The entity being tested</li>
<li><a href="./08-money-tests.md">Money Tests</a> - Testing value objects</li>
<li><a href="./10-customer-service-tests.md">Customer Service Tests</a> - Testing with mocks</li>
<li><a href="../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing">Unit Testing Best Practices</a></li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 06-customer-module.md</li>
<li>Next: 08-money-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#pure-domain-logic-is-easily-testable">Domain-Driven Design and Unit Testing - Pure Domain Logic is Easily Testable</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/typescript/07-order-tests","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"07-order-tests"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"07-order-tests\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/typescript/07-order-tests","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
