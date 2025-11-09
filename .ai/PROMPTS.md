# Prompt Templates

This file contains templates for common prompts to use with AI assistants. Copy and fill in the brackets with your specific needs.

---

## 🎯 Starting a New Phase

```
I'm ready to start [Phase X: Phase Name] of the interval timer app.

Current status:
- [What's completed so far]
- [What I'm blocked on, if anything]

For this phase, I want to:
1. [First task]
2. [Second task]
3. [Third task]

Please:
- Follow the architecture in PROJECT_CONTEXT.md
- Use [state management solution] for state
- Keep code beginner-friendly with comments
- Create tests for business logic

Let's start with [specific first step].
```

**Example**:
```
I'm ready to start Phase 1: Core Timer Functionality.

Current status:
- Fresh Flutter project initialized
- No custom code written yet

For this phase, I want to:
1. Set up Riverpod for state management
2. Create domain models (TimerState, IntervalConfig)
3. Implement timer controller with start/pause/reset

Please:
- Follow the architecture in PROJECT_CONTEXT.md
- Use Riverpod for state
- Keep code beginner-friendly with comments
- Create tests for business logic

Let's start with setting up the folder structure and adding Riverpod to pubspec.yaml.
```

---

## 🐛 Debugging Issues

```
I'm having an issue with [feature/component].

**Problem**: [Describe what's not working]

**Expected behavior**: [What should happen]

**What I've tried**:
- [Attempt 1]
- [Attempt 2]

**Relevant files**:
- [File path 1]
- [File path 2]

**Error message** (if any):
```
[paste error here]
```

Please help me debug this.
```

---

## ➕ Adding a New Feature

```
I want to add a new feature: [Feature Name]

**Description**: [What the feature does]

**User flow**:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Technical requirements**:
- [Requirement 1]
- [Requirement 2]

**Questions**:
- [Any specific questions about implementation]

Please create:
1. The necessary model/entity classes
2. Controller/provider for state management
3. UI widgets/screens
4. Basic tests

Follow the architecture pattern in PROJECT_CONTEXT.md.
```

**Example**:
```
I want to add a new feature: Preset Workouts

**Description**: Users can save their favorite interval configurations and quickly load them instead of setting up manually each time.

**User flow**:
1. User configures work/rest/rounds on setup screen
2. User taps "Save as Preset" button
3. User enters a name (e.g., "Tabata", "My Workout")
4. Preset is saved and appears in presets list
5. User can tap any preset to load its configuration

**Technical requirements**:
- Persist presets locally (using shared_preferences)
- CRUD operations (Create, Read, Update, Delete)
- Include 3 default presets (Tabata, HIIT, Simple)

**Questions**:
- Should presets be editable after creation?
- Maximum number of presets to allow?

Please create:
1. Preset model class
2. Preset repository for storage
3. Preset list screen with load/delete options
4. "Save Preset" dialog
5. Basic tests for CRUD operations

Follow the architecture pattern in PROJECT_CONTEXT.md.
```

---

## 🔧 Refactoring Code

```
I need to refactor [component/file] because [reason].

**Current issue**:
- [Problem 1]
- [Problem 2]

**Goal after refactoring**:
- [Improvement 1]
- [Improvement 2]

**Files involved**:
- [File path 1]
- [File path 2]

Please refactor this while:
- Keeping existing functionality working
- Maintaining the same architecture pattern
- Improving [specific aspect]
- Adding/updating tests as needed
```

---

## 🎨 Improving UI/UX

```
I want to improve the [screen/widget] to make it [more X].

**Current state**: [Describe current UI]

**Desired improvements**:
1. [Change 1]
2. [Change 2]
3. [Change 3]

**Design inspiration**: [Any specific apps or styles you like]

**Technical considerations**:
- [Any performance concerns]
- [Any accessibility needs]

Please update the UI with:
- Clean, minimal design
- Smooth animations
- Proper spacing and alignment
- Comments explaining design decisions
```

**Example**:
```
I want to improve the timer screen to make it more visually engaging and easier to read during workouts.

**Current state**: Basic countdown display with text

**Desired improvements**:
1. Large, bold numbers for the countdown (easy to see from distance)
2. Circular progress indicator showing interval progress
3. Color-coded intervals (green for work, blue for rest, yellow for prep)
4. Animated transition between intervals
5. Current interval label (WORK/REST) prominent at top

**Design inspiration**: Nike Training Club, Tabata Timer apps

**Technical considerations**:
- Need to be readable in bright sunlight
- Should work on small screens (iPhone SE)
- Animations shouldn't drain battery

Please update the UI with:
- Clean, minimal design
- Smooth animations
- Proper spacing and alignment
- Comments explaining design decisions
```

---

## 🧪 Adding Tests

```
I need tests for [component/feature].

**What to test**:
- [Scenario 1]
- [Scenario 2]
- [Edge case 1]
- [Edge case 2]

**Type of tests needed**:
- [ ] Unit tests
- [ ] Widget tests
- [ ] Integration tests

**Files to test**:
- [File path 1]
- [File path 2]

Please create comprehensive tests that cover:
- Happy path (normal usage)
- Edge cases
- Error scenarios
```

