# Claude Code Plugins Directory

A collection of Claude Code plugins for development tools, productivity, and MCP integrations.

## Plugins

### sdd-manager

Spec Driven Development document management plugin. Conducts dynamic interviews to generate PRDs, Tech Specs, and Design Specs optimized for AI coding agents.

**Commands:**
- `/analyze` - Analyze specifications
- `/status` - View current spec status
- `/next` - Get next task
- `/complete` - Mark task complete
- `/block` - Mark task blocked
- `/update` - Update spec content
- `/show` - Display spec details
- `/export` - Export specifications

## Installation

Add this plugin directory to your Claude Code configuration:

```bash
claude plugins add sequenzia/claude-plugins
```

Or install individual plugins:

```bash
claude plugins add sequenzia/claude-plugins/sdd-manager
```

## License

MIT
