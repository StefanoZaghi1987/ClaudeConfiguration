# Project Instructions: Universal Software Development Best Practices

## Overview

When working in this project, provide guidance based on timeless, framework-agnostic, and language-agnostic software development best practices. Focus on principles that apply universally across technology stacks, programming paradigms, and project types. Ground recommendations in industry research, proven patterns, and decades of software engineering experience.

---

## 1. Universal Coding Standards and Conventions

### Core Principles

**Readability First**: Code is read far more often than it is written. Optimize for human comprehension over brevity or cleverness.

**Consistency Over Preference**: Consistent code is more maintainable than "better" code that doesn't match the surrounding codebase. Follow established conventions within a project.

**Self-Documenting Code**: Code should explain *what* it does through clear naming and structure. Comments should explain *why* it exists or *why* a particular approach was chosen.

### Key Guidelines

**Naming Conventions**:
- Use descriptive, unambiguous names that reveal intent
- Avoid abbreviations unless universally understood in the domain
- Names should be pronounceable and searchable
- Boolean variables/functions should ask questions: `isValid`, `hasPermission`, `canExecute`
- Functions/methods should use verb phrases: `calculateTotal`, `fetchUserData`, `validateInput`
- Classes/types should use noun phrases: `UserAccount`, `OrderProcessor`, `PaymentGateway`

**Function/Method Design**:
- Functions should do one thing and do it well (Single Responsibility Principle)
- Keep functions small and focused (typically under 20-30 lines)
- Limit function parameters (ideally 0-3; consider objects/structs for more)
- Avoid side effects in functions that appear to be queries
- Use clear, consistent error handling patterns

**Code Organization**:
- Group related code together (high cohesion)
- Minimize dependencies between unrelated modules (low coupling)
- Organize by feature/domain rather than by technical layer when possible
- Keep the scope of variables as small as possible
- Declare variables close to where they're used

**Complexity Management**:
- Avoid deep nesting (more than 3-4 levels indicates need for refactoring)
- Use early returns/guard clauses to reduce nesting
- Extract complex conditionals into well-named functions
- Break down complex algorithms into smaller, testable pieces

### Common Anti-Patterns to Avoid

- **Magic Numbers**: Use named constants instead of unexplained literal values
- **God Objects**: Avoid classes/modules that know or do too much
- **Primitive Obsession**: Use domain types instead of primitives for domain concepts
- **Long Parameter Lists**: Refactor to parameter objects or builder patterns
- **Dead Code**: Remove unused code rather than commenting it out (version control preserves history)
- **Clever Code**: Avoid obscure language features or tricks that sacrifice clarity

### When to Apply

Apply these standards:
- Always, as the foundation of professional software development
- During code reviews to ensure consistency
- When onboarding new team members
- When establishing or updating team coding guidelines

---

## 2. Code Organization and Architecture Principles

### Core Principles

**Separation of Concerns**: Different aspects of the application (business logic, data access, presentation, etc.) should be separated into distinct modules or layers.

**Dependency Inversion**: High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Open/Closed Principle**: Code should be open for extension but closed for modification. Add new functionality through extension rather than changing existing code.

**Interface Segregation**: Clients should not be forced to depend on interfaces they don't use. Create focused, client-specific interfaces.

**Don't Repeat Yourself (DRY)**: Every piece of knowledge should have a single, unambiguous representation in the system.

### Key Guidelines

**Layered Architecture**:
- Separate presentation, business logic, and data access concerns
- Each layer should only depend on layers below it, never above
- Use dependency injection to manage dependencies between layers
- Define clear boundaries and contracts between layers

**Modularity**:
- Organize code into cohesive modules with well-defined responsibilities
- Modules should have high internal cohesion and low coupling to other modules
- Define clear public interfaces; hide implementation details
- Make dependencies explicit and manageable

**Domain-Driven Design Principles**:
- Model the domain accurately with ubiquitous language
- Identify and protect invariants and business rules
- Use value objects for domain concepts without identity
- Keep entities focused on identity and lifecycle management

**Dependency Management**:
- Minimize dependencies; each dependency is a coupling point
- Depend on stable abstractions rather than volatile implementations
- Use dependency injection to make dependencies explicit and testable
- Avoid circular dependencies between modules

**Scalability Patterns**:
- Design for horizontal scaling when possible
- Use stateless components where feasible
- Implement proper caching strategies at appropriate layers
- Consider event-driven architectures for decoupling

### Common Anti-Patterns to Avoid

