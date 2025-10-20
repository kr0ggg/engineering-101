1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","1-SOLID-Principles/4-Interface-segregation-principle/README","c"],{"children":["__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"4-Interface-segregation-principle\",\"README\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T798a,<h1>Interface Segregation Principle (ISP)</h1>
<h2>Name</h2>
<p><strong>Interface Segregation Principle</strong> - The &quot;I&quot; in SOLID</p>
<h2>Goal of the Principle</h2>
<p>Clients should not be forced to depend on interfaces they do not use. Interfaces should be focused and cohesive, containing only the methods that are relevant to their specific clients. This prevents clients from being burdened with unnecessary dependencies.</p>
<h2>Theoretical Foundation</h2>
<h3>Dependency Minimization Theory</h3>
<p>The Interface Segregation Principle is based on the fundamental software engineering principle that dependencies should be minimized. Every dependency represents a potential point of failure and a constraint on system evolution. By ensuring clients only depend on what they actually use, we minimize these risks.</p>
<h3>Interface Design Principles</h3>
<p>ISP formalizes several key interface design concepts:</p>
<ul>
<li><strong>Cohesion</strong>: Interface methods should be related and work toward a common purpose</li>
<li><strong>Minimal Interface</strong>: Interfaces should contain only essential methods</li>
<li><strong>Client-Specific Design</strong>: Interfaces should be designed from the client&#39;s perspective</li>
<li><strong>Composition over Inheritance</strong>: Multiple small interfaces are better than one large interface</li>
</ul>
<h3>Coupling Theory</h3>
<p>The principle directly addresses coupling theory by ensuring that:</p>
<ul>
<li>Clients are only coupled to functionality they actually use</li>
<li>Changes to unused interface methods don&#39;t affect clients</li>
<li>System components remain loosely coupled</li>
<li>Dependencies are explicit and intentional</li>
</ul>
<h3>Information Hiding</h3>
<p>ISP supports information hiding by ensuring that clients are not exposed to implementation details they don&#39;t need. This reduces the cognitive load on developers and makes systems easier to understand and maintain.</p>
<h3>Design Patterns Foundation</h3>
<p>ISP is the theoretical foundation for several design patterns:</p>
<ul>
<li><strong>Adapter Pattern</strong>: Adapting interfaces to client needs</li>
<li><strong>Facade Pattern</strong>: Providing simplified interfaces to complex subsystems</li>
<li><strong>Proxy Pattern</strong>: Controlling access to interfaces</li>
<li><strong>Decorator Pattern</strong>: Adding behavior without changing interfaces</li>
</ul>
<h2>Consequences of Violating ISP</h2>
<h3>Unique ISP-Specific Issues</h3>
<p><strong>Interface Pollution</strong></p>
<ul>
<li>Clients implementing methods they don&#39;t need (often as empty implementations)</li>
<li>Confusion about which methods are actually required</li>
<li>Difficulty understanding the true purpose of interfaces</li>
<li>Reduced code clarity and maintainability</li>
</ul>
<p><strong>Unnecessary Dependencies</strong></p>
<ul>
<li>Changes to unused methods affect clients unnecessarily</li>
<li>Clients become coupled to implementation details they don&#39;t need</li>
<li>System becomes more fragile and harder to maintain</li>
<li>Dependencies become unclear and difficult to track</li>
</ul>
<p><strong>Testing and Flexibility Problems</strong></p>
<ul>
<li>Clients must mock methods they don&#39;t use</li>
<li>Test setup becomes more complex</li>
<li>Mock objects become bloated and hard to maintain</li>
<li>Clients cannot easily switch between different implementations</li>
</ul>
<h2>Impact on Static Code Analysis</h2>
<h3>ISP-Specific Metrics</h3>
<p><strong>Interface Complexity Reduction</strong></p>
<ul>
<li>Smaller, focused interfaces reduce cognitive complexity</li>
<li>Better interface cohesion metrics in static analysis tools</li>
<li>Reduced coupling metrics through focused dependencies</li>
</ul>
<p><strong>Dependency Analysis Enhancement</strong></p>
<ul>
<li>Tools can identify unnecessary interface dependencies</li>
<li>Detection of fat interfaces with unused methods</li>
<li>Recognition of proper interface segregation</li>
</ul>
<h3>ISP-Specific Tool Benefits</h3>
<p><strong>ESLint/TSLint (JavaScript/TypeScript)</strong></p>
<ul>
<li>Better &quot;no-unused-vars&quot; compliance in interfaces</li>
<li>Better &quot;max-lines-per-function&quot; in interface methods</li>
</ul>
<p><strong>Checkstyle (Java)</strong></p>
<ul>
<li>Better &quot;InterfaceIsType&quot; compliance</li>
<li>Improved &quot;MethodLength&quot; in interface implementations</li>
</ul>
<p><strong>FxCop/StyleCop (.NET)</strong></p>
<ul>
<li>Fewer &quot;CA1500&quot; (Avoid excessive class coupling) violations</li>
</ul>
<h3>ISP-Specific Detection</h3>
<p><strong>ISP Violation Detection</strong></p>
<ul>
<li>Detection of fat interfaces with too many methods</li>
<li>Identification of clients implementing unused interface methods</li>
<li>Recognition of interfaces that could be split</li>
<li>Detection of unnecessary interface dependencies</li>
</ul>
<p><strong>Interface Analysis</strong></p>
<ul>
<li>Analysis of interface method usage patterns</li>
<li>Detection of proper interface segregation</li>
<li>Recognition of focused, cohesive interfaces</li>
</ul>
<h2>Role in Improving Software Quality</h2>
<p>The Interface Segregation Principle is essential for creating maintainable and flexible software systems. It ensures that:</p>
<ul>
<li><strong>Focused Interfaces</strong>: Each interface has a single, well-defined purpose</li>
<li><strong>Reduced Coupling</strong>: Clients only depend on what they actually use</li>
<li><strong>Better Maintainability</strong>: Changes to unused methods don&#39;t affect clients</li>
<li><strong>Improved Testability</strong>: Clients can be tested with minimal, focused interfaces</li>
<li><strong>Enhanced Flexibility</strong>: Clients can choose exactly what functionality they need</li>
</ul>
<h2>How to Apply This Principle</h2>
<h3>1. Identify Client Needs</h3>
<p><strong>What it means</strong>: Understand what each client actually requires from an interface. Different clients may need different subsets of functionality, and forcing them to depend on unused methods creates unnecessary coupling.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Analyze each class that implements an interface to see which methods it actually uses</li>
<li>Group clients by their usage patterns to identify common needs</li>
<li>Look for clients that implement methods with empty bodies or throw &quot;not implemented&quot; exceptions</li>
<li>Consider the different contexts where the interface might be used</li>
</ul>
<p><strong>Example from our code samples</strong>: In the violating <code>IWorker</code> interface, we can see that <code>BasicWorker</code> only needs basic functionality (Work, Eat, Sleep) but is forced to implement development methods (Code, Design, Test, Deploy) that it doesn&#39;t use. The refactored solution creates separate interfaces (<code>IBasicWorker</code>, <code>IDeveloper</code>, <code>ITester</code>, <code>IDevOps</code>) so clients only implement what they need.</p>
<h3>2. Split Large Interfaces</h3>
<p><strong>What it means</strong>: Break down fat interfaces into smaller, focused interfaces that each serve a specific purpose. This prevents clients from being burdened with methods they don&#39;t need.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Identify groups of related methods within a large interface</li>
<li>Create separate interfaces for each group of related functionality</li>
<li>Ensure each new interface has a single, well-defined responsibility</li>
<li>Use descriptive names that clearly indicate the interface&#39;s purpose</li>
</ul>
<p><strong>Example from our code samples</strong>: The violating <code>MediaPlayer</code> interface combines audio and video functionality. The refactored solution splits it into <code>AudioPlayer</code> and <code>VideoPlayer</code> interfaces, allowing clients to implement only the functionality they need. A basic audio player no longer needs to implement video methods it can&#39;t support.</p>
<h3>3. Use Composition</h3>
<p><strong>What it means</strong>: When clients need functionality from multiple interfaces, combine them through composition rather than creating one large interface. This allows clients to pick and choose exactly what they need.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Create multiple small, focused interfaces</li>
<li>Allow classes to implement multiple interfaces when they need multiple capabilities</li>
<li>Use interface inheritance to build more complex interfaces from simpler ones</li>
<li>Design interfaces to be composable and work well together</li>
</ul>
<p><strong>Example from our code samples</strong>: The refactored worker solution allows <code>FullStackDeveloper</code> to implement multiple interfaces (<code>IBasicWorker</code>, <code>IDeveloper</code>, <code>ITester</code>, <code>IDevOps</code>) to get all the functionality it needs, while <code>BasicWorker</code> only implements <code>IBasicWorker</code>. This composition approach gives clients exactly the capabilities they need without forcing unused dependencies.</p>
<h3>4. Avoid Empty Implementations</h3>
<p><strong>What it means</strong>: Don&#39;t force clients to implement methods they don&#39;t need by providing empty implementations or throwing &quot;not implemented&quot; exceptions. This is a clear sign that the interface is too large.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>If you find yourself writing empty method implementations, the interface likely violates ISP</li>
<li>Look for methods that throw &quot;NotImplementedException&quot; or similar exceptions</li>
<li>Consider splitting the interface to eliminate the need for empty implementations</li>
<li>Design interfaces so that every method is meaningful for every implementing class</li>
</ul>
<p><strong>Example from our code samples</strong>: The violating <code>BasicWorker</code> class throws &quot;NotImplementedException&quot; for development methods it can&#39;t perform. The refactored solution eliminates this problem by creating separate interfaces, so <code>BasicWorker</code> only implements methods it can actually perform.</p>
<h3>5. Design for Specific Use Cases</h3>
<p><strong>What it means</strong>: Create interfaces tailored to specific client needs rather than trying to create one interface that serves all possible use cases. This leads to more focused and useful interfaces.</p>
<p><strong>How to do it</strong>:</p>
<ul>
<li>Design interfaces from the client&#39;s perspective, not the implementer&#39;s perspective</li>
<li>Consider the specific scenarios where each interface will be used</li>
<li>Create interfaces that are cohesive and work well together</li>
<li>Avoid the temptation to add &quot;just in case&quot; methods to interfaces</li>
</ul>
<p><strong>Example from our code samples</strong>: The refactored document processor solution creates specific interfaces (<code>DocumentReader</code>, <code>DocumentWriter</code>, <code>DocumentPrinter</code>, <code>DocumentScanner</code>, <code>DocumentFaxer</code>, <code>DocumentEmailer</code>) that each serve specific use cases. A basic printer only needs to implement the interfaces it can actually support, making the design much cleaner and more maintainable.</p>
<h2>Examples of Violations and Refactoring</h2>
<h3>C# Example</h3>
<p><strong>Violating ISP:</strong></p>
<pre><code class="language-csharp">// Fat interface that forces clients to depend on unused methods
public interface IWorker
{
    void Work();
    void Eat();
    void Sleep();
    void Code();
    void Design();
    void Test();
    void Deploy();
}

