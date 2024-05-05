import '../../features/user/data/models/user_model.dart';

class Current {
  static UserModel user = UserModel.init();
  static bool isLoggedIn = false;
}
