---
description: "Analyze and explain architectural patterns, design patterns, and structural decisions in the codebase"
allowed-tools: Glob, Grep, Read, Task
---

# Architectural Analysis and Pattern Review

You are an **expert software architect** tasked with analyzing the codebase to identify, explain, and document architectural and design patterns.

## Objectives

1. **Identify patterns** across multiple architectural layers
2. **Explain design decisions** and the rationale behind them
3. **Visualize architecture** using Mermaid diagrams
4. **Analyze trade-offs** of chosen approaches
5. **Provide actionable recommendations** for improvements

## Analysis Scope

### 1. Application Architecture

Analyze and document:
- **Overall architecture style** (monolith, microservices, serverless, etc.)
- **Layering patterns** (presentation, business, data access)
- **Module organization** and boundaries
- **Dependency flow** and coupling
- **Separation of concerns**

### 2. Data Engineering Patterns

Identify:
- **Data pipeline architecture** (ETL, ELT, streaming)
- **Data storage patterns** (data warehouse, data lake, lake house)
- **Data modeling approaches** (dimensional, data vault, normalized)
- **Data transformation patterns** (incremental, full refresh, SCD types)
- **Orchestration patterns** (DAGs, event-driven, scheduled)

### 3. Design Patterns

Look for classic and modern patterns:
- **Creational**: Factory, Builder, Singleton, Dependency Injection
- **Structural**: Adapter, Decorator, Facade, Proxy
- **Behavioral**: Strategy, Observer, Command, Template Method
- **Architectural**: MVC, MVVM, Clean Architecture, Hexagonal
- **Domain-Driven Design**: Aggregates, Entities, Value Objects, Repositories

### 4. Backend Patterns

Examine:
- **API design patterns** (REST, GraphQL, RPC)
- **Authentication/Authorization** patterns (OAuth, JWT, RBAC)
- **Caching strategies** (cache-aside, write-through, distributed)
- **Database access patterns** (repository, active record, data mapper)
- **Messaging patterns** (pub/sub, request/reply, event sourcing)

### 5. Security Patterns

Assess:
- **Authentication mechanisms**
- **Authorization strategies** (RBAC, ABAC, policy-based)
- **Data protection** (encryption at rest/transit, secrets management)
- **Input validation** and sanitization
- **Security boundaries** and trust zones
- **Audit logging** patterns

### 6. Data Flow Patterns

Map out:
- **Data ingestion** flows (batch, streaming, real-time)
- **Data transformation** pipelines
- **Data distribution** patterns
- **Error handling** and dead letter queues
- **Data quality** checks and validation

### 7. Integration Patterns

Document:
- **API integration** patterns (REST clients, SDK usage)
- **Message-based integration** (queues, topics, event buses)
- **Database integration** (shared database, change data capture)
- **File-based integration** (FTP, S3, blob storage)
- **Third-party service integration**

## Analysis Workflow

### Step 1: Initial Exploration

Use the Task tool with the Explore agent to understand the codebase structure:

```
Task: Explore the codebase structure and identify:
- Programming languages and frameworks used
- Directory structure and organization
- Key configuration files
- Main entry points
- Testing approach
```

### Step 2: Pattern Identification

Based on the exploration, systematically search for patterns:

- Use Glob to find relevant files (configs, main modules, models, APIs)
- Use Grep to search for pattern indicators (class names, decorators, imports)
- Use Read to examine key files that reveal architectural decisions

### Step 3: Analysis and Documentation

For each identified pattern, document:

1. **Pattern Name and Type**
2. **Location** (files, modules, components)
3. **Purpose** (why this pattern was chosen)
4. **Implementation Details**
5. **Trade-offs**
6. **Alternatives Considered** (if evident)

## Output Format

Provide a structured analysis report with the following sections:

### Executive Summary

Brief overview (2-3 paragraphs) of:
- Overall architectural approach
- Key patterns identified
- Main strengths and areas for improvement

### Architecture Overview

#### High-Level Architecture Diagram

```mermaid
graph TB
    subgraph "Presentation Layer"
        UI[User Interface]
        API[API Gateway]
    end

    subgraph "Business Layer"
        SVC[Services]
        LOGIC[Business Logic]
    end

    subgraph "Data Layer"
        DB[(Database)]
        CACHE[(Cache)]
    end

    UI --> API
    API --> SVC
    SVC --> LOGIC
    LOGIC --> DB
    LOGIC --> CACHE
```

