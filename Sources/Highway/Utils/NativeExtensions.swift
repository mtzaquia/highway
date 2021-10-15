//
//  NativeExtensions.swift
//
//  Copyright (c) 2021 @mtzaquia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import OSLog
import UIKit

public extension UIViewController {
    /// A chaining function to attach different ``Routing`` objects to this controller instance, similar to ``environmentObject(_:)`` on `SwiftUI`.
    /// - Returns: `self` with the newly ``Routing`` attached to it.
    @discardableResult
    func routing<Router>(_ router: Router) -> Self where Router: Routing {
        Logger.highway.info("Attached \(String(describing: router)) to \(String(describing: self)).")
        routers[String(describing: Router.self)] = router
        return self
    }

    /// Finds the top-most view controller in a given hierarchy, starting from `self`.
    /// - Returns: The top-most view controller in the hierarchy, or `self`.
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }

        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }

        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }

        return self
    }
}

extension UIViewController {
    static var routersKey: UInt8 = 0
    var routers: [String: AnyObject] {
        get {
            objc_getAssociatedObject(self, &UIViewController.routersKey) as? [String: AnyObject] ?? [String: AnyObject]()
        }
        set(newValue) {
            objc_setAssociatedObject(self, &UIViewController.routersKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}
