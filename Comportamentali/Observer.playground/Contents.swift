import XCTest

/// The Subject owns some important state and notifies observers when the state
/// changes.

protocol Subject {

    var observers: [Observer] {get set}
    func register(_ observer: Observer) 
    func remove(_ observer: Observer) 
    func notify()
}

class ConcreteSubject: Subject {

    /// For the sake of simplicity, the Subject's state, essential to all
    /// subscribers, is stored in this variable.
    var state: Int = { return Int.random(in: 0..<10) }()

    /// @var array List of subscribers. In real life, the list of subscribers
    /// can be stored more comprehensively (categorized by event type, etc.).
    var observers: [Observer]
    init() {
        observers = [Observer]()
    }

    /// The subscription management methods.
    func register(_ observer: Observer) {
        print("Subject: registered an observer.\n")
        observers.append(observer)
    }

    func remove(_ observer: Observer) {
        if let idx = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: idx)
            print("Subject: removeed an observer.\n")
        }
    }

    /// Trigger an update in each subscriber.
    func notify() {
        print("Subject: Notifying observers...\n")
        observers.forEach({ $0.update(subject: self)})
    }

    /// Usually, the subscription logic is only a fraction of what a Subject can
    /// really do. Subjects commonly hold some important business logic, that
    /// triggers a notification method whenever something important is about to
    /// happen (or after it).
    func someBusinessLogic() {
        print("\nSubject: I'm doing something important.\n")
        state = Int.random(in: 0..<10)
        print("Subject: My state has just changed to: \(state)\n")
        notify()
    }
}

/// The Observer protocol declares the update method, used by subjects.
protocol Observer: class {

    func update(subject: ConcreteSubject)
}

/// Concrete Observers react to the updates issued by the Subject they had been
/// registered to.
class ConcreteObserverA: Observer {

    func update(subject: ConcreteSubject) {

        if subject.state < 3 {
            print("ConcreteObserverA: Reacted to the event.\n")
        }
    }
}

class ConcreteObserverB: Observer {

    func update(subject: ConcreteSubject) {

        if subject.state >= 3 {
            print("ConcreteObserverB: Reacted to the event.\n")
        }
    }
}

/// Let's see how it all works together.
 class ObserverConceptual: XCTestCase {

     func testObserverConceptual() {

         let subject = ConcreteSubject()

         let observer1 = ConcreteObserverA()
         let observer2 = ConcreteObserverB()

         subject.register(observer1)
         subject.register(observer2)

         subject.someBusinessLogic()
         subject.someBusinessLogic()
         subject.remove(observer2)
         subject.someBusinessLogic()
     }
 }
