import SwiftUI

struct HSBEditor: View {
    @Binding var colorSpace: ColorSpace
    @Binding var colorModel: ColorModel
    var colorPublisher: ColorPublisher

    @State private var hue: Double
    @State private var saturation: Double
    @State private var brightness: Double
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
        saturation = color.saturationComponent
        brightness = color.brightnessComponent
        alpha = color.alphaComponent
    }

    var body: some View {
        VStack(spacing: 0) {
            SaturationBrightnessSlider(
                hue: hue,
                saturation: $saturation,
                brightness: $brightness,
                colorSpace: colorSpace
            )
            .aspectRatio(1, contentMode: .fit)
            .frame(minHeight: 320)

            HStack(spacing: 0) {
                ColorSamplerView(
                    colorSpace: colorSpace.nsColorSpace
                ) { pickedColor in
                    syncComponents(from: pickedColor)
                }
                .padding(8)

                VStack {
                    HueSlider(hue: $hue, colorSpace: colorSpace)

                    AlphaSlider(
                        alpha: $alpha,
                        color: fullyOpaqueColor
                    )
                }
                .padding(8)
            }
            .padding(8)

            HStack {
                ColorModelPicker(colorModel: $colorModel)

                HSBAInputGroup(
                    hue: $hue,
                    saturation: $saturation,
                    brightness: $brightness,
                    alpha: $alpha
                )
                .frame(maxHeight: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 16)
        }
        .onChange(of: hsbaColor) { newValue in
            colorPublisher.publish(newValue, source: "HSBEditor")
        }
        .onReceive(
            colorPublisher
                .updates(excluding: "HSBEditor")
        ) { publishedColor in
            syncComponents(from: publishedColor.color)
        }
    }

    private var fullyOpaqueColor: Color {
        Color(nsColor: hsbaColor.withAlphaComponent(1))
    }

    private var hsbaColor: NSColor {
        NSColor(
            colorSpace: colorSpace.nsColorSpace,
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: alpha
        )
    }

    private func syncComponents(from color: NSColor) {
        hue = color.hueComponent
        saturation = color.saturationComponent
        brightness = color.brightnessComponent
        alpha = color.alphaComponent
    }
}

struct HSBEditor_Previews: PreviewProvider {
    static var previews: some View {
        HSBEditor(
            colorSpace: .constant(.sRGB),
            colorModel: .constant(.hsb),
            colorPublisher: ColorPublisher()
        )
        .frame(width: 320)
        .environmentObject(ColorSampler())
    }
}
