import 'package:equatable/equatable.dart';

class ChatCompletionEntity extends Equatable {
  final int created;
  final String model;
  final List<Choice> choices;

  const ChatCompletionEntity({
    required this.created,
    required this.model,
    required this.choices,
  });

  factory ChatCompletionEntity.fromJson(Map<String, dynamic> json) {
    return ChatCompletionEntity(
      created: json['created'],
      model: json['model'],
      choices:
          List<Choice>.from(json['choices'].map((x) => Choice.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        created,
        model,
        choices,
      ];
}

class Choice extends Equatable {
  final Message message;
  final String finishReason;

  const Choice({
    required this.message,
    required this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      message: Message.fromJson(json['message']),
      finishReason: json['finish_reason'],
    );
  }

  @override
  List<Object?> get props => [message, finishReason];
}

class Message extends Equatable {
  final String role;
  final String content;

  const Message({
    required this.role,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }

  @override
  List<Object?> get props => [role, content];
}
