import SwiftUI

struct SaturationLightnessSlider: View {
    var hue: Double
    @Binding var saturation: Double
    @Binding var lightness: Double
    var colorSpace: ColorSpace

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // https://www.joshwcomeau.com/css/color-formats/#hsl-4
                LinearGradient(
                    colors: [Color.black, Color.white],
                    startPoint: .bottom,
                    endPoint: .top
                )

                LinearGradient(
                    colors: [
                        Color(
                            nsColor: NSColor(
                                colorSpace: colorSpace.nsColorSpace,
                                hue: hue,
                                saturation: 1,
                                lightness: 0.5,
                                alpha: 0
                            )
                        ),
                        Color(
                            nsColor: NSColor(
                                colorSpace: colorSpace.nsColorSpace,
                                hue: hue,
                                saturation: 1,
                                lightness: 0.5,
                                alpha: 1
                            )
                        ),
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .blendMode(.overlay)
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
                        y: -lightness * geometry.size.height
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        saturation = (value.location.x / geometry.size.width)
                            .clamped(to: 0 ... 1)
                        lightness = 1 -
                            (value.location.y / geometry.size.height)
                            .clamped(to: 0 ... 1)
                    }
            )
        }
    }

    private var currentColor: Color {
        Color(
            nsColor: NSColor(
                colorSpace: colorSpace.nsColorSpace,
                hue: hue,
                saturation: saturation,
                lightness: lightness,
                alpha: 1
            )
        )
    }
}

struct SaturationLightnessSlider_Previews: PreviewProvider {
    static var previews: some View {
        SaturationLightnessSlider(
            hue: 1,
            saturation: .constant(1),
            lightness: .constant(1),
            colorSpace: .sRGB
        )
        .previewLayout(.fixed(width: 320, height: 320))
    }
}
