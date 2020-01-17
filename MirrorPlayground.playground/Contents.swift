// MARK: - mirrors of instances -

// MARK: - objects
class AClass {
    let storedPropertyStr: String
    let storedPropertyInt: Int
    let storedObject: BClass
    var computedProperty: String {
        return "hi"
    }

    init(title: String, number: Int, object: BClass) {
        storedPropertyStr = title
        storedPropertyInt = number
        storedObject = object
    }
}

class BClass {
    let name: String

    init(name: String) {
        self.name = name
    }
}

let aObject = AClass(title: "a", number: 1, object: BClass(name: "b"))
let aObjectMirror = Mirror(reflecting: aObject)
print(aObjectMirror.displayStyle!) // class
aObjectMirror.children.forEach { print($0) }
/*
 (label: Optional("storedPropertyStr"), value: "a")
 (label: Optional("storedPropertyInt"), value: 1)
*/
print(aObjectMirror.descendant("storedObject", "name")!) // b

print("\n------\n")

// MARK: - structs
struct AStruct {
    let storedProperty: Int = 0
    var computedProperty: Int {
        return 1
    }
}
let aStruct = AStruct()
let aStructMirror = Mirror(reflecting: aStruct)
print(aStructMirror.displayStyle!) // struct
aStructMirror.children.forEach { print($0) }
/*
 (label: Optional("storedProperty"), value: 0)
*/

print("\n------\n")

// MARK: - arrays
let aArray = ["a", "b", "c"]
let aArrayMirror = Mirror(reflecting: aArray)
print(aArrayMirror.displayStyle!) // collection
aArrayMirror.children.forEach { print($0) }
/*
 (label: nil, value: "a")
 (label: nil, value: "b")
 (label: nil, value: "c")
*/

print("\n------\n")

// MARK: - sets
let aSet: Set<String> = ["a", "b", "c"]
let aSetMirror = Mirror(reflecting: aSet)
print(aSetMirror.displayStyle!) // set
aSetMirror.children.forEach { print($0) }
/*
 (label: nil, value: "b")
 (label: nil, value: "c")
 (label: nil, value: "a")
 */

print("\n------\n")

// MARK: - dictionaries
let aDictionary = ["key1": "a", "key2": "b", "key3": "c"]
let aDictionaryMirror = Mirror(reflecting: aDictionary)
print(aDictionaryMirror.displayStyle!) // dictionary
aDictionaryMirror.children.forEach { print($0) }
/*
 (label: nil, value: (key: "key2", value: "b"))
 (label: nil, value: (key: "key1", value: "a"))
 (label: nil, value: (key: "key3", value: "c"))
 */

print("\n------\n")

// MARK: - tuples
let aTuple = ("a", labeled: 2, 9)
let aTupleMirror = Mirror(reflecting: aTuple)
print(aTupleMirror.displayStyle!) // tuple
aTupleMirror.children.forEach { print($0) }
/*
 (label: Optional(".0"), value: "a")
 (label: Optional("labeled"), value: 2)
 (label: Optional(".2"), value: 9)
 */

print("\n------\n")

// MARK: - enums
enum AEnum {
    case first
    case seconde
    case third
}
enum AEnumWithAssociatedValues {
    case first
    case second(with: String)
    case third(title: String, Value: Int, complete: (() -> Void)?)
}

let aEnum = AEnum.seconde
let aEnumMirror = Mirror(reflecting: aEnum)
print(aEnumMirror.displayStyle!) // enum
aEnumMirror.children.forEach { print($0) }
/*
 */
print(aEnumMirror.children.count) // 0

print("*****")

let aEnumWithAssociatedValues = AEnumWithAssociatedValues.third(title: "a",
                                                                Value: 1,
                                                                complete: nil)
let aEnumWithAssociatedValuesMirror = Mirror(reflecting: aEnumWithAssociatedValues)
print(aEnumWithAssociatedValuesMirror.displayStyle!) // enum
aEnumWithAssociatedValuesMirror.children.forEach { print($0) }
/*
 enum
 0
 enum
 (label: Optional("third"), value: (title: "a", Value: 1, complete: nil))
 */

print("\n------\n")

// MARK: - types
let aType = String.self
let aTypeMirror = Mirror(reflecting: aType)
print(aTypeMirror.displayStyle ?? "nil") // nil
aTypeMirror.children.forEach { print($0) }
/*
 */
print(aTypeMirror.children.count) // 0
