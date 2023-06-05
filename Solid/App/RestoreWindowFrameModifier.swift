import Defaults
import SwiftUI

struct RestoreWindowFrameModifier: ViewModifier {
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
