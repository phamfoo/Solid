import Defaults
import SwiftUI

struct AppMenuBar<Content>: View where Content: View {
    var menuBarProvider: MenuBarProvider

    @Default(.colorSpace) private var colorSpace
    @EnvironmentObject private var colorPublisher: ColorPublisher
    @EnvironmentObject private var colorSampler: ColorSampler
    @ViewBuilder var content: Content
    @Environment(\.openURL) var openURL

    var body: some View {
        content
            .onAppear {
                setupMenuBar()
            }
    }

    private func setupMenuBar() {
        menuBarProvider.setup(
            onPickColorSelected: {
                colorSampler
                    .show { pickedColor in
                        if let pickedColorInCurrentColorSpace = pickedColor?
                            .usingColorSpace(colorSpace.nsColorSpace)
                        {
                            colorPublisher.publish(
                                pickedColorInCurrentColorSpace,
                                source: "PickColorMenu"
                            )
                        }
                    }
            }, onQuitSelected: {
                NSApp.terminate(nil)
            }, onShowWindowSelected: {
                let application = NSApplication.shared

                if application.windows.filter({ $0.level == .normal }).isEmpty {
                    openURL(URL(string: "solidapp://newwindow")!)
                } else {
                    application.activate(ignoringOtherApps: true)
                }
            }
        )
    }
}
