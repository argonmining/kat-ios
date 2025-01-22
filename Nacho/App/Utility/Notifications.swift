import SwiftEntryKit
import SwiftUI
import Foundation

struct Notifications {

    static let messageKey: String = "message"

    static func presentTopMessage(_ message: String) {
        let view = TopMessageView(message: message)
        var attributes = EKAttributes()
        attributes.displayDuration = 3
        attributes.entryBackground = .clear
        attributes.exitAnimation = .init(fade: .init(from: 1, to: 0, duration: 0.3))
        let viewController = UIHostingController(rootView: view)
        viewController.view.backgroundColor = .clear
        guard let uiView = viewController.view else { return }
        SwiftEntryKit.display(entry: uiView, using: attributes)
    }

    static func sendMessageNotification(message: String) {
        NotificationCenter.default.post(
            name: .showMessageNotification,
            object: nil,
            userInfo: [messageKey: message]
        )
    }
}
