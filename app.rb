require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db 
	$db = SQLite3::Database.new 'leprosorium-2.db' 
	$db.results_as_hash = true
end

before do
	init_db
end

configure do 
	$db.execute 'create table if not exists Posts
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		create_date DATE, 
		content TEXT
	)'
end		

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
  erb :new
end

post '/new' do 
	content = params[:content]

	if content.size <=0
		@error = 'Вы не ввели текс'
		return erb :new
	else
		$db.execute 'insert into Posts (content, create_date) values (?, datetime())', [content]
		erb "Вы ввели: #{content}"	
	end

	
end