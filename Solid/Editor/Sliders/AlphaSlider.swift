import SwiftUI

struct AlphaSlider: View {
    @Binding var alpha: Double
    var fullyOpaqueColor: Color

    var body: some View {
        Slider(value: $alpha) {
            CheckerBoardBackground(numberOfRows: 4)
                .overlay {
                    LinearGradient(
                        colors: [
                            fullyOpaqueColor.opacity(0),
                            fullyOpaqueColor,
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
        } thumb: {
            Circle()
                .fill(Color.white)
                .overlay {
                    Circle()
                        .fill(fullyOpaqueColor.opacity(alpha))
                }
                .overlay {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                }
        }
    }
}

struct AlphaSlider_Previews: PreviewProvider {
    static var previews: some View {
        AlphaSlider(alpha: .constant(0.5), fullyOpaqueColor: .red)
            .frame(width: 320, height: 32)
    }
}
