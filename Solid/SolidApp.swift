import Defaults
import SwiftUI

@main
struct SolidApp: App {
    @Default(.stayOnTop) private var stayOnTop

    let persistenceController = PersistenceController.shared
    @StateObject private var colorPublisher = ColorPublisher()

    var body: some Scene {
        WindowGroup {
            AppMenuBar {
                ContentView()
            }
            .environmentObject(colorPublisher)
            .environment(
                \.managedObjectContext,
                persistenceController.container.viewContext
            )
            .onChange(of: stayOnTop) { stayOnTop in
                if stayOnTop {
                    NSApplication.shared.windows
                        .filter { $0.level == .normal }
                        .forEach { $0.level = .floating }
                } else {
                    NSApplication.shared.windows
                        .filter { $0.level == .floating }
                        .forEach { $0.level = .normal }
                }
            }
            .onReceive(
                NotificationCenter.default
                    .publisher(
                        for: NSWindow.didBecomeKeyNotification
                    )
            ) { _ in
                if stayOnTop {
                    NSApplication.shared.windows
                        .filter { $0.level == .normal }
                        .forEach { $0.level = .floating }
                } else {
                    NSApplication.shared.windows
                        .filter { $0.level == .floating }
                        .forEach { $0.level = .normal }
                }
            }
        }
        .windowToolbarStyle(.unified(showsTitle: false))

        Settings {
            AppSettings()
        }
    }
}
