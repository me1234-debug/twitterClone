import 'package:equatable/equatable.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/domain/repository/profile_repository.dart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  final String userId;

  FetchUserProfile(this.userId);
}

class UpdateUserProfile extends ProfileEvent {
  final UserProfileEntity userEntity;

  UpdateUserProfile(this.userEntity);
}

class Follow extends ProfileEvent {
  final UserProfileEntity userEntity;
  final UserProfileEntity currentUserEntity;

  Follow({this.userEntity, this.currentUserEntity});
}

class UnFollow extends ProfileEvent {
  final UserProfileEntity userEntity;
  final UserProfileEntity currentUserEntity;

  UnFollow({this.userEntity, this.currentUserEntity});
}

class ProfileState extends Equatable {
  final UserProfileEntity userProfile;

  ProfileState({this.userProfile});
  @override
  List<Object> get props => [userProfile];
}

class ProfileInitialState extends ProfileState {}

class FetchingUserProfile extends ProfileState {}

class FetchingUserProfileFailed extends ProfileState {}

class FetchingUserProfileComplete extends ProfileState {
  final UserProfileEntity userProfile;

  FetchingUserProfileComplete({this.userProfile}) : super(userProfile: userProfile);
}

class UpdateFailed extends ProfileState {}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  ProfileBloc({ProfileState initialState, this.profileRepository})
      : super(initialState);

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchUserProfile) {
      yield* _mapFetchUserProfileToEvent(event.userId);
    }
    if (event is UpdateUserProfile) {
      yield* _mapUpdateUserProfileToEvent(event.userEntity);
    }
    if (event is Follow) {
      yield* _mapFollowToEvent(event.userEntity, event.currentUserEntity);
    }
    if (event is UnFollow) {
      yield* _mapUnFollowToEvent(event.userEntity, event.currentUserEntity);
    }
  }

  Stream<ProfileState> _mapFetchUserProfileToEvent(String id) async* {
    yield FetchingUserProfile();
    final userProfileEither = await profileRepository.getUserProfile(id);
    yield* userProfileEither.fold(
      (failure) async* {
        yield FetchingUserProfileFailed();
      },
      (profile) async* {
        yield FetchingUserProfileComplete(userProfile: profile);
      },
    );
  }

  Stream<ProfileState> _mapUpdateUserProfileToEvent(
      UserProfileEntity entity) async* {
    if (entity.profilePhoto.runtimeType != String ||
        entity.coverPhoto.runtimeType != String) {
      final uploadEither = await profileRepository.uploadImage(entity);
      yield* uploadEither.fold((failure) async* {
        yield UpdateFailed();
      }, (newProfile) async* {
        entity = newProfile;
      });
    }
    final successEither = await profileRepository.updateUserProfile(entity);
    yield* successEither.fold((failure) async* {
      yield UpdateFailed();
    }, (success) async* {
      yield* _mapFetchUserProfileToEvent(entity.id);
    });
  }

  Stream<ProfileState> _mapFollowToEvent(
      UserProfileEntity userProfile, UserProfileEntity currentUser) async* {
    final followEither =
        await profileRepository.follow(userProfile, currentUser);
    yield* followEither.fold(
      (failure) async* {
        print('profile bloc follow failure');
        yield UpdateFailed();
      },
      (success) async* {
        yield* _mapFetchUserProfileToEvent(currentUser.id);
      },
    );
  }

  Stream<ProfileState> _mapUnFollowToEvent(
      UserProfileEntity userProfile, UserProfileEntity currentUser) async* {
    final unFollowEither =
        await profileRepository.unfollow(userProfile, currentUser);
    yield* unFollowEither.fold(
      (failure) async* {
        print('profile bloc un-follow failure');
        yield UpdateFailed();
      },
      (success) async* {
        yield* _mapFetchUserProfileToEvent(currentUser.id);
      },
    );
  }
}
