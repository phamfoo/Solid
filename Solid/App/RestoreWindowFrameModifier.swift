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
                guard let window = notification.object as? NSWindow,
                      let windowID = window.identifier?.rawValue,
                      windowID.starts(with: "main")
                else { return }

                let windowFrame = Defaults[.mainWindowFrame]
                    ?? getInitialFrame(for: window)

                if shouldUpdateWindowFrame {
                    window.setFrame(windowFrame, display: true)
                    shouldUpdateWindowFrame = false
                }
            }
    }

    private func getInitialFrame(for window: NSWindow) -> NSRect {
        // When the app launches for the first time, the window's width
        // is 900, even if I set idealWidth to a different value.
        //
        // We'll use the intrinsic width of the content view (if available)
        // as the initial width for the window instead of 900.
        var windowSize = window.frame.size
        if let intrinsicWidth = window.contentView?.intrinsicContentSize.width,
           intrinsicWidth > 0
        {
            windowSize.width = intrinsicWidth
        }

        let offsetX = (window.frame.width - windowSize.width) / 2
        let origin = CGPoint(
            x: window.frame.origin.x + offsetX,
            y: window.frame.origin.y
        )

        return NSRect(
            origin: origin,
            size: windowSize
        )
    }
}

extension Defaults.Keys {
    static let mainWindowFrame = Key<CGRect?>("mainWindowFrame")
}

extension CGRect: Defaults.Serializable {}
