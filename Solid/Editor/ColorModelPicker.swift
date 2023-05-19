import SwiftUI

struct ColorModelPicker: NSViewControllerRepresentable {
    @Binding var colorModel: ColorModel

    func makeNSViewController(context: Context) -> MenuViewController {
        let labelView =
            NSHostingView(rootView: LabelView(title: colorModel.displayName))
        let menuViewController = MenuViewController(
            labelView: labelView,
            items: ColorModel.allCases.map { $0.displayName },
            selectedIndex: 0
        )
        menuViewController.delegate = context.coordinator

        return menuViewController
    }

    func updateNSViewController(
        _: MenuViewController,
        context _: Context
    ) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MenuViewControllerDelegate {
        var parent: ColorModelPicker
        init(parent: ColorModelPicker) {
            self.parent = parent
        }

        func onSelect(itemIndex: Int) {
            let selectedColorModel = ColorModel.allCases[itemIndex]
            parent.colorModel = selectedColorModel
        }
    }
}

private struct LabelView: View {
    @State private var hovered = false
    var title: String

    var body: some View {
        HStack(spacing: 4) {
            Text(title)

            Image(systemName: "chevron.down")
                .imageScale(.small)
        }
        .foregroundColor(hovered ? .primary : .secondary)
        .padding(.horizontal, 8)
        .frame(maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(.white)
                .opacity(hovered ? 0.1 : 0)
        }
        .background {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .strokeBorder(.quaternary)
                .opacity(hovered ? 1 : 0)
        }
        .onHover { hovered in
            self.hovered = hovered
        }
    }
}

class MenuViewController: NSViewController {
    var items: [String]
    var selectedIndex: Int
    weak var delegate: MenuViewControllerDelegate?

    init(labelView: NSView, items: [String], selectedIndex: Int) {
        self.items = items
        self.selectedIndex = selectedIndex
        super.init(nibName: nil, bundle: nil)

        view = labelView
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func mouseDown(with _: NSEvent) {
        let menu = NSMenu()

        for (index, item) in items.enumerated() {
            let menuItem = NSMenuItem(
                title: item,
                action: #selector(colorModelSelected(_:)),
                keyEquivalent: ""
            )
            menuItem.tag = index
            menuItem.target = self
            if index == selectedIndex {
                menuItem.state = .on
            }

            menu.addItem(menuItem)
        }
        menu.popUp(
            positioning: nil,
            at: view.frame.origin,
            in: view
        )
    }

    @objc private func colorModelSelected(_ sender: NSMenuItem) {
        selectedIndex = sender.tag
        delegate?.onSelect(itemIndex: selectedIndex)
    }
}

protocol MenuViewControllerDelegate: AnyObject {
    func onSelect(itemIndex: Int)
}

enum ColorModel: CaseIterable, Identifiable {
    case hsb
    case rgb
    case hsl

    var id: String {
        displayName
    }

    var displayName: String {
        switch self {
        case .hsb:
            return "HSB"
        case .rgb:
            return "RGB"
        case .hsl:
            return "HSL"
        }
    }
}

struct ColorModelPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorModelPicker(colorModel: .constant(.hsb))
            .previewLayout(.sizeThatFits)
    }
}
