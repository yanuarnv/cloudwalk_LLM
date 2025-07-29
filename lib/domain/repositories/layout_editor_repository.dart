import 'package:cloudwalk_llm/application/failure.dart';
import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

abstract class LayoutEditorRepository{
  Future<Either<Failure,ScaffoldEntity>> changeLayout(String prompt,ScaffoldEntity model);
}