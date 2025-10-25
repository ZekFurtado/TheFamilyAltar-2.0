import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:thefamilyaltar/src/authentication/presentation/bloc/auth_cubit.dart';

import '../../bloc/authentication_bloc.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome, ${state.visitor.name}")));
          Navigator.pushNamedAndRemoveUntil(
              context, '/home', ModalRoute.withName('/'));
        } else if (state is AuthenticationError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.25)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.25)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.25)),
                ),
                labelText: 'Email'),
          ),
          const SizedBox(
            height: 20,
          ),
          BlocProvider(
            create: (context) => PasswordVisibilityCubit(),
            child: BlocBuilder<PasswordVisibilityCubit, bool>(
              builder: (context, hidePass) {
                return TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.25)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.25)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.25)),
                      ),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<PasswordVisibilityCubit>().toggle();
                        },
                        icon: hidePass
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      )),
                  obscureText: hidePass,
                  obscuringCharacter: "*",
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.onSurface),
                  backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.secondary)),
              child: const Text(
                "Forgot Password?",
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            height: 35,
            child: TextButton(
              onPressed: () {
                /* Calls AuthenticationCubit.emailSignIn(email,
                            password). This call will cause a series of actions
                            in different layers. This is the presentation layer.
                             */

                /*context.read<cubit.AuthenticationCubit>().emailSignIn(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim());*/

                context.read<AuthenticationBloc>().add(EmailSignInEvent(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim()));
              },
              child: const Text("Login"),
            ),
          )
        ],
      ),
    );
  }
}
