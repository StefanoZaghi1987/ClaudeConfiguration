# Prompt for Claude: Claude.md Modularization Best Practices Analysis

I need you to analyze project documentation and identify state-of-the-art best practices for modularizing Claude.md configuration files. This is a sequential, multi-task project that requires careful verification at each step.

## Critical Instructions

**EXECUTION ORDER IS MANDATORY**: Complete tasks sequentially. Do not skip ahead or work in parallel.

**VERIFICATION REQUIRED**: After completing each task, verify your output meets all requirements before proceeding to the next task.

**NO ASSUMPTIONS**: All findings must be grounded in reliable sources from the uploaded documentation or verified external sources.

**FILESYSTEM ACCESS**: If you encounter any filesystem access issues:
- STOP immediately
- Report the exact error message
- Try alternative approaches using available tools
- Do NOT proceed with assumptions
- Ask for help if needed

## Task Sequence

### Task 1: Project Documentation Analysis & Understanding

**Objective**: Read and fully comprehend all uploaded project documentation.

**Requirements**:
1. Use available filesystem tools to locate and read all uploaded documents
2. Create a comprehensive inventory of all documents found
3. Summarize the key information from each document
4. Identify core themes, principles, and guidelines present across all documents

**Verification Criteria**:
- [ ] All uploaded documents have been read
- [ ] Document inventory is complete with filenames and descriptions
- [ ] Key concepts and principles are extracted and summarized
- [ ] You can articulate the project's mission, scope, and objectives

**Output**: A summary confirming you have read and understood all documentation, including:
- List of all documents read
- Key takeaways from each document
- Understanding of the project's core mission and principles

**CHECKPOINT**: Before proceeding to Task 2, explicitly confirm:
"I have completed Task 1. I have read and understood [X] documents: [list document names]. I am ready to proceed to Task 2."

---

### Task 2: Claude.md Modularization Best Practices Analysis

**Objective**: Identify and document all state-of-the-art best practices and guidelines for modularizing Claude.md configuration files into smaller, manageable files while maintaining accessibility and optimizing for code quality, solution architecture, and token efficiency.

**Analysis Requirements**:

1. **Modularization Strategies**
   - Identify different approaches to splitting Claude.md into multiple files
   - Document file organization patterns and structures
   - Explain when to use each modularization approach
   - Provide decision frameworks for choosing modularization strategies

2. **Information Architecture**
   - How to organize content across multiple files
   - Cross-referencing techniques between files
   - Dependency management between configuration files
   - Loading order and priority mechanisms

3. **Token Optimization**
   - Strategies to minimize token usage across modular files
   - Techniques for avoiding redundancy between files
   - Efficient cross-referencing methods
   - Lazy loading or conditional loading patterns

4. **Accessibility & Maintainability**
   - Ensuring all information remains accessible when needed
   - Navigation patterns for modular configurations
   - Documentation strategies for modular structures
   - Version control best practices for multiple files

5. **Code Quality & Architecture**
   - How modularization impacts code quality outcomes
   - Architectural patterns that benefit from modularization
   - Separation of concerns in configuration files
   - Testing and validation of modular configurations

6. **Practical Implementation**
   - File naming conventions
   - Directory structure recommendations
   - Integration with existing Claude Code workflows
   - Migration strategies from monolithic to modular configurations

7. **Common Pitfalls & Anti-Patterns**
   - Over-modularization risks
   - Circular dependencies
   - Inconsistencies across files
   - Maintenance burden considerations

8. **Examples & Templates**
   - Provide concrete examples of modular structures
   - Template structures for different project types
   - Before/after comparisons
   - Real-world case studies (if available in documentation)

**Source Requirements**:
- Ground all findings in the uploaded project documentation
- Reference specific sections or principles from the documentation
- If using external sources, clearly identify and cite them
- Distinguish between documented practices and inferred best practices

