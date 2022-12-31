import SwiftUI

struct TimerPage: View {
  @Environment(\.displayScale) var displayScale
  @EnvironmentObject var pip: PiP
  @Clock var clock
  @State var remainingTime: TimeInterval? = 1 * 30

  var body: some View {
    let countdown = Countdown(remainingTime: remainingTime)
    VStack {
      if pip.canStart {
        PiPContainer()
          .onChange(of: clock.now) { _ in
            switch pip.progress {
            case .willStart, .didStart:
              if let remainingTime, remainingTime > 0 {
                self.remainingTime = remainingTime - 1
              }
            case nil, .willStop, .didStop:
              break
            }

            pip.enqueue(content: countdown, displayScale: displayScale)
          }
          .onChange(of: remainingTime, perform: { remainingTime in
            guard let remainingTime, remainingTime <= 0 else {
              return
            }
            print(remainingTime)
          })
          .frame(width: pip.size.width, height: pip.size.height)
          .border(Color.yellow)



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
    .background(Color.red)
  }
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerPage()
  }
}


