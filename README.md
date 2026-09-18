# OceanSys

A feature-rich **Route-to-Market (RTM) / Distribution Sales Management** mobile and web application built with Flutter. OceanSys empowers field sales representatives, supervisors, and distribution managers to streamline customer visits, manage routes, track location data, handle CRM interactions, and synchronize data — all with robust offline-first support.

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Use Cases](#use-cases)
- [Project Architecture](#project-architecture)
- [Tech Stack & Dependencies](#tech-stack--dependencies)
- [Project Structure](#project-structure)
- [Data Models](#data-models)
- [BLoC / Cubit State Management](#bloc--cubit-state-management)
- [Permission System](#permission-system)
- [Offline-First Support](#offline-first-support)
- [Getting Started](#getting-started)
- [Build Guide](#build-guide)
- [API Integration](#api-integration)
- [Local Database](#local-database)
- [Supported Platforms](#supported-platforms)
- [Roadmap & Upcoming Features](#roadmap--upcoming-features)

---

## Overview

OceanSys is a full-stack field-sales execution platform designed for companies operating distribution networks (often called "Route-to-Market" or "RTM" systems). It provides the end-to-end digital backbone for:

- Assigning daily/weekly customer-visit routes to sales agents.
- Scanning and visiting customers along a route (via list or interactive map).
- Recording visit outcomes, CRM notes, customer complaints, and purchase intent.
- Editing customer profiles on the fly.
- Activating or deactivating customers with audit reasons.
- Tracking each representative's live GPS position and computing real-time distances to each customer.
- Queuing every server write into a local SQLite database when offline, then replaying them in order once connectivity is restored.
- Administering users, roles, and granular feature permissions from within the app.

The application is **Persian-localized** (RTL UI, Jalali-aware routing, Persian fonts `dana`) and ships with a configurable server URL so the same binary can target staging, on-premises, or production backends.

---

## Key Features

### 🔐 Authentication & Session Management

- **Username / Password login** backed by JWT-style bearer tokens.
- **Credential persistence** across restarts via secure local storage (GetStorage).
- **Configurable server address** dialog on the login screen — no hard-coded backend.
- **Auto-redirect** from splash screen, with graceful error / retry states.
- **Animated ocean-themed login screen** with:
  - Physics-driven floating bubbles.
  - Sine-wave bottom animation.
  - **Parallax tilt effect** using the device accelerometer (sensors_plus).

### 🗺️ Route Scanner (Main Workflow)

The heart of OceanSys is a two-tab home experience — accessible via the **"Scan Customer"** menu item.

| Tab | Description |
|-----|-------------|
| **Customer List** | Pull-to-refresh list of every customer on today's route. Each card shows store sign, customer name, address, distance from agent (real-time), and a color-coded visit-status stripe. Tapping a card opens the customer detail screen. |
| **Interactive Map** | OpenStreetMap-style map (Google raster tiles via `flutter_map`) showing every customer location + the agent's live GPS position. Customer pins are color-coded by visit status and labeled with the store sign. Clicking a pin navigates to the customer detail page. |

Three distinct visit statuses are used throughout the app:

| Status | Color | Meaning |
|--------|-------|---------|
| Visited | 🟢 Green `#10B981` | Agent has completed the visit and sent `task_complete`. |
| In Progress / Data Pending | 🟠 Amber `#F59E0B` | Visit started but data has not yet reached the server (queued offline or submitting). |
| Not Visited | 🔴 Red `#EF4444` | No action taken yet. |

### 🛒 Customer Detail Page

For each selected customer the app presents:

1. **Customer header card** — store board sign, owner name, avatar.
2. **Complete customer info widget** — national ID, role code, postal code, address, mobile(s), phone, store area, GPS coordinates.
3. **2×2 action grid** with four business flows:
   - **Activate / Deactivate Customer** — dialog with reason + free-text description; posts to `disActiveCustomer`.
   - **Edit Customer Info** — navigates to a full edit form (national code, role, postal code, board, owner, address, mobiles, phone, store area).
   - **CRM Complaint / Description** — multi-checkbox form (Was the customer present? Was the owner in the shop? Are they cooperative?) plus a textarea for visit notes.
   - **Product Category Purchase Intent** — multi-select SKU/category checklist that records "what the customer buys" for merchandising intelligence.

### 🧭 Route Management

Available from the **"Route Manager"** menu item. Two tabs:

1. **Add Route** — Assign a list of customers (customer codes) to a specific user, with a Jalali/Persian-calendar date picker for visit-day scheduling and a user-search dialog.
2. **Delete Route** — Remove existing route assignments.

All data is pushed to the backend REST endpoints `set_rout` / `del_rout`.

### 👥 User Management

Restricted to users holding `USER_MANAGE` permission. Two tabs:

- **Add User** — Create new system accounts (first name, last name, username, password, role).
- **Activate / Deactivate User** — Flip the `is_active` flag for any user (soft-delete / suspension).

### 🔑 Permissions & Roles

Restricted to users holding `USER_MANAGE` permission. Two tabs with filter dialogs:

- **Users Tab** — Every user with their assigned role, active status toggle, and per-user permission overrides. Supports filtering by active / inactive / all.
- **Roles Tab** — Every role defined on the server with its check-box permission matrix.

The permission system is evaluated locally at render time. Menu items, buttons, and entire pages are guarded — if a user lacks the relevant permission constant, the UI element is simply not drawn.

### 📡 Offline Queue & Sync ("Upload Data")

OceanSys is built to survive the intermittent or zero-connectivity environments typical of field sales in rural/urban-edge areas.

- Every write request (deactivate customer, task complete, CRM note, product categories, customer edit, etc.) is routed through `CustomerRepository._postWithAuth`.
- If `Dio` throws any network exception OR the server returns codes `0 / 1 / -1` (the custom "no internet" range), the `(url, payload)` pair is inserted into the SQLite `pending_requests` table via `LocalDb.insertRequest`.
- The user gets a snackbar: *"Information saved and will be sent later"*.
- Menu item **"Upload Data"** (permission: `UPLOAD_DATA`) iterates the queue and replays each request with the bearer token. Successfully-replayed rows are deleted. A summary snackbar reports *N sent / M failed*.

### 📍 Live Location & Distance

`LocationSyncBloc` is started automatically at app boot (see `main.dart`):

- Uses `geolocator` to listen for platform location updates.
- Exposes current lat/lng via `LocationSyncState`.
- Provides `getDistanceInKm(lat, lng)` helper used on every customer list card to show the straight-line distance from the agent's current position to the customer.
- The Map tab enables **fast 5-second updates** while open and pauses them on dispose to conserve battery.

---

## Use Cases

Typical daily workflow for a **Sales Representative**:

1. Launch app → Splash → Login (credentials saved).
2. Open **"Scan Customer"** → View the day's assigned customers on the List tab.
3. Switch to the **Map** tab, see customers clustered geographically.
4. Walk/drive to the nearest customer. Tap their pin.
5. Review customer data → Update any outdated info (Edit Info).
6. Record purchase intent (Product Categories).
7. Note any complaint (CRM Description).
8. Mark visit complete (Task Complete action, implicit or explicit).
9. Go offline mid-shift? No problem — all writes queue locally.
10. End of shift: tap **"Upload Data"** to flush the queue.

Typical workflow for a **Supervisor / Admin**:

1. Login → Open **"Route Manager"** → Assign tomorrow's routes to the team.
2. Open **"User Manager"** → Onboard a new hire or suspend a leaver.
3. Open **"User Permissions"** → Fine-tune which team members can edit routes vs. only view vs. manage users.

---

## Project Architecture

OceanSys follows a clean **layered architecture** with explicit separation of concerns:

```
┌──────────────────────────────────────────────────┐
│                 UI  Layer  (view/)               │  Widgets, Pages, Dialogs
│  MenuPage  •  LoginPage  •  MainScreen           │  MenuWidget, action buttons,
│  CustomerListPage  •  MapPage  •  CustomerPage   │  CRM dialog, forms, cards
│  RouteManager  •  UserManager  •  PermissionsPage│
├──────────────────────────────────────────────────┤
│          State Layer  (cubit/  •  **/bloc/)      │  BLoC + Cubit
│  LoginCubit  •  UserBloc  •  MainBloc            │  Event → State
│  CustomerInfoBloc  •  CustomerEditBloc           │  UserStatus • UserRole
│  LocationSyncBloc  •  RouteBloc  •  AddUserBloc  │  PermissionCubit
├──────────────────────────────────────────────────┤
│           Domain Layer  (data/repository/)       │  Single source of truth
│  CustomerRepository  •  UserRepository           │  Orchestrates API + local DB
│  CustomerInfoRepository  •  LocationRepository   │  Token refresh, retries,
│  RouteRepository  •  PermissionRepository        │  offline queue logic
├──────────────────────────────────────────────────┤
│            Data Sources                          │
│  dio_service.dart  (Dio HTTP)                    │  Remote: REST + Bearer JWT
│  local_db.dart    (SQFlite SQLite)               │  Local : pending_requests
│  storage_const.dart (GetStorage K-V)             │  Local : token, credentials,
│                                                   │          server URL
└──────────────────────────────────────────────────┘
```

**Wiring is done at the root** — `main.dart` mounts every repository and bloc globally with `MultiRepositoryProvider` + `MultiBlocProvider`, so any page can `context.read<BlocOrRepo>()` without further wiring.

Navigation uses `GetX` (`GetMaterialApp` + `getPages`) combined with explicit `MaterialPageRoute` pushes for permission-wrapped sub-pages (e.g. `PermissionsPage` is wrapped in a fresh `BlocProvider<PermissionCubit>` at navigation time).

---

## Tech Stack & Dependencies

| Category | Package | Purpose |
|----------|---------|---------|
| **Framework** | Flutter 3.8.1+ / Dart 3.x | Application platform |
| **State Management** | flutter_bloc `^8.1.6`, bloc `^8.1.4` | BLoC / Cubit architecture |
| **Navigation & Dialogs** | get `^4.7.2` (GetX) | Routing + snackbars |
| **Network** | dio `^4.0.6` | HTTP client (JSON POST) |
| **Local Key-Value** | get_storage `^2.1.1` | Token, credentials, server URL persistence |
| **Local SQL** | sqflite `^2.4.2`, sqflite_common_ffi `^2.3.6`, path `^1.9.1` | Offline request queue (pending_requests table) |
| **Maps** | flutter_map `^8.2.1`, latlong2 (transitive) | Interactive OpenStreetMap-style canvas with Google raster tiles |
| **Location** | geolocator `^14.0.2` | Live GPS + distance computation |
| **Sensors** | sensors_plus `^7.1.0` | Accelerometer-driven parallax on the login screen |
| **Icons / Imagery** | flutter_svg `^2.0.17`, cupertino_icons `^1.0.8` | Menu SVG icons + Cupertino set |
| **Loading** | flutter_spinkit `^5.2.1` | `SpinKitRing` indicator for splash |
| **Decorations** | blobs `^2.0.0` | (Available) organic blob shapes |
| **Forms / Validation** | validated `^2.0.0` | Form field validators |
| **Utilities** | share_plus, url_launcher | External sharing / URL opening |
| **File I/O** | file_picker `^10.2.0` | File attach (used in upcoming competitor-prices / new-customer flows) |
| **Progress UI** | percent_indicator `^4.2.5` | Progress bars and circular indicators |
| **Launcher Icons** | flutter_launcher_icons `^0.14.1` | Generates Android / iOS launcher icons from `asset/iconeApp/ocean.png` |
| **Code Generation** | flutter_gen (integrations: flutter_svg) | Typed `Assets.icons.*` references |
| **Linting** | flutter_lints `^5.0.0` | Recommended Dart/Flutter rule set |

---

## Project Structure

```
lib/
├── constans/                      App-wide constants (misspelled "constans" in this codebase)
│   ├── decrations.dart            Reusable BoxDecorations / ButtonStyles
│   ├── my_color.dart              SolidColors + GradientColors palettes (blue→purple→green)
│   ├── my_strings.dart            UI string bank (bilingual, Persian heavy)
│   ├── permission_constans.dart   5 permission keys (CUSTOMER_SCAN etc.)
│   ├── storage_const.dart         GetStorage key names (token, username, password, server_address)
│   └── text_style.dart            TextTheme helpers (MyTextStyle)
│
├── cubit/
│   └── user/
│       ├── user_bloc.dart         User data + checkPermission() helper
│       └── user_state.dart        UserLoading / UserLoaded / UserError
│
├── data/
│   ├── api_constant.dart          ApiUrlConstant (base URL + 20+ REST endpoints)
│   ├── database/
│   │   └── local_db.dart          SQFlite helper: pending_requests CRUD
│   ├── repository/                6 repositories (Customer, User, CustomerInfo,
│   │                                Location, Route, Permission)
│   └── services/
│       └── dio_service.dart       Thin Dio wrapper (postJson, headers)
│
├── gen/
│   ├── assets.gen.dart            Generated by flutter_gen: Assets.icons.*
│   └── fonts.gen.dart             Generated font families
│
├── model/
│   ├── RouteScannerModel/         CRM, CustomerEdit, DisactiveCustomer, ProductCategory,
│   │                                TaskComplete, CustomerInfo request/response DTOs
│   ├── UserModel/
│   │   ├── Permission_model.dart  Permission bit-flags object
│   │   └── user_model.dart        UserModel(id, username, first/last, isActive, permission)
│   ├── permission_list_model.dart Permission-list endpoint DTO
│   ├── point_model.dart           Geo point (lat/lng + name)
│   ├── role_model.dart            Role DTO for role-based access UI
│   └── route_model.dart           Route assignment DTO
│
├── route_manager/
│   ├── names.dart                 NamedRoute constants (/, loginPage, mapPage, …)
│   └── pages.dart                 Pages.pages → List<GetPage> (GetX route table)
│
├── servies/
│   ├── customer_service.dart      Additional customer-side helpers
│   └── location_service.dart      Location-specific utilities
│
├── view/
│   ├── splash_screen.dart         Initial 3-sec splash → LoginPage
│   ├── auth/
│   │   ├── login_page.dart        Ocean-themed animated login + server address dialog
│   │   └── cubit/                 LoginCubit (init, login, saveServerAddress)
│   ├── main/
│   │   ├── menu_page.dart         Main grid menu (permission-gated tiles)
│   │   └── bloc/                  MainBloc + MainCubit for bottom-nav index
│   ├── RouteScanner/              The scanner/home workflow
│   │   ├── route_scanner.dart     MainScreen: BottomNav between CustomerList + Map
│   │   ├── CustomerPages/
│   │   │   ├── customer_list_page.dart  Pull-to-refresh customer cards with distance
│   │   │   ├── customer_page.dart       Customer detail + 2×2 action grid
│   │   │   ├── customer_page_idit.dart  Full customer edit form
│   │   │   ├── bloc/                     CustomerInfoBloc, CustomerEditBloc (events + states)
│   │   │   └── widget/                   app_bar, action_button, customer_info widget,
│   │   │                                    CRM dialog, disactive dialog, product-category dialog
│   │   └── map/
│   │       ├── map_page.dart             Google-tile map with colored customer markers
│   │       └── bloc/location_sync/       LocationSyncBloc + Cubit (Start/Stop sync, distances)
│   ├── manage _user/
│   │   ├── user_manager.dart      Tab shell: AddUser / ChangeUserStatus
│   │   ├── bloc/                  AddUserBloc + events + states
│   │   └── widgets/               add_user_page.dart, change_user_status_page.dart
│   ├── permissions/
│   │   ├── permissions_page.dart  Tab shell: Users / Roles + filter dialog
│   │   ├── cubit/                 PermissionCubit (load, assign, toggle, save)
│   │   └── widgets/               users_tab.dart, roles_tab.dart
│   ├── route_manager/
│   │   ├── route_manager.dart     Tab shell: AddRoute / DeleteRoute
│   │   ├── bloc/                  RouteBloc + RouteEvent + RouteState
│   │   └── widget/                base_route_form, Persian-calendar dialog, user-search dialog
│   └── widgets/                   menuWidget.dart, widgets_Dialog.dart (shared components)
│
└── main.dart                      App bootstrap, providers, theme, locale=fa, route table
```

---

## Data Models

### Core Entities

**`UserModel`** — Authenticated application user.
```
id: int            username: String
firstName: String  lastName: String
isActive: bool     permission: PermissionModel
```

**`PermissionModel`** — Bit-flag object exposing the 5 permissions. Evaluated by `UserBloc.checkPermission(key, user)`.

**`RoleModel`** — Named group of permissions (e.g. "Sales Rep", "Supervisor", "Admin").

**`CustomerInfoModel`** — Customer / store returned from `getCustomerData`. Fields include customer board sign, owner name, national code, role code, postal code, address, two mobile numbers, phone, store area, latitude, longitude, and the `visited` status flag.

**`Permission List Models`** — `permission_list_model.dart` + `role_model.dart` back the Permissions page.

### Request DTOs (RouteScannerModel folder)

| DTO | Endpoint | Purpose |
|-----|----------|---------|
| `DisactiveCustomerRequest` | `disActiveCustomer` | Activate/deactivate a customer with reason + description. |
| `TaskComplete` | `task_complete` | Mark visit done for a customer code. |
| `CRMCustomerDescriptionRequest` | `CRMCustomerDescription` | Save visit notes plus the 3 CRM checkboxes (visit, owner-present, cooperative). |
| `ProductCategoryCustomer` | `ProductCategory` | Save multi-SKU purchase-intent list. |
| `CustomerEditModel` | `editcoustomerinfo` | Full customer profile update. |

---

## BLoC / Cubit State Management

State management uses **BLoC for event-heavy flows** and **Cubit for simple state** — exactly following the user's documented preference. Every bloc has its events extracted to separate `_event.dart` files for a clean file layout.

### Registered at App Root (`main.dart`)

| Provider | Type | Events / Methods | Purpose |
|----------|------|------------------|---------|
| `LoginCubit` | Cubit | `init()`, `login()`, `saveServerAddress()` | Auth flow. |
| `UserBloc` | Bloc | `UserFetchData`, `checkPermission(key, user)` | Current user profile + permission lookup. |
| `CustomerInfoBloc` | Bloc | `CustomerInfoFetchData`, `getPoints(customers)` | Load route-customer list, transform to map points. |
| `CustomerEditBloc` | Bloc | `CustomerEditSubmit(...)` | Save edited customer fields. |
| `LocationSyncBloc` | Bloc | `StartLocationSync`, `StopLocationSync`, `StartFastUpdates`, `StopFastUpdates`, `getDistanceInKm()` | Live GPS stream + distance helper. |
| `RouteBloc` | Bloc | `RouteAdd(...)`, `RouteDelete(...)` | Create and remove route assignments. |
| `MainBloc` | Bloc | `MainChangePage(index)` | Bottom navigation index for the Scanner home. |

### Provided Lazily at Navigation

| Provider | Mounted In | Purpose |
|----------|------------|---------|
| `PermissionCubit` | MenuPage → PermissionsPage push | Fetch users / roles / permissions, toggle status, save overrides. |
| `AddUserBloc` | UserManager → AddUserPage | Create user + role selection. |

### State Pattern Consistency

Every feature bloc mirrors the same canonical shape:

```
FeatureInitial  →  FeatureLoading  →  FeatureLoaded (with data)
                                     ↘  FeatureError (with message)
                                     ↘  FeatureUpdating → FeatureUpdated
```

Pages use `BlocBuilder` for render states, `BlocListener` for one-shot side-effects (snackbars, navigation), and `BlocConsumer` where both are needed.

---

## Permission System

Permissions are **string constants** declared in [permission_constans.dart](file:///e:/projects/UIapp/ocean_sys/lib/constans/permission_constans.dart) and live in `PermissionModel` (returned with each `UserModel`).

| Constant | Label in Menu | Capability Unlocked |
|----------|---------------|---------------------|
| `CUSTOMER_SCAN` | Route Manager, Scan Customer | Full access to route scanner, customer list, map, and customer detail flows. Also unlocks the Route Manager page. |
| `UPLOAD_DATA` | Upload Data | Flush the offline SQLite queue to the server. |
| `USER_MANAGE` | USER, User Permissions | User Manager (add / suspend users) + Permissions page (role matrix, user overrides, status toggle). |
| `NEW_CUSTOMER` | New Customer | Placeholder — onboarding of net-new customers (coming soon). |
| `COMPETITOR_PRICES` | Competitor Prices | Placeholder — competitive price survey feature (coming soon). |

Enforcement pattern (from [menu_page.dart](file:///e:/projects/UIapp/ocean_sys/lib/view/main/menu_page.dart)):

```dart
if (userBloc.checkPermission(PermissionConstans.customerScan, state.user))
  MenuItem(...) // else the tile is omitted entirely
```

Server-side endpoints also enforce the same roles/permissions — UI gating is a UX convenience, not a security boundary.

---

## Offline-First Support

All state-changing HTTP calls go through `CustomerRepository._postWithAuth(url, map)` in [customer_repository.dart](file:///e:/projects/UIapp/ocean_sys/lib/data/repository/customer_repository.dart#L97-L110).

### Happy path (online)
1. Attach `Authorization: Bearer <token>` header.
2. `DioService.postJson(payload, url, options)`.
3. `200 OK` → Snackbar *"Information sent successfully"*, return 200.
4. `400` for `disActiveCustomer` → Snackbar *"Customer already deactivated"*.

### Unhappy path (offline or mid-air)
1. Dio throws, or `statusCode ∈ {0, 1, -1}` (custom network-down convention).
2. Snackbar *"Internet or server is down, data will be saved later"*.
3. `LocalDb.insertRequest(url, jsonEncode(payload))` → row in `pending_requests(id, url, payload)`.

### Manual Sync (Upload Data tile)
1. `CustomerRepository.sendOfflineRequest()` → `LocalDb.getPendingRequests()`.
2. Iterate, replay each with the stored bearer token.
3. On `200` → `LocalDb.deletePendingRequest(id)`, increment success counter.
4. Final snackbar reports *N sent / M failed* (fully successful / partially successful / fully failed messages each use a distinct color + border).

---

## Getting Started

### Prerequisites

- Flutter SDK **3.8.1** or newer (check with `flutter --version`).
- Dart 3.x (ships with Flutter 3.x).
- Android Studio (or IntelliJ / VS Code with Flutter plugin) for Android builds.
- Xcode 15+ for iOS builds (macOS only).
- Chrome / Edge for Web runs.
- A running OceanSys-compatible backend, reachable over HTTP. The default server URL is `http://192.168.1.2:8282/` and can be changed at any time from the "Adress Server" button on the login screen.

### Environment Check

```bash
flutter doctor
```
Resolve any listed issues before proceeding.

### Install Dependencies

```bash
flutter pub get
```

### Run (Debug)

```bash
# On a connected Android device / emulator:
flutter run

# On Chrome (Web):
flutter run -d chrome

# On Windows (desktop):
flutter run -d windows
```

First-run flow: Splash → Login screen → tap "Adress Server" → enter your backend base URL → Save → enter credentials → Sign in → Menu Grid.

---

## Build Guide

### Android

#### Debug APK
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

#### Release APK (single universal binary)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

#### Release App Bundle (recommended for Google Play)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

#### Per-ABI split APKs (smaller downloads)
```bash
flutter build apk --split-per-abi --release
# Produces armeabi-v7a, arm64-v8a, x86_64 separate APKs
```

> **Signing for Play Store**: Before a public release, create a JKS Keystore, add `android/key.properties` with `storePassword`, `keyPassword`, `keyAlias`, `storeFile`, and reference it in `android/app/build.gradle.kts`.

### Web

#### Enable the Web platform (one-time)
```bash
flutter channel stable
flutter upgrade
flutter config --enable-web
```

#### Debug on Chrome
```bash
flutter run -d chrome
```

#### Release build
```bash
flutter build web --release
# Output folder: build/web/
```
Deploy the entire `build/web/` directory to any static host (Nginx, Apache, Firebase Hosting, Vercel, Netlify, GitHub Pages).

If hosting **under a sub-path** (not the domain root), set `<base href="/your/path/">` in `web/index.html`. Use `--web-renderer html` for broader old-browser compatibility (default is `canvaskit`, better for complex graphics).

### iOS (macOS only)

```bash
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode → configure signing → Archive
```

### Windows (desktop)

```bash
flutter build windows --release
# Output: build/windows/x64/runner/Release/
```

### Clean / Rebuild cache

Run this after upgrading Flutter, changing packages, or switching branches:

```bash
flutter clean
flutter pub get
```

---

## API Integration

All endpoints are centralized in [api_constant.dart](file:///e:/projects/UIapp/ocean_sys/lib/data/api_constant.dart) as `ApiUrlConstant`. The effective `baseUrl` is:
```
GetStorage().read(StorageKey.serverAddress) ?? "http://192.168.1.2:8282/"
```

### Authentication

| Verb | Endpoint | Request | Response |
|------|----------|---------|----------|
| POST | `token` | Form-encoded or JSON login | JWT-style bearer token |

Token is persisted as `StorageKey.token` (GetStorage) and attached as `Authorization: Bearer <token>` on every authenticated call.

### User & Permissions

| Verb | Endpoint | Purpose |
|------|----------|---------|
| GET  | `getUserdata` | Current user + their permission object |
| GET  | `getAllUserdata` | All users (Permissions page) |
| GET  | `get_role_list` | Role list |
| GET  | `get_permission_list` | Available permission matrix |
| POST | `register` | Create a new user |
| POST | `edit_permission_user` | Per-user permission overrides |
| POST | `edit_permission_role` | Role permission matrix edits |
| POST | `change_user_role` | Reassign user role |
| POST | `{username}/status` | Activate / deactivate a user |
| GET  | `get_all_roles_permissions` | Joined roles + permissions tree |

### Customer Data

| Verb | Endpoint | Purpose |
|------|----------|---------|
| GET  | `getCustomerData` | Today's customers for the signed-in route |
| POST | `editcoustomerinfo` | Full customer profile update |
| POST | `disActiveCustomer` | Activate / deactivate customer with reason |
| POST | `task_complete` | Mark customer visit finished |
| POST | `CRMCustomerDescription` | Save visit notes and CRM flags |
| POST | `ProductCategory` | Save purchase-intent SKU list |
| POST | `point` | Lat/long location data (agent or customer) |

### Routes

| Verb | Endpoint | Purpose |
|------|----------|---------|
| POST | `set_rout` | Create a route assignment (user + date + customer codes) |
| POST | `del_rout` | Remove a route assignment |

### Status Code Convention

- `200` — Success
- `400` — Business rule error (customer already deactivated, etc.)
- `0 / 1 / -1` — Custom Dio error codes used as "network is unreachable" signals, triggering offline queue.

---

## Local Database

File: [local_db.dart](file:///e:/projects/UIapp/ocean_sys/lib/data/database/local_db.dart)

Provider: SQFlite on mobile, sqflite_common_ffi on desktop / web fallbacks.

Single database file: `ocean_sys.db`, version `1`.

### Schema

```sql
CREATE TABLE pending_requests (
  id      INTEGER PRIMARY KEY AUTOINCREMENT,
  url     TEXT,                -- original endpoint URL
  payload TEXT                 -- JSON-encoded request body
);
```

### Exposed Methods

- `LocalDb.insertRequest(url, payload)` → `Future<int>` (new row id)
- `LocalDb.getPendingRequests()` → `Future<List<Map>>`
- `LocalDb.deletePendingRequest(id)` → `Future<int>` (rows affected)

No migration code exists yet (version is pinned at 1).

---

## Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| **Android** | ✅ Primary target | Fully tested. Launcher icons generated. |
| **iOS** | ✅ Build config present | Xcode assets generated; requires signing. |
| **Web** | ✅ Flutter Web | Uses Google raster tiles (needs internet for map). |
| **Windows** | ✅ Desktop shell | sqflite FFI is wired up. |
| macOS / Linux | ❌ Not configured | Could be added by running `flutter create --platforms=macos,linux .` and configuring sqflite FFI. |

RTL behavior is automatic — the app declares `locale: const Locale("fa")` in `GetMaterialApp` and ships with the **Dana** Persian font family for headings and body.

---

## Roadmap & Upcoming Features

Two menu items are already scaffolded but flagged `isComingSoon: true` in [menu_page.dart](file:///e:/projects/UIapp/ocean_sys/lib/view/main/menu_page.dart):

- **New Customer** (`NEW_CUSTOMER` permission) — End-to-end onboarding of brand-new customers directly from the field: photo capture, GPS pin, store photos, duplicate check, and pending-approval workflow.
- **Competitor Prices** (`COMPETITOR_PRICES` permission) — Competitive price-survey module: select the competing SKU, enter price, optionally attach a shelf photo, and sync to HQ reporting.

Other planned improvements:
- In-app signature capture for Proof-of-Delivery.
- Order-taking cart and invoice PDF generation.
- Daily / weekly agent KPIs dashboard and visit-compliance %.
- WebSocket-based live location streaming to HQ dashboard.
- Push notifications for route changes.
- App-update check + in-app upgrader.

---

*This project is under active development and has not been officially released yet.*
