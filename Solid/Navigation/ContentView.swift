import SwiftUI

struct ContentView: View {
    @State private var tab = Tab.editor

    var body: some View {
        SolidTabView(
            tabs: [
                TabConfig(
                    title: "Editor",
                    content: AnyView(Editor()),
                    tab: .editor
                ),
                TabConfig(
                    title: "Colors",
                    content: AnyView(ColorList()),
                    tab: .colors
                ),
            ],
            currentTab: tab
        )
        .toolbar {
            ToolbarItemGroup {
                Spacer()

                Picker("Tab", selection: $tab) {
                    Label("Editor", systemImage: "slider.horizontal.3")
                        .tag(Tab.editor)

                    Label("Colors", systemImage: "rectangle.grid.2x2")
                        .tag(Tab.colors)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 320, height: 480))
    }
}
