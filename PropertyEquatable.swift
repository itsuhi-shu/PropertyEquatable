protocol PropertyEquatable: Equatable {}
extension PropertyEquatable {
    static func ~= (lhs: Self, rhs: Self) -> Bool {
        func recursiveCompareElements(lhs: Any, rhs: Any) -> Bool {
            let lMir = Mirror(reflecting: lhs)
            let rMir = Mirror(reflecting: rhs)

            return lMir.children.elementsEqual(rMir.children) { (lElm, rElm) -> Bool in
                guard let lKey = lElm.label,
                    let rKey = rElm.label,
                    lKey == rKey else {
                    return false
                }

                if let lVal = lElm.value as? Array<Any>,
                    let rVal = rElm.value as? Array<Any> {
                    return lVal.elementsEqual(rVal) { recursiveCompareElements(lhs: $0, rhs: $1) }
                }

                // TODO: Set & Dictionary

                if let lVal = lElm.value as? AnyHashable,
                    let rVal = rElm.value as? AnyHashable {
                    return lVal == rVal
                }

                return recursiveCompareElements(lhs: lElm.value, rhs: rElm.value)
            }
        }

        return recursiveCompareElements(lhs: lhs, rhs: rhs)
    }
}
