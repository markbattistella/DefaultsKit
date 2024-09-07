//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Enum to represent different prefix options for UserDefaults keys.
public enum UserDefaultsPrefix {
    
    case internalIdentifier
    case custom(String)
    
    /// Computed property to get the prefix string based on the enum case.
    public var prefix: String {
        switch self {
            case .internalIdentifier:
                if let identifier = Bundle.main.bundleIdentifier {
                    return "\(identifier).userDefaults."
                } else {
                    return "defaultsKit.userDefaults."
                }
            case .custom(let customPrefix):
                return customPrefix
        }
    }
}
