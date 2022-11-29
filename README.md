# MainThreadPropertyAccessor

<p>
<img src="https://img.shields.io/badge/Platform%20Compatibility-iOS%20%7C%C2%A0macOS%20%7C%C2%A0iPadOS-4E4E4E.svg?colorA=28a745" />
<img src="https://img.shields.io/badge/Swift%20Compatibility-5.7-4E4E4E.svg?colorA=28a745" />
<img src="https://img.shields.io/badge/Test%20Coverage-100%25-4E4E4E.svg?colorA=28a745" />
</p>

Syntactic sugar for setting properties on an ObservableObject on the main thread from within a Task.

```swift
Task {
    self.setOnMain.status = "Now I'll never get purple warnings again!"
}
```

## Installation

You can use the [Swift Package Manager](https://github.com/apple/swift-package-manager) by declaring MainThreadPropertyAccessor as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/theisegeberg/MainThreadPropertyAccessor", from: "0.1.0")
```

*For more information, see [the Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).*

## The problem

`ObservableObject` is often used as a kind of controller for SwiftUI `View`. After structured concurrency (async/await) was introduced we'll often need to set the value of a `@Published` property inside of a `ObservableObject`. This means wrapping the code in `DispatchQueue.main.async { ... }` or using a `@MainActor` annotated method. This can be done, but it's a lot of code.

## The solution

A protocol with no requirements that provides a default extension that exposes only one computed property: `.setOnMain`. This returns an object that can be subscripted into based on the `KeyPath`'s of the `ObservableObject` that implements the protocol.

## Usage

1. Add the protocol `MainThreadPropertyAccessor` to your `ObservableObject`
2. Use `self.setOnMain.somePropertyOfYourObject = newValue` to set properties on your `ObservableObject`

```swift
class AnObservableObject: ObservableObject, MainThreadPropertyAccessor {
    @Published var status:String = ""
    func updateStatus() {
        Task {
            // Do some async work
            self.status = "Will update the UI from a background thread" // Warning!
            self.setOnMain.status = "Will update the UI from the main dispatch queue" // 😘
        }
    }
}
```
