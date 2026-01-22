# Changelog Entry Template

Use this template when generating changelog entries in Phase 7.

---

## Template

```markdown
# Changelog: [Feature Name]

**Date:** YYYY-MM-DD
**Feature:** [Brief description of what was built]

## Summary

[2-3 sentence summary of what was accomplished]

## Changes

### Added
- [New capability 1]
- [New capability 2]

### Changed
- [Modification 1]
- [Modification 2]

### Technical Details
- [Implementation detail 1]
- [Implementation detail 2]

## Files Modified

### New Files
| File | Purpose |
|------|---------|
| `path/to/file.ts` | Description |

### Modified Files
| File | Changes |
|------|---------|
| `path/to/file.ts` | What was changed |

## Architecture Decisions

[Reference to ADR if created]
- ADR-NNNN: [Title]

## Testing

- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Notes

[Any additional notes, limitations, or future work]
```

---

## Usage Instructions

1. **Create filename:**
   - Format: `YYYY-MM-DD-feature-slug.md`
   - Use today's date
   - Use kebab-case for the slug
   - Example: `2024-01-15-user-authentication.md`

2. **Save location:**
   - Create `docs/changelog/` directory if it doesn't exist
   - Save the changelog entry to that directory

3. **Fill in the template:**
   - Focus on user-facing changes in Summary
   - List all files touched
   - Reference related ADRs

---

## Example Changelog Entry

```markdown
# Changelog: User Profile Editing

**Date:** 2024-01-15
**Feature:** Allow users to edit their profile information

## Summary

Users can now edit their profile information including name, email, and avatar. Changes are validated in real-time and saved automatically with debouncing.

## Changes

### Added
- Profile edit form with real-time validation
- Avatar upload with image cropping
- Email change with verification flow
- Profile update API endpoint

### Changed
- User model now supports avatar URLs
- Navigation now shows user avatar

### Technical Details
- Used react-image-crop for avatar editing
- Implemented optimistic updates for better UX
- Added debounced auto-save (500ms delay)

## Files Modified

### New Files
| File | Purpose |
|------|---------|
| `src/components/ProfileEditor/ProfileEditor.tsx` | Main profile editing component |
| `src/components/ProfileEditor/AvatarUpload.tsx` | Avatar upload and crop component |
| `src/hooks/useProfileUpdate.ts` | Profile update logic with debouncing |
| `src/api/profile.ts` | Profile API client functions |

### Modified Files
| File | Changes |
|------|---------|
| `src/models/User.ts` | Added avatarUrl field |
| `src/components/Navigation.tsx` | Display user avatar |
| `src/api/index.ts` | Export profile API |
| `prisma/schema.prisma` | Added avatarUrl to User model |

## Architecture Decisions

- ADR-0005: Profile Image Storage with S3

## Testing

- [x] Unit tests added for ProfileEditor
- [x] Unit tests added for useProfileUpdate hook
- [x] Integration tests for profile API
- [x] Manual testing completed

## Notes

- Avatar images are resized to 256x256 on upload
- Old avatars are not automatically deleted (future cleanup task)
- Email changes require verification before taking effect
```

---

## Categories Reference

Use these categories from Keep a Changelog:

- **Added** - New features
- **Changed** - Changes to existing functionality
- **Deprecated** - Features that will be removed
- **Removed** - Features that were removed
- **Fixed** - Bug fixes
- **Security** - Security improvements

For feature changelog entries, typically only Added and Changed are relevant.
