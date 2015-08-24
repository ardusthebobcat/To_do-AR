require('sinatra')
require('sinatra/reloader')
require('sinatra/activerecord')
require('./lib/task')
require('./lib/list')
also_reload('lib/**/*.rb')
require('pg')

get '/'  do
	@lists = List.all()
	erb(:index)
end

post('/lists') do
	name = params.fetch('list')
	list = List.new({:name => name, :id => nil})
	list.save()
	redirect('/')
end

post('/task/new') do
	id = params.fetch('id').to_i()
	description = params.fetch('description')
	due_date = params.fetch('due_date')
	@list = List.find(id)
	task = Task.new(:list_id => id, :done => false, :description => description, :due_date => due_date)
	task.save()
	redirect('/list/' + @list.id().to_s)
end

get('/list/:id') do
	@list = List.find(params.fetch('id'))
	erb(:list)
end
