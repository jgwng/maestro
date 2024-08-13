import 'package:client/business_logic/event/auth_event.dart';
import 'package:client/business_logic/state/auth_state.dart';
import 'package:client/network/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc() : super(const AuthState()){
    on<LoginEvent>(_onLoginUser);
    on<LogoutEvent>(_onLogoutUser);
  }
  AuthRepository repository = AuthRepository();

  void _onLoginUser(LoginEvent event, Emitter<AuthState> emit) async{
    if(state.isNetworking == true) return;

    emit(state.copyWith(isNetworking: true));
    var response = await repository.loginUser(
      id: event.id,
      password: event.password
    );
    emit(state.copyWith(isNetworking: false,isLogin: response));
  }

  void _onLogoutUser(LogoutEvent event, Emitter<AuthState> emit) async{
    emit(state.copyWith(isNetworking: true));
    await repository.logoutUser();
    emit(state.copyWith(isNetworking: false,isLogin: false));
  }


}