import SwiftUI

struct SettingTimeLimitSection: View {
  @AppStorage(.sns) private var _sns: TimeInterval = .defaultTimeLimit
  @AppStorage(.video) private var _video: TimeInterval = .defaultTimeLimit
  @AppStorage(.message) private var _message: TimeInterval = .defaultTimeLimit

  var sns: Binding<Date> {
    .init(get: { Date(timeIntervalSince1970: _sns) }, set: { _sns = $0.timeIntervalSince1970 })
  }
  var video: Binding<Date> {
    .init(get: { Date(timeIntervalSince1970: _video) }, set: { _video = $0.timeIntervalSince1970 })
  }
  var message: Binding<Date> {
    .init(get: { Date(timeIntervalSince1970: _message) }, set: { _message = $0.timeIntervalSince1970 })
  }

  var body: some View {
    Section {
      DatePicker("SNS", selection: sns, displayedComponents: .hourAndMinute)
        .datePickerStyle(.wheel)

      DatePicker("Video", selection: video, displayedComponents: .hourAndMinute)
        .datePickerStyle(.wheel)

      DatePicker("Message", selection: message, displayedComponents: .hourAndMinute)
        .datePickerStyle(.wheel)
    } header: {
      Text("Timer")
        .textCase(nil)
    }
  }
}

struct SettingTimeLimitSection_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SettingTimeLimitSection()
        .environment(\.colorScheme, .light)
      SettingTimeLimitSection()
        .environment(\.colorScheme, .dark)
    }
  }
}

// MARK: - Private
fileprivate extension String {
  static let prefix = "Setting.LimitTime"
  static let sns = "\(prefix).sns"
  static let video = "\(prefix).video"
  static let message = "\(prefix).message"
}

fileprivate extension TimeInterval {
  // Default time is 30 min
  static let defaultTimeLimit = Date(timeIntervalSince1970: 0).addingTimeInterval(30 * 60).timeIntervalSince1970
}
