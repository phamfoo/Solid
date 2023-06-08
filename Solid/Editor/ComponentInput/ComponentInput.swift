import SwiftUI

struct NumberInput: View {
    @FocusState private var isFocused: Bool

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
        TextField(label, value: $value, format: RangeIntegerStyle(range: range))
            .focused($isFocused)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
            .onChange(of: normalizedValue) { newValue in
                value = Self.getValue(
                    normalizedValue: newValue,
                    in: range
                )
            }
            .onSubmit {
                syncNormalizedValue()
            }
            .onChange(of: isFocused) { newValue in
                let hasLostFocus = !newValue
                
                if hasLostFocus {
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

extension NumberInput {
    private struct RangeIntegerStyle: ParseableFormatStyle {
        var parseStrategy: RangeIntegerStrategy

        init(range: ClosedRange<Int>) {
            parseStrategy = RangeIntegerStrategy(range: range)
        }

        func format(_ value: Int) -> String {
            return "\(value)"
        }
    }

    private struct RangeIntegerStrategy: ParseStrategy {
        private var intParseStrategy =
            IntegerParseStrategy<IntegerFormatStyle<Int>>(format: .number)
        var range: ClosedRange<Int>

        init(range: ClosedRange<Int>) {
            self.range = range
        }

        func parse(_ value: String) throws -> Int {
            let intValue = try intParseStrategy.parse(value)

            return intValue.clamped(to: range)
        }
    }
}

struct PercentageInput: View {
    @FocusState private var isFocused: Bool

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
        TextField(
            label,
            value: $value,
            format: RangePercentageStyle(range: 0 ... 100)
        )
        .focused($isFocused)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .onChange(of: normalizedValue) { newValue in
            value = Self.getValue(
                normalizedValue: newValue
            )
        }
        .onSubmit {
            normalizedValue = Double(value) / 100
        }
        .onChange(of: isFocused) { newValue in
            let hasLostFocus = !newValue
            
            if hasLostFocus {
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

extension PercentageInput {
    private struct RangePercentageStyle: ParseableFormatStyle {
        private var percentFormatStyle: IntegerFormatStyle<Int>.Percent
        var parseStrategy: RangePercentageStrategy

        init(range: ClosedRange<Int>) {
            percentFormatStyle = IntegerFormatStyle<Int>.Percent()
            parseStrategy = RangePercentageStrategy(
                range: range,
                parseStrategy: percentFormatStyle.parseStrategy
            )
        }

        func format(_ value: Int) -> String {
            percentFormatStyle.format(value)
        }
    }

    private struct RangePercentageStrategy: ParseStrategy {
        var range: ClosedRange<Int>
        var percentParseStrategy: IntegerParseStrategy<
            IntegerFormatStyle<Int>
                .Percent
        >

        init(
            range: ClosedRange<Int>,
            parseStrategy: IntegerParseStrategy<IntegerFormatStyle<Int>.Percent>
        ) {
            self.range = range
            percentParseStrategy = parseStrategy
        }

        func parse(_ value: String) throws -> Int {
            let intValue = try percentParseStrategy.parse(value)

            return intValue.clamped(to: range)
        }
    }
}
