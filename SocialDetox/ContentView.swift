import SwiftUI

struct ContentView: View {
  @StateObject var pip = PiP()
  var body: some View {
    TimerPage()
      .environmentObject(pip)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
