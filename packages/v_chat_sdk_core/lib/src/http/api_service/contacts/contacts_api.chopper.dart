// GENERATED CODE - DO NOT MODIFY BY HAND

// @dart=3.0
part of 'contacts_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ContactsApi extends ContactsApi {_$ContactsApi([ChopperClient? client]) { if (client == null) return;
this.client = client; }

@override final Type definitionType = ContactsApi;

@override Future<Response<dynamic>> createContacts(Map<String, dynamic> body) { final  Uri  $url = Uri.parse('contact/');
final $body = body;
final  Request  $request = Request('POST', $url, client.baseUrl, body: $body, );
return  client.send<dynamic, dynamic>($request); } 
@override Future<Response<dynamic>> updateContacts(Map<String, dynamic> body) { final  Uri  $url = Uri.parse('contact/');
final $body = body;
final  Request  $request = Request('PUT', $url, client.baseUrl, body: $body, );
return  client.send<dynamic, dynamic>($request); } 
@override Future<Response<dynamic>> deleteContacts(Map<String, dynamic> body) { final  Uri  $url = Uri.parse('contact/');
final $body = body;
final  Request  $request = Request('DELETE', $url, client.baseUrl, body: $body, );
return  client.send<dynamic, dynamic>($request); } 
 }
