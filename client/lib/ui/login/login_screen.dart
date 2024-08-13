import 'package:client/business_logic/bloc/auth_bloc.dart';
import 'package:client/business_logic/event/auth_event.dart';
import 'package:client/business_logic/state/auth_state.dart';
import 'package:client/core/maestro_routes.dart';
import 'package:client/ui/widget/client_button.dart';
import 'package:client/ui/widget/client_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  late TextEditingController idController;
  late TextEditingController pwController;

  late FocusNode idNode;
  late FocusNode pwNode;

  late AuthBloc _authBloc;


  @override
  void initState(){
    super.initState();
    idController = TextEditingController();
    pwController = TextEditingController();

    idNode = FocusNode();
    pwNode = FocusNode();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(
                size: 280,
                duration: Duration.zero,
              ),
              const SizedBox(
                height: 24,
              ),
              ClientTFT(
                labelText: '아이디',
                controller: idController,
                focusNode: idNode,
                onChanged: (String text){},
                onFieldSubmit: (String? text) => pwNode.requestFocus(),
              ),
              ClientTFT(
                  labelText: '비밀번호',
                  controller: pwController,
                  focusNode: pwNode,
                  onChanged: (String text) {},
                  obscureText: true,
                  onFieldSubmit: (String? text){}),
              const SizedBox(
                height: 20,
              ),
              BlocListener<AuthBloc,AuthState>(
                listener: (context, state) {
                if(state.isLogin) {
                  Get.toNamed(AppRoutes.home);
                } else {
                // Show an error message or handle failed login
                }},
                child:  BlocBuilder<AuthBloc,AuthState>(
                  builder: (context,state){
                    return ClientButton(
                      buttonText: '로그인',
                      hMargin: 20,
                      isNetworking: state.isNetworking,
                      onPressed: (){
                        FocusScope.of(context).unfocus();
                        _authBloc.add(LoginEvent(
                            'admin',
                            'qwer1233'
                        ));
                      },
                    );
                  },
                ),
               ),
            ],
          ),
        ),
      )
    );
  }

}