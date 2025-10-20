1:HL["/_next/static/css/6b40bd379144f5c8.css","style",{"crossOrigin":""}]
0:["Mi_IUBpRsd6BRYXmSnup_",[[["",{"children":["docs",{"children":[["slug","2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","c"],{"children":["__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"04-email-address-value-object\"]}",{}]}]}]},"$undefined","$undefined",true],"$L2",[[["$","link","0",{"rel":"stylesheet","href":"/_next/static/css/6b40bd379144f5c8.css","precedence":"next","crossOrigin":""}]],"$L3"]]]]
4:I[6954,[],""]
5:I[7264,[],""]
7:I[8326,["326","static/chunks/326-c01c22be8dcac7b1.js","687","static/chunks/app/docs/%5B...slug%5D/page-f5028c860b0f5f1d.js"],""]
3:[["$","meta","0",{"charSet":"utf-8"}],["$","title","1",{"children":"Engineering 101"}],["$","meta","2",{"name":"description","content":"SOLID + DDD training site"}],["$","meta","3",{"name":"viewport","content":"width=device-width, initial-scale=1"}]]
8:T4648,<h1>EmailAddress Value Object - Python Example</h1>
<p><strong>Section</strong>: <a href="../../1-introduction-to-the-domain.md#self-validation">Self-Validation</a></p>
<p><strong>Navigation</strong>: <a href="./03-order-entity.md">← Previous: Order Entity</a> | <a href="../../1-introduction-to-the-domain.md">← Back to Introduction</a> | <a href="./README.md">← Back to Python Index</a></p>
<hr>
<pre><code class="language-python"># Python Example - EmailAddress Value Object with Self-Validation
# File: 2-Domain-Driven-Design/code-samples/python/04-email-address-value-object.py

import re
from typing import Optional
from dataclasses import dataclass
import hashlib

