import SwiftUI

struct HSBAInputGroup: View {
    @State private var hovered = false
    @FocusState private var focusField: FocusField?
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    @Binding var alpha: Double

    var body: some View {
        HStack(spacing: 0) {
            NumberInput(
                "H",
                normalizedValue: $hue,
                in: 0 ... 360
            )
            .focused($focusField, equals: .hue)
            .padding(.vertical, 12)

            divider

            NumberInput(
                "S",
                normalizedValue: $saturation,
                in: 0 ... 100
            )
            .focused($focusField, equals: .saturation)
            .padding(.vertical, 12)

            divider

            NumberInput(
                "B",
                normalizedValue: $brightness,
                in: 0 ... 100
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

struct HSBAInputGroup_Previews: PreviewProvider {
    static var previews: some View {
        HSBAInputGroup(
            hue: .constant(1),
            saturation: .constant(1),
            brightness: .constant(1),
            alpha: .constant(1)
        )
        .frame(width: 320)
    }
}
