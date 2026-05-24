# Update Claude.md Configuration Files

You have just completed a working session on this project. Now update the Claude.md configuration file and any referenced documentation files based on this session's learnings.

## Your Task

Directly update the following files (do not propose changes, make them):
1. `/Claude.md` - Main configuration file
2. Any referenced files mentioned in Claude.md (e.g., `/docs/architecture.md`, `/docs/patterns.md`)

## Update Criteria

### ADD new information when:
- **New patterns emerged** that should be standardized (e.g., we consistently handled errors in a specific way)
- **Project-specific conventions** were established or clarified during this session
- **Domain terminology** was introduced that wasn't previously documented
- **Architectural decisions** were made that affect future work
- **Integration requirements** or external API details were discovered
- **Performance constraints** or requirements became apparent
- **Security requirements** or compliance needs were identified
- **Common pitfalls** were encountered that should be avoided in future

### REMOVE existing information when:
- **Outdated practices** that are no longer relevant to current codebase
- **Contradictory instructions** that conflict with actual project patterns
- **Redundant content** that duplicates Claude's general knowledge
- **Over-specific details** that constrain unnecessarily (e.g., "functions must be exactly 15 lines")
- **Unused sections** that haven't been relevant for multiple sessions
- **Framework-specific details** for frameworks no longer in use
- **Verbose explanations** that can be made more concise without losing clarity

### KEEP existing information when:
- It remains accurate and relevant
- It captures project-specific requirements
- It prevents known issues or mistakes
- It defines critical constraints or standards
- It documents domain-specific knowledge

## Update Process

1. **Review the session**: Analyze what code was written, what decisions were made, what patterns were used
2. **Identify gaps**: What information would have made this session smoother if it were in Claude.md?
3. **Identify obsolescence**: What existing guidance was ignored or contradicted because it's no longer accurate?
4. **Update files**: Make direct edits to improve configuration
5. **Optimize tokens**: Ensure all content is concise and information-dense

## Specific Updates to Consider

- [ ] Are there new architectural patterns to document?
- [ ] Were any naming conventions established or refined?
- [ ] Did we discover project-specific error handling patterns?
- [ ] Are there new integration points or external dependencies?
- [ ] Were performance requirements clarified?
- [ ] Did we establish new testing patterns?
- [ ] Are there security considerations to document?
- [ ] Was domain terminology used that should be defined?
- [ ] Are there common task workflows to document?
- [ ] Can any existing sections be more concise?

## Quality Standards for Updates

- **Concise**: Use minimal tokens while maintaining clarity
- **Specific**: Avoid generic advice Claude already knows
- **Actionable**: Provide concrete guidance, not vague principles
- **Current**: Reflect actual project state, not aspirational goals
- **Organized**: Maintain logical section structure and hierarchy

## Output Format

After updating files, provide a brief summary:
```
Updated: [list of files modified]

Key Changes:
- Added: [brief description of additions]
- Removed: [brief description of removals]
- Refined: [brief description of clarifications]

Token Impact: [estimate of tokens added/removed]
```

Begin the update now. Make direct file edits using the str_replace or create_file tools as needed.
