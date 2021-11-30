class GPApiResponse<T> {
  Status status;
  T? data;
  String? message;

  GPApiResponse({this.status = Status.begin, this.data, this.message});

  GPApiResponse.begin() : status = Status.begin;
  GPApiResponse.loading(this.message) : status = Status.loading;
  GPApiResponse.completed(this.data) : status = Status.completed;
  GPApiResponse.error(this.message) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

typedef Json = Map<String, dynamic>;

enum Status {
  begin,
  loading,
  completed,
  error,
}
