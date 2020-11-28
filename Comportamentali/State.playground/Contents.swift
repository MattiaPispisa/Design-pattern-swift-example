//import XCTest

/// The Context defines the interface of interest to clients. It also maintains
/// a reference to an instance of a State subclass, which represents the current
/// state of the Context.
class Contesto {

    /// A reference to the current state of the Context.
    private var stato: Stato

    private var nameStateWorking: String {
        get {
            String(describing: stato)
        }
    }

    init(_ stato: Stato) {
        self.stato = stato
        transitionTo(stato: stato)
    }

    /// The Context allows changing the State object at runtime.
    func transitionTo(stato: Stato) {
        print("Context: Transition to " + nameStateWorking)
        self.stato = stato
        self.stato.update(context: self)
    }

    /// The Context delegates part of its behavior to the current State object.
    func request1() {
        stato.handle1()
    }

    func request2() {
        stato.handle2()
    }
}

/// The base State class declares methods that all Concrete State should
/// implement and also provides a backreference to the Context object,
/// associated with the State. This backreference can be used by States to
/// transition the Context to another State.
protocol Stato: class {

    func update(context: Contesto)

    func handle1()
    func handle2()
}

class BaseState: Stato {

    private(set) weak var context: Contesto? 

    func update(context: Contesto) {
        self.context = context
    }

    func handle1() {}
    func handle2() {}
}

/// Concrete States implement various behaviors, associated with a state of the
/// Context.
class ConcreteStateA: BaseState {

    override func handle1() {
        print("ConcreteStateA handles request1.")
        print("ConcreteStateA wants to change the state of the context.\n")
        context?.transitionTo(stato: ConcreteStateB())
    }

    override func handle2() {
        print("ConcreteStateA handles request2.\n")
    }
}

class ConcreteStateB: BaseState {

    override func handle1() {
        print("ConcreteStateB handles request1.\n")
    }

    override func handle2() {
        print("ConcreteStateB handles request2.")
        print("ConcreteStateB wants to change the state of the context.\n")
        context?.transitionTo(stato: ConcreteStateA())
    }
}

/// Let's see how it all works together.
// class StateConceptual: XCTestCase {

//     func test() {
//         let context = Contesto(ConcreteStateA())
//         context.request1()
//         context.request2()
//     }
// }

// StateConceptual.defaultTestSuite.run()


let context = Contesto(ConcreteStateA())
//richiedo il lavoro al contesto e di conseguenza viene cambiato lo stato (se serve)
//esempio:
//stato iniziale = cancello chiuso
//se request1 = apri il cancello 
//allora lo stato che raggiungerò sara cancello aperto
context.request1()
//dato che la request1 ha cambiato lo stato request2 cambia comportamento (reagirà allo stato cancello aperto)
context.request2()