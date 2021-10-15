//
//  Routing.swift
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


import UIKit
import SwiftUI

/// A protocol defining a type that can route the application to specific destinations.
public protocol Routing: ObservableObject {
    /// The type of the root view controller for this particular instance.
    associatedtype Root: UIViewController
    /// The root view controller for this particular instance, from which presentations should be performed.
    var rootViewController: Root { get }

    /// The type declaring all available routes for this instance. Typically, this would be an `enum` with cases for each possible route you'd like to perform.
    associatedtype Route

    /// A function that will route the current context towards a specific path, or route.
    /// - Parameter route:The route to be used for this particular action.
    func go(to route: Route)
}
