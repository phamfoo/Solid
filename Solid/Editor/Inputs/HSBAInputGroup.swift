import SwiftUI

struct HSBAInputGroup: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    @Binding var alpha: Double

    var body: some View {
        InputGroup {
            NumberInput(
                "H",
                normalizedValue: $hue,
                in: 0 ... 360
            )
            .padding(.vertical, 12)

            NumberInput(
                "S",
                normalizedValue: $saturation,
                in: 0 ... 100
            )
            .padding(.vertical, 12)

            NumberInput(
                "B",
                normalizedValue: $brightness,
                in: 0 ... 100
            )
            .padding(.vertical, 12)

            PercentageInput("A", normalizedValue: $alpha)
                .padding(.vertical, 12)
        }
    }
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