**Note**: Adapt the diagram to reflect the actual architecture found.

### Detailed Pattern Analysis

For each major pattern category, provide:

#### [Pattern Category Name]

**Patterns Identified:**

1. **[Pattern Name]**
   - **Type**: [Creational/Structural/Behavioral/etc.]
   - **Location**: `path/to/file.py:123`
   - **Purpose**: Why this pattern is used
   - **Implementation**:
     ```python
     # Key code snippet demonstrating the pattern
     ```
   - **Trade-offs**:
     - ✅ **Advantages**: Benefits of this approach
     - ⚠️ **Disadvantages**: Potential drawbacks
   - **Alternatives**: Other patterns that could be used

**Visual Representation** (if applicable):

```mermaid
classDiagram
    class Factory {
        +create_product()
    }
    class Product {
        +operation()
    }
    Factory --> Product
```

### Data Flow Diagrams

Document key data flows:

```mermaid
flowchart LR
    Source[Data Source] --> Ingest[Ingestion Layer]
    Ingest --> Transform[Transformation]
    Transform --> Validate[Validation]
    Validate --> Store[(Data Warehouse)]
    Store --> Consume[Consumption Layer]
```

### Integration Architecture

Show how the system integrates with external systems:

```mermaid
graph LR
    App[Application]
    App -->|REST API| ExtAPI[External API]
    App -->|Messages| Queue[Message Queue]
    App -->|SQL| DB[(Database)]
    App -->|Files| S3[Object Storage]
```

### Security Architecture

Document security patterns and boundaries:

```mermaid
graph TB
    subgraph "Public Zone"
        LB[Load Balancer]
    end

    subgraph "DMZ"
        API[API Gateway]
        Auth[Auth Service]
    end

    subgraph "Private Zone"
        App[Application]
        DB[(Database)]
    end

    LB --> API
    API --> Auth
    Auth --> App
    App --> DB
```

### Trade-off Analysis

For major architectural decisions:

| Decision | Advantages | Disadvantages | Alternatives |
|----------|------------|---------------|--------------|
| Monolithic architecture | Simple deployment, easier debugging | Scalability challenges, tight coupling | Microservices, modular monolith |
| REST API | Simple, well-understood, cacheable | Over-fetching, multiple round-trips | GraphQL, gRPC |
| Relational DB | ACID guarantees, strong consistency | Scalability limits, rigid schema | NoSQL, NewSQL |

### Recommendations

Provide prioritized recommendations:

#### High Priority

1. **[Recommendation Title]**
   - **Issue**: What needs improvement
   - **Impact**: Why this matters (performance, maintainability, security)
   - **Approach**: How to implement the change
   - **Effort**: Estimated complexity (Low/Medium/High)

#### Medium Priority

2. **[Recommendation Title]**
   - ...

#### Low Priority (Future Considerations)

3. **[Recommendation Title]**
   - ...

### Best Practices Observed

Highlight positive patterns and practices:

- ✅ Consistent use of dependency injection
- ✅ Proper error handling and logging
- ✅ Separation of concerns between layers
- ✅ Comprehensive test coverage

### Anti-Patterns Detected

Call out problematic patterns:

- ❌ **God Object** in `service.py:45` - Too many responsibilities
- ❌ **Circular Dependencies** between modules A and B
- ❌ **Hard-coded Configuration** in `config.py:12`

## Important Notes

- **Be thorough but concise**: Focus on significant patterns, not every detail
- **Provide context**: Explain why patterns matter for this specific codebase
- **Use visual aids**: Diagrams make complex relationships easier to understand
- **Be specific**: Reference actual file paths and line numbers
- **Stay objective**: Present trade-offs fairly, not just criticisms
- **Prioritize recommendations**: Not everything needs to be fixed immediately

## Example Analysis Flow

1. Use Explore agent to understand the project
2. Identify the primary language and framework
3. Look for configuration files (requirements.txt, package.json, etc.)
4. Examine main entry points
5. Analyze module structure and imports
6. Review API definitions
7. Check database models and schemas
8. Examine authentication/authorization code
9. Review error handling patterns
10. Synthesize findings into structured report

## Rendering Diagrams

All Mermaid diagrams will be automatically rendered by Claude Code. Ensure:
- Syntax is valid
- Node names are descriptive
- Relationships are clearly labeled
- Subgraphs are used for logical grouping
- Colors/styles are used sparingly for emphasis

Begin the analysis now by exploring the codebase structure.
