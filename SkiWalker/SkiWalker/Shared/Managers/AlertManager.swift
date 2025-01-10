//
//  AlertManager.swift
//  SkiWalker
//
//  Created by irakli kharshiladze on 10.01.25.
//
import UIKit

final class AlertManager {
    static func showAlert(title: String = "Error", message: String, on viewController: UIViewController? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        presentAlert(alertController, on: viewController)
    }
    
    static func showAlertWithActions(title: String, message: String, actions: [UIAlertAction], on viewController: UIViewController? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction($0) }
        
        presentAlert(alertController, on: viewController)
    }
    
    private static func presentAlert(_ alertController: UIAlertController, on viewController: UIViewController?) {
        let topViewController = viewController ?? topMostViewController()
        topViewController?.present(alertController, animated: true, completion: nil)
    }
    
    private static func topMostViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }
        return getTopViewController(rootViewController)
    }
    
    private static func getTopViewController(_ viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController {
            return getTopViewController(presented)
        } else if let nav = viewController as? UINavigationController {
            return nav.visibleViewController ?? nav
        } else if let tab = viewController as? UITabBarController {
            return tab.selectedViewController ?? tab
        }
        return viewController
    }
}
