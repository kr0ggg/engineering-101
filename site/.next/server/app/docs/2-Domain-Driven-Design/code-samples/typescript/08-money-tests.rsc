1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/typescript/08-money-tests","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"08-money-tests\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T40cc,<h1>Money Tests - TypeScript Example (Jest)</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing">Domain-Driven Design and Unit Testing - Value Objects</a></p>
<p><strong>Navigation</strong>: <a href="./07-order-tests.md">← Previous: Order Tests</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./09-pricing-service-tests.md">Next: Pricing Service Tests →</a></p>
<hr>
<pre><code class="language-typescript">// TypeScript Example - Money Tests (Jest)
// File: 2-Domain-Driven-Design/code-samples/typescript/08-money-tests.ts

import { Money } from &#39;./02-money-value-object&#39;;

describe(&#39;Money Value Object&#39;, () =&gt; {
    describe(&#39;Creation and Validation&#39;, () =&gt; {
        it(&#39;should create money with valid amount and currency&#39;, () =&gt; {
            const money = new Money(100.50, &#39;USD&#39;);
            
            expect(money.amount).toBe(100.50);
            expect(money.currency).toBe(&#39;USD&#39;);
        });

        it(&#39;should throw error for negative amount&#39;, () =&gt; {
            expect(() =&gt; {
                new Money(-10.00, &#39;USD&#39;);
            }).toThrow(&#39;Amount cannot be negative&#39;);
        });

        it(&#39;should throw error for empty currency&#39;, () =&gt; {
            expect(() =&gt; {
                new Money(100.00, &#39;&#39;);
            }).toThrow(&#39;Currency cannot be empty&#39;);
        });

        it(&#39;should throw error for null currency&#39;, () =&gt; {
            expect(() =&gt; {
                new Money(100.00, null as any);
            }).toThrow(&#39;Currency cannot be empty&#39;);
        });

        it(&#39;should handle zero amount&#39;, () =&gt; {
            const money = new Money(0, &#39;USD&#39;);
            expect(money.amount).toBe(0);
            expect(money.currency).toBe(&#39;USD&#39;);
        });

        it(&#39;should handle large amounts&#39;, () =&gt; {
            const money = new Money(999999.99, &#39;USD&#39;);
            expect(money.amount).toBe(999999.99);
        });
    });

    describe(&#39;Arithmetic Operations&#39;, () =&gt; {
        let usd100: Money;
        let usd50: Money;
        let eur100: Money;

        beforeEach(() =&gt; {
            usd100 = new Money(100.00, &#39;USD&#39;);
            usd50 = new Money(50.00, &#39;USD&#39;);
            eur100 = new Money(100.00, &#39;EUR&#39;);
        });

        describe(&#39;Addition&#39;, () =&gt; {
            it(&#39;should add same currency amounts&#39;, () =&gt; {
                const result = usd100.add(usd50);
                
                expect(result.amount).toBe(150.00);
                expect(result.currency).toBe(&#39;USD&#39;);
            });

            it(&#39;should throw error when adding different currencies&#39;, () =&gt; {
                expect(() =&gt; {
                    usd100.add(eur100);
                }).toThrow(&#39;Cannot add different currencies&#39;);
            });

            it(&#39;should return new instance (immutability)&#39;, () =&gt; {
                const result = usd100.add(usd50);
                
                expect(result).not.toBe(usd100);
                expect(result).not.toBe(usd50);
                expect(usd100.amount).toBe(100.00); // Original unchanged
            });

            it(&#39;should handle addition with zero&#39;, () =&gt; {
                const zero = new Money(0, &#39;USD&#39;);
                const result = usd100.add(zero);
                
                expect(result.equals(usd100)).toBe(true);
            });
        });

        describe(&#39;Subtraction&#39;, () =&gt; {
            it(&#39;should subtract same currency amounts&#39;, () =&gt; {
                const result = usd100.subtract(usd50);
                
                expect(result.amount).toBe(50.00);
                expect(result.currency).toBe(&#39;USD&#39;);
            });

            it(&#39;should throw error when subtracting different currencies&#39;, () =&gt; {
                expect(() =&gt; {
                    usd100.subtract(eur100);
                }).toThrow(&#39;Cannot subtract different currencies&#39;);
            });

            it(&#39;should handle subtraction resulting in zero&#39;, () =&gt; {
                const result = usd100.subtract(usd100);
                
                expect(result.amount).toBe(0);
                expect(result.currency).toBe(&#39;USD&#39;);
            });

            it(&#39;should handle subtraction resulting in negative (if business allows)&#39;, () =&gt; {
                const result = usd50.subtract(usd100);
                
                expect(result.amount).toBe(-50.00);
                expect(result.currency).toBe(&#39;USD&#39;);
            });
        });

        describe(&#39;Multiplication&#39;, () =&gt; {
            it(&#39;should multiply by positive factor&#39;, () =&gt; {
                const result = usd100.multiply(1.5);
                
                expect(result.amount).toBe(150.00);
                expect(result.currency).toBe(&#39;USD&#39;);
            });

            it(&#39;should multiply by decimal factor&#39;, () =&gt; {
                const result = usd100.multiply(0.1);
                
                expect(result.amount).toBe(10.00);
                expect(result.currency).toBe(&#39;USD&#39;);
            });

            it(&#39;should multiply by zero&#39;, () =&gt; {
                const result = usd100.multiply(0);
                
                expect(result.amount).toBe(0);
                expect(result.currency).toBe(&#39;USD&#39;);
            });

            it(&#39;should throw error for negative factor&#39;, () =&gt; {
                expect(() =&gt; {
                    usd100.multiply(-1);
                }).toThrow(&#39;Factor cannot be negative&#39;);
            });

            it(&#39;should handle multiplication with large factors&#39;, () =&gt; {
                const result = usd100.multiply(1000);
                
                expect(result.amount).toBe(100000.00);
                expect(result.currency).toBe(&#39;USD&#39;);
            });
        });

        describe(&#39;Division&#39;, () =&gt; {
            it(&#39;should divide by positive divisor&#39;, () =&gt; {
                const result = usd100.divide(2);
                
                expect(result.amount).toBe(50.00);
                expect(result.currency).toBe(&#39;USD&#39;);
            });

            it(&#39;should divide by decimal divisor&#39;, () =&gt; {
                const result = usd100.divide(0.5);
                
                expect(result.amount).toBe(200.00);
                expect(result.currency).toBe(&#39;USD&#39;);
            });

            it(&#39;should throw error for zero divisor&#39;, () =&gt; {
                expect(() =&gt; {
                    usd100.divide(0);
                }).toThrow(&#39;Cannot divide by zero&#39;);
            });

            it(&#39;should throw error for negative divisor&#39;, () =&gt; {
                expect(() =&gt; {
                    usd100.divide(-2);
                }).toThrow(&#39;Divisor cannot be negative&#39;);
            });
        });
    });

    describe(&#39;Comparison Operations&#39;, () =&gt; {
        let usd100: Money;
        let usd50: Money;
        let usd100_2: Money;
        let eur100: Money;

        beforeEach(() =&gt; {
            usd100 = new Money(100.00, &#39;USD&#39;);
            usd50 = new Money(50.00, &#39;USD&#39;);
            usd100_2 = new Money(100.00, &#39;USD&#39;);
            eur100 = new Money(100.00, &#39;EUR&#39;);
        });

        describe(&#39;Equality&#39;, () =&gt; {
            it(&#39;should be equal to same amount and currency&#39;, () =&gt; {
                expect(usd100.equals(usd100_2)).toBe(true);
            });

            it(&#39;should not be equal to different amount&#39;, () =&gt; {
                expect(usd100.equals(usd50)).toBe(false);
            });

            it(&#39;should not be equal to different currency&#39;, () =&gt; {
                expect(usd100.equals(eur100)).toBe(false);
            });

            it(&#39;should be equal to itself&#39;, () =&gt; {
                expect(usd100.equals(usd100)).toBe(true);
            });
        });

        describe(&#39;Greater Than&#39;, () =&gt; {
            it(&#39;should be greater than smaller amount&#39;, () =&gt; {
                expect(usd100.isGreaterThan(usd50)).toBe(true);
            });

            it(&#39;should not be greater than equal amount&#39;, () =&gt; {
                expect(usd100.isGreaterThan(usd100_2)).toBe(false);
            });

            it(&#39;should not be greater than larger amount&#39;, () =&gt; {
                expect(usd50.isGreaterThan(usd100)).toBe(false);
            });

            it(&#39;should throw error when comparing different currencies&#39;, () =&gt; {
                expect(() =&gt; {
                    usd100.isGreaterThan(eur100);
                }).toThrow(&#39;Cannot compare different currencies&#39;);
            });
        });

        describe(&#39;Less Than&#39;, () =&gt; {
            it(&#39;should be less than larger amount&#39;, () =&gt; {
                expect(usd50.isLessThan(usd100)).toBe(true);
            });

            it(&#39;should not be less than equal amount&#39;, () =&gt; {
                expect(usd100.isLessThan(usd100_2)).toBe(false);
            });

            it(&#39;should not be less than smaller amount&#39;, () =&gt; {
                expect(usd100.isLessThan(usd50)).toBe(false);
            });
        });

        describe(&#39;Greater Than or Equal&#39;, () =&gt; {
            it(&#39;should be greater than or equal to smaller amount&#39;, () =&gt; {
                expect(usd100.isGreaterThanOrEqual(usd50)).toBe(true);
            });

            it(&#39;should be greater than or equal to equal amount&#39;, () =&gt; {
                expect(usd100.isGreaterThanOrEqual(usd100_2)).toBe(true);
            });

            it(&#39;should not be greater than or equal to larger amount&#39;, () =&gt; {
                expect(usd50.isGreaterThanOrEqual(usd100)).toBe(false);
            });
        });

        describe(&#39;Less Than or Equal&#39;, () =&gt; {
            it(&#39;should be less than or equal to larger amount&#39;, () =&gt; {
                expect(usd50.isLessThanOrEqual(usd100)).toBe(true);
            });

            it(&#39;should be less than or equal to equal amount&#39;, () =&gt; {
                expect(usd100.isLessThanOrEqual(usd100_2)).toBe(true);
            });

            it(&#39;should not be less than or equal to smaller amount&#39;, () =&gt; {
                expect(usd100.isLessThanOrEqual(usd50)).toBe(false);
            });
        });
    });

    describe(&#39;Factory Methods&#39;, () =&gt; {
        it(&#39;should create zero amount&#39;, () =&gt; {
            const zero = Money.zero(&#39;USD&#39;);
            
            expect(zero.amount).toBe(0);
            expect(zero.currency).toBe(&#39;USD&#39;);
        });

        it(&#39;should create from amount&#39;, () =&gt; {
            const money = Money.fromAmount(150.75, &#39;EUR&#39;);
            
            expect(money.amount).toBe(150.75);
            expect(money.currency).toBe(&#39;EUR&#39;);
        });

        it(&#39;should create from string amount&#39;, () =&gt; {
            const money = Money.fromString(&#39;99.99&#39;, &#39;GBP&#39;);
            
            expect(money.amount).toBe(99.99);
            expect(money.currency).toBe(&#39;GBP&#39;);
        });

        it(&#39;should throw error for invalid string amount&#39;, () =&gt; {
            expect(() =&gt; {
                Money.fromString(&#39;invalid&#39;, &#39;USD&#39;);
            }).toThrow(&#39;Invalid amount format&#39;);
        });
    });

    describe(&#39;String Representation&#39;, () =&gt; {
        it(&#39;should format as currency string&#39;, () =&gt; {
            const money = new Money(123.45, &#39;USD&#39;);
            
            expect(money.toString()).toBe(&#39;$123.45&#39;);
        });

        it(&#39;should format different currencies correctly&#39;, () =&gt; {
            const eur = new Money(123.45, &#39;EUR&#39;);
            const gbp = new Money(123.45, &#39;GBP&#39;);
            
            expect(eur.toString()).toBe(&#39;€123.45&#39;);
            expect(gbp.toString()).toBe(&#39;£123.45&#39;);
        });

        it(&#39;should handle zero amount formatting&#39;, () =&gt; {
            const zero = Money.zero(&#39;USD&#39;);
            
            expect(zero.toString()).toBe(&#39;$0.00&#39;);
        });
    });

    describe(&#39;Edge Cases&#39;, () =&gt; {
        it(&#39;should handle very small amounts&#39;, () =&gt; {
            const money = new Money(0.01, &#39;USD&#39;);
            
            expect(money.amount).toBe(0.01);
            expect(money.currency).toBe(&#39;USD&#39;);
        });

        it(&#39;should handle very large amounts&#39;, () =&gt; {
            const money = new Money(999999999.99, &#39;USD&#39;);
            
            expect(money.amount).toBe(999999999.99);
            expect(money.currency).toBe(&#39;USD&#39;);
        });

        it(&#39;should handle precision correctly&#39;, () =&gt; {
            const money1 = new Money(0.1, &#39;USD&#39;);
            const money2 = new Money(0.2, &#39;USD&#39;);
            const result = money1.add(money2);
            
            expect(result.amount).toBeCloseTo(0.3, 2);
        });

        it(&#39;should handle currency case insensitivity&#39;, () =&gt; {
            const money1 = new Money(100, &#39;USD&#39;);
            const money2 = new Money(100, &#39;usd&#39;);
            
            expect(money1.equals(money2)).toBe(true);
        });
    });
});
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Value Object Testing</h3>
<ul>
<li><strong>Comprehensive Coverage</strong>: Testing all public methods and edge cases</li>
<li><strong>Validation Testing</strong>: Verifying constructor validation rules</li>
<li><strong>Equality Testing</strong>: Testing value-based equality and hash codes</li>
<li><strong>Immutability Testing</strong>: Ensuring objects cannot be modified after creation</li>
<li><strong>Edge Case Testing</strong>: Testing boundary conditions and invalid inputs</li>
</ul>
<h3>Test Categories for Money</h3>
<ol>
<li><strong>Creation</strong>: Constructor validation and factory methods</li>
<li><strong>Arithmetic</strong>: Addition, subtraction, multiplication, division</li>
<li><strong>Comparison</strong>: Equality, greater than, less than operations</li>
<li><strong>Factory Methods</strong>: Zero, fromAmount, fromString methods</li>
<li><strong>Edge Cases</strong>: Precision, large numbers, currency handling</li>
</ol>
<h3>Jest Testing Features Used</h3>
<ul>
<li><strong>describe/it blocks</strong>: Organized test structure</li>
<li><strong>beforeEach</strong>: Test setup and data preparation</li>
<li><strong>expect assertions</strong>: Clear and readable assertions</li>
<li><strong>Error testing</strong>: Verifying proper exception handling</li>
<li><strong>toBeCloseTo</strong>: Precision testing for decimal numbers</li>
</ul>
<h3>Testing Best Practices Shown</h3>
<ul>
<li><strong>Comprehensive Coverage</strong>: Testing all methods and edge cases</li>
<li><strong>Clear Test Names</strong>: Descriptive names explaining the scenario</li>
<li><strong>Proper Assertions</strong>: Specific assertions about expected behavior</li>
<li><strong>Exception Testing</strong>: Verifying proper exception handling</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./02-money-value-object.md">Money Value Object</a> - The value object being tested</li>
<li><a href="./04-email-address-value-object.md">EmailAddress Value Object</a> - Another value object being tested</li>
<li><a href="./07-order-tests.md">Order Tests</a> - Testing entities</li>
<li><a href="../../1-introduction-to-the-domain.md#value-objects">Value Objects</a> - Value object concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 07-order-tests.md</li>
<li>Next: 09-pricing-service-tests.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#value-objects-enable-comprehensive-testing">Domain-Driven Design and Unit Testing - Value Objects Enable Comprehensive Testing</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/typescript/08-money-tests","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"08-money-tests"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"typescript\",\"08-money-tests\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/typescript/08-money-tests","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
