---
name: container-k8s-validator
description: Validates Containerfile COPY commands and Kubernetes manifest paths for consistency. Automatically runs when working with Containerfiles or K8s manifests to ensure source paths exist and destinations match between files.
---

# Container and Kubernetes Manifest Validator Skill

**IMPORTANT:** This skill executes automatically when working with Containerfiles or Kubernetes manifests.

## Automatic Invocation

This skill is automatically invoked when:
- Creating or modifying Containerfiles/Dockerfiles
- Creating or modifying Kubernetes manifests (*.yaml, *.yml)
- Before committing changes to these files

## Execution Protocol

When this skill is invoked, you MUST:

1. **Find all relevant files** in the current context:
   - Containerfiles/Dockerfiles being modified
   - Kubernetes manifests (Deployments, StatefulSets, ConfigMaps, Secrets)
   - Check common locations: `k8s/`, `manifests/`, `deploy/`, `.kube/`, root directory

2. **Extract and validate Containerfile paths:**
   - Parse all `COPY` and `ADD` commands
   - Extract source paths (left side of COPY/ADD)
   - Extract destination paths (right side of COPY/ADD)
   - Verify source paths exist using `ls` or `test -f`

3. **Extract Kubernetes manifest file references:**
   - Parse `volumeMounts.mountPath` in Deployments/StatefulSets
   - Parse `configMapKeyRef` and `secretKeyRef`
   - Parse ConfigMap/Secret creation from files (e.g., `kubectl create configmap --from-file=`)
   - Note any file paths referenced

4. **Cross-validate consistency:**
   - Check if files referenced in K8s manifests are copied in Containerfile
   - Check if destination paths in Containerfile match mountPath in manifests
   - Report mismatches and missing COPY commands

5. **Generate validation report** with findings

## Validation Steps

### Step 1: Find Containerfiles

```bash
find . -name "Containerfile" -o -name "Dockerfile" -o -name "*.containerfile" -o -name "*.dockerfile"
```

### Step 2: Extract COPY/ADD Commands

For each Containerfile, extract paths:
```bash
grep -E "^(COPY|ADD)" Containerfile
```

Parse format: `COPY <source> <destination>`

### Step 3: Validate Source Paths

For each source path found:
```bash
ls -la <source-path>  # Verify exists
```

### Step 4: Find Kubernetes Manifests

```bash
find . -path "*/k8s/*.yaml" -o -path "*/manifests/*.yaml" -o -path "*/deploy/*.yaml" -o -name "*deployment.yaml" -o -name "*statefulset.yaml"
```

### Step 5: Extract Mount Paths from Manifests

```bash
grep -A 5 "volumeMounts:" manifest.yaml
grep "mountPath:" manifest.yaml
```

### Step 6: Cross-Validate

Compare:
- Containerfile destination paths vs. K8s volumeMounts paths
- K8s manifest file references vs. Containerfile COPY sources
- Report any missing COPY commands for files used in manifests

## Validation Report Format

Present findings in this format:

```
## Container & K8s Validation Report

### Containerfiles Checked
- path/to/Containerfile
- path/to/Dockerfile

### Kubernetes Manifests Checked
- k8s/deployment.yaml
- k8s/configmap.yaml

### ✓ COPY Commands Validated
- ✓ COPY config/app.yaml /etc/config/app.yaml
  - Source exists: config/app.yaml
  - Used in: k8s/deployment.yaml (mountPath: /etc/config/app.yaml)

### ⚠ Issues Found

#### Missing Source Files
- ✗ COPY scripts/startup.sh /usr/local/bin/
  - Source NOT found: scripts/startup.sh
  - Action: Create file or remove COPY command

#### Missing COPY Commands
- ✗ File referenced in K8s but not copied to image
  - Manifest: k8s/deployment.yaml
  - Mount path: /etc/secrets/db-password
  - Action: Add COPY command to Containerfile

#### Path Mismatches
- ✗ Path inconsistency detected
  - Containerfile: COPY config/db.yaml /app/config/db.yaml
  - K8s manifest: mountPath: /etc/config/db.yaml
  - Action: Align paths in both files

### Recommendations
- Fix missing source files before building
- Add missing COPY commands for referenced files
- Ensure path consistency between Containerfile and manifests
- Consider generating files with RUN instead of COPY where appropriate
```

## Example Execution

**Scenario:** User modifies `Containerfile` and `k8s/deployment.yaml`

**Step 1:** Detect files in context
```bash
ls -la Containerfile k8s/deployment.yaml
```

**Step 2:** Parse Containerfile
```dockerfile
FROM python:3.11
COPY config/app.yaml /etc/config/app.yaml
COPY scripts/entrypoint.sh /usr/local/bin/
```

**Step 3:** Validate source paths
```bash
ls config/app.yaml        # ✓ Exists
ls scripts/entrypoint.sh  # ✗ NOT found
```

**Step 4:** Parse K8s manifest
```yaml
volumeMounts:
  - name: app-config
    mountPath: /etc/config/app.yaml
  - name: db-config
    mountPath: /etc/config/database.yaml  # Not in Containerfile!
```

**Step 5:** Generate report showing:
- Missing source: `scripts/entrypoint.sh`
- Missing COPY: `/etc/config/database.yaml` used in manifest
- Valid: `config/app.yaml` → `/etc/config/app.yaml`

## Critical Rules

- **ALWAYS run validation** before committing Containerfile changes
- **ALWAYS check both directions:**
  - Containerfile COPY sources must exist
  - K8s manifest files must be in Containerfile
- **DO NOT skip validation** even for small changes
- **DO provide actionable recommendations** in the report
- **DO suggest alternatives** (RUN vs COPY) when appropriate

## Alternative Suggestions

When finding issues, suggest alternatives:

### Missing File - Suggest Generation
```dockerfile
# Instead of: COPY scripts/startup.sh /usr/local/bin/
# Suggest:
RUN echo '#!/bin/bash\nset -euo pipefail\npython app.py' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh
```

### ConfigMap from File - Suggest Direct Creation
```bash
# Instead of: COPY config/app.yaml (then creating ConfigMap)
# Suggest: Create ConfigMap directly from local file
kubectl create configmap app-config --from-file=config/app.yaml
```

## Integration with CLAUDE.md Guidelines

This skill enforces the Containerfile and Kubernetes manifest validation guidelines in CLAUDE.md:
- Path existence validation
- Path consistency between files
- Completeness checks for COPY commands
- Security checks (avoid copying .env, credentials)

## Troubleshooting

**If Containerfile is not in standard location:**
- Ask user for the path to Containerfile
- Search recursively in common locations

**If K8s manifests use Helm/Kustomize:**
- Note that validation may be limited
- Suggest rendering templates first: `helm template` or `kustomize build`

**If using multi-stage builds:**
- Validate COPY --from=builder paths
- Check that files exist in the builder stage
