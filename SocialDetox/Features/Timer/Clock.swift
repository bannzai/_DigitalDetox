import Combine
import SwiftUI

class _Clock: ObservableObject {
  @Published var now: Date = .now

  let timer = Timer.publish(every: 1, on: .main, in: .common)
    .autoconnect()

  init() {
    timer.assign(to: &$now)
  }

  deinit {
    timer.upstream.connect().cancel()
  }
}

@propertyWrapper
struct Clock: DynamicProperty {
  @StateObject private var clock = _Clock()

  var wrappedValue: _Clock {
    clock
  }
}
