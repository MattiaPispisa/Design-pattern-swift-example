import XCTest

/// The Mediator interface declares a method used by components to notify the
/// mediator about various events. The Mediator may react to these events and
/// pass the execution to other components.
protocol Mediator: AnyObject {

    func notify(sender: Partner, event: String)
}

/// Concrete Mediators implement cooperative behavior by coordinating several
/// components.
class ConcreteMediator: Mediator {

    private var component1: ConcretePartner1
    private var component2: ConcretePartner2

    init(_ component1: ConcretePartner1, _ component2: ConcretePartner2) {
        self.component1 = component1
        self.component2 = component2

        component1.update(mediator: self)
        component2.update(mediator: self)
    }

    func notify(sender: Partner, event: String) {
        if event == "A" {
            print("Mediator reacts on A and triggers following operations:")
            self.component2.doC()
        }
        else if (event == "D") {
            print("Mediator reacts on D and triggers following operations:")
            self.component1.doB()
            self.component2.doC()
        }
    }
}

/// The Base Component provides the basic functionality of storing a mediator's
/// instance inside component objects.
class Partner {

    fileprivate weak var mediator: Mediator?

    init(mediator: Mediator? = nil) {
        self.mediator = mediator
    }

    func update(mediator: Mediator) {
        self.mediator = mediator
    }
}

/// Concrete Components implement various functionality. They don't depend on
/// other components. They also don't depend on any concrete mediator classes.
class ConcretePartner1: Partner {

    func doA() {
        print("Component 1 does A.")
        mediator?.notify(sender: self, event: "A")
    }

    func doB() {
        print("Component 1 does B.\n")
        mediator?.notify(sender: self, event: "B")
    }
}

class ConcretePartner2: Partner {

    func doC() {
        print("Component 2 does C.")
        mediator?.notify(sender: self, event: "C")
    }

    func doD() {
        print("Component 2 does D.")
        mediator?.notify(sender: self, event: "D")
    }
}

/// Let's see how it all works together.
class MediatorConceptual: XCTestCase {

    func testMediatorConceptual() {

        let concretePartner1 = ConcretePartner1()
        let concretePartner2 = ConcretePartner2()

        let mediator = ConcreteMediator(concretePartner1, concretePartner2)
        print("Client triggers operation A.")
        concretePartner1.doA()

        print("\nClient triggers operation D.")
        concretePartner2.doD()

        print(mediator)
    }
}
