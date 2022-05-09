/// Collection of extensions for lists.
extension ListExtensions<T> on Iterable<T> {
  /// Puts an element between each element of the list.
  Iterable<T> putElementBetween(T element) sync* {
    final Iterator<T> iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield element;
        yield iterator.current;
      }
    }
  }
}
