import SwiftUI

struct InputGroup<Content>: View where Content: View {
    @State private var hovered = false
    @FocusState private var focused: Bool

    @ViewBuilder var content: Content

    var body: some View {
        _VariadicView
            .Tree(DividedHStackLayout(shouldShowDivider: hovered || focused)) {
                content
            }
            .focused($focused)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .onHover { hovered in
                self.hovered = hovered
            }
            .onExitCommand {
                focused = false
            }
            .background {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(.quaternary)
                    .opacity(hovered ? 1 : 0)
            }
            .background {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .strokeBorder(Color.accentColor)
                    .opacity(focused ? 1 : 0)
            }
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
