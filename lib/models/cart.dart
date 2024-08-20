class Cart {
  List<Map<dynamic, dynamic>> cartList;
  double grandTotal;

  Cart({required this.cartList, required this.grandTotal});

  double calGrandTotal() {
    double tempTotal = 0;
    for (Map<dynamic, dynamic> item in cartList) {
      tempTotal = tempTotal + item['quantity'] * item['unitPrice'];
    }
    return tempTotal;
  }
}
