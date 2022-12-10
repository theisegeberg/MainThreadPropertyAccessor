import Foundation

/// Accesses a value of an root object `Root`, through a subscript on a specific queue.
///
/// The problem that this object addresses is the need for an `ObservableObject` to run a `Task`
/// closure but very often set properties on the `ObservableObject` itself on the main dispatch queue
/// where all UI updates are required to occur in `SwiftUI`.
///
/// - Important: Trying to get the value of the property will cause a fatal error, and is not supported.
@dynamicMemberLookup
public struct DispatchQueueAccessor<Root: AnyObject> {
    private weak var root: Root?
    private let queue: DispatchQueue
    
    /// Initialises an `DispatchQueueAccessor` with a root and an optional queue.
    /// - Parameters:
    ///   - root: The `Root` object in `KeyPath` terms.
    ///   The object on which you want to access properties.
    ///   - queue: The `DispatchQueue` you want to perform the setting of properties on.
    ///   It's default value is `DispatchQueue.main`.
    init(root: Root, queue: DispatchQueue = DispatchQueue.main) {
        self.root = root
        self.queue = queue
    }
    
    /// This subscript provides access to the `Root` objects properties. Setting this value will set it to the
    /// new value on the given queue. Getting values through this subscript will cause a fatal error and is
    /// not supported.
    public subscript<Value>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Root, Value>
    ) -> Value {
        get {
            fatalError("You're not supposed to use `.setOnMain`to get values, instead just use to the regular property on the object.")
        }
        set {
            queue.async {
                [weak root] in
                root?[keyPath: keyPath] = newValue
            }
        }
    }
}
