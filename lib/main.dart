import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/ticker.dart';
import 'package:timer_app/bloc/timer_bloc.dart';
import 'package:timer_app/bloc/button_cubit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(109, 234, 255, 1),
        accentColor: Color.fromRGBO(72, 74, 126, 1),
        brightness: Brightness.dark,
      ),
      title: 'Flutter Timer Intervals',
      home: MultiBlocProvider(
        child: Timer(),
        providers: [
          BlocProvider(
            create: (_) => TimerBloc(ticker: Ticker()),
            child: Timer(),
          ),
          BlocProvider(
            create: (_) => SearchCubit(),
          ),
        ],
      ),
    );
  }
}

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<TimerBloc>().state;
    final stateButton = context.watch<SearchCubit>().state;
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Timer Intervals')),
      body: ListView(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(child: TimerText()),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                child: Text('15s'),
                backgroundColor: stateButton == 15
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor,
                onPressed: () {
                  context.read<TimerBloc>().add(TimerStarted(duration: 15));
                  context.read<SearchCubit>().button0();
                },
              ),
              FloatingActionButton(
                child: Text('30s'),
                backgroundColor: stateButton == 30
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor,
                onPressed: () {
                  context.read<TimerBloc>().add(TimerStarted(duration: 30));
                  context.read<SearchCubit>().button1();
                },
              ),
              FloatingActionButton(
                child: Text('45s'),
                backgroundColor: stateButton == 45
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor,
                onPressed: () {
                  context.read<TimerBloc>().add(TimerStarted(duration: 45));
                  context.read<SearchCubit>().button2();
                },
              ),
              FloatingActionButton(
                child: Text('1min'),
                backgroundColor: stateButton == 60
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor,
                onPressed: () {
                  context.read<TimerBloc>().add(TimerStarted(duration: 60));
                  context.read<SearchCubit>().button3();
                },
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Actions(),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<TimerBloc>().state;
    final minutesStr =
        ((state.duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (state.duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<TimerBloc>().state;
    final stateButton = context.watch<SearchCubit>().state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state is TimerInitial) ...[
          FloatingActionButton(
            child: Icon(Icons.play_arrow),
            onPressed: () => context
                .read<TimerBloc>()
                .add(TimerStarted(duration: state.duration)),
          ),
        ],
        if (state is TimerRunInProgress) ...[
          FloatingActionButton(
            child: Icon(Icons.pause),
            onPressed: () => context.read<TimerBloc>().add(TimerPaused()),
          ),
          FloatingActionButton(
            child: Icon(Icons.cancel),
            onPressed: () {
              context.read<TimerBloc>().add(TimerReset());
              context.read<SearchCubit>().button1();
            },
          ),
        ],
        if (state is TimerRunPause) ...[
          FloatingActionButton(
            child: Icon(Icons.play_arrow),
            onPressed: () => context.read<TimerBloc>().add(TimerResumed()),
          ),
          FloatingActionButton(
            child: Icon(Icons.cancel),
            onPressed: () {
              context.read<TimerBloc>().add(TimerReset());
              context.read<SearchCubit>().button1();
            },
          ),
        ],
      ],
    );
  }
}
