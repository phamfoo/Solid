import Defaults
import SwiftUI

@main
struct SolidApp: App {
    @Default(.stayOnTop) private var stayOnTop

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
                .onChange(of: stayOnTop) { stayOnTop in
                    for window in NSApplication.shared.windows {
                        if stayOnTop {
                            window.level = .floating
                        } else {
                            window.level = .normal
                        }
                    }
                }
                .onReceive(
                    NotificationCenter.default
                        .publisher(
                            for: NSWindow.didBecomeKeyNotification
                        )
                ) { _ in
                    for window in NSApplication.shared.windows {
                        if stayOnTop {
                            window.level = .floating
                        } else {
                            window.level = .normal
                        }
                    }
                }
        }
        .windowToolbarStyle(.unified(showsTitle: false))

        Settings {
            AppSettings()
        }
    }
}
