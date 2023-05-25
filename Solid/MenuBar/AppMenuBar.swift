import SwiftUI

struct AppMenuBar<Content>: View where Content: View {
    @State private var menuBarController: MenuBarController?

    @EnvironmentObject private var colorPublisher: ColorPublisher
    @ViewBuilder var content: Content

    var body: some View {
        content
            .onAppear {
                menuBarController = MenuBarController(
                    onPickColorSelected: {
                        // TODO:
                        NSColorSampler()
                            .show { pickedColor in
                                if let pickedColor {
                                    colorPublisher.publish(
                                        pickedColor,
                                        source: "PickColorMenu"
                                    )
                                }
                            }
                    }
                )
            }
    }
}

class MenuBarController {
    private var statusBarItem: NSStatusItem
    var onPickColorSelected: () -> Void

    init(onPickColorSelected: @escaping () -> Void) {
        self.onPickColorSelected = onPickColorSelected

        statusBarItem = NSStatusBar.system
            .statusItem(withLength: NSStatusItem.squareLength)
        statusBarItem.button?.image = NSImage(
            systemSymbolName: "grid",
            accessibilityDescription: "Color Picker"
        )

        let menu = NSMenu()
        let pickColorItem = NSMenuItem(
            title: "Pick color",
            action: #selector(pickColorSelected),
            keyEquivalent: ""
        )
        pickColorItem.target = self
        menu.addItem(pickColorItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quitSelected),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        statusBarItem.menu = menu
    }

    @objc private func pickColorSelected() {
        onPickColorSelected()
    }

    @objc private func quitSelected() {
        NSApp.terminate(nil)
    }
}
