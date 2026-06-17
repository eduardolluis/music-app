import 'dart:async';

import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;

  @override
  FutureOr<UserModel?> build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.signUp(
      name: name,
      email: email,
      password: password,
    );

    switch (res) {
      case Left(value: final failure):
        state = AsyncValue.error(
          failure.message,
          StackTrace.current,
        );

      case Right(value: final user):
        state = AsyncValue.data(user);
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.logIn(
      email: email,
      password: password,
    );

    switch (res) {
      case Left(value: final failure):
        state = AsyncValue.error(
          failure.message,
          StackTrace.current,
        );

      case Right(value: final user):
        state = AsyncValue.data(user);
    }
  }
}