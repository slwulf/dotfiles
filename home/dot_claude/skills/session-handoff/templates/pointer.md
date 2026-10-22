# Pointer file template

**Pointer file template:**

    ---
    name: project_task_<identifier>
    description: <detail that expands the hook line>
    metadata:
      type: project
    ---

    State: <one or two lines>
    Next: <the next step>
    Pins:
    - <open pin>
    Unverified:
    - <claim that couldn't be checked against live state>
    Shaky:
    - <concept that still feels shaky>
    Handoff: ~/.claude/handoffs/<identifier>-handoff.md

`name`, `description`, and body are filled per task; `type: project` is fixed —
it's how the memory system categorizes pointer files. Omit `Unverified:` if
everything was checked, and `Shaky:` if no concept is shaky.

A listed pin is open. Closing a pin removes it from the list; anything worth
keeping about it goes in the handoff (Decisions or Findings).

**Example:**

    ---
    name: project_task_auth-middleware-rewrite
    description: Rewriting auth middleware to meet compliance requirements
    metadata:
      type: project
    ---

    State: API migration — plan done, no code yet, awaiting security review
    of token format.
    Next: Implement per plan — add auth middleware to 3 endpoints, update client SDK.
    Pins:
    - Awaiting security team review of JWT claims
    - Open: defer integration tests until staging env ready, or mock now?
    Unverified:
    - Staging env said to be ready "next week" — not checked this session
    Shaky:
    - Token refresh flow — re-explain at start
    Handoff: ~/.claude/handoffs/auth-middleware-rewrite-handoff.md
