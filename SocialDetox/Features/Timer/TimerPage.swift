import SwiftUI

struct TimerPage: View {
  enum Context {
    case sns
    case video
    case message
  }

  @Environment(\.displayScale) var displayScale
  @StateObject var pip = PiP()
  @StateObject var deadline = Deadline()
  @Clock var clock

  let context: Context

  var body: some View {
    let countdown = Countdown(remainingTime: remainingTime.wrappedValue)

    VStack {
      if pip.canStart {
        PiPContainer()
          .onChange(of: clock.now) { _ in
            switch pip.progress {
            case .willStart, .didStart:
              if remainingTime.wrappedValue > 0 {
                self.remainingTime.wrappedValue = remainingTime.wrappedValue - 1
              }
            case nil, .willStop, .didStop:
              return
            }
          }
          .onChange(of: remainingTime.wrappedValue, perform: { remainingTime in
            if remainingTime >= 0 {
              pip.enqueue(content: countdown, displayScale: displayScale)
            } else {
              // TODO: Reach deadline
            }
          })
          .frame(width: pip.size.width, height: pip.size.height)

        if pip.isActivated {
          Button {
            pip.stop()
          } label: {
            Image(systemName: "stop.fill")
              .imageScale(.large)
              .foregroundColor(.accentColor)
          }
        } else {
          Button {
            pip.start()
          } label: {
            Image(systemName: "play.fill")
              .imageScale(.large)
              .foregroundColor(.accentColor)
          }
        }
      } else {
        ProgressView()
      }
    }
    .onAppear {
      deadline.resetIfNeeded()
    }
  }

  var remainingTime: Binding<Int> {
    switch context {
    case .sns:
      return $deadline.remainingSNSTime
    case .video:
      return $deadline.remainingVideoTime
    case .message:
      return $deadline.remainingMessageTime
    }
  }
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerPage(context: .sns)
  }
}


