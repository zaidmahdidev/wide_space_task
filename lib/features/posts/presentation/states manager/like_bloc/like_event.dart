part of 'like_bloc.dart';

abstract class LikeEvent extends Equatable {
  const LikeEvent();

  @override
  List<Object> get props => [];
}

class AddLikeEvent extends LikeEvent {
  final int postId;

  const AddLikeEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}

class RemoveLikeEvent extends LikeEvent {
  final int postId;

  const RemoveLikeEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}
