fx_version 'cerulean'

game "gta5"

version '1.0'
description 'six_gps'
author "Sezay | 6-services"

server_script {
    'config.lua',
    'server.lua',
}
client_script {
    'config.lua',
    'client.lua',
}

lua54 'yes'
dependency '/assetpacks'