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
// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps, unused_catch_stack

import 'package:edge_dart_http_client/edge_dart_http_client.dart';
import 'package:edge_supabase/edge_supabase.dart';
import 'package:edge_telegram_bot/data/data.dart';
import 'package:edge_telegram_bot/edge_telegram_bot_core.dart';
import 'package:general_lib/extension/dynamic.dart';

import 'package:telegram_client/telegram_client/telegram_client.dart';

void main() async {
  TelegramClient tg = TelegramClient();

  tg.ensureInitialized(
    is_init_tdlib: false,
    telegramClientTelegramBotApiOption: TelegramClientTelegramBotApiOption(
      tokenBot: EdgeTelegramBotData.telegram_bot_token,
      clientOption: {},
      httpClient: EdgeHttpClient(),
    ),
  );
  EdgeTelegramBot edgeTelegramBot = EdgeTelegramBot(tg: tg);
  SupabaseFunctions(fetch: (request) async {
    Response response({
      required Map data,
    }) {
      return Response.json(data.toStringifyPretty());
    }

    try {
      String pathUrl = request.url.path.trim();
      String method = request.method.toLowerCase();
      Map queryParameters = request.url.queryParameters;
      

      if (RegExp("(/telegram/webhook)", caseSensitive: false).hasMatch(request.url.path)) {
        if (request.method.toLowerCase() != "post") {
          return response(
            data: {
              "@type": "error",
              "message": "method_not_support",
              "description": "Maaf hanya menerima method post",
            },
          );
        }
        Object? body = await request.json();

        if (body is Map && body.isNotEmpty) {
          Map? result = await edgeTelegramBot.botUpdate(update: body);

          return response(
            data: {"@type": "ok"},
          );
        }
        return response(
          data: {
            "@type": "error",
            "message": "method_not_support",
            "description": "Maaf hanya menerima method post",
          },
        );
      }

      return response(data: {
        "@type": "error",
        "message": "path_not_found",
        "description": "Maaf tidak ada path: ${request.url.path}",
      });
    } catch (e, stack) {
      return response(data: {
        "@type": "error",
        "message": "server_error",
        // "description": "Maaf tidak ada path: ${request.url.path}",
      });
    }
  });
}
