import SwiftUI

@main
struct SolidApp: App {
    private let persistenceController = PersistenceController()
    @StateObject private var colorPublisher = ColorPublisher()
    @StateObject private var colorSampler = ColorSampler()

    // We need to keep this at the application level
    // so that the menu bar only gets initialized once.
    private let menuBarProvider = MenuBarProvider()

    var body: some Scene {
        WindowGroup(id: "main") {
            AppMenuBar(menuBarProvider: menuBarProvider) {
                ContentView()
            }
            .environmentObject(colorPublisher)
            .environmentObject(colorSampler)
            .environment(
                \.managedObjectContext,
                persistenceController.container.viewContext
            )
            .modifier(SyncStayOnTopModifier())
            .modifier(RestoreWindowFrameModifier(windowGroupID: "main"))
        }
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {}
        }
        .handlesExternalEvents(matching: ["solidapp://newwindow"])

        Settings {
            AppSettings()
        }
    }
}
