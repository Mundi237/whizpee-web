// GENERATED CODE - DO NOT MODIFY BY HAND

// @dart=3.0
part of 'block_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$BlockApi extends BlockApi {_$BlockApi([ChopperClient? client]) { if (client == null) return;
this.client = client; }

@override final Type definitionType = BlockApi;

@override Future<Response<dynamic>> banUser(String peerId) { final  Uri  $url = Uri.parse('user-ban/${peerId}/ban');
final  Request  $request = Request('POST', $url, client.baseUrl, );
return  client.send<dynamic, dynamic>($request); } 
@override Future<Response<dynamic>> unBanUser(String peerId) { final  Uri  $url = Uri.parse('user-ban/${peerId}/un-ban');
final  Request  $request = Request('POST', $url, client.baseUrl, );
return  client.send<dynamic, dynamic>($request); } 
@override Future<Response<dynamic>> checkBan(String peerId) { final  Uri  $url = Uri.parse('user-ban/${peerId}/ban');
final  Request  $request = Request('GET', $url, client.baseUrl, );
return  client.send<dynamic, dynamic>($request); } 
 }
