import 'package:cloudwalk_llm/app_bloc_observer.dart';
import 'package:cloudwalk_llm/application/app_theme_data.dart';
import 'package:cloudwalk_llm/data/data_sources/llm_local_datasources.dart';
import 'package:cloudwalk_llm/Infrastructure/processor.dart';
import 'package:cloudwalk_llm/data/data_sources/llm_remote_datasources.dart';
import 'package:cloudwalk_llm/data/repositories/layout_editor_repository_impl.dart';
import 'package:cloudwalk_llm/domain/repositories/layout_editor_repository.dart';
import 'package:cloudwalk_llm/presentation/ui/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oktoast/oktoast.dart';

void main() async{
  Bloc.observer = AppBlocObserver();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Processor>(
          create: (context) => LlmRemoteDataSources(),
        ),
        RepositoryProvider<LayoutEditorRepository>(
          create: (context) => LayoutEditorRepositoryImpl(
            RepositoryProvider.of<Processor>(context),
          ),
        ),
      ],
      child: OKToast(
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: CLThemeData.getTheme(context),
            home: MainScreen()),
      ),
    );
  }
}
