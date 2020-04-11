//
// Introductory information can be found in the `README.md` file located in the root directory of this repository.
// Licensing information can be found in the `LICENSE` file located in the root directory of this repository.
//

extension Patterns {

    // Exposed

    // Type: Patterns
    // Topic: Many

    ///
    @frozen
    public struct Many<Pattern>
    where Pattern: PatternProtocol {

        // Exposed

        // Type: Patterns.Many
        // Topic: Main

        ///
        @inlinable
        public init(
            _ pattern: Pattern,
            smallestCount: Int? = nil,
            largestCount: Int? = nil
        ) {
            self.pattern = pattern
            self.smallestCount = smallestCount
            self.largestCount = largestCount
        }

        ///
        public var pattern: Pattern

        ///
        public var smallestCount: Int?

        ///
        public var largestCount: Int?
    }
}

extension Patterns.Many {

    // Concealed

    // Type: Patterns.Many
    // Topic: Main

    private func _isIterationSmallEnough(_ iteration: Int) -> Bool {
        guard let largestCount = largestCount else {
            return true
        }
        return iteration < largestCount
    }

    private func _isIterationLargeEnough(_ iteration: Int) -> Bool {
        guard let smallestCount = smallestCount else {
            return true
        }
        return iteration >= smallestCount
    }
}

extension Patterns.Many: PatternProtocol {

    // Exposed

    // Protocol: PatternProtocol
    // Topic: Main

    public typealias Sample = Pattern.Sample

    public func indexAfterMatching<S>(atStartIndexOf samples: S) -> S.Index?
    where S: Collection, S.Element == Sample {
        var index: S.Index = samples.startIndex
        var iteration = 0
        while
            _isIterationSmallEnough(iteration),
            let nextIndex = pattern.indexAfterMatching(atStartIndexOf: samples[index...])
        {
            index = nextIndex
            iteration += 1
        }
        guard _isIterationLargeEnough(iteration) else {
            return nil
        }
        return index
    }
}

extension PatternProtocol {

    // Exposed

    // Type: PatternProtocol
    // Topic: Many

    ///
    @inlinable
    public static func * (_ some: Self, _ other: Int) -> Patterns.Many<Self> {
        .init(some, smallestCount: other, largestCount: other)
    }

    ///
    @inlinable
    public static func * (_ some: Self, _ other: PartialRangeFrom<Int>) -> Patterns.Many<Self> {
        .init(some, smallestCount: other.lowerBound)
    }

    ///
    @inlinable
    public static func * (_ some: Self, _ other: PartialRangeThrough<Int>) -> Patterns.Many<Self> {
        .init(some, largestCount: other.upperBound)
    }

    ///
    @inlinable
    public static func * (_ some: Self, _ other: PartialRangeUpTo<Int>) -> Patterns.Many<Self> {
        .init(some, largestCount: other.upperBound - 1)
    }

    ///
    @inlinable
    public static func * (_ some: Self, _ other: ClosedRange<Int>) -> Patterns.Many<Self> {
        .init(some, smallestCount: other.lowerBound, largestCount: other.upperBound)
    }

    ///
    @inlinable
    public static func * (_ some: Self, _ other: Range<Int>) -> Patterns.Many<Self> {
        .init(some, smallestCount: other.lowerBound, largestCount: other.upperBound - 1)
    }

    ///
    @inlinable
    public func many() -> Patterns.Many<Self> {
        .init(self)
    }
}
