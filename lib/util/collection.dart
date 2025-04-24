/// Extension that provides additional utility methods for lists.
extension AppList<E> on List<E> {
  /// Maps each element along with its index to a new value.
  ///
  /// Similar to [Iterable.map], but the provided [convert] function
  /// receives both the index and the element at that index.
  ///
  /// Example:
  /// ```dart
  /// final list = ['a', 'b', 'c'];
  /// final result = list.mapIndexed((index, element) => '$index:$element');
  /// // result is ['0:a', '1:b', '2:c']
  /// ```
  ///
  /// Returns an [Iterable] with the results of applying [convert]
  /// to each element with its index in the original list.
  Iterable<R> mapIndexed<R>(R Function(int index, E element) convert) sync* {
    for (var index = 0; index < length; index++) {
      yield convert(index, this[index]);
    }
  }
}
