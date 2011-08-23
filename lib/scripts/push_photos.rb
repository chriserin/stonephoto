require 'mechanize'

for month in [4, 5, 8]
  dir = Dir.open("pics/2011/#{'%02d' % month}")
  dir.each do |file_name|
    @agent = Mechanize.new
    @agent.user_agent = 'Individueller User-Agent'
    @agent.user_agent_alias = 'Linux Mozilla'
    @agent.open_timeout = 3
    @agent.read_timeout = 1000 
    @agent.keep_alive = true

    @agent.max_history = 0 # reduce memory if you make lots of requests
    puts file_name 
    if file_name =~ /DSC/
      page = @agent.get "http://localhost:3000/photos/new"

      form = page.forms.first  
      form['photo[name]'] = "name"
      form['photo[tag]'] = "tag"
      form.file_uploads.first.file_name = "pics/2011/#{'%02d' % month}/" + file_name
      form.submit
    end
  end
end