// Client that only needs basic worker functionality
public class BasicWorker : IWorker
{
    public void Work()
    {
        Console.WriteLine(&quot;Basic worker working...&quot;);
    }
    
    public void Eat()
    {
        Console.WriteLine(&quot;Basic worker eating...&quot;);
    }
    
    public void Sleep()
    {
        Console.WriteLine(&quot;Basic worker sleeping...&quot;);
    }
    
    // Forced to implement unused methods
    public void Code()
    {
        throw new NotImplementedException(&quot;Basic worker can&#39;t code!&quot;);
    }
    
    public void Design()
    {
        throw new NotImplementedException(&quot;Basic worker can&#39;t design!&quot;);
    }
    
    public void Test()
    {
        throw new NotImplementedException(&quot;Basic worker can&#39;t test!&quot;);
    }
    
    public void Deploy()
    {
        throw new NotImplementedException(&quot;Basic worker can&#39;t deploy!&quot;);
    }
}

// Client that only needs development functionality
public class Developer : IWorker
{
    public void Work()
    {
        Console.WriteLine(&quot;Developer working...&quot;);
    }
    
    public void Eat()
    {
        Console.WriteLine(&quot;Developer eating...&quot;);
    }
    
    public void Sleep()
    {
        Console.WriteLine(&quot;Developer sleeping...&quot;);
    }
    
    public void Code()
    {
        Console.WriteLine(&quot;Developer coding...&quot;);
    }
    
    public void Design()
    {
        Console.WriteLine(&quot;Developer designing...&quot;);
    }
    
    public void Test()
    {
        Console.WriteLine(&quot;Developer testing...&quot;);
    }
    
    public void Deploy()
    {
        Console.WriteLine(&quot;Developer deploying...&quot;);
    }
}
</code></pre>
<p><strong>Refactored - Applying ISP:</strong></p>
<pre><code class="language-csharp">// Segregated interfaces - each focused on specific functionality
public interface IBasicWorker
{
    void Work();
    void Eat();
    void Sleep();
}

public interface IDeveloper
{
    void Code();
    void Design();
}

public interface ITester
{
    void Test();
}

public interface IDevOps
{
    void Deploy();
}

// Clients only implement what they need
public class BasicWorker : IBasicWorker
{
    public void Work()
    {
        Console.WriteLine(&quot;Basic worker working...&quot;);
    }
    
    public void Eat()
    {
        Console.WriteLine(&quot;Basic worker eating...&quot;);
    }
    
    public void Sleep()
    {
        Console.WriteLine(&quot;Basic worker sleeping...&quot;);
    }
}

public class Developer : IBasicWorker, IDeveloper
{
    public void Work()
    {
        Console.WriteLine(&quot;Developer working...&quot;);
    }
    
    public void Eat()
    {
        Console.WriteLine(&quot;Developer eating...&quot;);
    }
    
    public void Sleep()
    {
        Console.WriteLine(&quot;Developer sleeping...&quot;);
    }
    
    public void Code()
    {
        Console.WriteLine(&quot;Developer coding...&quot;);
    }
    
    public void Design()
    {
        Console.WriteLine(&quot;Developer designing...&quot;);
    }
}

public class FullStackDeveloper : IBasicWorker, IDeveloper, ITester, IDevOps
{
    public void Work()
    {
        Console.WriteLine(&quot;Full-stack developer working...&quot;);
    }
    
    public void Eat()
    {
        Console.WriteLine(&quot;Full-stack developer eating...&quot;);
    }
    
    public void Sleep()
    {
        Console.WriteLine(&quot;Full-stack developer sleeping...&quot;);
    }
    
    public void Code()
    {
        Console.WriteLine(&quot;Full-stack developer coding...&quot;);
    }
    
    public void Design()
    {
        Console.WriteLine(&quot;Full-stack developer designing...&quot;);
    }
    
    public void Test()
    {
        Console.WriteLine(&quot;Full-stack developer testing...&quot;);
    }
    
    public void Deploy()
    {
        Console.WriteLine(&quot;Full-stack developer deploying...&quot;);
    }
}
</code></pre>
<h3>Java Example</h3>
<p><strong>Violating ISP:</strong></p>
<pre><code class="language-java">// Fat interface that forces clients to depend on unused methods
public interface MediaPlayer {
    void playAudio();
    void playVideo();
    void playAudioFromCD();
    void playVideoFromDVD();
    void playAudioFromUSB();
    void playVideoFromUSB();
}

// Client that only needs audio functionality
public class AudioPlayer implements MediaPlayer {
    @Override
    public void playAudio() {
        System.out.println(&quot;Playing audio...&quot;);
    }
    
    @Override
    public void playVideo() {
        throw new UnsupportedOperationException(&quot;Audio player can&#39;t play video!&quot;);
    }
    
    @Override
    public void playAudioFromCD() {
        System.out.println(&quot;Playing audio from CD...&quot;);
    }
    
    @Override
    public void playVideoFromDVD() {
        throw new UnsupportedOperationException(&quot;Audio player can&#39;t play video from DVD!&quot;);
    }
    
    @Override
    public void playAudioFromUSB() {
        System.out.println(&quot;Playing audio from USB...&quot;);
    }
    
    @Override
    public void playVideoFromUSB() {
        throw new UnsupportedOperationException(&quot;Audio player can&#39;t play video from USB!&quot;);
    }
}
</code></pre>
<p><strong>Refactored - Applying ISP:</strong></p>
<pre><code class="language-java">// Segregated interfaces - each focused on specific functionality
public interface AudioPlayer {
    void playAudio();
    void playAudioFromCD();
    void playAudioFromUSB();
}

public interface VideoPlayer {
    void playVideo();
    void playVideoFromDVD();
    void playVideoFromUSB();
}

// Clients only implement what they need
public class BasicAudioPlayer implements AudioPlayer {
    @Override
    public void playAudio() {
        System.out.println(&quot;Playing audio...&quot;);
    }
    
    @Override
    public void playAudioFromCD() {
        System.out.println(&quot;Playing audio from CD...&quot;);
    }
    
    @Override
    public void playAudioFromUSB() {
        System.out.println(&quot;Playing audio from USB...&quot;);
    }
}

public class BasicVideoPlayer implements VideoPlayer {
    @Override
    public void playVideo() {
        System.out.println(&quot;Playing video...&quot;);
    }
    
    @Override
    public void playVideoFromDVD() {
        System.out.println(&quot;Playing video from DVD...&quot;);
    }
    
    @Override
    public void playVideoFromUSB() {
        System.out.println(&quot;Playing video from USB...&quot;);
    }
}

public class UniversalMediaPlayer implements AudioPlayer, VideoPlayer {
    @Override
    public void playAudio() {
        System.out.println(&quot;Playing audio...&quot;);
    }
    
    @Override
    public void playAudioFromCD() {
        System.out.println(&quot;Playing audio from CD...&quot;);
    }
    
    @Override
    public void playAudioFromUSB() {
        System.out.println(&quot;Playing audio from USB...&quot;);
    }
    
    @Override
    public void playVideo() {
        System.out.println(&quot;Playing video...&quot;);
    }
    
    @Override
    public void playVideoFromDVD() {
        System.out.println(&quot;Playing video from DVD...&quot;);
    }
    
    @Override
    public void playVideoFromUSB() {
        System.out.println(&quot;Playing video from USB...&quot;);
    }
}
</code></pre>
<h3>TypeScript Example</h3>
<p><strong>Violating ISP:</strong></p>
<pre><code class="language-typescript">// Fat interface that forces clients to depend on unused methods
interface DocumentProcessor {
    readDocument(): void;
    writeDocument(): void;
    printDocument(): void;
    scanDocument(): void;
    faxDocument(): void;
    emailDocument(): void;
}

// Client that only needs basic document functionality
class BasicPrinter implements DocumentProcessor {
    readDocument(): void {
        console.log(&quot;Reading document...&quot;);
    }
    
    writeDocument(): void {
        console.log(&quot;Writing document...&quot;);
    }
    
    printDocument(): void {
        console.log(&quot;Printing document...&quot;);
    }
    
    // Forced to implement unused methods
    scanDocument(): void {
        throw new Error(&quot;Basic printer can&#39;t scan!&quot;);
    }
    
    faxDocument(): void {
        throw new Error(&quot;Basic printer can&#39;t fax!&quot;);
    }
    
    emailDocument(): void {
        throw new Error(&quot;Basic printer can&#39;t email!&quot;);
    }
}
</code></pre>
<p><strong>Refactored - Applying ISP:</strong></p>
<pre><code class="language-typescript">// Segregated interfaces - each focused on specific functionality
interface DocumentReader {
    readDocument(): void;
}

interface DocumentWriter {
    writeDocument(): void;
}

interface DocumentPrinter {
    printDocument(): void;
}

interface DocumentScanner {
    scanDocument(): void;
}

interface DocumentFaxer {
    faxDocument(): void;
}

interface DocumentEmailer {
    emailDocument(): void;
}

// Clients only implement what they need
class BasicPrinter implements DocumentReader, DocumentWriter, DocumentPrinter {
    readDocument(): void {
        console.log(&quot;Reading document...&quot;);
    }
    
    writeDocument(): void {
        console.log(&quot;Writing document...&quot;);
    }
    
    printDocument(): void {
        console.log(&quot;Printing document...&quot;);
    }
}

class ScannerPrinter implements DocumentReader, DocumentWriter, DocumentPrinter, DocumentScanner {
    readDocument(): void {
        console.log(&quot;Reading document...&quot;);
    }
    
    writeDocument(): void {
        console.log(&quot;Writing document...&quot;);
    }
    
    printDocument(): void {
        console.log(&quot;Printing document...&quot;);
    }
    
    scanDocument(): void {
        console.log(&quot;Scanning document...&quot;);
    }
}

class AllInOnePrinter implements DocumentReader, DocumentWriter, DocumentPrinter, DocumentScanner, DocumentFaxer, DocumentEmailer {
    readDocument(): void {
        console.log(&quot;Reading document...&quot;);
    }
    
    writeDocument(): void {
        console.log(&quot;Writing document...&quot;);
    }
    
    printDocument(): void {
        console.log(&quot;Printing document...&quot;);
    }
    
    scanDocument(): void {
        console.log(&quot;Scanning document...&quot;);
    }
    
    faxDocument(): void {
        console.log(&quot;Faxing document...&quot;);
    }
    
    emailDocument(): void {
        console.log(&quot;Emailing document...&quot;);
    }
}
</code></pre>
<h2>How This Principle Helps with Code Quality</h2>
<ol>
<li><strong>Focused Interfaces</strong>: Each interface has a single, clear purpose</li>
<li><strong>Reduced Dependencies</strong>: Clients only depend on what they actually use</li>
<li><strong>Better Maintainability</strong>: Changes to unused methods don&#39;t affect clients</li>
<li><strong>Improved Readability</strong>: Interfaces are easier to understand and use</li>
<li><strong>Enhanced Flexibility</strong>: Clients can choose exactly what functionality they need</li>
</ol>
<h2>How This Principle Helps with Automated Testing</h2>
<ol>
<li><strong>Focused Testing</strong>: Each interface can be tested independently</li>
<li><strong>Easier Mocking</strong>: Smaller interfaces are easier to mock and test</li>
<li><strong>Reduced Test Complexity</strong>: Tests only need to cover relevant functionality</li>
<li><strong>Better Test Coverage</strong>: Each interface can have comprehensive test coverage</li>
<li><strong>Isolated Testing</strong>: Changes to one interface don&#39;t affect tests for others</li>
</ol>
<pre><code class="language-csharp">// Example of testing with ISP
[Test]
public void BasicWorker_ImplementsOnlyBasicFunctionality()
{
    // Arrange
    IBasicWorker worker = new BasicWorker();
    
    // Act &amp; Assert
    Assert.DoesNotThrow(() =&gt; worker.Work());
    Assert.DoesNotThrow(() =&gt; worker.Eat());
    Assert.DoesNotThrow(() =&gt; worker.Sleep());
}

[Test]
public void Developer_ImplementsBasicAndDevelopmentFunctionality()
{
    // Arrange
    IBasicWorker basicWorker = new Developer();
    IDeveloper developer = new Developer();
    
    // Act &amp; Assert
    Assert.DoesNotThrow(() =&gt; basicWorker.Work());
    Assert.DoesNotThrow(() =&gt; developer.Code());
    Assert.DoesNotThrow(() =&gt; developer.Design());
}

[Test]
public void FullStackDeveloper_ImplementsAllFunctionality()
{
    // Arrange
    IBasicWorker basicWorker = new FullStackDeveloper();
    IDeveloper developer = new FullStackDeveloper();
    ITester tester = new FullStackDeveloper();
    IDevOps devOps = new FullStackDeveloper();
    
    // Act &amp; Assert
    Assert.DoesNotThrow(() =&gt; basicWorker.Work());
    Assert.DoesNotThrow(() =&gt; developer.Code());
    Assert.DoesNotThrow(() =&gt; tester.Test());
    Assert.DoesNotThrow(() =&gt; devOps.Deploy());
}
</code></pre>
<h2>Summary</h2>
<p>The Interface Segregation Principle is crucial for creating maintainable and flexible software systems. By ensuring that clients only depend on the interfaces they actually use, we achieve:</p>
<ul>
<li><strong>Focused Design</strong>: Interfaces are tailored to specific client needs</li>
<li><strong>Reduced Coupling</strong>: Clients are not burdened with unnecessary dependencies</li>
<li><strong>Better Maintainability</strong>: Changes to unused methods don&#39;t affect clients</li>
<li><strong>Improved Testability</strong>: Smaller, focused interfaces are easier to test</li>
<li><strong>Enhanced Flexibility</strong>: Clients can choose exactly what functionality they need</li>
</ul>
<p>This principle builds upon the Liskov Substitution Principle by ensuring that the interfaces we create are focused and cohesive. It also sets the foundation for the Dependency Inversion Principle, as well-designed interfaces are essential for proper dependency inversion.</p>
<h2>Exercise 1: Design - Interface Segregation Principle</h2>
<h3>Objective</h3>
<p>Design focused, cohesive interfaces that don&#39;t force clients to depend on methods they don&#39;t use, following the Interface Segregation Principle.</p>
<h3>Task</h3>
<p>Analyze the e-commerce system and design interfaces that follow ISP principles.</p>
<ol>
<li><strong>Identify Interface Needs</strong>: Examine the refactored code from previous exercises and identify where interfaces are needed</li>
<li><strong>Design Focused Interfaces</strong>: Create small, cohesive interfaces with single responsibilities</li>
<li><strong>Avoid Fat Interfaces</strong>: Ensure interfaces don&#39;t force clients to implement unused methods</li>
<li><strong>Plan Interface Composition</strong>: Design how multiple small interfaces can be combined when needed</li>
</ol>
<h3>Deliverables</h3>
<ul>
<li>Interface design showing focused, cohesive interfaces</li>
<li>Analysis of client needs for each interface</li>
<li>Interface composition plan</li>
<li>Examples of fat interfaces to avoid</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Navigate to the <code>ecom-exercises</code> folder</li>
<li>Choose your preferred language (C#, Java, Python, or TypeScript)</li>
<li>Review your refactored code from SRP, OCP, and LSP exercises</li>
<li>Identify where interfaces would be beneficial</li>
<li>Create your design without modifying any code</li>
</ol>
<hr>
<h2>Exercise 2: Implementation - Interface Segregation Principle</h2>
<h3>Objective</h3>
<p>Implement your design from Exercise 1, ensuring that all existing unit tests continue to pass and clients only depend on the interfaces they actually use.</p>
<h3>Task</h3>
<p>Implement the focused interfaces according to your design while maintaining system functionality.</p>
<ol>
<li><strong>Create Interfaces</strong>: Implement the focused interfaces from your design</li>
<li><strong>Refactor Classes</strong>: Modify existing classes to implement only the interfaces they need</li>
<li><strong>Ensure Segregation</strong>: Verify that clients only depend on the functionality they use</li>
<li><strong>Maintain Functionality</strong>: Ensure all existing unit tests pass</li>
<li><strong>Test Interface Usage</strong>: Verify that clients can use only the functionality they require</li>
</ol>
<h3>Success Criteria</h3>
<ul>
<li>All existing unit tests pass</li>
<li>The application runs without errors</li>
<li>Clients only depend on the interfaces they actually use</li>
<li>Interfaces are focused and cohesive</li>
<li>The system maintains the same external behavior</li>
</ul>
<h3>Getting Started</h3>
<ol>
<li>Use your design from Exercise 1 as a guide</li>
<li>Start by creating the focused interfaces</li>
<li>Refactor existing classes to implement only what they need</li>
<li>Run tests frequently to ensure you don&#39;t break existing functionality</li>
<li>Verify that clients can use only the functionality they require</li>
</ol>
<h3>Implementation Best Practices</h3>
<h4>Git Workflow</h4>
<ol>
<li><p><strong>Create a Feature Branch</strong>: Start from main and create a new branch for your ISP refactoring</p>
<pre><code class="language-bash">git checkout main
git pull origin main
git checkout -b feature/isp-refactoring
</code></pre>
</li>
<li><p><strong>Commit Frequently</strong>: Make small, focused commits as you refactor</p>
<pre><code class="language-bash">git add .
git commit -m &quot;Create IProductReader interface&quot;
git commit -m &quot;Create IProductWriter interface&quot;
git commit -m &quot;Refactor ProductService to implement segregated interfaces&quot;
git commit -m &quot;Create ICartOperations interface&quot;
git commit -m &quot;Create ICartCalculations interface&quot;
</code></pre>
</li>
<li><p><strong>Test After Each Change</strong>: Run tests after each refactoring step</p>
<pre><code class="language-bash"># Run tests to ensure nothing is broken
dotnet test  # or equivalent for your language
</code></pre>
</li>
</ol>
<h4>Industry Best Practices</h4>
<ol>
<li><strong>Interface Segregation</strong>: Create small, focused interfaces with single responsibilities</li>
<li><strong>Client-Specific Interfaces</strong>: Design interfaces based on actual client needs</li>
<li><strong>Interface Composition</strong>: Combine multiple small interfaces when needed</li>
<li><strong>Fat Interface Detection</strong>: Identify interfaces that force clients to depend on unused methods</li>
<li><strong>Dependency Minimization</strong>: Ensure clients only depend on what they actually use</li>
<li><strong>Interface Documentation</strong>: Document the purpose and usage of each interface</li>
<li><strong>Backward Compatibility</strong>: Maintain compatibility when segregating existing interfaces</li>
<li><strong>Testing Interfaces</strong>: Create tests that verify interface segregation works correctly</li>
</ol>
<h3>Learning Objectives</h3>
<p>After completing both exercises, you should be able to:</p>
<ul>
<li>Design focused, cohesive interfaces</li>
<li>Avoid fat interfaces that violate ISP</li>
<li>Implement ISP while maintaining system functionality</li>
<li>Use interface composition effectively</li>
<li>Ensure clients only depend on what they use</li>
</ul>
<p><strong>Next</strong>: The <a href="../5-Dependency-segregation-principle/README.md">Dependency Inversion Principle</a> builds upon ISP by ensuring that high-level modules depend on abstractions rather than concrete implementations, completing the SOLID principles foundation.</p>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","1-SOLID-Principles/4-Interface-segregation-principle/README","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"README"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"1-SOLID-Principles\",\"4-Interface-segregation-principle\",\"README\"]}"},"styles":[]}],"segment":["slug","1-SOLID-Principles/4-Interface-segregation-principle/README","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
