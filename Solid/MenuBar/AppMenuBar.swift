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
    private lazy var menu: NSMenu = {
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

        return menu
    }()

    private lazy var statusBarItem = NSStatusBar.system
        .statusItem(withLength: NSStatusItem.squareLength)

    func setup(onPickColorSelected: @escaping () -> Void) {
        self.onPickColorSelected = onPickColorSelected

        if let statusBarButton = statusBarItem.button {
            statusBarButton.image = NSImage(
                systemSymbolName: "grid",
                accessibilityDescription: "Color Picker"
            )
            statusBarButton.target = self
            statusBarButton.action = #selector(statusBarButtonClicked(_:))
            statusBarButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    @objc func statusBarButtonClicked(_: NSStatusBarButton) {
        let event = NSApp.currentEvent!

        if event.type == .rightMouseUp {
            pickColorSelected()
        } else if event.type == .leftMouseUp {
            statusBarItem.menu = menu
            statusBarItem.button?.performClick(nil)
            statusBarItem.menu = nil
        }
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
