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

    /// Registers default values for UserDefaults keys.
    ///
    /// - Parameters:
    ///   - defaults: A dictionary containing the default values to register.
    ///   - reset: If true, all keys will be deleted before registering the defaults.
    public func register<T: UserDefaultsKeyRepresentable>(
        defaults dictionary: [T: Any],
        reset: Bool = false
    ) {
        if reset { dictionary.keys.forEach { remove(for: $0) } }
        let mappedDictionary = dictionary.reduce(into: [String: Any]()) { result, element in
            result[element.key.value] = element.value
        }
        self.register(defaults: mappedDictionary)
    }
}

// MARK: - Utility Methods

extension UserDefaults {

    /// Prints all keys and values from a specified UserDefaults suite that match a prefix.
    ///
    /// - Parameter suiteType: The type conforming to `UserDefaultsKeyRepresentable` representing
    /// the desired suite.
    public static func printAll<T: UserDefaultsKeyRepresentable>(from suiteType: T.Type) {
        processAllKeys(from: suiteType) { userDefaults, key in
            print("\(key): \(userDefaults.value(forKey: key) ?? "nil")")
        }
    }

    /// Deletes all keys from a specified UserDefaults suite that match a prefix.
    ///
    /// - Parameter suiteType: The type conforming to `UserDefaultsKeyRepresentable` representing
    /// the desired suite.
    public static func deleteAll<T: UserDefaultsKeyRepresentable>(from suiteType: T.Type) {
        processAllKeys(from: suiteType) { userDefaults, key in
            userDefaults.removeObject(forKey: key)
        }
    }
}

// MARK: - Helper methods

extension UserDefaults {

    /// Retrieves the correct `UserDefaults` instance for the specified suite type.
    ///
    /// - Parameter suiteType: The type conforming to `UserDefaultsKeyRepresentable` representing
    /// the desired suite.
    /// - Returns: The `UserDefaults` instance for the given suite type, or `nil` if it could not
    /// be retrieved.
    private static func getUserDefaultsInstance<T: UserDefaultsKeyRepresentable>(
        from suiteType: T.Type
    ) -> UserDefaults? {
        let suiteName = suiteType.suiteName
        let userDefaults: UserDefaults? = suiteName == nil ? .standard : .init(suiteName: suiteName)
        guard let userDefaultsInstance = userDefaults else {
            assertionFailure(
                "Unable to retrieve UserDefaults for suite: \(suiteName ?? "standard")"
            )
            return nil
        }
        return userDefaultsInstance
    }

    /// Processes all keys from a specified UserDefaults suite that match a prefix.
    ///
    /// - Parameters:
    ///   - suiteType: The type conforming to `UserDefaultsKeyRepresentable` representing the
    ///   desired suite.
    ///   - process: A closure to execute for each matching key, providing the `UserDefaults`
    ///   instance and the key.
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
}
