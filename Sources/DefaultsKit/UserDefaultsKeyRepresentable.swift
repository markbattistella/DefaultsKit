//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A type that represents a UserDefaults key using a `String` raw value. Conforming types gain
/// automatic namespacing via an optional `keyPrefix` or, when absent, the app’s bundle
/// identifier. This helps avoid key collisions and keeps UserDefaults storage organised.
public protocol UserDefaultsKeyRepresentable: RawRepresentable where RawValue == String {

    /// An optional prefix applied to all keys for this conforming type. If `nil`, the bundle
    /// identifier is used; if that is unavailable, a fallback prefix is applied.
    static var keyPrefix: String? { get }
}

extension UserDefaultsKeyRepresentable {

    /// The default implementation returns `nil`, allowing the prefix logic to fall back to the
    /// bundle identifier or the fallback value.
    public static var keyPrefix: String? {
        return nil
    }

    /// The fully qualified UserDefaults key for this instance. Combines the calculated prefix
    /// with the raw key value.
    internal var value: String {
        return "\(Self.prefix)\(rawValue)"
    }

    /// The resolved prefix used for all keys under this type.
    ///
    /// Priority:
    /// 1. `keyPrefix` when provided
    /// 2. App bundle identifier
    /// 3. Fallback string
    ///
    /// The final prefix is trimmed and normalised before being appended.
    internal static var prefix: String {
        var prefixValue: String
        if let keyPrefix {
            prefixValue = keyPrefix
        } else if let identifier = Bundle.main.bundleIdentifier {
            prefixValue = identifier
        } else {
            prefixValue = "com.markbattistella.packages.defaultsKit"
        }
        prefixValue = prefixValue.trimmingCharacters(in: .init(charactersIn: "."))
        return "\(prefixValue).defaults."
    }
}
