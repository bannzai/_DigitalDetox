//
//  ContentView.swift
//  SocialDetox
//
//  Created by bannzai on 2022/12/25.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.displayScale) var displayScale
  @EnvironmentObject var pip: PiP
  @Clock var clock
  @State var remainingTime: TimeInterval? = 60 * 30

  var body: some View {
    let countdown = Countdown(remainingTime: remainingTime)
    VStack {
      PiPContainer()
        .onChange(of: clock.now) { _ in
          switch pip.progress {
          case .willStart, .didStart, .willStop:
            if let remainingTime {
              self.remainingTime = remainingTime - 1
            }
          case nil, .didStop:
            break
          }

          pip.enqueue(content: countdown, displayScale: displayScale)
        }
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
    }
    .background(Color.red)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
