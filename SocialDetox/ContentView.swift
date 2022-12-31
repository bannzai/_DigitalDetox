import SwiftUI

struct ContentView: View {
  @StateObject var pip = PiP()
  var body: some View {
    ServicesPage()
      .environmentObject(pip)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
