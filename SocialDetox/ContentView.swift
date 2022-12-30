import SwiftUI

struct ContentView: View {
  var body: some View {
    List {
      Section("Header 1") {
        Text("1")
        Text("2")
        Text("3")
      }
      Section("Header 2") {
        Text("1")
        Text("2")
        Text("3")
      }
    }
    .listStyle(.insetGrouped)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
