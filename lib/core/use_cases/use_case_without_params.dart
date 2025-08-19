import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';

abstract class UseCaseWithoutParams<T> {
  Future<Either<Failure, T>> call();
}
