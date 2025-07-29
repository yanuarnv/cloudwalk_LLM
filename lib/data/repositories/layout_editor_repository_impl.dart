import 'package:cloudwalk_llm/application/failure.dart';
import 'package:cloudwalk_llm/data/data_sources/processor.dart';
import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:cloudwalk_llm/domain/repositories/layout_editor_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class LayoutEditorRepositoryImpl extends LayoutEditorRepository {
  final Processor processor;

  LayoutEditorRepositoryImpl(this.processor);

  @override
  Future<Either<Failure, ScaffoldEntity>> changeLayout(
      String prompt, ScaffoldEntity model) async {
    try {
      final data = await processor.nlpProcessing(prompt, model);
      return Right(data);
    } on InternalFailure catch (e) {
      return Left(e);
    } on ServerFailure catch (e) {
      return Left(e);
    }
  }
}