- **Big Ball of Mud**: Avoid tangled, unstructured code with no clear architecture
- **Spaghetti Code**: Avoid complex, tangled control flow that's hard to follow
- **Tight Coupling**: Avoid direct dependencies on concrete implementations
- **Leaky Abstractions**: Ensure abstractions don't expose implementation details
- **Premature Optimization**: Don't sacrifice clarity for performance without measurement
- **Over-Engineering**: Don't add complexity for hypothetical future requirements

### When to Apply

- During initial project architecture design
- When adding new features or modules
- During major refactoring efforts
- When code reviews reveal architectural issues
- When scaling requirements change

---

## 3. Testing Strategies and Quality Assurance

### Core Principles

**Test-Driven Mindset**: Write testable code by considering testing during design, not as an afterthought.

**Test Pyramid**: Balance unit tests (many), integration tests (some), and end-to-end tests (few) based on speed, reliability, and coverage.

**Fast Feedback**: Tests should run quickly to enable rapid development cycles. Slow tests discourage frequent testing.

**Independent Tests**: Tests should not depend on each other or on external state. Each test should set up its own context.

**Deterministic Tests**: Tests should produce the same results every time. Flaky tests erode confidence.

### Key Guidelines

**Unit Testing**:
- Test individual functions/methods in isolation
- Use test doubles (mocks, stubs, fakes) for dependencies
- Each test should verify one behavior or scenario
- Follow the Arrange-Act-Assert (AAA) or Given-When-Then pattern
- Aim for high coverage of business logic and edge cases

**Integration Testing**:
- Test interactions between components or modules
- Verify that interfaces between components work correctly
- Test with real dependencies where practical, test doubles where necessary
- Focus on critical integration points and data flows

**End-to-End Testing**:
- Test complete user workflows through the system
- Use sparingly due to maintenance cost and execution time
- Focus on critical business paths and user journeys
- Keep E2E tests stable and maintainable

**Test Quality**:
- Tests should be readable and maintainable like production code
- Use descriptive test names that explain the scenario and expected outcome
- Avoid test logic complexity; tests should be straightforward
- Keep test setup (fixtures) simple and clear
- Remove or fix flaky tests immediately

**Test Coverage**:
- Aim for high coverage of business logic (80%+ is good)
- Don't chase 100% coverage; focus on valuable tests
- Measure coverage as a guide, not a goal
- Prioritize testing complexity and risk areas

**Testing Strategies**:
- Use TDD for complex algorithms and business logic
- Use BDD for user-facing features and requirements
- Property-based testing for invariants and edge cases
- Mutation testing to assess test effectiveness

### Common Anti-Patterns to Avoid

- **Testing Implementation Details**: Test behavior, not internal implementation
- **Fragile Tests**: Tests that break with trivial code changes
- **Slow Test Suites**: Tests that take too long discourage frequent execution
- **Test Interdependence**: Tests that must run in specific order or share state
- **Overmocking**: Excessive use of mocks obscures real behavior
- **Assertion Roulette**: Multiple unrelated assertions in a single test

### When to Apply

- Write tests before or alongside production code (TDD)
- Before refactoring to ensure behavior preservation
- When bugs are found, write failing tests first
- During code reviews to ensure adequate test coverage
- Continuously as part of CI/CD pipeline

---

## 4. Documentation Best Practices

### Core Principles

**Document Intent, Not Mechanics**: Code shows *how*, documentation should explain *why* and provide context.

**Documentation as Code**: Keep documentation close to code, version controlled, and maintained as code changes.

**Right Level of Detail**: Document at the appropriate level for the audience. Architecture docs differ from API docs which differ from inline comments.

**Living Documentation**: Documentation must be maintained and updated. Outdated documentation is worse than no documentation.

### Key Guidelines

**Code Comments**:
- Explain *why* code exists, not *what* it does (the code should show that)
- Document non-obvious behaviors, edge cases, or workarounds
- Explain complex algorithms or business rules
- Reference tickets, issues, or external resources for context
- Keep comments concise and relevant
- Remove obsolete comments immediately

**API Documentation**:
- Document all public interfaces, functions, and classes
- Explain parameters, return values, and side effects
- Provide usage examples for complex APIs
- Document preconditions, postconditions, and invariants
- Specify error conditions and exceptions
- Use documentation generation tools (docstrings, JSDoc, etc.)

**README Files**:
- Explain what the project does and why it exists
- Provide setup and installation instructions
- Include basic usage examples
- List dependencies and requirements
- Explain how to run tests
- Provide contribution guidelines
- Include license information

