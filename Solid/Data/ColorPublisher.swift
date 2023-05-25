import AppKit
import Combine
import Defaults

private typealias Query = [String: String?]

class ColorPublisher: ObservableObject {
    private var colorSubject = CurrentValueSubject<
        ColorUpdate,
        Never
    >(ColorUpdate(color: Defaults[.color], source: "Root"))

    private var updateChannels = [Query: AnyPublisher<ColorUpdate, Never>]()

    func publish(_ color: NSColor, source: String) {
        colorSubject.send(ColorUpdate(color: color, source: source))
    }

    func updates(excluding source: String? = nil)
        -> AnyPublisher<ColorUpdate, Never>
    {
        let query = ["excluding": source]

        if let updateChannel = updateChannels[query] {
            return updateChannel
        }

        let newUpdateChannel = colorSubject
            .filter { $0.source != source }
            .eraseToAnyPublisher()

        updateChannels[query] = newUpdateChannel

        return newUpdateChannel
    }

    var currentColor: NSColor {
        colorSubject.value.color
    }
}

struct ColorUpdate {
    var color: NSColor
    var source: String
}
