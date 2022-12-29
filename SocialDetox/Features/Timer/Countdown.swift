import SwiftUI

struct Countdown: View {
  @Clock var clock
  let goal: Date?

  var body: some View {
    let components = dateComponents()

    HStack(spacing: 10) {
      Number(value: components?.hour)
      Colon()
      Number(value: components?.minute)
      Colon()
      Number(value: components?.second)
    }
  }

  func dateComponents() -> DateComponents? {
    guard let goal else {
      return nil
    }

    return Calendar.autoupdatingCurrent.dateComponents([.hour, .minute, .second], from: clock.now, to: goal)
  }

  struct Number: View {
    let value: Int?

    var body: some View {
      Text(String(format: "%02d", value ?? 0))
        .font(.system(size: 28, weight: .bold))
        .redacted(reason: value == nil ? .placeholder : [])
    }
  }

  struct Colon: View {
    var body: some View {
      Text(":")
        .font(.system(size: 28, weight: .bold))
        .alignmentGuide(VerticalAlignment.center) { $0[VerticalAlignment.center] + 3 }
    }
  }
}

struct Countdown_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Countdown(goal: .now.addingTimeInterval(60 * 30))
      Countdown(goal: nil)
    }
  }
}
