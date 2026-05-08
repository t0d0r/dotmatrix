# save-spec

Save a compressed specification of the current conversation to a file.

## Usage

```
/save-spec [filename]
```

## Arguments

- `filename` (optional): Output file path. If not provided, auto-generates from conversation topic.

## Instructions

When this skill is invoked:

1. Use the `conversation-spec-writer` agent via the Task tool to create a compressed specification of the conversation
2. The spec should capture:
   - Context and goals discussed
   - Key decisions made
   - Technical approaches chosen
   - Important code snippets and configurations
   - Any open items or next steps
3. Generate the filename (if not provided):
   - Analyze the main topic/theme of the conversation
   - Create a slug-friendly filename: lowercase, hyphens instead of spaces, no special chars
   - Format: `spec_<topic-slug>_<YYYYMMDD>.md`
   - Examples:
     - Nginx log parsing discussion → `spec_nginx-log-parsing_20260205.md`
     - Auth implementation → `spec_auth-implementation_20260205.md`
     - API refactoring → `spec_api-refactoring_20260205.md`
4. Write the generated spec to the file
5. Confirm the file location to the user

## Example

```
/save-spec                                  # auto-generates: spec_nginx-config_20260205.md
/save-spec ./docs/my_custom_name.md         # uses provided path
```

This will create a spec file documenting the current conversation.
