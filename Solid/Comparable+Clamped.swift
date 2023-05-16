// https://stackoverflow.com/questions/36110620/standard-way-to-clamp-a-number-between-two-values-in-swift/40868784#40868784
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
