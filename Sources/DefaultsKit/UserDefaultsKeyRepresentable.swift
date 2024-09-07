//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A protocol that represents a key used in `UserDefaults` with a raw string value.
///
/// Conforming types must have a `RawValue` of type `String` and provide a `value` property
/// that returns the full key string used for accessing `UserDefaults`.
public protocol UserDefaultsKeyRepresentable: RawRepresentable where RawValue == String {
    
    /// The full key string used in `UserDefaults`, combining the bundle identifier (if available)
    /// with the raw string value of the conforming type.
    var value: String { get }
}

public extension UserDefaultsKeyRepresentable {
    
    /// The formatted string value for the key, using the determined prefix.
    var value: String {
        return "\(UserDefaultsPrefix.internalIdentifier.prefix)\(self.rawValue)"
    }
}
