---
name: "c4-diagramming"
description: "C4 Model PlantUML organization for architecture diagrams"
---

# C4 Model PlantUML Diagramming

## Directory Structure

```
docs/diagrams/
├── 10-Context.plantuml       # C1 System Context
├── 20-Container.plantuml     # C2 Container
├── 30-Component.plantuml     # C3 Component
├── systems/
│   ├── internal-systems.puml
│   ├── external-systems.puml
│   └── *.puml
├── containers/
│   └── *.puml
├── components/
│   └── *.puml
└── persons/
    ├── persons.puml
    └── *.puml
```

## Modular Include Pattern

1. **Individual definition files**: Each system/person/container in its own `.puml` file
2. **Category aggregators**: Group related definitions (`internal-systems.puml`)
3. **Main diagram files**: Top-level views that compose the architecture

## Level-Specific Guidelines

- **C1 Context**: Include ALL systems, use bulk include files
- **C2 Container**: Use selective includes to avoid System vs System_Boundary conflicts
- **C3 Component**: Drill into specific container internals

## Naming Conventions

- **Files**: lowercase with hyphens (`api-gateway.puml`)
- **IDs**: PascalCase (`APIGateway`)
- **Boundaries**: Suffix with purpose (`AIAgentSystem`)

## Common Pitfalls

- System in C1 may need to become System_Boundary in C2 — use selective includes
- Include only systems that have relationships — remove orphaned includes
- Verify rendering after changes at all diagram levels
