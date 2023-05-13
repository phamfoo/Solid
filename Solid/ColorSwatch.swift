import SwiftUI

struct ColorSwatch: View {
    var color: NSColor

    var body: some View {
        RoundedRectangle(cornerRadius: 4, style: .continuous)
            .fill(Color(nsColor: color))
            .frame(width: 32, height: 32)
    }
}

struct ColorSwatch_Previews: PreviewProvider {
    static var previews: some View {
        ColorSwatch(color: .red)
    }
}
