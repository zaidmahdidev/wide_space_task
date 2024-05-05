import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/errors/failures.dart';
import '../../../data/models/post/Post.dart';
import '../../../data/repositories/posts_repository.dart';

part 'like_event.dart';
part 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final PostsRepository postsRepository;

  LikeBloc({
    required this.postsRepository,
  }) : super(LikeInitial()) {
    on<LikeEvent>((event, emit) async {
      print(event);
      if (event is AddLikeEvent) {
        emit(LikeLoading());
        final failureOrPost = await postsRepository.addLike(event.postId);
        emit(_mapFailureOrPostToState(failureOrPost, true));
      } else if (event is RemoveLikeEvent) {
        emit(LikeLoading());
        final failureOrPost = await postsRepository.removeLike(event.postId);
        emit(_mapFailureOrPostToState(failureOrPost, false));
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case EmptyCacheFailure:
        return emptyCacheFailureMessage;
      case OfflineFailure:
        return offlineFailureMessage;
      default:
        return "Unexpected Error, Please try again later.";
    }
  }

  LikeState _mapFailureOrPostToState(
      Either<Failure, dynamic> failureOrPost, bool likeAdded) {
    return failureOrPost.fold(
        (failure) => ErrorLikeState(message: _mapFailureToMessage(failure)),
        (post) => likeAdded ? LikeAdded(post: post) : LikeRemoved(post: post));
  }
}
