import SwiftUI

struct SolidTabView: NSViewControllerRepresentable {
    var tabs: [TabConfig]
    var currentTab: Tab

    func makeNSViewController(context _: Context) -> NSTabViewController {
        let tabViewController = NSTabViewController()
        tabViewController.tabStyle = .unspecified

        for tab in tabs {
            let tabItemController = NSHostingController(rootView: tab.content)
            let tabItem = NSTabViewItem(viewController: tabItemController)
            tabItem.label = tab.title
            tabViewController.addTabViewItem(tabItem)
        }

        return tabViewController
    }

    func updateNSViewController(
        _ tabViewController: NSTabViewController,
        context _: Context
    ) {
        tabViewController.selectedTabViewItemIndex = currentIndex
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
