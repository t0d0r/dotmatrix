" UTF-8
" Bulgarian keymap is included in Vim by default
" to switch to BG PHONETIC use i_CTRL-^ (i_ means in insert mode)
if has('gui_running')
  " don't let bulgarian keymap to enabled by default
  "let &iminsert = ! &iminsert
  set iminsert=0
  set imsearch=-1

  " fix for OS specific cyrillic
"  set langmap=яq,вw,еe,рr,тt,ъy,уu,иi,оo,пp,ш[,щ],аa,сs,дd,фf,гg,хh,йj,кk,лl,ю\\,зz,ьx,цc,жv,бb,нn,мm,ч`,ЯQ,ВW,ЕE,РR,ТT,ЪY,УU,ИI,ОO,ПP,Ш[,Щ],АA,СS,ДD,ФF,ГG,ХH,ЙJ,КK,ЛL,Ю\\,ЗZ,ЬX,ЦC,ЖV,БB,НN,МM,Ч`
"  set keymap=bulgarian-phonetic
endif
