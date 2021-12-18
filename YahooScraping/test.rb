require 'open-uri'
require 'nokogiri'

p "URLを入力してください"
url = gets

puts url

doc = Nokogiri::HTML(open(url.chomp!))
#現在の値段
doc.xpath('//*[@id="l-sub"]/div[1]/ul/li[2]/div[1]/div[2]/dl/dd[1]/text()').each do |node|
    puts "現在の値段 : #{node}"
end
#商品名
doc.xpath('//*[@id="ProductTitle"]/div/h1').each do |node|
    puts "商品名 : #{node}"
end
#開始日時
doc.xpath('//*[@id="l-main"]/div/div[2]/div/div/div[1]/ul/li[2]/dl/dd').each do |node|
    puts "開始日時 : #{node.text}"
end
#終了日時
doc.xpath('//*[@id="l-main"]/div/div[2]/div/div/div[1]/ul/li[3]/dl/dd').each do |node|
    puts "終了日時 : #{node.text}"
end
#残り時間
doc.xpath('//*[@id="l-sub"]/div[1]/ul/li[1]/div/ul/li[2]/dl/dd/text()').each do |node|
    puts "残り時間 : #{node}"
end
#入札件数
doc.xpath('//*[@id="l-sub"]/div[1]/ul/li[1]/div/ul/li[1]/dl/dd/text()').each do |node|
    puts "入札件数 : #{node}件"
end