import SwiftUI

struct ColorList: View {
    @SectionedFetchRequest<Date, SolidColor>(
        sectionIdentifier: \.startOfDay,
        sortDescriptors: [SortDescriptor(\.timestamp, order: .reverse)],
        animation: .default
    )
    private var sections: SectionedFetchResults<Date, SolidColor>

    @State private var searchText = ""

    var body: some View {
        VStack {
            SearchBar(text: $searchText)

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
        .onChange(of: searchText) { newValue in
            var predicates: [NSPredicate] = []

            if !newValue.isEmpty {
                predicates.append(
                    NSPredicate(format: "name CONTAINS[c] %@", newValue)
                )

                let colorPredicates: [String: NSPredicate] = [
                    "black": NSPredicate(format: "brightness < 0.1"),
                    "blue": NSPredicate(format: "hue >= 0.52 AND hue <= 0.67 AND saturation >= 0.4 AND brightness >= 0.4"),
                    "brown": NSPredicate(format: "((hue >= 0 AND hue <= 0.08) OR (hue >= 0.92 AND hue <= 1)) AND saturation >= 0.25 AND brightness >= 0.1 AND brightness <= 0.7"),
                    "gray": NSPredicate(format: "saturation < 0.05 AND brightness >= 0.05 AND brightness <= 0.95"),
                    "green": NSPredicate(format: "hue >= 0.2 AND hue <= 0.4 AND saturation >= 0.3 AND brightness >= 0.3"),
                    "orange": NSPredicate(format: "hue >= 0.05 AND hue <= 0.12 AND saturation >= 0.5 AND brightness >= 0.5"),
                    "pink": NSPredicate(format: "hue >= 0.85 AND saturation >= 0.3 AND brightness >= 0.7"),
                    "purple": NSPredicate(format: "hue >= 0.75 AND hue <= 0.95 AND saturation >= 0.3 AND brightness >= 0.5"),
                    "red": NSPredicate(format: "hue >= 0.95 OR hue <= 0.05 AND saturation >= 0.5 AND brightness >= 0.5"),
                    "white": NSPredicate(format: "brightness >= 0.95"),
                ]

                if let predicate = colorPredicates[newValue] {
                    predicates.append(
                        predicate
                    )
                }
            }

            sections.nsPredicate =
                predicates.isEmpty
                    ? nil
                    : NSCompoundPredicate(
                        orPredicateWithSubpredicates: predicates
                    )
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
