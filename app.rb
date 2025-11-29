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
	@posts = $db.execute 'select * from Posts order by id desc'
	erb :index
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
		redirect '/'	
	end
end

get '/post/:id' do
	post_id = params[:id]

	results = $db.execute 'select * from Posts where id = ?', [post_id]
	@row = results[0]

	erb :post

end