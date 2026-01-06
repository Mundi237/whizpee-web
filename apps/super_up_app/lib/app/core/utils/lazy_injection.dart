// Copyright 2023, the hatemragab project author.
// All rights reserved. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:get_it/get_it.dart';
 import 'package:super_up_core/super_up_core.dart';

import '../api_service/auth/auth_api_service.dart';
import '../api_service/profile/profile_api_service.dart';
import '../api_service/story/story_api_service.dart';
import '../app_config/app_config_controller.dart';
import '../controllers/version_checker_controller.dart';

void registerSingletons() {
  GetIt.I.registerSingleton<AuthApiService>(AuthApiService.init());
  GetIt.I.registerSingleton<StoryApiService>(StoryApiService.init());
  final ProfileApiService profileApiService = ProfileApiService.init();
  GetIt.I.registerSingleton<ProfileApiService>(profileApiService);
  GetIt.I.registerSingleton<AppSizeHelper>(AppSizeHelper());
  GetIt.I.registerSingleton<VAppConfigController>(
    VAppConfigController(profileApiService),
  );

  GetIt.I.registerSingleton<VersionCheckerController>(
      VersionCheckerController(profileApiService));


}
