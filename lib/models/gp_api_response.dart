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

enum Status {
  begin,
  loading,
  completed,
  error,
}

class DataResponse<T> {
  T? data;
}

class ArrayResponses<T> {
  List<T> data;

  ArrayResponses(this.data);
}

class ResponsesResults<T> {
  List<T> results;

  ResponsesResults(this.results);
}

class DataItemResponse<T> {
  List<ItemResponse<T>> data;

  DataItemResponse(this.data);
}

class ItemResponse<T> {
  List<T> items;
  Pager? pager;
  ItemResponse(this.items);
}

class Pager {
  int? totalItems;
  int? pageNumber;
  int? pageSize;
}

class NullResponse {}
