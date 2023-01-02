import SwiftUI
import AVKit

struct TimerPage: View {
  @StateObject var deadline = Deadline.shared

  let service: Service

  var body: some View {
    if !AVPictureInPictureController.isPictureInPictureSupported() {
      UnsupportedPiPBody(service: service, remainingTime: remainingTime)
    } else {
      PictureInPictureBody(service: service, deadline: deadline, remainingTime: remainingTime)
    }
  }

  var remainingTime: Binding<Int> {
    switch service.category {
    case .sns:
      return $deadline.remainingSNSTime
    case .video:
      return $deadline.remainingVideoTime
    case .message:
      return $deadline.remainingMessageTime
    }
  }

  struct UnsupportedPiPBody: View {
    @Clock var clock
    @State var isRunning = false

    let service: Service
    let remainingTime: Binding<Int>

    var body: some View {
      VStack(spacing: 10) {
        Countdown(remainingTime: remainingTime.wrappedValue)

        if isRunning {
          Button {
            isRunning = false
          } label: {
            Image(systemName: "stop.fill")
              .imageScale(.large)
              .foregroundColor(.accentColor)
          }
        } else {
          Button {
            isRunning = true

            if let url = URL(string: service.urlScheme) {
              UIApplication.shared.open(url)
            }
          } label: {
            Image(systemName: "play.fill")
              .imageScale(.large)
              .foregroundColor(.accentColor)
          }
        }

        Text("Unsupported picture in picture device")
      }
      .onChange(of: clock.now) { _ in
        if isRunning, remainingTime.wrappedValue > 0 {
          self.remainingTime.wrappedValue = remainingTime.wrappedValue - 1
        }
      }
      .onChange(of: remainingTime.wrappedValue, perform: { remainingTime in
        if remainingTime <= 0 {
          // TODO: Reach deadline
        }
      })
    }
  }

  struct PictureInPictureBody: View {
    @Environment(\.displayScale) var displayScale
    @Clock var clock
    @StateObject var pip = PiP.shared

    let service: Service
    @ObservedObject var deadline: Deadline
    let remainingTime: Binding<Int>

    var body: some View {
      VStack(spacing: 10) {
        if pip.canStart {
          Image(service.iconName)
            .resizable()
            .scaledToFill()
            .frame(width: 60, height: 60)
            .background(service.iconBackgroundColor)
            .cornerRadius(4)

          VStack(alignment: .leading) {
            Text(service.name)
          }

          PiPContainer(pip: pip)
            .onChange(of: clock.now) { _ in
              // Keep enqueue content every time. If stop picture in picture and queue is empty, PiPContainer is blank.
              pip.enqueue(content: Countdown(remainingTime: remainingTime.wrappedValue), displayScale: displayScale)

              switch pip.progress {
              case .didStart:
                if pip.isPlaying, remainingTime.wrappedValue > 0 {
                  self.remainingTime.wrappedValue = remainingTime.wrappedValue - 1
                }
              case nil, .willStart, .willStop, .didStop:
                return
              }
            }
            .onChange(of: remainingTime.wrappedValue, perform: { remainingTime in
              if remainingTime <= 0 {
                // TODO: Reach deadline
              }
            })
            .onChange(of: pip.progress, perform: { progress in
              guard case .didStart = progress else {
                return
              }

              if let url = URL(string: service.urlScheme) {
                UIApplication.shared.open(url)
              }
            })
            .frame(width: pip.size.width, height: pip.size.height)
            .alert(error: $pip.launchError)

          // Button
          Group {
            if case .willStart = pip.progress {
              Button {

              } label: {
                ProgressView()
              }
              .disabled(true)
            } else {
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
  }
}

struct TimerPage_Previews: PreviewProvider {
  static var previews: some View {
    TimerPage(service: .twitter)
  }
}


