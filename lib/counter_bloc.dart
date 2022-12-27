import 'package:bloc/bloc.dart';

class CounterBloc extends Bloc<CounterEvents, int>{
  CounterBloc(): super(5){
    on<CounterIncEvent>(_onIncrement);
    on<CounterDecEvent>(_onDecrement);
  }
  _onIncrement(CounterIncEvent event, Emitter<int> emit){
    emit(state + 1);
  }
  _onDecrement(CounterDecEvent event, Emitter<int> emit){
    if(state <= 0) return;
    emit(state - 1);
  }
}

abstract class CounterEvents{}
class CounterIncEvent extends CounterEvents{}
class CounterDecEvent extends CounterEvents{}