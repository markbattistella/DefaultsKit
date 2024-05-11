//
// Project: EmbeeKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// Protocol for providing a type-safe key for UserDefaults.
public protocol UserDefaultsKeyRepresentable {

	/// The raw string value for the key.
	var value: String { get }
}
