# require 'cgi'
require 'uri'
require 'open-uri'
require 'nokogiri'

# cgi = CGI.new
# url = cgi['url']  # formのurlを取得
# email = cgi['mail'] # formのメールを取得

url = "https://page.auctions.yahoo.co.jp/jp/auction/l1030746530"
email = "test@test.com"

# URLとメールの中身が空かどうか
if url == "" && email == ""
    puts "何も入力されていません"
    return
elsif url == "" 
    puts "URLが入力されていません"
    return
elsif email == ""
    puts "メールが入力されていません"
    return
end

# Yahooオークションの商品ページURLかどうか
# 入力されたURLがヤフーオークションの商品URLでない場合、「URLが間違っています。」を返す
if !(url.match(/https:\/\/page.auctions.yahoo.co.jp\/jp\/auction\/[a-z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]/))
    puts "Yahooオークションの商品ページURLではありません。"
    return
end
puts "Yahooオークションの商品ページURLです。"

# 入力された商品URLが終了していた場合、「この商品はもうすでに終了しています」を返す
#urlからアクセス、全体データ取得
charset = nil
html = URI.open(url) do |f|
charset = f.charset    #文字種別を取得
f.read                 #htmlを読み込んで変数htmlに渡す
end

#nokogiriで扱えるように取得したHTMLを変換
doc = Nokogiri::HTML.parse(html, nil, charset)
if doc.xpath('//*[@id="closedHeader"]/div')
    puts "この商品はもうすでに終了しています"
    return
end

# メールアドレスかどうか
# 入力された文字列がメール出ない場合、「メールが間違っています」を返す
if !(email.match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i))
    puts "メールが間違っています"
    return
end
puts "メールアドレスです。"

# スクレイピングされているURLがすでに10個ある場合、「表示数が限界です。他の商品推移を削除してから入力してください。」を返す

# 全てのチェックが完了したらURLとメールをデータベースに保存する

# データベースから保存されているスクレイピングの実行結果を取得する
# 取得した実行結果をHTMLに表示する



