<div align="center">

# DefaultsKit

![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FDefaultsKit%2Fbadge%3Ftype%3Dswift-versions)

![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fmarkbattistella%2FDefaultsKit%2Fbadge%3Ftype%3Dplatforms)

![Licence](https://img.shields.io/badge/Licence-MIT-white?labelColor=blue&style=flat)

</div>

`DefaultsKit` is a Swift package that provides a clean and type-safe way to manage `UserDefaults` keys and values. It introduces extensible protocols for keys and convenient property wrappers for storing, retrieving, and managing preferences using a consistent prefix strategy.

## Features

- **Type-safe UserDefaults Keys:** Use enums conforming to `UserDefaultsKeyRepresentable` to define keys with automatic prefix handling.
- **Property Wrappers:**
  - `@DefaultsPersisted`: A powerful property wrapper for any `Codable` type with built-in support for primitives and optionals
  - `@AppStorage`: Enhanced SwiftUI integration with type-safe keys for common types
- **Prefix Management:** Supports internal bundle identifiers or custom prefixes via the `UserDefaultsPrefix` enum
- **Utility Functions:** Includes methods for setting, getting, printing, and deleting `UserDefaults` entries
- **Codable Support:** Automatic encoding/decoding for complex types

## Installation

Add `DefaultsKit` to your Swift project using Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/markbattistella/DefaultsKit", from: "2.0.0")
]
```

## Usage

### Defining Keys

Define keys by conforming your enums to `UserDefaultsKeyRepresentable`:

```swift
enum UserDefaultsKeys: String, UserDefaultsKeyRepresentable {
    case userPreference
    case appTheme
    case userProfile
}
```

### Using DefaultsPersisted

The `@DefaultsPersisted` property wrapper supports any `Codable` type:

```swift
// For primitive types
@DefaultsPersisted(UserDefaultsKeys.userPreference)
var isEnabled: Bool = false

// For custom types
@DefaultsPersisted(UserDefaultsKeys.userProfile)
var profile: UserProfile = UserProfile(name: "John", age: 30)

// For optional values
@DefaultsPersisted(UserDefaultsKeys.lastLoginDate)
var lastLogin: Date?
```

### AppStorage Integration

Use type-safe keys with SwiftUI's `@AppStorage`:

```swift
struct ContentView: View {
    @AppStorage(UserDefaultsKeys.userPreference)
    var isEnabled: Bool = false
    
    @AppStorage(UserDefaultsKeys.appTheme)
    var theme: String = "light"
    
    var body: some View {
        Toggle("Enable Feature", isOn: $isEnabled)
    }
}
```

### Direct UserDefaults Access

Use the extended `UserDefaults` methods:

```swift
// Setting values
UserDefaults.standard.set(true, for: UserDefaultsKeys.userPreference)

// Getting values
let preference = UserDefaults.standard.bool(for: UserDefaultsKeys.userPreference)

// Encoding complex objects
try? UserDefaults.standard.encode(profile, for: UserDefaultsKeys.userProfile)

// Decoding complex objects
let savedProfile: UserProfile? = try? UserDefaults.standard.decode(for: UserDefaultsKeys.userProfile)
```

## Managing Defaults

### Registering defaults

```swift
// Register defaults
UserDefaults.standard.register(
    defaults: [
        UserDefaultsKeys.appTheme: "light",
        UserDefaultsKeys.userPreference: true
    ]
)
```

### Helper methods

```swift
// Print all values
UserDefaults.standard.printAll()

// Delete all values
UserDefaults.standard.deleteAll()

// Use the internal bundle identifier
UserDefaults.standard.printAll(withPrefix: .internalIdentifier)

// Use custom prefix
UserDefaults.standard.printAll(withPrefix: .custom("custom.prefix."))
```

## License

`DefaultsKit` is available under the MIT license. See the LICENSE file for more information.
