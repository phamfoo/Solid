import SwiftUI

struct SolidButtonStyle: ButtonStyle {
    @State private var hovered = false

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .opacity(configuration.isPressed ? 0.64 : 1)
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.quaternary)
                    .opacity(hovered ? 1 : 0)
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .onHover { hovered in
                self.hovered = hovered
            }
            .animation(.easeInOut(duration: 0.1), value: hovered)
            .animation(
                .easeInOut(duration: 0.1),
                value: configuration.isPressed
            )
    }
}

extension ButtonStyle where Self == SolidButtonStyle {
    static var solid: SolidButtonStyle {
        SolidButtonStyle()
    }
}
