extension Router {

    /**
     Junction Router

     A fork in the road. You can see all the paths in front of you (setChildren), but can only
     drive down one path at a time (setChild).

     The junction function is a Router behaviour customiser. It replaces handlesRoute and setRoute
     with functions that behave like a Junction Router and returns a modified copy of the Router.

     - parameter junctions: [Router<T>], an array of child routers to present

     - returns: Router<T>, a customised copy of self
     */
    public func junction(_ junctions: [Router<ViewController, Path>])
        -> Router<ViewController, Path> {

            var router = self

            router.handlesRoute = { path in
                return junctions.contains { $0.handlesRoute?(path) ?? false }
            }
            router.setRoute = { path in
                // inform the junction presenter of the available children
                router.presenter?.set(junctions.compactMap { $0.presentable })

                if let junction = junctions.pickFirst({ $0.handlesRoute?(path) == true ? $0 : nil }) {
                    // if a child matches, pass the path to it
                    _ = junction.setRoute?(path)
                    // and set it as the active junction
                    if let presentable = junction.presentable {
                        router.presenter?.set(presentable)
                    }
                    return true
                }
                return false
            }
            router.dispose = {
                junctions.forEach { $0.dispose?() }
                
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
