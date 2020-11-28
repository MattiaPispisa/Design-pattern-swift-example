import XCTest

typealias Composto = Sequence
typealias Iteratore = IteratorProtocol

/// This is a collection that we're going to iterate through using an iterator
/// derived from IteratorProtocol.
class CompostoConcreto: Composto {

    fileprivate lazy var items = [String]()

    func append(_ item: String) {
        self.items.append(item)
    }
}

extension CompostoConcreto {

    func makeIterator() -> IteratoreConcreto {
        return IteratoreConcreto(self)
    }
}

/// Concrete Iterators implement various traversal algorithms. These classes
/// store the current traversal position at all times.
class IteratoreConcreto: Iteratore {

    private let collection: CompostoConcreto
    private var index = 0

    init(_ collection: CompostoConcreto) {
        self.collection = collection
    }

    func next() -> String? {
        defer { index += 1 }
        return index < collection.items.count ? collection.items[index] : nil
    }
}


/// Client does not know the internal representation of a given sequence.
class Client {
    // ...
    static func clientCode<S: Composto>(sequence: S) {
        for item in sequence {
            print(item)
        }
    }
    // ...
}

/// Let's see how it all works together.
 class IteratorConceptual: XCTestCase {

     func testIteratorProtocol() {

         let words = CompostoConcreto()
         words.append("First")
         words.append("Second")
         words.append("Third")

         print("Straight traversal using IteratorProtocol:")
         Client.clientCode(sequence: words)
     }

 }

