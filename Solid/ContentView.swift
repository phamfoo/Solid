import SwiftUI

struct ContentView: View {
    @State private var tab = Tab.editor

    var body: some View {
        TabView(selection: $tab) {
            Editor()
                .tabItem {
                    Text("Editor")
                }
                .tag(Tab.editor)

            ColorList()
                .tabItem {
                    Text("Colors")
                }
                .tag(Tab.colors)
        }
        .frame(minWidth: 320)
    }
}

private enum Tab {
    case editor
    case colors
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 320, height: 480))
    }
}
