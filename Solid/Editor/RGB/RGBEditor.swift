import SwiftUI

struct RGBEditor: View {
    @Binding var colorSpace: ColorSpace
    @Binding var colorModel: ColorModel
    var colorPublisher: ColorPublisher

    @State private var hue: Double
    @State private var saturation: Double
    @State private var brightness: Double
    @State private var alpha: Double

    @State private var red: Double
    @State private var green: Double
    @State private var blue: Double

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

        red = color.redComponent
        green = color.greenComponent
        blue = color.blueComponent
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
                    syncRGBAComponents(from: pickedColor)
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

                RGBAInputGroup(
                    red: $red,
                    green: $green,
                    blue: $blue,
                    alpha: $alpha
                )
                .frame(maxHeight: .infinity)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 16)
        }
        .onChange(of: rgbaColor) { newValue in
            if newValue != colorPublisher.currentColor {
                colorPublisher.publish(newValue, source: "RGBEditor_RGB")
            }
        }
        .onReceive(
            colorPublisher.updates(excluding: "RGBEditor_RGB")
        ) { publishedColor in
            if rgbaColor != publishedColor.color {
                syncRGBAComponents(from: publishedColor.color)
            }
        }
        .onChange(of: hsbaColor) { newValue in
            if newValue != colorPublisher.currentColor {
                colorPublisher.publish(newValue, source: "RGBEditor_HSB")
            }
        }
        .onReceive(
            colorPublisher.updates(excluding: "RGBEditor_HSB")
        ) { publishedColor in
            if hsbaColor != publishedColor.color {
                syncHSBAComponents(from: publishedColor.color)
            }
        }
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

    private var rgbaColor: NSColor {
        NSColor(
            colorSpace: colorSpace.nsColorSpace,
            components: [red, green, blue, alpha],
            count: 4
        )
    }

    private var fullyOpaqueColor: Color {
        Color(nsColor: rgbaColor.withAlphaComponent(1))
    }

    private func syncHSBAComponents(from color: NSColor) {
        DispatchQueue.main.async {
            hue = color.hueComponent
            saturation = color.saturationComponent
            brightness = color.brightnessComponent
            alpha = color.alphaComponent
        }
    }

    private func syncRGBAComponents(from color: NSColor) {
        DispatchQueue.main.async {
            red = color.redComponent
            green = color.greenComponent
            blue = color.blueComponent
            alpha = color.alphaComponent
        }
    }
}

struct RGBEditor_Previews: PreviewProvider {
    static var previews: some View {
        RGBEditor(
            colorSpace: .constant(.sRGB),
            colorModel: .constant(.rgb),
            colorPublisher: ColorPublisher()
        )
        .frame(width: 320)
        .environmentObject(ColorSampler())
    }
}
