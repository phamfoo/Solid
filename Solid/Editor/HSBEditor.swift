import SwiftUI

struct HSBEditor: View {
    @Binding var colorSpace: ColorSpace
    @Binding var colorModel: ColorModel
    @Binding var color: NSColor

    @State private var hue: Double
    @State private var saturation: Double
    @State private var brightness: Double
    @State private var alpha: Double

    init(
        colorSpace: Binding<ColorSpace>,
        colorModel: Binding<ColorModel>,
        color: Binding<NSColor>
    ) {
        _colorSpace = colorSpace
        _colorModel = colorModel
        _color = color

        let color = _color.wrappedValue
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

            HStack(spacing: 0) {
                ColorSampler { pickedColor in
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
        .onChange(of: nsColor) { nsColor in
            color = nsColor
        }
    }

    private var fullyOpaqueColor: Color {
        Color(nsColor: nsColor.withAlphaComponent(1))
    }

    private var nsColor: NSColor {
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
            color: .constant(.red)
        )
        .frame(width: 320)
    }
}
