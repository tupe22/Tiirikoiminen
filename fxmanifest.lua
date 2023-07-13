game 'gta5'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    'cl-tiirikoiminen.lua',
}
shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}
server_scripts {
    'sv-tiirikoiminen.lua'
}

dependencies {
    'ox_lib',
    'ox_target',
    'mythic_notify'
}
