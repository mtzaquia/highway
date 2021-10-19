//
//  TestObjects.swift
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

import Foundation
import Highway
import UIKit

// MARK: - TestRouter

class TestRouter: Routing {
    private(set) weak var rootViewController: UIViewController?
    init(rootViewController: UIViewController, registeringSelf: Bool = true) {
        self.rootViewController = rootViewController

        if registeringSelf {
            rootViewController.routing(self)
        }
    }

    func go(to route: Route) {
        switch route {
        case .first: print("First route!")
        case .second: print("Second route!")
        }
    }
}

extension TestRouter {
    enum Route {
        case first
        case second
    }
}

// MARK: - TestController

final class TestController: UIViewController {
    @Router var testRouter: TestRouter
    @Router(named: "Rewired") var rewiredRouter: TestRouter
}

// MARK: - Rewired routers

final class RewiredRouter: TestRouter {
    override func go(to route: Route) {
        switch route {
        case .first: print("First rewired route!")
        case .second: print("Second rewired route!")
        }
    }
}

final class AnotherRouter: TestRouter {
    override func go(to route: Route) {
        switch route {
        case .first: print("First another route!")
        case .second: print("Second another route!")
        }
    }
}

