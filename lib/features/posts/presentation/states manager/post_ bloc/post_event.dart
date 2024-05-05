part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
}

class GetPostEvent extends PostEvent {
  final int postId;

  const GetPostEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}
