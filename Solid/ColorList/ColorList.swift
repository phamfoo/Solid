import SwiftUI

struct ColorList: View {
    @SectionedFetchRequest<Date, SolidColor>(
        sectionIdentifier: \.startOfDay,
        sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)],
        animation: .default
    )
    private var sections: SectionedFetchResults<Date, SolidColor>

    var body: some View {
        List {
            ForEach(sections) { section in
                Section(sectionHeader(fromDate: section.id)) {
                    ForEach(section) { color in
                        ColorListRow(color: color)
                    }
                }
            }
        }
    }

    private func sectionHeader(fromDate date: Date) -> String {
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        return date.formatted(
            date: .abbreviated,
            time: .omitted
        )
    }
}

extension SolidColor {
    @objc var startOfDay: Date {
        Calendar.current.startOfDay(for: timestamp!)
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
