import SwiftUI

struct ContentView: View {

  var body: some View {
    NavigationStack {
      ServicesPage()
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

