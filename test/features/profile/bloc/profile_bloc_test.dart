import 'package:dartz/dartz.dart';
import 'package:fc_twitter/core/error/failure.dart';
import 'package:fc_twitter/features/profile/domain/entity/user_profile_entity.dart';
import 'package:fc_twitter/features/profile/representation/bloc/profile_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';
import '../../../mocks/mocks.dart';

void main() {
  UserProfileEntity userEntity;
  MockProfileRepository mockProfileRepository;
  ProfileBloc profileBloc;

  setUp(() {
    userEntity = userProfileEntityFixture();
    mockProfileRepository = MockProfileRepository();
    profileBloc = ProfileBloc(
      initialState: ProfileInitialState(),
      profileRepository: mockProfileRepository,
    );
  });

  test('confirm initial state', () {
    expect(profileBloc.state, equals(ProfileInitialState()));
  });

  group('profile bloc FetchUserProfile event', () {
    test(
        'should emit [FetchingUserProfile and FetchingComplete] when successful',
        () {
      when(mockProfileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingComplete(userProfile: UserProfileEntity()),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(FetchUserProfile('userId'));
    });

    test(
        'should emit [FetchingUserProfile and FetchingFailed] when un-successful',
        () {
      when(mockProfileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Left(ProfileFailure())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingFailed(),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(FetchUserProfile('userId'));
    });
  });

  group('profile bloc UpdateUserProfile event', () {
    test(
        'should emit [FetchingUserProfile and FetchingComplete] when successful',
        () {
      when(mockProfileRepository.updateUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(true)),
      );
      when(mockProfileRepository.uploadImage(any)).thenAnswer(
        (_) => Future.value(Right(userEntity)),
      );
      when(mockProfileRepository.getUserProfile(any)).thenAnswer(
        (_) => Future.value(Right(UserProfileEntity())),
      );

      final expectations = [
        FetchingUserProfile(),
        FetchingComplete(userProfile: UserProfileEntity()),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(UpdateUserProfile(userEntity));
    });

    test(
        'should emit [FetchingUserProfile and FetchingFailed] when un-successful',
        () {
      when(mockProfileRepository.updateUserProfile(any)).thenAnswer(
        (_) => Future.value(Left(ProfileFailure())),
      );
      when(mockProfileRepository.uploadImage(any)).thenAnswer(
        (_) => Future.value(Right(userEntity)),
      );

      final expectations = [
        UpdateFailed(),
      ];

      expectLater(profileBloc, emitsInOrder(expectations));
      profileBloc.add(UpdateUserProfile(userEntity));
    });
  });
}
