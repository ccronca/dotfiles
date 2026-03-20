---
name: data-arch-team
description: Create an agent team to analyze data engineering architectural changes from multiple perspectives (performance, architecture/design patterns, data quality). Teammates work in parallel to review changes, then synthesize findings into a design document with recommendations.
---

# Data Architecture Team Skill

**IMPORTANT:** This skill creates an agent team for multi-perspective analysis of data engineering architectural changes. Enable agent teams first by setting `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in your environment or settings.json.

## Purpose

When you need to evaluate data engineering architectural changes (dbt models, data pipelines, schema changes), this skill spawns a team of specialized reviewers who analyze the changes from different angles:

- **Performance & Scalability Analyst**: Query optimization, incremental strategies, data volume handling, resource efficiency
- **Architecture & Design Patterns Reviewer**: Star schema/dimensional modeling, OLTP/OLAP separation, layering patterns, tool/technology fit
- **Data Quality Engineer**: Test coverage, validation frameworks, freshness checks, edge cases
- **Pragmatic Engineering Analyst**: Effort estimation, simplicity vs extensibility trade-offs, avoiding over-engineering while ensuring future-readiness

Each teammate works independently in **read-only plan mode** to ensure safe exploration without accidental modifications.

## When to Use

Use this skill when you need architectural review for:

- Major dbt model refactoring or new model design
- Data pipeline architecture decisions
- Schema changes affecting multiple models
- Performance optimization opportunities
- Data quality framework improvements
- Materialization strategy changes
- Moving from OLTP to OLAP patterns
- Technology/tool selection decisions

**Do NOT use this skill for:**
- Simple bug fixes or single-line changes
- Routine model updates that follow established patterns
- When you need implementation (this skill only provides analysis)

## Execution Protocol

When this skill is invoked, you MUST:

### 1. Enable Agent Teams

Verify that agent teams are enabled:
```bash
# Check if the environment variable is set
echo $CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS
```

If not enabled, inform the user and provide instructions to enable it in settings.json.

### 2. Identify the Review Target

From conversation context, identify what needs architectural review:
- Specific dbt models (file paths or model names)
- Data pipeline components
- Schema change proposals
- Performance issues in existing models
- Data quality concerns
- Technology selection decisions

If the target is unclear, ask the user to specify.

### 3. Gather Context

Collect all relevant context for the review:
- File contents of affected models (use Read tool)
- Related upstream/downstream models (use dbt lineage if available)
- Current test coverage (dbt test files)
- Performance metrics or issues (if mentioned)
- Database schema (if relevant)
- Project requirements or constraints
- Current data warehouse architecture (staging/core/marts layers)
- Existing tools and technologies in use

### 4. Create the Agent Team

Spawn the agent team with three specialized teammates. Use natural language to instruct Claude to create the team:

```text
Create an agent team to analyze [describe the change/model/issue] from multiple
data engineering perspectives. Spawn 4 teammates:

1. Performance & Scalability Analyst (use Sonnet, plan mode required)
   - Focus: Query performance, incremental strategies, data volume handling,
     resource efficiency, partition/index optimization, technology fit for the
     use case, avoiding unnecessary complexity
   - Context: [Provide model files, schema, data volume info]
   - Key questions: Is the technology appropriate for the scale? Are we
     over-engineering this solution?

2. Architecture & Design Patterns Reviewer (use Sonnet, plan mode required)
   - Focus:
     * Standard data warehouse patterns (star schema, snowflake schema, fact/dimension tables)
     * OLTP vs OLAP separation (are we mixing operational and analytical workloads?)
     * Slowly Changing Dimensions (SCD Type 1/2/3) where appropriate
     * Relational database best practices
     * dbt layering (staging/intermediate/core/marts)
     * Materialization choices (table/view/incremental)
     * Tool & technology evaluation:
       - Existing tools vs custom implementation (dbt packages, PySpark, Airflow, etc.)
       - Is tool complexity justified for the feature need?
       - Don't reinvent the wheel if good tools exist
       - Don't use heavyweight tools for simple problems
     * Dependencies and maintainability
     * Naming conventions and documentation
     * Effort required vs benefit (how much code rewrite is needed?)
   - Context: [Provide model files, dbt project structure, existing patterns, current tech stack]
   - Key questions: Does this follow standard dimensional modeling? Are we
     separating OLTP and OLAP properly? Is this the simplest solution that
     works? Should we use an existing tool or build custom? Is the tool
     complexity justified? What's the effort/benefit ratio?

