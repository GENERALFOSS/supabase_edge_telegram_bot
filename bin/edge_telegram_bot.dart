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
// ignore_for_file: unused_local_variable, constant_identifier_names, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

// import 'package:edge_supabase/edge_supabase.dart';
import 'package:general_lib/general_lib.dart';
import 'package:http/http.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:telegram_client/telegram_client/telegram_client.dart';
import "package:path/path.dart" as path;

Logger logger = Logger();
TelegramClient tg = TelegramClient();
Future<(String token_bot, Map get_me)> askTokenBot() async {
  while (true) {
    await Future.delayed(Duration(microseconds: 1));

    String result = logger.prompt("Tolong Masukan Token Bot Ya @botfather: (12345:abcd)");

    if (result.isNotEmpty) {
      Map get_me_result = await tg.telegramBotApi.request(
        "getMe",
        isThrowOnError: false,
        tokenBot: result,
      );

      if (get_me_result["ok"] == true) {
        return (result, get_me_result["result"] as Map);
      }
    }
  }
}

Future<Uri> askTelegramUrlWebhook() async {
  while (true) {
    await Future.delayed(Duration(microseconds: 1));

    String result = logger.prompt("Tolong Masukan Url Webhook Ya Contoh: https://example.supabase.co");

    if (result.isNotEmpty) {
      Uri uri = Uri.parse(result).replace(pathSegments: [
        "functions",
        "v1",
        "edge_telegram_bot",
        "telegram",
        "webhook",
      ]);
      try {
        Response slebew = await head(uri);
        return uri;
      } catch (e) {}
    }
  }
}

void main(List<String> args_raws) async {
  Args args = Args(args_raws);
  tg.ensureInitialized(
    is_init_tdlib: false,
  );

  String command = (args.arguments.firstOrNull ?? "");

  List<String> commands = [
    "generate",
    "set_webhook",
    "help",
  ];

  commands.sort();

  if (commands.contains(command) == false) {
    command = await Future(() async {
      while (true) {
        await Future.delayed(Duration(microseconds: 1));

        String result = logger.chooseOne("Silahkan Pilih", choices: commands);

        if (commands.contains(result)) {
          return result;
        }
      }
    });
  }

  if (command == "generate") {
    var (String token_bot, Map bot_info) = await askTokenBot();
    print(bot_info.toStringifyPretty());

    String generate_script_data = """
// ignore_for_file: non_constant_identifier_names

class EdgeTelegramBotData {
  static String telegram_bot_token = ${json.encode(token_bot)};
  
  static int telegram_bot_id = ${(bot_info["id"])};
  
  static String telegram_bot_username = ${json.encode(bot_info["username"])};

}

""";
    Directory directory_data = Directory(path.join(Directory.current.path, "lib", "data"));
    if (directory_data.existsSync() == false) {
      await directory_data.create(recursive: true);
    }
    File file_data = File(path.join(directory_data.path, "data.dart"));

    await file_data.writeAsString(generate_script_data);

    print("Succes");

    exit(0);
  }

  if (command == "set_webhook") {
    var (String token_bot, Map bot_info) = await askTokenBot();
    print(bot_info.toStringifyPretty());

    Uri url_webhook = await askTelegramUrlWebhook();
    print("Telegram Url Webhook: ${url_webhook.toString()}");

    Map webhok = await tg.telegramBotApi.invoke(
      "setWebhook",
      parameters: {
        "url": url_webhook.toString(),
      },
      tokenBot: token_bot,
    );
    webhok.printPretty();
    print("Succes");
  }
  exit(0);
}
// https://xeilkdirppuzpeqvoziq.supabase.co/functions/v1/edge_telegram_bot/telegram/webhook
// https://xeilkdirppuzpeqvoziq.supabase.co/functions/v1/edge_telegram_bot/telegram/webhook