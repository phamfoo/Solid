import SwiftUI

struct AppMenuBar<Content>: View where Content: View {
    var menuBarProvider: MenuBarProvider

    @EnvironmentObject private var colorPublisher: ColorPublisher
    @EnvironmentObject private var colorSampler: ColorSampler
    @ViewBuilder var content: Content

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
                        if let pickedColor {
                            colorPublisher.publish(
                                pickedColor,
                                source: "PickColorMenu"
                            )
                        }
                    }
            }, onQuitSelected: {
                NSApp.terminate(nil)
            }
        )
    }
}
