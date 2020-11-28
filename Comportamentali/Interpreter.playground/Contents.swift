//The interpreter pattern is used to evaluate sentences in a language.

//import XCTest

protocol Context {
    
}

protocol IntegerInterpret {
    func interpret(_ context: IntegerContext) -> Int
}

protocol IntegerExpression: IntegerInterpret {
    func interpret(_ context: IntegerContext) -> Int
    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression
    func copied() -> IntegerExpression
}

final class IntegerContext: Context {
    private var data: [Character:Int] = [:]

    func lookup(name: Character) -> Int {
        return self.data[name]!
    }

    func assign(expression: IntegerVariableExpression, value: Int) {
        self.data[expression.name] = value
    }
}

final class IntegerVariableExpression: IntegerExpression {
    
    let name: Character

    init(name: Character) {
        self.name = name
    }

    func interpret(_ context: IntegerContext) -> Int {
        return context.lookup(name: self.name)
    }

    func replace(character name: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        if name == self.name {
            return integerExpression.copied()
        } else {
            return IntegerVariableExpression(name: self.name)
        }
    }

    func copied() -> IntegerExpression {
        return IntegerVariableExpression(name: self.name)
    }
}

final class AddExpression: IntegerExpression {
    private var operand1: IntegerExpression
    private var operand2: IntegerExpression

    init(op1: IntegerExpression, op2: IntegerExpression) {
        self.operand1 = op1
        self.operand2 = op2
    }

    func interpret(_ context: IntegerContext) -> Int {
        return self.operand1.interpret(context) + self.operand2.interpret(context)
    }

    func replace(character: Character, integerExpression: IntegerExpression) -> IntegerExpression {
        return AddExpression(op1: operand1.replace(character: character, integerExpression: integerExpression),
                             op2: operand2.replace(character: character, integerExpression: integerExpression))
    }

    func copied() -> IntegerExpression {
        return AddExpression(op1: self.operand1, op2: self.operand2)
    }
}

// class InterpreterConceptual: XCTestCase {
//     func test() {
//         let context = IntegerContext()

//         let a = IntegerVariableExpression(name: "A")
//         let b = IntegerVariableExpression(name: "B")
//         let c = IntegerVariableExpression(name: "C")

//         let expression = AddExpression(op1: a, op2: AddExpression(op1: b, op2: c)) // a + (b + c)

//         context.assign(expression: a, value: 2)
//         context.assign(expression: b, value: 1)
//         context.assign(expression: c, value: 3)

//         expression.interpret(context)
//     }
// }

// InterpreterConceptual.defaultTestSuite.run()

let context = IntegerContext()

let a = IntegerVariableExpression(name: "A")
let b = IntegerVariableExpression(name: "B")
let c = IntegerVariableExpression(name: "C")

let expression = AddExpression(op1: a, op2: AddExpression(op1: b, op2: c)) // a + (b + c)

context.assign(expression: a, value: 2)
context.assign(expression: b, value: 1)
context.assign(expression: c, value: 3)

let result = expression.interpret(context)
print("Risultato dell'espressione: " + String(result));