class Setting {
  int id;
  String apiUrl;
  String endPointGetPlu;
  String endPointSendData;
  String endPointGetOperator;
  String endPointGetModifier;
  String currency;
  String passwordSpv;
  String passwordAuth;
  int decimalPoint;
  int changeOperator;
  int editOrder;
  int auth;
  int tableOveride;
  int cover;

  Setting({this.id, this.apiUrl, this.endPointGetPlu,this.endPointSendData, this.passwordSpv,
    this.endPointGetOperator, this.endPointGetModifier,this.currency, this.decimalPoint, this.changeOperator, this.editOrder,
    this.auth, this.passwordAuth, this.tableOveride, this.cover});

  factory Setting.fromMap(dynamic data){
    return Setting(
      id: data['id'],
      apiUrl: data['apiUrl'],
      endPointGetPlu: data['endPointGetPlu'],
      endPointSendData: data['endPointSendData'],
      endPointGetOperator: data['endPointGetOperator'],
      endPointGetModifier: data['endpointGetModifier'],
      currency: data['currency'],
      passwordSpv: data['passwordSpv'],
      decimalPoint: data['decimalPoint'],
      changeOperator: data['changeOperator'],
      editOrder: data['editOrder'],
      auth: data['auth'],
      passwordAuth: data['passwordAuth'],
      tableOveride: data['tableOveride'],
      cover: data['cover']
    );
  }
}