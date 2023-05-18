import SwiftUI

struct CheckerBoardBackground: View {
    var numberOfRows: Int

    var body: some View {
        Canvas { context, size in
            context.fill(
                Path(CGRect(origin: .zero, size: size)),
                with: .color(.white)
            )

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
    }
}

struct CheckerBoardBackground_Previews: PreviewProvider {
    static var previews: some View {
        CheckerBoardBackground(numberOfRows: 8)
            .frame(width: 200, height: 200)
    }
}
