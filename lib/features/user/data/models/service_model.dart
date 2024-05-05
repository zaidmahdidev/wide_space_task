import '../../../../core/models/current_provider.dart';

class ServiceModel {
  int? _id;
  String? _name;
  bool? _active;
  String? _description;
  bool? _canBePerformedBySubwallet;
  num? _amount; // the default amount per day for sub-wallet
  int? _repetition; // the default repetition per day for sub-wallet

  int? get id => _id;

  String get name => _name ?? Current.user.firstName!;

  String get description => _description ?? "";

  bool get active => _active ?? false;

  bool get canBePerformedBySubwallet => _canBePerformedBySubwallet ?? false;

  num get amount => _amount ?? 0;

  int get repetition => _repetition ?? 0;

  set repetition(int? repetition) {
    _repetition = repetition;
  }

  set amount(num amount) {
    _amount = amount;
  }

  set active(bool active) {
    _active = active;
  }

  // Widget actionPage() {
  //   if ([TransactionTypeModel.p2p, TransactionTypeModel.m2p, TransactionTypeModel.viral].contains(serviceTransactionType)) {
  //     return SendMoneyScreen(
  //       transactionType: serviceTransactionType,
  //     );
  //   } else if (serviceTransactionType == TransactionTypeModel.r2p) {
  //     return ReceiveMoneyScreen(
  //       transactionType: serviceTransactionType,
  //     );
  //   } else if ([TransactionTypeModel.topUp, TransactionTypeModel.billPay].contains(serviceTransactionType)) {
  //     return TopupMethodsListScreen(
  //       transactionType: serviceTransactionType,
  //     );
  //   } else if (serviceTransactionType == TransactionTypeModel.cashOut) {
  //     if (Current.user.isAgent) {
  //       return AgentCashoutScreen(transactionType: serviceTransactionType);
  //     } else {
  //       return UserCashoutScreen(
  //         transactionType: serviceTransactionType,
  //       );
  //     }
  //   } else if (serviceTransactionType == TransactionTypeModel.p2m || serviceTransactionType == TransactionTypeModel.m2m) {
  //     return PurchaseScreen(
  //       transactionType: serviceTransactionType,
  //     );
  //   } else if (serviceTransactionType == TransactionTypeModel.loan) {
  //     return LoanMethodsListScreen(transactionType: TransactionTypeModel.loan);
  //   } else if (serviceTransactionType == TransactionTypeModel.cashIn) {
  //     return AgentCashInScreen(transactionType: TransactionTypeModel.cashIn);
  //   } else {
  //     return const LostScreen();
  //   }
  // }

  ServiceModel({
    int? id,
    String? name,
    String? description,
    bool? active,
    bool? canBePerformedBySubwallet,
    num? amount,
    int? repetition,
  }) {
    _id = id;
    _name = name;
    _description = description;
    _active = active;
    _canBePerformedBySubwallet = canBePerformedBySubwallet;
    _amount = amount;
    _repetition = repetition;
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['service_id'] ?? json['transaction_type_id'],
      // service_id when comes from subwallets in me , id when comes from wallets in me
      name: json['name'],
      description: json['description'],
      active: json['active'] == 1,
      canBePerformedBySubwallet: json['is_subwallet'] == 1,
      amount: json['amount'] ?? 0,
      repetition: json['repetition'] ?? 0,
    );
  }

  ServiceModel fromJson(Map<String, dynamic> json) {
    return ServiceModel.fromJson(json);
  }

  static fromJsonList(List<dynamic> jsonList) {
    List<ServiceModel> serviceModelsList = [];
    for (var jsonModel in jsonList) {
      serviceModelsList.add(ServiceModel.fromJson(jsonModel));
    }

    return serviceModelsList;
  }

  factory ServiceModel.init() {
    return ServiceModel(id: 0, name: '', description: '', active: false);
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_type_id': _id,
      'name': _name,
      'description': _description,
      'active': _active,
      'amount': _amount,
      'repetition': _repetition,
      'default': 0,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => super.hashCode ^ id.hashCode;
}
