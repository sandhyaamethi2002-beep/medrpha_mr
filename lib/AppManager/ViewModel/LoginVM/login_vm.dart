import '../../Models/LoginM/login_model.dart';
import '../../Services/LoginS/login_service.dart';

class LoginViewModel {

  final LoginService _service = LoginService();

  Future<LoginResponseModel?> login({
    required String userName,
    required String password,
  }) async {

    return await _service.login(
      userName: userName,
      password: password,
      role: 2,
    );
  }
}