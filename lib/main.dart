import 'package:bloc_training/search_bloc/search_bloc.dart';
import 'package:bloc_training/search_screen.dart';
import 'package:bloc_training/user_bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search_user_repository/search_user_repository.dart';

import 'counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final counterBloc = CounterBloc();
    return RepositoryProvider(
  create: (context) => SearchUserRepository(),
    child: MultiBlocProvider(
      providers: [
        BlocProvider<CounterBloc>(
          create: (BuildContext context) => counterBloc,
          lazy: false,
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(counterBloc),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(
              searchUserRepository: RepositoryProvider.of<SearchUserRepository>(context),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SearchScreen(),
      ),
    ),
);
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
      final counterBloc = BlocProvider.of<CounterBloc>(context);
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bloc'),
        ),
        floatingActionButton: BlocConsumer<CounterBloc, int>(
          listenWhen: (prev, current) => prev > current,
          listener: (context, state) {
            if(state == 0){
              Scaffold.of(context).showBottomSheet((context) => Container(
                color: Colors.blue,
                height: 40,
                width: double.infinity,
                child: const Text("State is 0"),
              ),);
            }
         },
          builder: (context, state){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.toString()),
                IconButton(
                  onPressed: () {
                    counterBloc.add(CounterIncEvent());
                  },
                  icon: const Icon(Icons.plus_one),
                ),
                IconButton(
                  onPressed: () {
                    counterBloc.add(CounterDecEvent());
                  },
                  icon: const Icon(Icons.exposure_minus_1),
                ),
                IconButton(
                  onPressed: () {
                    final userBloc = context.read<UserBloc>();
                    userBloc.add(
                        UserGetUsersEvent(context.read<CounterBloc>().state));
                  },
                  icon: const Icon(Icons.person),
                ),
                IconButton(
                  onPressed: () {
                    final userBloc = context.read<UserBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Job(),
                      ),
                    );
                    userBloc
                        .add(UserGetJobEvent(context.read<CounterBloc>().state));
                  },
                  icon: const Icon(Icons.work),
                ),
              ],
            );
          },
),
        body: Center(
          child: Column(
            children: [
              BlocBuilder<CounterBloc, int>(
                //bloc: CounterBloc(),
                  builder: (context, state) {
                    final users =
                    context.select((UserBloc bloc) => bloc.state.users);
                    return Column(
                      children: [
                        Text(
                          state.toString(),
                          style: const TextStyle(fontSize: 33),
                        ),
                        if (users.isNotEmpty) ...users.map((e) => Text(e.name)),
                      ],
                    );
                  }),
              // Job(),
            ],
          ),
        ),
      );
  }
}

class Job extends StatelessWidget {
  const Job({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
        final job = state.job;
        return Column(
          children: [
            if (state.isLoading) const CircularProgressIndicator(),
            if (job.isNotEmpty) ...state.job.map((e) => Text(e.name)),
          ],
        );
      }),
    );
  }
}
