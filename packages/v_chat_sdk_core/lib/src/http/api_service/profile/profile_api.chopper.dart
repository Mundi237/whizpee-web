// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class _$ProfileApi extends ProfileApi {_$ProfileApi([ChopperClient? client]) { if (client == null) return;
this.client = client; }

@override final Type definitionType = ProfileApi;

@override Future<Response<dynamic>> addNotificationPush(Map<String, dynamic> body) { final  Uri  $url = Uri.parse('profile/push');
final $body = body;
final  Request  $request = Request('POST', $url, client.baseUrl, body: $body, );
return  client.send<dynamic, dynamic>($request); } 
@override Future<Response<dynamic>> deleteNotificationPush() { final  Uri  $url = Uri.parse('profile/push');
final  Request  $request = Request('DELETE', $url, client.baseUrl, );
return  client.send<dynamic, dynamic>($request); } 
@override Future<Response<dynamic>> getLastSeenAt(String peerId) { final  Uri  $url = Uri.parse('profile/users/${peerId}/last-seen');
final  Request  $request = Request('GET', $url, client.baseUrl, );
return  client.send<dynamic, dynamic>($request); } 
 }
