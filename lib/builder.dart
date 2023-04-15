// ignore_for_file: depend_on_referenced_packages

library ai_function_generator;

import 'package:ai_function_generator/src/ai_function_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder generateAiFunction(BuilderOptions options) =>
    SharedPartBuilder([AiFunctionGenerator()], 'ai_function_generator');
