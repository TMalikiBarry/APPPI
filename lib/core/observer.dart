import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

/// Help to identify the current states of BLoCs
/// TODO remove this class before deployment to avoid performance issues
class AppObserver extends BlocObserver {
  //
  static final logger = Logger();

  ///We can run something, when we create our Bloc
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    ///We can check, if the BlocBase is a Bloc or a Cubit
    logger.i("Bloc $bloc created");
  }

  ///We can react to events
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.i("an event Happened in $bloc the event is $event");
  }

  ///We can even react to transitions
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    /// With this we can specifically know, when and what changed in our Bloc
    logger.i("Transit ${transition.currentState} => ${transition.nextState}");
  }

  ///We can react to errors, and we will know the error and the StackTrace
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.i("Error in $bloc with $error -  stacktrace is $stackTrace");
  }

  ///We can even run something, when we close our Bloc
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    logger.i("Bloc $bloc closed");
  }
}
