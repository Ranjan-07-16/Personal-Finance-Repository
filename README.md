# Flutter Personal Finance App

A personal finance tracker built with Flutter, SQLite, SharedPreferences, and Riverpod. Tracks daily income and expenses with category breakdowns and a live pie-chart dashboard.

---

## Current Implementation Status

> Last updated after: Clean Architecture restructuring of the Expenses feature.

### What's built and working

| Screen | Route | Status | Notes |
|---|---|---|---|
| Auth (login / sign-up) | `/` | ✅ Working | Real SQLite auth; email + password validation; duplicate-signup check; inline error messages |
| Dashboard | `/dashboard` | ✅ Working | Riverpod `ConsumerWidget`; live expense + income pie charts; session-restored username |
| My Expenses | `/expenses_detail` | ✅ Working | Add / clear-all; Riverpod + repository pattern; charts update on mutation |
| My Income | `/income_detail` | ✅ Working | Add / clear-all; Riverpod providers; charts update on mutation |
| My Profile | `/profile` | ✅ Working | Edit username; session-persisted; logout clears SharedPreferences session |
| Help & Support | `/help` | ✅ Working | FAQ (10 expandable items), Help Centre (contact info + clipboard copy), Feedback form |
| About | `/about` | ⚠️ Stale | Static content; still says "DartPad Edition" — needs updating |
| Account Centre | `/account_center` | ⚠️ Partial | Displays user info via `UserData` statics, not reactive to `userProvider` |
| Account Status | `/account_status` | ⚠️ Partial | Static "Active" display; reads `UserData` statics directly |
| Add Account | `/add_account` | ⚠️ Simulated | UI-only dialog; no real multi-account support |

### Navigation flow (actual)

```
App launch
  └─ SharedPreferences session check
       ├─ session found  → /dashboard
       └─ no session     → / (AuthScreen)

/ (AuthScreen) → login or sign up → /dashboard

/dashboard
  ├─ tap "My Expenses"  → /expenses_detail
  ├─ tap "My Income"    → /income_detail
  └─ tap avatar         → /profile
       ├─ Account Centre → /account_center
       ├─ Help           → /help → FaqScreen (push, no named route)
       ├─ Account Status → /account_status
       ├─ About          → /about
       ├─ Add Account    → /add_account
       └─ Logout         → / (clears session, removes all routes)
```

### Planned vs. Current

| Feature | Planned | Current |
|---|---|---|
| State management | Riverpod everywhere | ✅ Riverpod for expenses, income, auth/user · ⚠️ `AccountCenterScreen` / `AccountStatusScreen` still read `UserData` statics |
| Storage — expenses | SQLite | ✅ SQLite via `SqliteExpenseRepository` |
| Storage — income | SQLite | ✅ SQLite via `DatabaseHelper` (repository migration pending) |
| Storage — auth | SQLite | ✅ SQLite via `DatabaseHelper` |
| Session persistence | SharedPreferences | ✅ `SessionService` wrapping SharedPreferences |
| Auth | Real credential check | ✅ Email + password validated against SQLite `users` table |
| Expenses — architecture | Clean Architecture (domain / data / presentation) | ✅ Fully migrated to `features/expenses/` |
| Income — architecture | Clean Architecture | ⏳ Riverpod only; `features/income/` migration pending |
| Auth — architecture | Clean Architecture | ⏳ Riverpod only; `features/auth/` migration pending |
| Dashboard — architecture | Feature module | ⏳ Still in `lib/screens/`; depends on both expense + income providers |
| Help screen | Navigation only | ✅ Expandable FAQ, Help Centre sheet, Feedback form |
| Budget / savings goals | Planned | ❌ Not started |
| Per-item delete | Planned | ❌ Clear-all only |
| Search / date filtering | Planned | ❌ Not started |
| Unit / widget tests | Planned | ❌ None yet |
| Multi-device sync / cloud | Future | ❌ Not started |

### Current folder structure

