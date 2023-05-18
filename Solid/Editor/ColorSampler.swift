import SwiftUI

struct ColorSampler: View {
    @State private var sampling = false

    var onPick: (NSColor) -> Void

    var body: some View {
        Button {
            sampling = true
            NSColorSampler()
                .show { pickedColor in
                    sampling = false

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
                .opacity(sampling ? 1 : 0)
        }
    }
}

struct ColorSampler_Previews: PreviewProvider {
    static var previews: some View {
        ColorSampler { _ in }
    }
}
