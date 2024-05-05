import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:ebn_balady/features/posts/data/repositories/posts_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../data/models/post/Post.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostsRepository postsRepository;

  PostBloc({required this.postsRepository}) : super(PostInitial()) {
    on<PostEvent>((event, emit) async {
      if (event is GetPostEvent) {
        emit(LoadingPostState());
        final failureOrPost = await postsRepository.getPost(event.postId);
        emit(_mapFailureOrPostToState(failureOrPost));
      }
    });
  }
  PostState _mapFailureOrPostToState(Either<Failure, dynamic> failureOrPosts) {
    return failureOrPosts.fold(
        (failure) => ErrorPostState(message: mapFailureToMessage(failure)),
        (post) => LoadedPostState(post: post));
  }
}
