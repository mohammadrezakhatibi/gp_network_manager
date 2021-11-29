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

// class DataResponse<T> {
//   T? data;

//   DataResponse.fromJson(Json json) : data = json['data'];
// }

// class ArrayResponses<T> {
//   List<T> data;

//   ArrayResponses(this.data);

//   ArrayResponses.fromJson(Json json) : data = json['data'];
// }

// class ResponsesResults<T> {
//   List<T> results;

//   ResponsesResults(this.results);

//   ResponsesResults.fromJson(Json json) : results = json['results'];
// }

// class DataItemResponse<T> {
//   T data;

//   DataItemResponse(this.data);

//   DataItemResponse.fromJson(Json json) : data = json['data'];
// }

// class NullResponse {}
