# require 'cgi'
require 'uri'
require 'open-uri'
require 'nokogiri'

# cgi = CGI.new
# url = cgi['url']  # formのurlを取得
# email = cgi['mail'] # formのメールを取得

url = "https://page.auctions.yahoo.co.jp/jp/auction/p1030200628"
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
if !(url.match(/https:\/\/page.auctions.yahoo.co.jp\/jp\/auction\/[a-z][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]/))
    puts "Yahooオークションの商品ページURLではありません。"
    return
end
puts "Yahooオークションの商品ページURLです。"

# urlからアクセス、全体データ取得
charset = nil
html = URI.open(url) do |f|
charset = f.charset    # 文字種別を取得
f.read                 # htmlを読み込んで変数htmlに渡す
end

# nokogiriで扱えるように取得したHTMLを変換
doc = Nokogiri::HTML.parse(html, nil, charset)
# 商品の出品が終了しているかどうか
if doc.at_css('div.ClosedHeader__tag') 
    puts 'URLの商品はもうすでに終了しています。'
    return
end 

# 入力された文字列がメールアドレスかどうか
if !(email.match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i))
    puts "メールアドレスが間違っています"
    return
end
puts "メールアドレスです。"

# スクレイピングされているURLがすでに10個ある場合、「表示数が限界です。他の商品推移を削除してから入力してください。」を返す

# 全てのチェックが完了したらURLとメールをデータベースに保存する

# データベースから保存されているスクレイピングの実行結果を取得する
# 取得した実行結果をHTMLに表示する



