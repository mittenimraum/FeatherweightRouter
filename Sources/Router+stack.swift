extension Router {

    /**
     Stack Router

     Photos of every town you drive through to get to the destination. You may not be able to see
     the alternative paths, but you can navigate back to the start by traveling back through the
     waypoints in the stack.

     The Stack router behaviour is analogous to NavigationControllers.

     - parameter stack: Array of routes that may also have child routes.

     - returns: A customised copy of Router<T>
     */
    public func stack(_ stack: [Router<ViewController, Path>]) -> Router<ViewController, Path> {

        var router = self

        router.handlesRoute = { path in
            return stack.contains { $0.handlesRoute?(path) ?? false }
        }

        router.setRoute = { path in
            router.presenter?.set(stack.pickFirst { $0.getStack?(path) } ?? [])
            
            return true
        }
        router.dispose = {
            stack.forEach { $0.dispose?() }
            
            router.presenter?.dispose?()
            router.presenter = nil
            router.handlesRoute = nil
            router.getStack = nil
            router.setRoute = nil
            router.dispose = nil
        }
        return router
    }
}
