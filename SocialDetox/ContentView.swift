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
      countdown
        .onChange(of: clock.now) { _ in
          if pip.isActivated {
            if pip.isPlaying, let remainingTime {
              self.remainingTime = remainingTime - 1
            }

            pip.enqueue(content: countdown, displayScale: displayScale)
          }
        }

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
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
