import SwiftUI

struct AppMenuBar<Content>: View where Content: View {
    var menuBarController: MenuBarController

    @EnvironmentObject private var colorPublisher: ColorPublisher
    @EnvironmentObject private var colorSampler: ColorSampler
    @ViewBuilder var content: Content

    var body: some View {
        content
            .onAppear {
                menuBarController.setup(
                    onPickColorSelected: {
                        colorSampler
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
    var onPickColorSelected: (() -> Void)?
    private lazy var statusBarItem = NSStatusBar.system
        .statusItem(withLength: NSStatusItem.squareLength)

    func setup(onPickColorSelected: @escaping () -> Void) {
        self.onPickColorSelected = onPickColorSelected

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
        if let onPickColorSelected {
            onPickColorSelected()
        }
    }

    @objc private func quitSelected() {
        NSApp.terminate(nil)
    }
}
