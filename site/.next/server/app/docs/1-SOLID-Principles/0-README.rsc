1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","1-SOLID-Principles/0-README","c"],{"children":["__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"0-README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T599b,<h1>SOLID Principles: A Comprehensive Guide</h1>
<h2>Introduction</h2>
<p>The SOLID principles are a set of five design principles introduced by Robert C. Martin (Uncle Bob) that aim to make software designs more understandable, flexible, and maintainable. These principles serve as fundamental guidelines for writing clean, robust, and scalable code.</p>
<h2>What are the SOLID Principles?</h2>
<p>SOLID is an acronym that stands for:</p>
<ol>
<li><strong>S</strong> - Single Responsibility Principle (SRP)</li>
<li><strong>O</strong> - Open/Closed Principle (OCP)</li>
<li><strong>L</strong> - Liskov Substitution Principle (LSP)</li>
<li><strong>I</strong> - Interface Segregation Principle (ISP)</li>
<li><strong>D</strong> - Dependency Inversion Principle (DIP)</li>
</ol>
<h2>Theoretical Foundation</h2>
<p>The SOLID principles are grounded in fundamental computer science concepts and software engineering theory:</p>
<h3>Cognitive Load Theory</h3>
<p>Each principle reduces cognitive complexity by limiting the mental effort required to understand and modify code. When developers can focus on single responsibilities, interfaces, or abstractions, they can process information more efficiently and make fewer errors.</p>
<h3>Coupling and Cohesion Theory</h3>
<ul>
<li><strong>Cohesion</strong>: The degree to which elements within a module work together toward a single purpose</li>
<li><strong>Coupling</strong>: The degree of interdependence between modules</li>
<li>SOLID principles maximize cohesion while minimizing coupling, creating more maintainable systems</li>
</ul>
<h3>Information Hiding Principle</h3>
<p>By encapsulating implementation details behind well-defined interfaces, SOLID principles enable modules to change their internal implementation without affecting dependent modules.</p>
<h3>Open-Closed Principle Foundation</h3>
<p>Based on Bertrand Meyer&#39;s work on object-oriented design, the principle enables systems to be extended without modification, reducing the risk of introducing bugs in existing, tested code.</p>
<h3>Behavioral Subtyping</h3>
<p>The Liskov Substitution Principle formalizes the mathematical concept of behavioral subtyping, ensuring that derived classes maintain the contract of their base classes.</p>
<h2>Consequences of Violating SOLID Principles</h2>
<h3>Common Impact Patterns</h3>
<p>Violating SOLID principles leads to several recurring patterns of problems that affect software quality, development velocity, and long-term maintainability:</p>
<h4>Development Velocity Impact</h4>
<ul>
<li><strong>Slower Development</strong>: Coordination overhead when multiple developers need to modify the same files</li>
<li><strong>Increased Debugging Time</strong>: Complex interdependencies make issue resolution more time-consuming</li>
<li><strong>More Frequent Integration Conflicts</strong>: Tight coupling leads to merge conflicts and integration issues</li>
<li><strong>Reduced Confidence in Changes</strong>: Developers become hesitant to make modifications due to unknown side effects</li>
</ul>
<h4>Testing and Quality Issues</h4>
<ul>
<li><strong>Testing Complexity</strong>: Complex test scenarios that must account for multiple responsibilities and dependencies</li>
<li><strong>Difficult-to-Isolate Failures</strong>: Issues can originate from multiple sources, making debugging challenging</li>
<li><strong>Reduced Test Coverage</strong>: Complex code becomes difficult to test comprehensively</li>
<li><strong>Unreliable Tests</strong>: Tests may pass in some contexts but fail in others due to inconsistent behavior</li>
</ul>
<h4>Maintenance Nightmare</h4>
<ul>
<li><strong>Bug Fixes Cascade</strong>: Changes in one area break unrelated functionality</li>
<li><strong>Refactoring Becomes Risky</strong>: Unknown side effects make code changes dangerous</li>
<li><strong>Code Reuse Decreases</strong>: Tightly coupled components can&#39;t be reused independently</li>
<li><strong>Technical Debt Accumulation</strong>: Code smells and anti-patterns accumulate over time</li>
</ul>
<h4>Architecture and Design Problems</h4>
<ul>
<li><strong>Rigid Architecture</strong>: Systems become inflexible and difficult to modify</li>
<li><strong>Tight Coupling</strong>: Components become interdependent, reducing modularity</li>
<li><strong>Reduced Flexibility</strong>: Systems can&#39;t adapt to changing requirements</li>
<li><strong>Deployment Complexity</strong>: Changes require more frequent full system deployments</li>
</ul>
<h3>Principle-Specific Consequences</h3>
<h4>Without Single Responsibility Principle</h4>
<ul>
<li><strong>Code becomes fragile</strong>: Changes in one area break unrelated functionality</li>
<li><strong>Testing becomes complex</strong>: Multiple responsibilities require complex test scenarios</li>
<li><strong>Debugging becomes difficult</strong>: Issues can originate from multiple sources</li>
<li><strong>Code reuse decreases</strong>: Tightly coupled responsibilities can&#39;t be reused independently</li>
</ul>
<h4>Without Open/Closed Principle</h4>
<ul>
<li><strong>High modification risk</strong>: Every new feature requires changing existing, tested code</li>
<li><strong>Regression bugs increase</strong>: Modifications to existing code introduce new bugs</li>
<li><strong>Deployment complexity grows</strong>: Changes to core functionality affect multiple modules</li>
<li><strong>Development velocity decreases</strong>: Teams must coordinate changes across multiple files</li>
</ul>
<h4>Without Liskov Substitution Principle</h4>
<ul>
<li><strong>Runtime errors increase</strong>: Subclasses may not behave as expected when substituted</li>
<li><strong>Polymorphism breaks</strong>: Code relying on polymorphism fails unpredictably</li>
<li><strong>Contract violations</strong>: Derived classes don&#39;t honor the promises made by base classes</li>
<li><strong>Testing becomes unreliable</strong>: Tests may pass with base classes but fail with subclasses</li>
</ul>
<h4>Without Interface Segregation Principle</h4>
<ul>
<li><strong>Unnecessary dependencies</strong>: Classes depend on methods they don&#39;t use</li>
<li><strong>Interface pollution</strong>: Interfaces become bloated with unrelated methods</li>
<li><strong>Implementation complexity</strong>: Classes must implement methods they don&#39;t need</li>
<li><strong>Coupling increases</strong>: Changes to unused interface methods affect dependent classes</li>
</ul>
<h4>Without Dependency Inversion Principle</h4>
<ul>
<li><strong>Rigid architecture</strong>: High-level modules depend on low-level implementation details</li>
<li><strong>Testing becomes difficult</strong>: Hard dependencies make unit testing challenging</li>
<li><strong>Flexibility decreases</strong>: Systems become tightly coupled to specific implementations</li>
<li><strong>Reusability suffers</strong>: Components can&#39;t be easily reused in different contexts</li>
</ul>
<h2>Why SOLID Principles Matter</h2>
<h3>Improved Software Quality</h3>
<ul>
<li><strong>Maintainability</strong>: Code becomes easier to understand, modify, and extend</li>
<li><strong>Readability</strong>: Clear separation of concerns makes code self-documenting</li>
<li><strong>Reliability</strong>: Reduced coupling minimizes the risk of unintended side effects</li>
<li><strong>Consistency</strong>: Standardized approaches lead to predictable code patterns</li>
</ul>
<h3>Lower Cost of Ownership</h3>
<p>SOLID principles significantly reduce the total cost of ownership (TCO) of software systems through multiple mechanisms:</p>
<h4>Development Cost Reduction</h4>
<ul>
<li><strong>Reduced Bug Fixes</strong>: Well-structured code has fewer bugs and easier debugging</li>
<li><strong>Faster Development</strong>: New features can be added without modifying existing code</li>
<li><strong>Easier Refactoring</strong>: Changes are localized and don&#39;t cascade through the system</li>
<li><strong>Reduced Technical Debt</strong>: Clean architecture prevents accumulation of code smells</li>
</ul>
<h4>Maintenance Cost Reduction</h4>
<ul>
<li><strong>Predictable Maintenance</strong>: Changes have known, limited impact scope</li>
<li><strong>Reduced Regression Testing</strong>: Isolated changes require less comprehensive testing</li>
<li><strong>Faster Issue Resolution</strong>: Clear separation of concerns makes debugging more efficient</li>
<li><strong>Lower Support Costs</strong>: More reliable systems require less customer support</li>
</ul>
<h4>Operational Cost Benefits</h4>
<ul>
<li><strong>Reduced Deployment Risk</strong>: Isolated changes reduce production issues</li>
<li><strong>Easier Monitoring</strong>: Clear module boundaries improve observability</li>
<li><strong>Simplified Troubleshooting</strong>: Well-defined interfaces make problem isolation easier</li>
<li><strong>Reduced Downtime</strong>: More stable systems experience fewer outages</li>
</ul>
<h2>Code Maintainability and Static Analysis</h2>
<h3>Understanding Code Maintainability</h3>
<p>Code maintainability refers to the ease with which software can be modified, extended, debugged, and understood. It&#39;s a critical factor in long-term software success and directly impacts development velocity, bug rates, and system reliability.</p>
<h4>Key Maintainability Factors</h4>
<ul>
<li><strong>Readability</strong>: How easily developers can understand the code</li>
<li><strong>Modularity</strong>: Degree to which code is organized into independent modules</li>
<li><strong>Testability</strong>: How easily code can be unit tested</li>
<li><strong>Documentation</strong>: Quality and completeness of code documentation</li>
<li><strong>Complexity</strong>: Cyclomatic complexity and cognitive load</li>
<li><strong>Coupling</strong>: Interdependence between modules</li>
<li><strong>Cohesion</strong>: How well elements within a module work together</li>
</ul>
<h3>Static Code Analysis Tools</h3>
<p>Static code analysis tools automatically examine source code without executing it, identifying potential issues, code smells, and maintainability problems. These tools are essential for maintaining code quality and measuring maintainability improvements.</p>
<h4>Popular Static Analysis Tools</h4>
<p><strong>SonarQube</strong></p>
<ul>
<li>Comprehensive code quality platform</li>
<li>Measures maintainability index, technical debt, and code coverage</li>
<li>Identifies code smells, bugs, and security vulnerabilities</li>
<li>Provides trend analysis and quality gates</li>
<li>Supports multiple programming languages</li>
</ul>
<p><strong>Other Notable Tools</strong></p>
<ul>
<li><strong>ESLint/TSLint</strong>: JavaScript/TypeScript linting</li>
<li><strong>Checkstyle</strong>: Java code style and quality</li>
<li><strong>FxCop/StyleCop</strong>: .NET static analysis</li>
<li><strong>Pylint</strong>: Python code analysis</li>
<li><strong>CodeClimate</strong>: Automated code review</li>
<li><strong>PMD</strong>: Multi-language static analysis</li>
</ul>
<h4>Maintainability Index</h4>
<p>The Maintainability Index is a composite metric that combines:</p>
<ul>
<li><strong>Cyclomatic Complexity</strong>: Measures the number of linearly independent paths</li>
<li><strong>Lines of Code</strong>: Size of the codebase</li>
<li><strong>Halstead Volume</strong>: Measures program complexity based on operators and operands</li>
</ul>
<p><strong>Formula</strong>: <code>MI = 171 - 5.2 * ln(Halstead Volume) - 0.23 * Cyclomatic Complexity - 16.2 * ln(Lines of Code)</code></p>
<p><strong>Score Interpretation</strong>:</p>
<ul>
<li><strong>0-9</strong>: Low maintainability (Red)</li>
<li><strong>10-19</strong>: Moderate maintainability (Yellow)</li>
<li><strong>20-100</strong>: High maintainability (Green)</li>
</ul>
<h3>How SOLID Principles Improve Maintainability Metrics</h3>
<h4>Single Responsibility Principle Impact</h4>
<ul>
<li><strong>Reduces Cyclomatic Complexity</strong>: Single-purpose classes have simpler control flow</li>
<li><strong>Improves Cohesion</strong>: All methods work toward a single goal</li>
<li><strong>Enhances Readability</strong>: Clear, focused class purposes</li>
<li><strong>Reduces Coupling</strong>: Fewer dependencies between classes</li>
</ul>
<h4>Open/Closed Principle Impact</h4>
<ul>
<li><strong>Stabilizes Complexity</strong>: Existing code doesn&#39;t change, reducing volatility</li>
<li><strong>Improves Extensibility</strong>: New features don&#39;t increase existing complexity</li>
<li><strong>Reduces Risk</strong>: Less modification means fewer bugs</li>
<li><strong>Enhances Testability</strong>: Stable interfaces enable better test coverage</li>
</ul>
<h4>Liskov Substitution Principle Impact</h4>
<ul>
<li><strong>Ensures Predictable Behavior</strong>: Subclasses behave consistently</li>
<li><strong>Reduces Runtime Errors</strong>: Polymorphism works reliably</li>
<li><strong>Improves Test Reliability</strong>: Tests work consistently across inheritance hierarchy</li>
<li><strong>Enhances Code Confidence</strong>: Developers can trust inheritance relationships</li>
</ul>
<h4>Interface Segregation Principle Impact</h4>
<ul>
<li><strong>Reduces Interface Complexity</strong>: Smaller, focused interfaces</li>
<li><strong>Minimizes Dependencies</strong>: Clients only depend on what they use</li>
<li><strong>Improves Modularity</strong>: Clear separation of concerns</li>
<li><strong>Enhances Flexibility</strong>: Easy to swap implementations</li>
</ul>
<h4>Dependency Inversion Principle Impact</h4>
<ul>
<li><strong>Reduces Coupling</strong>: High-level modules independent of low-level details</li>
<li><strong>Improves Testability</strong>: Easy to mock dependencies</li>
<li><strong>Enhances Flexibility</strong>: Easy to change implementations</li>
<li><strong>Stabilizes Architecture</strong>: Clear dependency hierarchy</li>
</ul>
<h3>Common Static Analysis Benefits</h3>
<h4>Universal Maintainability Improvements</h4>
<ul>
<li><strong>Higher Maintainability Ratings</strong>: SOLID-compliant code typically achieves A or B ratings</li>
<li><strong>Reduced Technical Debt</strong>: Clean architecture prevents accumulation of code smells</li>
<li><strong>Better Code Coverage</strong>: Modular design enables comprehensive unit testing</li>
<li><strong>Lower Complexity Scores</strong>: Reduced cyclomatic complexity through proper design</li>
</ul>
<h4>Universal Tool Benefits</h4>
<p><strong>ESLint/TSLint (JavaScript/TypeScript)</strong></p>
<ul>
<li>Reduced &quot;complexity&quot; rule violations</li>
<li>Better &quot;max-lines-per-function&quot; compliance</li>
<li>Improved &quot;prefer-const&quot; usage</li>
<li>Better &quot;no-unused-vars&quot; compliance</li>
</ul>
<p><strong>Checkstyle (Java)</strong></p>
<ul>
<li>Better &quot;MethodLength&quot; compliance</li>
<li>Reduced &quot;CyclomaticComplexity&quot; violations</li>
<li>Improved &quot;ClassDataAbstractionCoupling&quot; metrics</li>
<li>Better &quot;VisibilityModifier&quot; compliance</li>
</ul>
<p><strong>FxCop/StyleCop (.NET)</strong></p>
<ul>
<li>Fewer &quot;CA1500&quot; (Avoid excessive class coupling) violations</li>
<li>Better &quot;CA1501&quot; (Avoid excessive inheritance) compliance</li>
<li>Improved &quot;CA1502&quot; (Avoid excessive complexity) scores</li>
<li>Reduced &quot;CA1505&quot; (Avoid unmaintainable code) violations</li>
</ul>
<h4>Universal Quality Gates</h4>
<ul>
<li><strong>Minimum Maintainability Index Thresholds</strong>: Enforce minimum scores</li>
<li><strong>Maximum Cyclomatic Complexity Limits</strong>: Control complexity per method/class</li>
<li><strong>Coupling and Cohesion Requirements</strong>: Ensure proper module design</li>
<li><strong>Code Coverage Targets</strong>: Maintain adequate test coverage</li>
</ul>
<h3>Measuring SOLID Compliance</h3>
<h4>Automated Metrics</h4>
<ul>
<li><strong>Coupling Metrics</strong>: Afferent/Efferent coupling measurements</li>
<li><strong>Cohesion Metrics</strong>: LCOM (Lack of Cohesion of Methods)</li>
<li><strong>Complexity Metrics</strong>: Cyclomatic complexity per class/method</li>
<li><strong>Size Metrics</strong>: Lines of code, number of methods per class</li>
<li><strong>Inheritance Metrics</strong>: Depth of inheritance tree</li>
</ul>
<h4>Quality Gates</h4>
<ul>
<li><strong>Maintainability Rating</strong>: A, B, C, D, E ratings</li>
<li><strong>Technical Debt</strong>: Estimated time to fix all issues</li>
<li><strong>Code Coverage</strong>: Percentage of code covered by tests</li>
<li><strong>Duplication</strong>: Percentage of duplicated code</li>
<li><strong>Security Hotspots</strong>: Number of security vulnerabilities</li>
</ul>
<h3>Continuous Improvement with SOLID</h3>
<h4>Monitoring Trends</h4>
<ul>
<li>Track maintainability index over time</li>
<li>Monitor technical debt accumulation</li>
<li>Measure code coverage improvements</li>
<li>Analyze bug density reduction</li>
</ul>
<h4>Quality Gates</h4>
<ul>
<li>Set minimum maintainability thresholds</li>
<li>Require SOLID principle compliance</li>
<li>Enforce code coverage targets</li>
<li>Block deployments with critical issues</li>
</ul>
<h4>Team Training</h4>
<ul>
<li>Regular SOLID principle workshops</li>
<li>Code review guidelines</li>
<li>Refactoring best practices</li>
<li>Static analysis tool training</li>
</ul>
<h2>How SOLID Principles Work Together</h2>
<p>The SOLID principles are not independent rules but work together to create a cohesive design philosophy:</p>
<ul>
<li><strong>SRP</strong> ensures each class has a single, well-defined purpose</li>
<li><strong>OCP</strong> allows extending functionality without modifying existing code</li>
<li><strong>LSP</strong> ensures that derived classes can substitute their base classes</li>
<li><strong>ISP</strong> prevents classes from depending on unused interfaces</li>
<li><strong>DIP</strong> inverts dependencies to rely on abstractions rather than concretions</li>
</ul>
<h2>Learning Path</h2>
<p>This guide is structured to help you understand each principle progressively:</p>
<ol>
<li>Start with <strong>Single Responsibility Principle</strong> - the foundation of clean code</li>
<li>Move to <strong>Open/Closed Principle</strong> - enabling extensibility</li>
<li>Learn <strong>Liskov Substitution Principle</strong> - ensuring proper inheritance</li>
<li>Understand <strong>Interface Segregation Principle</strong> - creating focused interfaces</li>
<li>Master <strong>Dependency Inversion Principle</strong> - achieving loose coupling</li>
</ol>
<p>Each principle builds upon the previous ones, creating a comprehensive approach to object-oriented design.</p>
<h2>Reference Application</h2>
<p>This repository includes a comprehensive reference application that demonstrates SOLID principles in practice. The application is an e-commerce system that connects to a PostgreSQL database and is implemented across multiple platforms:</p>
<ul>
<li><strong>C# (.NET)</strong>: Full-featured implementation with comprehensive testing</li>
<li><strong>Java</strong>: Maven-based project with JUnit testing</li>
<li><strong>TypeScript</strong>: Node.js implementation with Jest testing</li>
<li><strong>Python</strong>: Modern Python with pytest and coverage reporting</li>
</ul>
<p>The application is designed to be <strong>platform-agnostic</strong> and <strong>deployment-agnostic</strong>, meaning it can run in any environment - from local development to cloud-native deployments. This makes it an ideal learning tool that focuses purely on coding principles rather than deployment complexities.</p>
<h3>Application Architecture</h3>
<p>The e-commerce application centers around an <code>EcommerceManager</code> class that handles core business logic. Each platform implementation maintains the same interface and behavior, ensuring that the SOLID principles can be applied consistently across different programming languages and environments.</p>
<h2>Getting Started</h2>
<p>Navigate through each principle folder to learn:</p>
<ul>
<li>The core concept and goals</li>
<li>Real-world examples in multiple programming languages</li>
<li>Common violations and how to fix them</li>
<li>Benefits for code quality and testing</li>
<li>How each principle connects to the next</li>
</ul>
<p>Remember: SOLID principles are guidelines, not rigid rules. Apply them thoughtfully based on your specific context and requirements.</p>
<h2>Working on the Exercises</h2>
<h3>Development Workflow</h3>
<ol>
<li><p><strong>Create a Branch</strong>: Start by creating a new branch from the main repository</p>
<pre><code class="language-bash">git checkout -b your-name/solid-principles-exercise
</code></pre>
</li>
<li><p><strong>Work on Your Branch</strong>: Make all your changes on your personal branch</p>
<ul>
<li>This allows you to experiment freely without affecting the main codebase</li>
<li>You can always revert to a clean state if needed</li>
</ul>
</li>
<li><p><strong>Commit Frequently</strong>: Check in your work often with meaningful commit messages</p>
<pre><code class="language-bash">git add .
git commit -m &quot;Implement Single Responsibility Principle for Product class&quot;
</code></pre>
</li>
<li><p><strong>Run Tests Regularly</strong>: Execute unit tests frequently to ensure your changes don&#39;t break existing functionality</p>
<ul>
<li>The unit tests target the <code>EcommerceManager</code> class interface, which should remain consistent</li>
<li>Tests should pass without modification as you refactor the implementation</li>
</ul>
</li>
<li><p><strong>Revert When Stuck</strong>: If you encounter issues or make mistakes, revert to your last working commit</p>
<pre><code class="language-bash">git log --oneline  # Find your last good commit
git reset --hard &lt;commit-hash&gt;  # Revert to that commit
</code></pre>
</li>
</ol>
<h3>Research Tips</h3>
<p>When you get stuck on a particular principle, here are effective research strategies:</p>
<ul>
<li><strong>Read the Theory</strong>: Start with the principle&#39;s definition and core concepts</li>
<li><strong>Study Examples</strong>: Look at real-world code examples in the documentation</li>
<li><strong>Identify Violations</strong>: Find examples of what NOT to do - this often clarifies the principle</li>
<li><strong>Practice Incrementally</strong>: Start with simple refactoring and gradually apply more complex patterns</li>
<li><strong>Compare Implementations</strong>: Look at how the same principle is applied across different programming languages</li>
<li><strong>Use Design Patterns</strong>: Many SOLID principles are implemented through well-known design patterns</li>
<li><strong>Test-Driven Approach</strong>: Write tests first to understand the expected behavior, then refactor to meet SOLID principles</li>
</ul>
<hr>
<p><strong>Next</strong>: Begin with the <a href="./1-Single-class-reponsibility-principle/README.md">Single Responsibility Principle</a> to understand the foundation of clean, maintainable code.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","1-SOLID-Principles/0-README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"0-README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"0-README\"]}"},"styles":[]}],"segment":["slug","1-SOLID-Principles/0-README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
