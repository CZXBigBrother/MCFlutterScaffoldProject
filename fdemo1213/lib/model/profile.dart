class Profile {
  Profile();
  String token;
  num theme;
  String lastLogin;
  String locale;
  // User user;
  Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
        // 'user': instance.user,
        'token': instance.token,
        'theme': instance.theme,
        // 'cache': instance.cache,
        'lastLogin': instance.lastLogin,
        'locale': instance.locale
      };

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
