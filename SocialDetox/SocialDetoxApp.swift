//
//  SocialDetoxApp.swift
//  SocialDetox
//
//  Created by bannzai on 2022/12/25.
//

import SwiftUI
import AVFAudio

@main
struct SocialDetoxApp: App {
  @StateObject var pip = PiP()

  init() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .moviePlayback)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("AudioSession throw error: \(error)")
    }
  }

  var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(pip)
        }
    }
}
