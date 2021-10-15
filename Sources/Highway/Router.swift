//
//  Router.swift
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

/// A property wrapper for fetching ``Routing`` instances attached to a given controller or controller hierarchy. Similar to ``@EnvironemntObject`` on `SwiftUI`.
///
/// Usage:
/// ```
/// final class MyController: UIViewController {
///   @Router var appRouter: AppRouter
///   @Router(searchParents: false) var featureRouter: MyFeatureRouter
///
///   func done() {
///     featureRouter.go(to: .nextStep)
///   }
/// }
/// ```
@propertyWrapper
public struct Router<Routable> where Routable: Routing {
    public static subscript<T>(_enclosingInstance instance: T,
                               wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Routable>,
                               storage storageKeyPath: ReferenceWritableKeyPath<T, Self>) -> Routable
    where T: UIViewController
    {
        get {
            var controller: UIViewController = instance
            while true {
                if let targetRouter = controller.routers[String(describing: Routable.self)] as? Routable {
                    Logger.highway.info("\(String(describing: targetRouter)) found for \(String(describing: instance)), attached to \(String(describing: controller)).")
                    return targetRouter
                } else {
                    guard let parent = controller.parent, instance[keyPath: storageKeyPath].searchParents else {
                        break
                    }

                    controller = parent
                }
            }

            let type = String(describing: Routable.self)
            fatalError("No router of type \(type) found. A UIViewController.routing(_:) for \(type) may be missing for this controller or its parents.")
        }
        set {}
    }

    @available(*, unavailable)
    public var wrappedValue: Routable {
        get { fatalError() }
        set { fatalError() }
    }

    private var searchParents: Bool

    /// Declares a new ``Routing`` accessor in a given ``UIViewController``.
    /// - Parameter searchParents: A flag indicating if the routers should be searched for in parent controllers if not attached to the declaring controller. Defaults to `true`.
    public init(searchParents: Bool = true) {
        self.searchParents = searchParents
    }
}
