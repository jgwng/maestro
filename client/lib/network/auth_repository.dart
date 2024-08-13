class AuthRepository{
  AuthRepository._() : super(){
    _instance = this;
  }
  factory AuthRepository() => _instance ?? AuthRepository._();

  static AuthRepository? _instance;

  Future<bool> loginUser({String? id,String? password}) async {

    await Future<void>.delayed(const Duration(seconds: 1));

    if(id != 'admin'){
      return false;
    }

    if(password != 'qwer1234'){
      return false;
    }
    await Future<void>.delayed(const Duration(seconds: 1));

    return true;
  }

  Future<void> logoutUser() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}
