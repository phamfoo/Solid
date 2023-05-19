import SwiftUI

struct HueSlider: View {
    @Binding var hue: Double
    var colorSpace: ColorSpace

    var body: some View {
        Slider(value: $hue) {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    colors
                        .first
                        .frame(width: geometry.size.height / 2)
                    LinearGradient(
                        colors: colors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    colors
                        .last
                        .frame(width: geometry.size.height / 2)
                }
            }
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
            .map { normalizedHue in
                Color(
                    nsColor: NSColor(
                        colorSpace: colorSpace.nsColorSpace,
                        hue: normalizedHue,
                        saturation: 1,
                        brightness: 1,
                        alpha: 1
                    )
                )
            }
    }

    private var fullySaturatedColor: Color {
        Color(
            nsColor: NSColor(
                colorSpace: colorSpace.nsColorSpace,
                hue: hue,
                saturation: 1,
                brightness: 1,
                alpha: 1
            )
        )
    }
}

struct HueSlider_Previews: PreviewProvider {
    static var previews: some View {
        HueSlider(hue: .constant(0.5), colorSpace: .sRGB)
            .frame(width: 320, height: 32)
    }
}
