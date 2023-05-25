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
            .frame(minWidth: 320, minHeight: 320)

            HStack(spacing: 0) {
                ColorSampler { pickedColor in
                    if let pickedColorInCurrentColorSpace =
                        pickedColor.usingColorSpace(colorSpace.nsColorSpace)
                    {
                        colorPublisher.publish(
                            pickedColorInCurrentColorSpace,
                            source: "ColorPicker"
                        )
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
        .onChange(of: rgbaColor) { rgbaColor in
            colorPublisher.publish(rgbaColor, source: "RGBEditor_RGB")
        }
        .onReceive(
            colorPublisher.updates(excluding: "RGBEditor_RGB")
        ) { publishedColor in
            if rgbaColor != publishedColor.color {
                syncRGBComponents(from: publishedColor.color)
            }
        }
        .onChange(of: hsbaColor) { hsbaColor in
            colorPublisher.publish(hsbaColor, source: "RGBEditor_HSB")
        }
        .onReceive(
            colorPublisher.updates(excluding: "RGBEditor_HSB")
        ) { publishedColor in
            if hsbaColor != publishedColor.color {
                syncHSBComponents(from: publishedColor.color)
            }
        }
        .onReceive(colorPublisher.updates()) { publishedColor in
            alpha = publishedColor.color.alphaComponent
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

    private func syncHSBComponents(from color: NSColor) {
        hue = color.hueComponent
        saturation = color.saturationComponent
        brightness = color.brightnessComponent
    }

    private func syncRGBComponents(from color: NSColor) {
        red = color.redComponent
        green = color.greenComponent
        blue = color.blueComponent
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
    }
}
