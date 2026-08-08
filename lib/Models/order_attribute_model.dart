class FilterModel {
  final String? value;
  bool isSelected;

  set changeIsSelected(bool val) {
    isSelected = val;
  }

  FilterModel({this.value, this.isSelected = false});
}

class OrderAttribute {
  final String? attributeName;
  final List<FilterModel>? attributeValues;

  OrderAttribute({this.attributeName, this.attributeValues});
}
