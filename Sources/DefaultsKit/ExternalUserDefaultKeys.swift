//
// Project: EmbeeKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// An externally accessible enumeration that defines keys for UserDefaults settings.
///
/// Conforming to `UserDefaultsKeyRepresentable` allows these keys to be easily used
/// with UserDefaults for storing and retrieving values.
public enum ExternalUserDefaultKeys: String, UserDefaultsKeyRepresentable {

    /// The raw value of the enum case is used as the key's value.
    public var value: String { self.rawValue }

    /// Key for the user's preference on whether haptics are enabled.
    case settingsHapticsEnabled

    /// Key for the user's preference on whether audio effects are enabled.
    case settingsAudioEffectsEnabled

    /// Key for the navigation path stored in the app.
    case storedNavigationPath
}