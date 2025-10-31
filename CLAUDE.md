# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter-based Asset Management System ("Quan Ly Tai San") for tracking fixed assets, tools and supplies (CCDC), asset transfers, handovers, and generating various reports. The application supports Vietnamese localization and is designed for web and mobile platforms.

## Development Commands

### Setup
```bash
# Install dependencies
flutter pub get

# Run the application (dev environment)
flutter run

# Build for web
flutter build web

# Clean build artifacts
flutter clean
```

### Testing
```bash
# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze
```

## Architecture

### State Management
The app uses **BLoC pattern** (flutter_bloc) as the primary state management solution with the following layers:
- **Bloc**: Business logic components located in `lib/screen/*/bloc/`
- **Event**: User actions triggering state changes (`*_event.dart`)
- **State**: Application state representations (`*_state.dart`)
- **Repository**: Data layer handling API calls and data transformations

All BLoCs are registered globally in [lib/core/utils/bloc_providers.dart](lib/core/utils/bloc_providers.dart) and provided via `MultiBlocProvider` in [lib/app.dart](lib/app.dart).

### Additional State Management
- **Provider**: Used alongside BLoC for certain UI state (see `lib/core/utils/providers.dart`)
- **GetX**: Used for localization (`MyLocale()`) and navigation helpers
- **Riverpod**: Also integrated via `ProviderScope` for specific features

### Navigation
The app uses **go_router** for declarative routing:
- Routes are defined in [lib/routes/app_route_conf.dart](lib/routes/app_route_conf.dart)
- Route paths and names are in [lib/routes/routes.dart](lib/routes/routes.dart)
- Navigation structure uses `ShellRoute` for persistent layouts (Home shell)
- Initial route is the login screen

### Dependency Injection
Basic DI using **get_it**:
- Setup in [lib/injection.dart](lib/injection.dart)
- Currently only registers `AppRouteConf`
- Access via `locator<T>()` throughout the app

### Data Persistence
- **GetStorage**: Local storage for user info, auth tokens, and cached data
- **AccountHelper**: Singleton service managing user session and cached reference data (departments, staff, assets, etc.) via `StorageService`

### API Integration
- Base URL configuration in [lib/main.dart](lib/main.dart) via `Config` class
- Environment-based URLs (dev/prod)
- Uses `se_gay_components` package's `ApiConfig` for base API setup
- Repositories handle all API calls using Dio

### Project Structure

```
lib/
├── common/              # Shared components, widgets, and utilities
│   ├── button/         # Reusable button configurations
│   ├── components/     # Common UI components (loading, popups, PDF conversion)
│   ├── input/          # Form input components
│   ├── model/          # Shared DTOs (config, permissions, signatures)
│   ├── page/           # Reusable page layouts (contracts, signers)
│   ├── popup/          # Modal dialogs
│   ├── reponsitory/    # Shared repositories (config, permissions, file exports)
│   ├── table/          # Table components and configurations
│   └── widgets/        # Generic widgets (filters, headers, file uploads)
├── core/
│   ├── constants/      # App-wide constants (colors, icons, images)
│   ├── enum/           # Enumerations (roles, screen types)
│   ├── theme/          # Text styles and icon paths
│   └── utils/          # Utilities (BLoC observer, providers, permissions, response parsing)
├── locale/             # Localization controller (Vietnamese)
├── routes/             # Routing configuration
├── screen/             # Feature modules (each with bloc, model, repository, views)
│   ├── asset_category/      # Asset category management
│   ├── asset_group/         # Asset group management
│   ├── asset_handover/      # Asset handover workflows
│   ├── asset_management/    # Main asset CRUD operations
│   ├── asset_transfer/      # Asset transfer (dieu dong) workflows
│   ├── category_manager/    # Master data (staff, departments, projects, capital sources, roles)
│   ├── ccdc_group/          # Tools & supplies groups
│   ├── dashboard/           # Dashboard view
│   ├── home/                # Main navigation shell
│   ├── login/               # Authentication and user management
│   ├── reason_increase/     # Reasons for asset increases
│   ├── report/              # Various reports (S22-DN, inventory records, tracking forms)
│   ├── tool_and_material_transfer/  # Tool transfer workflows
│   ├── tool_and_supplies_handover/  # Tool handover workflows
│   ├── tools_and_supplies/  # CCDC management
│   ├── type_asset/          # Asset types
│   ├── type_ccdc/           # CCDC types
│   └── unit/                # Units of measurement
├── app.dart            # Root widget with all providers
├── injection.dart      # Dependency injection setup
└── main.dart           # Entry point with environment config
```

