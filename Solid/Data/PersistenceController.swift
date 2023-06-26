import AppKit
import CoreData

struct PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let colors: [NSColor] = [
            .red,
            .green,
            .blue
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

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Solid")
        if inMemory {
            container.persistentStoreDescriptions.first!
                .url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error
                // appropriately.
                // fatalError() causes the application to generate a crash log
                // and terminate. You should not use this function in a shipping
                // application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
