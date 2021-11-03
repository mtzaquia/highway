# Highway

Highway is a lightweight, scalable framework for basic routing in iOS apps.

## Instalation

Highway is available via Swift Package Manager.

```swift
dependencies: [
  .package(url: "https://github.com/mtzaquia/highway.git", .branch("main")),
],
```

## Requirements

- Highway requires iOS 14 or higher.
- Highway requires Xcode 13 or higher.

## Usage

### Creating a router

Simply start by creating an object that conforms to `Routing`.

```swift
final class AppRouting: Routing {
    // Since routers can be attached to controllers, prefer a weak reference.
    private(set) weak var rootViewController: UINavigationController?

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        
        // We are conveniently attaching the router to the hierarchy here.
        rootViewController.routing(self)
    }
}

// Defining `Route` and finishing the requirements from the protocol in an extension for readability.
extension AppRouting {
    enum Route {
        case home
        case detail(_: String)
    }

    func go(to route: Route) {
        switch route {
        case .home: 
            rootViewController?.popToRootViewController(animated: true)
        case let .detail(text):
            rootViewController?.pushViewController(MyDetailController(text: text), animated: true)
        }
    }
}
```

### Completing

If you'd like to use the router for going back (i.e.: when the work on a destination is completed), define the `Destination` type and implement the `complete(_:)` method in your entity, too.

```swift
extension AppRouting {
    enum Destination {
        case detail(_: String)
    }

    func complete(_ destination: Destination) {
        switch destination {
        case let .detail(choice):
            rootViewController?.popToRootViewController(animated: true)
            (rootViewController?.viewControllers.first as? MyController)?.choice = choice
        }
    }
}
``` 

_**Attention:** By default, the `complete(_:)` method is provided with no destinations for convenience._

### Using the router in your app

It is important to attach your router to a view controller in the hierarchy so that you can retrieve it later. The simplest way is to call `UIVIewController.routing(_:)`. This can be conveniently done in the initialisation of the custom router type. See the [Creating a router](#creating-a-router) code snippet.

Once registered, you can fetch your registered routers using the property wrapper `@Router`. It works similarly to `@EnvironmentObject`, retrieving the instance registered with the matching type.

```swift
final class MyController: UIViewController {
    // Declaring the property to access our custom router instance.
    @Router var appRouter: AppRouting
    
    // ...
    
    func showDetail(_ text: String) {
        // Going to the detail screen using our router.
        appRouter.go(to: .detail(text))
    }
}
```

By default, the `@Router` property wrapper will look for the parent controllers until a router matching the proposed type is found. If you would like to prevent this behaviour, set the `searchParents` property to `false`.

```swift
// This requires a valid `AppRouting` instance to be attached to the view controller declaring this property.
@Router(searchParents: false) var appRouter: AppRouting
```

### Going back

If you are also using routers to go back, simply call `complete(_:)` whenever you are done.

```swift
final class MyDetailController: UIViewController {
    @Router var appRouter: AppRouting
    
    // ...
    
    func didSelect(_ choice: String) {
        appRouter.complete(.detail(choice))
    }
}
```

## License

Copyright (c) 2021 @mtzaquia

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
