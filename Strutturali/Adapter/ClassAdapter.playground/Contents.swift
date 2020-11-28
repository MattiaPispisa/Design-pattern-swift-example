import XCTest

//Esempio di Class adapter si vedere dal fato che Adapter eredita Adaptee

/// The Target defines the domain-specific interface used by the client code.

protocol Target {
    func request() -> String
}

extension Target {

    func request() -> String {
        return "Target: The default target's behavior."
    }
}

class ConcreteTarget: Target {

}

/// The Adaptee contains some useful behavior, but its interface is incompatible
/// with the existing client code. The Adaptee needs some adaptation before the
/// client code can use it.
class Adaptee {

    public func specificRequest() -> String {
        return ".eetpadA eht fo roivaheb laicepS"
    }
}

/// The Adapter makes the Adaptee's interface compatible with the Target's
/// interface.
class ClassAdapter: Adaptee,Target {

    func request() -> String {
        return "Adapter: (TRANSLATED) " + specificRequest().reversed()
    }
}

/// The client code supports all classes that follow the Target interface.
class Client {
    // ...
    static func someClientCode(target: Target) {
        print(target.request())
    }
    // ...
}

// Let's see how it all works together.
 class AdapterConceptual: XCTestCase {

     func testAdapterConceptual() {
         print("Client: I can work just fine with the Target objects:")
         Client.someClientCode(target: ConcreteTarget())

         let adaptee = Adaptee()
         print("Client: The Adaptee class has a weird interface. See, I don't understand it:")
         print("Adaptee: " + adaptee.specificRequest())

         print("Client: But I can work with it via the Adapter:")
         Client.someClientCode(target: ClassAdapter())
     }
 }

 AdapterConceptual.defaultTestSuite.run()

