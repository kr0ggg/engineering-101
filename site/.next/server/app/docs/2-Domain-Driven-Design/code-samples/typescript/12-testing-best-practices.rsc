1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"12-testing-best-practices\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T4d89,<h1>Testing Best Practices - TypeScript Example (Jest)</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing">Best Practices for DDD Unit Testing</a></p>
<p><strong>Navigation</strong>: <a href="./11-testing-anti-patterns.md">← Previous: Testing Anti-Patterns</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./13-domain-modeling-best-practices.md">Next: Domain Modeling Best Practices →</a></p>
<hr>
<pre><code class="language-typescript">// TypeScript Example - Testing Best Practices (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices.ts

import { Customer, CustomerId, CustomerStatus } from &#39;./06-customer-module&#39;;
import { Money } from &#39;./02-money-value-object&#39;;
import { Order, OrderId, ProductId } from &#39;./03-order-entity&#39;;

// ✅ BEST PRACTICE 1: Test Behavior, Not Implementation
describe(&#39;✅ GOOD: Test Behavior, Not Implementation&#39;, () =&gt; {
    it(&#39;should activate customer and make them active&#39;, () =&gt; {
        // ✅ Test what the object does, not how it does it
        const customer = createTestCustomer();
        
        customer.activate();
        
        expect(customer.status).toBe(CustomerStatus.Active);
        expect(customer.isActive()).toBe(true);
        expect(customer.canPlaceOrders()).toBe(true);
    });

    it(&#39;should prevent order modification after confirmation&#39;, () =&gt; {
        // ✅ Test business behavior and constraints
        const order = createTestOrder();
        order.addItem(createTestProductId(), 2, Money.fromAmount(25, &#39;USD&#39;));
        order.confirm();
        
        expect(() =&gt; {
            order.addItem(createTestProductId(), 1, Money.fromAmount(10, &#39;USD&#39;));
        }).toThrow(&#39;Cannot modify confirmed order&#39;);
        
        expect(order.canBeModified()).toBe(false);
    });
});

// ✅ BEST PRACTICE 2: Use Descriptive Test Names
describe(&#39;✅ GOOD: Descriptive Test Names&#39;, () =&gt; {
    it(&#39;should throw error when trying to activate suspended customer&#39;, () =&gt; {
        // ✅ Clear scenario: what we&#39;re testing
        const customer = createTestCustomer();
        customer.suspend();
        
        expect(() =&gt; {
            customer.activate();
        }).toThrow(&#39;Cannot activate suspended customer&#39;);
    });

    it(&#39;should apply 15% discount for VIP customers on orders over $100&#39;, () =&gt; {
        // ✅ Clear business rule being tested
        const vipCustomer = createVipCustomer();
        const largeOrder = createLargeOrder(150); // $150 order
        
        const total = pricingService.calculateOrderTotal(largeOrder, vipCustomer, createTestAddress());
        
        // VIP gets 15% discount: $150 * 0.85 = $127.50
        expect(total.amount).toBeCloseTo(127.50, 2);
    });

    it(&#39;should allow customer to update their own email address&#39;, () =&gt; {
        // ✅ Clear scenario and expected outcome
        const customer = createTestCustomer();
        const newEmail = EmailAddress.fromString(&#39;newemail@example.com&#39;);
        
        const updatedCustomer = customer.updateEmail(newEmail);
        
        expect(updatedCustomer.email.equals(newEmail)).toBe(true);
    });
});

