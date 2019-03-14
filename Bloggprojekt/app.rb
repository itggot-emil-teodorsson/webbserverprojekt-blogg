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

post('/check_values') do
    db=SQLite3::Database.new('db/users.db')

    db.results_as_hash = true
    result = db.execute("SELECT * FROM accounts")
    
    session[:username] = params["username"]
    session[:password] = params["password"]
    
    i = 0
    while i <= result.length - 1
        if session[:username] == result[i][0]
            if BCrypt::Password.new(result[i][1]) == session[:password]
                valid = true
                User_id = result[i][2]
                break
            else
                valid = false
            end
        else
            valid = false
        end

        i += 1
    end

    if valid == true
        redirect('/access')
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

get('/register') do
    slim(:register)
end

post('/register_values') do
    db=SQLite3::Database.new('db/users.db')
    
    db.results_as_hash = true

    session[:reg_username] = params["reg_username"]
    session[:reg_password] = params["reg_password"]

    session[:hash_password] = BCrypt::Password.create(session[:reg_password])

    if session[:reg_username] != db.execute("SELECT Username FROM accounts")
        db.execute("INSERT INTO accounts (Username, Password) VALUES (?,?)", session[:reg_username], session[:hash_password])
    else
        redirect('/username_taken')
    end

    redirect('/')
end

get('/username_taken') do
    slim(:username_taken)
end

get('/user_page') do
    slim(:userpage)
end