3. Data Quality Engineer (use Sonnet, plan mode required)
   - Focus: Test coverage, validation frameworks, freshness checks,
     edge cases, null handling, data integrity, referential integrity
   - Context: [Provide model files, test files, data quality requirements]
   - Key questions: Are we testing the right things? What edge cases are we missing?
     Should we use existing data quality tools (dbt_expectations, Great Expectations, etc.)
     or build custom tests?

4. Pragmatic Engineering Analyst (use Sonnet, plan mode required)
   - Focus:
     * Effort estimation (lines of code, models affected, migration complexity)
     * Simplicity vs extensibility trade-offs (YAGNI vs future-readiness)
     * Avoiding over-engineering (don't build what you don't need NOW)
     * Avoiding under-engineering (don't paint yourself into a corner)
     * Code rewrite scope and risk assessment
     * Implementation phases (can this be done incrementally?)
     * "Good enough for now" vs "built to last" analysis
     * Technical debt evaluation (acceptable vs problematic debt)
   - Context: [Provide current implementation, proposed changes, known future requirements]
   - Key questions:
     * What's the MINIMUM change that solves the current problem?
     * Will this solution hold up when [anticipated requirement] arrives?
     * Are we solving problems we don't have yet?
     * Can we deliver value incrementally instead of all-at-once?
     * What's the 80/20 approach here (80% value with 20% effort)?
     * Where should we be flexible for future changes vs rigid for simplicity?

All teammates must work in plan mode (read-only) and cannot make code changes.

After all teammates complete their analysis, synthesize their findings into a
design document with the following structure:

## Executive Summary
[High-level overview of all findings, key recommendations, effort estimate]

## Performance & Scalability Analysis
- Query performance considerations
- Incremental strategy evaluation
- Resource efficiency
- Technology fit assessment
- Complexity analysis (are we over-engineering?)

## Architecture & Design Patterns Analysis
- Standard patterns evaluation (star schema, dimensional modeling)
- OLTP vs OLAP separation review
- SCD pattern recommendations where applicable
- Relational database best practices
- dbt layering and materialization choices
- Tool & technology recommendations:
  * Existing tools vs custom implementation
  * Tool complexity vs feature needs trade-off
  * Specific package/library recommendations with rationale
- Effort required vs benefit analysis
- Code rewrite scope and impact

## Data Quality Analysis
- Test coverage gaps
- Validation framework recommendations (existing tools vs custom)
- Edge cases and data integrity concerns
- Freshness and SLA monitoring

## Pragmatic Engineering Analysis
- Effort estimation (realistic scope and timeline)
- Simplicity vs extensibility evaluation
- Over-engineering vs under-engineering assessment
- Incremental implementation opportunities
- 80/20 analysis (maximum value with minimum effort)
- Technical debt trade-offs
- Future-readiness without premature optimization

## Cross-Cutting Concerns
[Issues or recommendations that span multiple areas]

## Recommended Actions (Prioritized)
1. [High-priority, high-impact recommendations]
2. [Medium-priority recommendations]
3. [Nice-to-have improvements]

For each recommendation:
- Rationale: Why this matters
- Effort: Low/Medium/High (how much work required)
- Benefit: Expected improvement
- Risk: What could go wrong if not addressed
- Tool recommendation: Use existing tool X vs build custom (with justification)

## Decision Points
[Areas requiring explicit decisions from the team]

## Effort Estimation
- Lines of code affected
- Number of models requiring changes
- Downstream impact (how many dependent models)
- Testing effort required
- Migration/backfill considerations
- Learning curve for new tools/technologies

Save the design document to docs/architecture/[descriptive-name]-review.md
```

### 5. Monitor Team Progress

As teammates work:
- Check on their progress using Shift+Down (in-process mode) or by viewing panes (split mode)
- Redirect if any teammate is stuck or going off-track
- Answer questions from teammates if they need clarification
- If teammates disagree on approaches, have them discuss with each other to reach consensus

### 6. Ensure Proper Cleanup

After the synthesis document is created:
- Verify all teammates have completed their analysis
- Ask the lead to shut down all teammates gracefully
- Ask the lead to clean up the team resources
- Present the final design document path to the user

## Context Requirements

Provide each teammate with:

**For all teammates:**
- The specific models/files being reviewed (full file contents)
- The goal of the architectural change
- Any known constraints or requirements
- Project context (dbt version, database platform, data volumes)
- Current architecture patterns (if documented)
- Existing tools and technologies in the stack

**Additionally for Performance Analyst:**
- Current performance metrics (if available)
- Data volume estimates
- Query execution plans (if available)
- Incremental strategy requirements
- Database platform specifics (PostgreSQL, Snowflake, BigQuery, etc.)

**Additionally for Architecture & Design Patterns Reviewer:**
- Existing dbt project structure and layers
- Established patterns and conventions (from CLAUDE.md if available)
- Dependency graph (upstream/downstream models)
- Documentation standards
- Current fact/dimension table structure (if applicable)
- OLTP vs OLAP separation strategy
- Existing SCD patterns in use
- Current tech stack (tools, packages, frameworks in use)

**Additionally for Data Quality Engineer:**
- Existing test files
- Data quality requirements or SLAs
- Known data quality issues
- Edge cases to consider
- Data integrity requirements
- Current data quality tools in use

**Additionally for Pragmatic Engineering Analyst:**
- Current implementation (baseline for effort comparison)
- Proposed changes (scope of work)
- Known future requirements (what's on the roadmap)
- Team velocity and capacity
- Existing technical debt
- Migration constraints (downtime windows, data volumes)
- Similar past projects (reference implementations)

## Key Review Principles

The Architecture & Design Patterns Reviewer should specifically evaluate:

### 1. OLTP vs OLAP Separation
- Are we properly separating operational (transactional) from analytical (reporting) workloads?
- Is the model designed for read-heavy analytical queries (OLAP) or write-heavy transactions (OLTP)?
- Are we avoiding operational query patterns in the data warehouse?

### 2. Dimensional Modeling
- **Star Schema**: Is this an appropriate fact or dimension table design?
- **Fact Tables**: Contain measurements, metrics, and foreign keys to dimensions
- **Dimension Tables**: Contain descriptive attributes for analysis
- **Slowly Changing Dimensions**: Are we handling dimension changes appropriately (SCD Type 1/2/3)?

### 3. Relational Database Best Practices
- Proper normalization for dimensions (typically denormalized for query performance)
- Referential integrity (foreign key relationships)
- Appropriate use of surrogate keys vs natural keys
- Grain definition (what does one row represent?)

### 4. Tool & Technology Evaluation
**Don't reinvent the wheel, but don't use a sledgehammer to crack a nut:**

- **Existing tools vs custom implementation**:
  * dbt packages: dbt_utils, dbt_expectations, dbt_artifacts, etc.
  * Data processing: PySpark for large-scale data, pandas for small datasets
  * Orchestration: Airflow, Dagster, Prefect vs custom scheduling
  * Data quality: Great Expectations, dbt_expectations vs custom tests
  * Data validation frameworks vs custom SQL checks

- **Complexity vs need trade-off**:
  * Don't use PySpark for processing small CSV files (use dbt or SQL)
  * Don't build custom orchestration if Airflow already exists
  * Don't use heavy ML frameworks for simple aggregations
  * Don't import massive libraries for single utility functions

- **Evaluation criteria**:
  * Does an existing tool solve 80%+ of the need?
  * Is the tool's complexity justified by our use case?
  * What's the learning curve and maintenance burden?
  * License compatibility and cost
  * Community support and documentation quality
  * Integration with existing stack

- **Examples of good tool choices**:
  * Use dbt_utils.surrogate_key() instead of custom MD5 logic
  * Use dbt_expectations for data quality rules instead of custom SQL
  * Use PySpark when processing TB+ of data, not for MB files
  * Use existing Airflow DAG patterns instead of custom schedulers

### 5. Effort vs Benefit Analysis
- How much code needs to be rewritten?
- What's the migration path from current to proposed design?
- Is the complexity justified by the benefits?
- Can we achieve 80% of the benefit with 20% of the effort?

### 6. Avoid Over-Engineering
- Are we using the simplest technology that fits the need?
- Are we adding unnecessary abstractions or frameworks?
- Is this premature optimization?
- Could a simpler pattern achieve the same goal?

## Best Practices

1. **Size the work appropriately**: Each teammate should have a clear, focused review scope
2. **Provide sufficient context**: Include all files and information needed for independent analysis
3. **Set clear review criteria**: Tell teammates specifically what to look for
4. **Monitor progress**: Check in on teammates and redirect if needed
5. **Synthesize effectively**: The lead should create a cohesive document, not just concatenate reports
6. **Handle disagreements**: If teammates disagree, have them discuss directly to reach consensus
7. **Focus on pragmatism**: Prioritize practical, achievable recommendations over theoretical perfection
8. **Evaluate tools thoughtfully**: Balance "don't reinvent the wheel" with "don't over-complicate"

## Example Usage

**Scenario 1: New dbt mart model review**
```text
/data-arch-team

I need architectural review for a new dbt mart model that aggregates
vulnerability findings across multiple tools. The model joins 5 staging
tables and uses an incremental strategy.

Files to review:
- models/marts/mart_vulnerability_summary.sql
- models/staging/stg_*.sql (5 files)

Questions:
- Is this following proper star schema pattern?
- Should this be a fact table or dimension table?
- Are we separating OLAP workload properly?
- Should we use dbt packages for any of this logic?
```

**Scenario 2: Technology choice for data processing**
```text
/data-arch-team

We need to process daily log files (currently 500MB/day, growing to 5GB/day
next year). Currently using dbt SQL but queries are getting complex.

Should we:
- Stick with dbt SQL
- Move to PySpark
- Use pandas in Python models
- Something else?

Don't want to over-engineer but also want to be ready for growth.
```

**Scenario 3: Schema refactoring to SCD Type 2**
```text
/data-arch-team

Planning to refactor the bridge tables to use SCD Type 2 pattern. Need
architectural review of the proposed changes and effort/benefit analysis.

Files: models/core/bridge_*.sql (3 files)

Key questions:
- Is SCD Type 2 the right pattern here?
- Should we use dbt_utils or build custom?
- How much code rewrite is required?
- What's the migration path?
- Are we over-engineering this?
```

**Scenario 4: Data quality framework selection**
```text
/data-arch-team

We need to add better data quality checks. Currently using basic dbt tests
but need more sophisticated validation.

Options:
- Expand dbt tests with custom SQL
- Use dbt_expectations package
- Bring in Great Expectations
- Build custom validation framework

Which approach makes sense for our scale (50 models, 10M rows/day)?
```

## Troubleshooting

**If agent teams are not enabled:**
- Provide clear instructions to add `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` to settings.json
- Point to the Claude Code documentation on agent teams

**If teammates aren't spawning:**
- Verify the task is complex enough to warrant a team
- Ensure the prompt explicitly requests 3 teammates
- Check that you specified plan mode requirement for each teammate

**If teammates finish too quickly:**
- Provide more context and specific review criteria
- Ask them to go deeper on specific areas
- Give them concrete questions to answer

**If teammates recommend over-engineering:**
- Remind them: "Prioritize simplicity and pragmatism over theoretical perfection"
- Ask: "What's the simplest solution that achieves the goal?"
- Challenge: "Is this complexity justified by actual requirements?"

**If teammates miss obvious tool options:**
- Prompt them: "Have you checked if existing dbt packages/tools solve this?"
- Ask: "What's the trade-off between using tool X vs building custom?"

**If lead starts implementing instead of coordinating:**
- Remind the lead: "Wait for your teammates to complete their analysis before synthesizing"
- Emphasize read-only mode: "Do not make any code changes, only analyze"

## Output Deliverable

The skill produces a design document at `docs/architecture/[name]-review.md` with:

- Executive summary of all findings
- Detailed analysis from each perspective
- Standard design patterns evaluation (star schema, OLTP/OLAP, SCD)
- Tool & technology recommendations with complexity analysis
- Effort vs benefit analysis
- Prioritized recommendations with effort estimates
- Decision points requiring team input
- Complexity assessment (are we over-engineering?)

This document serves as the basis for:
- Architectural decision records (ADRs)
- Implementation planning
- Team discussion and alignment
- Design approval process
- Effort estimation for sprint planning
- Technology selection decisions

## Integration with Existing Agents

This skill complements the existing `dbt-data-engineer` agent:

- **dbt-data-engineer**: Single expert for implementation and guidance
- **data-arch-team**: Multi-perspective review team for architectural decisions

Use `dbt-data-engineer` for implementation work, use `data-arch-team` for architectural review before major changes.

---

**Important Notes:**

- Always work in plan mode (read-only) to prevent accidental changes
- Agent teams consume more tokens than single agents - use for significant architectural decisions
- The skill creates independent reviewers who may disagree - synthesis is crucial
- Prioritize standard patterns (star schema, SCD) over custom solutions
- Evaluate existing tools before building custom solutions
- Balance tool complexity with actual feature needs
- Always evaluate effort required vs benefit gained
- Challenge over-engineering and unnecessary complexity
- Clean up team resources properly to avoid orphaned sessions
