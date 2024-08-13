class AuthState{
  final bool isLogin;
  final bool isNetworking;

  const AuthState({
    this.isLogin = false,
    this.isNetworking = false,
  });


  AuthState copyWith({
    bool? isLogin,
    bool? isNetworking,
  }) {
    return AuthState(
      isLogin: isLogin ?? this.isLogin,
      isNetworking: isNetworking ?? this.isNetworking,
    );
  }

}