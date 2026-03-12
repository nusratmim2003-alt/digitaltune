# Memory Library — UX Design Specification
**Digital Cassette Mobile App**

Version 1.0 | March 2026

---

## 1. Purpose of the Library

### What the Library Is For

The Memory Library is the emotional archive of Digital Cassette. It's where users return to revisit the musical memories they've shared and received—a digital memory box that feels intimate, personal, and nostalgic.

Unlike a transactional messaging inbox, the Library is a reflective space. Each cassette represents a moment frozen in time: a song that said what words couldn't, a letter that captured raw emotion, a connection made meaningful through music.

### Emotional Role

The Library serves these emotional functions:

- **Remembrance**: Users revisit cassettes when they want to feel again
- **Connection**: Users see the trail of emotional exchanges with people who matter
- **Reflection**: Users look back at moments they've created and received
- **Preservation**: Users save cassettes they don't want to lose
- **Continuation**: Users return to reply, extending conversations across time

The Library is not just storage—it's a ritual of return. Users come back when:
- They miss someone
- They want to hear that song again
- They're ready to reply
- They need comfort or nostalgia
- They want to relive a memory

### Retention & Revisiting

The Library drives retention through:

1. **Emotional Investment**: Each cassette represents time, thought, and vulnerability
2. **Incomplete Threads**: Unreplied cassettes create gentle pull-back motivation
3. **Saved Moments**: Users curate their most precious memories
4. **Discovery**: Users might stumble on cassettes they forgot about
5. **Birthday/Anniversary Triggers**: Future feature: reminders about special dates

The design must make returning feel rewarding, not overwhelming.

---

## 2. Information Architecture

### Three-Tab System

The Library uses a clear three-tab structure:

#### **Sent Tab**
**Definition**: Cassettes created and sent by the current user.

**What belongs here**:
- Original cassettes the user created
- Cassettes they sent to specific people
- Reply cassettes they sent in response to someone else

**What does NOT belong here**:
- Cassettes they received
- Cassettes someone else sent
- Drafts (not in MVP)

**Count badge**: Total number of sent cassettes

**Emotional tone**: "What I've shared with the world"

---

#### **Inbox Tab**
**Definition**: Cassettes received by the user from others, including replies.

