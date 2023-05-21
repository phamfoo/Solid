import SwiftUI

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
            .padding(.vertical, 12)
            .contentShape(Rectangle())
            .onTapGesture {
                focused = true
            }
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
            .padding(.vertical, 12)
            .contentShape(Rectangle())
            .onTapGesture {
                focused = true
            }
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