// ✅ BEST PRACTICE 3: Test Edge Cases and Business Rules
describe(&#39;✅ GOOD: Test Edge Cases and Business Rules&#39;, () =&gt; {
    describe(&#39;Order Item Validation&#39;, () =&gt; {
        it(&#39;should throw error for zero quantity&#39;, () =&gt; {
            expect(() =&gt; {
                new OrderItem(
                    createTestProductId(),
                    0, // Invalid quantity
                    Money.fromAmount(25, &#39;USD&#39;)
                );
            }).toThrow(&#39;Quantity must be positive&#39;);
        });

        it(&#39;should throw error for negative quantity&#39;, () =&gt; {
            expect(() =&gt; {
                new OrderItem(
                    createTestProductId(),
                    -1, // Invalid quantity
                    Money.fromAmount(25, &#39;USD&#39;)
                );
            }).toThrow(&#39;Quantity must be positive&#39;);
        });

        it(&#39;should handle maximum allowed quantity&#39;, () =&gt; {
            // ✅ Test boundary conditions
            const maxQuantity = 999999;
            const item = new OrderItem(
                createTestProductId(),
                maxQuantity,
                Money.fromAmount(0.01, &#39;USD&#39;)
            );
            
            expect(item.quantity).toBe(maxQuantity);
        });
    });

    describe(&#39;Money Value Object Edge Cases&#39;, () =&gt; {
        it(&#39;should handle very small amounts&#39;, () =&gt; {
            const smallAmount = Money.fromAmount(0.01, &#39;USD&#39;);
            expect(smallAmount.amount).toBe(0.01);
        });

        it(&#39;should handle very large amounts&#39;, () =&gt; {
            const largeAmount = Money.fromAmount(999999999.99, &#39;USD&#39;);
            expect(largeAmount.amount).toBe(999999999.99);
        });

        it(&#39;should prevent currency mixing in arithmetic&#39;, () =&gt; {
            const usdAmount = Money.fromAmount(100, &#39;USD&#39;);
            const eurAmount = Money.fromAmount(100, &#39;EUR&#39;);
            
            expect(() =&gt; {
                usdAmount.add(eurAmount);
            }).toThrow(&#39;Cannot add different currencies&#39;);
        });
    });
});

// ✅ BEST PRACTICE 4: Keep Tests Simple and Focused
describe(&#39;✅ GOOD: Simple and Focused Tests&#39;, () =&gt; {
    it(&#39;should create customer with valid data&#39;, () =&gt; {
        // ✅ One concept per test
        const customer = new Customer(
            new CustomerId(&#39;customer-1&#39;),
            &#39;John Doe&#39;,
            EmailAddress.fromString(&#39;john@example.com&#39;)
        );
        
        expect(customer.name).toBe(&#39;John Doe&#39;);
        expect(customer.status).toBe(CustomerStatus.Pending);
    });

    it(&#39;should activate customer&#39;, () =&gt; {
        // ✅ One behavior per test
        const customer = createTestCustomer();
        
        customer.activate();
        
        expect(customer.status).toBe(CustomerStatus.Active);
    });

    it(&#39;should deactivate customer&#39;, () =&gt; {
        // ✅ One behavior per test
        const customer = createTestCustomer();
        customer.activate(); // First activate
        
        customer.deactivate();
        
        expect(customer.status).toBe(CustomerStatus.Inactive);
    });
});

// ✅ BEST PRACTICE 5: Use Domain Language in Tests
describe(&#39;✅ GOOD: Domain Language in Tests&#39;, () =&gt; {
    it(&#39;should allow active customer to place orders&#39;, () =&gt; {
        // ✅ Use business terminology
        const activeCustomer = createActiveCustomer();
        
        expect(activeCustomer.canPlaceOrders()).toBe(true);
    });

    it(&#39;should prevent suspended customer from placing orders&#39;, () =&gt; {
        // ✅ Use business terminology
        const suspendedCustomer = createSuspendedCustomer();
        
        expect(suspendedCustomer.canPlaceOrders()).toBe(false);
    });

    it(&#39;should calculate order total including tax and shipping&#39;, () =&gt; {
        // ✅ Use business terminology
        const order = createOrderWithItems();
        const customer = createStandardCustomer();
        const address = createCaliforniaAddress();
        
        const total = pricingService.calculateOrderTotal(order, customer, address);
        
        expect(total.amount).toBeGreaterThan(order.totalAmount.amount);
    });
});

