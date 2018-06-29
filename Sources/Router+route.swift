extension Router {

    /**
     Route extension

     A named destination. Unlike the Junction and Stack, Route is a valid endpoint. To drive to
     town, there may be multiple routes with varying junctions and paths to take, but the
     destination will remain the same.

     - parameter predicate: A String containing a regex that possibly matches to provided paths.
     - parameter children: Array of little Router children.

     - returns: A customised copy of Router<T>
     */
    public func route(predicate
        pathMatches: @escaping ((Path) -> Bool), children: [Router<ViewController, Path>] = []) ->
        Router<ViewController, Path> {

            var router = self
            
            router.handlesRoute = { path in
                return pathMatches(path) || children.contains { $0.handlesRoute?(path) ?? false }
            }
            if let _ = router.presenter?.setChild {
                router.setRoute = { path in
                    guard let child = children.filter({ $0.handlesRoute?(path) ?? false }).first else {
                        return false
                    }
                    _ = child.setRoute?(path)
                    if let presentable = child.presentable {
                        router.presenter?.set(presentable)
                    }
                    return true
                }
            }
            router.getStack = { path in
                let presentable = router.presenter?.presentable
                
                if pathMatches(path) {
                    return presentable == nil ? [] : [presentable!]
                }
                for child in children {
                    if let stack = child.getStack?(path) {
                        return (presentable == nil ? [] : [presentable!]) + stack
                    }
                }
                return nil
            }
            router.dispose = {
                children.forEach { $0.dispose?() }
                
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
