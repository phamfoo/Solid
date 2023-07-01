import SwiftUI

struct InputGroup<Content>: View where Content: View {
    @State private var isHovered = false
    @FocusState private var isFocused: Bool

    @ViewBuilder var content: Content

    var body: some View {
        _VariadicView
            .Tree(DividedHStackLayout(
                shouldShowDivider: isHovered ||
                    isFocused
            )) {
                content
            }
            .focused($isFocused)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .onHover { isHovered in
                self.isHovered = isHovered
            }
            .onExitCommand {
                isFocused = false
            }
            .background {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(.quaternary)
                    .opacity(isHovered ? 1 : 0)
            }
            .background {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(Color.accentColor)
                    .scaleEffect(isFocused ? 1 : 1.05)
                    .opacity(isFocused ? 1 : 0)
            }
            .animation(.easeOut(duration: 0.1), value: isFocused)
            .animation(.easeOut(duration: 0.1), value: isHovered)
    }
}

// https://movingparts.io/variadic-views-in-swiftui
struct DividedHStackLayout: _VariadicView_UnaryViewRoot {
    var shouldShowDivider: Bool

    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        let last = children.last?.id

        HStack(spacing: 0) {
            ForEach(children) { child in
                child

                if child.id != last {
                    Divider()
                        .padding(.vertical, 8)
                        .opacity(shouldShowDivider ? 1 : 0)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
