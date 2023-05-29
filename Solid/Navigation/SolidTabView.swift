import SwiftUI

struct SolidTabView: NSViewRepresentable {
    var tabs: [TabConfig]
    var currentTab: Tab

    func makeNSView(context: Context) -> NSTabView {
        let tabView = NSTabView()
        tabView.tabViewType = .noTabsNoBorder

        for tab in tabs {
            let tabItemView = NSHostingView(rootView: tab.content)
            tabItemView.translatesAutoresizingMaskIntoConstraints = false
            tabItemView.setContentCompressionResistancePriority(
                .defaultHigh,
                for: .vertical
            )
            tabItemView.setContentCompressionResistancePriority(
                .defaultHigh,
                for: .horizontal
            )
            let tabItem = NSTabViewItem()
            tabItem.view = tabItemView
            tabItem.label = tab.title
            tabView.addTabViewItem(tabItem)
        }

        tabView.delegate = context.coordinator

        return tabView
    }

    func updateNSView(
        _ tabView: NSTabView,
        context _: Context
    ) {
        tabView.selectTabViewItem(at: currentIndex)
    }

    private var currentIndex: Int {
        tabs.firstIndex { currentTab == $0.tab }!
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, NSTabViewDelegate {
        var parent: SolidTabView

        init(parent: SolidTabView) {
            self.parent = parent
        }

        func tabView(
            _ tabView: NSTabView,
            didSelect tabViewItem: NSTabViewItem?
        ) {
            if let tabViewItemView = tabViewItem?.view {
                NSLayoutConstraint.activate([
                    tabViewItemView.leadingAnchor
                        .constraint(equalTo: tabView.leadingAnchor),
                    tabViewItemView.trailingAnchor
                        .constraint(equalTo: tabView.trailingAnchor),
                    tabViewItemView.topAnchor
                        .constraint(equalTo: tabView.topAnchor),
                    tabViewItemView.bottomAnchor
                        .constraint(equalTo: tabView.bottomAnchor),
                ])
            }
        }
    }
}

enum Tab {
    case editor
    case colors
}

struct TabConfig {
    var title: String
    var content: AnyView
    var tab: Tab
}
