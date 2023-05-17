import SwiftUI

struct RGBAInputGroup: View {
    @State private var hovered = false
    @FocusState private var focusField: FocusField?
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    @Binding var alpha: Double

    var body: some View {
        HStack(spacing: 0) {
            NumberInput(
                "R",
                normalizedValue: $red,
                in: 0 ... 255
            )
            .focused($focusField, equals: .hue)
            .padding(.vertical, 12)

            divider

            NumberInput(
                "G",
                normalizedValue: $green,
                in: 0 ... 255
            )
            .focused($focusField, equals: .saturation)
            .padding(.vertical, 12)

            divider

            NumberInput(
                "B",
                normalizedValue: $blue,
                in: 0 ... 255
            )
            .focused($focusField, equals: .brightness)
            .padding(.vertical, 12)

            divider

            PercentageInput("A", normalizedValue: $alpha)
                .focused($focusField, equals: .alpha)
                .padding(.vertical, 12)
        }
        .fixedSize(horizontal: false, vertical: true)
        .textFieldStyle(.plain)
        .multilineTextAlignment(.center)
        .onHover { hovered in
            self.hovered = hovered
        }
        .onExitCommand {
            focusField = nil
        }
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(.quaternary)
                .opacity(hovered ? 1 : 0)
        }
        .background {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color.accentColor)
                .opacity(focused ? 1 : 0)
        }
    }

    private var focused: Bool {
        focusField != nil
    }

    private var divider: some View {
        Divider()
            .padding(.vertical, 8)
            .opacity(hovered || focusField != nil ? 1 : 0)
    }
}

private enum FocusField {
    case hue
    case saturation
    case brightness
    case alpha
}

struct RGBAInputGroup_Previews: PreviewProvider {
    static var previews: some View {
        RGBAInputGroup(
            red: .constant(1),
            green: .constant(1),
            blue: .constant(1),
            alpha: .constant(1)
        )
        .frame(width: 320)
    }
}
