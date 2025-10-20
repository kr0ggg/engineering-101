1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"09-pricing-service-tests\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T404e,<h1>Pricing Service Tests - TypeScript Example (Jest)</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#domain-services-enable-focused-testing">Domain-Driven Design and Unit Testing - Domain Services</a></p>
<p><strong>Navigation</strong>: <a href="./08-money-tests.md">← Previous: Money Tests</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./10-customer-service-tests.md">Next: Customer Service Tests →</a></p>
<hr>
<pre><code class="language-typescript">// TypeScript Example - Pricing Service Tests (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests.ts

import { PricingService, Customer, Address } from &#39;./05-pricing-service&#39;;
import { Money } from &#39;./02-money-value-object&#39;;
import { Order, OrderId, CustomerId, ProductId } from &#39;./03-order-entity&#39;;

describe(&#39;Pricing Service&#39;, () =&gt; {
    let pricingService: PricingService;
    let standardCustomer: Customer;
    let premiumCustomer: Customer;
    let vipCustomer: Customer;
    let californiaAddress: Address;
    let newYorkAddress: Address;
    let texasAddress: Address;

    beforeEach(() =&gt; {
        pricingService = new PricingService();
        
        standardCustomer = {
            id: &#39;customer-1&#39;,
            type: &#39;Standard&#39;,
            isActive: true
        };
        
        premiumCustomer = {
            id: &#39;customer-2&#39;,
            type: &#39;Premium&#39;,
            isActive: true
        };
        
        vipCustomer = {
            id: &#39;customer-3&#39;,
            type: &#39;VIP&#39;,
            isActive: true
        };
        
        californiaAddress = { state: &#39;CA&#39;, country: &#39;US&#39; };
        newYorkAddress = { state: &#39;NY&#39;, country: &#39;US&#39; };
        texasAddress = { state: &#39;TX&#39;, country: &#39;US&#39; };
    });

    describe(&#39;Order Total Calculation&#39;, () =&gt; {
        it(&#39;should calculate total for standard customer&#39;, () =&gt; {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                standardCustomer,
                californiaAddress
            );
            
            // Base: $50, Customer discount (5%): $47.50, Tax (8.75%): $51.66, Shipping: $9.99
            expect(total.amount).toBeCloseTo(61.65, 2);
        });

        it(&#39;should calculate total for premium customer&#39;, () =&gt; {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                premiumCustomer,
                californiaAddress
            );
            
            // Base: $50, Customer discount (10%): $45, Tax (8.75%): $48.94, Shipping: $9.99
            expect(total.amount).toBeCloseTo(58.93, 2);
        });

        it(&#39;should calculate total for VIP customer&#39;, () =&gt; {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                vipCustomer,
                californiaAddress
            );
            
            // Base: $50, Customer discount (15%): $42.50, Tax (8.75%): $46.22, Shipping: $9.99
            expect(total.amount).toBeCloseTo(56.21, 2);
        });

        it(&#39;should throw error for inactive customer&#39;, () =&gt; {
            const order = createTestOrder();
            const inactiveCustomer = { ...standardCustomer, isActive: false };
            
            expect(() =&gt; {
                pricingService.calculateOrderTotal(
                    order,
                    inactiveCustomer,
                    californiaAddress
                );
            }).toThrow(&#39;Cannot calculate pricing for inactive customer&#39;);
        });
    });

    describe(&#39;Customer Discounts&#39;, () =&gt; {
        it(&#39;should apply correct discount for standard customer&#39;, () =&gt; {
            const originalAmount = Money.fromAmount(100, &#39;USD&#39;);
            
            const discountAmount = pricingService.calculateDiscountAmount(
                originalAmount,
                standardCustomer
            );
            
            expect(discountAmount.amount).toBe(5); // 5% discount
        });

        it(&#39;should apply correct discount for premium customer&#39;, () =&gt; {
            const originalAmount = Money.fromAmount(100, &#39;USD&#39;);
            
            const discountAmount = pricingService.calculateDiscountAmount(
                originalAmount,
                premiumCustomer
            );
            
            expect(discountAmount.amount).toBe(10); // 10% discount
        });

        it(&#39;should apply correct discount for VIP customer&#39;, () =&gt; {
            const originalAmount = Money.fromAmount(100, &#39;USD&#39;);
            
            const discountAmount = pricingService.calculateDiscountAmount(
                originalAmount,
                vipCustomer
            );
            
            expect(discountAmount.amount).toBe(15); // 15% discount
        });
    });

    describe(&#39;Bulk Discounts&#39;, () =&gt; {
        it(&#39;should apply bulk discount for large orders&#39;, () =&gt; {
            const largeOrder = createLargeOrder(25); // 25 items
            
            const total = pricingService.calculateOrderTotal(
                largeOrder,
                standardCustomer,
                californiaAddress
            );
            
            // Should include 5% bulk discount
            expect(total.amount).toBeLessThan(1000); // Approximate check
        });

        it(&#39;should apply medium bulk discount for medium orders&#39;, () =&gt; {
            const mediumOrder = createMediumOrder(15); // 15 items
            
            const total = pricingService.calculateOrderTotal(
                mediumOrder,
                standardCustomer,
                californiaAddress
            );
            
            // Should include 3% bulk discount
            expect(total.amount).toBeLessThan(500); // Approximate check
        });

        it(&#39;should not apply bulk discount for small orders&#39;, () =&gt; {
            const smallOrder = createTestOrder(); // 2 items
            
            const total = pricingService.calculateOrderTotal(
                smallOrder,
                standardCustomer,
                californiaAddress
            );
            
            // No bulk discount should be applied
            expect(total.amount).toBeGreaterThan(50);
        });
    });

    describe(&#39;Tax Calculations&#39;, () =&gt; {
        it(&#39;should calculate correct tax for California&#39;, () =&gt; {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                standardCustomer,
                californiaAddress
            );
            
            const taxRate = pricingService.getEffectiveTaxRate(californiaAddress);
            expect(taxRate).toBe(0.0875); // 8.75%
        });

        it(&#39;should calculate correct tax for New York&#39;, () =&gt; {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                standardCustomer,
                newYorkAddress
            );
            
            const taxRate = pricingService.getEffectiveTaxRate(newYorkAddress);
            expect(taxRate).toBe(0.08); // 8%
        });

        it(&#39;should calculate correct tax for Texas&#39;, () =&gt; {
            const order = createTestOrder();
            
            const total = pricingService.calculateOrderTotal(
                order,
                standardCustomer,
                texasAddress
            );
            
            const taxRate = pricingService.getEffectiveTaxRate(texasAddress);
            expect(taxRate).toBe(0.0625); // 6.25%
        });

        it(&#39;should use default tax rate for unknown state&#39;, () =&gt; {
            const unknownAddress = { state: &#39;UNKNOWN&#39;, country: &#39;US&#39; };
            
            const taxRate = pricingService.getEffectiveTaxRate(unknownAddress);
            expect(taxRate).toBe(0.05); // Default 5%
        });
    });

    describe(&#39;Shipping Calculations&#39;, () =&gt; {
        it(&#39;should provide free shipping for orders over threshold&#39;, () =&gt; {
            const largeOrder = createLargeOrder(30); // Large order
            
            const isEligible = pricingService.isEligibleForFreeShipping(
                largeOrder,
                californiaAddress
            );
            
            expect(isEligible).toBe(true);
        });

        it(&#39;should not provide free shipping for orders under threshold&#39;, () =&gt; {
            const smallOrder = createTestOrder(); // Small order
            
            const isEligible = pricingService.isEligibleForFreeShipping(
                smallOrder,
                californiaAddress
            );
            
            expect(isEligible).toBe(false);
        });

        it(&#39;should calculate shipping based on order size&#39;, () =&gt; {
            const smallOrder = createTestOrder();
            const mediumOrder = createMediumOrder(8);
            const largeOrder = createLargeOrder(15);
            
            const smallTotal = pricingService.calculateOrderTotal(
                smallOrder,
                standardCustomer,
                californiaAddress
            );
            
            const mediumTotal = pricingService.calculateOrderTotal(
                mediumOrder,
                standardCustomer,
                californiaAddress
            );
            
            const largeTotal = pricingService.calculateOrderTotal(
                largeOrder,
                standardCustomer,
                californiaAddress
            );
            
            // Shipping should increase with order size
            expect(largeTotal.amount).toBeGreaterThan(mediumTotal.amount);
            expect(mediumTotal.amount).toBeGreaterThan(smallTotal.amount);
        });
    });

    describe(&#39;Edge Cases&#39;, () =&gt; {
        it(&#39;should handle zero amount orders&#39;, () =&gt; {
            const emptyOrder = new Order(
                new OrderId(&#39;empty-order&#39;),
                new CustomerId(&#39;customer-1&#39;)
            );
            
            const total = pricingService.calculateOrderTotal(
                emptyOrder,
                standardCustomer,
                californiaAddress
            );
            
            // Should only include shipping
            expect(total.amount).toBeCloseTo(9.99, 2);
        });

        it(&#39;should handle very large orders&#39;, () =&gt; {
            const hugeOrder = createHugeOrder(100);
            
            const total = pricingService.calculateOrderTotal(
                hugeOrder,
                vipCustomer,
                californiaAddress
            );
            
            expect(total.amount).toBeGreaterThan(0);
        });

        it(&#39;should handle orders with single item&#39;, () =&gt; {
            const singleItemOrder = new Order(
                new OrderId(&#39;single-item&#39;),
                new CustomerId(&#39;customer-1&#39;)
            );
            
            singleItemOrder.addItem(
                new ProductId(&#39;product-1&#39;),
                1,
                Money.fromAmount(10, &#39;USD&#39;)
            );
            
            const total = pricingService.calculateOrderTotal(
                singleItemOrder,
                standardCustomer,
                californiaAddress
            );
            
            expect(total.amount).toBeGreaterThan(10);
        });
    });

    // Helper methods
    function createTestOrder(): Order {
        const order = new Order(
            new OrderId(&#39;test-order&#39;),
            new CustomerId(&#39;customer-1&#39;)
        );
        
        order.addItem(
            new ProductId(&#39;product-1&#39;),
            2,
            Money.fromAmount(25, &#39;USD&#39;)
        );
        
        return order;
    }

    function createMediumOrder(itemCount: number): Order {
        const order = new Order(
            new OrderId(&#39;medium-order&#39;),
            new CustomerId(&#39;customer-1&#39;)
        );
        
        for (let i = 0; i &lt; itemCount; i++) {
            order.addItem(
                new ProductId(`product-${i}`),
                1,
                Money.fromAmount(10, &#39;USD&#39;)
            );
        }
        
        return order;
    }

    function createLargeOrder(itemCount: number): Order {
        const order = new Order(
            new OrderId(&#39;large-order&#39;),
            new CustomerId(&#39;customer-1&#39;)
        );
        
        for (let i = 0; i &lt; itemCount; i++) {
            order.addItem(
                new ProductId(`product-${i}`),
                1,
                Money.fromAmount(20, &#39;USD&#39;)
            );
        }
        
        return order;
    }

    function createHugeOrder(itemCount: number): Order {
        const order = new Order(
            new OrderId(&#39;huge-order&#39;),
            new CustomerId(&#39;customer-1&#39;)
        );
        
        for (let i = 0; i &lt; itemCount; i++) {
            order.addItem(
                new ProductId(`product-${i}`),
                1,
                Money.fromAmount(50, &#39;USD&#39;)
            );
        }
        
        return order;
    }
});
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Domain Service Testing</h3>
<ul>
<li><strong>Focused Testing</strong>: Test complex business rules in isolation</li>
<li><strong>Mocked Dependencies</strong>: Use test doubles for external services</li>
<li><strong>Scenario Testing</strong>: Test various business scenarios and edge cases</li>
<li><strong>Integration Testing</strong>: Test how multiple domain objects work together</li>
</ul>
<h3>Test Categories for Pricing Service</h3>
<ol>
<li><strong>Order Total Calculation</strong>: Main pricing calculation method</li>
<li><strong>Customer Discounts</strong>: Different customer type discounts</li>
<li><strong>Bulk Discounts</strong>: Volume-based discount calculations</li>
<li><strong>Tax Calculations</strong>: Tax rates for different states</li>
<li><strong>Shipping Calculations</strong>: Shipping cost and free shipping rules</li>
<li><strong>Edge Cases</strong>: Zero amounts, large orders, single items</li>
</ol>
<h3>Jest Testing Features Used</h3>
<ul>
<li><strong>describe/it blocks</strong>: Organized test structure</li>
<li><strong>beforeEach</strong>: Test setup and data preparation</li>
<li><strong>Helper Functions</strong>: Reusable test data creation</li>
<li><strong>toBeCloseTo</strong>: Precision testing for monetary calculations</li>
<li><strong>Custom Matchers</strong>: Specific assertions for business rules</li>
</ul>
<h3>Testing Best Practices Shown</h3>
<ul>
<li><strong>Helper Methods</strong>: Reusable test data creation</li>
<li><strong>Descriptive Names</strong>: Clear test scenario descriptions</li>
<li><strong>Specific Assertions</strong>: Testing exact business rule outcomes</li>
<li><strong>Scenario Coverage</strong>: Testing different business scenarios</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./05-pricing-service.md">Pricing Service</a> - The service being tested</li>
<li><a href="./03-order-entity.md">Order Entity</a> - Used in pricing calculations</li>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Customer information for pricing</li>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Used for monetary calculations</li>
<li><a href="../../1-introduction-to-the-domain.md#domain-services">Domain Services</a> - Domain service concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 08-money-tests.md</li>
<li>Next: 10-customer-service-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#domain-services-enable-focused-testing">Domain-Driven Design and Unit Testing - Domain Services Enable Focused Testing</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"09-pricing-service-tests"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"09-pricing-service-tests\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
