import SwiftUI

struct SolidButtonStyle: ButtonStyle {
    @State private var isHovered = false

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .opacity(configuration.isPressed ? 0.64 : 1)
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .fill(.quaternary)
                    .opacity(isHovered ? 1 : 0)
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .onHover { isHovered in
                self.isHovered = isHovered
            }
            .animation(.easeOut(duration: 0.1), value: isHovered)
            .animation(
                .easeOut(duration: 0.1),
                value: configuration.isPressed
            )
    }
}

extension ButtonStyle where Self == SolidButtonStyle {
    static var solid: SolidButtonStyle {
        SolidButtonStyle()
    }
}
