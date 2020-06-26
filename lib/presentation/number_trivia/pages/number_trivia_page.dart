import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/injection_container.dart';
import 'package:flutter_clean_architecture/presentation/number_trivia/bloc/bloc.dart';
import 'package:flutter_clean_architecture/presentation/number_trivia/widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                // ignore: missing_return
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(message: 'Start Searching');
                  } else if (state is Loading) {
                    return LoadingIndicator();
                  } else if (state is Loaded) {
                    return TriviaDisplay(numberTrivia: state.trivia);
                  } else if (state is Error) {
                    return MessageDisplay(message: state.message);
                  }
                },
              ),
              SizedBox(height: 16),
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}
