import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';

abstract class UseCaseWithoutParamsOptional<T> {
  Future<Either<Failure, Option<T>>> call();
}
