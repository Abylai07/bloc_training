part of 'user_bloc.dart';

class UserState {
  final List<User> users;
  final List<Job> job;
  final bool isLoading;

  UserState({
    this.users = const [],
    this.job = const [],
    this.isLoading = false,
  });

  UserState copyWith({
     List<User>? users,
     List<Job>? job,
     bool isLoading = false,
  }){
    return UserState(
      users: users ?? this.users,
      job: job ?? this.job,
      isLoading: isLoading,
    );
}
}

class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}

class Job {
  final String id;
  final String name;

  Job({required this.id, required this.name});
}
