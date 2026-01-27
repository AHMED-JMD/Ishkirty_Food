// Web implementation using dart:html
import 'dart:html' as html;

String? getLocal(String key) => html.window.localStorage[key];

void setLocal(String key, String value) {
  html.window.localStorage[key] = value;
}

void removeLocal(String key) {
  html.window.localStorage.remove(key);
}
