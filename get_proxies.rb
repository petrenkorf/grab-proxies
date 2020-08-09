require 'open-uri'
require 'nokogiri'
require 'base64'

proxylist = []

url     = "https://proxy-list.org/english/index.php?p="
headers = {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:53.0) Gecko/20100101 Firefox/53.0"}
ENCODED_IP_REGEX = /(\')(.*)(\')/i

for page in 1..10 do
  p "[*]Scrapping page #{page}..."
  response = open(url+page.to_s, headers)

  doc = Nokogiri::HTML(response)

  doc = doc.xpath("//*[@class=\"proxy\"]").each do |l|
    matches   = l.to_s.scan(ENCODED_IP_REGEX)
    encodedIp = matches[0][1] if matches.empty? === false
    proxylist.push(Base64.decode64 encodedIp) if encodedIp.nil? === false
  end
  sleep 5
end

p "[*]Writing proxies to file..."

File.open('proxylist', 'a') do |file|
  for ip in proxylist do
    file.write("#{ip}\n")  
  end
end

p "[*]Done!"

