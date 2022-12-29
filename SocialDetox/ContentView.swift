//
//  ContentView.swift
//  SocialDetox
//
//  Created by bannzai on 2022/12/25.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.displayScale) var displayScale
  @Clock var clock
  @State var remainingTime: TimeInterval? = 60 * 30

  var body: some View {
    VStack {
      Countdown(remainingTime: remainingTime)
        .onChange(of: clock.now) { _ in
          let image = render(content: Countdown(remainingTime: remainingTime).frame(height: 60), displayScale: displayScale, size: CGSize(width: UIScreen.main.bounds.width, height: 60))
          do {
            let buffer = try image?.sampleBuffer(displayScale: displayScale)
            dump(buffer)
          } catch {
            print(error)
          }
        }

      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Hello, world!")
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
