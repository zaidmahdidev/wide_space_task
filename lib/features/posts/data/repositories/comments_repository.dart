import 'package:dartz/dartz.dart';
import 'package:ebn_balady/core/errors/exceptions.dart';
import 'package:ebn_balady/core/errors/failures.dart';
import 'package:ebn_balady/injection_container.dart' as di;

import '../../../../core/data_providers/remote_data_provider.dart';
import '../../../../core/network/data_source_url.dart';
import '../../../../core/repository.dart';
import '../models/comment/comment_model.dart';

class CommentsRepository extends Repository {
  Future<Either<Failure, dynamic>> getComments(
      int postId, int pageNumber) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.get,
              url: DataSourceURL.getCommentEndPoint(
                  postId: postId, pageNumber: pageNumber),
              retrievedDataType: CommentModel.init(),
              returnType: List,
            );
          } catch (e, s) {
            di.logger.d('Get comments catch', e, s);
            return throw UnexpectedException();
          }
          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> addComment(
      String comment, int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.post,
              url: DataSourceURL.getCommentEndPoint(postId: postId),
              returnType: Map,
              retrievedDataType: CommentModel.init(),
              body: {"body": comment},
            );
          } catch (e, s) {
            di.logger.d('Add a comment catch', e, s);
            return throw UnexpectedException();
          }
          return remoteData;
        });
    /* if (await networkInfo.isConnected) {
      try {
        CommentModel commentModel =
            await remoteDataSource.addComment(comment, postId);
        return Right(commentModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }*/
  }

  Future<Either<Failure, dynamic>> deleteComment(
      int commentId, int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.delete,
              url: DataSourceURL.getCommentEndPoint(
                  postId: postId, commentId: commentId),
              returnType: Map,
              retrievedDataType: CommentModel.init(),
            );
          } catch (e, s) {
            di.logger.d('Delete a comment catch', e, s);
            return throw UnexpectedException();
          }
          return remoteData;
        });
    // return await _getMessage(
    //     () => remoteDataSource.deleteComment(commentId, postId));
  }

  Future<Either<Failure, dynamic>> updateComment(
      CommentModel comment, int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.post,
              url:
                  "${DataSourceURL.getCommentEndPoint(postId: postId, commentId: comment.id)}?_method=PUT",
              returnType: Map,
              retrievedDataType: CommentModel.init(),
              body: {"body": comment.body},
            );
          } catch (e, s) {
            di.logger.d('Update comment catch', e, s);
            return throw UnexpectedException();
          }
          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> addCommentLike(
      int commentId, int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.post,
              url: DataSourceURL.getCommentLikeEndPoint(
                  postId: postId, commentId: commentId),
              returnType: Map,
              retrievedDataType: CommentModel.init(),
            );
          } catch (e, s) {
            di.logger.d('Add a like to a comment catch', e, s);
            return throw UnexpectedException();
          }
          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> removeCommentLike(
      int commentId, int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.delete,
              url: DataSourceURL.getCommentLikeEndPoint(
                  postId: postId, commentId: commentId),
              returnType: Map,
              retrievedDataType: CommentModel.init(),
            );
          } catch (e, s) {
            di.logger.d('Remove a like from a comment catch', e, s);
            return throw UnexpectedException();
          }
          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> addCommentDislike(
      int commentId, int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.post,
              url: DataSourceURL.getCommentDislikeEndPoint(
                  postId: postId, commentId: commentId),
              retrievedDataType: CommentModel.init(),
              returnType: Map,
            );
          } catch (e, s) {
            di.logger.d('Add a dislike to a comment catch', e, s);
            return throw UnexpectedException();
          }
          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> removeCommentDislike(
      int commentId, int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.delete,
              url: DataSourceURL.getCommentDislikeEndPoint(
                  postId: postId, commentId: commentId),
              retrievedDataType: CommentModel.init(),
              returnType: Map,
            );
          } catch (e, s) {
            di.logger.d('Remove a dislike from a comment catch', e, s);
            return throw UnexpectedException();
          }
          return remoteData;
        });
  }
}
