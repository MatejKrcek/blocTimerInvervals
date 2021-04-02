import 'package:bloc/bloc.dart';

class SearchCubit extends Cubit<int> {
  SearchCubit() : super(30);

  int _markNumber = 30;

  int get markNumber {
    return _markNumber;
  }

  void button0() => emit(_markNumber = 15);
  void button1() => emit(_markNumber = 30);
  void button2() => emit(_markNumber = 45);
  void button3() => emit(_markNumber = 60);
}