// ✅ BEST PRACTICE 6: Arrange-Act-Assert Pattern
describe(&#39;✅ GOOD: Arrange-Act-Assert Pattern&#39;, () =&gt; {
    it(&#39;should apply bulk discount for large orders&#39;, () =&gt; {
        // ✅ Arrange - Set up test data
        const customer = createStandardCustomer();
        const order = createLargeOrder(25); // 25 items
        const address = createTestAddress();
        
        // ✅ Act - Execute the behavior
        const total = pricingService.calculateOrderTotal(order, customer, address);
        
        // ✅ Assert - Verify the outcome
        expect(total.amount).toBeLessThan(order.totalAmount.amount);
    });

    it(&#39;should prevent order confirmation without items&#39;, () =&gt; {
        // ✅ Arrange
        const emptyOrder = new Order(
            new OrderId(&#39;empty-order&#39;),
            new CustomerId(&#39;customer-1&#39;)
        );
        
        // ✅ Act &amp; Assert
        expect(() =&gt; {
            emptyOrder.confirm();
        }).toThrow(&#39;Cannot confirm empty order&#39;);
    });
});

// ✅ BEST PRACTICE 7: Test Error Conditions
describe(&#39;✅ GOOD: Test Error Conditions&#39;, () =&gt; {
    it(&#39;should throw descriptive error for invalid email&#39;, () =&gt; {
        expect(() =&gt; {
            EmailAddress.fromString(&#39;invalid-email&#39;);
        }).toThrow(&#39;Invalid email address format: invalid-email&#39;);
    });

    it(&#39;should throw error when customer not found&#39;, async () =&gt; {
        const nonExistentId = CustomerId.generate();
        
        await expect(
            customerService.getCustomerById(nonExistentId)
        ).rejects.toThrow(&#39;Customer not found&#39;);
    });

    it(&#39;should throw error for inactive customer pricing&#39;, () =&gt; {
        const inactiveCustomer = createInactiveCustomer();
        const order = createTestOrder();
        
        expect(() =&gt; {
            pricingService.calculateOrderTotal(order, inactiveCustomer, createTestAddress());
        }).toThrow(&#39;Cannot calculate pricing for inactive customer&#39;);
    });
});

