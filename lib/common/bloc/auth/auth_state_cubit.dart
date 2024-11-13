import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_magang/common/bloc/auth/auth_state.dart';
import 'package:sistem_magang/domain/usecases/is_logged_in.dart';
import 'package:sistem_magang/service_locator.dart';

class AuthStateCubit extends Cubit<AuthState>{
  AuthStateCubit() : super(AppInitialState());

  void appStarted() async{
    var isLoggedIn = await sl<IsLoggedInUseCase>().call();

    if (isLoggedIn){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var role = sharedPreferences.getString('role');

      if (role == 'Student'){
        emit(AuthenticatedStudent());
      } else {
        emit(AuthenticatedLecturer());
      }
    } else{
      emit(UnAuthenticated());
    }
  }

}