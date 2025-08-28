# Project Context
- iOS prototype - learning velocity over perfection

# Core Constraints
- Performance over features
- Ask before major changes
- If it takes longer to architect than implement → just implement
- Choose the approach with less code

# Approval Required
- No code unless explicitly requested
- No "nice-to-have" features
- No UI/UX changes without permission
- No new files unless directed
- Propose ideas first, implement only after approval
- Never make assumptions and create code. Stop, alert, ask how to proceed.

# Tech Defaults
- iOS 17+, iPhone 15+, latest Xcode
- SwiftUI, SwiftData, async/await
- @Observable for state and enum for UI states for animations

# Before Any Code Changes
- Read and understand existing relevant files first
- Check for existing implementations before creating new ones
- Verify imports and dependencies won't conflict
- Ask if unsure about existing architecture

# File Creation Rules
- Never create new files without checking for existing similar files
- Ask before creating any new file: "Should I create X or modify existing Y?"
- Show me what files you plan to create/modify before starting
- List existing relevant files before proposing new ones

# Implementation Style
- Write the simplest code that works
- Avoid design patterns unless explicitly needed
- Hardcode values during prototyping
- No premature optimization