//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A protocol that represents a key used in `UserDefaults` with a raw string value. Conforming
/// types must have a `RawValue` of type `String` and provide a `value` property that returns the
/// full key string used for accessing `UserDefaults`.
public protocol UserDefaultsKeyRepresentable: RawRepresentable where RawValue == String {

    /// The suite name for the `UserDefaults` instance, defaulting to nil for `.standard`.
    static var suiteName: String? { get }
}

// MARK: - Default values

extension UserDefaultsKeyRepresentable {

    /// Default suite name is nil, meaning `.standard`.
    public static var suiteName: String? {
        return nil
    }

    /// The formatted string value for the key, using the determined prefix.
    internal var value: String {
        return "\(Self.prefix)\(self.rawValue)"
    }

    /// The default prefix based on the bundle identifier or fallback string.
    internal static var prefix: String {
        if let identifier = Bundle.main.bundleIdentifier {
            return "\(identifier).userDefaults."
        } else {
            return "defaultsKit.userDefaults."
        }
    }
}
