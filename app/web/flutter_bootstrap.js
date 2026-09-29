{{flutter_js}}
{{flutter_build_config}}
// i18n: index.html sets window.PORTFOLIO_LANG before loading this file
if (window.PORTFOLIO_LANG === "en") _flutter.buildConfig.builds[0].mainJsPath = "main.dart.en.js";

_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}}
  }
});
