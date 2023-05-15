import SwiftUI

struct Editor: View {
    @State private var hue = 1.0
    @State private var saturation = 1.0
    @State private var brightness = 1.0
    @State private var alpha = 1.0

    var body: some View {
        VStack {
            SaturationBrightnessSlider(
                hue: hue,
                saturation: $saturation,
                brightness: $brightness
            )
            .aspectRatio(1, contentMode: .fit)

            HStack {
                ColorSampler { pickedColor in
                    syncComponents(from: pickedColor)
                }

                VStack {
                    Slider(value: $hue) {
                        Text("Hue")
                    }

                    Slider(value: $alpha) {
                        Text("Alpha")
                    }
                }
                .labelsHidden()
            }
            .padding(.horizontal)

            HStack {
                NumberInput("H", normalizedValue: $hue, in: 0 ... 360)
                NumberInput("S", normalizedValue: $saturation, in: 0 ... 100)
                NumberInput("B", normalizedValue: $brightness, in: 0 ... 100)

                PercentageInput("A", normalizedValue: $alpha)
            }
            .padding(.horizontal)
            .padding(.top, 16)

            VStack(alignment: .leading) {
                Text("Output")
                    .font(.headline)
                    .foregroundColor(.secondary)

                ColorOutput(color: color)
            }
            .padding(.horizontal)
            .padding(.top, 16)

            RecentColors(color: color)
                .padding(.horizontal)
                .padding(.top, 32)

            Spacer()
        }
    }

    private var color: NSColor {
        NSColor(
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

struct NumberInput: View {
    @FocusState private var focused: Bool

    private var label: String
    @Binding private var normalizedValue: Double
    private var range: ClosedRange<Int>
    @State private var value: Int

    init(
        _ label: String,
        normalizedValue: Binding<Double>,
        in range: ClosedRange<Int>
    ) {
        self.label = label
        self.range = range
        _normalizedValue = normalizedValue
        value = Self.getValue(
            normalizedValue: normalizedValue.wrappedValue,
            in: range
        )
    }

    var body: some View {
        TextField(label, value: $value, format: .number)
            .focused($focused)
            .onChange(of: normalizedValue) { newNormalizedValue in
                value = Self.getValue(
                    normalizedValue: newNormalizedValue,
                    in: range
                )
            }
            .onSubmit {
                syncNormalizedValue()
            }
            .onChange(of: focused) { focused in
                if !focused {
                    syncNormalizedValue()
                }
            }
    }

    private func syncNormalizedValue() {
        normalizedValue = Double(value) /
            Double(range.upperBound - range.lowerBound)
    }

    private static func getValue(
        normalizedValue: Double,
        in range: ClosedRange<Int>
    ) -> Int {
        let value = normalizedValue *
            Double(range.upperBound - range.lowerBound)

        let roundedValue = Int(round(value))

        return roundedValue
    }
}

struct PercentageInput: View {
    @FocusState private var focused: Bool

    private var label: String
    @Binding private var normalizedValue: Double
    @State private var value: Int

    init(
        _ label: String,
        normalizedValue: Binding<Double>
    ) {
        self.label = label
        _normalizedValue = normalizedValue
        value = Self.getValue(
            normalizedValue: normalizedValue.wrappedValue
        )
    }

    var body: some View {
        TextField(label, value: $value, format: .percent)
            .focused($focused)
            .onChange(of: normalizedValue) { newNormalizedValue in
                value = Self.getValue(
                    normalizedValue: newNormalizedValue
                )
            }
            .onSubmit {
                normalizedValue = Double(value) / 100
            }
            .onChange(of: focused) { focused in
                if !focused {
                    syncNormalizedValue()
                }
            }
    }

    private func syncNormalizedValue() {
        normalizedValue = Double(value) / 100
    }

    private static func getValue(
        normalizedValue: Double
    ) -> Int {
        let value = normalizedValue * 100
        let roundedValue = Int(round(value))

        return roundedValue
    }
}

struct Editor_Previews: PreviewProvider {
    static var previews: some View {
        Editor()
            .previewLayout(.fixed(width: 320, height: 640))
            .environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
    }
}
