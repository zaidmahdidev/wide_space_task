// import 'package:dartz/dartz.dart';
//
// import '../data_providers/remote_data_provider.dart';
// import '../errors/failures.dart';
// import '../network/data_source_url.dart';
// import '../repository.dart';
// import '../utils/common_utils.dart';
//
// mixin AvailableSubWalletsMixin on Repository {
//   Future<Either<Failure, dynamic>> getAvailableWallets(
//       {required String phoneNumber, required int currencyId}) async {
//     return await sendRequest(
//       checkConnection: networkInfo.isConnected,
//       remoteFunction: () async {
//         final remoteData = await remoteDataProvider.sendData(
//           url: DataSourceURL.availableWallets(phoneNumber: phoneNumber),
//           retrievedDataType: TargetWalletModel.init(),
//           requestType: RequestTypes.post,
//           returnType: List,
//           body: {
//             'to_id': parsePhone(phoneNumber),
//             'currency_id': currencyId,
//           },
//         );
//         return remoteData;
//       },
//     );
//   }
// }
