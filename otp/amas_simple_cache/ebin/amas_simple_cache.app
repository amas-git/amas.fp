{
  application, 
  amas_simple_cache,                                                           
  [
   {description, "提供简单的cache服务"}, 
   {vsn, "0.1.0"},
   {modules, [
              amas_sc_app,
              amas_sc_sup
             ]},
   {registered, [amas_sc_sup]},
   {applications, [kernel, stdlib]},     
   {mod, {amas_sc_app, []}},
   {start_phases, []}
  ]
}.
