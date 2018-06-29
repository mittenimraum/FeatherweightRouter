/**

 To control the display or change of route, each router needs a presenter to hand off to. The
 presenter separates the route tree from interface code.

 The actual presenter is owned by the presenter which can control the lifecycle of ViewControllers.

 It is a structure that bridges commands between the Router and View. As such about the only thing
 we need to test is that the commands are forwarded correctly.

 */
public struct Presenter<ViewController> {

    /// Returns the child presenter
    public var getPresentable: (() -> ViewController?)?

    /// Sets the child value to the passed in presenter
    public var setChild: ((ViewController) -> Void)?
    
    /// Sets the children value to passed in presenters
    public var setChildren: (([ViewController]) -> Void)?

    /// The owned presenter
    public var presentable: ViewController? { return getPresentable?() }
    
    /// Dispose
    public var dispose: (() -> Void)?

    /**
     Shorthand for the setChild function

     - parameter child: child presenter
     */
    public func set(_ child: ViewController) {
        guard let setChild = setChild else {
            return
        }
        setChild(child)
    }

    /**
     Shorthand for the setChildren function

     - parameter children: presenter children
     */
    public func set(_ children: [ViewController]) {
        guard let setChildren = setChildren else {
            return
        }
        setChildren(children)
    }

    /**
     Presenter initialiser

     - parameter getPresentable: Returns the owned presenter
     - parameter setChild:       Callback action to set the child presenter
     - parameter setChildren:    Callback to set the children presenters
     */
    public init(getPresentable: @escaping () -> ViewController?,
                setChild: ((ViewController) -> Void)? = nil,
                setChildren: (([ViewController]) -> Void)? = nil,
                dispose: (() -> Void)? = nil) {
        self.getPresentable = getPresentable
        self.setChild = setChild
        self.setChildren = setChildren
        self.dispose = dispose
    }
}
