fx_version 'adamant'
game 'gta5'

author 'troner14'
description 'Troner14_minerJob by troner14'
version '1.0'

lua54 'yes'

server_scripts {
	'server/main.lua',
	"@es_extended/locale.lua",
    "locales/es.lua",
	'config.lua',
	"@mysql-async/lib/MySQL.lua"
}

client_scripts {
	"@es_extended/locale.lua",
    "locales/es.lua",
	'config.lua',
	'client/main.lua'
}

ui_page "html/index.html"

files({
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/items/*.png',
})
