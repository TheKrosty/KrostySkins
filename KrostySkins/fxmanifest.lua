



fx_version 'adamant'
game 'gta5'


client_script {
	'config.lua',
	'client/*.lua',
} 

server_scripts {
	'config.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua',
} 





client_script 'entityiter.lua'
client_script "@Badger-Anticheat/acloader.lua"