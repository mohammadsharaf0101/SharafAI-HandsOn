import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ---------------- STATES ----------------
abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {}
class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}
class LoginInvalid extends LoginState {
  final String? emailError, passwordError;
  LoginInvalid({this.emailError, this.passwordError});
}

// ---------------- CUBIT ----------------
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    // التحقق من الحقول
    if (email.isEmpty || password.isEmpty) {
      return emit(LoginInvalid(emailError: "Required", passwordError: "Required"));
    }
    final eErr = !email.endsWith('@gmail.com') ? "Invalid Gmail" : null;
    final pErr = password.length < 8 ? "Too Short min(8 chars)" : null;
    if ([eErr, pErr].any((e) => e != null)) {
      return emit(LoginInvalid(emailError: eErr, passwordError: pErr));
    }

    emit(LoginLoading());

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/users/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(LoginSuccess());
      } else {
        emit(LoginError('Server Login Failed'));
      }
    } catch (_) {
      emit(LoginError('No Internet Connection'));
    }
  }
}