# Digital Cassette — Complete UX Design Document

**Version:** 1.0  
**Date:** March 9, 2026  
**Platform:** Mobile-first (Flutter), optional web landing page  
**Backend:** FastAPI + PostgreSQL

---

## Table of Contents

1. [Product Overview](#product-overview)
2. [Product Principles](#product-principles)
3. [User Personas](#user-personas)
4. [Core User Flows](#core-user-flows)
5. [Authentication Flow](#authentication-flow)
6. [Home Dashboard](#home-dashboard)
7. [Create Cassette Flow](#create-cassette-flow)
8. [Receiver Unlock Flow](#receiver-unlock-flow)
9. [Cassette Experience Ritual](#cassette-experience-ritual)
10. [Memory Library](#memory-library)
11. [Reply Flow](#reply-flow)
12. [Notifications](#notifications)
13. [Profile & Settings](#profile--settings)
14. [States & Feedback](#states--feedback)
15. [Motion & Micro-interactions](#motion--micro-interactions)
16. [Accessibility](#accessibility)
17. [Mobile-First Layout Rules](#mobile-first-layout-rules)
18. [Design System](#design-system)
19. [Web Landing Page (Optional)](#web-landing-page-optional)
20. [Technical Integration Notes](#technical-integration-notes)

---

## Product Overview

**Digital Cassette** is a nostalgic mobile app where users send meaningful musical moments through a cassette-inspired experience. Each "cassette" contains:
- A YouTube song link (the emotional soundtrack)
- A personal handwritten-style letter
- An optional photo

The receiver unlocks the cassette with a password, experiencing a cinematic reveal animation before listening and reading.

### Core Product Rule (MVP)
- **Song source:** YouTube link only (no in-app search, no manual artist/title entry)
- **Primary platform:** Mobile app (Android first, iOS-ready architecture)
- **Core magic moment:** Password-protected unlock with cassette animation

---

## Product Principles

### 1. **Emotional First**
Every interaction should feel warm, nostalgic, and intentional. No cold utility.

### 2. **Slowness is a Feature**
Pause, anticipation, and reveal are part of the experience. Don't rush users through the cassette moment.

### 3. **Simplicity Over Features**
One YouTube link. One letter. One photo. That's it. No complexity, no overwhelm.

### 4. **Analog Soul, Digital Body**
Design feels handcrafted and tactile but leverages modern tech seamlessly.

### 5. **Privacy by Design**
Password-protected memories. Anonymous mode. Users control their emotional data.

### 6. **Mobile-Intimate, Not Desktop-Formal**
This is a phone-in-hand, late-night message app. Not a productivity tool.

---

## User Personas

### Persona 1: **Maya, the Long-Distance Friend**
- **Age:** 26
- **Goal:** Stay emotionally connected with her best friend across time zones
- **Pain:** Generic messaging feels cold; wants something more meaningful
- **Behavior:** Sends cassettes on birthdays, anniversaries, or "just because" moments
- **Quote:** *"I want to send something more than just a text."*

### Persona 2: **Alex, the Nostalgic Romantic**
- **Age:** 32
- **Goal:** Express feelings through music and words in a memorable way
- **Pain:** Playlists feel impersonal; wants a private, password-protected love letter
- **Behavior:** Creates cassettes for partner on special occasions, uses handwritten-style text
- **Quote:** *"I want them to feel the song the way I do."*

### Persona 3: **Jordan, the Apology Sender**
- **Age:** 23
- **Goal:** Make amends after a fight with a heartfelt gesture
- **Pain:** Phone calls feel too awkward; texts feel too casual
- **Behavior:** Sends a cassette with an emotional song and sincere letter
- **Quote:** *"I needed something more than 'sorry.'"*

### Persona 4: **Sam, the Memory Keeper**
- **Age:** 29
- **Goal:** Archive meaningful musical moments with friends and family
- **Pain:** Streaming playlists don't capture context or emotional story
- **Behavior:** Saves received cassettes, revisits them when nostalgic, replies with songs
- **Quote:** *"I want to remember how this song made me feel."*

---

## Core User Flows

### High-Level Journey Map

```
Sender Journey:
1. Opens app → Sees home dashboard
2. Taps "Create Cassette"
3. Pastes YouTube link
4. Writes letter
5. Uploads optional photo
6. Chooses emotion tag
7. Sets password
8. Previews cassette
9. Generates link
10. Shares link with receiver

Receiver Journey:
1. Receives link (via SMS, WhatsApp, etc.)
2. Opens link → Lands on unlock screen
3. Enters password
4. Experiences unlock animation
5. Cassette reveals
6. Reads letter, views photo, plays song
7. Saves to library (requires login)
8. Optionally replies with their own song
```

---

## Authentication Flow

### Screens

#### 1. **Welcome Screen**
**Purpose:** First impression, emotional tone-setting

**Layout:**
- Hero visual: Illustrated cassette tape with soft shadow
- Headline: "Send songs like handwritten letters"
- Subheading: "Share musical moments, wrapped in emotion"
- CTA: "Get Started"
- Secondary CTA: "I already have an account"

**Motion:**
- Subtle cassette tape reel rotation on load
- Fade-in text animation

---

#### 2. **Login Screen**
**Purpose:** Quick access for returning users

**Fields:**
- Email (autocomplete enabled)
- Password (show/hide toggle)

**CTAs:**
- "Log In" (primary button)
- "Forgot Password?" (text link)
- "Don't have an account? Sign Up" (text link)

**States:**
- Idle
- Loading (spinner in button)
- Error (red border + message below field)
- Success (navigate to home)

**Validation:**
- Email format check
- Password minimum 8 characters

---

#### 3. **Sign Up Screen**
**Purpose:** New user account creation

**Fields:**
- Name (full name)
- Email
- Password (show/hide toggle)
- Confirm Password (show/hide toggle)

**CTAs:**
- "Create Account" (primary button)
- "Already have an account? Log In" (text link)

**States:**
- Idle
- Loading
- Error (inline field validation)
- Success (navigate to optional profile setup)

**Validation:**
- Name required
- Email format + uniqueness check (API)
- Password strength indicator (weak/medium/strong)
- Passwords match

---

#### 4. **Forgot Password Screen**
**Purpose:** Account recovery

**Fields:**
- Email

**CTAs:**
- "Send Reset Link" (primary button)
- "Back to Login" (text link)

**Flow:**
- User enters email
- Receives reset link via email
- Opens link → lands on reset password screen (not shown here, but assumes token-based reset)

---

#### 5. **Profile Setup Screen (Optional/Skippable)**
**Purpose:** Personalize profile after signup

**Fields:**
- Profile photo (optional, image picker)
- Bio (optional, 150 characters)

**CTAs:**
- "Save & Continue" (primary)
- "Skip for Now" (secondary text link)

**Design Notes:**
- Photo: Circular avatar with "Add Photo" placeholder
- Bio: Multiline text field with character counter

---

## Home Dashboard

### Purpose
Emotional landing pad. Encourage creation. Show recent activity.

### Layout Structure

#### **Top Section: Greeting**
- "Good morning, Maya" (time-based greeting)
- Subtext: "What memory will you create today?"

#### **Primary CTA**
- Large button: "Create a Cassette" (with cassette icon)
- Visual weight: Most prominent element

#### **Recent Activity Sections**
1. **Sent** (horizontal scroll, max 3 cards visible)
   - Card shows: cover image, receiver name, date, emotion tag
2. **Received** (horizontal scroll, max 3 cards visible)
   - Card shows: cover image, sender name, date, emotion tag, "New" badge if unread
3. **Saved** (horizontal scroll, max 3 cards visible)
   - Card shows: cover image, date, emotion tag

#### **Bottom Navigation Bar**
- Home (active)
- Library
- Create (floating action button style, elevated)
- Notifications (with badge if unread)
- Profile

### Interaction States
- Tap cassette card → Navigate to memory detail screen
- Tap "Create a Cassette" → Navigate to create flow
- Pull to refresh → Reload recent activity

---

## Create Cassette Flow

### Overview
6-step process. Progress indicator at top. Back navigation allowed.

---

### **Step 1: Add YouTube Link**

**Purpose:** Attach the song

**Layout:**
- Header: "What song will you send?"
- Subtext: "Paste a YouTube link below"
- Input field: "https://youtube.com/watch?v=..."
- Example link text: "e.g., https://youtu.be/dQw4w9WgXcQ"

**Validation:**
- Check for valid YouTube URL patterns:
  - `youtube.com/watch?v=`
  - `youtu.be/`
  - `youtube.com/embed/`
- Extract video ID
- Show thumbnail preview below input after validation

**State:**
- Empty state (placeholder)
- Loading state (validating link)
- Success state (thumbnail preview + title if API available)
- Error state ("Invalid YouTube link. Please try again.")

**CTA:**
- "Continue" (disabled until valid link)

**Design Notes:**
- Thumbnail preview: 16:9 ratio, rounded corners
- Song title preview if YouTube API integrated (optional for MVP)

---

### **Step 2: Write Letter**

**Purpose:** Personal message

**Layout:**
- Header: "Write your letter"
- Subtext: "Say what the song means to you"
- Textarea: Multiline, min 3 lines visible, max 500 characters
- Character counter: "235/500"

**Design:**
- Background: Slightly textured paper effect
- Font: Handwritten-style typeface (Patrick Hand or Caveat)
- Placeholder: "Dear [name], this song reminds me of..."

**CTA:**
- "Continue" (disabled if empty)

**Interaction:**
- Auto-focus on textarea
- Keyboard dismisses on tap outside

---

### **Step 3: Upload Optional Photo**

**Purpose:** Add visual memory

**Layout:**
- Header: "Add a photo (optional)"
- Subtext: "A picture to go with your memory"
- Image picker area:
  - Empty state: Dashed border box with camera icon + "Tap to add photo"
  - Filled state: Selected image preview with "Replace" and "Remove" buttons

**CTA:**
- "Continue" (always enabled, photo is optional)
- "Skip" (text link)

**Image Picker:**
- Opens device photo library
- Optional camera capture
- Image preview after selection
- "Replace" → Opens picker again
- "Remove" → Returns to empty state

**Design Notes:**
- Preview: 1:1 ratio, rounded corners
- Max file size: 5MB (client-side check)

---

### **Step 4: Choose Emotion Tag**

**Purpose:** Categorize the mood

**Layout:**
- Header: "What emotion does this carry?"
- Subtext: "Choose one"
- Emotion chips (single-select):
  - ❤️ Love
  - 🕰️ Nostalgia
  - 🤝 Friendship
  - 💭 Missing You
  - 🙏 Apology

**Design:**
- Chips: Rounded, pill-shaped
- Selected state: Filled with accent color
- Unselected state: Outlined, light background

**CTA:**
- "Continue" (disabled until one selected)

---

### **Step 5: Set Password**

**Purpose:** Lock the cassette

**Layout:**
- Header: "Protect this memory"
- Subtext: "Create a password to unlock this cassette"
- Fields:
  - Password (show/hide toggle)
  - Confirm Password (show/hide toggle)
- Optional toggle: "Send anonymously" (hides sender name)

**Validation:**
- Password minimum 4 characters (simple for sharing context)
- Passwords must match
- Show strength indicator if password >8 characters

**CTA:**
- "Continue" (disabled until valid)

**Design Notes:**
- Privacy notice: "Only the person with the password can open this cassette"
- Anonymous mode subtext: "Your name won't appear on the cassette"

---

### **Step 6: Preview and Generate**

**Purpose:** Final review before sending

**Layout:**
- Header: "Preview your cassette"
- Cassette visual preview:
  - Cover image (photo if uploaded, or placeholder design)
  - Emotion tag badge
  - Song thumbnail
  - Letter preview (first 2 lines, truncated)
  - Privacy summary: "Protected with password" + "Anonymous" if toggled

**CTAs:**
- "Edit" (goes back to relevant step)
- "Generate Link" (primary button)

**Loading State:**
- "Creating your cassette..." spinner
- Backend writes to DB, generates unique shareable link

**Success State:**
- Navigate to success screen

---

### **Success Screen**

**Purpose:** Share the cassette

**Layout:**
- Header: "Your cassette is ready! 🎉"
- Shareable link: Display in copyable text box
- Password reminder: "Password: [entered password]"
- CTAs:
  - "Copy Link" (copies to clipboard + shows "Copied!" toast)
  - "Share" (opens native share sheet)
  - "Create Another" (navigates back to Step 1)
  - "Go to Library" (navigates to library screen)

**Design:**
- Celebration micro-animation on load
- Link box: Rounded, tap to copy

---

## Receiver Unlock Flow

### Overview
Receiver receives link outside the app (SMS, WhatsApp, etc.). Opens link → lands on unlock screen.

---

### **Screen 1: Password Unlock**

**Purpose:** Protect the memory, build anticipation

**Layout:**
- Locked cassette visual (illustrated, 3D-ish cassette with lock icon)
- Header: "You've received a memory"
- Subtext: "Enter the password to unlock"
- Password input field (centered, show/hide toggle)
- CTA: "Unlock" button

**States:**
- **Idle:** Awaiting input
- **Loading:** "Unlocking..." spinner in button
- **Invalid Password:** Red border + message "Incorrect password. Try again."
- **Too Many Attempts:** "Too many attempts. Try again in 5 minutes." (rate limiting)
- **Success:** Navigate to cassette experience screen with animation

**Design:**
- Cassette visual: Subtle pulse animation
- Background: Dark gradient for focus

**Security:**
- Rate limiting: 5 attempts per 5 minutes
- No "forgot password" for cassettes (password is shared context)

---

### **Screen 2: Cassette Experience (Unlock Animation → Reveal)**

**Purpose:** Cinematic unveiling of the memory

**Animation Sequence (2-3 seconds):**
1. Unlock sound effect (optional, soft click)
2. Cassette lock opens
3. Cassette case opens (lid lifts)
4. Letter and photo reveal with fade-in
5. Background transitions to warm paper tone

**Post-Animation Layout:**
- **Top Section:**
  - Cassette cover image (photo if uploaded)
  - Rotating tape reels animation (while song plays)
  - Song title + thumbnail (if available via YouTube API)

- **Middle Section:**
  - Handwritten-style letter text (full text, scrollable if long)
  - Photo (if uploaded, expandable on tap)

- **Bottom Section:**
  - YouTube player embed (or "Open in YouTube" button for MVP)
  - Playback controls (play/pause)

- **Action Buttons (Fixed Bottom):**
  - "Save to Library" (requires login if not logged in)
  - "Reply with a Song"
  - "Replay Experience" (restarts animation)

**Interaction:**
- **Save to Library:**
  - If logged in → Saves to library, shows "Saved!" toast
  - If not logged in → Shows modal: "Log in to save this memory" with "Log In" / "Sign Up" CTAs

- **Reply with a Song:** Navigates to reply flow

- **Replay Experience:** Restarts unlock animation from beginning

**Design Notes:**
- Background: Warm paper texture
- Letter text: Handwritten font
- Cassette visual: Rotating reels while song plays (CSS animation or Lottie)
- Photo: Tap to expand fullscreen with pinch-to-zoom

---

## Memory Library

### Purpose
Archive and revisit sent, received, and saved cassettes.

---

### **Layout Structure**

#### **Top Section**
- Search bar: "Search memories..."
- Segmented tabs:
  - **Sent**
  - **Inbox**
  - **Saved**

#### **Filter & Sort Bar**
- Filter by emotion tag: Chips (multi-select, "All" / "Love" / "Nostalgia" / etc.)
- Sort dropdown: "Newest" / "Oldest"

#### **Cassette Card Grid**
- Grid layout: 2 columns on mobile, 3-4 on tablet
- Card design:
  - Cover image (photo or placeholder)
  - Short letter preview (first 30 characters, ellipsis)
  - Sender/receiver label ("From: Alex" or "To: Maya")
  - Date
  - Emotion tag badge
  - Reply count badge (if conversation thread exists)
  - Song attached indicator (small music note icon)

**Interaction:**
- Tap card → Navigate to memory detail screen

---

### **Empty States**

#### **Sent Empty:**
- Illustration: Empty cassette shelf
- Headline: "You haven't sent any cassettes yet"
- Subtext: "Share a musical memory with someone special"
- CTA: "Create Your First Cassette"

#### **Inbox Empty:**
- Illustration: Empty mailbox
- Headline: "No cassettes received yet"
- Subtext: "When someone sends you a memory, it'll appear here"

#### **Saved Empty:**
- Illustration: Empty archive
- Headline: "No saved memories yet"
- Subtext: "Cassettes you save will appear here"

#### **No Results (Search/Filter):**
- Headline: "No memories found"
- Subtext: "Try adjusting your filters"
- CTA: "Clear Filters"

---

### **Memory Detail Screen**

**Purpose:** View full cassette with conversation thread

**Layout:**
- **Top Section:**
  - Back button
  - Overflow menu (3-dot): Delete (if sender owns), Report (if receiver)

- **Cassette Visual:**
  - Cover image
  - Rotating reels if playing
  - Song thumbnail

- **Content Section:**
  - Full letter text
  - Photo (if available, expandable)
  - Emotion tag badge
  - Sender/receiver info: "From Alex, Jan 15, 2026"

- **YouTube Player Area:**
  - Embedded player or "Open in YouTube" button

- **Conversation Thread (if replies exist):**
  - Chronological list of replies
  - Each reply shows: sender, date, song, letter preview
  - Tap reply → Expands to show full letter + photo

- **Action Buttons (Fixed Bottom):**
  - "Save" / "Unsave" toggle (icon changes)
  - "Reply with a Song"
  - "Replay Experience"
  - "Delete" (only for sender-owned memories, shows confirmation modal)

**States:**
- Loading (skeleton screens)
- Error (retry button)

---

## Reply Flow

### Purpose
Faster, lighter version of create flow. Respond to received cassette with a song.

---

### **Layout Structure**

#### **Top Section: Original Cassette Summary**
- Small card showing:
  - Original cassette cover
  - Original sender name
  - "Replying to [Name]'s cassette"

---

#### **Step 1: Paste YouTube Link**
- Header: "Send them a song back"
- YouTube link input (same validation as create flow)
- Thumbnail preview after validation
- CTA: "Continue"

---

#### **Step 2: Write Reply Message**
- Header: "Write your reply"
- Textarea (same design as create flow letter, but smaller max: 300 characters)
- CTA: "Continue"

---

#### **Step 3: Add Optional Image**
- Same as create flow Step 3
- CTA: "Continue" / "Skip"

---

#### **Step 4: Preview Reply**
- Shows:
  - Original cassette summary
  - Your reply song thumbnail
  - Your reply letter preview
  - Your photo (if uploaded)
- CTAs:
  - "Edit"
  - "Send Reply"

**Loading State:**
- "Sending your reply..."

**Success Screen:**
- Header: "Reply sent! 🎵"
- Subtext: "They'll receive your musical reply"
- CTAs:
  - "View Conversation" (navigates to memory detail screen with thread)
  - "Go to Library"

---

## Notifications

### Purpose
Alert users to new cassettes, replies, and saves.

---

### **Layout Structure**

#### **Header:**
- "Notifications"
- Mark all as read button (text link)

#### **Notification Card Types:**

1. **New Cassette Received**
   - Icon: Cassette emoji 📼
   - Text: "[Name] sent you a cassette"
   - Subtext: "2 hours ago"
   - Read/unread indicator (blue dot for unread)

2. **Reply Received**
   - Icon: Music note emoji 🎵
   - Text: "[Name] replied to your cassette"
   - Subtext: "Yesterday"

3. **Cassette Saved**
   - Icon: Heart emoji ❤️
   - Text: "[Name] saved your cassette"
   - Subtext: "3 days ago"

**Interaction:**
- Tap notification → Navigate to relevant cassette detail screen
- Swipe to dismiss (optional)

---

### **Empty State**
- Illustration: Quiet notifications bell
- Headline: "All caught up!"
- Subtext: "No new notifications"

---

### **Badge Count**
- Bottom nav notification icon shows badge count for unread

---

## Profile & Settings

### **Profile Screen**

**Purpose:** User identity and stats

**Layout:**

#### **Top Section:**
- Profile photo (circular, tap to change)
- Name (editable on tap)
- Email (read-only)
- Bio (optional, editable on tap)

#### **Stats Section:**
- "Cassettes Sent: 12"
- "Replies Received: 8"
- "Saved Memories: 5"

#### **Action Buttons:**
- "Edit Profile" (navigates to edit screen)
- "Settings" (navigates to settings screen)

---

### **Settings Screen**

**Purpose:** App preferences and account management

**Layout:**

#### **Account Settings**
- "Change Password" → Navigates to change password flow
- "Email Notifications" → Toggle
- "Push Notifications" → Toggle

#### **Privacy Settings**
- "Anonymous Mode by Default" → Toggle (sets default for cassette creation)
- "Who can send me cassettes?" → Options: Everyone / Only people I follow / No one

#### **App Preferences**
- "Theme" → Light / Dark (optional for MVP)
- "Haptic Feedback" → Toggle

#### **Support**
- "Help & FAQ" → External link or in-app webview
- "Contact Support" → Email link
- "Privacy Policy" → External link
- "Terms of Service" → External link

#### **Danger Zone**
- "Log Out" → Confirmation modal → Clears session → Returns to welcome screen
- "Delete Account" → Confirmation modal with password re-entry → Permanently deletes account

---

## States & Feedback

### **Loading States**

1. **Inline Spinners:** For button actions (login, create, send)
2. **Skeleton Screens:** For content loading (library, memory detail)
3. **Full-screen Loader:** For critical flows (cassette generation, unlock animation)

**Design:**
- Spinner: Circular, warm color (amber)
- Skeleton: Subtle shimmer animation, paper tone background

---

### **Error States**

1. **Inline Field Error:** Red border + error message below field
2. **Toast Error:** Sticky toast at bottom with error message + dismiss button
3. **Full-screen Error:** For critical failures (network error, API down)
   - Illustration: Broken cassette tape
   - Headline: "Something went wrong"
   - Subtext: Error message (user-friendly)
   - CTA: "Try Again"

**Error Message Tone:**
- Friendly, apologetic, non-technical
- Example: "We couldn't send your cassette. Please check your connection and try again."

---

### **Success States**

1. **Toast Success:** Green toast with checkmark icon + message ("Cassette sent!", "Saved!")
2. **Success Screen:** Full-screen confirmation with celebration animation (confetti, checkmark)

---

### **Empty States**

Covered in each feature section. General principles:
- Friendly illustration
- Encouraging headline
- Actionable CTA

---

## Motion & Micro-interactions

### **Cassette Unlock Animation**
- Duration: 2-3 seconds
- Sequence:
  1. Lock icon shakes and unlocks (0.5s)
  2. Cassette case lid lifts open (1s, easing: ease-out)
  3. Letter and photo fade in with slight upward drift (1s)
  4. Background color transitions to paper tone (0.5s, overlapping)

**Implementation:** Lottie animation or Flutter implicit animations

---

### **Tape Reel Rotation**
- Continuous rotation while song plays
- Speed syncs with playback (optional, or fixed slow rotation)
- Stops when paused

**Implementation:** CSS `@keyframes` or Flutter `AnimationController`

---

### **Button Press Feedback**
- Haptic feedback on tap (if enabled in settings)
- Subtle scale down animation (0.95x) on press
- Spring back on release

---

### **Card Tap Animation**
- Scale up slightly on press (1.02x)
- Subtle shadow expansion

---

### **Pull to Refresh**
- Custom loader: Cassette icon rotates while pulling
- Release triggers refresh

---

### **Transition Animations**
- Screen transitions: Slide from right (iOS-style) or fade (Android Material)
- Modal pop-ups: Slide up from bottom with backdrop fade-in

---

### **Success Confetti**
- After cassette generation or reply sent
- Brief confetti burst (1-2 seconds)
- Warm color palette (amber, brown, cream)

**Implementation:** Flutter `confetti` package or Lottie

---

## Accessibility

### **Screen Reader Support**
- All interactive elements have semantic labels
- Images have alt text (e.g., "Cassette cover image showing sunset photo")
- Buttons have descriptive labels (e.g., "Unlock cassette", not just "Unlock")

### **Keyboard Navigation (if web or desktop)**
- Tab order follows visual hierarchy
- Focus indicators visible on all interactive elements

### **Color Contrast**
- Text on background meets WCAG AA minimum (4.5:1 for body text, 3:1 for large text)
- Deep brown (#3E2723) on paper tone (#F5EFE6) passes

### **Touch Targets**
- Minimum 44x44 points (iOS) / 48x48 dp (Android)
- Adequate spacing between tappable elements

### **Font Scaling**
- Respects system font size settings
- Test at 200% scale to ensure readability

### **Animations**
- Respect "reduce motion" system setting
- Provide option to disable animations in settings

### **Form Validation**
- Clear error messages
- Announce errors to screen readers
- Error states distinguishable without color alone (icons + text)

---

## Mobile-First Layout Rules

### **Breakpoints**
- **Small phone:** 320px - 360px (e.g., iPhone SE)
- **Standard phone:** 375px - 414px (e.g., iPhone 12, Pixel 5)
- **Large phone:** 428px+ (e.g., iPhone 14 Pro Max)
- **Tablet:** 768px+ (optional, future consideration)

### **Grid System**
- **Padding:** 16px horizontal margin on phone
- **Card spacing:** 12px between cards
- **Column grid:** 2 columns for library cards, 1 column for detail views

### **Typography Scaling**
- **Heading 1:** 28pt on small, 32pt on large
- **Heading 2:** 20pt on small, 24pt on large
- **Body:** 16pt (fixed, readable)
- **Caption:** 14pt

### **Component Sizing**
- **Buttons:** Height 48dp, full-width primary buttons on mobile
- **Input fields:** Height 48dp, full-width
- **Cards:** Full-width minus horizontal padding, height auto based on content

### **Bottom Navigation**
- Fixed at bottom, 56dp height
- Icons centered, labels optional (icon-only recommended for mobile)

### **One-Handed Usability**
- Critical actions (Create, Unlock) reachable in bottom third of screen
- Top navigation limited to back button and page title

---

## Design System

### **Color Palette**

#### **Primary Colors**
- **Paper Tone (Background):** `#F5EFE6` — Warm off-white, nostalgic paper
- **Deep Brown (Text):** `#3E2723` — Primary text color, high contrast
- **Amber Accent:** `#FF6F00` — Emotional highlight, CTAs, active states

#### **Secondary Colors**
- **Light Brown:** `#8D6E63` — Secondary text, inactive states
- **Cream:** `#FFF8E1` — Card backgrounds, input fields
- **Soft Shadow:** `rgba(62, 39, 35, 0.1)` — Retro shadow effect

#### **Emotion Tag Colors**
- **Love:** `#E91E63` (Pink)
- **Nostalgia:** `#795548` (Brown)
- **Friendship:** `#4CAF50` (Green)
- **Missing You:** `#9C27B0` (Purple)
- **Apology:** `#2196F3` (Blue)

#### **Semantic Colors**
- **Success:** `#66BB6A` (Green)
- **Error:** `#EF5350` (Red)
- **Warning:** `#FFA726` (Orange)
- **Info:** `#42A5F5` (Blue)

---

### **Typography**

#### **Font Families**
1. **Serif Headings:** Merriweather (Google Fonts)
   - Weights: Regular (400), Bold (700)
   - Usage: H1, H2, H3
2. **Body Text:** Inter (Google Fonts) or SF Pro (iOS native)
   - Weights: Regular (400), Medium (500), Semi-bold (600)
   - Usage: Body, captions, buttons
3. **Handwritten Accent:** Patrick Hand or Caveat (Google Fonts)
   - Weight: Regular (400)
   - Usage: Letters, personal message areas

#### **Type Scale**
- **H1:** 32pt, Merriweather Bold, Line height 1.2
- **H2:** 24pt, Merriweather Bold, Line height 1.3
- **H3:** 20pt, Merriweather Regular, Line height 1.4
- **Body Large:** 18pt, Inter Regular, Line height 1.5
- **Body:** 16pt, Inter Regular, Line height 1.6
- **Body Small:** 14pt, Inter Regular, Line height 1.5
- **Caption:** 12pt, Inter Medium, Line height 1.4
- **Handwritten:** 18pt, Patrick Hand Regular, Line height 1.6

---

### **Spacing System**
**Base unit:** 4px

- **4px** — Tight spacing (icon + text)
- **8px** — Small spacing (form field padding)
- **12px** — Medium spacing (card internal padding)
- **16px** — Standard spacing (screen horizontal padding)
- **24px** — Large spacing (section separation)
- **32px** — XL spacing (major section breaks)
- **48px** — XXL spacing (hero sections)

---

### **Shadows**
**Retro soft shadows** (not harsh Material Design shadows)

- **Card Shadow:**
  - `box-shadow: 0 4px 12px rgba(62, 39, 35, 0.08)`
- **Button Hover Shadow:**
  - `box-shadow: 0 6px 16px rgba(62, 39, 35, 0.12)`
- **Modal Shadow:**
  - `box-shadow: 0 8px 24px rgba(62, 39, 35, 0.15)`

---

### **Border Radius**
- **Small (chips, tags):** 16px
- **Medium (buttons, inputs):** 12px
- **Large (cards):** 20px
- **Circular (profile photos):** 50%

---

### **Component Styles**

#### **Buttons**

##### **Primary Button**
- Background: `#FF6F00` (Amber)
- Text: `#FFFFFF` (White)
- Height: 48dp
- Border radius: 12px
- Font: Inter Semi-bold, 16pt
- Hover: Darken 10%, add shadow
- Disabled: Opacity 0.4

##### **Secondary Button**
- Background: Transparent
- Text: `#FF6F00` (Amber)
- Border: 2px solid `#FF6F00`
- Height: 48dp
- Border radius: 12px
- Font: Inter Semi-bold, 16pt
- Hover: Light amber background `#FFF3E0`
- Disabled: Opacity 0.4

##### **Text Button**
- Background: Transparent
- Text: `#8D6E63` (Light Brown)
- No border
- Font: Inter Medium, 16pt
- Hover: Underline
- Disabled: Opacity 0.4

---

#### **Text Fields**

##### **Default State**
- Background: `#FFF8E1` (Cream)
- Border: 1px solid `#D7CCC8` (Light gray-brown)
- Border radius: 12px
- Padding: 12px 16px
- Font: Inter Regular, 16pt
- Placeholder text: `#8D6E63` (Light brown), opacity 0.6

##### **Focus State**
- Border: 2px solid `#FF6F00` (Amber)
- Background: `#FFFFFF`

##### **Error State**
- Border: 2px solid `#EF5350` (Red)
- Background: `#FFEBEE` (Light red tint)
- Error text below: 14pt, `#EF5350`

##### **Disabled State**
- Background: `#EFEBE9` (Gray)
- Opacity: 0.6

---

#### **Cards**

##### **Cassette Card (Library Grid)**
- Background: `#FFFFFF`
- Border radius: 20px
- Shadow: `0 4px 12px rgba(62, 39, 35, 0.08)`
- Padding: 12px
- Layout:
  - Cover image: Full-width, 16:9 ratio, rounded corners (16px)
  - Letter preview: 14pt, `#3E2723`, 2 lines max, ellipsis
  - Metadata row: Sender/date, 12pt, `#8D6E63`
  - Emotion tag badge: Bottom right, absolute position

##### **Memory Detail Card**
- Background: `#FFF8E1` (Cream)
- Border radius: 20px
- Shadow: `0 6px 16px rgba(62, 39, 35, 0.1)`
- Padding: 24px
- Letter text: Handwritten font, 18pt

---

#### **Emotion Tag Chips**
- Height: 32dp
- Border radius: 16px
- Padding: 8px 16px
- Font: Inter Medium, 14pt
- Selected: Background = emotion color, text = white
- Unselected: Background = `#F5F5F5`, text = emotion color, border 1px solid emotion color

---

#### **Cassette Visual Component**
**3D-ish cassette illustration** (can use SVG or Lottie)

Elements:
- Cassette body: Rectangular with rounded corners
- Label area: Centered, shows cover photo or placeholder
- Tape reels: Two circles, rotating animation
- Lock icon: Centered, appears on locked cassettes

**Color scheme:**
- Body: `#3E2723` (Deep brown) or gradient
- Label: White or cream background for photo
- Reels: Dark brown with lighter inner circle

---

#### **Letter Component**
- Background: Paper texture or subtle noise pattern
- Font: Patrick Hand or Caveat, 18pt
- Text color: `#3E2723`
- Padding: 24px
- Decorative elements: Optional faint horizontal lines (notebook paper style)

---

#### **Toast / Snackbar**
- Background: `#3E2723` (Deep brown)
- Text: `#FFFFFF` (White), Inter Medium, 14pt
- Border radius: 12px
- Padding: 12px 16px
- Position: Bottom, 16px from screen edge
- Duration: 3 seconds
- Dismiss: Swipe or auto-dismiss

---

#### **Loading State**
- **Spinner:** Circular, `#FF6F00` (Amber), 24px diameter
- **Skeleton Card:**
  - Background: `#EFEBE9` (Light gray)
  - Shimmer animation: Gradient sweep from left to right
  - Duration: 1.5s loop

---

#### **Empty State**
- Illustration: Centered, 120px height, muted brown tones
- Headline: 20pt, Merriweather Regular, `#3E2723`
- Subtext: 14pt, Inter Regular, `#8D6E63`
- CTA button: Primary button style
- Vertical spacing: 24px between elements

---

## Web Landing Page (Optional)

### Purpose
Marketing page to drive app downloads. Not the main product experience.

---

### **Structure**

#### **Section 1: Hero**
- Headline: "Send songs like handwritten letters"
- Subheadline: "Share musical moments, wrapped in emotion"
- CTA: "Download on App Store" / "Get it on Google Play"
- Hero visual: Animated cassette illustration or phone mockup showing app

#### **Section 2: How It Works**
- 3-step illustration:
  1. "Paste a YouTube link"
  2. "Write a personal letter"
  3. "Share with a password"
- Brief explanatory text below each step

#### **Section 3: Features**
- Feature cards:
  1. "Nostalgic Design" — Cassette-inspired interface
  2. "Private & Secure" — Password-protected memories
  3. "Emotional Tags" — Categorize your feelings
- Icon + headline + description for each

#### **Section 4: Testimonial / Use Cases**
- User quotes:
  - "I sent my best friend a cassette on her birthday. She cried." — Maya
  - "This is how I apologized to my partner. It felt real." — Alex

#### **Section 5: Download CTA**
- Repeat: "Download on App Store" / "Get it on Google Play"
- Optional: Email signup for launch announcement

#### **Footer**
- Links: Privacy Policy, Terms of Service, Contact
- Social media icons (optional)

---

### **Design Notes**
- Responsive: Mobile-first, scales to desktop (max-width: 1200px)
- Color palette: Same as app (paper tone, deep brown, amber)
- Typography: Same fonts (Merriweather, Inter)
- Animations: Subtle scroll-triggered fade-ins, cassette rotation

---

## Technical Integration Notes

### **Flutter Architecture**
- **State Management:** Riverpod 2.x
- **Routing:** go_router (deep linking for cassette share URLs)
- **HTTP:** dio with interceptors for auth tokens
- **Serialization:** json_serializable + freezed
- **Storage:** shared_preferences (settings), flutter_secure_storage (auth tokens)

### **API Endpoints (FastAPI Backend)**

#### **Auth**
- `POST /auth/signup` — Create account
- `POST /auth/login` — Login
- `POST /auth/forgot-password` — Send reset email
- `POST /auth/reset-password` — Reset password with token
- `GET /auth/me` — Get current user

#### **Cassettes**
- `POST /cassettes` — Create cassette (returns shareable link)
- `GET /cassettes/{id}` — Get cassette detail (requires password verification)
- `POST /cassettes/{id}/unlock` — Verify password and unlock
- `POST /cassettes/{id}/save` — Save to library
- `DELETE /cassettes/{id}` — Delete cassette (sender only)

#### **Library**
- `GET /library/sent` — Get sent cassettes
- `GET /library/inbox` — Get received cassettes
- `GET /library/saved` — Get saved cassettes
- `GET /library/search?q={query}` — Search library

#### **Replies**
- `POST /cassettes/{id}/replies` — Send reply
- `GET /cassettes/{id}/replies` — Get conversation thread

#### **Notifications**
- `GET /notifications` — Get notifications
- `POST /notifications/{id}/read` — Mark as read
- `POST /notifications/read-all` — Mark all as read

#### **Profile**
- `GET /profile/{user_id}` — Get user profile
- `PUT /profile` — Update profile (name, bio, photo)
- `PUT /profile/password` — Change password

---

### **Database Schema (PostgreSQL)**

#### **users**
- `id` (UUID, primary key)
- `name` (VARCHAR)
- `email` (VARCHAR, unique)
- `password_hash` (VARCHAR)
- `profile_photo_url` (VARCHAR, nullable)
- `bio` (TEXT, nullable)
- `created_at` (TIMESTAMP)

#### **cassettes**
- `id` (UUID, primary key)
- `sender_id` (UUID, foreign key → users.id, nullable if anonymous)
- `youtube_link` (VARCHAR)
- `letter_text` (TEXT)
- `photo_url` (VARCHAR, nullable)
- `emotion_tag` (ENUM: Love, Nostalgia, Friendship, Missing You, Apology)
- `password_hash` (VARCHAR)
- `is_anonymous` (BOOLEAN)
- `shareable_link` (VARCHAR, unique)
- `created_at` (TIMESTAMP)

#### **replies**
- `id` (UUID, primary key)
- `cassette_id` (UUID, foreign key → cassettes.id)
- `sender_id` (UUID, foreign key → users.id)
- `youtube_link` (VARCHAR)
- `reply_text` (TEXT)
- `photo_url` (VARCHAR, nullable)
- `created_at` (TIMESTAMP)

#### **library_saves**
- `id` (UUID, primary key)
- `user_id` (UUID, foreign key → users.id)
- `cassette_id` (UUID, foreign key → cassettes.id)
- `saved_at` (TIMESTAMP)

#### **notifications**
- `id` (UUID, primary key)
- `user_id` (UUID, foreign key → users.id)
- `type` (ENUM: cassette_received, reply_received, cassette_saved)
- `cassette_id` (UUID, foreign key → cassettes.id)
- `is_read` (BOOLEAN, default false)
- `created_at` (TIMESTAMP)

---

### **Deep Linking**
- Shareable cassette link format: `https://digitalcassette.app/c/{cassette_id}`
- App intercepts link and navigates to unlock screen
- Uses go_router's path parameters: `/c/:cassetteId`

---

### **Image Upload**
- **Client:** image_picker plugin, max 5MB, JPEG compression
- **Backend:** Upload to cloud storage (AWS S3, Cloudflare R2, or similar)
- **API:** `POST /upload/image` → Returns `photo_url`

---

### **YouTube Integration**
- **Client validation:** Regex check for YouTube URL patterns
- **Video ID extraction:** Parse URL to extract video ID
- **Thumbnail:** Construct URL: `https://img.youtube.com/vi/{video_id}/maxresdefault.jpg`
- **Player:** Use `youtube_player_flutter` package or webview embed

---

### **Security Considerations**
- **Password hashing:** bcrypt on backend
- **JWT tokens:** For authenticated API requests
- **Rate limiting:** 5 unlock attempts per cassette per 5 minutes
- **HTTPS only:** All API requests over HTTPS
- **Secure storage:** Auth tokens in flutter_secure_storage

---

## Summary

This UX design document provides a comprehensive blueprint for building Digital Cassette, a mobile-first Flutter app with a warm, nostalgic cassette-inspired design. The product focuses on emotional, password-protected musical moments shared via YouTube links and personal letters.

**Key Design Pillars:**
1. **Emotional First:** Every screen feels warm, intimate, and intentional
2. **Simplicity:** One YouTube link, one letter, one photo — no complexity
3. **Cinematic Unlock:** Password-protected cassette reveal is the core magic moment
4. **Mobile-Intimate:** Designed for late-night, phone-in-hand sharing
5. **Privacy by Design:** Password-protected, anonymous mode, secure by default

**Next Steps:**
1. **Design Mockups:** High-fidelity Figma designs based on this document
2. **Prototype:** Interactive prototype for user testing
3. **Flutter Implementation:** Build feature by feature with Riverpod + go_router
4. **FastAPI Backend:** Build REST API with PostgreSQL database
5. **User Testing:** Gather feedback on unlock experience, create flow, and emotional tone
6. **Iterate:** Refine based on user behavior and feedback

**Long-term Vision:**
- Add Spotify support (after MVP)
- Voice message option (emotional audio note)
- Collaborative cassettes (multiple senders)
- Physical cassette merch (QR code links to digital cassette)

---

**Document End**
