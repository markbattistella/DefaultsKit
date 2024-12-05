//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A protocol to represent keys for `UserDefaults` that conform to `RawRepresentable` where the
/// `RawValue` is of type `String`.
///
/// This protocol provides functionality to generate prefixed keys for `UserDefaults` to avoid
/// conflicts, and optionally allows the use of a custom suite name.
public protocol UserDefaultsKeyRepresentable: RawRepresentable where RawValue == String {

    /// The name of the custom `UserDefaults` suite, if any.
    ///
    /// - Default: `nil` (uses the standard `UserDefaults` if not specified).
    static var suiteName: String? { get }
}

// MARK: - Default values

extension UserDefaultsKeyRepresentable {

    /// Default implementation for `suiteName` to return `nil`.
    ///
    /// Override this property in conforming types to specify a custom suite name.
    public static var suiteName: String? {
        return nil
    }

    /// Computed property to get the full key value with a prefix.
    ///
    /// This combines the type-specific prefix and the raw key value, ensuring unique keys in
    /// `UserDefaults`.
    internal var value: String {
        return "\(Self.prefix)\(rawValue)"
    }

    /// Computed property to generate a prefix for the keys.
    ///
    /// The prefix is constructed as follows:
    /// 1. If a `suiteName` is provided, use it.
    /// 2. If the app's bundle identifier exists, use it.
    /// 3. As a fallback, use a default value: `"com.markbattistella.packages.defaultsKit.default."`.
    ///
    /// The resulting prefix ends with `.defaults.` to namespace the keys for `UserDefaults`.
    internal static var prefix: String {
        var prefixValue: String
        if let suiteName = suiteName {
            prefixValue = suiteName
        } else if let identifier = Bundle.main.bundleIdentifier {
            prefixValue = identifier
        } else {
            prefixValue = "com.markbattistella.packages.defaultsKit."
        }
        return "\(prefixValue).defaults."
    }
}
