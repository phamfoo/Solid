import SwiftUI

struct SolidTabView: NSViewRepresentable {
    var tabs: [TabConfig]
    var currentTab: Tab

    func makeNSView(context _: Context) -> NSTabView {
        let tabView = NSTabView()
        tabView.tabViewType = .noTabsNoBorder

        for tab in tabs {
            let tabItemView = NSHostingView(rootView: tab.content)
            if tabItemView.intrinsicContentSize.height > 0 {
                tabItemView.translatesAutoresizingMaskIntoConstraints = false
                tabItemView.setContentCompressionResistancePriority(
                    .defaultHigh,
                    for: .vertical
                )
                tabItemView.setContentCompressionResistancePriority(
                    .defaultHigh,
                    for: .horizontal
                )
            }

            let tabItem = NSTabViewItem()
            tabItem.view = tabItemView
            tabItem.label = tab.title
            tabView.addTabViewItem(tabItem)
        }

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
