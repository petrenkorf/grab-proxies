require 'open-uri'
require 'nokogiri'
require 'base64'

proxylist = []

for page in 1..10 do
  response = open("https://proxy-list.org/english/index.php?p=#{page}", 
                 "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:53.0) Gecko/20100101 Firefox/53.0")

  doc = Nokogiri::HTML(response)


  doc = doc.xpath("//*[@class=\"proxy\"]").each do |l|
    matches   = l.to_s.scan(/(\')(.*)(\')/i)
    encodedIp = matches[0][1] if matches.empty? === false
    proxylist.push(Base64.decode64 encodedIp) if encodedIp.nil? === false

    #ip        = Base64.decode64 encodedIp if encodedIp.nil? === false


    #p proxylist
  end
  sleep 5
end
File.open('proxylist', 'a') do |file| 
  for ip in proxylist do
    file.write("#{ip}\n")  
  end
end
p "Done!"

