import SwiftUI
import AVKit

struct TimerPage: View {
  @StateObject var deadline = Deadline.shared

  let service: Service

  var body: some View {
    if !AVPictureInPictureController.isPictureInPictureSupported() {
      UnsupportedPiPBody(service: service, remainingTime: deadline.remainingTime(for: service.category))
    } else {
      PictureInPictureBody(service: service, deadline: deadline, remainingTime: deadline.remainingTime(for: service.category))
    }
  }
  // FIXME:: Why canOpenURL return false when pass custom schema URL
  //     if let url = URL(string: service.urlScheme), UIApplication.shared.canOpenURL(url) {
  // } else {
  //      Text("Can't open \(service.name) app. Please confirm of app is installed")
  //    }

  struct UnsupportedPiPBody: View {
    @Clock var clock
    @State var isRunning = false

    let service: Service
    @Binding var remainingTime: Int

    var body: some View {
      VStack(spacing: 10) {
        Countdown(remainingTime: remainingTime)

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
        if isRunning, remainingTime > 0 {
          remainingTime = remainingTime - 1
        }
      }
      .onChange(of: remainingTime, perform: { remainingTime in
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
    @Binding var remainingTime: Int

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
              pip.enqueue(content: Countdown(remainingTime: remainingTime), displayScale: displayScale)

              switch pip.progress {
              case .didStart:
                if pip.isPlaying, remainingTime > 0 {
                  remainingTime = remainingTime - 1
                }
              case nil, .willStart, .willStop, .didStop:
                return
              }
            }
            .onChange(of: remainingTime, perform: { remainingTime in
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


