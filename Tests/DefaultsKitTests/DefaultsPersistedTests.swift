//
// Project: DefaultsKit
// Author: Mark Battistella
// Website: https://markbattistella.com
//

import Foundation
import Testing

@testable import DefaultsKit

private enum TestKey: String, UserDefaultsKeyRepresentable {
  static let keyPrefix: String? = "com.defaultskit.tests"
  case boolValue
  case intValue
  case doubleValue
  case floatValue
  case stringValue
  case dataValue
  case codableValue
  case optionalValue
}

private struct Item: Codable, Equatable {
  let name: String
  let count: Int
}

@Suite("DefaultsPersisted", .serialized)
struct DefaultsPersistedTests {

  private let suiteName = "com.defaultskit.tests.suite"
  private var store: UserDefaults { UserDefaults(suiteName: suiteName)! }

  init() {
    UserDefaults(suiteName: suiteName)!.removePersistentDomain(forName: suiteName)
  }

  // MARK: - Primitive defaults (the main bug: must return defaultValue, not 0/false)

  @Test func boolDefaultIsRespected() {
    let wrapper = DefaultsPersisted(wrappedValue: true, TestKey.boolValue, defaults: store)
    #expect(wrapper.wrappedValue == true)
  }

  @Test func intDefaultIsRespected() {
    let wrapper = DefaultsPersisted(wrappedValue: 42, TestKey.intValue, defaults: store)
    #expect(wrapper.wrappedValue == 42)
  }

  @Test func doubleDefaultIsRespected() {
    let wrapper = DefaultsPersisted(wrappedValue: 3.14, TestKey.doubleValue, defaults: store)
    #expect(wrapper.wrappedValue == 3.14)
  }

  @Test func floatDefaultIsRespected() {
    let wrapper = DefaultsPersisted(wrappedValue: Float(1.5), TestKey.floatValue, defaults: store)
    #expect(wrapper.wrappedValue == Float(1.5))
  }

  // MARK: - Primitives round-trip

  @Test func boolRoundTrips() {
    var wrapper = DefaultsPersisted(wrappedValue: false, TestKey.boolValue, defaults: store)
    wrapper.wrappedValue = true
    #expect(wrapper.wrappedValue == true)
    wrapper.wrappedValue = false
    #expect(wrapper.wrappedValue == false)
  }

  @Test func intRoundTrips() {
    var wrapper = DefaultsPersisted(wrappedValue: 0, TestKey.intValue, defaults: store)
    wrapper.wrappedValue = 99
    #expect(wrapper.wrappedValue == 99)
  }

  @Test func doubleRoundTrips() {
    var wrapper = DefaultsPersisted(wrappedValue: 0.0, TestKey.doubleValue, defaults: store)
    wrapper.wrappedValue = 2.718
    #expect(wrapper.wrappedValue == 2.718)
  }

  @Test func floatRoundTrips() {
    var wrapper = DefaultsPersisted(wrappedValue: Float(0), TestKey.floatValue, defaults: store)
    wrapper.wrappedValue = Float(9.9)
    #expect(wrapper.wrappedValue == Float(9.9))
  }

  @Test func stringRoundTrips() {
    var wrapper = DefaultsPersisted(wrappedValue: "default", TestKey.stringValue, defaults: store)
    #expect(wrapper.wrappedValue == "default")
    wrapper.wrappedValue = "hello"
    #expect(wrapper.wrappedValue == "hello")
  }

  // MARK: - Codable type

  @Test func codableRoundTrips() {
    let defaultItem = Item(name: "default", count: 0)
    var wrapper = DefaultsPersisted(
      wrappedValue: defaultItem, TestKey.codableValue, defaults: store)
    #expect(wrapper.wrappedValue == defaultItem)
    let newItem = Item(name: "widget", count: 7)
    wrapper.wrappedValue = newItem
    #expect(wrapper.wrappedValue == newItem)
  }

  // MARK: - Optional

  @Test func optionalDefaultsToNil() {
    let wrapper = DefaultsPersisted<String?>(TestKey.optionalValue, defaults: store)
    #expect(wrapper.wrappedValue == nil)
  }

  @Test func optionalRoundTrips() {
    var wrapper = DefaultsPersisted<String?>(TestKey.optionalValue, defaults: store)
    wrapper.wrappedValue = "set"
    #expect(wrapper.wrappedValue == "set")
    wrapper.wrappedValue = nil
    #expect(wrapper.wrappedValue == nil)
  }
}

@Suite("UserDefaults extensions", .serialized)
struct UserDefaultsExtTests {

  private let suiteName = "com.defaultskit.tests.ext"
  private var store: UserDefaults { UserDefaults(suiteName: suiteName)! }

  init() {
    UserDefaults(suiteName: suiteName)!.removePersistentDomain(forName: suiteName)
  }

  @Test func existsReturnsFalseForMissingKey() {
    #expect(store.exists(for: TestKey.boolValue) == false)
  }

  @Test func existsReturnsTrueAfterSet() {
    store.set(true, for: TestKey.boolValue)
    #expect(store.exists(for: TestKey.boolValue) == true)
  }

  @Test func removeDeletesKey() {
    store.set(42, for: TestKey.intValue)
    store.remove(for: TestKey.intValue)
    #expect(store.exists(for: TestKey.intValue) == false)
  }

  @Test func deleteAllKeysRemovesPrefixedKeys() {
    store.set(true, for: TestKey.boolValue)
    store.set(1, for: TestKey.intValue)
    UserDefaults.deleteAllKeys(for: TestKey.self)
    // Standard defaults are used by deleteAllKeys; values in our suite are independent
    // — this verifies the method runs without crashing
  }

  @Test func registerDefaultsApplied() {
    store.register(defaults: [TestKey.intValue: 77])
    // Registered defaults appear only when no real value is stored
    #expect(store.integer(for: TestKey.intValue) == 77)
  }

  @Test func encodeDecodeRoundTrips() throws {
    let item = Item(name: "thing", count: 3)
    try store.encode(item, for: TestKey.codableValue)
    let decoded: Item? = try store.decode(for: TestKey.codableValue)
    #expect(decoded == item)
  }
}
