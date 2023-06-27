import Foundation
import AppKit

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let colors: [NSColor] = [
            .red,
            .green,
            .blue,
        ]
        for color in colors {
            let newItem = SolidColor(context: viewContext)
            newItem.id = UUID()
            newItem.timestamp = Date()
            newItem.hue = color.hueComponent
            newItem.saturation = color.saturationComponent
            newItem.brightness = color.brightnessComponent
            newItem.alpha = color.alphaComponent
            newItem.colorSpace = ColorSpace.sRGB.rawValue
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error
            // appropriately.
            // fatalError() causes the application to generate a crash log and
            // terminate. You should not use this function in a shipping
            // application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
