import SwiftUI

struct ContentView: View {
  @StateObject var pip = PiP()

  var body: some View {
    NavigationStack {
      ServicesPage()
        .environmentObject(pip)
        .toolbar(content: {
          ToolbarItem(placement: .navigationBarTrailing, content: {
            NavigationLink(destination: SettingPage(), label: {
              Image(systemName: "gearshape.fill")
            })
          })
        })
    }
  }
}

