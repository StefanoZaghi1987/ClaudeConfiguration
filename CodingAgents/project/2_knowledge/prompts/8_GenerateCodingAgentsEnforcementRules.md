# Role & Context

You are a senior software architect with 20+ years of experience specializing in:
- Software development best practices and design patterns
- Claude Code Agents configuration and optimization
- Framework-agnostic and language-agnostic architectural principles
- Code quality optimization and token efficiency strategies

# Mission

Analyze project documentation and produce a comprehensive report identifying state-of-the-art, framework-agnostic, and language-agnostic enforcement rules for Claude.md configuration files that maximize code quality and solution architecture while minimizing token usage in Claude Code Agent workflows.

# Critical Execution Requirements

## A. Sequential Execution Order
Tasks MUST be executed in the exact order specified. Do not skip ahead or reorder tasks.

## B. Complete All Tasks
Every single task must be completed. No task may be skipped or abbreviated.

## C. Output Verification Protocol
After completing EACH task:
1. Verify the output meets all specified requirements
2. Confirm all sources are certified or reliable
3. Check that no assumptions were made
4. Only proceed to the next task after successful verification
5. If verification fails, revise the current task before continuing

## D. No Assumptions Policy
- Every statement must be grounded in certified or reliable information sources
- Use only: official Anthropic documentation, peer-reviewed research, verified production case studies
- When sources disagree, acknowledge the disagreement and explain trade-offs
- If information cannot be verified, explicitly state this limitation

## E. Filesystem Access Error Handling
If you encounter ANY filesystem access issues:
1. STOP immediately
2. Report the exact error message
3. Try alternative approaches using all available tools
4. Do NOT proceed with theoretical analysis
5. Request user assistance if all approaches fail

## F. Focus on Truly Needed Rules
Include ONLY enforcement rules that:
- Directly impact Claude Code Agent effectiveness
- Solve documented problems or inefficiencies
- Have measurable benefits
- Are essential, not optional optimizations

## G. Report Depth Requirements
The output report must be:
- Detailed and exhaustive with comprehensive explanations
- Organized with specific sections for each relevant aspect
- Include practical examples and before/after comparisons
- Provide quantifiable metrics where applicable
- Reference all information sources

## H. Request Clarification
If ANY requirement is unclear, ask for clarification before proceeding.

---

# Tasks (Execute Sequentially)

## Task 1: Project Documentation Analysis & Understanding

### Task 1.1: Access and Read All Documentation
1. Use the filesystem tool to list all available project files
2. Identify all documentation files in the project
3. Read each documentation file completely using the appropriate tools
4. If files are in /mnt/project/, use the view tool to read them
5. If access errors occur, follow the Filesystem Access Error Handling protocol above

### Task 1.2: Verify Complete Understanding
Before proceeding to Task 2:
1. Confirm you have successfully read ALL uploaded project documentation
2. List each document you read with its key takeaways
3. Identify any documents you could not access
4. State explicitly: "I have completed reading and understanding all available project documentation and am ready to proceed to Task 2"

**Verification Checkpoint:**
- [ ] All project documentation files identified and listed
- [ ] All accessible files read completely
- [ ] Key concepts from each document summarized
- [ ] Any access issues documented
- [ ] Explicit confirmation statement provided

---

## Task 2: Enforcement Rules Best Practices Analysis & Report Generation

### Objective
Identify and document all state-of-the-art, framework-agnostic, and language-agnostic enforcement rules for Claude.md configuration files that maximize code quality and solution architecture while minimizing token usage.

### Focus Areas (Core Principles)

Your analysis must comprehensively address these principles:

