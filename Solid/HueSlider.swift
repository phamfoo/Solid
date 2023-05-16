import SwiftUI

struct HueSlider: View {
    @Binding var hue: Double

    var body: some View {
        GeometryReader { geometry in
            let maxTravelDistance = geometry.size.width - geometry.size.height

            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
            .clipShape(Capsule())
            .overlay(alignment: .leading) {
                Circle()
                    .fill(fullySaturatedColor)
                    .overlay {
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 2)
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .offset(x: hue * maxTravelDistance)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let start = geometry.size.height / 2
                        let location = value.location.x - start
                        hue = (location / maxTravelDistance)
                            .clamped(to: 0 ... 1)
                    }
            )
        }
    }

    private var colors: [Color] {
        Array(stride(from: 0.0, to: 361.0, by: 30.0))
            .map { $0 / 360 }
            .map { Color(hue: $0, saturation: 1, brightness: 1) }
    }

    private var fullySaturatedColor: Color {
        Color(hue: hue, saturation: 1, brightness: 1)
    }
}

struct HueSlider_Previews: PreviewProvider {
    static var previews: some View {
        HueSlider(hue: .constant(0.5))
            .frame(width: 320, height: 32)
    }
}
