class Meal{
  final String _name;
  final DateTime _dataTime;
  //add List<Product>

  Meal(this._name, this._dataTime);

  String get name => _name;

  DateTime get dateTime => _dataTime;

}