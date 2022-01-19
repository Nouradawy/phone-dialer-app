abstract class ProfileStates{}

class ProfileStatesInitial extends ProfileStates{}

class ProfileInitialState extends ProfileStates{}

class ProfileImagePickedSuccess extends ProfileStates{}
class ProfileImagePickedError extends ProfileStates{}

class CoverImagePickedSuccess extends ProfileStates{}
class CoverImagePickedError extends ProfileStates{}


class UploadProfileImageSuccess extends ProfileStates{}
class UploadProfileImageError extends ProfileStates{}

class UploadCoverImageSuccess extends ProfileStates{}
class UploadCoverImageError extends ProfileStates{}

class UpdateUserInfoLoading extends ProfileStates{}
class UpdateUserInfoSuccess extends ProfileStates{}
class UpdateUserInfoError extends ProfileStates{}

class ExtractCurrrentUserLoading extends ProfileStates{}
class ExtractCurrrentUserInfoSuccess extends ProfileStates{}
class ExtractCurrrentUserInfoError extends ProfileStates{}

