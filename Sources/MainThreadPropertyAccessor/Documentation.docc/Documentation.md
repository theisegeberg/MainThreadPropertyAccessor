# ``MainThreadPropertyAccessor``

Syntactic sugar for setting `Published` properties on an `ObservableObject` from within a `Task`.

## Overview

In SwiftUI you are required to set your `@Published` properties on the main thread. The `MainThreadPropertyAccessor` protocol gives you access to a property on your `ObservableObject` called `.setOnMain`. This property has all the same objects as `self`, but if you set them through this property then it'll be done on main.

### Usage

In the following example `AnObservableObject` implements `MainThreadPropertyAccessor`. Then when `self.status` is set it'll be done from a background thread, and cause a warning (and potentially not updated the UI). But when `self.setOnMain.status` is set it'll be done on the main thread.

```swift
class AnObservableObject: ObservableObject, MainThreadPropertyAccessor {
    @Published var status:String = ""
    func updateStatus() {
        Task {
            // ... Do some async work ...
            self.status = "Will update the UI from a background thread" 
            // Warning!
            
            self.setOnMain.status = "Will update the UI from the main dispatch queue"
            // 😘
        }
    }
}
```


## Topics

### Group
