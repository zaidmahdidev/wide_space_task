part of 'comment_like_bloc.dart';

abstract class CommentLikeEvent extends Equatable {
  const CommentLikeEvent();

  @override
  List<Object> get props => [];
}

class AddLikeEvent extends CommentLikeEvent {
  final int postId;
  final int commentId;

  const AddLikeEvent({required this.postId, required this.commentId});

  @override
  List<Object> get props => [postId, commentId];
}

class RemoveLikeEvent extends CommentLikeEvent {
  final int postId;
  final int commentId;

  const RemoveLikeEvent({required this.postId, required this.commentId});

  @override
  List<Object> get props => [postId, commentId];
}

class AddDislikeEvent extends CommentLikeEvent {
  final int postId;
  final int commentId;

  const AddDislikeEvent({required this.postId, required this.commentId});

  @override
  List<Object> get props => [postId, commentId];
}

class RemoveDislikeEvent extends CommentLikeEvent {
  final int postId;
  final int commentId;

  const RemoveDislikeEvent({required this.postId, required this.commentId});

  @override
  List<Object> get props => [postId, commentId];
}
