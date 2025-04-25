import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leeds_library/core/theme/app_theme.dart';

import 'package:leeds_library/core/di/di_container.dart' as di;
import 'package:leeds_library/presentation/block/account/account_block.dart';
import 'package:leeds_library/presentation/block/add_book/add_book_bloc.dart';
import 'package:leeds_library/presentation/block/add_reader/add_reader_bloc.dart';
import 'package:leeds_library/presentation/block/barcode_scanner/barcode_scanner_block.dart';
import 'package:leeds_library/presentation/block/book_details/book_details_bloc.dart';
import 'package:leeds_library/presentation/block/books_list/books_lists_block.dart';
import 'package:leeds_library/presentation/block/create_loan/create_loan_bloc.dart';
import 'package:leeds_library/presentation/block/finder_bloc/finder_bloc.dart';
import 'package:leeds_library/presentation/block/loans_list/loans_list_bloc.dart';
import 'package:leeds_library/presentation/block/loans_my_bloc/my_loans_bloc.dart';
import 'package:leeds_library/presentation/block/reading_plans/reading_plans_bloc.dart';
import 'package:leeds_library/presentation/block/reviews/reviews_bloc.dart';
import 'package:leeds_library/presentation/block/reviews/reviews_event.dart';
import 'package:leeds_library/presentation/block/text_recognize/text_recognize_block.dart';
import 'package:leeds_library/presentation/block/user_google_auth/google_auth_block.dart';
import 'package:leeds_library/presentation/block/user_register/register_block.dart';


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
        BlocProvider(create: (context) => di.sl<BarcodeScannerBloc>()),
        BlocProvider(create: (context) => di.sl<AddBookBloc>()),
        BlocProvider(create: (context) => di.sl<TextRecognizerBloc>()),
        BlocProvider(create: (context) => di.sl<BooksListBloc>()),
        BlocProvider(create: (context) => di.sl<FinderBloc>()),
        BlocProvider(create: (context) => di.sl<AccountBloc>()),
        BlocProvider(create: (context) => di.sl<AddReaderBloc>()),
        BlocProvider(create: (context) => di.sl<CreateLoanBloc>()),
        BlocProvider(create: (context) => di.sl<LoansListBloc>()),
        BlocProvider(create: (context) => di.sl<BookDetailsBloc>()),
        BlocProvider(create: (context) => di.sl<ReviewsBloc>()..add(InitialEvent())),
        BlocProvider(create: (context) => di.sl<ReadingPlansBloc>()),
        BlocProvider(create: (context) => di.sl<MyLoansListBloc>()),


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
