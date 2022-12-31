import SwiftUI

// MARK: - IntKey
extension AppStorage {
  enum IntKey: String {
    case snsHour
    case snsMinute
    case videoHour
    case videoMinute
    case messageHour
    case messageMinute

    var key: String {
      "IntKey.\(rawValue)"
    }
  }

  init(wrappedValue: Value, _ key: IntKey, store: UserDefaults? = nil) where Value == Int {
    self.init(wrappedValue: wrappedValue, key.key, store: store)
  }

  init(_ key: IntKey, store: UserDefaults? = nil) where Value == Int? {
    self.init(key.key, store: store)
  }
}
