{application, amas_echo_server,
 [{description, "提供简单的echo服务"},
  {vsn, "0.1.0"},
  {modules, [amas_es_app,
             amas_es_sup,
             amas_es_server]},
  {registered, [amas_es_sup]},
  {applications, [kernel, stdlib, sasl]},
  {mod, {amas_es_app, []}}]}.
