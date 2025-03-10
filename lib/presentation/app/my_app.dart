import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/theme/app_theme.dart';

import 'package:leeds_library/core/di/di_container.dart' as di;
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_block.dart';
import 'package:leeds_library/presentation/block/user_register/register_block.dart';

//import 'package:leeds_library/presentation/block/auth/auth_block.dart';
//import 'package:leeds_library/presentation/block/auth/auth_event.dart';
import 'package:leeds_library/presentation/navigation/app_router.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<GoogleAuthBloc>()//..add(GoogleAuthInitial()),
        ),
        BlocProvider(
            create: (context) => di.sl<RegisterBloc>()//..add(GoogleAuthInitial()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Task',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter().router,
      ),
    );
  }
}
