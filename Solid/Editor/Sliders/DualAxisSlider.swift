import SwiftUI

struct DualAxisSlider<Background, Cursor>: View where Background: View,
    Cursor: View
{
    @Binding var horizontal: Double
    @Binding var vertical: Double
    @ViewBuilder var background: Background
    @ViewBuilder var cursor: Cursor

    var body: some View {
        GeometryReader { geometry in
            background
                .overlay(alignment: .bottomLeading) {
                    cursor
                        .frame(width: 16, height: 16)
                        .offset(x: -8, y: 8)
                        .offset(
                            x: horizontal * geometry.size.width,
                            y: -vertical * geometry.size.height
                        )
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            horizontal = (
                                value.location.x / geometry.size
                                    .width
                            )
                            .clamped(to: 0 ... 1)
                            vertical = 1 -
                                (value.location.y / geometry.size.height)
                                .clamped(to: 0 ... 1)
                        }
                )
        }
    }
}

struct DualAxisSlider_Previews: PreviewProvider {
    static var previews: some View {
        DualAxisSlider(
            horizontal: .constant(1),
            vertical: .constant(1)
        ) {} cursor: {}
    }
}
