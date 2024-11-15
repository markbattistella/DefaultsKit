//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Setting Values

extension UserDefaults {

    /// Stores a value in UserDefaults.
    ///
    /// - Parameters:
    ///   - value: The value to store.
    ///   - key: The key to associate the value with.
    public func set<Value>(_ value: Value, for key: any UserDefaultsKeyRepresentable) {
        self.set(value, forKey: key.value)
    }

    /// Removes a value associated with a key in UserDefaults.
    ///
    /// - Parameter key: The key for which to remove the value.
    public func remove(for key: any UserDefaultsKeyRepresentable) {
        self.removeObject(forKey: key.value)
    }
}

// MARK: - Getting Values

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

// MARK: - Setup Methods

extension UserDefaults {

    /// Registers a dictionary of default values with optional reset functionality.
    ///
    /// - Parameters:
    ///   - dictionary: A dictionary containing the default values.
    ///   - reset: Whether to reset all existing keys before registering new defaults.
    ///   Defaults to `false`.
    public func register<T: UserDefaultsKeyRepresentable>(
        defaults dictionary: [T: Any],
        reset: Bool = false
    ) {
        if reset {
            deleteAll()
        }
        let mappedDictionary = dictionary.reduce(into: [String: Any]()) { result, element in
            result[element.key.value] = element.value
        }
        self.register(defaults: mappedDictionary)
    }
}

// MARK: - Encoding/Decoding Methods

extension UserDefaults {

    /// Encodes a value and stores it in UserDefaults.
    public func encode<Value: Encodable>(
        _ value: Value,
        for key: any UserDefaultsKeyRepresentable
    ) throws {
        let data = try JSONEncoder().encode(value)
        self.set(data, for: key)
    }

    /// Decodes and retrieves a value for a given key.
    public func decode<T: Decodable>(for key: any UserDefaultsKeyRepresentable) throws -> T? {
        guard let data = self.data(for: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Utility Methods

extension UserDefaults {

    /// Prints all UserDefaults keys and values, filtered by a specified or default prefix.
    ///
    /// - Parameter prefixOption: An optional prefix to filter keys, defaulting to `.internalIdentifier`.
    public func printAll(withPrefix prefixOption: UserDefaultsPrefix = .internalIdentifier) {
        let prefix = prefixOption.prefix
        let defaults = self.dictionaryRepresentation()
        let filtered = defaults.filter { key, _ in key.hasPrefix(prefix) }
        filtered.forEach { key, value in
            print("\(key): \(value)")
        }
    }

    /// Deletes all UserDefaults keys, filtered by a specified or default prefix.
    ///
    /// - Parameter prefixOption: An optional prefix to filter keys, defaulting to `.internalIdentifier`.
    public func deleteAll(withPrefix prefixOption: UserDefaultsPrefix = .internalIdentifier) {
        let prefix = prefixOption.prefix
        let allKeys = self.dictionaryRepresentation().keys
        allKeys.forEach { key in
            if key.hasPrefix(prefix) {
                self.removeObject(forKey: key)
            }
        }
    }
}
