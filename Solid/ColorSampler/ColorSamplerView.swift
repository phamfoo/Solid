import Defaults
import SwiftUI

struct ColorSamplerView: View {
    @Default(.copyAfterPicking) private var copyAfterPicking
    @Default(.includeHashPrefix) private var includeHashPrefix
    @Default(.lowerCaseHex) private var lowerCaseHex

    @EnvironmentObject private var colorSampler: ColorSampler
    var onPick: (NSColor) -> Void

    var body: some View {
        Button {
            colorSampler
                .show { pickedColor in
                    if let pickedColor {
                        self.onPick(pickedColor)
                    }
                }
        } label: {
            Image(systemName: "eyedropper")
                .imageScale(.large)
        }
        .buttonStyle(.solid)
        .background {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.accentColor)
                .opacity(colorSampler.isSampling ? 1 : 0)
        }
    }
}

struct ColorSamplerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSamplerView { _ in }
    }
}
