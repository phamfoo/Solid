import SwiftUI

struct RGBAInputGroup: View {
    @Binding var red: Double
    @Binding var green: Double
    @Binding var blue: Double
    @Binding var alpha: Double

    var body: some View {
        InputGroup {
            NumberInput(
                "R",
                normalizedValue: $red,
                in: 0 ... 255
            )
            .padding(.vertical, 12)

            NumberInput(
                "G",
                normalizedValue: $green,
                in: 0 ... 255
            )
            .padding(.vertical, 12)

            NumberInput(
                "B",
                normalizedValue: $blue,
                in: 0 ... 255
            )
            .padding(.vertical, 12)

            PercentageInput("A", normalizedValue: $alpha)
                .padding(.vertical, 12)
        }
    }
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
