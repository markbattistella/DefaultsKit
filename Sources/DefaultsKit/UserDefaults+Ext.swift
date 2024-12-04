//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

// MARK: - Setting

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

// MARK: - Deletion

extension UserDefaults {

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

// MARK: - Setup Methods

extension UserDefaults {

    public func register<T: UserDefaultsKeyRepresentable>(
        defaults: [T: Any],
        reset: Bool = false
    ) {
        guard let userDefaultsInstance = UserDefaults.getUserDefaultsInstance(from: T.self) else {
            return
        }
        if reset {
            UserDefaults.removeKeys(Array(defaults.keys), from: userDefaultsInstance)
        }
        var prefixedDefaults: [String: Any] = [:]
        defaults.forEach { key, value in
            prefixedDefaults[key.value] = value
        }
        userDefaultsInstance.register(defaults: prefixedDefaults)
    }
}

// MARK: - Utility Methods - Print

extension UserDefaults {

    public static func printKeys<T: UserDefaultsKeyRepresentable>(of type: T.Type) {
        processAllKeys(from: type) { userDefaultsInstance, key in
            if let value = userDefaultsInstance.object(forKey: key) {
                print("\(key): \(value)")
            }
        }
    }

    public static func printKeys<T: UserDefaultsKeyRepresentable>(_ keys: [T]) {
        guard let userDefaultsInstance = getUserDefaultsInstance(from: T.self) else { return }
        keys.forEach { key in
            if let value = userDefaultsInstance.object(forKey: key.value) {
                print("\(key.value): \(value)")
            }
        }
    }
}

// MARK: - Utility Methods - Delete

extension UserDefaults {
    public static func deleteKeys<T: UserDefaultsKeyRepresentable>(of type: T.Type) {
        processAllKeys(from: type) { userDefaultsInstance, key in
            userDefaultsInstance.removeObject(forKey: key)
        }
    }

    public static func deleteKeys<T: UserDefaultsKeyRepresentable>(_ keys: [T]) {
        guard let userDefaultsInstance = getUserDefaultsInstance(from: T.self) else { return }
        removeKeys(keys, from: userDefaultsInstance)
    }
}

// MARK: - Helper methods

extension UserDefaults {

    private static func getUserDefaultsInstance<T: UserDefaultsKeyRepresentable>(
        from suiteType: T.Type
    ) -> UserDefaults? {
        if let suiteName = suiteType.suiteName {
            return UserDefaults(suiteName: suiteName)
        } else {
            return .standard
        }
    }

    private static func processAllKeys<T: UserDefaultsKeyRepresentable>(
        from suiteType: T.Type,
        process: (UserDefaults, String) -> Void
    ) {
        guard let userDefaultsInstance = getUserDefaultsInstance(from: suiteType) else { return }
        let prefix = T.prefix
        let allKeys = userDefaultsInstance.dictionaryRepresentation().keys
        allKeys.forEach { key in
            if key.hasPrefix(prefix) {
                process(userDefaultsInstance, key)
            }
        }
    }

    private static func removeKeys<T: UserDefaultsKeyRepresentable>(
        _ keys: [T],
        from userDefaultsInstance: UserDefaults
    ) {
        keys.forEach { key in
            userDefaultsInstance.removeObject(forKey: key.value)
        }
    }
}