### Feature Module Pattern
Each feature module in `screen/` follows a consistent structure:
- `bloc/`: BLoC files (event, state, bloc)
- `model/`: DTOs and data models
- `repository/`: API interaction layer
- `views/` or `widget/`: UI components
- `component/` or `pages/`: Additional UI pieces
- `provider/`: Feature-specific providers (if needed)
- `request/`: Request DTOs

## Key Technical Details

### Environment Configuration
The app environment is controlled via the `Config` class in [lib/main.dart](lib/main.dart:16-36):
- Change `environment` constant between "dev" and "prod"
- Dev URL: `https://ecotel-odoo.id.vn:8386`
- Prod URL: `http://42.119.110.246:8386`

### Localization
- Default locale: `vi_VN` (Vietnamese)
- Managed by GetX's `MyLocale` controller
- Date formatting uses `intl` package with Vietnamese locale

### Web Support
- Uses `dynamic_path_url_strategy` to remove the `#` from URLs (`setPathUrlStrategy()`)
- Conditional web-specific implementations in `*_web.dart` files

### Custom Dependencies
The project depends on two custom Git packages:
- `se_gay_components`: UI component library from `https://github.com/congcuong207/SeGayComponent.git`
- `table_base`: Table component from `https://github.com/chienpntb/table_base.git` (dev/new_table_expand branch)

### Reports & PDF Generation
The app generates various Vietnamese regulatory reports:
- Asset ledgers (Sổ Tài Sản Cố Định, S22-DN)
- Inventory records (Biên Bản Kiểm Kê)
- Tracking forms (Sổ Theo Dõi)
- Uses `pdf` and `printing` packages for PDF generation
- PDF conversion handled in `lib/common/components/convert_pdf.dart`

### Permission System
- Permission-based access control managed by `PermissionSignService`
- Permissions loaded on app start and monitored via stream
- Menu items refresh based on user permissions via `MenuRefreshService`
- Role-based features controlled via `RoleCode` enum

### Data Caching Strategy
`AccountHelper` acts as a singleton cache for reference data:
- Departments, staff, projects, capital sources
- Asset groups, CCDC groups, asset categories
- Assets and CCDC lists
- Loaded on app initialization and refreshed as needed

## Development Guidelines

### Adding a New Feature Module
1. Create module directory under `lib/screen/module_name/`
2. Implement BLoC (event, state, bloc) in `bloc/` subdirectory
3. Create repository in `repository/` subdirectory
4. Add models in `model/` subdirectory
5. Build UI in `views/` or `widget/` subdirectory
6. Register BLoC in [lib/core/utils/bloc_providers.dart](lib/core/utils/bloc_providers.dart)
7. Add route in [lib/routes/app_route_conf.dart](lib/routes/app_route_conf.dart)

### Working with Tables
- Use `table_base` package for editable tables
- Configuration classes in `component/table_*_config.dart`
- Table styles and utils in `lib/common/table/`
- Common menu setup in `lib/common/common_menu_setup_table.dart`

### Excel Import/Export
- Excel import converters in `component/convert_excel_to_*.dart`
- Export functionality in `lib/common/reponsitory/save_export_file_*.dart`
- Supports platform-specific implementations (web vs IO)

### State Management Best Practices
- Use BLoC for feature logic and data flows
- Handle concurrent events with `bloc_concurrency.sequential()` transformer
- Emit loading states before async operations
- Always emit success or error states after operations complete
