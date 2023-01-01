import Foundation

extension Int {
  static let defaultHour = 0
  static let defaultMinute = 30

  static func remainingTime(hour: Int, minute: Int) -> Int {
    hour * 60 * 60 + minute * 60
  }
}
