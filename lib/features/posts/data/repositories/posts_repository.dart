import 'package:dartz/dartz.dart';
import 'package:ebn_balady/core/errors/exceptions.dart';
import 'package:ebn_balady/core/errors/failures.dart';
import 'package:ebn_balady/injection_container.dart' as di;

import '../../../../core/data_providers/remote_data_provider.dart';
import '../../../../core/network/data_source_url.dart';
import '../../../../core/repository.dart';
import '../../../user/data/models/user_model.dart';
import '../models/post/Post.dart';

class PostsRepository extends Repository {
  Future<Either<Failure, dynamic>> getPosts(int pageNumber) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.get,
              url: DataSourceURL.getPostEndPoint(pageNumber: pageNumber),
              retrievedDataType: PostModel.init(),
              returnType: List,
              cacheKey: 'CACHED_POSTS',
            );
          } catch (e, s) {
            di.logger.d('Get posts catch', e, s);
            return throw UnexpectedException();
          }

          return remoteData;
        });

    // if (await networkInfo.isConnected) {
    //   try {
    //     final remotePosts = await remoteDataSource.getPosts(pageNumber);
    //     print("before chach");
    //
    //     await localDataSource.cachePosts(remotePosts);
    //     print("after chach");
    //     return Right(remotePosts);
    //   } on ServerException {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   try {
    //     final localPosts = await localDataSource.getCachedPosts();
    //     return Right(localPosts);
    //   } on EmptyCacheException {
    //     return Left(EmptyCacheFailure());
    //   }
    // }
  }

  Future<Either<Failure, dynamic>> getPost(int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.get,
              url: DataSourceURL.getPostEndPoint(postId: postId),
              retrievedDataType: PostModel.init(),
              returnType: Map,
            );
          } catch (e, s) {
            di.logger.d('Get a post catch', e, s);
            return throw UnexpectedException();
          }

          return remoteData;
        });
    //
    // if (await networkInfo.isConnected) {
    //   try {
    //     final remotePost = await remoteDataSource.getPost(postId);
    //     return Right(remotePost);
    //   } on ServerException {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   return Left(OfflineFailure());
    // }
  }

  Future<Either<Failure, dynamic>> addPost(PostModel post) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.post,
              url: DataSourceURL.getPostEndPoint(),
              returnType: Map,
              retrievedDataType: PostModel.init(),
              body: post.toFormData(),
            );
          } catch (e, s) {
            di.logger.d('Add a post catch', e, s);
            return throw UnexpectedException();
          }

          return remoteData;
        });
    // return await _getMessage(() => remoteDataSource.addPost(post));
  }

  Future<Either<Failure, dynamic>> deletePost(int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.delete,
              url: DataSourceURL.getPostEndPoint(postId: postId),
              retrievedDataType: Unit,
              returnType: int,
            );
          } catch (e, s) {
            di.logger.d('Delete a post catch', e, s);
            return throw UnexpectedException();
          }

          return remoteData;
        });
  }

  Future<Either<Failure, dynamic>> updatePost(PostModel post) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.post,
              url:
                  "${DataSourceURL.getPostEndPoint(postId: post.id)}?_method=PUT",
              retrievedDataType: PostModel.init(),
              returnType: Map,
              body: post.toFormData(),
            );
          } catch (e, s) {
            di.logger.d('Delete a post catch', e, s);
            return throw UnexpectedException();
          }

          return remoteData;
        });
    // return await _getMessage(() => remoteDataSource.updatePost(post));
  }

  Future<Either<Failure, dynamic>> addLike(int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.post,
              url: DataSourceURL.getPostLikeEndPoint(postId: postId),
              retrievedDataType: PostModel.init(),
              returnType: Map,
            );
          } catch (e, s) {
            di.logger.d('Add a like to a post catch', e, s);
            return throw UnexpectedException();
          }

          return remoteData;
        });
    // if (await networkInfo.isConnected) {
    //   try {
    //     final PostModel post = await remoteDataSource.addLike(postId);
    //     return Right(post);
    //   } on ServerException {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   return Left(OfflineFailure());
    // }
  }

  Future<Either<Failure, dynamic>> removeLike(int postId) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.delete,
              url: DataSourceURL.getPostLikeEndPoint(postId: postId),
              retrievedDataType: PostModel.init(),
              returnType: Map,
            );
          } catch (e, s) {
            di.logger.d('Delete a like from a post catch', e, s);
            return throw UnexpectedException();
          }

          return remoteData;
        });
    // if (await networkInfo.isConnected) {
    //   try {
    //     final PostModel post = await remoteDataSource.removeLike(postId);
    //     return Right(post);
    //   } on ServerException {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   return Left(OfflineFailure());
    // }
  }

  Future<Either<Failure, dynamic>> getUsers(int pageNumber) async {
    return await sendRequest(
        checkConnection: networkInfo.isConnected,
        remoteFunction: () async {
          final dynamic remoteData;
          try {
            remoteData = await remoteDataProvider.sendData(
              requestType: RequestTypes.get,
              url: DataSourceURL.getUserEndPoint(pageNumber: pageNumber),
              retrievedDataType: UserModel.init(),
              returnType: List,
              cacheKey: 'CACHED_USERS',
            );
          } catch (e, s) {
            di.logger.d('Get Users catch', e, s);
            return throw UnexpectedException();
          }

          return remoteData;
        });
  }
}