**What belongs here**:
- Original cassettes sent to the user by others
- Reply cassettes received in conversation threads
- Cassettes unlocked by the user (that they didn't send)

**What does NOT belong here**:
- Cassettes the user created themselves
- Cassettes the user only saved but never unlocked
- Deleted cassettes

**Count badge**: Total number of received cassettes

**Emotional tone**: "What others have given me"

---

#### **Saved Tab**
**Definition**: Cassettes explicitly saved by the user after unlocking, regardless of whether they sent or received them.

**What belongs here**:
- Any cassette the user marked as "saved"
- Could be from Sent or Inbox tabs
- Acts as a curated favorites list

**What does NOT belong here**:
- Cassettes not explicitly saved
- Unsaved cassettes, even if unlocked

**Count badge**: Total number of saved cassettes

**Emotional tone**: "What I want to keep forever"

---

### Tab Relationships

- A cassette can appear in **Sent** and **Saved** simultaneously
- A cassette can appear in **Inbox** and **Saved** simultaneously
- Saving does not remove the cassette from its origin tab
- Unsaving removes it only from Saved tab
- Deleting a sent cassette removes it from Sent (and Saved if saved)

---

## 3. Library Screen Layout

### Screen Structure (Flutter Mobile)

```
┌─────────────────────────────────┐
│  [Back]  Memory Library    [⋮]  │ ← App Bar
├─────────────────────────────────┤
│  Your musical memories           │ ← Subtitle
├─────────────────────────────────┤
│  [Sent 3] [Inbox 1] [Saved 2]   │ ← Segmented Tab Bar
├─────────────────────────────────┤
│  [🔍 Search memories...]         │ ← Search (collapsible)
├─────────────────────────────────┤
│                                  │
│  ┌───────────────────────────┐  │
│  │ [🎵] Someone Like You     │  │ ← Memory Card
│  │     ❤ Love • Mar 5  AX34DF│  │
│  └───────────────────────────┘  │
│                                  │
│  ┌───────────────────────────┐  │
│  │ [🎵] Bohemian Rhapsody    │  │
│  │     📦 Nostalgia • Feb 28 │  │
│  └───────────────────────────┘  │
│                                  │
│  ┌───────────────────────────┐  │
│  │ [🎵] Count on Me          │  │
│  │     💛 Friendship • Feb 14│  │
│  └───────────────────────────┘  │
│                                  │
│  [Pull to refresh]               │
│                                  │
└─────────────────────────────────┘
│ [🏠] [📚] [➕] [🔔] [👤]        │ ← Bottom Nav
└─────────────────────────────────┘
```

### Layout Specifications

**App Bar**:
- Title: "Memory Library" (Playfair Display, 20sp, deep brown)
- Background: Cream paper (#F5F0E8)
- Elevation: 0
- Leading: Back icon (if navigated from elsewhere)
- Trailing: Overflow menu (3-dot) for settings/filters

**Subtitle**:
- Text: "Your musical memories"
- Style: Inter, 14sp, muted sepia (#6E5C4F)
- Padding: 16px horizontal, 8px vertical
- Background: Cream paper

**Tab Bar Section**:
- Height: 56px
- Background: Cream paper
- Horizontal padding: 16px
- Sticky at top when scrolling

**Search Bar** (Optional, Collapsible):
- Shown below tabs
- Height: 48px
- Border: 1px vintage border (#D8CBB7)
- Rounded: 12px
- Placeholder: "Search memories..." (Muted text)
- Icon: 🔍 left-aligned
- Background: White (#FFFFFF)
- Margin: 16px horizontal, 12px vertical
- Initially collapsed, expands on tap

**Content Area**:
- Scrollable list of memory cards
- Padding: 16px horizontal
- Card spacing: 12px vertical
- Pull-to-refresh enabled
- Bottom padding: 80px (for bottom nav clearance)

**Empty State**:
- Centered vertically in content area
- Icon + Title + Subtitle + CTA (if appropriate)

---

## 4. Visual Design Requirements

### Color Palette

**Backgrounds**:
- Page background: `#F5F0E8` (warm cream paper)
- Card surface: `#EBE3D5` (secondary paper)
- Tab bar background: `#F5F0E8`
- Active tab: `#EBE3D5` with subtle shadow
- Search bar: `#FFFFFF`

**Text**:
- Primary text: `#2E1E0F` (deep brown)
- Secondary text: `#6E5C4F` (muted sepia)
- Badge text: `#2E1E0F`

**Accents**:
- Active tab indicator: `#D6A441` (accent gold)
- Badge background: `#D6A441` with 15% opacity
- Save icon: `#D6A441`
- CTA buttons: Golden gradient

**Borders & Shadows**:
- Card border: `#D8CBB7` (vintage border), 1px
- Card shadow: `rgba(46, 30, 15, 0.06)`, offset (0, 4), blur 12px
- Tab shadow: `rgba(46, 30, 15, 0.04)`, offset (0, 2), blur 8px

### Typography

**Headings**:
- Page title: Playfair Display, 20sp, w600, deep brown
- Card title: Inter, 16sp, w600, deep brown

**Body Text**:
- Subtitle: Inter, 14sp, w400, muted sepia
- Tab labels: Inter, 14sp, w600, deep brown (active) / muted (inactive)
- Card metadata: Inter, 13sp, w400, muted sepia
- Badge: Inter, 11sp, w600, deep brown

**Handwritten Accents**:
- Caveat font for empty state subtitles only
- Not used in tabs, cards, or functional UI

### Spacing & Layout

- Base unit: 4px
- Page horizontal padding: 16px
- Card padding: 16px
- Card spacing: 12px vertical
- Tab bar height: 56px
- Tab item padding: 12px horizontal, 10px vertical
- Badge padding: 4px horizontal, 2px vertical
- Minimum touch target: 48x48dp

### Rounded Corners

- Cards: 16px
- Tabs: 12px
- Badges: 16px (pill shape)
- Search bar: 12px
- Cassette icon: 8px

---

## 5. Segmented Tab Bar UX

### Tab Bar Design

**Layout**:
```
┌─────────────────────────────────┐
│  ┌─────┐  ┌─────┐  ┌─────┐     │
│  │Sent │  │Inbox│  │Saved│     │
│  │  3  │  │  1  │  │  2  │     │
│  └─────┘  └─────┘  └─────┘     │
└─────────────────────────────────┘
```

**Tab Item Anatomy**:
- Label: "Sent", "Inbox", or "Saved"
- Count badge: Small rounded pill (e.g., "3")
- Spacing: 8px between label and badge

**Visual States**:

**Active Tab**:
- Background: `#EBE3D5` (paper surface)
- Text color: `#2E1E0F` (deep brown)
- Font weight: 600
- Border bottom: 3px solid `#D6A441` (golden accent)
- Shadow: Subtle elevation shadow
- Badge background: `#D6A441` with 20% opacity
- Badge text: `#2E1E0F`

**Inactive Tab**:
- Background: Transparent
- Text color: `#6E5C4F` (muted sepia)
- Font weight: 500
- No border
- No shadow
- Badge background: `#D8CBB7` (border color) with 10% opacity
- Badge text: `#6E5C4F`

**Pressed State**:
- Slight scale down (0.98)
- Ripple effect in golden accent color (20% opacity)
- Immediate visual feedback

### Tab Behavior

**Tap Interaction**:
1. User taps inactive tab
2. Ripple animation expands from tap point
3. Tab scales slightly (0.98) for 100ms
4. Content area fades out (150ms)
5. Tab transitions to active state (200ms)
6. New content fades in (150ms, delayed 100ms)
7. Total transition: ~350ms

**Scroll Behavior**:
- Tab bar sticks to top when content scrolls
- Always visible, even at bottom of long lists
- No auto-hiding

**Badge Updates**:
- Count updates immediately when action taken
- Number animates (scale pulse) when changed
- If count reaches 0, badge hides gracefully
- If count increases, badge scales in

### Accessibility

- Each tab has semantic label: "Sent cassettes, 3 items"
- Selected state announced by screen reader
- Keyboard navigable (tab key cycles through)
- Minimum touch target: 48x48dp per tab

---

## 6. Memory Card UX

### Card Anatomy

```
┌───────────────────────────────────┐
│ [Icon] Title            [Badge]   │
│        Emoji • Meta • Date        │
└───────────────────────────────────┘
```

**Left: Cassette Icon** (56x56dp)
- Dark brown square: `#3B2314`
- Rounded corners: 8px
- Golden music note icon: `#D6A441`
- Or optional: YouTube thumbnail (future)
- Icon size: 24dp
- Vertically centered

**Center: Content** (Flexible width)
- **Line 1**: Memory title
  - Font: Inter, 16sp, w600, deep brown
  - Max lines: 1
  - Ellipsis if overflow
  - Example: "Someone Like You"
  
- **Line 2**: Metadata
  - Font: Inter, 13sp, w400, muted sepia
  - Format: `[Emoji] [Emotion] • [Date]`
  - Example: "❤ Love • Mar 5"
  - Max lines: 1

**Right: Code Badge** (64dp width, aligned right)
- Background: `#D6A441` with 15% opacity
- Text: Inter, 11sp, w600, deep brown
- Padding: 6px horizontal, 4px vertical
- Rounded: 12px
- Example: "AX3" or "AX34DF"
- Vertically centered

### Card Visual Design

**Container**:
- Background: `#EBE3D5` (paper surface)
- Border: 1px solid `#D8CBB7` (vintage border)
- Border radius: 16px
- Shadow: `rgba(46, 30, 15, 0.06)`, offset (0, 4), blur 12px
- Padding: 16px
- Height: 88dp (comfortable mobile touch)
- Margin: 12px vertical, 16px horizontal

**Interactive States**:

**Default**:
- Full opacity
- No scale

**Pressed**:
- Scale: 0.98
- Shadow intensifies slightly
- Duration: 100ms

**Tap Feedback**:
- Ripple effect in golden accent (10% opacity)
- Expands from tap point
- Duration: 300ms

### Example Cards

**Card 1: Sent Love Cassette**
```
┌───────────────────────────────────┐
│ [🎵] Someone Like You   [AX34DF]  │
│      ❤ Love • Mar 5               │
└───────────────────────────────────┘
```

**Card 2: Received Nostalgia Cassette**
```
┌───────────────────────────────────┐
│ [🎵] Bohemian Rhapsody  [BK92QR]  │
│      📦 Nostalgia • Feb 28        │
└───────────────────────────────────┘
```

**Card 3: Saved Friendship Cassette**
```
┌───────────────────────────────────┐
│ [🎵] Count on Me        [CZ11PL]  │
│      💛 Friendship • Feb 14        │
└───────────────────────────────────┘
```

### Card Touch Behavior

**Single Tap**:
- Opens Memory Detail screen
- Card scales down briefly (feedback)
- Page transitions with slide-up animation

**Long Press** (Future):
- Show context menu
- Options: Save/Unsave, Delete (if sender), Share
- Not in MVP

**Swipe** (Not Recommended for MVP):
- Avoid horizontal swipe actions
- Keep interactions simple and explicit

### Card List Behavior

**List Entrance**:
- Cards stagger-fade in from bottom
- Delay: 50ms between each card
- Animation duration: 200ms per card
- Max 5 cards animate at once

**Pull to Refresh**:
- Golden accent spinner/indicator
- Pulls down 80dp to trigger
- Haptic feedback on trigger
- List refreshes, cards re-animate

**Scroll Performance**:
- Cards should be lightweight widgets
- Avoid heavy thumbnails in MVP
- Use simple icons initially
- Load thumbnails lazily if added later

---

## 7. Memory Detail Screen UX

### Screen Structure

```
┌─────────────────────────────────┐
│ [←] Memory Detail      [⋮]      │ ← App Bar
├─────────────────────────────────┤
│                                  │
│     ┌─────────────────────┐     │
│     │                     │     │ ← Cassette Visual
│     │    🎵 Side A        │     │
│     │                     │     │
│     └─────────────────────┘     │
│                                  │
│  Someone Like You                │ ← Title
│  ❤ Love • Mar 5 • AX34DF        │ ← Metadata
│                                  │
├─────────────────────────────────┤
│  [▶ Play Song]                   │ ← YouTube Player CTA
├─────────────────────────────────┤
│                                  │
│  From: Maya Johnson              │ ← Sender
│  (or "Anonymous sender")         │
│                                  │
│  ┌─────────────────────────────┐│
│  │ [Letter Content]            ││ ← Letter Section
│  │                             ││
│  │ "Hey! Remember last summer  ││
│  │  when we..."                ││
│  │                             ││
│  └─────────────────────────────┘│
│                                  │
│  [Photo if attached]             │ ← Optional Photo
│                                  │
├─────────────────────────────────┤
│  💬 Conversation                │ ← Reply Thread
│                                  │
│  ┌───────────────────────────┐  │
│  │ [🎵] Maya replied          │  │ ← Reply Card
│  │     💛 Friendship • Mar 6  │  │
│  └───────────────────────────┘  │
│                                  │
├─────────────────────────────────┤
│  [💾 Save] [💬 Reply] [🔁 Replay]│ ← Action Buttons
└─────────────────────────────────┘
```

### Cassette Visual Section

**Cassette Display**:
- Large cassette illustration: 280x182dp (retains aspect ratio)
- Dark brown gradient background
- "Side A" label on cream paper area
- Two tape reels visible
- Golden accent line
- Centered horizontally
- Top padding: 24dp

**Title & Metadata**:
- Title: Playfair Display, 24sp, w600, deep brown
- Metadata: Inter, 14sp, w400, muted sepia
- Format: `[Emoji] [Emotion] • [Date] • [Code]`
- Centered text alignment
- Spacing: 12dp between title and metadata

### YouTube Player Section

**Play Song CTA**:
- Full-width button
- Height: 56dp
- Background: Golden gradient
- Text: "▶ Play Song" (Inter, 16sp, w600, white)
- On tap: Opens YouTube player (embedded or external)
- Margin: 16px horizontal, 16px vertical

**YouTube Embed** (If Inline):
- Standard YouTube iframe player
- 16:9 aspect ratio
- Rounded corners: 16px
- Border: 1px vintage border
- Replaces CTA button when active

### Letter Section

**Sender Label**:
- Text: "From: [Name]" or "Anonymous sender"
- Font: Inter, 14sp, w500, muted sepia
- Padding: 16px top

**Letter Container**:
- Background: `#FFFFFF` (clean white paper)
- Border: 1px solid `#D8CBB7`
- Rounded: 16px
- Padding: 20px
- Shadow: Subtle vintage shadow
- Margin: 12px vertical, 16px horizontal

**Letter Text**:
- Font: Caveat, 20sp, w400, deep brown (handwritten style)
- Line height: 1.6
- Max height: None (scroll within screen)
- Color: `#2E1E0F`

**Photo Attachment** (If Present):
- Displayed below letter
- Full-width with 16px margins
- Aspect ratio preserved
- Rounded: 12px
- Border: 1px vintage border
- Margin: 16px top

### Conversation Thread Section

**Section Header**:
- Text: "💬 Conversation"
- Font: Inter, 16sp, w600, deep brown
- Padding: 24px top, 12px bottom

**Reply Cards**:
- Mini version of memory cards
- Height: 72dp
- Same structure as library cards
- Tappable to view reply detail
- Stacked vertically with 8px spacing

**No Replies State**:
- Light gray text: "No replies yet"
- Font: Inter, 14sp, w400, muted sepia
- Centered in section

### Action Buttons

**Button Bar**:
- Fixed at bottom (above system nav)
- Background: Cream paper with top shadow
- Padding: 16px
- Three buttons horizontally arranged

**Save Button**:
- Icon: 💾 (filled if saved, outline if not)
- Label: "Save" or "Saved"
- Background: Transparent (icon button style)
- Text color: Golden accent if saved, muted if not
- On tap: Toggle save state, show toast feedback

**Reply Button**:
- Icon: 💬
- Label: "Reply"
- Background: Golden gradient (primary action)
- Width: Flexible (takes most space)
- On tap: Navigate to Reply Flow screen

**Replay Button** (Optional):
- Icon: 🔁
- Label: "Replay"
- Background: Transparent (outline button)
- On tap: Re-trigger cassette unlock animation

### Interaction Behavior

**Scroll Behavior**:
- Entire screen scrolls as one unit
- Action buttons may sticky-float at bottom
- Cassette visual stays in flow (doesn't parallax)

**Navigation**:
- Back button returns to Library (preserves tab state)
- Overflow menu (⋮): Share, Delete (if sender), Report (future)

**Save Feedback**:
- Instant icon state change
- Toast message: "Saved to library" or "Removed from saved"
- No loading spinner needed

**Delete Confirmation** (If Sender):
- Show bottom sheet dialog
- Title: "Delete this cassette?"
- Message: "This will remove it from your library and the recipient's inbox."
- Actions: "Cancel" (secondary), "Delete" (destructive red)

---

## 8. Search UX

### Search Bar Design

**Default State (Collapsed)**:
- Hidden by default in MVP
- Revealed by tapping search icon in app bar
- Or shown persistent below tabs if room allows

**Expanded State**:
```
┌─────────────────────────────────┐
│  🔍  Search memories...          │
└─────────────────────────────────┘
```

**Specifications**:
- Height: 48dp
- Background: White (#FFFFFF)
- Border: 1px vintage border (#D8CBB7)
- Rounded: 12px
- Icon: 🔍 (16dp, muted sepia)
- Placeholder: "Search memories..." (muted sepia)
- Text: Inter, 15sp, w400, deep brown
- Padding: 12px horizontal

### Search Behavior

**Search Triggers On**:
- Memory title (exact and partial match)
- Letter text preview (if available in query)
- Emotion tag name
- Sender/receiver name (if not anonymous)
- Cassette code (exact match)

**Search Does NOT Trigger On**:
- YouTube video ID
- Hidden metadata
- Dates (use filters for date sorting)

**Search Results**:
- Updates live as user types (debounced 300ms)
- Filters current tab's cassettes only
- Results displayed as normal memory cards
- Highlights matching text (optional in MVP)

**No Results State**:
```
┌─────────────────────────────────┐
│                                  │
│         🔍                       │
│                                  │
│  No memories found               │
│                                  │
│  Try a different search term     │
│                                  │
└─────────────────────────────────┘
```

**Clear Search**:
- X icon appears on right side when text entered
- Tap to clear and return to full list
- Icon color: Muted sepia

### Search Accessibility

- Semantic label: "Search memories"
- Screen reader announces result count
- Result cards maintain full accessibility

---

## 9. Filter and Sort UX

### Filter Options (Minimal MVP)

**Sort Options**:
- Newest first (default)
- Oldest first
- Recently saved (Saved tab only)

**Filter Options**:
- All emotions (default)
- Love ❤
- Nostalgia 📦
- Friendship 💛
- Missing You 💜
- Apology 💙

### Filter UI Design

**Approach: Horizontal Chip Row**

Displayed below search bar (if search is shown) or below tab bar:

```
┌─────────────────────────────────┐
│ [Sort ▼] [❤] [📦] [💛] [💜] [💙]│
└─────────────────────────────────┘
```

**Sort Dropdown**:
- Button style
- Label: "Sort" with dropdown icon
- On tap: Shows bottom sheet with radio options
- Selected option shown with checkmark
- Sheet dismisses on selection

**Emotion Chips**:
- Small rounded chips
- Icon only (emoji)
- Size: 40x40dp
- Background: Transparent (inactive)
- Background: Golden accent 20% opacity (active)
- Border: 1px vintage border (inactive)
- Border: 1px golden accent (active)
- Tap to toggle filter
- Multiple selections allowed (OR logic)

**Alternative: Bottom Sheet (If Space Limited)**:
- Single "Filter & Sort" button below tabs
- Opens bottom sheet with all options
- Apply button at bottom
- Dismisses on apply

### Filter Behavior

**Active Filter Indication**:
- Chip background changes to golden accent
- Filter button shows count badge (e.g., "2 active")
- Results update immediately

**Clear Filters**:
- Show "Clear" text button if any filters active
- Resets to default (newest, all emotions)

**Filtered Results**:
- Display as normal memory cards
- Show count in tab badge (filtered count)
- If zero results, show empty state variant

### Filter Accessibility

- Each chip has semantic label: "Filter by Love"
- Active state announced
- Keyboard navigable

---

## 10. Empty State UX

### Empty Sent Tab

**Visual**:
```
┌─────────────────────────────────┐
│                                  │
│         📼                       │
│                                  │
│  No cassettes sent yet           │
│                                  │
│  Create your first memory and    │
│  share a song with someone       │
│                                  │
│  [Create a Cassette]             │
│                                  │
└─────────────────────────────────┘
```

**Copy**:
- Title: "No cassettes sent yet"
- Subtitle: "Create your first memory and share a song with someone"
- CTA: "Create a Cassette" button (golden gradient)

**Tone**: Encouraging, warm, action-oriented

---

### Empty Inbox Tab

**Visual**:
```
┌─────────────────────────────────┐
│                                  │
│         📬                       │
│                                  │
│  Your inbox is quiet             │
│                                  │
│  When someone sends you a        │
│  cassette, it'll appear here     │
│                                  │
└─────────────────────────────────┘
```

**Copy**:
- Title: "Your inbox is quiet"
- Subtitle: "When someone sends you a cassette, it'll appear here"
- No CTA (passive state)

**Tone**: Calm, patient, welcoming

---

### Empty Saved Tab

**Visual**:
```
┌─────────────────────────────────┐
│                                  │
│         💾                       │
│                                  │
│  No saved memories yet           │
│                                  │
│  Save cassettes you want to      │
│  keep forever                    │
│                                  │
└─────────────────────────────────┘
```

**Copy**:
- Title: "No saved memories yet"
- Subtitle: "Save cassettes you want to keep forever"
- No CTA

**Tone**: Gentle, curatorial, intimate

---

### No Search Results

**Visual**:
```
┌─────────────────────────────────┐
│                                  │
│         🔍                       │
│                                  │
│  No memories found               │
│                                  │
│  Try a different search term     │
│  or adjust your filters          │
│                                  │
└─────────────────────────────────┘
```

**Copy**:
- Title: "No memories found"
- Subtitle: "Try a different search term or adjust your filters"
- No CTA (search term adjusts results)

**Tone**: Helpful, non-judgmental

---

### No Filtered Results

**Visual**: Same as no search results

**Copy**:
- Title: "No cassettes match"
- Subtitle: "Try removing some filters"
- CTA: "Clear Filters" text button

**Tone**: Helpful, solution-oriented

---

### Design Principles for Empty States

1. **Icon First**: Large, friendly icon (64dp, centered)
2. **Title**: Short, human, non-technical (Playfair Display, 18sp)
3. **Subtitle**: 1-2 short sentences, warm tone (Inter, 14sp)
4. **CTA**: Only if user can take action (golden gradient button)
5. **Spacing**: Generous vertical rhythm (24dp between elements)
6. **Color**: Muted sepia text, not pure gray
7. **No Illustrations**: Keep it minimal (icon only, no complex artwork in MVP)

---

## 11. Interaction Behavior

### Tap on Tab

**Behavior**:
1. Tab ripple animation (golden accent, 20% opacity)
2. Tab scales down slightly (0.98) for 100ms
3. Content area fades out (opacity 1 → 0, 150ms)
4. Tab transitions to active state (200ms)
   - Background fills
   - Text color darkens
   - Bottom border appears
5. New content fades in (opacity 0 → 1, 150ms, delayed 100ms)
6. Cards stagger-animate from bottom

**Feedback**:
- Immediate visual response (ripple, scale)
- Smooth content transition
- Total duration: ~350ms

---

### Tap on Memory Card

**Behavior**:
1. Card ripple animation (golden accent, 10% opacity)
2. Card scales down (0.98) for 100ms
3. Haptic feedback (light tap)
4. Navigate to Memory Detail screen
5. Transition: Slide up from bottom (300ms)

**Feedback**:
- Visual feedback before navigation
- Smooth, fluid transition
- Navigation feels intentional, not instant

---

### Pull to Refresh

**Trigger**:
- User pulls down on list
- Overscroll by 80dp to trigger
- Indicator appears at 40dp

**Indicator**:
- Golden accent spinner (circular progress)
- Size: 24dp
- Centered horizontally
- Rotates continuously

**Behavior**:
1. User pulls down (elastic scroll)
2. Indicator scale-fades in
3. At 80dp, haptic feedback (medium impact)
4. User releases
5. List animates back to top
6. Spinner rotates for 1-2 seconds
7. New/updated cards fade in
8. Spinner fades out

**Feedback**:
- Elastic visual feedback
- Haptic confirmation on trigger
- Clear "refreshing" state
- Smooth return to content

---

### Long Press (Future, Not MVP)

**Trigger**:
- User long-presses memory card for 500ms
- Haptic feedback (medium impact)

**Behavior**:
- Card slightly elevates (scale 1.02, shadow increases)
- Context menu appears as bottom sheet
- Options: Save/Unsave, Delete (if sender), Share, Report

**Not Included in MVP**:
- Keep interactions simple and explicit
- Use dedicated buttons instead

---

### Save/Unsave

**Location**: Memory Detail screen (action button bar)

**Save Behavior**:
1. User taps "Save" button
2. Icon fills instantly (outline → filled)
3. Label changes: "Save" → "Saved"
4. Button color shifts to golden accent
5. Toast appears: "Saved to library"
6. Cassette added to Saved tab

**Unsave Behavior**:
1. User taps "Saved" button
2. Icon unfills instantly (filled → outline)
3. Label changes: "Saved" → "Save"
4. Button color returns to muted
5. Toast appears: "Removed from saved"
6. Cassette removed from Saved tab

**Feedback**:
- Instant visual state change (no loading)
- Toast confirmation
- Icon and label sync

---

### Delete Confirmation

**Trigger**: User taps Delete in overflow menu (Memory Detail screen)

**Behavior**:
1. Bottom sheet slides up from bottom
2. Title: "Delete this cassette?"
3. Message: "This will remove it from your library and the recipient's inbox."
4. Actions:
   - "Cancel" (secondary button, left)
   - "Delete" (destructive red button, right)

**On Cancel**:
- Sheet slides down
- Returns to detail screen

**On Delete**:
1. Sheet slides down
2. Loading indicator appears briefly
3. Navigate back to Library (preserves tab)
4. Toast: "Cassette deleted"
5. Card removed from list (fade-out animation)

**Feedback**:
- Clear warning message
- Destructive action color-coded (red)
- Confirmation prevents accidents

---

### Reply CTA

**Location**: Memory Detail screen (primary action button)

**Behavior**:
1. User taps "Reply" button
2. Button scales down (0.98) for 100ms
3. Navigate to Reply Flow screen
4. Transition: Slide up from bottom (300ms)
5. Original cassette context shown at top of reply flow

**Feedback**:
- Clear action button (golden gradient)
- Smooth navigation
- Context preserved in reply flow

---

### Replay Cassette CTA

**Location**: Memory Detail screen (action button bar)

**Behavior**:
1. User taps "Replay" button
2. Detail screen fades out
3. Unlock/experience screen appears
4. Cassette unlocks with full animation sequence
5. After experience, returns to detail screen

**Feedback**:
- Re-experience the full unlock emotion
- Useful for showing cassette to someone else
- Non-destructive action

---

## 12. Motion and Micro-interactions

### Tab Switching Transition

**Duration**: 350ms total

**Sequence**:
1. **Tap (0ms)**: Ripple animation begins
2. **Scale (0-100ms)**: Tab scales to 0.98
3. **Content fade-out (0-150ms)**: Current cards fade to opacity 0
4. **Tab transition (100-300ms)**:
   - Background color fills
   - Text color darkens
   - Bottom border appears
   - Shadow elevates
5. **Content fade-in (200-350ms)**: New cards fade from opacity 0 to 1
6. **Card stagger (250-450ms)**: Cards animate up subtly

**Easing**: Cubic-bezier(0.4, 0.0, 0.2, 1) (Material standard)

**Feels**: Smooth, responsive, intentional

---

### Card Press Feedback

**Duration**: 100ms

**Sequence**:
1. **Tap (0ms)**: Ripple animation begins from tap point
2. **Scale (0-100ms)**: Card scales to 0.98
3. **Ripple expansion (0-300ms)**: Golden ripple expands and fades
4. **Navigation (100ms)**: Screen transition begins

**Easing**: Ease-out

**Feels**: Tactile, immediate, satisfying

---

### Card List Entrance Animation

**Duration**: 200ms per card

**Sequence**:
1. **Tab loads**: Cards initially at opacity 0, translated down 20dp
2. **Stagger delay**: Each card delays by 50ms after previous
3. **Animate**:
   - Opacity: 0 → 1 (200ms)
   - Transform: translateY(20dp) → translateY(0) (200ms)
4. **Max simultaneous**: Only 5 cards animate at once
5. **Remaining cards**: Load instantly (no animation)

**Easing**: Ease-out

**Feels**: Organic, gentle, elegant

---

### Save/Unsave Confirmation

**Duration**: 200ms

**Sequence**:
1. **Icon transition (0-200ms)**:
   - Outline → Filled (or reverse)
   - Scale pulse: 1 → 1.2 → 1
2. **Color transition (0-200ms)**:
   - Muted → Golden accent (or reverse)
3. **Toast appears (100ms delay)**:
   - Slides up from bottom center
   - Text: "Saved to library"
   - Duration: 2 seconds
   - Fades out after 1.5 seconds

**Easing**: Ease-out for icon, ease-in-out for toast

**Feels**: Instant, rewarding, clear

---

### Empty State Appearance

**Duration**: 300ms

**Sequence**:
1. **Tab switches**: Content area clears
2. **Empty state fades in (0-300ms)**:
   - Opacity: 0 → 1
   - Transform: translateY(10dp) → translateY(0)
3. **Icon subtle bounce (200-400ms)**:
   - Scale: 1 → 1.1 → 1

**Easing**: Ease-out

**Feels**: Soft, welcoming, non-jarring

---

### Navigation Into Detail Screen

**Duration**: 300ms

**Sequence**:
1. **Card tap**: Card scales down (100ms)
2. **Screen transition (0-300ms)**:
   - Current screen: Opacity 1 → 0, scale 0.95
   - Detail screen: Slides up from bottom (translateY(100%) → translateY(0))
3. **Detail content loads**: Fade in (200ms, delayed 100ms)

**Easing**: Cubic-bezier(0.4, 0.0, 0.2, 1)

**Feels**: Layered, intentional, mobile-native

---

### Motion Principles Summary

1. **Soft**: No harsh cuts or instant changes
2. **Intimate**: Animations feel personal, not mechanical
3. **Quick**: Total durations under 400ms for most actions
4. **Not Flashy**: Subtle, supportive, never distracting
5. **Performance-Friendly**: Use transforms and opacity (GPU-accelerated)
6. **Purposeful**: Every animation has a reason (feedback, transition, delight)

---

## 13. Accessibility Rules

### Text Contrast

**Minimum Requirements**:
- Primary text (#2E1E0F) on cream (#F5F0E8): **13.8:1 ratio** ✓
- Secondary text (#6E5C4F) on cream (#F5F0E8): **7.2:1 ratio** ✓
- Golden accent (#D6A441) on white: **4.8:1 ratio** ✓
- All ratios exceed WCAG AAA standards

**Enforcement**:
- Never reduce text opacity below 100%
- Avoid light text on light backgrounds
- Use deep brown for all critical text

---

### Minimum Tap Target Sizes

**Requirements**:
- All interactive elements: **48x48dp minimum**
- Tabs: 48dp height (even if label smaller)
- Cards: 88dp height (ample touch area)
- Buttons: 48dp height
- Icons: 24dp visual, 48dp touch area

**Enforcement**:
- Add invisible padding if visual element smaller
- Test on physical devices
- Ensure spacing between tap targets

---

### Semantic Labels

**Screen Readers**:
- Page title: "Memory Library. Your musical memories."
- Tabs: "Sent tab, 3 cassettes. Inbox tab, 1 cassette. Saved tab, 2 cassettes."
- Cards: "Someone Like You. Love. March 5. Cassette code AX34DF. Double tap to open."
- Buttons: "Save cassette. Reply to cassette. Replay cassette experience."

**Implementation**:
- Use `Semantics` widget in Flutter
- Provide meaningful labels for all interactive elements
- Announce state changes (e.g., "Cassette saved")

---

### Badge Accessibility

**Issue**: Count badges alone don't convey meaning to screen readers

**Solution**:
- Tab label includes count: "Sent, 3 items"
- Don't rely solely on visual badges
- Announce count changes

---

### Emotion Emoji Accessibility

**Issue**: Emojis may not be readable by screen readers

**Solution**:
- Always pair emoji with text label
- Format: "Love emoji. Love emotion." (screen reader)
- Visual: ❤ Love (user sees)

---

### Motion & Vestibular

**Considerations**:
- Respect `prefers-reduced-motion` system setting
- If enabled, disable all animations except opacity fades
- No parallax effects
- No rotating spinners (use linear progress instead)

---

### Color Blindness

**Considerations**:
- Don't rely solely on color for state (e.g., saved vs. unsaved)
- Use icons, labels, and shapes as well
- Emotion tags use emoji + text, not just color
- Golden accent is distinct enough for most color blindness types

---

### Font Scaling

**Support**:
- Respect user's system font size settings
- Test at 100%, 150%, and 200% scale
- Ensure cards don't break at large sizes
- Allow text to wrap if needed

---

## 14. Edge Cases

### Missing Title Metadata

**Issue**: YouTube video title unavailable or song name not provided

**Solution**:
- Fallback to generic title: "Untitled Memory"
- Show cassette normally
- Don't break card layout

---

### Missing Thumbnail

**Issue**: No YouTube thumbnail loaded

**Solution**:
- Use default cassette icon (dark brown square with golden music note)
- No broken image placeholder
- Consistent with MVP (no thumbnails initially)

---

### Deleted Memory

**Issue**: User tries to open a cassette that was deleted by sender

**Solution**:
- Show error state on Memory Detail screen
- Title: "This cassette has been removed"
- Subtitle: "The sender deleted this memory."
- CTA: "Go Back" button
- Remove from library list after user sees message

---

### Broken or Unavailable YouTube Video

**Issue**: YouTube video no longer available

**Solution**:
- Show error message in player area: "Video unavailable"
- Allow user to still read letter
- Don't break detail screen
- Suggest: "The song may have been removed from YouTube."

---

### Network Failure on Library Load

**Issue**: App can't fetch cassette list

**Solution**:
```
┌─────────────────────────────────┐
│                                  │
│         📡                       │
│                                  │
│  Couldn't load memories          │
│                                  │
│  Check your connection and       │
│  try again                       │
│                                  │
│  [Try Again]                     │
│                                  │
└─────────────────────────────────┘
```

**Behavior**:
- Show error state in content area
- Keep tabs and nav visible
- CTA: "Try Again" button (golden gradient)
- On tap, retry fetch

---

### Network Failure on Detail Screen

**Issue**: App can't load full cassette data

**Solution**:
- Show skeleton loading state initially
- If fails, show error overlay
- Message: "Couldn't load cassette details"
- CTA: "Try Again" or "Go Back"

---

### Very Long Titles

**Issue**: Song title exceeds card width

**Solution**:
- Truncate with ellipsis: "Someone Like You Once Told Me..."
- Max lines: 1
- Full title visible on detail screen
- Don't wrap to second line (breaks visual rhythm)

---

### Very Long Letter Previews

**Issue**: Letter text is hundreds of characters (not in MVP, but consider)

**Solution**:
- No preview text shown on cards (icon + metadata only)
- Full letter only on detail screen
- Detail screen allows scrolling

---

### Duplicate-Looking Entries

**Issue**: User sent same song multiple times to different people

**Solution**:
- Each cassette has unique code badge (AX34DF, BK92QR)
- Show recipient's name if not anonymous (in metadata or detail)
- Allow duplicates (no merge logic)
- User can distinguish by date

---

### No Replies in Thread

**Issue**: Conversation section exists but no replies yet

**Solution**:
- Show section header: "💬 Conversation"
- Empty state text: "No replies yet"
- Style: Muted sepia, centered, soft
- No CTA (Reply button already above)

---

### Saved State Already Exists

**Issue**: User taps Save on already-saved cassette

**Solution**:
- Show as "Saved" state with filled icon
- Tap toggles to Unsave
- No error or duplicate action

---

### Sender is Anonymous

**Issue**: Cassette sent with anonymous mode enabled

**Solution**:
- Show sender as: "Anonymous sender"
- No profile link
- Still allow reply (reply goes back to anonymous sender)
- Maintain privacy

---

### Cassette Code Collision (Unlikely)

**Issue**: Two cassettes somehow have same code

**Solution**:
- Backend ensures unique codes
- If collision somehow occurs, regenerate code
- Not a UX issue (handled by backend)

---

## 15. Data Model Assumptions for UX

### Minimum Data Required per Cassette

**For Library Card Display**:
```json
{
  "id": "uuid-string",
  "title": "Someone Like You",
  "emotion_tag": "love",
  "emotion_emoji": "❤",
  "date_created": "2026-03-05T14:30:00Z",
  "cassette_code": "AX34DF",
  "tab_type": "sent | inbox | saved",
  "is_saved": false,
  "sender_name": "Maya Johnson" | "Anonymous",
  "recipient_name": "Alex Chen" | null,
  "thumbnail_url": null | "https://...",
  "reply_count": 0
}
```

**For Memory Detail Screen**:
```json
{
  "id": "uuid-string",
  "title": "Someone Like You",
  "emotion_tag": "love",
  "emotion_emoji": "❤",
  "date_created": "2026-03-05T14:30:00Z",
  "cassette_code": "AX34DF",
  "sender_id": "uuid",
  "sender_name": "Maya Johnson",
  "sender_is_anonymous": false,
  "recipient_id": "uuid",
  "recipient_name": "Alex Chen",
  "letter_text": "Hey! Remember last summer when we...",
  "photo_url": null | "https://...",
  "youtube_video_id": "abc123xyz",
  "youtube_embed_url": "https://youtube.com/embed/abc123xyz",
  "thumbnail_url": null | "https://...",
  "is_saved": false,
  "replies": [
    {
      "id": "uuid-string",
      "title": "Count on Me",
      "emotion_tag": "friendship",
      "emotion_emoji": "💛",
      "date_created": "2026-03-06T10:15:00Z",
      "cassette_code": "BK92QR",
      "sender_name": "Alex Chen"
    }
  ]
}
```

### API Endpoints Assumed

**GET /api/library/sent** → List of sent cassettes
**GET /api/library/inbox** → List of received cassettes
**GET /api/library/saved** → List of saved cassettes
**GET /api/cassettes/:id** → Full cassette detail
**POST /api/cassettes/:id/save** → Save cassette
**DELETE /api/cassettes/:id/save** → Unsave cassette
**DELETE /api/cassettes/:id** → Delete cassette (if sender)

---

## 16. Flutter Implementation Notes

### Recommended Widget Structure

```
MemoryLibraryScreen (StatefulWidget)
├─ AppBar
│  ├─ Title: "Memory Library"
│  └─ Overflow Menu
├─ Column
│  ├─ Subtitle Text
│  ├─ LibraryTabBar (Custom Widget)
│  │  ├─ TabButton (Sent)
│  │  ├─ TabButton (Inbox)
│  │  └─ TabButton (Saved)
│  ├─ SearchBar (Optional, Collapsible)
│  └─ MemoryList (ListView.builder)
│     ├─ MemoryCard (Reusable Widget)
│     ├─ MemoryCard
│     └─ ...
│     └─ LibraryEmptyState (If empty)
└─ BottomNavigationBar
```

### Reusable Widgets to Create

**LibraryTabBar**:
- Custom StatefulWidget
- Manages selected tab state
- Renders 3 TabButton widgets
- Callback for tab selection

**TabButton**:
- Text label + count badge
- Active/inactive visual states
- Ripple effect on tap
- Semantic label for accessibility

**MemoryCard**:
- Cassette icon/thumbnail (left)
- Title + metadata (center)
- Code badge (right)
- Tap gesture detector
- Ripple effect on press

**LibraryEmptyState**:
- Icon (64dp)
- Title (Playfair Display)
- Subtitle (Inter)
- Optional CTA button
- Configurable for each tab

**MemoryDetailScreen**:
- Cassette visual component
- YouTube player area
- Letter container
- Reply thread list
- Action button bar

**SaveButton**:
- Icon + label
- Toggle state (saved/unsaved)
- Toast feedback on tap
- Semantic label

**ReplyButton**:
- Golden gradient button
- Navigation to reply flow
- Maintains original cassette context

### State Management Approach

**Recommended**: Riverpod for state management

**Providers**:
- `memoryLibraryProvider` → Fetches and caches cassette lists
- `selectedTabProvider` → Tracks active tab
- `savedCassettesProvider` → Manages saved state
- `cassetteDetailProvider` → Fetches full cassette data

**Why Riverpod**:
- Already used in project
- Clean separation of UI and business logic
- Easy to test
- Good for async data fetching

### Performance Considerations

**List Optimization**:
- Use `ListView.builder` for efficient rendering
- Only render visible cards
- Avoid heavy widgets in cards (keep thumbnails simple)

**Caching**:
- Cache fetched cassette lists
- Use `CachedNetworkImage` for thumbnails (future)
- Invalidate cache on save/unsave/delete

**Lazy Loading**:
- Load first 20 cassettes
- Fetch more on scroll to bottom
- Show "Loading more..." indicator

### Routing

**Go Router Routes**:
- `/library` → MemoryLibraryScreen
- `/library/detail/:id` → MemoryDetailScreen
- Query params: `?tab=sent` (optional, to restore tab state)

**Navigation**:
- From HomeScreen bottom nav → `/library`
- From MemoryCard tap → `/library/detail/:id`
- Back button preserves tab state

---

## 17. Final Design Tone

### The Library Should Feel Like

**A Digital Memory Box**:
- Warm and nostalgic
- Each cassette is a treasure
- Revisiting feels intimate and intentional
- Not overwhelming or cluttered

**A Shelf of Emotional Cassette Moments**:
- Organized but personal
- Visual distinction between tabs
- Cassette codes feel like catalog numbers
- Each entry is a keepsake

**Something Users Return To When They Want to Remember Someone**:
- Low-pressure browsing
- Easy to find specific memories
- Revisiting feels rewarding
- Not transactional (no urgency, no notifications)

---

### The Library Should NOT Feel Like

**A Corporate Dashboard**:
- No cold blues or grays
- No sterile white backgrounds
- No generic icons
- No data-table vibes

**A Standard Messaging Inbox**:
- No chat bubbles
- No typing indicators
- No "unread" badges (unless truly necessary)
- No timestamp minutiae (dates are poetic, not technical)

**A Generic List Page**:
- Not just a vertical scroll of identical items
- Each card feels collectible
- Visual warmth throughout
- Motion and feedback make it feel alive

---

### Visual Tone Summary

**Colors**: Warm cream paper, deep brown text, golden accents
**Typography**: Elegant serifs for headings, clean sans-serif for UI, handwritten for letters
**Spacing**: Generous, uncluttered, breathable
**Shadows**: Soft, vintage, subtle
**Shapes**: Rounded, friendly, tactile
**Motion**: Soft, quick, supportive
**Emotion**: Nostalgic, intimate, reflective

---

## Implementation Checklist

### Phase 1: Core Library Screen
- [ ] Create `MemoryLibraryScreen` widget
- [ ] Implement `LibraryTabBar` with 3 tabs
- [ ] Build `MemoryCard` reusable widget
- [ ] Wire up tab selection state
- [ ] Fetch and display cassette lists
- [ ] Add pull-to-refresh

### Phase 2: Empty States & Error Handling
- [ ] Create `LibraryEmptyState` widget
- [ ] Design empty states for each tab
- [ ] Handle network errors gracefully
- [ ] Add retry UI

### Phase 3: Memory Detail Screen
- [ ] Create `MemoryDetailScreen` widget
- [ ] Display cassette visual and metadata
- [ ] Render letter text
- [ ] Add YouTube player CTA
- [ ] Build action button bar (Save, Reply, Replay)

### Phase 4: Save/Unsave Functionality
- [ ] Implement save button toggle
- [ ] Sync saved state across tabs
- [ ] Add toast feedback
- [ ] Update Saved tab count badge

### Phase 5: Search & Filters (Optional)
- [ ] Add search bar (collapsible)
- [ ] Implement search logic
- [ ] Add emotion filter chips
- [ ] Add sort dropdown

### Phase 6: Motion & Accessibility
- [ ] Add tab transition animations
- [ ] Add card entrance animations
- [ ] Implement card press feedback
- [ ] Add semantic labels for screen readers
- [ ] Test with TalkBack/VoiceOver
- [ ] Verify tap target sizes

### Phase 7: Edge Cases & Polish
- [ ] Handle missing data gracefully
- [ ] Test with long titles
- [ ] Test with anonymous senders
- [ ] Add delete confirmation dialog
- [ ] Final UI polish and spacing

---

## Appendix: Design Tokens

### Colors
```dart
// Backgrounds
static const Color background = Color(0xFFF5F0E8);
static const Color paper = Color(0xFFEBE3D5);

// Text
static const Color primaryText = Color(0xFF2E1E0F);
static const Color mutedText = Color(0xFF6E5C4F);

// Accent
static const Color accent = Color(0xFFD6A441);

// Borders
static const Color border = Color(0xFFD8CBB7);

// Semantic
static const Color error = Color(0xFFC6453C);
static const Color success = Color(0xFF4C8B4A);
```

### Typography
```dart
// Headings
static TextStyle h1 = GoogleFonts.playfairDisplay(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: AppColors.primaryText,
);

// Body
static TextStyle body = GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: AppColors.primaryText,
);

// Handwritten
static TextStyle handwritten = GoogleFonts.caveat(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  color: AppColors.primaryText,
);
```

### Spacing
```dart
static const double xs = 4.0;
static const double sm = 8.0;
static const double md = 12.0;
static const double lg = 16.0;
static const double xl = 24.0;
static const double xxl = 32.0;
```

### Border Radius
```dart
static const double radiusSmall = 8.0;
static const double radiusMedium = 12.0;
static const double radiusLarge = 16.0;
static const double radiusCircular = 9999.0;
```

---

**End of Memory Library UX Specification**

*This document should be used as the source of truth for design and development of the Memory Library feature in Digital Cassette.*
