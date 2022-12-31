import SwiftUI

struct SettingTimeLimitSection: View {
  struct Time: Hashable {
    let hour: Int
    let minute: Int
  }

  @AppStorage(.snsHour) private var snsHour: Int = .defaultHour
  @AppStorage(.snsMinute) private var snsMinute: Int = .defaultMinute
  @AppStorage(.videoHour) private var videoHour: Int = .defaultHour
  @AppStorage(.videoMinute) private var videoMinute: Int = .defaultMinute
  @AppStorage(.messageHour) private var messageHour: Int = .defaultHour
  @AppStorage(.messageMinute) private var messageMinute: Int = .defaultMinute

  @State var snsHourPickerIsPresented = false
  @State var snsMinutePickerIsPresented = false
  var body: some View {
    Section {
      Component(
        titleKey: "SNS",
        hour: $snsHour,
        minute: $snsMinute
      )
      Component(
        titleKey: "Video",
        hour: $videoHour,
        minute: $videoMinute
      )
      Component(
        titleKey: "Message",
        hour: $messageHour,
        minute: $messageMinute
      )
    } header: {
      Text("Timer")
        .textCase(nil)
    }
  }

  struct Component: View {
    let titleKey: LocalizedStringKey
    let hour: Binding<Int>
    let minute: Binding<Int>

    @State var hourPickerIsPresented = false
    @State var minutePickerIsPresented = false

    var body: some View {
      VStack(spacing: 8) {
        HStack {
          Text(titleKey)
          Spacer()
          HStack(spacing: 10) {
            Button {
              hourPickerIsPresented.toggle()
            } label: {
              Text("\(hour.wrappedValue)")
            }
            .buttonStyle(.bordered)

            Button {
              minutePickerIsPresented.toggle()
            } label: {
              Text(String(format: "%02d", minute.wrappedValue))
            }
            .buttonStyle(.bordered)
          }
        }

        if hourPickerIsPresented {
          Divider()
          VStack(alignment: .leading, spacing: 4) {
            HStack {
              Text("Hour")
              Spacer()
              Button {
                hourPickerIsPresented = false
              } label: {
                Text("Close")
              }
            }
            Picker("", selection: hour) {
              ForEach(0..<10) { hour in
                Text("\(hour)")
              }
            }
            .pickerStyle(.wheel)
          }
        }
        if minutePickerIsPresented {
          Divider()
          VStack(alignment: .leading, spacing: 4) {
            HStack {
              Text("Minute")
              Spacer()
              Button {
                minutePickerIsPresented = false
              } label: {
                Text("Close")
              }
            }
            Picker("", selection: minute) {
              ForEach(0..<60) { minute in
                Text("\(minute)")
              }
            }
            .pickerStyle(.wheel)
          }
        }
      }
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
  static let snsHour = "\(prefix).snsHour"
  static let snsMinute = "\(prefix).snsMinute"
  static let videoHour = "\(prefix).videoHour"
  static let videoMinute = "\(prefix).videoMinute"
  static let messageHour = "\(prefix).messageHour"
  static let messageMinute = "\(prefix).messageMinute"
}

fileprivate extension Int {
  static let defaultHour = 0
  static let defaultMinute = 30
}