**Verification Criteria**:
- [ ] All analysis sections are comprehensive and detailed
- [ ] Each recommendation is grounded in reliable sources
- [ ] Practical examples are provided throughout
- [ ] Token optimization strategies are specific and actionable
- [ ] Both benefits and trade-offs are documented
- [ ] Decision frameworks help readers choose appropriate approaches
- [ ] The report is structured with clear sections and subsections

**Output Format**: 
Create a detailed Markdown (.md) document with the following structure:

```markdown
# Claude.md Modularization: Best Practices & Guidelines

## Executive Summary
[High-level overview of key findings and recommendations]

## 1. Introduction
### 1.1 Purpose
### 1.2 Scope
### 1.3 Key Principles from Project Documentation

## 2. Modularization Strategies
### 2.1 [Strategy 1]
### 2.2 [Strategy 2]
### 2.3 Decision Framework

## 3. Information Architecture
### 3.1 File Organization Patterns
### 3.2 Cross-Referencing Techniques
### 3.3 Dependency Management
### 3.4 Loading Order & Priority

## 4. Token Optimization
### 4.1 Redundancy Elimination
### 4.2 Efficient Cross-Referencing
### 4.3 Conditional Loading Patterns
### 4.4 Measurement & Validation

## 5. Accessibility & Maintainability
### 5.1 Ensuring Information Accessibility
### 5.2 Navigation Patterns
### 5.3 Documentation Strategies
### 5.4 Version Control Best Practices

## 6. Code Quality & Architecture Impact
### 6.1 Quality Outcomes
### 6.2 Architectural Patterns
### 6.3 Separation of Concerns
### 6.4 Testing & Validation

## 7. Practical Implementation Guide
### 7.1 File Naming Conventions
### 7.2 Directory Structures
### 7.3 Integration with Workflows
### 7.4 Migration Strategies

## 8. Common Pitfalls & Anti-Patterns
### 8.1 Over-Modularization
### 8.2 Circular Dependencies
### 8.3 Inconsistencies
### 8.4 Maintenance Burden

## 9. Examples & Templates
### 9.1 Minimal Modular Structure
### 9.2 Standard Modular Structure
### 9.3 Comprehensive Modular Structure
### 9.4 Before/After Comparisons

## 10. References & Sources
[All sources cited throughout the document]

## Appendices
### Appendix A: Quick Reference Guide
### Appendix B: Decision Trees
### Appendix C: Checklists
```

**CHECKPOINT**: Before finalizing the report, verify:
- [ ] All sections are detailed and exhaustive
- [ ] Every recommendation is sourced or clearly marked as inference
- [ ] Examples are concrete and actionable
- [ ] The document is well-structured and navigable
- [ ] Token optimization is addressed throughout
- [ ] Both benefits and trade-offs are documented

**Final Output**: Generate the complete report as a downloadable Markdown (.md) artifact.

---

## Final Task: Completion Summary

After completing both tasks, provide a final summary that includes:

1. **Task 1 Completion Confirmation**
   - Number of documents read
   - Key concepts understood
   - Any limitations or gaps in documentation

2. **Task 2 Completion Confirmation**
   - Confirmation that all analysis sections are complete
   - Total word count and section count of the report
   - Key findings summary
   - Any assumptions made (if any)

3. **Verification Status**
   - Confirmation that all verification criteria were met
   - Any issues encountered and how they were resolved

4. **Deliverable Confirmation**
   - Confirmation that the Markdown artifact is ready for download
   - Brief description of the artifact contents

---

## Clarification Questions

Before beginning, please answer:

1. Can you confirm you have access to filesystem tools to read the uploaded documents?
2. Are there any uploaded documents that you cannot access?
3. Do you understand the requirement to ground all analysis in reliable sources?
4. Are there any aspects of the modularization analysis that are unclear?
5. Do you have any questions about the required output format?

**Please acknowledge your understanding of these instructions and confirm you are ready to begin with Task 1.**
