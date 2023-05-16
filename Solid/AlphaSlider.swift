import SwiftUI

struct AlphaSlider: View {
    @Binding var alpha: Double
    var fullyOpaqueColor: Color

    var body: some View {
        Slider(value: $alpha) {
            Canvas { context, size in
                context.fill(
                    Path(CGRect(origin: .zero, size: size)),
                    with: .color(.white)
                )

                let numberOfRows = 4
                let cellSize = size.height / Double(numberOfRows)
                let numberOfColumns = Int(round(size.width / cellSize))

                for row in 0 ..< numberOfRows {
                    for column in 0 ..< numberOfColumns {
                        let cellRect = CGRect(
                            x: CGFloat(column) * cellSize,
                            y: CGFloat(row) * cellSize,
                            width: cellSize,
                            height: cellSize
                        )

                        if (row + column) % 2 == 0 {
                            context.fill(Path(cellRect), with: .color(.gray))
                        }
                    }
                }
            }
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
