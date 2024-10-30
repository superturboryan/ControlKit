//
//  BetweenZeroAndOneInclusive.swift
//  ControlKit
//

@propertyWrapper
struct BetweenZeroAndOneInclusive {
    
    private var value: Float
    private let range: ClosedRange<Float> = 0.0...1.0

    init(wrappedValue: Float) {
        value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }

    var wrappedValue: Float {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
}
