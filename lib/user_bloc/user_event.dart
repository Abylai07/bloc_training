part of 'user_bloc.dart';

class UserEvent {}

class UserGetUsersEvent extends UserEvent{
  late final int count;

  UserGetUsersEvent(this.count);
}
class UserGetJobEvent extends UserEvent{
  late final int count;

  UserGetJobEvent(this.count);
}