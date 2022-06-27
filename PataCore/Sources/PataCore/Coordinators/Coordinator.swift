//
//  Coordinator.swift
//  
//
//  Created by Franco on 26/06/22.
//

import Foundation

/// It defines relationship properties, children and router.
/// It also defines presentation methods, present and dismiss.
/// The concrete coordinator implements the coordinator protocol. It knows how to create concrete view controllers and the order in which view controllers should be displayed.
public protocol Coordinator: AnyObject {
    /// It holds the children for the concrete coordinator, we present children when they belong to the same coordinator flow.
    var children: [Coordinator] { get set }
    
    /// The start method, whenever using a coordinator we need to call this method in order to show a view controller.
    /// - Parameters:
    ///   - animated: if the view controller will be showed animated.
    ///   - onDismissed: caller when the coordinator is dismissed.
    func present(animated: Bool, onDismissed: (() -> Void)?)
    
    /// Internally it calls the router dismiss, each router will have different ways to dismiss.
    /// - Parameter animated: if the router will dismiss animating or not.
    /// - Parameter completion: The block to execute after the view controller is dismissed. This block has no return value and takes no parameters. You may specify nil for this parameter.
    func dismiss(animated: Bool, completion: (() -> Void)?)
    
    func presentChild(_ child: Coordinator, animated: Bool, onDismissed: (() -> Void)?)
}

public extension Coordinator {
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        children.forEach {
            $0.dismiss(animated: animated, completion: nil)
        }
        self.dismiss(animated: true, completion: completion)
    }
  
    func presentChild(_ child: Coordinator,
                      animated: Bool,
                      onDismissed: (() -> Void)? = nil) {
        children.append(child)
        child.present(animated: animated, onDismissed: { [weak self, weak child] in
            guard let self = self, let child = child else { return }
            self.removeChild(child)
            onDismissed?()
        })
    }

    private func removeChild(_ child: Coordinator) {
        guard let index = children.firstIndex(where: { $0 === child }) else {
            return
        }
        children.remove(at: index)
    }
}
