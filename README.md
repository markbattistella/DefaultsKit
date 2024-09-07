# DefaultsKit

`DefaultsKit` is a Swift package that provides a clean and type-safe way to manage `UserDefaults` keys and values. It introduces an extensible protocol for keys and convenient utilities for storing, retrieving, and managing preferences using a consistent prefix strategy.

## Features

- **Type-safe UserDefaults Keys:** Use enums conforming to `UserDefaultsKeyRepresentable` to define keys with automatic prefix handling.
- **Prefix Management:** Supports internal bundle identifiers or custom prefixes via the `UserDefaultsPrefix` enum.
- **AppStorage Integration:** Simplifies using `UserDefaults` with SwiftUI's `@AppStorage` property wrapper for common types (`Bool`, `Int`, `Double`, `String`).
- **Utility Functions:** Includes methods for setting, getting, printing, and deleting `UserDefaults` entries, with optional prefix filtering.

## Installation

Add `DefaultsKit` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/markbattistella/DefaultsKit", from: "1.0.0")
]
```

## Usage

### Defining Keys

Define keys by conforming your enums to `UserDefaultsKeyRepresentable`:

```swift
enum UserDefaultsKeys: String, UserDefaultsKeyRepresentable {
  case userPreference
  case appTheme
}
```

### Setting and Getting Values

Use the provided extension methods on `UserDefaults`:

```swift
UserDefaults.standard.set(true, for: UserDefaultsKeys.userPreference)
let preference = UserDefaults.standard.bool(for: UserDefaultsKeys.userPreference)
```

### Managing Prefixes

Control key prefixes with `UserDefaultsPrefix`:

```swift
UserDefaults.standard.printAll(withPrefix: .custom("custom.prefix."))
UserDefaults.standard.deleteAll(withPrefix: .internalIdentifier)
```

### AppStorage Integration

Integrate with `@AppStorage` in SwiftUI:

```swift
@AppStorage(UserDefaultsKeys.userPreference, store: UserDefaults.standard)
var userPref: Bool = false
```

## License

`DefaultsKit` is available under the MIT license. See the LICENSE file for more information.
