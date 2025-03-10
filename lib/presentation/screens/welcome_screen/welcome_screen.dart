import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:leeds_library/core/di/di_container.dart';
import 'package:leeds_library/core/theme/app_colors.dart';
import 'package:leeds_library/presentation/block/welcome/welcome_block.dart';
import 'package:leeds_library/presentation/block/welcome/welcome_event.dart';
import 'package:leeds_library/presentation/block/welcome/welcome_state.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';
import 'package:leeds_library/presentation/widgets/custom_yellow_icon_button.dart';
import 'package:leeds_library/presentation/widgets/welcome_box.dart';

import 'custom_green_icon_button.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}
class WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WelcomeBloc>()..add(CheckAuthStatus()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundDetails,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.accentColor,
                      AppColors.backgroundDetails,
                    ],
                  )),
              child: Center(
                  child: Transform.translate(
                    offset: Offset(0, -40),

                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset('assets/images/lib_logo.png'),
                    ),
                  )),
            ),
            BlocListener<WelcomeBloc, WelcomeState>(
              listener: (context, state) {
                if (state is WelcomeAuthenticated) {
                  context.pushReplacement(AppRoutes.main);
                }
              },
              child: BlocBuilder<WelcomeBloc, WelcomeState>(
                builder: (context, state) {
                  if (state is WelcomeChecking) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      WelcomeBox(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          decoration: const BoxDecoration(
                            color: AppColors.backgroundDetails,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8),
                                bottom: Radius.circular(8)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(translate('welcome_title'),
                                  style:
                                  Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 8),
                              Text(
                                translate('welcome_subtitle'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: CustomGreenIconButton(
                                  text: translate('sign_in'),
                                  height: 56,
                                  onPressed: () {
                                    context.push(AppRoutes.googleSignIn);
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    translate('dont_have_account'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                      color: AppColors.secondaryText2,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.push(AppRoutes.googleSignIn);
                                    },
                                    child: Text(
                                      translate('sign_up_first'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                        color: AppColors.accentColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