**Architectural Documentation**:
- Document high-level system architecture and components
- Use Architecture Decision Records (ADRs) for significant decisions
- Include diagrams (C4 model, sequence diagrams, etc.)
- Explain architectural patterns and their rationale
- Document integration points and dependencies
- Keep architecture docs updated as system evolves

**Process Documentation**:
- Document development workflows and processes
- Provide onboarding guides for new team members
- Explain deployment and release procedures
- Document incident response procedures
- Create runbooks for operational tasks

### Common Anti-Patterns to Avoid

- **Obvious Comments**: Don't state what's clearly visible in code
- **Outdated Documentation**: Update docs when code changes or remove them
- **Over-Documentation**: Don't document every trivial detail
- **Documentation Instead of Refactoring**: If code needs extensive explanation, consider refactoring
- **Duplicate Documentation**: Don't repeat information across multiple places

### When to Apply

- When writing public APIs or interfaces
- For complex business logic or algorithms
- When making architectural decisions (ADRs)
- During code reviews to ensure adequate documentation
- When onboarding processes identify gaps

---

## 5. Version Control and Collaboration Guidelines

### Core Principles

**Atomic Commits**: Each commit should represent a single logical change. If you can't describe the change in one sentence, it's probably multiple commits.

**Clear History**: Git history should tell the story of the project. Well-structured commits make debugging and understanding changes easier.

**Trunk-Based Development**: Keep integration branches short-lived. Integrate to main/trunk frequently to reduce merge conflicts and integration issues.

**Code Review Culture**: Every change should be reviewed. Code review improves quality, shares knowledge, and maintains standards.

### Key Guidelines

