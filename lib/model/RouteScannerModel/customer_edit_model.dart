class CustomerEditModel {
  // TODO فرمت صیحیح داده ها برای عملکرد بهتر نرم افزار
  dynamic customerCode; // int
  dynamic nationalCode; // str
  dynamic roleCode; // int
  dynamic postalCode; // str
  dynamic customerBoard; // str
  dynamic customerName; // str
  dynamic address; // str
  dynamic mobileNumber; // str
  dynamic mobileNumber2; // str
  dynamic phoneNumber; // str
  dynamic storeArea; // int

  CustomerEditModel({
    this.customerCode,
    this.nationalCode,
    this.roleCode,
    this.postalCode,
    this.customerBoard,
    this.customerName,
    this.address,
    this.mobileNumber,
    this.mobileNumber2,
    this.phoneNumber,
    this.storeArea,
  });

  CustomerEditModel.fromJson(Map<String, dynamic> json) {
    customerCode = json['customer_code'];
    nationalCode = json['nationalCode'];
    roleCode = json['roleCode'];
    postalCode = json['postalCode'];
    customerBoard = json['customerboard'];
    customerName = json['custumername'];
    address = json['address'];
    mobileNumber = json['mobileNumber'];
    mobileNumber2 = json['mobileNumber2'];
    phoneNumber = json['phoneNumber'];
    storeArea = json['storeArea'];
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_code': customerCode,
      'nationalCode': nationalCode,
      'roleCode': roleCode,
      'postalCode': postalCode,
      'customerboard': customerBoard,
      'custumername': customerName,
      'address': address,
      'mobileNumber': mobileNumber,
      'mobileNumber2': mobileNumber2,
      'phoneNumber': phoneNumber,
      'storeArea': storeArea,
    };
  }
}
