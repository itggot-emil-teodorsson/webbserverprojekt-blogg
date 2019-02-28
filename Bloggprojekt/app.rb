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

get('/login') do
    slim(:login)
end

post('/test') do
    db=SQLite3::Database.new('db/users.db')

    db.results_as_hash = true
    result = db.execute("SELECT * FROM accounts")
    
    session[:username] = params["username"]
    session[:password] = params["password"]
    if session[:username] == result[0][0]
        if session[:password] == result[0][1]
            redirect('/access')
        else
            redirect('/no_access')
        end
    else
        redirect('/no_access')
    end
end

get('/access') do
    slim(:access)
end

get('/no_access') do
    slim(:no_access)
end

post('/logout') do
    redirect('/')
end