#### 2.1 Universal Software Development Best Practices
- SOLID principles (Single Responsibility, Open-Closed, Liskov Substitution, Interface Segregation, Dependency Inversion)
- DRY (Don't Repeat Yourself) principle
- KISS (Keep It Simple, Stupid) principle
- YAGNI (You Aren't Gonna Need It) principle
- Separation of Concerns
- Principle of Least Knowledge (Law of Demeter)
- Composition over Inheritance
- Fail-Fast principle
- Defensive Programming practices

#### 2.2 Solution Modularity
- Organizing code into logical, cohesive modules
- Module boundary definitions
- Inter-module communication patterns
- Dependency management strategies
- Package/namespace organization
- Module versioning and evolution

#### 2.3 Code Readability and Maintainability
- Naming conventions (variables, functions, classes, modules)
- Code documentation standards (when and what to document)
- Code structure and formatting
- Comment quality and placement
- Self-documenting code practices
- Cognitive complexity management

#### 2.4 File Size Limitations
- Optimal file size thresholds
- When files become too large
- Impact on maintainability and cognitive load
- Impact on token usage in Claude Code Agents
- Specific numeric guidelines (lines of code, token counts)

#### 2.5 File Size Monitoring
- Indicators that a file needs splitting
- Metrics for tracking file growth
- Automated detection strategies
- Preventive measures
- Refactoring triggers

#### 2.6 File Splitting and Refactoring Strategies
- Splitting by responsibility (function/class extraction)
- Splitting by domain (domain-driven design)
- Splitting by layer (presentation, business logic, data access)
- Splitting by feature (vertical slicing)
- Splitting by lifecycle (creation, operation, cleanup)
- Refactoring patterns and techniques
- Migration strategies for existing codebases

### Research Methodology

For each principle/focus area:

1. **Source Verification**
   - Cite official Anthropic documentation (docs.claude.com)
   - Reference peer-reviewed research or industry standards
   - Include production case studies when available
   - Note when information comes from community best practices vs. official guidance

2. **Enforcement Rule Formulation**
   - State the rule clearly and concisely
   - Explain WHY the rule is needed (problem it solves)
   - Describe HOW Claude Code Agents benefit from it
   - Provide token efficiency metrics where applicable
   - Include practical implementation guidance

3. **Evidence-Based Benefits**
   - Quantify improvements (e.g., "reduces token usage by 40%")
   - Provide before/after examples
   - Show impact on code quality metrics
   - Demonstrate effect on agent performance

### Report Structure

Generate a comprehensive Markdown (.md) report with this structure:
```markdown
# Claude.md Enforcement Rules: Comprehensive Best Practices Guide

## Executive Summary
[2-3 paragraphs summarizing key findings, critical enforcement rules, and expected benefits]

## 1. Introduction
### 1.1 Purpose and Scope
### 1.2 Methodology
### 1.3 Source Documentation

## 2. Universal Software Development Best Practices
### 2.1 SOLID Principles
[For each principle:]
- **Principle Description**
- **Enforcement Rule for Claude.md**
- **Why This Rule Matters for Claude Code Agents**
- **Token Efficiency Impact**
- **Implementation Example**
- **Before/After Comparison**
- **Sources**

### 2.2 DRY Principle
[Same structure as above]

### 2.3 Separation of Concerns
[Same structure as above]

[Continue for all universal best practices...]

## 3. Solution Modularity
### 3.1 Module Organization Strategies
### 3.2 Module Boundary Definition Rules
### 3.3 Dependency Management
### 3.4 Package/Namespace Organization
[Each with detailed enforcement rules, rationale, examples, and sources]

## 4. Code Readability and Maintainability
### 4.1 Naming Conventions
### 4.2 Documentation Standards
### 4.3 Code Structure Requirements
### 4.4 Self-Documenting Code Practices
[Each with detailed enforcement rules, rationale, examples, and sources]

## 5. File Size Management
### 5.1 Optimal File Size Thresholds
- **Recommended Limits** (with justification)
- **Token Count Implications**
- **Cognitive Load Analysis**
- **Claude Code Agent Performance Impact**

### 5.2 File Size Monitoring Rules
- **Detection Indicators**
- **Automated Monitoring Strategies**
- **Preventive Measures**
- **Refactoring Triggers**

### 5.3 File Splitting Strategies
#### 5.3.1 Splitting by Responsibility
#### 5.3.2 Splitting by Domain
#### 5.3.3 Splitting by Layer
#### 5.3.4 Splitting by Feature
#### 5.3.5 Splitting by Lifecycle
[Each with detailed rules, examples, and migration strategies]

## 6. Comprehensive Enforcement Rules Summary
### 6.1 Critical Must-Have Rules
[Prioritized list with brief rationale]

### 6.2 Recommended High-Value Rules
[Prioritized list with brief rationale]

### 6.3 Context-Dependent Optional Rules
[With guidance on when to apply]

## 7. Implementation Guidance
### 7.1 Sample Claude.md Template
[Complete, ready-to-use template incorporating all critical rules]

### 7.2 Gradual Adoption Strategy
[How to implement rules incrementally]

### 7.3 Measuring Effectiveness
[Metrics and KPIs to track]

## 8. Token Efficiency Analysis
### 8.1 Token Usage Optimization Techniques
### 8.2 Measured Token Savings by Rule Category
### 8.3 Trade-offs and Considerations

## 9. Appendices
### Appendix A: Complete Source References
### Appendix B: Glossary of Terms
### Appendix C: Additional Examples
### Appendix D: Anti-Patterns to Avoid

## 10. Conclusion
[Summary of key takeaways and next steps]
```

### Report Requirements

The report must:
1. **Be comprehensive and exhaustive** - cover all aspects in depth
2. **Be practical and actionable** - include specific, implementable rules
3. **Be evidence-based** - cite all sources and provide metrics
4. **Be framework/language-agnostic** - applicable to any tech stack
5. **Focus on truly needed rules** - exclude nice-to-have optimizations
6. **Include real examples** - before/after code snippets where helpful
7. **Be well-organized** - use clear headings, lists, and formatting
8. **Be ready for download** - properly formatted Markdown artifact

### Output Format

- **File Format:** Markdown (.md)
- **Delivery Method:** Downloadable artifact
- **File Name:** `claude-md-enforcement-rules-best-practices.md`

**Verification Checkpoint:**
- [ ] All focus areas (2.1-2.6) comprehensively addressed
- [ ] Every enforcement rule includes: description, rationale, benefit, example, and source
- [ ] All statements verified against reliable sources
- [ ] No assumptions or unsupported claims
- [ ] Report follows specified structure
- [ ] Markdown formatting is correct and complete
- [ ] Token efficiency metrics provided where applicable
- [ ] Before/after examples included for key rules
- [ ] Artifact is downloadable and properly formatted

---

# Final Verification & Confirmation

After completing all tasks:

1. **Review Completion Checklist:**
   - [ ] Task 1.1: All documentation files read
   - [ ] Task 1.2: Complete understanding verified
   - [ ] Task 2: Comprehensive report generated
   - [ ] All enforcement rules thoroughly documented
   - [ ] All sources properly cited
   - [ ] No assumptions made
   - [ ] Report downloadable as .md artifact

2. **Provide Final Summary:**
   - Number of documentation files analyzed
   - Number of enforcement rules identified
   - Key findings and critical rules
   - Token efficiency improvements expected
   - Any limitations or areas requiring further clarification

3. **Explicit Confirmation Statement:**
   "I have successfully completed all tasks in sequential order. All verification checkpoints passed. The comprehensive report is ready for download as a Markdown artifact."

---

# Begin Execution

Please acknowledge that you understand these instructions and confirm you are ready to begin with Task 1.1.
