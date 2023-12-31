import AppKit
import Defaults

class MenuBarProvider {
    private var statusBarItem: NSStatusItem?

    var onPickColorSelected: (() -> Void)?
    var onShowWindowSelected: (() -> Void)?
    var onQuitSelected: (() -> Void)?

    private lazy var menu: NSMenu = {
        let menu = NSMenu()
        let pickColorItem = NSMenuItem(
            title: "Pick color",
            action: #selector(handlePickColor),
            keyEquivalent: ""
        )
        pickColorItem.target = self
        menu.addItem(pickColorItem)

        let showItem = NSMenuItem(
            title: "Show",
            action: #selector(handleShowWindow),
            keyEquivalent: ""
        )
        showItem.target = self
        menu.addItem(showItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(handleQuit),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)

        return menu
    }()

    func setup(
        onPickColorSelected: @escaping () -> Void,
        onQuitSelected: @escaping () -> Void,
        onShowWindowSelected: @escaping () -> Void
    ) {
        if statusBarItem == nil {
            let newStatusBarItem = NSStatusBar.system
                .statusItem(withLength: NSStatusItem.squareLength)
            if let statusBarButton = newStatusBarItem.button {
                statusBarButton.image = NSImage(
                    systemSymbolName: "grid",
                    accessibilityDescription: "Color Picker"
                )
                statusBarButton.target = self
                statusBarButton.action = #selector(statusBarButtonClicked(_:))
                statusBarButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
            }

            statusBarItem = newStatusBarItem
        }

        self.onPickColorSelected = onPickColorSelected
        self.onQuitSelected = onQuitSelected
        self.onShowWindowSelected = onShowWindowSelected
    }

    @objc private func statusBarButtonClicked(_: NSStatusBarButton) {
        let event = NSApp.currentEvent!

        if event.type == .rightMouseUp {
            if Defaults[.rightClickMenuBarToPick] {
                handlePickColor()
            } else {
                simulateMenuBarClick()
            }
        } else if event.type == .leftMouseUp {
            simulateMenuBarClick()
        }
    }

    @objc private func handlePickColor() {
        if let onPickColorSelected {
            onPickColorSelected()
        }
    }

    @objc private func handleShowWindow() {
        if let onShowWindowSelected {
            onShowWindowSelected()
        }
    }

    @objc private func handleQuit() {
        if let onQuitSelected {
            onQuitSelected()
        }
    }

    private func simulateMenuBarClick() {
        statusBarItem!.menu = menu
        statusBarItem!.button?.performClick(nil)
        statusBarItem!.menu = nil
    }
}
