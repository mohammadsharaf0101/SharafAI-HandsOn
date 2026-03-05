import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ================= STATES =================

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String role;
  RegisterSuccess(this.role);
}

class RegisterError extends RegisterState {
  final String message;
  RegisterError(this.message);
}

class RegisterInvalid extends RegisterState {
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? roleError;

  RegisterInvalid({
    this.nameError,
    this.emailError,
    this.passwordError,
    this.roleError,
  });
}

// ================= CUBIT =================

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String? role,
  }) async {

    final nErr = name.isEmpty
        ? "Name Required"
        : (RegExp(r'[0-9]').hasMatch(name)
            ? "Numbers not allowed"
            : null);

    final eErr =
        !email.endsWith('@gmail.com') ? "Invalid Gmail" : null;

    final pErr = password.length < 8
        ? "Too Short min(8 chars)"
        : (password != confirmPassword ? "Mismatch" : null);

    final rErr = role == null ? "Select Role" : null;

    if ([nErr, eErr, pErr, rErr].any((e) => e != null)) {
      emit(RegisterInvalid(
        nameError: nErr,
        emailError: eErr,
        passwordError: pErr,
        roleError: rErr,
      ));
      return;
    }

    emit(RegisterLoading());

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/users/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        emit(RegisterSuccess(role!));
      } else {
        emit(RegisterError('Server Registration Failed'));
      }
    } catch (_) {
      emit(RegisterError('No Internet Connection'));
    }
  }
}