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
  bool get isEmpty => isNotFound;

  R when<R>({
    required R Function(T data) success,
    required R Function() notFound,
    required R Function(E error) failure,
  }) {
    if (isSuccess) {
      return success(data as T);
    } else if (isNotFound) {
      return notFound();
    } else if (isFailure) {
      return failure(error as E);
    } else {
      throw Exception("Unhandled Result state");
    }
  }

}
