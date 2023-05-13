import SwiftUI

struct ColorList: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(
            keyPath: \SolidColor.timestamp,
            ascending: false
        )]
    )
    private var colors: FetchedResults<SolidColor>

    var body: some View {
        List(colors) { color in
            ColorListItem(color: color)
        }
    }
}

struct ColorList_Previews: PreviewProvider {
    static var previews: some View {
        ColorList()
            .previewLayout(.fixed(width: 320, height: 480))
            .environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
    }
}
