import Combine
import SwiftUI

private class Clock: ObservableObject {
    @Published var date: Date = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .default)
        .autoconnect()

    init() {
        timer
            .assign(to: &$date)
    }

    deinit {
        timer.upstream.connect().cancel()
    }
}

@propertyWrapper
struct Now: DynamicProperty {
    @StateObject private var clock = Clock()

    var wrappedValue: Date {
        clock.date
    }
}
