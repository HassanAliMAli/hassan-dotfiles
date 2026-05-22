# V3 Global Coding Rules

## 1. Read Before Editing

- Understand the request before changing anything.
- Read the task, relevant files, and existing conventions first.
- Check repository-specific instructions before coding.
- Follow local guidance such as `global_rules.md`, `AGENTS.md`, `GEMINI.md`, `CLAUDE.md`, README files, and contribution docs when present.
- Do not start coding until the scope is clear.

## 2. Make Minimal Correct Changes

- Make the smallest correct change.
- Do not touch unrelated files, code, or behavior.
- Prefer targeted fixes over broad rewrites.
- If broader refactoring would help, propose it separately instead of silently expanding scope.
- Always breakdown the prompt you will be given into as many small tasks as possible and create a to-do list with checkboxes and complete those tiny tasks and keep checking the completed tasks.
- Always research the web and official docs and for every tasks find the best way to achieve the to-do list tasks but first explain everything to the user in plain and easy wording that a non technical person can understand and only continue if the user allows.

## 3. Use Current Docs

- Before using a library, framework feature, SDK, or unfamiliar API, read the relevant official docs or authoritative references when available.
- Use Context7 when the task depends on current library or framework documentation, API behavior, or code examples.
- Treat Context7 as a documentation aid, not as absolute truth.
- Verify any critical behavior against source docs or project code when possible.

## 4. Plan Non-Trivial Work

- For non-trivial work, create a short implementation plan before editing.
- Break the task into steps.
- Identify dependencies, risks, and edge cases before making changes.

## 5. Keep Code Clean

- Prefer readability over cleverness.
- Use clear names and straightforward control flow.
- Follow the project’s existing style unless there is a strong reason not to.
- Keep code modular and cohesive.
- Avoid unnecessary abstraction, duplication, and redundant code.
- Keep files reasonably sized; split code when a file becomes difficult to maintain.
- Remove dead, duplicate, or unused code in the area being changed when it is safe to do so.
- Do not leave behind commented-out old code or temporary workaround code after the fix is complete.
- Mark dummy, mock, placeholder, or test-only data clearly.

## 6. Protect Security

- Never hardcode secrets, credentials, API keys, tokens, or private data.
- Use environment variables, config files, or secret managers appropriate to the stack.
- Validate inputs and handle errors explicitly.
- Do not make risky changes without understanding their impact.
- Preserve existing behavior unless the task requires changing it.

## 7. Comment With Purpose

- Write comments only where they improve understanding.
- Comment non-obvious logic, constraints, tradeoffs, and assumptions.
- Do not add comments for obvious code.
- Document important setup details, edge cases, and limitations when relevant.

## 8. Test And Verify

- Test the change with the most relevant available checks.
- Run or update tests when practical.
- Use linting, type checks, and build checks where they exist.
- Check for syntax issues, type issues, unused imports, broken references, and obvious regressions before finishing.
- Review the final diff for unintended changes.

## 9. Use Review Tools

- Use CodeRabbit before commit when available to review uncommitted changes.
- Treat CodeRabbit as a review layer, not a replacement for tests or human judgment.
- Use CodeRabbit feedback to catch code quality issues, edge cases, and security concerns before finalizing.
- If the repo has PR-based review, let CodeRabbit review the PR as well.

## 10. Keep Git Discipline

- If the project is intended to use Git, ensure the repository is initialized.
- Ensure `.gitignore` exists and includes appropriate entries for the stack, tooling, build output, secrets, and local-only files.
- Include agent instruction files in `.gitignore` when they are personal or machine-specific, including `AGENTS.md`, `GEMINI.md`, and `CLAUDE.md`, unless the project explicitly wants them committed.
- Make clean, focused commits after meaningful completed work.
- Do not bundle unrelated changes in the same commit.

## 11. Respect Scope

- Never touch anything the user did not ask to change unless it is directly required for correctness, safety, or completion.
- If a requested change would benefit from broader cleanup, fix only what is needed and note the rest separately.
- Do not introduce extra or redundant code.

## 12. Use Modern Practices

- Use modern, stable, well-supported practices appropriate to the language and project.
- Avoid outdated or deprecated approaches.
- Prefer the most maintainable solution that fits the codebase and team context.

## 13. Final Quality Gate

- Check the whole touched area for dead code, redundant code, error-handling gaps, unused imports, and broken links or references.
- Clean up previously errored code in the area you fixed when it is safe to do so.
- Verify the final result against the project’s standards and security needs before committing.
