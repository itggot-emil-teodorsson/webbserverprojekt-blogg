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
                session[:User_id] = result[i][2]
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

    db.execute("INSERT INTO accounts (Username, Password) VALUES (?,?)", session[:reg_username], session[:hash_password])

    redirect('/reg_complete')
end

get('/reg_complete') do
    slim(:reg_complete)
end

before('/user_page') do
    db=SQLite3::Database.new('db/users.db')

    db.results_as_hash = true
    result = db.execute("SELECT * FROM accounts")

    j = 0
    
    while j <= result.length - 1
        if session[:User_id] == result[j][2]
            session[:logged_in] = true
        else
            session[:logged_in] = false
        end
        
        j += 1
    end
end

get('/user_page') do
    if session[:logged_in] == true
        slim(:userpage)
    else
        slim(:no_profile)
    end
end

get('/red_prof') do
    slim(:red_prof)
end

post('/spara_redigering') do
    
end