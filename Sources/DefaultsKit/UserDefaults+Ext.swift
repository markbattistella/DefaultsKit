//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Storing data

extension UserDefaults {

    /// Stores a value in UserDefaults.
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to associate the value with.
    public func set<Value>(_ value: Value, for key: any UserDefaultsKeyRepresentable) {
        self.set(value, forKey: key.value)
    }
}

// MARK: - Deleing data

extension UserDefaults {

    /// Removes a value associated with a key in UserDefaults.
    ///
    /// - Parameter key: The key for which to remove the value.
    public func remove(for key: any UserDefaultsKeyRepresentable) {
        self.removeObject(forKey: key.value)
    }
}

// MARK: - Getting data

extension UserDefaults {

    /// Retrieve a Bool value for a given key.
    public func bool(for key: any UserDefaultsKeyRepresentable) -> Bool {
        self.bool(forKey: key.value)
    }

    /// Retrieve an Integer value for a given key.
    public func integer(for key: any UserDefaultsKeyRepresentable) -> Int {
        self.integer(forKey: key.value)
    }

    /// Retrieve a Float value for a given key.
    public func float(for key: any UserDefaultsKeyRepresentable) -> Float {
        self.float(forKey: key.value)
    }

    /// Retrieve a Double value for a given key.
    public func double(for key: any UserDefaultsKeyRepresentable) -> Double {
        self.double(forKey: key.value)
    }

    /// Retrieve a String value for a given key.
    public func string(for key: any UserDefaultsKeyRepresentable) -> String? {
        self.string(forKey: key.value)
    }

    /// Retrieve a Data value for a given key.
    public func data(for key: any UserDefaultsKeyRepresentable) -> Data? {
        self.data(forKey: key.value)
    }

    // Retrieve a Date value for a given key.
    public func date(for key: any UserDefaultsKeyRepresentable) -> Date? {
        self.object(forKey: key.value) as? Date
    }

    /// Retrieve a URL value for a given key.
    public func url(for key: any UserDefaultsKeyRepresentable) -> URL? {
        self.url(forKey: key.value)
    }

    /// Retrieve a generic value for a given key.
    public func value<Value>(for key: any UserDefaultsKeyRepresentable) -> Value? {
        self.value(forKey: key.value) as? Value
    }

    /// Retrieve an array for a given key.
    public func array<Value>(for key: any UserDefaultsKeyRepresentable) -> [Value]? {
        self.array(forKey: key.value) as? [Value]
    }

    /// Retrieve a dictionary for a given key.
    public func dictionary(for key: any UserDefaultsKeyRepresentable) -> [String: Any]? {
        self.dictionary(forKey: key.value)
    }
}

// MARK: - Encoding / Decoding Methods

extension UserDefaults {

    /// Encodes a value and stores it in UserDefaults.
    ///
    /// - Parameters:
    ///   - value: The value to encode and store.
    ///   - key: The key to associate with the encoded value.
    /// - Throws: An error if encoding fails.
    public func encode<Value: Encodable>(
        _ value: Value,
        for key: any UserDefaultsKeyRepresentable
    ) throws {
        let data = try JSONEncoder().encode(value)
        self.set(data, for: key)
    }

    /// Decodes and retrieves a value for a given key.
    ///
    /// - Parameter key: The key associated with the desired value.
    /// - Throws: An error if decoding fails.
    /// - Returns: The decoded value for the given key, or `nil` if the key does not exist.
    public func decode<T: Decodable>(
        for key: any UserDefaultsKeyRepresentable
    ) throws -> T? {
        guard let data = self.data(for: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Registration

extension UserDefaults {

    /// Registers default values to UserDefaults for keys provided by the specified type.
    ///
    /// - Parameters:
    ///   - defaults: A dictionary of keys and values to register as defaults in UserDefaults.
    ///   - reset: A Boolean indicating whether to delete all keys that match the specified type's
    ///   prefix before registering new defaults. Default value is `false`.
    /// - Note: If `reset` is set to `true`, all existing keys that match the prefix will be
    /// deleted before new defaults are registered.
    public func register<T: UserDefaultsKeyRepresentable>(
        defaults: [T: Any],
        reset: Bool = false
    ) {
        let instance = UserDefaults.getInstance(from: T.self)
        if reset { UserDefaults.deleteAllKeys(for: T.self) }
        let prefixedDefaults = defaults.reduce(into: [String: Any]()) { result, entry in
            result[entry.key.value] = entry.value
        }
        instance.register(defaults: prefixedDefaults)
    }
}

// MARK: - Utilities

extension UserDefaults {

    /// Prints all keys from UserDefaults that match the prefix provided by the specified type.
    ///
    /// - Parameter representable: A type conforming to `UserDefaultsKeyRepresentable` that
    /// provides prefix and suite information.
    /// - Note: This method iterates over all keys in the relevant `UserDefaults` instance and
    /// prints those that match the specified prefix, along with their values.
    public static func printAllKeys<T: UserDefaultsKeyRepresentable>(
        for representable: T.Type
    ) {
        #if DEBUG
        let instance = UserDefaults.getInstance(from: T.self)
        let prefix = T.prefix
        let allFilteredKeys = instance.dictionaryRepresentation().keys
        allFilteredKeys.forEach { key in
            if key.hasPrefix(prefix), let value = instance.object(forKey: key) {
                print("\(key): \(value)")
            }
        }
        #endif
    }

    /// Deletes all keys from UserDefaults that match the prefix provided by the specified type.
    ///
    /// - Parameter representable: A type conforming to `UserDefaultsKeyRepresentable` that
    /// provides prefix and suite information.
    /// - Note: This method deletes all keys whose names begin with the specified prefix in the
    /// relevant `UserDefaults` instance.
    public static func deleteAllKeys<T: UserDefaultsKeyRepresentable>(
        for representable: T.Type
    ) {
        let instance = UserDefaults.getInstance(from: T.self)
        let prefix = T.prefix
        let allFilteredKeys = instance.dictionaryRepresentation().keys
        allFilteredKeys.forEach { key in
            if key.hasPrefix(prefix) {
                instance.removeObject(forKey: key)
            }
        }
    }
}

// MARK: - Helpers

extension UserDefaults {

    /// Retrieves an instance of UserDefaults based on the suite name of the provided type.
    ///
    /// - Parameter representable: A type conforming to `UserDefaultsKeyRepresentable` that
    /// provides suite information.
    /// - Returns: The corresponding `UserDefaults` instance, either the one with the specified
    /// suite or the standard suite.
    private static func getInstance<T: UserDefaultsKeyRepresentable>(
        from representable: T.Type
    ) -> UserDefaults {
        if let suite = T.keyPrefix {
            return UserDefaults(suiteName: suite)!
        }
        return .standard
    }
}
