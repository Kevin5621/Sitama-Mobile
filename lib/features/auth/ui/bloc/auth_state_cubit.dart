import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitama/features/auth/domain/usecases/is_logged_in.dart';
import 'package:sitama/features/auth/ui/bloc/auth_state.dart';
import 'package:sitama/service_locator.dart';

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