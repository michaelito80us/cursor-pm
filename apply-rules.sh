#!/bin/bash
set -e  # Exit on error

# Parse arguments
DRY_RUN=false
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
    shift
fi

# Validate requirements
if [ $# -eq 0 ]; then
    echo "❌ Error: Please provide the target project directory"
    echo "Usage: ./apply-rules.sh [--dry-run] <target-project-directory>"
    exit 1
fi

# Function to simulate or execute a command
execute_or_print() {
    if [ "$DRY_RUN" = true ]; then
        echo "🔍 Would execute: $*"
    else
        "$@"
    fi
}

TARGET_DIR="$1"

# Function to add specific entries to ignore files
add_ignore_entries() {
    local target="$TARGET_DIR/$1"
    shift
    local entries=("$@")
    
    if [ "$DRY_RUN" = true ]; then
        echo "🔍 Would modify: $target"
        if [ ! -f "$target" ]; then
            echo "   Would create new file with entries:"
            printf "   %s\n" "${entries[@]}"
        else
            echo "   Would add missing entries:"
            for entry in "${entries[@]}"; do
                if ! grep -qF "$entry" "$target" 2>/dev/null; then
                    echo "   + $entry"
                fi
            done
        fi
        return
    fi
    
    # If target doesn't exist, create it with the entries
    if [ ! -f "$target" ]; then
        echo "📄 Creating new file: $target"
        printf "%s\n" "${entries[@]}" > "$target"
        return
    fi
    
    # Add missing entries
    echo "📝 Updating existing file: $target"
    for entry in "${entries[@]}"; do
        if ! grep -qF "$entry" "$target" 2>/dev/null; then
            echo "   + Adding: $entry"
            echo "$entry" >> "$target"
        fi
    done
}

# Create target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    echo "📁 ${DRY_RUN:+"Would create"} ${DRY_RUN:="Creating"} new project directory: $TARGET_DIR"
    execute_or_print mkdir -p "$TARGET_DIR"

    # Initialize readme for new project
    cat > "$TARGET_DIR/README.md" << 'EOL'
# New Project

This project has been initialized with agile workflow support and auto rule generation configured from [cursor-auto-rules-agile-workflow](https://github.com/bmadcode/cursor-auto-rules-agile-workflow).

For workflow documentation, see [Workflow Rules](docs/workflow-rules.md).
EOL
fi

# Create .cursor/rules directory if it doesn't exist
mkdir -p "$TARGET_DIR/.cursor/rules"

# Create .cursor/templates directory if it doesn't exist
mkdir -p "$TARGET_DIR/.cursor/templates"

# Copy core rule files
echo "📦 Copying core rule files..."
cp -n .cursor/rules/*.mdc "$TARGET_DIR/.cursor/rules/"

# Copy template files
echo "📦 Copying template files..."
cp -r .cursor/templates/* "$TARGET_DIR/.cursor/templates/"

# Create docs directory if it doesn't exist
mkdir -p "$TARGET_DIR/docs"

# Create workflow documentation
cat > "$TARGET_DIR/docs/workflow-rules.md" << 'EOL'
# Cursor Workflow Rules

This project has been updated to use the auto rule generator from [cursor-auto-rules-agile-workflow](https://github.com/bmadcode/cursor-auto-rules-agile-workflow).

> **Note**: This script can be safely re-run at any time to update the template rules to their latest versions. It will not impact or overwrite any custom rules you've created.

## Core Features

- Automated rule generation
- Standardized documentation formats
- AI behavior control and optimization
- Flexible workflow integration options

## Workflow Integration Options

### 1. Automatic Rule Application (Recommended)
The core workflow rule is automatically installed in `.cursor/rules/`:
- `000-cursor-rules.mdc` - Core cursor rules
- `100-git-workflow.mdc` - Git workflow rules
- `801-workflow-agile.mdc` - Complete Agile workflow

The templates for generating the PRD, Architecture, and User Stories are in `.cursor/templates/`:
- `template-prd.md` - PRD template
- `template-arch.md` - Architecture template
- `template-story.md` - User Story template

These rules are automatically applied when working with corresponding file types.

### 2. Notepad-Based Workflow
For a more flexible approach, use the templates in `xnotes/notepads/`:
1. Enable Notepads in Cursor options
2. Create a new notepad (e.g., "agile")
3. Copy contents from `xnotes/workflow-agile.md`
4. Use \`@notepad-name\` in conversations
5. Do the same for the other templates in `xnotes/notepads/`

> 💡 **Tip:** The Notepad approach is ideal for:
> - Initial project setup
> - Story implementation
> - Focused development sessions
> - Reducing context overhead

## Getting Started

1. Review the templates in \`xnotes/\`
2. Choose your preferred workflow approach
3. Start using the AI with confidence!

EOL

# Create xnotes directory and copy templates
echo "📝 Setting up Notepad templates..."
mkdir -p "$TARGET_DIR/xnotes"
cp -r xnotes/* "$TARGET_DIR/xnotes/"

# Update .cursorignore with specific entries
echo "📄 Updating .cursorignore..."
cursorignore_entries=(
    "/node_modules"
    "/build"
    "/temp"
    ".DS_Store"
    ".gitignore"
    "/xnotes"
)
add_ignore_entries ".cursorignore" "${cursorignore_entries[@]}"

# Update .cursorindexingignore with specific entries
echo "📄 Updating .cursorindexingignore..."
cursorindexingignore_entries=(
    "/xnotes"
    ".cursor/templates/*.md"
)
add_ignore_entries ".cursorindexingignore" "${cursorindexingignore_entries[@]}"

# Update .gitignore with all entries
echo "📄 Updating .gitignore..."
gitignore_entries=(
    "# Private individual user cursor rules"
    ".cursor/rules/_*.mdc"
    "# Project specific ignores"
    "/xnotes"
    ".DS_Store"
)
add_ignore_entries ".gitignore" "${gitignore_entries[@]}"

echo "✨ Deployment Complete!"
echo "📁 Core rules: $TARGET_DIR/.cursor/rules/"
echo "📁 Templates: $TARGET_DIR/.cursor/templates/"
echo "📝 Notepad templates: $TARGET_DIR/xnotes/notepads/"
echo "📄 Documentation: $TARGET_DIR/docs/workflow-rules.md"
echo "🔒 Updated .gitignore and .cursorignore"
echo ""
echo "Next steps:"
echo "1. Review the documentation in docs/workflow-rules.md"
echo "2. Choose your preferred workflow approach"
echo "3. Enable Cursor Notepads if using the flexible workflow option"
echo "4. To start a new project, use xnotes/project-idea-prompt.md as a template"
echo "   to craft your initial message to the AI agent"
