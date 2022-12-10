import Foundation

/// Adopting this protocol will give access to `self.setOnMain` which is of type
/// DispatchQueueAccessor<Self>. This provides easy syntactic sugar for setting the value of a property on
/// the main dispatch queue. This is quite useful for when you run a `Task` in an `ObservableObject`
///  and whish to set a `@Published` property to update a SwiftUI `View`.
public protocol MainThreadPropertyAccessor: AnyObject {}

public extension MainThreadPropertyAccessor {
    /// Accesses properties the main dispatch queue.
    ///
    /// It enables you to write code from within `Task` closures without wrapping (the very common)
    /// act of setting a published property on an `ObservableObject`.
    ///
    /// The problem that this object addresses is the need for an `ObservableObject` to run a `Task`
    /// closure but very often set properties on the `ObservableObject` itself on the main dispatch
    /// queue where all UI updates are required to occur in `SwiftUI`.
    ///
    /// ```
    /// class SomeObservableObject: ObservableObject, MainThreadPropertyAccessor {
    ///     @Published var status:String = ""
    ///
    ///     func updateStatus() {
    ///         Task {
    ///             self.status = "Background thread badness" // ⚠️ Warning!
    ///             self.setOnMain.status = "Main thread goodness" // 😘
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Important: You can only use this property for setting values. Trying to get the value of a
    /// property will cause a fatal error.
    ///
    /// - Warning: Because it sets the value on the main dispatch queue asynchronously, the value will
    /// not be immediately set. So assume the value isn't immediately.
    var setOnMain: DispatchQueueAccessor<Self> {
        get {
            .init(root: self, queue: .main)
        }
        set {}
    }
}
