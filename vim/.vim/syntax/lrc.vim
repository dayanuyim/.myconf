syntax case ignore
syntax match fields /^\(\[[^\]]*\]\)\+/ contains=message
syntax match message contained /\[[^\]]*\]/hs=s+1,he=e-1 contains=keywords,time
syntax match timeinline /<[0-9][0-9:.]*>/ contains=time2
syntax match keywords contained /\[[^:]*:/hs=s+1,he=e-1 contains=colon
syntax match time contained /\[[0-9][0-9:.]*\]/hs=s+1,he=e-1
syntax match time2 contained /<[0-9][0-9:.]*>/hs=s+1,he=e-1
syntax match colon contained /:/

highlight link fields     Statement
highlight link keywords   Keyword
highlight link message    Identifier
highlight link time       Float
highlight link time2      Float
highlight link colon      Operator
highlight link timeinline Statement

