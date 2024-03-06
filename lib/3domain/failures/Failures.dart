import 'package:equatable/equatable.dart';

abstract class Failure {}

class ServerFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class GeneralFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class DatabaseFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ServerTimeoutFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class ResultEmptyFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class NoConnectionFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}

class EmptySearchFailure extends Failure with EquatableMixin {
  @override
  List<Object?> get props => [];
}