**Commit Messages**:
- Use clear, descriptive commit messages
- Follow conventional commits format: `type(scope): subject`
- Common types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`
- First line: concise summary (50 chars max)
- Blank line, then detailed explanation if needed
- Reference issue/ticket numbers
- Explain *why* and *what*, not *how* (code shows how)

**Branching Strategies**:
- Use short-lived feature branches (days, not weeks)
- Keep branches focused on single features or fixes
- Regularly sync with main/trunk to avoid conflicts
- Delete branches after merging
- Use descriptive branch names: `feature/user-authentication`, `fix/null-pointer-error`

**Pull Request/Merge Request Practices**:
- Keep PRs small and focused (easier to review)
- Provide clear description of changes and rationale
- Include test results and testing approach
- Link to related issues or tickets
- Respond promptly to review feedback
- Don't merge your own code without review (except emergency fixes)

**Code Review Standards**:
- Review code promptly (within 24 hours ideally)
- Focus on logic, design, and maintainability, not style (automate style)
- Be constructive and respectful in feedback
- Distinguish between blocking issues and suggestions
- Approve when confident, request changes when needed
- Use review as knowledge-sharing opportunity

**Collaboration Practices**:
- Communicate changes that affect others early
- Use pair programming for complex or critical changes
- Document decisions in code, commits, or ADRs
- Share knowledge through reviews and documentation
- Resolve conflicts through discussion, not force-pushing

### Common Anti-Patterns to Avoid

- **Commit Dumping**: Pushing all changes as one massive commit
- **Meaningless Messages**: "fixed stuff", "updates", "WIP"
- **Long-Lived Branches**: Feature branches open for weeks or months
- **Merge Commit Spam**: Excessive merge commits from poor branch management
- **Force Pushing Shared Branches**: Rewriting history on shared branches
- **Rubber Stamp Reviews**: Approving without actually reviewing

### When to Apply

- Every code change, no matter how small
- Before starting new features (create branch)
- Before merging (code review)
- When conflicts arise (communicate and resolve)
- During retrospectives (improve processes)

---

## 6. Security Best Practices

### Core Principles

**Defense in Depth**: Implement multiple layers of security controls. No single control should be the only defense.

**Least Privilege**: Grant minimum permissions necessary. Users, services, and code should have only the access they need.

**Fail Securely**: When errors occur, fail to a secure state. Don't leak information in error messages.

**Secure by Default**: Systems should be secure without requiring configuration. Security should not be opt-in.

**Zero Trust**: Never trust input. Always validate and sanitize. Don't assume internal systems are safe.

### Key Guidelines

**Input Validation**:
- Validate all input from untrusted sources (users, APIs, files, etc.)
- Use allowlists (what's permitted) rather than denylists (what's forbidden)
- Validate data type, format, length, and range
- Sanitize input to prevent injection attacks
- Reject invalid input; don't try to fix it

**Authentication & Authorization**:
- Use strong authentication mechanisms (multi-factor when possible)
- Never store passwords in plain text; use strong hashing (bcrypt, Argon2)
- Implement proper session management
- Use token expiration and rotation
- Enforce authorization at every access point, not just UI
- Implement proper role-based or attribute-based access control

**Data Protection**:
- Encrypt sensitive data at rest and in transit
- Use established cryptographic libraries; never roll your own crypto
- Protect encryption keys properly (key management systems)
- Minimize sensitive data collection and storage
- Implement proper data retention and deletion policies
- Comply with regulations (GDPR, CCPA, etc.)

**Secure Communication**:
- Use TLS/SSL for all network communication
- Validate certificates and implement certificate pinning where appropriate
- Avoid deprecated protocols and ciphers
- Implement proper CORS policies
- Use secure headers (CSP, HSTS, X-Frame-Options, etc.)

**Error Handling & Logging**:
- Don't expose sensitive information in error messages
- Log security events for monitoring and forensics
- Don't log sensitive data (passwords, tokens, PII)
- Implement proper log retention and protection
- Monitor logs for security incidents

**Dependency Management**:
- Keep dependencies updated to patch vulnerabilities
- Audit dependencies for known vulnerabilities regularly
- Minimize dependencies; each is a potential attack vector
- Pin dependency versions in production
- Use dependency scanning tools in CI/CD

**Common Vulnerabilities (OWASP Top 10)**:
- Injection attacks (SQL, Command, LDAP, etc.)
- Broken authentication
- Sensitive data exposure
- XML external entities (XXE)
- Broken access control
- Security misconfiguration
- Cross-site scripting (XSS)
- Insecure deserialization
- Using components with known vulnerabilities
- Insufficient logging & monitoring

### Common Anti-Patterns to Avoid

- **Security Through Obscurity**: Don't rely on hiding implementation details
- **Hard-Coded Credentials**: Never commit secrets to version control
- **Client-Side Security**: Don't trust client-side validation or authorization
- **Ignoring Updates**: Running outdated dependencies with known vulnerabilities
- **Excessive Privileges**: Running services or code with unnecessary permissions
- **Weak Cryptography**: Using deprecated algorithms or weak keys

### When to Apply

- During design phase (threat modeling)
- Every code change (secure coding practices)
- In code reviews (security checklist)
- Regular security audits and penetration testing
- When adding dependencies (security assessment)
- Incident response and remediation

---

## 7. Performance Optimization Principles

### Core Principles

**Measure First**: Don't optimize without profiling. Measure to identify bottlenecks, optimize those, then measure again.

**Premature Optimization is Evil**: Write clear, correct code first. Optimize only when performance issues are identified and measured.

**User-Perceived Performance**: Optimize what users notice. A 100ms improvement in page load matters more than a 100ms improvement in a background job.

**Algorithmic Efficiency**: The right algorithm beats micro-optimizations. O(n²) → O(n log n) matters more than language-specific tricks.

### Key Guidelines

**Performance Profiling**:
- Use profiling tools to identify actual bottlenecks
- Measure under realistic conditions (production-like data and load)
- Profile CPU, memory, I/O, and network separately
- Focus on the slowest operations first (biggest impact)
- Keep baseline measurements for comparison

**Algorithmic Optimization**:
- Choose appropriate data structures (hash maps, trees, etc.)
- Understand time and space complexity of algorithms
- Avoid unnecessary loops and iterations
- Use appropriate search and sort algorithms
- Cache computation results when appropriate

**Database Performance**:
- Index frequently queried columns
- Optimize queries (avoid N+1, use joins appropriately)
- Use database explain/analyze tools to understand query plans
- Avoid loading unnecessary data (SELECT *)
- Implement proper connection pooling
- Use caching layers for read-heavy workloads
- Consider denormalization for read performance (with caution)

**Caching Strategies**:
- Cache at appropriate levels (application, database, CDN)
- Use cache invalidation strategies (TTL, event-based)
- Be aware of cache stampede and implement protections
- Don't cache everything; cache what's expensive to compute
- Monitor cache hit rates

**Network Performance**:
- Minimize network requests (batching, bundling)
- Reduce payload sizes (compression, minification)
- Use CDNs for static assets
- Implement pagination for large datasets
- Use efficient serialization formats
- Consider HTTP/2 and HTTP/3 features

**Resource Management**:
- Release resources promptly (connections, file handles, memory)
- Implement proper connection pooling
- Use lazy loading where appropriate
- Avoid resource leaks
- Monitor resource usage

**Scalability Patterns**:
- Design for horizontal scaling
- Use asynchronous processing for long-running tasks
- Implement proper queueing for background jobs
- Use load balancing effectively
- Consider eventual consistency where appropriate
- Implement circuit breakers and backpressure

### Common Anti-Patterns to Avoid

- **Premature Optimization**: Optimizing before identifying real bottlenecks
- **Micro-Optimization**: Focusing on insignificant improvements
- **Over-Caching**: Caching everything, making cache invalidation complex
- **Ignoring Trade-offs**: Sacrificing maintainability for marginal gains
- **N+1 Queries**: Loading data in loops instead of batching
- **Synchronous Everything**: Blocking operations where async would help

### When to Apply

- After measuring and identifying bottlenecks
- When performance requirements are not being met
- During capacity planning for scale
- When architectural decisions impact performance
- Not before code works correctly
- After code reviews identify obvious inefficiencies

---

## 8. Code Review Standards

### Core Principles

**Constructive Feedback**: Code review is about improving code and sharing knowledge, not criticism.

**Clarity Over Brevity**: Clear, maintainable code is better than clever or terse code.

**Shared Ownership**: Code review distributes knowledge and responsibility across the team.

**Continuous Improvement**: Every review is an opportunity to improve both code and team practices.

### Key Guidelines

**What to Review**:

*Design and Architecture*:
- Does the change fit the existing architecture?
- Is the solution appropriately complex (not over- or under-engineered)?
- Are abstractions at the right level?
- Does it follow SOLID principles?

*Code Quality*:
- Is the code readable and maintainable?
- Are names clear and meaningful?
- Are functions/methods appropriately sized and focused?
- Is there duplicated code that should be extracted?
- Are edge cases handled?

*Testing*:
- Are there adequate tests for the changes?
- Do tests cover edge cases and error conditions?
- Are tests clear and maintainable?
- Do tests actually test the right things?

*Security*:
- Are inputs validated?
- Are there potential security vulnerabilities?
- Is sensitive data handled properly?
- Are authentication and authorization correct?

*Performance*:
- Are there obvious performance issues?
- Is the database queried efficiently?
- Are resources managed properly?

*Documentation*:
- Is complex logic explained?
- Are API changes documented?
- Are architectural decisions recorded?

**How to Review**:

*For Reviewers*:
- Review promptly (within 24 hours)
- Read the entire changeset with context
- Run and test the code locally if significant
- Ask questions when unclear ("Why?" rather than "Change this")
- Distinguish between must-fix issues and suggestions
- Provide specific, actionable feedback
- Acknowledge good patterns and improvements
- Be respectful and assume good intent

*For Authors*:
- Keep changes small and focused
- Provide clear description and context
- Respond to all comments
- Don't take feedback personally
- Ask for clarification when needed
- Make requested changes or discuss alternatives
- Thank reviewers for their time and feedback

**Review Comments**:
- Use clear labels: Required, Suggestion, Question, Nit
- Explain *why* a change is needed, not just *what*
- Provide examples or references when helpful
- Be specific about what should change
- Balance criticism with acknowledgment of good work

**Review Process**:
- Establish team standards for what requires review
- Use checklists for consistency
- Automate style and formatting checks (don't review formatting)
- Balance thoroughness with velocity
- Rotate reviewers to spread knowledge
- Use review metrics to improve (time to review, iterations, etc.)

### Common Anti-Patterns to Avoid

- **Rubber Stamping**: Approving without actually reviewing
- **Nitpicking**: Focusing on trivial issues while missing major problems
- **Style Debates**: Arguing about subjective preferences (automate this)
- **Delayed Reviews**: Letting PRs sit for days
- **Hostile Comments**: Disrespectful or condescending feedback
- **Approval Shopping**: Seeking approvals until someone says yes
- **Incomplete Reviews**: Only reviewing part of the changes

### When to Apply

- Every code change before merging to main/trunk
- Higher scrutiny for critical or security-sensitive code
- More thorough reviews for new team members
- Lighter reviews for trivial changes (documentation, typos)
- Paired reviews for complex architectural changes

---

## 9. Refactoring and Technical Debt Management

### Core Principles

**Continuous Improvement**: Refactor incrementally as part of normal development, not in isolation.

**Working Code First**: Refactor only after code works correctly. Tests should pass before and after.

**Red-Green-Refactor**: Make tests pass (green), then improve code (refactor), maintaining green tests.

**Boy Scout Rule**: Leave code better than you found it. Small improvements accumulate over time.

**Technical Debt is Strategic**: Not all debt is bad. Intentional debt can accelerate delivery if managed properly.

### Key Guidelines

**When to Refactor**:
- During feature development when working in the area
- When you touch code and see opportunities for improvement
- Before adding functionality that current structure makes difficult
- When code smells become apparent
- During dedicated improvement sprints (sparingly)
- NOT as separate "refactoring tasks" disconnected from features

**Common Refactoring Patterns**:
- Extract method/function for repeated or complex code
- Rename variables, functions, classes for clarity
- Simplify complex conditionals
- Remove dead code
- Consolidate duplicate code
- Break up large functions or classes
- Reduce coupling between modules
- Improve error handling

**Technical Debt Management**:

*Types of Debt*:
- **Deliberate**: Conscious decision to ship faster (must track and address)
- **Accidental**: Emerges from learning, changing requirements, or mistakes
- **Bit Rot**: Code that degrades as systems around it evolve

*Managing Debt*:
- Make debt visible (document in ADRs, backlog, or code comments)
- Assess impact and risk (not all debt is equal)
- Plan incremental paydown
- Balance new features with debt reduction
- Track debt metrics (code complexity, duplication, test coverage)
- Communicate debt to stakeholders

*Prioritizing Refactoring*:
- High-change, high-pain areas first (frequently modified, hard to work with)
- Areas blocking new features or causing bugs
- Critical path code
- Don't refactor stable code that rarely changes
- Use metrics: change frequency × complexity

**Safe Refactoring Practices**:
- Ensure comprehensive test coverage before refactoring
- Make small, incremental changes
- Run tests after each change
- Commit after each successful refactoring step
- Use IDE refactoring tools when available
- Review refactorings like any other code change
- Don't change behavior and refactor simultaneously

**Code Smells to Watch For**:
- Long methods or functions
- Large classes with too many responsibilities
- Long parameter lists
- Duplicated code
- Complex conditionals
- Deep nesting
- Feature envy (method uses another class more than its own)
- Primitive obsession (using primitives instead of domain types)
- Data clumps (same group of data passed around together)

### Common Anti-Patterns to Avoid

- **Big Bang Refactoring**: Large, risky refactoring disconnected from features
- **Refactoring Without Tests**: Changing code without safety net
- **Indefinite Debt**: Accumulating debt without plan to address
- **Gold Plating**: Over-refactoring or premature abstraction
- **Scope Creep**: Refactoring expanding beyond initial scope
- **Ignoring Debt**: Pretending technical debt doesn't exist

### When to Apply

- Continuously as part of normal development
- Before adding features to hard-to-modify code
- When code reviews identify debt
- During retrospectives to plan debt reduction
- When bugs cluster in certain areas
- When velocity decreases due to code quality

---

## 10. CI/CD and Deployment Best Practices

### Core Principles

**Automate Everything**: Manual processes are error-prone and inconsistent. Automate builds, tests, and deployments.

**Continuous Integration**: Integrate code to mainline frequently (at least daily). Catch integration issues early.

**Fast Feedback**: CI pipelines should be fast (under 10 minutes ideally) to encourage frequent commits.

**Deploy Frequently**: Small, frequent deployments reduce risk compared to large, infrequent releases.

**Rollback Capability**: Every deployment should be reversible quickly if issues arise.

### Key Guidelines

**Continuous Integration**:
- Commit to mainline frequently (multiple times per day)
- Every commit triggers automated build and test
- Fix broken builds immediately (stop the line)
- Keep build fast (under 10 minutes for primary build)
- Use build artifacts, not rebuilding for each environment
- Fail fast: run fastest tests first

**Build Automation**:
- Use consistent, reproducible builds
- Version all build artifacts
- Build once, deploy many times
- Include dependency versions in builds
- Generate build metadata (version, commit hash, timestamp)
- Keep build scripts in version control
- Make builds deterministic (same input = same output)

**Testing in CI/CD**:
- Run unit tests on every commit
- Run integration tests on every build
- Run E2E tests before production deployment
- Use test parallelization for speed
- Quarantine flaky tests
- Monitor test execution time
- Fail builds on test failures

**Deployment Strategies**:

*Blue-Green Deployment*:
- Maintain two identical production environments
- Deploy to inactive (green) while active (blue) serves traffic
- Switch traffic after validation
- Easy rollback by switching back

*Canary Deployment*:
- Deploy to small subset of users first
- Monitor metrics closely
- Gradually increase traffic to new version
- Rollback if issues detected

*Feature Flags*:
- Deploy code with features disabled
- Enable features independently of deployment
- Test in production safely
- Quick feature rollback without redeployment

**Infrastructure as Code**:
- Define infrastructure in version control
- Use declarative configuration
- Automate infrastructure provisioning
- Ensure consistency across environments
- Review infrastructure changes like code changes
- Test infrastructure changes in non-production first

**Environment Management**:
- Keep environments as similar as possible
- Use same deployment process for all environments
- Test in production-like staging environment
- Avoid "works on my machine" issues
- Use containers or VMs for consistency
- Manage environment-specific configuration separately

**Deployment Safety**:
- Implement health checks and readiness probes
- Use gradual rollouts for risky changes
- Monitor key metrics during deployment
- Implement automated rollback on failure
- Test rollback procedures regularly
- Maintain deployment runbooks

**Release Management**:
- Version releases semantically (SemVer)
- Maintain changelog of changes
- Tag releases in version control
- Coordinate releases across dependent services
- Communicate releases to stakeholders
- Plan maintenance windows for breaking changes

### Common Anti-Patterns to Avoid

- **Manual Deployments**: Error-prone and inconsistent
- **Long-Lived Branches**: Delaying integration increases risk
- **Environment Drift**: Differences between environments hide bugs
- **Deployment Freeze**: Batching changes increases risk
- **No Rollback Plan**: Unable to revert problematic deployments
- **Ignoring Failed Tests**: Accepting CI failures as normal
- **Flaky Tests**: Tests that randomly fail and pass

### When to Apply

- From day one of project (set up CI/CD early)
- Every code change (continuous integration)
- Multiple times per day (continuous deployment for mature teams)
- Before major releases (ensure pipeline health)
- After incidents (improve deployment safety)
- During retrospectives (optimize pipeline)

---

## 11. Monitoring and Observability Principles

### Core Principles

**Observability Over Monitoring**: Systems should be observable, allowing questions about unknown problems, not just monitoring known issues.

**Measure What Matters**: Focus on metrics that reflect user experience and business value, not vanity metrics.

**Three Pillars**: Implement metrics, logs, and traces for comprehensive observability.

**Actionable Alerts**: Alerts should require action. Too many alerts lead to alert fatigue.

### Key Guidelines

**Metrics Collection**:

*System Metrics*:
- CPU, memory, disk, network utilization
- Request rate, error rate, response time
- Database connection pool usage
- Queue depths and processing rates
- Cache hit/miss rates

*Application Metrics*:
- Business KPIs (orders, transactions, etc.)
- Feature usage and adoption
- User engagement metrics
- Error rates and types
- Latency percentiles (p50, p95, p99)

*RED Method (Rate, Errors, Duration)*:
- Request rate: requests per second
- Error rate: percentage of failed requests
- Duration: latency distribution

*USE Method (Utilization, Saturation, Errors)*:
- For resources: utilization, saturation, errors

**Logging Best Practices**:
- Use structured logging (JSON, key-value pairs)
- Include context (request ID, user ID, session ID)
- Log appropriate levels (DEBUG, INFO, WARN, ERROR)
- Don't log sensitive data (PII, credentials, tokens)
- Include timestamps and log sources
- Aggregate logs centrally
- Set appropriate retention policies
- Make logs searchable

**Distributed Tracing**:
- Trace requests across services
- Include correlation IDs in all logs
- Visualize request paths and timing
- Identify bottlenecks in distributed systems
- Understand dependencies and failures

**Alerting Strategy**:
- Alert on symptoms, not causes
- Define clear SLOs (Service Level Objectives)
- Alert when SLOs are at risk
- Include runbooks in alerts
- Use appropriate severity levels
- Implement alert routing and escalation
- Review and tune alerts regularly
- Measure alert actionability

**Dashboards**:
- Create role-specific dashboards (ops, development, business)
- Focus on actionable metrics
- Use consistent visualization conventions
- Include context and time ranges
- Link to runbooks and related resources
- Keep dashboards maintained and relevant

**Service Level Objectives (SLOs)**:
- Define user-facing metrics
- Set realistic, measurable targets
- Track error budgets
- Use SLOs to prioritize work
- Review and adjust SLOs regularly

**Incident Response**:
- Document on-call procedures
- Maintain runbooks for common issues
- Implement incident communication plans
- Conduct blameless post-mortems
- Track and learn from incidents
- Improve observability based on incidents

### Common Anti-Patterns to Avoid

- **Alert Fatigue**: Too many non-actionable alerts
- **Vanity Metrics**: Tracking metrics that don't drive decisions
- **Log Everything**: Logging too much makes finding issues harder
- **No Context**: Logs without correlation IDs or request context
- **Stale Dashboards**: Outdated, unused dashboards
- **Reactive Only**: Only adding monitoring after incidents
- **Ignoring Baselines**: Not understanding normal system behavior

### When to Apply

- From project inception (build observability in)
- Before deploying to production
- After incidents (add missing observability)
- When scaling or changing architecture
- Continuously (improve and refine)
- During capacity planning
- When optimizing performance

---

## 12. Accessibility and Internationalization Considerations

### Core Principles

**Inclusive by Default**: Design and build for all users from the start, not as an afterthought.

**Legal Compliance**: Many jurisdictions require accessibility (ADA, WCAG, etc.). Compliance is mandatory.

**Progressive Enhancement**: Core functionality should work for everyone; enhance for capable systems.

**Cultural Sensitivity**: Respect cultural differences in design, content, and interaction patterns.

### Key Guidelines

**Accessibility (A11y)**:

*Semantic Structure*:
- Use semantic HTML/markup
- Proper heading hierarchy
- Meaningful element roles and labels
- Landmark regions for navigation

*Keyboard Navigation*:
- All functionality accessible via keyboard
- Visible focus indicators
- Logical tab order
- Keyboard shortcuts documented

*Screen Reader Support*:
- Provide alternative text for images
- Use ARIA labels where needed
- Describe non-text content
- Announce dynamic content changes
- Provide skip links

*Visual Design*:
- Sufficient color contrast (WCAG AA minimum: 4.5:1 for text)
- Don't rely solely on color to convey information
- Resizable text without breaking layout
- Clear, readable fonts
- Support for high contrast mode

*Forms and Inputs*:
- Label all form fields
- Provide clear error messages
- Use appropriate input types
- Indicate required fields
- Provide input format examples

*Testing*:
- Use automated accessibility testing tools
- Test with actual assistive technologies
- Include users with disabilities in testing
- Validate against WCAG guidelines

**Internationalization (i18n)**:

*Text and Content*:
- Externalize all user-facing strings
- Use resource bundles or localization files
- Support right-to-left (RTL) languages
- Avoid hard-coded text
- Allow for text expansion (some languages need 30% more space)
- Don't concatenate translated strings

*Formatting*:
- Use locale-specific date/time formatting
- Support local number formats (decimal separators)
- Handle currency properly (symbols, placement)
- Support locale-specific sorting

*Character Encoding*:
- Use UTF-8 everywhere
- Handle multi-byte characters properly
- Validate input handling for all character sets
- Test with non-Latin alphabets

*Cultural Considerations*:
- Be aware of cultural symbols and colors
- Respect local holidays and calendars
- Handle names properly (not all cultures use first/last name)
- Support multiple address formats
- Be sensitive to images and icons

*Localization (l10n)*:
- Provide professional translations
- Allow for regional variations
- Test UI with translated content
- Support locale switching
- Handle plural forms correctly (different rules per language)

### Common Anti-Patterns to Avoid

- **Accessibility as Afterthought**: Adding accessibility late in development
- **Color Only Information**: Using only color to convey meaning
- **Keyboard Traps**: Elements that trap keyboard focus
- **Missing Labels**: Forms without proper labels
- **Hard-Coded Strings**: Text embedded in code
- **Assumed Formats**: Expecting specific date/number formats
- **ASCII Assumptions**: Assuming all text is ASCII
- **Cultural Insensitivity**: Using region-specific symbols or colors

### When to Apply

- From initial design phase
- During development of all UI components
- In code reviews (check for a11y and i18n)
- Before each release (accessibility testing)
- When entering new markets (localization)
- After user feedback about accessibility
- Continuously as requirements evolve

---

## General Guidance for Claude

When providing assistance in this project:

1. **Focus on Principles**: Emphasize the underlying principles that transcend specific technologies. Explain the "why" behind recommendations.

2. **Technology Agnostic**: Avoid referencing specific frameworks, libraries, or tools unless explicitly asked. Keep advice applicable to any technology stack.

3. **Provide Context**: Explain when and why to apply certain practices. Software engineering is about trade-offs.

4. **Cite Best Practices**: Reference industry standards, research, or proven patterns when relevant (SOLID, Clean Code, OWASP, etc.).

5. **Encourage Critical Thinking**: Help users understand principles so they can make informed decisions for their specific context.

6. **Balance Pragmatism**: While promoting best practices, acknowledge that real-world constraints exist. Perfect is the enemy of good.

7. **Stay Current on Timeless Principles**: Focus on practices that have stood the test of time and are backed by research, not trends.

8. **Be Actionable**: Provide concrete, actionable guidance that users can implement immediately.

9. **Acknowledge Trade-offs**: Every decision has trade-offs. Help users understand and evaluate them.

10. **Foster Learning**: Encourage understanding of fundamentals. Don't just tell what to do, help users understand why.
