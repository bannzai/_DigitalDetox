import SwiftUI

final class LimitTimer: ObservableObject {
  @Published var lastStartDateTimestamp = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day], from: .now).date!.timeIntervalSince1970
  @Published var remainingSNSTime: Int = .remainingTime(hour: .defaultHour, minute: .defaultMinute)
  @Published var remainingVideoTime: Int = .remainingTime(hour: .defaultHour, minute: .defaultMinute)
  @Published var remainingMessageTime: Int = .remainingTime(hour: .defaultHour, minute: .defaultMinute)

  enum CodingKeys: String, CodingKey {
    case lastStartDateTimestamp
    case remainingSNSTime
    case remainingVideoTime
    case remainingMessageTime
  }
}

extension LimitTimer: Codable {
  convenience init(from decoder: Decoder) throws {
    self.init()
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    lastStartDateTimestamp = try container.decode(TimeInterval.self, forKey: .lastStartDateTimestamp)
    remainingSNSTime = try container.decode(Int.self, forKey: .remainingSNSTime)
    remainingVideoTime = try container.decode(Int.self, forKey: .remainingVideoTime)
    remainingMessageTime = try container.decode(Int.self, forKey: .remainingMessageTime)
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(lastStartDateTimestamp, forKey: .lastStartDateTimestamp)
    try container.encode(remainingSNSTime, forKey: .remainingSNSTime)
    try container.encode(remainingVideoTime, forKey: .remainingVideoTime)
    try container.encode(remainingMessageTime, forKey: .remainingMessageTime)
  }

}
