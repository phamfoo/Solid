import SwiftUI

struct HSLEditor: View {
    @Binding var colorSpace: ColorSpace
    @Binding var colorModel: ColorModel
    var colorPublisher: ColorPublisher

    @State private var hue: Double
    @State private var saturation: Double
    @State private var lightness: Double
    @State private var alpha: Double

    init(
        colorSpace: Binding<ColorSpace>,
        colorModel: Binding<ColorModel>,
        colorPublisher: ColorPublisher
    ) {
        _colorSpace = colorSpace
        _colorModel = colorModel
        self.colorPublisher = colorPublisher

        let color = colorPublisher.currentColor
        hue = color.hueComponent
        saturation = color.hslSaturation
        lightness = color.lightness
        alpha = color.alphaComponent
    }

    var body: some View {
        VStack(spacing: 0) {
            SaturationLightnessSlider(
                hue: hue,
                saturation: $saturation,
                lightness: $lightness,
                colorSpace: colorSpace
            )
            .aspectRatio(1, contentMode: .fit)
            .frame(minHeight: 320)

            HStack(spacing: 0) {
                ColorSamplerView { pickedColor in
                    if let pickedColorInCurrentColorSpace =
                        pickedColor.usingColorSpace(colorSpace.nsColorSpace)
                    {
                        syncComponents(from: pickedColorInCurrentColorSpace)
                    }
                }
                .padding(8)

                VStack {
                    HueSlider(hue: $hue, colorSpace: colorSpace)
                        .frame(height: 24)

                    AlphaSlider(
                        alpha: $alpha,
                        color: fullyOpaqueColor
                    )
                    .frame(height: 24)
                }
                .padding(8)
            }
            .padding(8)

            HStack {
                ColorModelPicker(colorModel: $colorModel)

                HSLAInputGroup(
                    hue: $hue,
                    saturation: $saturation,
                    lightness: $lightness,
                    alpha: $alpha
                )
                .frame(maxHeight: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 16)
        }
        .onChange(of: hslaColor) { nsColor in
            colorPublisher.publish(nsColor, source: "HSLEditor")
        }
        .onReceive(
            colorPublisher
                .updates(excluding: "HSLEditor")
        ) { publishedColor in
            syncComponents(from: publishedColor.color)
        }
    }

    private var fullyOpaqueColor: Color {
        Color(nsColor: hslaColor.withAlphaComponent(1))
    }

    private var hslaColor: NSColor {
        NSColor(
            colorSpace: colorSpace.nsColorSpace,
            hue: hue,
            saturation: saturation,
            lightness: lightness,
            alpha: alpha
        )
    }

    private func syncComponents(from color: NSColor) {
        hue = color.hueComponent
        saturation = color.hslSaturation
        lightness = color.lightness
        alpha = color.alphaComponent
    }
}

struct HSLEditor_Previews: PreviewProvider {
    static var previews: some View {
        HSLEditor(
            colorSpace: .constant(.sRGB),
            colorModel: .constant(.hsl),
            colorPublisher: ColorPublisher()
        )
        .frame(width: 320)
        .environmentObject(ColorSampler())
    }
}
