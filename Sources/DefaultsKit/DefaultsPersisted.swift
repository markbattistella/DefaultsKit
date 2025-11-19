//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation

/// A property wrapper for storing values in UserDefaults with type-safe keys.
///
/// This wrapper provides a convenient way to store and retrieve values from UserDefaults using
/// type-safe keys that conform to `UserDefaultsKeyRepresentable`.
@propertyWrapper
public struct DefaultsPersisted<Value: Codable> {

    private let key: any UserDefaultsKeyRepresentable
    private let defaultValue: Value
    private let defaults: UserDefaults

    public init(
        wrappedValue: Value,
        _ key: any UserDefaultsKeyRepresentable,
        defaults: UserDefaults = .standard
    ) {
        self.defaultValue = wrappedValue
        self.key = key
        self.defaults = defaults
    }

    public var wrappedValue: Value {

        // MARK: Fetching the data

        get {
            // Handle primitive types first for better performance
            switch Value.self {

                case is Bool.Type:
                    return defaults.bool(for: key) as! Value

                case is Int.Type:
                    return defaults.integer(for: key) as! Value

                case is Double.Type:
                    return defaults.double(for: key) as! Value

                case is Float.Type:
                    return defaults.float(for: key) as! Value

                case is String.Type:
                    return (defaults.string(for: key) ?? defaultValue as! String) as! Value

                case is Date.Type:
                    return (defaults.date(for: key) ?? defaultValue as! Date) as! Value

                case is Data.Type:
                    return (defaults.data(for: key) ?? defaultValue as! Data) as! Value

                case is URL.Type:
                    return (defaults.url(for: key) ?? defaultValue as! URL) as! Value

                default:
                    // For all other Codable types, use JSON encoding/decoding
                    do {
                        if let data = defaults.data(for: key) {
                            return try JSONDecoder().decode(Value.self, from: data)
                        }
                    } catch {
                        print(
                            "Error decoding value for key \(key.value): \(error.localizedDescription)"
                        )
                    }
                    return defaultValue
            }
        }

        // MARK: Storing the data

        set {
            // Handle optional values
            if let optional = newValue as? OptionalType, optional.isNil {
                defaults.remove(for: key)
                return
            }

            // Handle primitives first for better performance
            switch newValue {

                case let value as Bool:
                    defaults.set(value, for: key)

                case let value as Int:
                    defaults.set(value, for: key)

                case let value as Double:
                    defaults.set(value, for: key)

                case let value as Float:
                    defaults.set(value, for: key)

                case let value as String:
                    defaults.set(value, for: key)

                case let value as Date:
                    defaults.set(value, for: key)

                case let value as Data:
                    defaults.set(value, for: key)

                case let value as URL:
                    defaults.set(value, for: key)

                default:
                    // For all other Codable types, use JSON encoding
                    do {
                        let data = try JSONEncoder().encode(newValue)
                        defaults.set(data, for: key)
                    } catch {
                        // If encoding fails, remove the value
                        defaults.remove(for: key)
                    }
            }
        }
    }
}

// MARK: - Optional Support

private protocol OptionalType {
    var isNil: Bool { get }
}

extension Optional: OptionalType {
    fileprivate var isNil: Bool { self == nil }
}

// MARK: - Convenience Initializers

extension DefaultsPersisted where Value: ExpressibleByNilLiteral {

    /// Creates a new instance for optional values.
    public init(
        _ key: any UserDefaultsKeyRepresentable,
        defaults: UserDefaults = .standard
    ) {
        self.init(wrappedValue: nil, key, defaults: defaults)
    }
}
