import SwiftUI

struct ColorModelPicker: View {
    @State private var isHovered = false

    @Binding var colorModel: ColorModel

    var body: some View {
        HStack(spacing: 4) {
            Text(colorModel.displayName)

            Image(systemName: "chevron.down")
                .imageScale(.small)
        }
        .foregroundColor(isHovered ? .primary : .secondary)
        .padding(.horizontal, 8)
        .frame(maxHeight: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(.white)
                .opacity(isHovered ? 0.1 : 0)
        }
        .background {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .strokeBorder(.quaternary)
                .opacity(isHovered ? 1 : 0)
        }
        .onHover { isHovered in
            self.isHovered = isHovered
        }
        .overlay {
            // I had a layout issue when trying to put the label
            // inside an NSHostingView.
            // Now we just render the label in SwiftUI land normally
            // and have this overlay show the menu instead.
            ColorModelPickerOverlay(colorModel: $colorModel)
        }
    }
}

struct ColorModelPickerOverlay: NSViewControllerRepresentable {
    @Binding var colorModel: ColorModel

    func makeNSViewController(context: Context) -> MenuViewController {
        let menuViewController = MenuViewController(
            items: ColorModel.allCases.map { $0.displayName }
        )
        menuViewController.delegate = context.coordinator

        return menuViewController
    }

    func updateNSViewController(
        _ menuViewController: MenuViewController,
        context _: Context
    ) {
        let selectedIndex = ColorModel.allCases
            .firstIndex { $0.id == colorModel.id }!

        menuViewController.selectedIndex = selectedIndex
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, MenuViewControllerDelegate {
        var parent: ColorModelPickerOverlay
        init(parent: ColorModelPickerOverlay) {
            self.parent = parent
        }

        func onSelect(itemIndex: Int) {
            let selectedColorModel = ColorModel.allCases[itemIndex]
            parent.colorModel = selectedColorModel
        }
    }
}

class MenuViewController: NSViewController {
    var items: [String]
    var selectedIndex: Int
    weak var delegate: MenuViewControllerDelegate?

    init(items: [String]) {
        self.items = items
        selectedIndex = 0
        super.init(nibName: nil, bundle: nil)

        view = NSView(frame: .zero)
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
            at: NSPoint(x: 0, y: view.frame.height),
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

struct ColorModelPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorModelPicker(colorModel: .constant(.hsb))
            .frame(height: 32)
    }
}
