class Result<T, E> {
  final T? data;
  final E? error;
  final bool isNotFound;

  Result.success(this.data)
      : error = null,
        isNotFound = false;

  Result.notFound()
      : data = null,
        error = null,
        isNotFound = true;

  Result.failure(this.error)
      : data = null,
        isNotFound = false;

  bool get isSuccess => data != null;
  bool get isFailure => error != null;
  bool get isEmpty => isNotFound; // Для зручності
}
