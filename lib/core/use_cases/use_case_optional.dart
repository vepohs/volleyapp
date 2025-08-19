import 'package:dartz/dartz.dart';
import 'package:volleyapp/core/errors/failure.dart';

abstract class UseCaseOptional<T, Params> {
  Future<Either<Failure, Option<T>>> call(Params params);
}
