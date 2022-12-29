//
//  ContentView.swift
//  SocialDetox
//
//  Created by bannzai on 2022/12/25.
//

import SwiftUI

struct ContentView: View {
  @State var goal: Date? = .now.addingTimeInterval(60 * 30)

  var body: some View {
        VStack {
          Countdown(goal: goal)
            .rendered(id: goal) { image in
              let buffer = try? image?.sampleBuffer()
              dump(buffer)
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
