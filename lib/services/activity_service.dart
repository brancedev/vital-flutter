library vital;

import 'dart:async';
import 'package:chopper/chopper.dart';
import 'package:vital_flutter/services/data/activity.dart';
import 'package:vital_flutter/services/utils/http_api_key_interceptor.dart';
import 'package:vital_flutter/services/utils/http_logging_interceptor.dart';
import 'package:vital_flutter/services/utils/json_serializable_converter.dart';
import 'package:http/http.dart' as http;

part 'activity_service.chopper.dart';

@ChopperApi()
abstract class ActivityService extends ChopperService {
  @Get(path: 'summary/activity/{user_id}')
  @FactoryConverter(request: JsonConverter.requestFactory)
  Future<Response<ActivitiesResponse>> _getActivity(
    @Path('user_id') String userId,
    @Query('start_date') String startDate,
    @Query('end_date') String? endDate,
    @Query('provider') String? provider,
  );

  Future<Response<ActivitiesResponse>> getActivity(
    String userId,
    DateTime startDate,
    DateTime? endDate,
    String? provider,
  ) {
    return _getActivity(userId, startDate.toIso8601String(), endDate?.toIso8601String(), provider);
  }

  @Get(path: 'summary/activity/{user_id}/raw')
  Future<Response<Object>> getActivityRaw(
    @Path('user_id') String userId,
    @Query('start_date') DateTime startDate,
    @Query('end_date') DateTime? endDate,
    @Query('provider') String? provider,
  );

  static ActivityService create(http.Client httpClient, String baseUrl, String apiKey) {
    final client = ChopperClient(
      client: httpClient,
      baseUrl: baseUrl,
      interceptors: [HttpRequestLoggingInterceptor(), HttpApiKeyInterceptor(apiKey)],
      converter: const JsonSerializableConverter({
        ActivitiesResponse: ActivitiesResponse.fromJson,
      }),
    );

    return _$ActivityService(client);
  }
}
