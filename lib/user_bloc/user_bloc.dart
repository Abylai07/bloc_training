import 'dart:async';


import 'package:bloc_training/counter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CounterBloc counterBloc;
  late final StreamSubscription counterStreamSubscription;
  UserBloc(this.counterBloc) : super(UserState()) {
    on<UserGetUsersEvent>(_onGetUser);
    on<UserGetJobEvent>(_onGetJob);
    counterStreamSubscription = counterBloc.stream.listen((state) {
      if(state <= 0){
        add(UserGetUsersEvent(0));
        add(UserGetJobEvent(0));
      }
    });
  }

  @override
  Future<void> close(){
    counterStreamSubscription.cancel();
    return super.close();
  }


  _onGetUser(UserGetUsersEvent event, Emitter<UserState> emit) async{
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    final users = List.generate(event.count, (index) => User(id: index.toString(), name: 'user name'));
    emit(state.copyWith(users: users));
  }
  _onGetJob(UserGetJobEvent event, Emitter<UserState> emit) async{
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(seconds: 1));
    final job = List.generate(event.count, (index) => Job(id: index.toString(), name: 'Job name'));
    emit(state.copyWith(job: job));
  }
}

