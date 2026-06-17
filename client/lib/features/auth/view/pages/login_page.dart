import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/core/widgets/utils.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' hide State;

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
    formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authViewModelProvider).isLoading == true;

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
        data: (data) {
          // TODO: NAVIGATE to home page
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
        },
        error: ((error, stackTrace) {
          showSnackBar(context, error.toString()); 
        }),
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign In!",
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),

                    CustomField(hintText: "Email", controller: _emailController),
                    const SizedBox(height: 15),

                    CustomField(
                      hintText: "Password",
                      controller: _passwordController,
                      isObscureText: true,
                    ),
                    SizedBox(height: 20),

                    AuthGradientButton(
                      label: "Sign In",
                      onTap: () async {
                        final res = await AuthRemoteRepository().logIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        final val = switch (res) {
                          Left(value: final l) => l,
                          Right(value: final r) => r,
                        };
                        print(val);
                      },
                    ),
                    SizedBox(height: 20),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Pallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
