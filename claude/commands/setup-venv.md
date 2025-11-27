---
description: "Create Python virtual environment, install dependencies, and provide activation command"
allowed-tools: Bash, Read, Glob
---

# Task

Set up a Python virtual environment for the current project and install all dependencies.

**Instructions:**

1. **Detect the project structure:**
   - Look for dependency files in the current directory:
     - `requirements.txt` or `requirements-dev.txt`
     - `pyproject.toml`
     - `setup.py`
     - `Pipfile`
   - If multiple files exist, prioritize in this order: `pyproject.toml`, `requirements.txt`, `setup.py`, `Pipfile`

2. **Create the virtual environment:**
   - Use `python3 -m venv .venv` to create a virtual environment in the `.venv` directory
   - If a virtual environment already exists at `.venv`, ask the user if they want to recreate it

3. **Install dependencies:**
   - Activate the virtual environment temporarily using `source .venv/bin/activate`
   - Install dependencies based on the detected file:
     - For `requirements.txt`: `pip install -r requirements.txt`
     - For `requirements-dev.txt`: Install both `requirements.txt` (if exists) and `requirements-dev.txt`
     - For `pyproject.toml`: `pip install -e .` or `pip install .`
     - For `setup.py`: `pip install -e .`
     - For `Pipfile`: `pipenv install`
   - Upgrade pip first: `pip install --upgrade pip`

4. **Verify installation:**
   - List installed packages using `pip list` or `pip freeze`
   - Report any installation errors

5. **Provide activation instructions:**
   - Display the command to activate the virtual environment:
     ```
     source .venv/bin/activate
     ```
   - Remind the user to deactivate when done using: `deactivate`

**Notes:**
- If no dependency files are found, create an empty virtual environment and inform the user
- Handle errors gracefully and provide clear feedback
- Use the project's Python version if specified in configuration files
- The `.venv` directory is typically included in `.gitignore` to avoid committing virtual environments
