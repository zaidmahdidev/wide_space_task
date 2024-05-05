part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends PostsEvent {
  final int pageNumber;

  const GetPostsEvent({required this.pageNumber});
  @override
  List<Object> get props => [pageNumber];
}

class AddPostEvent extends PostsEvent {
  final PostModel post;

  const AddPostEvent({required this.post});

  @override
  List<Object> get props => [post];
}

class UpdatePostEvent extends PostsEvent {
  final PostModel post;

  const UpdatePostEvent({required this.post});

  @override
  List<Object> get props => [post];
}

class DeletePostEvent extends PostsEvent {
  final int postId;

  const DeletePostEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}
