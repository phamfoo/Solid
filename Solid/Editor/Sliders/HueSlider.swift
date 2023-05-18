import SwiftUI

struct HueSlider: View {
    @Binding var hue: Double

    var body: some View {
        Slider(value: $hue) {
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
        } thumb: {
            Circle()
                .fill(fullySaturatedColor)
                .overlay {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                        .padding(2)
                }
        }
    }

    private var colors: [Color] {
        Array(stride(from: 0.0, to: 361.0, by: 30.0))
            .map { $0 / 360 }
            .map { Color(hue: $0, saturation: 1, brightness: 1) }
    }

    private var fullySaturatedColor: Color {
        Color(hue: hue, saturation: 1, brightness: 1)
    }
}

struct HueSlider_Previews: PreviewProvider {
    static var previews: some View {
        HueSlider(hue: .constant(0.5))
            .frame(width: 320, height: 32)
    }
}
