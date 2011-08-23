require 'rubygems'
require 'mechanize'
@agent = Mechanize.new
@agent.user_agent = 'Individueller User-Agent'
@agent.user_agent_alias = 'Linux Mozilla'
@agent.open_timeout = 3
@agent.read_timeout = 4
@agent.keep_alive = false

@agent.max_history = 0 # reduce memory if you make lots of requests

#01 manual get requests
page_ids = [91, 55, 143, 150]
url = 'http://meredithstoneimages.com'
STONE_URL = "meredithstoneimages.com"
@image_urls = []
@retries = []

def scrape_hrefs(hrefs)
  hrefs.each do |href|
    if href =~ /attachment/
      puts href
      begin
        sleep 2
        pic_page = @agent.get href
      rescue
        puts "timeout error"
        @retries << href
        next
      end
 
      pic_page.links.each do |pic_link|
        if pic_link.href =~ /2011\/(\d\d)\/DSC_(.*)\.jpg/
          @image_urls << "/wp-content/uploads/2011/#{$1}/DSC_#{$2}.jpg"
          puts "    " + @image_urls.last
        end
      end
    end
  end
end

for page_id in page_ids do 

  puts page_id
  begin
    sleep 2
    page = @agent.get url, {"page_id" => page_id}
  rescue Timeout::Error
    puts "timeout error " + page_id
    next
  end

  page_hrefs = page.links.map { |link| link.href }
  scrape_hrefs(page_hrefs)
end

scrape_hrefs(@retries)

for image in @image_urls do 
  Net::HTTP.start( STONE_URL ) { |http|
    begin 
      resp = http.get( image )
      sleep 2
    rescue
      puts 'error'
      next
    end
    if resp.code == '200'
      file_name = image.sub('/wp-content/uploads', 'pics')
      File.open(file_name, 'wb' ) { |file|
        file.write(resp.body)
        puts "saved file #{file_name}"
      }
    end 
  }
end
