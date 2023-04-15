// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:ai_function/ai_function.dart';
import 'package:build/build.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:dio/dio.dart';
import 'package:source_gen/source_gen.dart';

class AiFunctionGenerator extends GeneratorForAnnotation<AiGenerable> {
  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        'AiGenerable annotation can only be used on classes.',
        element: element,
      );
    }
    if (!element.isAbstract) {
      throw InvalidGenerationSourceError(
        'AiGenerable annotation can only be used on abstract classes.',
        element: element,
      );
    }

    final classBody = StringBuffer();

    for (final method in element.methods) {
      classBody.write(await _generateMethod(method));
      classBody.writeln();
    }

    return '''
      class ${element.name}Impl implements ${element.name} {
        $classBody
      }
    ''';
  }

  Future<String> _generateMethod(MethodElement element) async {
    late final String openAiApiKey;
    if (Platform.environment.containsKey('OPENAI_API_KEY')) {
      openAiApiKey = Platform.environment['OPENAI_API_KEY']!;
    } else {
      throw Exception(
        'No OpenAI API key found. '
        'Please set the OPENAI_API_KEY environment variable.',
      );
    }
    final headers = {'Authorization': 'Bearer $openAiApiKey'};
    final body = jsonEncode(
      {
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'user',
            'content': 'Generate a Flutter function which has ${element.returnType} as return type, '
                '${element.name} as name and ${element.parameters} as parameters. '
                'Return only the method instructions without any further explanation.\n'
                '${element.documentationComment != null ? 'The method is documented with this text: ${element.documentationComment}' : ''} '
          }
        ]
      },
    );

    final res = await Dio().post<Map<String, dynamic>>(
      'https://api.openai.com/v1/chat/completions',
      data: body,
      options: Options(headers: headers),
    );

    if (res.statusCode == 200) {
      return '${res.data?['choices'][0]['message']['content']}'
          .replaceAll('```dart', '')
          .replaceAll('```', '');
    } else {
      throw Exception('Failed to generate code with GPT-4 API: ${res.data}');
    }
  }
}
