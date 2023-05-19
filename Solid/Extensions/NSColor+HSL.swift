import AppKit

// https://en.wikipedia.org/wiki/HSL_and_HSV#Interconversion
extension NSColor {
    convenience init(
        colorSpace: NSColorSpace,
        hue: Double,
        saturation: Double,
        lightness: Double,
        alpha: Double
    ) {
        let brightness = lightness
            + saturation * min(lightness, 1 - lightness)

        let hsbSaturation = brightness == 0
            ? 0
            : 2 * (1 - lightness / brightness)

        self.init(
            colorSpace: colorSpace,
            hue: hue,
            saturation: hsbSaturation,
            brightness: brightness,
            alpha: alpha
        )
    }
}

extension NSColor {
    var lightness: Double {
        brightnessComponent * (1 - saturationComponent / 2)
    }

    var hslSaturation: Double {
        lightness == 0 || lightness == 1
            ? 0
            : (brightnessComponent - lightness) / min(lightness, 1 - lightness)
    }
}
