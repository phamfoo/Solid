import SwiftUI

struct ColorSampler: View {
    var onPick: (NSColor) -> Void

    var body: some View {
        Button {
            NSColorSampler()
                .show { pickedColor in
                    if let pickedColor {
                        self.onPick(pickedColor)
                    }
                }
        } label: {
            Image(systemName: "eyedropper")
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
}

struct ColorSampler_Previews: PreviewProvider {
    static var previews: some View {
        ColorSampler { _ in }
    }
}
