require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

enable :sessions


get('/') do
    slim(:index)
end

get('/skapa_inlagg') do
    slim(:skapa_inlagg)
end