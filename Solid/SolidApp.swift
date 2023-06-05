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
        WindowGroup(id: "main") {
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
            .modifier(RestoreWindowFrameModifier(windowGroupID: "main"))
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

private struct RestoreWindowFrameModifier: ViewModifier {
    @State private var shouldUpdateWindowFrame = true

    var windowGroupID: String

    func body(content: Content) -> some View {
        content
            // Save and restore window frame manually
            .onReceive(
                NotificationCenter.default
                    .publisher(
                        for: NSWindow.willCloseNotification
                    )
            ) { notification in
                if let window = notification.object as? NSWindow,
                   let windowID = window.identifier?.rawValue,
                   windowID.starts(with: windowGroupID)
                {
                    Defaults[.mainWindowFrame] = window.frame
                    shouldUpdateWindowFrame = true
                }
            }
            .onReceive(
                NotificationCenter.default
                    .publisher(
                        for: NSWindow.didBecomeMainNotification
                    )
            ) { notification in
                if let window = notification.object as? NSWindow,
                   let windowID = window.identifier?.rawValue,
                   windowID.starts(with: "main"),
                   let savedWindowFrame = Defaults[.mainWindowFrame]
                {
                    if shouldUpdateWindowFrame {
                        window.setFrame(savedWindowFrame, display: true)
                        shouldUpdateWindowFrame = false
                    }
                }
            }
    }
}

extension Defaults.Keys {
    static let mainWindowFrame = Key<CGRect?>("mainWindowFrame")
}

extension CGRect: Defaults.Serializable {}
