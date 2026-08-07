# Coding Rules & Conventions

Ensure the codebase remains maintainable using these patterns.

---

## 🚦 Clean Code Checklist
- **No Inline Margins:** Utilize spacing tokens (`AppSpacing.s12`, etc.) rather than manual padding values.
- **Model Immutability:** Use `final` attributes for entities and create `copyWith` for state changes.
- **No Unused Imports:** Keep imports lists completely clean.