// ✅ BEST PRACTICE 8: Use Helper Methods for Test Data
describe(&#39;✅ GOOD: Helper Methods for Test Data&#39;, () =&gt; {
    // ✅ Helper methods make tests readable and maintainable
    function createTestCustomer(): Customer {
        return new Customer(
            new CustomerId(&#39;test-customer&#39;),
            &#39;Test Customer&#39;,
            EmailAddress.fromString(&#39;test@example.com&#39;)
        );
    }

    function createActiveCustomer(): Customer {
        const customer = createTestCustomer();
        customer.activate();
        return customer;
    }

    function createSuspendedCustomer(): Customer {
        const customer = createTestCustomer();
        customer.suspend();
        return customer;
    }

    function createTestOrder(): Order {
        const order = new Order(
            new OrderId(&#39;test-order&#39;),
            new CustomerId(&#39;test-customer&#39;)
        );
        order.addItem(
            createTestProductId(),
            2,
            Money.fromAmount(25, &#39;USD&#39;)
        );
        return order;
    }

    function createTestProductId(): ProductId {
        return new ProductId(&#39;test-product&#39;);
    }

    function createStandardCustomer(): Customer {
        return {
            id: &#39;customer-1&#39;,
            type: &#39;Standard&#39;,
            isActive: true
        };
    }

    function createVipCustomer(): Customer {
        return {
            id: &#39;customer-vip&#39;,
            type: &#39;VIP&#39;,
            isActive: true
        };
    }

    function createInactiveCustomer(): Customer {
        return {
            id: &#39;customer-inactive&#39;,
            type: &#39;Standard&#39;,
            isActive: false
        };
    }

    function createTestAddress(): Address {
        return { state: &#39;CA&#39;, country: &#39;US&#39; };
    }

    function createCaliforniaAddress(): Address {
        return { state: &#39;CA&#39;, country: &#39;US&#39; };
    }

    function createLargeOrder(baseAmount: number): Order {
        const order = new Order(
            new OrderId(&#39;large-order&#39;),
            new CustomerId(&#39;customer-1&#39;)
        );
        
        // Add multiple items to reach the base amount
        const itemCount = Math.ceil(baseAmount / 10);
        for (let i = 0; i &lt; itemCount; i++) {
            order.addItem(
                new ProductId(`product-${i}`),
                1,
                Money.fromAmount(10, &#39;USD&#39;)
            );
        }
        
        return order;
    }

    function createOrderWithItems(): Order {
        const order = new Order(
            new OrderId(&#39;order-with-items&#39;),
            new CustomerId(&#39;customer-1&#39;)
        );
        
        order.addItem(
            new ProductId(&#39;product-1&#39;),
            2,
            Money.fromAmount(25, &#39;USD&#39;)
        );
        
        order.addItem(
            new ProductId(&#39;product-2&#39;),
            1,
            Money.fromAmount(15, &#39;USD&#39;)
        );
        
        return order;
    }
});

// ✅ BEST PRACTICE 9: Test Business Rules Explicitly
describe(&#39;✅ GOOD: Test Business Rules Explicitly&#39;, () =&gt; {
    it(&#39;should enforce customer status business rules&#39;, () =&gt; {
        const customer = createTestCustomer();
        
        // Business rule: Only active customers can place orders
        expect(customer.canPlaceOrders()).toBe(false);
        
        customer.activate();
        expect(customer.canPlaceOrders()).toBe(true);
        
        customer.suspend();
        expect(customer.canPlaceOrders()).toBe(false);
    });

    it(&#39;should enforce order modification business rules&#39;, () =&gt; {
        const order = createTestOrder();
        
        // Business rule: Only draft orders can be modified
        expect(order.canBeModified()).toBe(true);
        
        order.confirm();
        expect(order.canBeModified()).toBe(false);
    });

    it(&#39;should enforce order confirmation business rules&#39;, () =&gt; {
        const emptyOrder = new Order(
            new OrderId(&#39;empty&#39;),
            new CustomerId(&#39;customer-1&#39;)
        );
        
        // Business rule: Orders must have items before confirmation
        expect(emptyOrder.canBeConfirmed()).toBe(false);
        
        emptyOrder.addItem(createTestProductId(), 1, Money.fromAmount(10, &#39;USD&#39;));
        expect(emptyOrder.canBeConfirmed()).toBe(true);
    });
});

// ✅ BEST PRACTICE 10: Use Meaningful Assertions
describe(&#39;✅ GOOD: Meaningful Assertions&#39;, () =&gt; {
    it(&#39;should calculate correct order total&#39;, () =&gt; {
        const order = createTestOrder();
        
        // ✅ Specific assertion about business calculation
        expect(order.totalAmount.equals(Money.fromAmount(50, &#39;USD&#39;))).toBe(true);
    });

    it(&#39;should maintain customer identity after updates&#39;, () =&gt; {
        const customer = createTestCustomer();
        const originalId = customer.id;
        
        const updatedCustomer = customer.updateEmail(
            EmailAddress.fromString(&#39;newemail@example.com&#39;)
        );
        
        // ✅ Specific assertion about identity preservation
        expect(updatedCustomer.id.equals(originalId)).toBe(true);
    });

    it(&#39;should preserve order item equality&#39;, () =&gt; {
        const productId = createTestProductId();
        const unitPrice = Money.fromAmount(25, &#39;USD&#39;);
        
        const item1 = new OrderItem(productId, 2, unitPrice);
        const item2 = new OrderItem(productId, 2, unitPrice);
        
        // ✅ Specific assertion about value equality
        expect(item1.equals(item2)).toBe(true);
    });
});
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Testing Best Practices</h3>
<h4>1. <strong>Test Behavior, Not Implementation</strong></h4>
<ul>
<li>✅ Focus on what the domain object does, not how it does it</li>
<li>✅ Test the observable behavior and outcomes</li>
<li>✅ Avoid testing private fields or internal methods</li>
</ul>
<h4>2. <strong>Use Descriptive Test Names</strong></h4>
<ul>
<li>✅ Test names should clearly express the scenario, action, and expected outcome</li>
<li>✅ Make them readable to business stakeholders</li>
<li>✅ Use domain language in test names</li>
</ul>
<h4>3. <strong>Test Edge Cases and Business Rules</strong></h4>
<ul>
<li>✅ Ensure comprehensive coverage of business rules and boundary conditions</li>
<li>✅ Test both happy paths and error scenarios</li>
<li>✅ Test boundary values and edge cases</li>
</ul>
<h4>4. <strong>Keep Tests Simple and Focused</strong></h4>
<ul>
<li>✅ Each test should validate one concept or business rule</li>
<li>✅ Avoid complex test setups and multiple assertions per test</li>
<li>✅ One behavior per test</li>
</ul>
<h4>5. <strong>Use Domain Language in Tests</strong></h4>
<ul>
<li>✅ Use business terminology in test names and assertions</li>
<li>✅ Make tests more readable and maintainable</li>
<li>✅ Tests serve as living documentation</li>
</ul>
<h4>6. <strong>Arrange-Act-Assert Pattern</strong></h4>
<ul>
<li>✅ Clear structure: Set up test data, execute behavior, verify outcome</li>
<li>✅ Makes tests easy to read and understand</li>
<li>✅ Consistent pattern across all tests</li>
</ul>
<h4>7. <strong>Test Error Conditions</strong></h4>
<ul>
<li>✅ Verify proper exception handling</li>
<li>✅ Test business rule violations</li>
<li>✅ Use descriptive error messages</li>
</ul>
<h4>8. <strong>Use Helper Methods for Test Data</strong></h4>
<ul>
<li>✅ Reusable test data creation</li>
<li>✅ Reduces test duplication</li>
<li>✅ Makes tests more maintainable</li>
</ul>
<h4>9. <strong>Test Business Rules Explicitly</strong></h4>
<ul>
<li>✅ Make business rules visible in tests</li>
<li>✅ Test business constraints and validations</li>
<li>✅ Document business logic through tests</li>
</ul>
<h4>10. <strong>Use Meaningful Assertions</strong></h4>
<ul>
<li>✅ Specific assertions about expected behavior</li>
<li>✅ Test business calculations accurately</li>
<li>✅ Verify domain object properties correctly</li>
</ul>
<h3>Jest Testing Best Practices</h3>
<ul>
<li><strong>Helper Functions</strong>: Reusable test data creation</li>
<li><strong>Descriptive Names</strong>: Clear test scenario descriptions</li>
<li><strong>Specific Assertions</strong>: Testing exact business rule outcomes</li>
<li><strong>Scenario Coverage</strong>: Testing different business scenarios</li>
</ul>
<h3>Benefits of Good Testing Practices</h3>
<ol>
<li><strong>Maintainable</strong>: Tests are easy to understand and modify</li>
<li><strong>Reliable</strong>: Tests provide consistent results</li>
<li><strong>Documentation</strong>: Tests serve as living documentation</li>
<li><strong>Confidence</strong>: Comprehensive coverage builds confidence in changes</li>
<li><strong>Debugging</strong>: Clear test names help identify issues quickly</li>
</ol>
<h2>Related Concepts</h2>
<ul>
<li><a href="./07-order-tests.md">Order Tests</a> - Examples of good testing practices</li>
<li><a href="./08-money-tests.md">Money Tests</a> - Value object testing examples</li>
<li><a href="./10-customer-service-tests.md">Customer Service Tests</a> - Mocking best practices</li>
<li><a href="./11-testing-anti-patterns.md">Testing Anti-Patterns</a> - What to avoid</li>
<li><a href="../../1-introduction-to-the-domain.md#benefits-of-ddd-for-unit-testing">Unit Testing Benefits</a></li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 11-testing-anti-patterns.md</li>
<li>Next: 13-domain-modeling-best-practices.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#best-practices-for-ddd-unit-testing">Best Practices for DDD Unit Testing</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"12-testing-best-practices"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"12-testing-best-practices\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
