import Defaults
import SwiftUI

@main
struct SolidApp: App {
    @Default(.stayOnTop) private var stayOnTop

    let persistenceController = PersistenceController.shared
    @StateObject private var colorPublisher = ColorPublisher()
    @StateObject private var colorSampler = ColorSampler()

    // We need to keep this at the application level
    // so that the menu bar only gets initialized once.
    @State private var menuBarController = MenuBarController()

    var body: some Scene {
        WindowGroup {
            AppMenuBar(menuBarController: menuBarController) {
                ContentView()
            }
            .environmentObject(colorPublisher)
            .environmentObject(colorSampler)
            .environment(
                \.managedObjectContext,
                persistenceController.container.viewContext
            )
            // Update windows as stayOnTop changes
            // or when there's a new window
            .onChange(of: stayOnTop) { stayOnTop in
                updateWindowLevel(stayOnTop: stayOnTop)
            }
            .onReceive(
                NotificationCenter.default
                    .publisher(
                        for: NSWindow.didBecomeKeyNotification
                    )
            ) { _ in
                updateWindowLevel(stayOnTop: stayOnTop)
            }
            // Save and restore window frame manually
            .onReceive(
                NotificationCenter.default
                    .publisher(
                        for: NSWindow.willCloseNotification
                    )
            ) { notification in
                if let window = notification.object as? NSWindow,
                   window == NSApplication.shared.mainWindow
                {
                    Defaults[.mainWindowFrame] = window.frame
                }
            }
            .onReceive(
                NotificationCenter.default
                    .publisher(
                        for: NSWindow.didBecomeKeyNotification
                    )
            ) { notification in
                if let window = notification.object as? NSWindow,
                   let savedWindowFrame = Defaults[.mainWindowFrame]
                {
                    window.setFrame(savedWindowFrame, display: true)
                }
            }
        }
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            CommandGroup(replacing: CommandGroupPlacement.newItem) {}
        }

        Settings {
            AppSettings()
        }
    }

    private func updateWindowLevel(stayOnTop: Bool) {
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

extension Defaults.Keys {
    static let mainWindowFrame = Key<CGRect?>("mainWindowFrame")
}

extension CGRect: Defaults.Serializable {}
