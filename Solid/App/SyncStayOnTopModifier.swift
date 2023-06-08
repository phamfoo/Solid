import Defaults
import SwiftUI

struct SyncStayOnTopModifier: ViewModifier {
    @Default(.stayOnTop) private var stayOnTop

    func body(content: Content) -> some View {
        content
            // Update windows as stayOnTop changes
            // or when there's a new window
            .onChange(of: stayOnTop) { newValue in
                updateWindowLevel(stayOnTop: newValue)
            }
            .onReceive(
                NotificationCenter.default
                    .publisher(
                        for: NSWindow.didBecomeKeyNotification
                    )
            ) { _ in
                updateWindowLevel(stayOnTop: stayOnTop)
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
