---
name: gemini-reviewer
description: Use Google Gemini for parallel code reviews, complex task validation, and second opinions. Runs Gemini CLI non-interactively to provide alternative perspectives on code quality, implementation decisions, and technical solutions.
---

# Gemini Reviewer

## Overview

This skill leverages Google Gemini to provide parallel reviews and validation for complex tasks, offering alternative perspectives and catching issues that might be missed by a single reviewer.

## When to Use This Skill

Invoke this skill when:

- Performing code reviews (automatically invoked by /code-review command)
- Validating complex implementation decisions
- Getting a second opinion on architectural choices
- Double-checking critical security or performance code
- Reviewing complex algorithms or business logic
- Verifying test coverage and quality

## Review Types

### Code Review

Reviews code changes from PRs, MRs, or commits, focusing on:
- Correctness and logic errors
- Code quality and maintainability
- Security vulnerabilities
- Performance issues
- Test coverage gaps
- Best practices adherence

### Implementation Validation

Validates proposed implementations or design decisions:
- Architectural soundness
- Scalability considerations
- Alternative approaches
- Potential pitfalls
- Best practice alignment

### General Review

Provides second opinion on any technical artifact:
- Documentation clarity
- Configuration correctness
- Script safety
- Data model design

## Workflow

### Step 1: Determine Review Type

Based on the task, identify what needs review:
- **PR/MR number** → Code review
- **Commit hash** → Code review
- **Implementation plan** → Validation review
- **Code snippet** → General review

### Step 2: Prepare Review Context

Gather necessary context:
- For code reviews: Get diff, changed files, PR/MR description
- For validation: Get implementation plan, requirements, constraints
- For general: Get relevant code/docs

### Step 3: Execute Gemini Review

Run Gemini CLI non-interactively with appropriate prompt:

```bash
gemini -y -o text "Review this code change..." < context.txt
```

Use YOLO mode (`-y`) for non-interactive execution.

### Step 4: Parse and Structure Output

Extract key findings:
- Critical issues
- Moderate/minor issues
- Suggestions
- Alternative approaches

### Step 5: Return Results

Provide structured review results to be combined with Claude's review.

## Best Practices

- Run in parallel with Claude code-reviewer for maximum coverage
- Use non-interactive mode (`-y` flag) for automation
- Provide sufficient context in prompts
- Structure output for easy comparison with Claude's results
- Focus Gemini on areas where it excels (security, performance, algorithms)

## Example Prompts

**Code Review:**
```
Review this pull request for code quality, security, and best practices.

PR: #123
Title: Add user authentication

Changed files:
- src/auth.py (120 additions, 10 deletions)
- tests/test_auth.py (50 additions)

Focus on:
1. Security vulnerabilities
2. Error handling
3. Test coverage
4. Performance implications

[diff content]
```

**Implementation Validation:**
```
Evaluate this implementation approach for a caching layer.

Requirements:
- Cache frequently accessed data
- Support TTL and invalidation
- Must be thread-safe

Proposed approach:
[plan details]

Provide feedback on architecture, potential issues, and alternatives.
```

## Integration Notes

- This skill is automatically invoked by the `/code-review` command
- Results are presented alongside Claude's code-reviewer output
- Both reviewers run in parallel for efficiency
- Gemini provides complementary perspective to Claude's analysis
