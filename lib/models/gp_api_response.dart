class GPApiResponse<T> {
  ResponseStatus status;
  T? data;
  String? message;

  GPApiResponse({this.status = ResponseStatus.begin, this.data, this.message});

  GPApiResponse.begin() : status = ResponseStatus.begin;
  GPApiResponse.loading(this.message) : status = ResponseStatus.loading;
  GPApiResponse.completed(this.data) : status = ResponseStatus.completed;
  GPApiResponse.error(this.message) : status = ResponseStatus.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

typedef Json = Map<String, dynamic>;

enum ResponseStatus {
  begin,
  loading,
  completed,
  error,
}
