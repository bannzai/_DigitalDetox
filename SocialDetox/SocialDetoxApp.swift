//
//  SocialDetoxApp.swift
//  SocialDetox
//
//  Created by bannzai on 2022/12/25.
//

import UIKit
import SwiftUI
import AVKit

@main
struct SocialDetoxApp: App {

  init() {
  }

  var body: some Scene {
        WindowGroup {
          if AVPictureInPictureController.isPictureInPictureSupported() {
            ContentView()
          } else {
            Text("Unsupported device")
          }
        }
    }
}
