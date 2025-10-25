import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thefamilyaltar/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:thefamilyaltar/src/authentication/presentation/pages/widgets/login_form.dart';

import '../../../../core/services/injection_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthenticationBloc>(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              Container(
                // height: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      // color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/samata_doot_logo.png',
                            width: 96,
                          ),
                          Image.asset(
                            'assets/cm-dcm.png',
                            width: 180,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome to Samata Doot",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      LoginForm()
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
