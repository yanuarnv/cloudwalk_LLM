import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:flutter/cupertino.dart';

abstract class Processor{
  Future<ScaffoldEntity> nlpProcessing(String prompt,ScaffoldEntity model);
}