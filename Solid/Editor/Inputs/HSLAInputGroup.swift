import SwiftUI

struct HSLAInputGroup: View {
    @Binding var hue: Double
    @Binding var saturation: Double
    @Binding var lightness: Double
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
                "L",
                normalizedValue: $lightness,
                in: 0 ... 100
            )
            .padding(.vertical, 12)

            PercentageInput("A", normalizedValue: $alpha)
                .padding(.vertical, 12)
        }
    }
}

struct HSLAInputGroup_Previews: PreviewProvider {
    static var previews: some View {
        HSLAInputGroup(
            hue: .constant(1),
            saturation: .constant(1),
            lightness: .constant(1),
            alpha: .constant(1)
        )
        .frame(width: 320)
    }
}
