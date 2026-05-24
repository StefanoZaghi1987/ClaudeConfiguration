# Prompt for Claude: Cross-Reference & File Linking Methods Analysis

I need you to analyze state-of-the-art methods for structuring references between Claude.md configuration files and other project documentation/configuration files. Follow these tasks sequentially:

## Task 1: Project Documentation Analysis & Understanding

**Objective**: Comprehensively read and understand all uploaded project documentation.

**Actions**:
1. Use `project_knowledge_search` to discover all available documentation in the project knowledge base
2. Search for: "Claude.md configuration", "best practices", "modularization", "token optimization", "file organization"
3. Read each discovered document completely
4. Identify key concepts, principles, and guidelines already established
5. Note any existing guidance on file references or modularization

**Verification Checkpoint**:
- Confirm you have identified and read ALL project documentation files
- List all documents analyzed with their key topics
- Confirm understanding of existing modularization rules (which should NOT be re-explained in final output)
- State: "Task 1 verification complete - all documentation analyzed" before proceeding

**If filesystem access issues occur**: STOP immediately, report exact error, try alternative tools, do NOT make assumptions, request help if needed.

---

## Task 2: Cross-Reference Methods Analysis

**Objective**: Identify ALL state-of-the-art methods for referencing external files from Claude.md, analyzing their syntaxes, context-loading approaches, token efficiency, and practical applications.

**Focus Areas** (analyze each comprehensively):

### 2.1 Direct Cross-Reference Methods
- Markdown link syntax variations
- Inline vs. reference-style links
- Relative vs. absolute path conventions
- Section/heading anchors within documents
- Context-loading behavior for each approach
- Token consumption patterns

### 2.2 File Import/Inclusion Methods
- File content embedding techniques
- Partial file inclusion (specific sections/lines)
- Dynamic vs. static inclusion
- Preprocessing approaches
- Token implications of each method

### 2.3 Path-Based Reference Strategies
- Directory structure conventions
- Naming patterns for referenced files
- Hierarchical vs. flat organization
- Path resolution mechanics
- Context discovery optimization

### 2.4 Semantic Reference Approaches
- Topic-based references ("see X documentation")
- Conditional references ("when Y, consult Z")
- Layered reference strategies (overview vs. detail)
- Context-aware referencing

### 2.5 Hybrid and Advanced Methods
- Combining multiple reference types
- Template-based approaches
- Configuration inheritance patterns
- Multi-file coordination strategies

**For EACH method identified, analyze**:
1. **Syntax**: Exact notation and format requirements
2. **Context-Loading**: How Claude accesses and processes the referenced content
3. **Token Efficiency**: Comparative token usage (reference vs. inline content)
4. **Use Cases**: When this method is optimal
5. **Limitations**: Known constraints or drawbacks
6. **Best Practices**: Recommended implementation patterns
7. **Examples**: Concrete before/after demonstrations

**Research Requirements**:
- Ground ALL findings in project documentation OR established software engineering sources
- Use `project_knowledge_search` extensively to find relevant information
- Use `web_search` for industry standards and community best practices ONLY when project documentation is insufficient
- Cite specific sources for each method identified
- NO assumptions - every statement must be verifiable

**Comparative Analysis**:
- Create detailed comparison matrix of all methods
- Evaluate: token efficiency, complexity, maintainability, flexibility, tool support
- Identify optimal use cases for each approach
- Provide decision framework for method selection

**Verification Checkpoint**:
- Confirm you have analyzed ALL major state-of-the-art referencing methods
- Verify each method has complete syntax, context-loading, and token analysis
- Confirm all statements are sourced from project docs or reliable sources
- State: "Task 2 verification complete - comprehensive methods analysis finished" before proceeding

---

## Task 3: Generate Comprehensive Report

**Objective**: Create detailed, exhaustive Markdown report as downloadable artifact.

**Report Structure**:

```markdown
# Claude.md Cross-Reference & File Linking Methods: Comprehensive Analysis

## Executive Summary
[Brief overview of findings, key recommendations]

## Methodology
[How analysis was conducted, sources examined]

## State-of-the-Art Referencing Methods

### Method 1: [Name]
#### Syntax
[Exact syntax with examples]

#### Context-Loading Approach
[How Claude processes these references]

#### Token Efficiency Analysis
[Quantitative token comparison]

#### Optimal Use Cases
[When to use this method]

#### Limitations & Constraints
[Known drawbacks]

#### Best Practices
[Implementation recommendations]

#### Practical Examples
[Before/after demonstrations]

#### Source References
[Citations]

[Repeat for ALL methods identified]

## Comparative Analysis Matrix
[Comprehensive comparison table]

## Decision Framework
[How to choose the right method for different scenarios]

## Implementation Guidelines
[Practical guidance for applying these methods]

## Token Optimization Strategies
[Cross-method optimization techniques]

## Anti-Patterns & Common Mistakes
[What to avoid]

## Production-Ready Templates
[Ready-to-use examples]

## Measurement & Validation
[How to assess effectiveness]

## References
[Complete bibliography]
```

**Report Requirements**:
- Detailed and exhaustive (NOT summary-level)
- Each method gets dedicated section with full analysis
- Include specific syntax examples with actual code/markdown
- Provide quantitative token comparisons where possible
- Include decision trees/flowcharts for method selection
- Do NOT re-explain Claude.md modularization rules (already covered in project docs)
- Focus exclusively on referencing/linking METHODS
- Production-ready: immediately usable by developers

**Output Format**:
- Generate as downloadable Markdown (.md) artifact using `create_file`
- Use proper Markdown formatting (headers, code blocks, tables)
- Include table of contents
- Use clear, scannable structure
- Place file in `/mnt/user-data/outputs/` directory
- Filename: `ClaudeCodeReferencingMethodsBestPractices.md`

**Verification Checkpoint**:
- Confirm report includes ALL identified methods with complete analysis
- Verify all sections are detailed (not superficial)
- Confirm proper Markdown formatting
- Verify file is in outputs directory
- State: "Task 3 verification complete - comprehensive report generated"

---

## Final Summary & Confirmation

After completing all tasks, provide:

1. **Task Completion Checklist**:
   - [ ] Task 1: All project documentation analyzed
   - [ ] Task 2: All referencing methods comprehensively analyzed
   - [ ] Task 3: Complete report generated as downloadable artifact

2. **Methods Summary**: Brief list of ALL methods analyzed

3. **Report Location**: Confirm file path and provide download link

4. **Key Findings**: 2-3 most important insights

5. **Quality Assurance**: Confirm all statements are sourced, no assumptions made

---

## Clarification Questions (Ask Before Starting)

Before beginning, please confirm:
1. Can you access the project knowledge base and uploaded documentation?
2. Are there any specific referencing methods you're already aware of that I should ensure are covered?
3. Should the analysis focus on any particular programming languages, frameworks, or project types?
4. Are there specific token optimization targets (e.g., "achieve 70% reduction") I should use as benchmarks?
5. Do you have access to filesystem for creating the output artifact?

**Critical Reminders**:
- Execute tasks SEQUENTIALLY - complete each before proceeding
- VERIFY each task's output before moving forward
- NO ASSUMPTIONS - all findings must be grounded in reliable sources
- STOP and report if filesystem access issues occur
- Focus on referencing METHODS (not general modularization principles)
- Report must be DETAILED and EXHAUSTIVE, not summary-level
- Analyze ALL major state-of-the-art methods

**Acknowledge** that you understand these requirements and are ready to begin, or ask any clarifying questions now.
