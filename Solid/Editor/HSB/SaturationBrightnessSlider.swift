import SwiftUI

struct SaturationBrightnessSlider: View {
    var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    var colorSpace: ColorSpace

    var body: some View {
        DualAxisSlider(horizontal: $saturation, vertical: $brightness) {
            ZStack {
                fullySaturatedColor

                LinearGradient(
                    colors: [.white, .white.opacity(0)],
                    startPoint: .leading,
                    endPoint: .trailing
                )

                LinearGradient(
                    colors: [.black, .black.opacity(0)],
                    startPoint: .bottom,
                    endPoint: .top
                )
            }
        } cursor: {
            Circle()
                .fill(currentColor)
                .overlay {
                    Circle()
                        .strokeBorder(.white, lineWidth: 2)
                }
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

    private var currentColor: Color {
        Color(
            nsColor: NSColor(
                colorSpace: colorSpace.nsColorSpace,
                hue: hue,
                saturation: saturation,
                brightness: brightness,
                alpha: 1
            )
        )
    }
}

struct SaturationBrightnessSlider_Previews: PreviewProvider {
    static var previews: some View {
        SaturationBrightnessSlider(
            hue: 1,
            saturation: .constant(1),
            brightness: .constant(1),
            colorSpace: .sRGB
        )
        .previewLayout(.fixed(width: 320, height: 320))
    }
}
