import SwiftUI

struct SaturationBrightnessSlider: View {
    @Binding var saturation: Double
    @Binding var brightness: Double

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(.quaternary)
                .overlay {
                    Rectangle()
                        .strokeBorder(Color.accentColor)
                }
                .overlay(alignment: .bottomLeading) {
                    Circle()
                        .strokeBorder(.white, lineWidth: 2)
                        .frame(width: 16, height: 16)
                        .offset(x: -8, y: 8)
                        .offset(
                            x: saturation * geometry.size.width,
                            y: -brightness * geometry.size.height
                        )
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            saturation = value.location.x / geometry.size.width
                            brightness = 1 -
                                value.location.y / geometry.size.height
                        }
                )
        }
    }
}

struct SaturationBrightnessSlider_Previews: PreviewProvider {
    static var previews: some View {
        SaturationBrightnessSlider(
            saturation: .constant(1),
            brightness: .constant(1)
        )
        .previewLayout(.fixed(width: 320, height: 320))
    }
}
