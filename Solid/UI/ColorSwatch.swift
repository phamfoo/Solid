import SwiftUI

struct ColorSwatch: View {
    var color: NSColor
    var body: some View {
        HStack(spacing: 0) {
            Color(nsColor: color.withAlphaComponent(1))
            Color(nsColor: color)
        }
        .background {
            CheckerBoardBackground(numberOfRows: 8)
        }
        .frame(width: 44, height: 44)
        .drawingGroup()
        .clipShape(shape)
        .overlay(shape.stroke(.quaternary))
    }

    private var shape: some Shape {
        RoundedRectangle(
            cornerRadius: 6,
            style: .continuous
        )
    }
}

struct ColorSwatch_Previews: PreviewProvider {
    static var previews: some View {
        ColorSwatch(color: .red)
            .padding()
    }
}
