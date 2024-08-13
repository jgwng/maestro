abstract class AuthEvent{

}

class LoginEvent extends AuthEvent{
  final String id;
  final String password;

  LoginEvent(this.id,this.password);
}

class LogoutEvent extends AuthEvent{
  LogoutEvent();
}