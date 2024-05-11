//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

public extension UserDefaults {

	/// Stores a value in UserDefaults.
	///
	/// - Parameters:
	///   - value: The value to store.
	///   - key: The key to associate the value with.
	func set<Value>(_ value: Value, for key: UserDefaultsKeyRepresentable) {
		self.set(value, forKey: key.value)
	}

	/// Removes a value associated with a key in UserDefaults.
	///
	/// - Parameter key: The key for which to remove the value.
	func remove(for key: UserDefaultsKeyRepresentable) {
		self.removeObject(forKey: key.value)
	}

	/// Registers a dictionary of default values.
	///
	/// - Parameter dictionary: A dictionary containing the default values.
	func register<T: UserDefaultsKeyRepresentable>(defaults dictionary: [T: Any]) {
		let mappedDictionary = dictionary.reduce(into: [String: Any]()) { result, element in
			result[element.key.value] = element.value
		}
		self.register(defaults: mappedDictionary)
	}

	/// Retrieve a Bool value for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The Bool value for the key, or `false` if not found.
	func bool(for key: UserDefaultsKeyRepresentable) -> Bool {
		self.bool(forKey: key.value)
	}

	/// Retrieve an Integer value for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The Integer value for the key, or `0` if not found.
	func integer(for key: UserDefaultsKeyRepresentable) -> Int {
		self.integer(forKey: key.value)
	}

	/// Retrieve a Float value for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The Float value for the key, or `0.0` if not found.
	func float(for key: UserDefaultsKeyRepresentable) -> Float {
		self.float(forKey: key.value)
	}

    /// Retrieve a Double value for a given key.
    ///
    /// - Parameter key: The key to look up.
    /// - Returns: The Double value for the key, or `0.0` if not found.
    func double(for key: UserDefaultsKeyRepresentable) -> Double {
        self.double(forKey: key.value)
    }

	/// Retrieve a String value for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The String value for the key, or `nil` if not found.
	func string(for key: UserDefaultsKeyRepresentable) -> String? {
		self.string(forKey: key.value)
	}

	/// Retrieve a Data value for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The Data value for the key, or `nil` if not found.
	func data(for key: UserDefaultsKeyRepresentable) -> Data? {
		self.data(forKey: key.value)
	}

	/// Retrieve a URL value for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The URL value for the key, or `nil` if not found.
	func url(for key: UserDefaultsKeyRepresentable) -> URL? {
		self.url(forKey: key.value)
	}

	/// Retrieve a generic value for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The generic value for the key, or `nil` if not found or if the type does not match.
	func value<Value>(for key: UserDefaultsKeyRepresentable) -> Value? {
		self.value(forKey: key.value) as? Value
	}

	/// Retrieve an array for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The array for the key, or `nil` if not found or if the type does not match.
	func array<Value>(for key: UserDefaultsKeyRepresentable) -> [Value]? {
		self.array(forKey: key.value) as? [Value]
	}

	/// Retrieve a dictionary for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The dictionary for the key, or `nil` if not found.
	func dictionary(for key: UserDefaultsKeyRepresentable) -> [String: Any]? {
		self.dictionary(forKey: key.value)
	}

	/// Encodes a value and stores it in UserDefaults.
	///
	/// - Parameters:
	///   - value: The Encodable value to store.
	///   - key: The key to associate the value with.
	/// - Throws: Throws an error if unable to encode the value.
	func encode<Value: Encodable>(_ value: Value, for key: UserDefaultsKeyRepresentable) throws {
		let data = try JSONEncoder().encode(value)
		self.set(data, for: key)
	}

	/// Decodes and retrieves a value for a given key.
	///
	/// - Parameter key: The key to look up.
	/// - Returns: The Decodable value associated with the key, if found.
	/// - Throws: Throws an error if unable to decode the value.
	func decode<T : Decodable>(for key: UserDefaultsKeyRepresentable) throws -> T? {
		guard let data = self.data(for: key) else { return nil }
		return try JSONDecoder().decode(T.self, from: data)
	}
}