# ✅ GOOD: Self-Validating Value Object
@dataclass(frozen=True)
class EmailAddress:
    &quot;&quot;&quot;Value object representing an email address with validation&quot;&quot;&quot;
    
    _value: str
    
    def __post_init__(self):
        &quot;&quot;&quot;Validate email address during construction&quot;&quot;&quot;
        if not self._value or not self._value.strip():
            raise ValueError(&quot;Email address cannot be empty&quot;)
        
        trimmed_email = self._value.strip().lower()
        
        if not self._is_valid_email(trimmed_email):
            raise ValueError(f&quot;Invalid email address format: {self._value}&quot;)
        
        # Update the frozen dataclass field
        object.__setattr__(self, &#39;_value&#39;, trimmed_email)
    
    @property
    def value(self) -&gt; str:
        &quot;&quot;&quot;Get the email address value&quot;&quot;&quot;
        return self._value
    
    @property
    def domain(self) -&gt; str:
        &quot;&quot;&quot;Extract the domain part of the email&quot;&quot;&quot;
        return self._value.split(&#39;@&#39;)[1]
    
    @property
    def local_part(self) -&gt; str:
        &quot;&quot;&quot;Extract the local part of the email&quot;&quot;&quot;
        return self._value.split(&#39;@&#39;)[0]
    
    @property
    def is_gmail(self) -&gt; bool:
        &quot;&quot;&quot;Check if this is a Gmail address&quot;&quot;&quot;
        return self.domain == &#39;gmail.com&#39;
    
    @property
    def is_corporate(self) -&gt; bool:
        &quot;&quot;&quot;Check if this is a corporate email address&quot;&quot;&quot;
        corporate_domains = [&#39;company.com&#39;, &#39;corp.com&#39;, &#39;business.org&#39;]
        return self.domain in corporate_domains
    
    @property
    def is_disposable(self) -&gt; bool:
        &quot;&quot;&quot;Check if this is a disposable email address&quot;&quot;&quot;
        disposable_domains = [
            &#39;10minutemail.com&#39;, &#39;tempmail.org&#39;, &#39;guerrillamail.com&#39;,
            &#39;mailinator.com&#39;, &#39;throwaway.email&#39;
        ]
        return self.domain in disposable_domains
    
    def normalize(self) -&gt; &#39;EmailAddress&#39;:
        &quot;&quot;&quot;Return normalized version of email address&quot;&quot;&quot;
        # Gmail addresses can be normalized by removing dots and plus aliases
        if self.is_gmail:
            local = self.local_part.replace(&#39;.&#39;, &#39;&#39;)
            if &#39;+&#39; in local:
                local = local.split(&#39;+&#39;)[0]
            normalized_value = f&quot;{local}@{self.domain}&quot;
            return EmailAddress(normalized_value)
        
        return self
    
    def get_hash(self) -&gt; str:
        &quot;&quot;&quot;Get a hash of the email address for privacy&quot;&quot;&quot;
        return hashlib.sha256(self._value.encode()).hexdigest()[:16]
    
    def mask(self) -&gt; str:
        &quot;&quot;&quot;Return a masked version of the email for display&quot;&quot;&quot;
        local_part = self.local_part
        domain = self.domain
        
        if len(local_part) &lt;= 2:
            masked_local = &#39;*&#39; * len(local_part)
        else:
            masked_local = local_part[0] + &#39;*&#39; * (len(local_part) - 2) + local_part[-1]
        
        return f&quot;{masked_local}@{domain}&quot;
    
    def __str__(self) -&gt; str:
        return self._value
    
    def __repr__(self) -&gt; str:
        return f&quot;EmailAddress(&#39;{self._value}&#39;)&quot;
    
    def __eq__(self, other) -&gt; bool:
        if not isinstance(other, EmailAddress):
            return False
        return self._value == other._value
    
    def __hash__(self) -&gt; int:
        return hash(self._value)
    
    @staticmethod
    def _is_valid_email(email: str) -&gt; bool:
        &quot;&quot;&quot;Validate email address format using regex&quot;&quot;&quot;
        # RFC 5322 compliant regex (simplified)
        pattern = r&#39;^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$&#39;
        return re.match(pattern, email) is not None
    
    @classmethod
    def create(cls, email: str) -&gt; &#39;EmailAddress&#39;:
        &quot;&quot;&quot;Factory method for creating email addresses&quot;&quot;&quot;
        return cls(email)
    
    @classmethod
    def create_gmail(cls, local_part: str) -&gt; &#39;EmailAddress&#39;:
        &quot;&quot;&quot;Create a Gmail address&quot;&quot;&quot;
        return cls(f&quot;{local_part}@gmail.com&quot;)
    
    @classmethod
    def create_corporate(cls, local_part: str, domain: str) -&gt; &#39;EmailAddress&#39;:
        &quot;&quot;&quot;Create a corporate email address&quot;&quot;&quot;
        return cls(f&quot;{local_part}@{domain}&quot;)

# ✅ GOOD: Email Validation Service
class EmailValidationService:
    &quot;&quot;&quot;Domain service for complex email validation&quot;&quot;&quot;
    
    def __init__(self):
        self._blacklisted_domains = {
            &#39;spam.com&#39;, &#39;fake-email.com&#39;, &#39;invalid.org&#39;
        }
        self._corporate_domains = {
            &#39;company.com&#39;, &#39;corp.com&#39;, &#39;business.org&#39;
        }
    
    def is_valid_for_registration(self, email: EmailAddress) -&gt; bool:
        &quot;&quot;&quot;Check if email is valid for user registration&quot;&quot;&quot;
        if email.is_disposable:
            return False
        
        if email.domain in self._blacklisted_domains:
            return False
        
        return True
    
    def is_corporate_email(self, email: EmailAddress) -&gt; bool:
        &quot;&quot;&quot;Check if email is from a corporate domain&quot;&quot;&quot;
        return email.domain in self._corporate_domains
    
    def get_email_category(self, email: EmailAddress) -&gt; str:
        &quot;&quot;&quot;Categorize email address&quot;&quot;&quot;
        if email.is_gmail:
            return &quot;personal&quot;
        elif email.is_corporate:
            return &quot;corporate&quot;
        elif email.is_disposable:
            return &quot;disposable&quot;
        else:
            return &quot;other&quot;

# ✅ GOOD: Email Address Specification
class EmailSpecification:
    &quot;&quot;&quot;Specification for email-related business rules&quot;&quot;&quot;
    
    def is_valid_for_customer_registration(self, email: EmailAddress) -&gt; bool:
        &quot;&quot;&quot;Check if email meets customer registration requirements&quot;&quot;&quot;
        return (not email.is_disposable and
                not email.is_gmail or email.local_part.count(&#39;.&#39;) &lt;= 2)
    
    def is_valid_for_business_account(self, email: EmailAddress) -&gt; bool:
        &quot;&quot;&quot;Check if email is valid for business account&quot;&quot;&quot;
        return (not email.is_disposable and
                not email.is_gmail and
                email.domain not in [&#39;yahoo.com&#39;, &#39;hotmail.com&#39;, &#39;outlook.com&#39;])
    
    def requires_verification(self, email: EmailAddress) -&gt; bool:
        &quot;&quot;&quot;Check if email requires verification&quot;&quot;&quot;
        return (email.is_gmail or
                email.is_corporate or
                email.domain in [&#39;yahoo.com&#39;, &#39;hotmail.com&#39;, &#39;outlook.com&#39;])

# ✅ GOOD: Email Address Factory
class EmailAddressFactory:
    &quot;&quot;&quot;Factory for creating email addresses with different strategies&quot;&quot;&quot;
    
    @staticmethod
    def create_personal_email(local_part: str, domain: str) -&gt; EmailAddress:
        &quot;&quot;&quot;Create a personal email address&quot;&quot;&quot;
        return EmailAddress(f&quot;{local_part}@{domain}&quot;)
    
    @staticmethod
    def create_business_email(first_name: str, last_name: str, company_domain: str) -&gt; EmailAddress:
        &quot;&quot;&quot;Create a business email address&quot;&quot;&quot;
        local_part = f&quot;{first_name.lower()}.{last_name.lower()}&quot;
        return EmailAddress(f&quot;{local_part}@{company_domain}&quot;)
    
    @staticmethod
    def create_support_email(company_domain: str) -&gt; EmailAddress:
        &quot;&quot;&quot;Create a support email address&quot;&quot;&quot;
        return EmailAddress(f&quot;support@{company_domain}&quot;)
    
    @staticmethod
    def create_noreply_email(company_domain: str) -&gt; EmailAddress:
        &quot;&quot;&quot;Create a no-reply email address&quot;&quot;&quot;
        return EmailAddress(f&quot;noreply@{company_domain}&quot;)

# ✅ GOOD: Email Address Repository Interface
class EmailAddressRepository:
    &quot;&quot;&quot;Repository interface for email address operations&quot;&quot;&quot;
    
    def exists(self, email: EmailAddress) -&gt; bool:
        &quot;&quot;&quot;Check if email address already exists&quot;&quot;&quot;
        raise NotImplementedError
    
    def is_verified(self, email: EmailAddress) -&gt; bool:
        &quot;&quot;&quot;Check if email address is verified&quot;&quot;&quot;
        raise NotImplementedError
    
    def mark_as_verified(self, email: EmailAddress) -&gt; None:
        &quot;&quot;&quot;Mark email address as verified&quot;&quot;&quot;
        raise NotImplementedError

# ✅ GOOD: Email Address Service
class EmailAddressService:
    &quot;&quot;&quot;Domain service for email address operations&quot;&quot;&quot;
    
    def __init__(self, repository: EmailAddressRepository):
        self._repository = repository
        self._validation_service = EmailValidationService()
    
    def register_email(self, email: EmailAddress) -&gt; bool:
        &quot;&quot;&quot;Register a new email address&quot;&quot;&quot;
        if not self._validation_service.is_valid_for_registration(email):
            raise ValueError(&quot;Email address is not valid for registration&quot;)
        
        if self._repository.exists(email):
            raise ValueError(&quot;Email address already exists&quot;)
        
        # Email is valid and unique
        return True
    
    def verify_email(self, email: EmailAddress) -&gt; None:
        &quot;&quot;&quot;Verify an email address&quot;&quot;&quot;
        if not self._repository.exists(email):
            raise ValueError(&quot;Email address not found&quot;)
        
        self._repository.mark_as_verified(email)
    
    def get_email_info(self, email: EmailAddress) -&gt; dict:
        &quot;&quot;&quot;Get information about an email address&quot;&quot;&quot;
        return {
            &#39;email&#39;: email.value,
            &#39;domain&#39;: email.domain,
            &#39;local_part&#39;: email.local_part,
            &#39;is_gmail&#39;: email.is_gmail,
            &#39;is_corporate&#39;: email.is_corporate,
            &#39;is_disposable&#39;: email.is_disposable,
            &#39;category&#39;: self._validation_service.get_email_category(email),
            &#39;masked&#39;: email.mask(),
            &#39;hash&#39;: email.get_hash()
        }

# ❌ BAD: Primitive Obsession
class BadCustomer:
    &quot;&quot;&quot;Example of primitive obsession - using string instead of EmailAddress&quot;&quot;&quot;
    
    def __init__(self, name: str, email: str):
        self.name = name
        self.email = email  # ❌ Using primitive string
    
    def send_email(self, subject: str, body: str):
        # ❌ No validation, no type safety
        if &#39;@&#39; not in self.email:
            raise ValueError(&quot;Invalid email&quot;)
        # ... rest of logic

# ❌ BAD: Validation Scattered
class BadEmailValidator:
    &quot;&quot;&quot;Example of scattered validation logic&quot;&quot;&quot;
    
    def validate_email(self, email: str) -&gt; bool:
        # ❌ Validation logic scattered across multiple classes
        if not email:
            return False
        
        if &#39;@&#39; not in email:
            return False
        
        # More validation logic scattered elsewhere
        return True

# Example usage
if __name__ == &quot;__main__&quot;:
    # Create email addresses
    try:
        email1 = EmailAddress(&quot;john.doe@company.com&quot;)
        email2 = EmailAddress(&quot;jane.smith@gmail.com&quot;)
        email3 = EmailAddress(&quot;support@business.org&quot;)
        
        print(f&quot;Email 1: {email1}&quot;)
        print(f&quot;Domain: {email1.domain}&quot;)
        print(f&quot;Is corporate: {email1.is_corporate}&quot;)
        print(f&quot;Masked: {email1.mask()}&quot;)
        
        print(f&quot;\nEmail 2: {email2}&quot;)
        print(f&quot;Is Gmail: {email2.is_gmail}&quot;)
        print(f&quot;Normalized: {email2.normalize()}&quot;)
        
        print(f&quot;\nEmail 3: {email3}&quot;)
        print(f&quot;Is corporate: {email3.is_corporate}&quot;)
        
        # Test validation
        try:
            bad_email = EmailAddress(&quot;invalid-email&quot;)
        except ValueError as e:
            print(f&quot;\nValidation error: {e}&quot;)
        
        # Test equality
        email4 = EmailAddress(&quot;john.doe@company.com&quot;)
        print(f&quot;\nEmail1 == Email4: {email1 == email4}&quot;)
        
        # Test factory methods
        gmail = EmailAddress.create_gmail(&quot;test.user&quot;)
        print(f&quot;\nGmail created: {gmail}&quot;)
        
        corporate = EmailAddress.create_corporate(&quot;admin&quot;, &quot;company.com&quot;)
        print(f&quot;Corporate created: {corporate}&quot;)
        
    except ValueError as e:
        print(f&quot;Error: {e}&quot;)
</code></pre>
<h2>Key Concepts Demonstrated</h2>
<h3>Self-Validation</h3>
<h4>1. <strong>Validation at Construction</strong></h4>
<ul>
<li>✅ Email address is validated when created</li>
<li>✅ Invalid email addresses cannot be created</li>
<li>✅ Validation happens at the domain boundary</li>
</ul>
<h4>2. <strong>Rich Value Object Behavior</strong></h4>
<ul>
<li>✅ Email address has useful methods and properties</li>
<li>✅ Business logic is encapsulated in the value object</li>
<li>✅ Methods express business operations clearly</li>
</ul>
<h4>3. <strong>Immutability</strong></h4>
<ul>
<li>✅ Email address cannot be modified after creation</li>
<li>✅ All operations return new instances</li>
<li>✅ Thread-safe and predictable behavior</li>
</ul>
<h4>4. <strong>Value-Based Equality</strong></h4>
<ul>
<li>✅ Two email addresses are equal if they have the same value</li>
<li>✅ Hash code is based on the value</li>
<li>✅ Can be used as dictionary keys</li>
</ul>
<h3>EmailAddress Value Object Design Principles</h3>
<h4><strong>Self-Validation</strong></h4>
<ul>
<li>✅ Email address validates itself during construction</li>
<li>✅ Invalid email addresses cannot be created</li>
<li>✅ Clear error messages for validation failures</li>
</ul>
<h4><strong>Rich Behavior</strong></h4>
<ul>
<li>✅ Email address has useful methods and properties</li>
<li>✅ Business logic is encapsulated in the value object</li>
<li>✅ Methods express business operations clearly</li>
</ul>
<h4><strong>Immutability</strong></h4>
<ul>
<li>✅ Email address cannot be modified after creation</li>
<li>✅ All operations return new instances</li>
<li>✅ Thread-safe and predictable behavior</li>
</ul>
<h4><strong>Value-Based Equality</strong></h4>
<ul>
<li>✅ Two email addresses are equal if they have the same value</li>
<li>✅ Hash code is based on the value</li>
<li>✅ Can be used as dictionary keys</li>
</ul>
<h3>Python Benefits for Value Objects</h3>
<ul>
<li><strong>Dataclasses</strong>: Clean, concise class definitions with <code>@dataclass</code></li>
<li><strong>Frozen Dataclasses</strong>: Immutable objects with <code>frozen=True</code></li>
<li><strong>Type Hints</strong>: Better IDE support and documentation</li>
<li><strong>Properties</strong>: Clean access to encapsulated data</li>
<li><strong>Method Chaining</strong>: Fluent interfaces for operations</li>
<li><strong>Error Handling</strong>: Clear exception messages for validation</li>
</ul>
<h3>Common Anti-Patterns to Avoid</h3>
<h4><strong>Primitive Obsession</strong></h4>
<ul>
<li>❌ Using primitives instead of domain types</li>
<li>❌ No type safety for business concepts</li>
<li>❌ Scattered validation logic</li>
</ul>
<h4><strong>Validation Scattered</strong></h4>
<ul>
<li>❌ Validation logic spread across multiple classes</li>
<li>❌ Inconsistent validation rules</li>
<li>❌ Hard to maintain and test</li>
</ul>
<h4><strong>Mutable Value Objects</strong></h4>
<ul>
<li>❌ Value objects that can be modified</li>
<li>❌ Unpredictable behavior</li>
<li>❌ Thread safety issues</li>
</ul>
<h2>Related Concepts</h2>
<ul>
<li><a href="./01-customer-entity.md">Customer Entity</a> - Entity using EmailAddress</li>
<li><a href="./03-order-entity.md">Order Entity</a> - Entity with business logic</li>
<li><a href="./02-money-value-object.md">Money Value Object</a> - Another value object example</li>
<li><a href="../../1-introduction-to-the-domain.md#self-validation">Self-Validation</a> - Self-validation concepts</li>
</ul>
<p>/*</p>
<ul>
<li>Navigation:</li>
<li>Previous: 03-order-entity.md</li>
<li>Next: 05-pricing-service.md</li>
<li></li>
<li>Back to: <a href="../../1-introduction-to-the-domain.md#self-validation">Self-Validation</a><br> */</li>
</ul>
2:[null,["$","html",null,{"lang":"en","children":[["$","head",null,{"children":[["$","link",null,{"rel":"preconnect","href":"https://fonts.googleapis.com"}],["$","link",null,{"rel":"preconnect","href":"https://fonts.gstatic.com","crossOrigin":"anonymous"}],["$","link",null,{"href":"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap","rel":"stylesheet"}]]}],["$","body",null,{"className":"antialiased","children":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":[["$","title",null,{"children":"404: This page could not be found."}],["$","div",null,{"style":{"fontFamily":"system-ui,\"Segoe UI\",Roboto,Helvetica,Arial,sans-serif,\"Apple Color Emoji\",\"Segoe UI Emoji\"","height":"100vh","textAlign":"center","display":"flex","flexDirection":"column","alignItems":"center","justifyContent":"center"},"children":["$","div",null,{"children":[["$","style",null,{"dangerouslySetInnerHTML":{"__html":"body{color:#000;background:#fff;margin:0}.next-error-h1{border-right:1px solid rgba(0,0,0,.3)}@media (prefers-color-scheme:dark){body{color:#fff;background:#000}.next-error-h1{border-right:1px solid rgba(255,255,255,.3)}}"}}],["$","h1",null,{"className":"next-error-h1","style":{"display":"inline-block","margin":"0 20px 0 0","padding":"0 23px 0 0","fontSize":24,"fontWeight":500,"verticalAlign":"top","lineHeight":"49px"},"children":"404"}],["$","div",null,{"style":{"display":"inline-block"},"children":["$","h2",null,{"style":{"fontSize":14,"fontWeight":400,"lineHeight":"49px","margin":0},"children":"This page could not be found."}]}]]}]}]],"notFoundStyles":[],"childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$","$L4",null,{"parallelRouterKey":"children","segmentPath":["children","docs","children",["slug","2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","c"],"children"],"loading":"$undefined","loadingStyles":"$undefined","hasLoading":false,"error":"$undefined","errorStyles":"$undefined","template":["$","$L5",null,{}],"templateStyles":"$undefined","notFound":"$undefined","notFoundStyles":"$undefined","childProp":{"current":["$L6",["$","div",null,{"className":"flex min-h-screen bg-gray-50","children":[["$","aside",null,{"className":"sidebar","children":["$","div",null,{"className":"sidebar-nav","children":[["$","$L7",null,{"href":"/","className":"text-lg font-semibold text-gray-900 mb-4 block hover:text-blue-600","children":"← Engineering 101"}],["$","h2",null,{"className":"text-lg font-semibold text-gray-900 mb-4","children":"Course Content"}],["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles","className":"sidebar-item","children":"1-SOLID-Principles"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/0-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle","className":"sidebar-item","children":"1-Single-class-reponsibility-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/1-Single-class-reponsibility-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle","className":"sidebar-item","children":"2-Open-closed-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/2-Open-closed-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/2-Open-closed-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle","className":"sidebar-item","children":"3-Liskov-substitution-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/3-Liskov-substitution-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle","className":"sidebar-item","children":"4-Interface-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/4-Interface-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/4-Interface-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle","className":"sidebar-item","children":"5-Dependency-segregation-principle"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/5-Dependency-segregation-principle/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application","className":"sidebar-item","children":"reference-application"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/CI-README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/CI-README","className":"sidebar-item","children":"CI-README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet","className":"sidebar-item","children":"Dotnet"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Dotnet/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Dotnet/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Java",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java","className":"sidebar-item","children":"Java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Java/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python","className":"sidebar-item","children":"Python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache","className":"sidebar-item","children":".pytest_cache"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/.pytest_cache/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/Python/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/Python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/1-SOLID-Principles/reference-application/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript","className":"sidebar-item","children":"TypeScript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/1-SOLID-Principles/reference-application/TypeScript/README",{"children":[["$","$L7",null,{"href":"/docs/1-SOLID-Principles/reference-application/TypeScript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design","className":"sidebar-item","children":"2-Domain-Driven-Design"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/0-README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/0-README","className":"sidebar-item","children":"0-README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts","className":"sidebar-item","children":"1-Bounded-Contexts"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-Bounded-Contexts/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/1-introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/1-introduction-to-the-domain","className":"sidebar-item","children":"1-introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language","className":"sidebar-item","children":"2-Ubiquitous-Language"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/2-Ubiquitous-Language/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models","className":"sidebar-item","children":"3-Domain-Models"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/3-Domain-Models/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/3-Domain-Models/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping","className":"sidebar-item","children":"4-Context-Mapping"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/4-Context-Mapping/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/4-Context-Mapping/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns","className":"sidebar-item","children":"5-Strategic-Patterns"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/5-Strategic-Patterns/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples","className":"sidebar-item","children":"code-samples"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/README","className":"sidebar-item","children":"README"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp","className":"sidebar-item","children":"csharp"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/02-order-entity","className":"sidebar-item","children":"02-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/03-money-value-object","className":"sidebar-item","children":"03-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/csharp/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/csharp/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/introduction-to-the-domain","className":"sidebar-item","children":"introduction-to-the-domain"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java","className":"sidebar-item","children":"java"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-inventory-service","className":"sidebar-item","children":"03-inventory-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/04-order-tests","className":"sidebar-item","children":"04-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/java/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/java/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python","className":"sidebar-item","children":"python"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/python/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/python/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript","className":"sidebar-item","children":"typescript"}],["$","div",null,{"className":"ml-4 mt-1","children":["$","ul",null,{"className":"space-y-1","children":[["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/02-money-value-object","className":"sidebar-item","children":"02-money-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/03-order-entity","className":"sidebar-item","children":"03-order-entity"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/04-email-address-value-object","className":"sidebar-item","children":"04-email-address-value-object"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/05-pricing-service","className":"sidebar-item","children":"05-pricing-service"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/06-customer-module","className":"sidebar-item","children":"06-customer-module"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/07-order-tests","className":"sidebar-item","children":"07-order-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/08-money-tests","className":"sidebar-item","children":"08-money-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/09-pricing-service-tests","className":"sidebar-item","children":"09-pricing-service-tests"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/11-testing-anti-patterns","className":"sidebar-item","children":"11-testing-anti-patterns"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/12-testing-best-practices","className":"sidebar-item","children":"12-testing-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/13-domain-modeling-best-practices","className":"sidebar-item","children":"13-domain-modeling-best-practices"}],false]}],["$","li","/docs/2-Domain-Driven-Design/code-samples/typescript/README",{"children":[["$","$L7",null,{"href":"/docs/2-Domain-Driven-Design/code-samples/typescript/README","className":"sidebar-item","children":"README"}],false]}]]}]}]]}]]}]}]]}]]}]}]]}]]}]]}]}],["$","main",null,{"className":"main-content","children":["$","div",null,{"className":"content-wrapper","children":[["$","div",null,{"className":"page-header","children":["$","h1",null,{"className":"page-title","children":"04-email-address-value-object"}]}],["$","div",null,{"className":"prose prose-lg max-w-none","children":["$","div",null,{"dangerouslySetInnerHTML":{"__html":"$8"}}]}]]}]}]]}],null],"segment":"__PAGE__?{\"slug\":[\"2-Domain-Driven-Design\",\"code-samples\",\"python\",\"04-email-address-value-object\"]}"},"styles":[]}],"segment":["slug","2-Domain-Driven-Design/code-samples/python/04-email-address-value-object","c"]},"styles":[]}],"segment":"docs"},"styles":[]}]}]]}],null]
6:null
