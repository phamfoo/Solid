import SwiftUI

struct Slider<Track, Thumb>: View where Track: View, Thumb: View {
    @Binding var value: Double
    @ViewBuilder var track: Track
    @ViewBuilder var thumb: Thumb

    var body: some View {
        GeometryReader { geometry in
            let maxTravelDistance = geometry.size.width - geometry.size.height

            track.clipShape(
                RoundedRectangle(
                    cornerRadius: .infinity,
                    style: .continuous
                )
            )
            .overlay(alignment: .leading) {
                thumb
                    .aspectRatio(1, contentMode: .fit)
                    .offset(x: value * maxTravelDistance)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let start = geometry.size.height / 2
                        let location = value.location.x - start
                        self.value = (location / maxTravelDistance)
                            .clamped(to: 0 ... 1)
                    }
            )
        }
    }
}

struct Slider_Previews: PreviewProvider {
    static var previews: some View {
        let colors = Array(stride(from: 0.0, to: 361.0, by: 30.0))
            .map { $0 / 360 }
            .map { Color(hue: $0, saturation: 1, brightness: 1) }

        Slider(value: .constant(0.5)) {
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
        } thumb: {
            Circle()
                .strokeBorder(Color.white, lineWidth: 2)
        }
        .frame(width: 320, height: 32)
    }
}
