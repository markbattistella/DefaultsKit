//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import SwiftUI

/// Extension for AppStorage to handle `Bool` types.
/// Provides initializer for custom key conforming to `UserDefaultsKeyRepresentable`.
extension AppStorage where Value == Bool {

    /// Initializes a new storage for `Bool` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value for the `Bool` being managed.
    ///   - key: A custom key conforming to `UserDefaultsKeyRepresentable`.
    ///   - store: The UserDefaults store to use. Defaults to `nil`.
    public init(
        wrappedValue: Value,
        _ key: any UserDefaultsKeyRepresentable,
        store: UserDefaults? = nil
    ) {
        self.init(wrappedValue: wrappedValue, key.value, store: store)
    }
}

/// Extension for AppStorage to handle `Int` types.
/// Provides initializer for custom key conforming to `UserDefaultsKeyRepresentable`.
extension AppStorage where Value == Int {

    /// Initializes a new storage for `Int` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value for the `Int` being managed.
    ///   - key: A custom key conforming to `UserDefaultsKeyRepresentable`.
    ///   - store: The UserDefaults store to use. Defaults to `nil`.
    public init(
        wrappedValue: Value,
        _ key: any UserDefaultsKeyRepresentable,
        store: UserDefaults? = nil
    ) {
        self.init(wrappedValue: wrappedValue, key.value, store: store)
    }
}

/// Extension for AppStorage to handle `Double` types.
/// Provides initializer for custom key conforming to `UserDefaultsKeyRepresentable`.
extension AppStorage where Value == Double {

    /// Initializes a new storage for `Double` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value for the `Double` being managed.
    ///   - key: A custom key conforming to `UserDefaultsKeyRepresentable`.
    ///   - store: The UserDefaults store to use. Defaults to `nil`.
    public init(
        wrappedValue: Value,
        _ key: any UserDefaultsKeyRepresentable,
        store: UserDefaults? = nil
    ) {
        self.init(wrappedValue: wrappedValue, key.value, store: store)
    }
}

/// Extension for AppStorage to handle `String` types.
/// Provides initializer for custom key conforming to `UserDefaultsKeyRepresentable`.
extension AppStorage where Value == String {

    /// Initializes a new storage for `String` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value for the `String` being managed.
    ///   - key: A custom key conforming to `UserDefaultsKeyRepresentable`.
    ///   - store: The UserDefaults store to use. Defaults to `nil`.
    public init(
        wrappedValue: Value,
        _ key: any UserDefaultsKeyRepresentable,
        store: UserDefaults? = nil
    ) {
        self.init(wrappedValue: wrappedValue, key.value, store: store)
    }
}

/// Extension for AppStorage to handle `Data` types.
/// Provides initializer for custom key conforming to `UserDefaultsKeyRepresentable`.
extension AppStorage where Value == Data {

    /// Initializes a new storage for `Data` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value for the `Data` being managed.
    ///   - key: A custom key conforming to `UserDefaultsKeyRepresentable`.
    ///   - store: The UserDefaults store to use. Defaults to `nil`.
    public init(
        wrappedValue: Value,
        _ key: any UserDefaultsKeyRepresentable,
        store: UserDefaults? = nil
    ) {
        self.init(wrappedValue: wrappedValue, key.value, store: store)
    }
}

/// Extension for AppStorage to handle `URL` types.
/// Provides initializer for custom key conforming to `UserDefaultsKeyRepresentable`.
extension AppStorage where Value == URL {

    /// Initializes a new storage for `URL` value.
    ///
    /// - Parameters:
    ///   - wrappedValue: The default value for the `URL` being managed.
    ///   - key: A custom key conforming to `UserDefaultsKeyRepresentable`.
    ///   - store: The UserDefaults store to use. Defaults to `nil`.
    public init(
        wrappedValue: Value,
        _ key: any UserDefaultsKeyRepresentable,
        store: UserDefaults? = nil
    ) {
        self.init(wrappedValue: wrappedValue, key.value, store: store)
    }
}
