import SwiftUI

struct SaturationBrightnessSlider: View {
    var hue: Double
    @Binding var saturation: Double
    @Binding var brightness: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hue: hue, saturation: 1, brightness: 1)

                LinearGradient(
                    colors: [.white, .white.opacity(0)],
                    startPoint: .leading,
                    endPoint: .trailing
                )

                LinearGradient(
                    colors: [.black, .black.opacity(0)],
                    startPoint: .bottom,
                    endPoint: .top
                )
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
                        saturation = (value.location.x / geometry.size.width)
                            .clamped(to: 0 ... 1)
                        brightness = 1 -
                            (value.location.y / geometry.size.height)
                            .clamped(to: 0 ... 1)
                    }
            )
        }
    }
}

// https://stackoverflow.com/questions/36110620/standard-way-to-clamp-a-number-between-two-values-in-swift/40868784#40868784
private extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

struct SaturationBrightnessSlider_Previews: PreviewProvider {
    static var previews: some View {
        SaturationBrightnessSlider(
            hue: 1,
            saturation: .constant(1),
            brightness: .constant(1)
        )
        .previewLayout(.fixed(width: 320, height: 320))
    }
}
