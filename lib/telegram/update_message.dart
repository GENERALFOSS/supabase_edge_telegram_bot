/* <!-- START LICENSE -->


Program Ini Di buat Oleh DEVELOPER Dari PERUSAHAAN GLOBAL CORPORATION 
Social Media: 

- Youtube: https://youtube.com/@Global_Corporation 
- Github: https://github.com/globalcorporation
- TELEGRAM: https://t.me/GLOBAL_CORP_ORG_BOT

Seluruh kode disini di buat 100% murni tanpa jiplak / mencuri kode lain jika ada akan ada link komment di baris code

Jika anda mau mengedit pastikan kredit ini tidak di hapus / di ganti!

Jika Program ini milik anda dari hasil beli jasa developer di (Global Corporation / apapun itu dari turunan itu jika ada kesalahan / bug / ingin update segera lapor ke sub)

Misal anda beli Beli source code di Slebew CORPORATION anda lapor dahulu di slebew jangan lapor di GLOBAL CORPORATION!


<!-- END LICENSE --> */
// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:async';

import 'package:edge_supabase/edge_supabase.dart';
import 'package:edge_telegram_bot/data/data.dart';
import 'package:edge_telegram_bot/edge_telegram_bot_core.dart';
import 'package:telegram_client/telegram_client.dart';

extension EdgeTelegramBotUpdateMessageExtension on EdgeTelegramBot {
  FutureOr<Map?> telegram_updateMessage({
    required Map update,
  }) async {
    if (update["message"] is Map == false) {
      return null;
    }
    Map msg = update["message"];
    if (msg["from"] is Map == false) {
      return null;
    }
    if (msg["chat"] is Map == false) {
      return null;
    }
    Map msg_from = msg["from"];
    int from_id = msg_from["id"];

    if (msg_from["first_name"] is String == false) {
      msg_from["first_name"] = "";
    }
    if (msg_from["last_name"] is String == false) {
      msg_from["last_name"] = "";
    }

    String from_first_name = msg_from["first_name"];
    String from_last_name = msg_from["last_name"];
    String from_full_name = "${from_first_name.trim()} ${from_last_name.trim()}".trim();

    Map msg_chat = msg["chat"];

    if (msg_chat["first_name"] is String == false) {
      msg_chat["first_name"] = "";
    }
    if (msg_chat["title"] is String == false) {
      msg_chat["title"] = "";
    }

    if (msg_chat["last_name"] is String == false) {
      msg_chat["last_name"] = "";
    }

    if (msg_chat["type"] is String == false) {
      msg_chat["type"] = "";
    }
    int chat_id = msg_chat["id"];

    String chat_first_name = msg_chat["first_name"];
    String chat_title = msg_chat["title"];
    String chat_last_name = msg_chat["last_name"];
    String chat_type = msg_chat["type"];
    String msg_text_or_caption = () {
      if (msg["text"] is String) {
        return msg["text"];
      }
      if (msg["caption"] is String) {
        return msg["caption"];
      }
      return "";
    }();

    RegExp regExp_prefix = RegExp("^([./!])", caseSensitive: false);
    FutureOr<Map> telegramRequest({
      required String method,
      Map? parameters,
    }) async {
      parameters ??= {};
      parameters.addAll({
        "@type": method,
      });
      return await tg.request(
        parameters: parameters,
        telegramClientData: TelegramClientData.telegramBotApi(
          token_bot: EdgeTelegramBotData.telegram_bot_token,
        ),
      );
    }

    try {
      if (regExp_prefix.hasMatch(msg_text_or_caption)) {
        String command_text = msg_text_or_caption.replaceAll(regExp_prefix, "");
        if (RegExp("^(start)", caseSensitive: false).hasMatch(command_text)) {
          return await telegramRequest(
            method: "sendMessage",
            parameters: {
              "chat_id": chat_id,
              "text": """
Hallo Perkenalkan Saya Robot Saya 

https://github.com/GENERALFOSS/supabase_edge_telegram_bot
""",
            },
          );
        }
      }
    } catch (e) {
      return await telegramRequest(
        method: "sendMessage",
      
            parameters: {
              "chat_id": chat_id,
              "text": """
Ada yang error nich slebew

https://github.com/GENERALFOSS/supabase_edge_telegram_bot
""",
            },
      );
    }


    return null;
  }
}
