import SwiftUI

final class Deadline: ObservableObject, Codable {
  @Published var lastRecordDateTimestamp = Calendar.autoupdatingCurrent.startOfDay(for: .now).timeIntervalSince1970
  @Published var remainingSNSTime: Int = .remainingTime(hour: .defaultHour, minute: .defaultMinute)
  @Published var remainingVideoTime: Int = .remainingTime(hour: .defaultHour, minute: .defaultMinute)
  @Published var remainingMessageTime: Int = .remainingTime(hour: .defaultHour, minute: .defaultMinute)

  static let shared = Deadline()
  private init() { }

  // MARK: - Codable
  enum CodingKeys: String, CodingKey {
    case lastRecordDateTimestamp
    case remainingSNSTime
    case remainingVideoTime
    case remainingMessageTime
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    lastRecordDateTimestamp = try container.decode(TimeInterval.self, forKey: .lastRecordDateTimestamp)
    remainingSNSTime = try container.decode(Int.self, forKey: .remainingSNSTime)
    remainingVideoTime = try container.decode(Int.self, forKey: .remainingVideoTime)
    remainingMessageTime = try container.decode(Int.self, forKey: .remainingMessageTime)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(lastRecordDateTimestamp, forKey: .lastRecordDateTimestamp)
    try container.encode(remainingSNSTime, forKey: .remainingSNSTime)
    try container.encode(remainingVideoTime, forKey: .remainingVideoTime)
    try container.encode(remainingMessageTime, forKey: .remainingMessageTime)
  }

  // MARK: - Internal
  func resetIfNeeded() {
    let today = Calendar.autoupdatingCurrent.startOfDay(for: .now)
    if Calendar.autoupdatingCurrent.isDate(today, inSameDayAs: Date(timeIntervalSince1970: lastRecordDateTimestamp)) {
      return
    }

    if let hour = UserDefaults.standard.integer(forKey: .snsHour), let minute = UserDefaults.standard.integer(forKey: .snsMinute) {
      remainingSNSTime = .remainingTime(hour: hour, minute: minute)
    } else {
      remainingSNSTime = .remainingTime(hour: .defaultHour, minute: .defaultMinute)
    }

    if let hour = UserDefaults.standard.integer(forKey: .videoHour), let minute = UserDefaults.standard.integer(forKey: .videoMinute) {
      remainingVideoTime = .remainingTime(hour: hour, minute: minute)
    } else {
      remainingVideoTime = .remainingTime(hour: .defaultHour, minute: .defaultMinute)
    }

    if let hour = UserDefaults.standard.integer(forKey: .messageHour), let minute = UserDefaults.standard.integer(forKey: .messageMinute) {
      remainingMessageTime = .remainingTime(hour: hour, minute: minute)
    } else {
      remainingMessageTime = .remainingTime(hour: .defaultHour, minute: .defaultMinute)
    }
  }
}

private extension UserDefaults {
  static let deadlineKey = "Object.Deadline"

  func set(deadline: Deadline) {
    let data = try? JSONEncoder().encode(deadline)
    set(data, forKey: UserDefaults.deadlineKey)
  }
  func deadline() -> Deadline? {
    guard let data = data(forKey: UserDefaults.deadlineKey) else {
      return nil
    }
    return try? JSONDecoder().decode(Deadline.self, from: data)
  }
}
