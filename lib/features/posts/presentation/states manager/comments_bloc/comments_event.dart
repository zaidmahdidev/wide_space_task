part of 'comments_bloc.dart';

@immutable
abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class GetCommentsEvent extends CommentsEvent {
  final int postId;
  final int pageNumber;

  const GetCommentsEvent({required this.postId, required this.pageNumber});
  @override
  List<Object> get props => [postId, pageNumber];
}

class RefreshCommentsEvent extends CommentsEvent {
  final int postId;
  final int pageNumber;

  const RefreshCommentsEvent({required this.postId, required this.pageNumber});
  @override
  List<Object> get props => [postId, pageNumber];
}

class AddCommentEvent extends CommentsEvent {
  final String body;
  final int postId;

  const AddCommentEvent({required this.body, required this.postId});

  @override
  List<Object> get props => [body, postId];
}

class UpdateCommentEvent extends CommentsEvent {
  final CommentModel newComment;
  final int postId;
  final int index;
  const UpdateCommentEvent(
      {required this.newComment, required this.postId, required this.index});

  @override
  List<Object> get props => [newComment, postId, index];
}

class DeleteCommentEvent extends CommentsEvent {
  final int commentId;
  final int postId;
  final int index;

  const DeleteCommentEvent(
      {required this.commentId, required this.postId, required this.index});
  @override
  List<Object> get props => [commentId, postId, index];
}
