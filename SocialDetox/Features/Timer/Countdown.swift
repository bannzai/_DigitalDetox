import SwiftUI

struct Countdown: View {
  let remainingTime: TimeInterval?

  var body: some View {
    let components = timeComponents()

    HStack(spacing: 10) {
      Number(value: components?.hour)
      Colon()
      Number(value: components?.minute)
      Colon()
      Number(value: components?.second)
    }
  }

  func timeComponents() -> (hour: Int, minute: Int, second: Int)? {
    guard let remainingTime else {
      return nil
    }

    let second = Int(remainingTime.truncatingRemainder(dividingBy: 60))
    let minute = Int((remainingTime / 60).truncatingRemainder(dividingBy: 60))
    let hour = Int(remainingTime / 60 * 60)
    return (hour, minute, second)
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
      Countdown(remainingTime: 60 * 30)
      Countdown(remainingTime: nil)
    }
  }
}