```
lib/
├── db/
│   └── db_helper.dart              # DB init, schema migrations (v3), income + auth CRUD
├── features/
│   └── expenses/                   # ✅ Fully Clean Architecture
│       ├── domain/
│       │   ├── expense.dart            # Pure entity
│       │   ├── expense_categories.dart # Category → Color constants
│       │   └── expense_repository.dart # Abstract interface
│       ├── data/
│       │   └── sqlite_expense_repository.dart  # SQLite implementation
│       └── presentation/
│           ├── providers/
│           │   └── expense_providers.dart  # expenseRepositoryProvider, expensesProvider, totals
│           ├── screens/
│           │   └── expenses_screen.dart
│           └── widgets/
│               └── expense_block.dart
├── models/
│   ├── financial_data.dart         # Income-source → Color constants (expense constants moved to feature)
│   ├── income.dart                 # Income entity (CA migration pending)
│   └── user_data.dart              # Static user fields (legacy; being phased out by userProvider)
├── providers/
│   ├── auth_providers.dart         # UserState, UserNotifier, userProvider
│   └── financial_providers.dart    # Income providers (expense providers moved to feature)
├── screens/
│   ├── about_screen.dart
│   ├── account_center_screen.dart
│   ├── account_status_screen.dart
│   ├── add_account_screen.dart
│   ├── auth_screen.dart            # ConsumerStatefulWidget; real SQLite auth
│   ├── dashboard_screen.dart       # ConsumerWidget; watches expense + income providers
│   ├── faq_screen.dart             # 10 expandable FAQ items
│   ├── help_screen.dart            # HelpCard list; FAQ nav, Help Centre sheet, Feedback form
│   ├── income_screen.dart          # ConsumerStatefulWidget; Riverpod (not CA yet)
│   └── profile_screen.dart         # ConsumerStatefulWidget; userProvider
├── services/
│   └── session_service.dart        # SharedPreferences session wrapper
├── widgets/
│   ├── chart_tile.dart
│   ├── dashboard_tile.dart
│   ├── help_card.dart
│   ├── income_block.dart           # Not yet moved to features/income/
│   └── simple_pie_chart.dart       # Custom pie chart (CustomPainter)
└── main.dart                       # ProviderScope, session restore, named routes
```

---

## Build & Setup

### Prerequisites

| Tool | Required version |
|---|---|
| Flutter SDK | 3.24.0+ |
| Dart SDK | 3.5.0+ (bundled with Flutter) |
| Android SDK | API 21+ (for Android target) |

### Install dependencies

```bash
flutter pub get
```

### Run

```bash
# Android (emulator or device)
flutter run

# Linux desktop
flutter run -d linux

# Web (not actively tested)
flutter run -d chrome
```

### Build release

```bash
# Android APK
flutter build apk --release

# Linux
flutter build linux --release
```

**iOS / macOS** require a macOS machine with Xcode installed. Runner targets exist in the project but have not been tested against a Mac environment.

### pubspec.yaml dependencies

```yaml
dependencies:
  flutter:           sdk: flutter
  sqflite:           ^2.3.3    # Local SQLite database
  path:              ^1.9.0    # DB path resolution
  flutter_riverpod:  ^2.5.1    # State management
  shared_preferences: ^2.3.2   # Session persistence
  cupertino_icons:   ^1.0.8
```

### SQLite schema (current version: 3)

| Table | Columns |
|---|---|
| `users` | `id`, `email UNIQUE`, `password`, `username DEFAULT ''` |
| `expenses` | `id`, `amount REAL`, `category TEXT`, `reason TEXT`, `colorValue INTEGER`, `dateMs INTEGER` |
| `income` | `id`, `amount REAL`, `source TEXT`, `reason TEXT`, `colorValue INTEGER`, `dateMs INTEGER` |

---

## Known Limitations & TODOs

