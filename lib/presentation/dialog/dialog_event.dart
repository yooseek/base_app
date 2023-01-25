part of 'dialog_bloc.dart';

abstract class DialogEvent {
  const DialogEvent();
}

class DialogInitEvent extends DialogEvent {
  final String? title;
  final String? content;
  final String? button;

  const DialogInitEvent({
    this.title,
    this.content,
    this.button,
  });
}

class ChangeTitleEvent extends DialogEvent {
  final String title;

  const ChangeTitleEvent({
    required this.title,
  });
}

class ChangeContentEvent extends DialogEvent {
  final String content;

  const ChangeContentEvent({
    required this.content,
  });
}

class ChangeButtonEvent extends DialogEvent {
  final String button;

  const ChangeButtonEvent({
    required this.button,
  });
}

class CheckNickNameDupEvent extends DialogEvent {
  final String nickname;

  const CheckNickNameDupEvent({
    required this.nickname,
  });
}

class ChangeNickNameEvent extends DialogEvent {
  final String nickname;

  const ChangeNickNameEvent({
    required this.nickname,
  });
}
