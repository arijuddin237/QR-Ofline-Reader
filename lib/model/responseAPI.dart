class ResponseAPI{
  final dynamic data;

  ResponseAPI({this.data});

  factory ResponseAPI.fromJson(dynamic json){
    return ResponseAPI(
      data: json
    );
  }
}