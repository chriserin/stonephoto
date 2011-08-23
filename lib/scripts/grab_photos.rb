require 'net/http'

STONE_URL = "meredithstoneimages.com"

root_path = "/wp-content/uploads/2011"
for month in (4..8) do
  puts month
  month_s = "%02d" % month 
  directory_name = "pics/2011/#{month_s}"
  Dir::mkdir(directory_name) unless FileTest::directory?(directory_name)
  for pic_number in (1..9999)
    sleep 2
    Net::HTTP.start( STONE_URL ) { |http|
      begin 
        pic_path = "#{root_path}/#{month_s}/DSC_#{"%04d" % pic_number}.jpg"
        puts pic_path
        resp = http.get( pic_path )
      rescue
        puts 'error'
        next
      end
      if resp.code == '200'
        file_name = "pics/2011/#{month_s}/DSC_#{"%04d" % pic_number}.jpg"
        File.open(file_name, 'wb' ) { |file|
          file.write(resp.body)
          puts "saved file #{file_name}"
        }
      end 
      }
  end
end
