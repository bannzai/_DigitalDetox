import SwiftUI

struct Countdown: View {
  @Clock var clock
  let goal: Date

  var body: some View {
    let components = dateComponents()

    HStack(spacing: 10) {
      if let hour = components?.hour {
        Number(value: hour)
        Colon()
      }
      if let minute = components?.minute {
        Number(value: minute)
        Colon()
      }
      if let second = components?.second {
        Number(value: second)
      }
    }
  }

  func dateComponents() -> DateComponents? {
    Calendar.autoupdatingCurrent.dateComponents([.hour, .minute, .second], from: clock.now, to: goal)
  }

  struct Number: View {
    let value: Int

    var body: some View {
      Text(String(format: "%02d", value))
        .font(.system(size: 28, weight: .semibold))
    }
  }

  struct Colon: View {
    var body: some View {
      Text(":")
        .font(.system(size: 28, weight: .semibold))
    }
  }
}

struct Countdown_Previews: PreviewProvider {
  static var previews: some View {
    Countdown(goal: .now.addingTimeInterval(60 * 30))
  }
}
