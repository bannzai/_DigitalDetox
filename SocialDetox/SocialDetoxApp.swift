//
//  SocialDetoxApp.swift
//  SocialDetox
//
//  Created by bannzai on 2022/12/25.
//

import SwiftUI
import AVKit

@main
struct SocialDetoxApp: App {
  @StateObject var pip = PiP()

  init() {
    do {
      // Workaround for prevent warning to set defaultToSpeaker options.
      // https://developer.apple.com/forums/thread/714598
      try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("AudioSession throw error: \(error)")
    }
  }

  var body: some Scene {
        WindowGroup {
          if AVPictureInPictureController.isPictureInPictureSupported() {
            ContentView()
              .environmentObject(pip)
          } else {
            Text("Unsupported device")
          }
        }
    }
}
