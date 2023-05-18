import SwiftUI

struct SaturationBrightnessSlider: View {
    var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double
    var colorSpace: ColorSpace

    var body: some View {
        GeometryReader { geometry in
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
            .overlay(alignment: .bottomLeading) {
                Circle()
                    .fill(currentColor)
                    .overlay {
                        Circle()
                            .strokeBorder(.white, lineWidth: 2)
                    }
                    .frame(width: 16, height: 16)
                    .offset(x: -8, y: 8)
                    .offset(
                        x: saturation * geometry.size.width,
                        y: -brightness * geometry.size.height
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        saturation = (value.location.x / geometry.size.width)
                            .clamped(to: 0 ... 1)
                        brightness = 1 -
                            (value.location.y / geometry.size.height)
                            .clamped(to: 0 ... 1)
                    }
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
