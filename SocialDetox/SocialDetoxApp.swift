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
