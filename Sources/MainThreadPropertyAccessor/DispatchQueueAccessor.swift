import Foundation

/// Accesses a value of an root object `Root`, through a subscript on a specific queue.
///
/// The problem that this object addresses is the need for an `ObservableObject` to run a `Task`
/// closure but very often set properties on the `ObservableObject` itself on the main dispatch queue
/// where all UI updates are required to occur in `SwiftUI`.
///
/// - Important: Reading the value will produce an optional because the root object is weakly retained.
/// If you want to read it just read it directly from the `Root` object.
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
    
    /// This subscript provides access to the `Root` objects properties. Setting is like normal setting of
    /// the property. But getting will happen on the chosen dispatch queue.
    public subscript<Value>(
        dynamicMember keyPath: ReferenceWritableKeyPath<Root, Value>
    ) -> Value? {
        get {
            root?[keyPath: keyPath]
        }
        set {
            guard let newValue else {
                return
            }
            queue.async {
                [weak root] in
                root?[keyPath: keyPath] = newValue
            }
        }
    }
}
