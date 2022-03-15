import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_books/blocs/auth_bloc/auth_bloc.dart';
import 'package:my_books/data/repositories/firebase_auth_repository_impl.dart';
import 'package:my_books/domain/usecases/auth/login_usecase.dart';
import 'package:my_books/domain/usecases/auth/logout_usecase.dart';
import 'package:my_books/domain/usecases/auth/register_usecase.dart';
import 'package:my_books/presentation/screens/books_screen.dart';
import 'package:my_books/presentation/screens/sign_in_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => FirebaseAuthRepositoryImpl(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          loginUseCase: LoginUseCase(
            authRepo:
                RepositoryProvider.of<FirebaseAuthRepositoryImpl>(context),
          ),
          logoutUseCase: LogoutUseCase(
            authRepo:
                RepositoryProvider.of<FirebaseAuthRepositoryImpl>(context),
          ),
          registerUseCase: RegisterUseCase(
            authRepo:
                RepositoryProvider.of<FirebaseAuthRepositoryImpl>(context),
          ),
        ),
        child: MaterialApp(
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)?.app_name ?? '',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const BooksScreen();
              }

              return const SignInScreen();
            },
          ),
        ),
      ),
    );
  }
}