1. **Income + Auth features** not yet migrated to Clean Architecture — `lib/features/income/` and `lib/features/auth/` directories don't exist yet. Income CRUD still goes through `DatabaseHelper` directly rather than a repository interface.
2. **`AccountCenterScreen` / `AccountStatusScreen`** read `UserData.username` / `UserData.email` static fields instead of watching `userProvider` — they won't react to live profile updates.
3. **`AboutScreen`** still contains "DartPad Edition" copy — needs to reflect the native Flutter app.
4. **`AddAccountScreen`** is a UI-only simulation — tapping "Create Account" shows a SnackBar but doesn't persist anything.
5. **No per-item delete** — expenses and income can only be cleared entirely. Swipe-to-delete per entry is planned.
6. **Dashboard** still lives in `lib/screens/` rather than its own feature module; it should move once both expense and income features are fully in `lib/features/`.
7. **`DatabaseHelper`** still handles income and auth CRUD — these should be extracted to `SqliteIncomeRepository` and `SqliteAuthRepository` when those features are migrated.
8. **No test suite** — no unit, widget, or integration tests exist yet.
9. **No search or date filtering** on the expense or income lists.
10. **Pie charts show empty grey circle** when there are no entries — no illustrated empty state per the design doc's specification.

---

## Planned Design (Original Design Doc)

The sections below document the original design intent. Items marked ✅ in the table above are implemented; the rest remain aspirational.

### 1. Problem Framing

The core problem this project addresses is the lack of awareness and control people have over their daily spending.
Users often struggle to track expenses, understand spending patterns, and meet savings goals.
The app will provide simple daily tracking, category-wise insights, and a clear visual summary.
Core user flow: Onboarding → Add Daily Expense → View Dashboard Insights → Track Savings Goals.

### 2. Architecture Choice

Architecture Selected: **Clean Architecture (Layered)**

Justification:
- Separates UI, business logic, and data clearly.
- Supports scalability as new features like budgeting, AI insights, or bank integration can be added easily.
- Maintains testability with isolated layers.

Data flow: `UI → Provider → Use Cases → Repository → Local DB / API`

### 3. State Management Plan

Chosen State Management: **Riverpod**

Reasons:
- Scalable for medium-to-large applications.
- Eliminates context dependency; easy global access.
- Supports reactive updates ideal for dashboards and financial charts.
- Good performance with fine-grained state providers.

### 4. UI/UX Layout Strategy

Guiding Principles: Simplicity, clarity, minimum clicks.

Navigation Flow:
- Splash → Onboarding → Home Dashboard (Daily Spend, Remaining Budget, Graph) → Add Expense → Categories → Savings Goals → Settings

Wireframe Logic:
- Home screen shows insights at top, expense list below.
- Add expense is a clean single-form flow.
- Graphs use smooth animation and clear icons.

### 5. Service & Data Layer Design

APIs: (Optional Future Integration)
- Currency API
- Bank Sync API (Later Stage)

Local Storage:
- SQLite for storing expenses and income.
- SharedPreferences for session persistence.

Caching Strategy:
- Last 7 days dashboard data cached for performance.

Async Operations:
- Handled via repositories with try/catch boundaries.
- No business logic inside UI widgets.

### 6. Error & Edge Case Handling

Validation:
- Prevent empty inputs.
- Restrict negative amounts.

Network Failure:
- Graceful fallback to cached data.

Loading States:
- Shimmer UI placeholders.

Empty States:
- Illustrated empty screens prompting users to add transactions.

### 7. Scalability & Maintainability

Target Folder Structure (in progress — expenses complete, income + auth pending):

```
lib/
├── core/
├── features/
│   ├── expenses/     ✅ done
│   ├── income/       ⏳ pending
│   ├── auth/         ⏳ pending
│   └── dashboard/    ⏳ pending
```

Modularization:
- Each feature (expenses, goals, dashboard) kept independent.

Future Scalability:
- Can extend to analytics, budgeting automation, notifications, AI recommendations.
- Maintainability ensured through clean layered separation and Riverpod scalability.