---

## 📦 Adding Dependencies

```
I need to add [package name] to the project for [purpose].

**Why this package**:
- [Reason 1]
- [Reason 2]

**How it will be used**:
- [Usage 1]
- [Usage 2]

Please:
1. Add the dependency to pubspec.yaml
2. Run flutter pub get
3. Show me a basic example of how to use it in our architecture
4. Update DECISIONS.md with why we chose this package
```

**Example**:
```
I need to add just_audio to the project for playing interval alert sounds.

**Why this package**:
- Recommended in DECISIONS.md for low-latency audio
- Cross-platform support
- Can play background audio

**How it will be used**:
- Play "beep" sound when work interval starts
- Play different sound when rest interval starts
- Play completion sound when workout ends

Please:
1. Add the dependency to pubspec.yaml
2. Run flutter pub get
3. Show me a basic example of how to use it in our architecture
4. Create an AudioService class in core/services/
5. Update DECISIONS.md to confirm this choice
```

---

## 🚀 Preparing for Release

```
I want to prepare the app for [platform] release.

**Current status**:
- [What's implemented]
- [What's been tested]

**Release checklist needed**:
- [ ] App icon designed and added
- [ ] Splash screen configured
- [ ] App name finalized
- [ ] Bundle ID / Package name set
- [ ] Signing configured
- [ ] Permissions requested properly
- [ ] App store assets ready

Please help me with:
1. [Specific task 1]
2. [Specific task 2]
```

---

## 🔍 Code Review Request

```
Please review [file/feature] for:
- [ ] Code quality and best practices
- [ ] Performance issues
- [ ] Security concerns
- [ ] Accessibility
- [ ] Architecture compliance
- [ ] Missing tests
- [ ] Documentation gaps

**Specific concerns**:
- [Concern 1]
- [Concern 2]

File(s) to review:
- [File path 1]
- [File path 2]
```

---

## 💡 General Question

```
I have a question about [topic]:

[Your question]

**Context**:
- [Relevant info 1]
- [Relevant info 2]

**What I've already tried**:
- [Research/attempt 1]
- [Research/attempt 2]

Please explain in a beginner-friendly way with examples if possible.
```

---

## 📊 Progress Update Request

```
Please update the .ai/ documentation to reflect current progress:

**Completed**:
- [Task 1]
- [Task 2]
- [Task 3]

**Currently working on**:
- [Current task]

**Next up**:
- [Next task]

**Blockers/Questions**:
- [Any issues]

Please update:
1. CURRENT_STATE.md
2. NEXT_STEPS.md (check off completed items)
3. DECISIONS.md (if any new decisions were made)
```

---

## 🎓 Learning Request

```
I want to understand [concept/pattern] better.

**What I know so far**:
- [Current understanding]

**What's confusing me**:
- [Question 1]
- [Question 2]

**How it relates to this project**:
- [Where it's used]

Please explain:
- The concept in simple terms
- How it applies to our interval timer app
- A concrete example from our codebase (or create one)
- Any best practices or gotchas
```

**Example**:
```
I want to understand Riverpod providers better.

**What I know so far**:
- Providers hold state that widgets can watch
- StateNotifierProvider is for complex state

**What's confusing me**:
- When to use Provider vs StateProvider vs StateNotifierProvider
- How to combine multiple providers
- Where providers should be declared

**How it relates to this project**:
- We're using it for timer state management

Please explain:
- The concept in simple terms
- How it applies to our interval timer app
- A concrete example with our timer
- Any best practices or gotchas
```

---

## 🎯 Quick Task

```
Quick task: [Concise description of what you need]

[Any necessary context]
```

**Use this for**:
- Simple one-line changes
- Adding a single widget
- Fixing a typo
- Quick clarifications

---

## 📝 Notes for Using These Templates

### Tips for Better Prompts:
1. **Be specific**: "Make the timer bigger" vs "Increase timer font size to 72sp"
2. **Provide context**: Reference files, previous decisions, current state
3. **Set expectations**: What success looks like
4. **Ask questions**: If unsure, ask the AI to clarify options

### Best Practices:
- ✅ Copy template and fill in all sections
- ✅ Reference documentation files (PROJECT_CONTEXT.md, etc.)
- ✅ Include error messages in full
- ✅ Specify which files are involved
- ⚠️ Don't ask for too many unrelated things at once
- ⚠️ Don't assume AI remembers previous conversations

### Iterating:
If the first response isn't quite right:
```
Thanks! That's close, but could you adjust [specific thing]?

[More specific guidance]
```

### Saving Good Prompts:
When you craft a prompt that works really well, save it to this file as a new template!

---

## 🤖 Meta: Prompts About Prompts

```
I want to create a reusable prompt template for [common task].

**Task description**: [What this task involves]

**Variables that change**: [What's different each time]

**Fixed requirements**: [What's always the same]

Please create a template I can add to PROMPTS.md.
```

---

**Last Updated**: October 30, 2025
**Version**: 1.0
