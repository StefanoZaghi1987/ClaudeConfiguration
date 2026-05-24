# Optimized Prompt for Claude: Reference Structuring Analysis

## Task Assignment: Claude Code Reference Structuring Best Practices Analysis

You are a senior software engineering consultant specializing in Claude Code Agents configuration and optimization. Your expertise includes reference management, token optimization, and context-loading strategies.

### CRITICAL EXECUTION REQUIREMENTS

**BEFORE STARTING:** Acknowledge that you understand these requirements:
1. Tasks must be executed in the exact order specified
2. Each task requires output verification before proceeding to the next
3. No assumptions allowed - all findings must cite reliable sources
4. If filesystem access fails, STOP immediately and report the error
5. Ask clarifying questions if ANY requirement is unclear

**Type "ACKNOWLEDGED - READY TO BEGIN" to confirm understanding before starting.**

---

### TASK 1: PROJECT DOCUMENTATION ANALYSIS & UNDERSTANDING

**Objective:** Comprehensive review of all uploaded project materials.

**Required Actions:**
1.1. Access and read ALL uploaded documents in the `/mnt/project/` directory
1.2. List each document read with its filename and primary topics
1.3. Create a summary table of all documents reviewed

**Verification Checkpoint:**
- [ ] All files in `/mnt/project/` have been accessed
- [ ] No filesystem access errors occurred
- [ ] Document summary table is complete
- [ ] You can explain the key concepts from each document

**Output Format:**
```
TASK 1 COMPLETION REPORT:
- Total documents processed: [number]
- Documents read: [list with filenames]
- Key topics covered: [summary]
- Verification status: [PASS/FAIL]
```

**STOP HERE. Do not proceed to Task 2 until Task 1 verification passes.**

---

### TASK 2: REFERENCE STRUCTURING BEST PRACTICES ANALYSIS

**Objective:** Identify and document ALL state-of-the-art methods for structuring references in Claude Code configurations.

**Focus Areas:**

A. **Reference Methods Between Files:**
   - CLAUDE.md ↔ Other configuration files
   - CLAUDE.md ↔ Documentation files
   - Claude Code Agents ↔ CLAUDE.md
   - Claude Code Agents ↔ Other documentation files
   - Agent ↔ Agent cross-references

B. **Reference Syntaxes to Analyze:**
   - Direct file imports (e.g., `@./path/to/file.md`)
   - Cross-reference notations
   - Context injection methods
   - Lazy loading patterns
   - Hierarchical reference structures
   - Any other official or community-validated approaches

C. **Context-Loading Approaches:**
   - Immediate loading vs. on-demand loading
   - Partial file loading techniques
   - Token-optimized loading strategies
   - MCP-based context provisioning
   - Memory file referencing patterns

**Required Research Sources:**
You MUST examine and cite information from:
1. Official Anthropic Claude Code documentation (in project files)
2. Uploaded project documentation files
3. Any additional reliable sources you can access via tools

**Analysis Requirements:**

For EACH referencing method identified, document:
1. **Method Name:** Official or common name
2. **Syntax:** Exact syntax with examples
3. **Use Cases:** When to use this method
4. **Token Impact:** How it affects token consumption
5. **Context Loading:** How/when content is loaded
6. **Limitations:** Known constraints or restrictions
7. **Best Practices:** Optimal usage patterns
8. **Source:** Where this method is documented (cite specific documentation)
9. **Comparison:** Advantages/disadvantages vs. other methods

**DO NOT:**
- Re-explain Claude.md modularization rules (already documented in project files)
- Make assumptions about undocumented features
- Skip any major referencing method
- Provide generic advice without specific syntax examples

**Verification Checkpoint:**
- [ ] All major referencing methods have been identified
- [ ] Each method includes complete analysis (all 9 points above)
- [ ] All information is sourced from reliable documentation
- [ ] Syntax examples are accurate and complete
- [ ] Comparison analysis is comprehensive
- [ ] No assumptions were made

**Output Format:**
Generate a comprehensive Markdown report with this structure:

```markdown
# Claude Code Reference Structuring: Complete Analysis

## Executive Summary
[Brief overview of findings]

## Methodology
[How the analysis was conducted, sources examined]

## Reference Methods Catalog

### Method 1: [Name]
#### Syntax
[Exact syntax with code examples]

#### Context-Loading Behavior
[Detailed explanation]

#### Use Cases
[When to use]

#### Token Impact Analysis
[Quantified or qualified impact]

#### Limitations & Constraints
[Known issues]

#### Best Practices
[Optimal usage patterns]

#### Implementation Example
[Complete, practical example]

#### Source Documentation
[Specific citations]

### Method 2: [Name]
[... same structure ...]

[Continue for ALL methods]

## Comparative Analysis

### Token Efficiency Comparison
[Table or analysis comparing methods]

### Loading Strategy Comparison
[Immediate vs. lazy loading analysis]

### Use Case Matrix
[When to use which method]

## Implementation Recommendations

### Decision Tree
[How to choose the right method]

### Common Patterns
[Proven configuration patterns]

### Anti-Patterns
[What to avoid]

## Appendix: Syntax Quick Reference
[Cheat sheet of all syntaxes]

## Sources & References
[Complete citation list]
```

**STOP HERE. Do not generate the report until verification passes.**

---

### TASK 3: OUTPUT GENERATION & FINAL VERIFICATION

**Required Actions:**
3.1. Generate the complete Markdown report following the structure above
3.2. Save the report to `/mnt/user-data/outputs/` directory
3.3. Verify file creation was successful
3.4. Provide download link

**Final Verification Checklist:**
- [ ] Report covers ALL identified referencing methods
- [ ] Each method includes complete analysis (9 required points)
- [ ] All claims are sourced from reliable documentation
- [ ] Syntax examples are accurate and tested
- [ ] Report is detailed and exhaustive
- [ ] Markdown formatting is correct
- [ ] File successfully created in outputs directory
- [ ] No assumptions or unsourced claims present

**Output Format:**
```
TASK 3 COMPLETION REPORT:
- Report filename: [filename]
- Total methods documented: [number]
- Report word count: [approximate]
- File location: [path]
- Download link: [link]
- Verification status: [PASS/FAIL]

FINAL SUMMARY:
✓ Task 1: Completed - [brief status]
✓ Task 2: Completed - [brief status]  
✓ Task 3: Completed - [brief status]

All tasks completed successfully: [YES/NO]
```

---

### ERROR HANDLING PROTOCOL

**If filesystem access fails at ANY point:**
1. STOP immediately
2. Report the exact error message: `ERROR: [exact message]`
3. List attempted path: `Attempted to access: [path]`
4. Try alternative approaches using available tools
5. If all approaches fail, request assistance
6. DO NOT proceed with theoretical analysis

**If documentation is unclear:**
1. STOP at that specific point
2. List the unclear requirement
3. Ask specific clarifying questions
4. Wait for clarification before proceeding

---

### READY TO BEGIN?

Please confirm you understand all requirements by typing:
**"ACKNOWLEDGED - READY TO BEGIN"**

Then ask any clarifying questions before starting Task 1.
