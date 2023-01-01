import SwiftUI

// MARK: - IntKey
extension AppStorage {
  typealias IntKey = UserDefaults.IntKey

  init(wrappedValue: Value, _ key: IntKey, store: UserDefaults? = nil) where Value == Int {
    self.init(wrappedValue: wrappedValue, key.key, store: store)
  }

  init(_ key: IntKey, store: UserDefaults? = nil) where Value == Int? {
    self.init(key.key, store: store)
  }
}

extension UserDefaults {
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

  func integer(forKey key: IntKey) -> Int? {
    integer(forKey: key.rawValue)
  }
}
