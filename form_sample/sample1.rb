
# url自分でいれてちょ

require 'open-uri'
require 'nokogiri'

#標準入力ver.
=begin
puts "ヤフオクの商品ページのurlを入れてください:"
url = gets
=end



#一応確認の為に3パターンで確認するといい
#即決価格のみのurl
#url = ""

#現在価格のみのurl
#url = ""

#即決価格+現在価格のurl
#url = ""



#urlからアクセス、全体データ取得
charset = nil
html = URI.open(url) do |f|
  charset = f.charset    #文字種別を取得
  f.read                 #htmlを読み込んで変数htmlに渡す
end

#nokogiriで扱えるように取得したHTMLを変換
doc = Nokogiri::HTML.parse(html, nil, charset)

#aタグが入札件数とか残り時間とかの取得時に邪魔なので消す
doc.search(:a).map &:remove
    
# 条件分けの為に先に残り時間を取得(詳細はJSで構成されているので取得できない)
remain_time = doc.xpath('//li[@class="Count__count Count__count--sideLine"]//dd[@class="Count__number"]').text.gsub(/(\r\n|\r|\n|\f|\t)/, "")
if /[分]/.match(remain_time) then
    puts "残り時間が僅かなので終了致しました。"
    exit
end

#即決のみ(現在価格がない)の場合はそもそもしないようにする
if /[現在]/.match(doc.xpath('//dt[@class="Price__title"]').text) then 

    # 各必要データの取得
    # 商品名
    proname = doc.xpath('//h1[contains(@class, "Product")]').text.gsub(/(\r\n|\r|\n|\f|\t)/, "")

    # 税込価格を抜いた現在価格
    doc.xpath('//span[@class="Price__tax u-fontSize14"]').remove
    price = doc.at_xpath('//dd[@class="Price__value"]').text.gsub(/(\r\n|\r|\n|\f|\t)/, "")

    # 開始日時
    start = doc.xpath('//dl[contains(., "開始日時")]').text.gsub(/(\r\n|\r|\n|\f|\t)/, "")

    # 終了日時
    finish = doc.xpath('//dl[contains(., "終了日時")]').text.gsub(/(\r\n|\r|\n|\f|\t)/, "")

    # 入札件数
    bid_number = doc.at('//li[@class="Count__count"]//dd[@class="Count__number"]').text

    # 残り時間の文字列の整形("時間","日"の削除 + 数値に変換)
    if /["時間"]/.match(remain_time) then
        remain_time_data_H = remain_time.gsub("時間",'').to_i
        #puts "残り #{remain_time_data_H} 時間"
    else
        remain_time_data_D = remain_time.gsub("日",'').to_i
        #puts "残り #{remain_time_data_D} 日"
    end

    # 価格の文字列の整形
    price_data = price.gsub(",",'').gsub("円",'').to_i
    #puts "現在の価格は #{price_data} 円,税込価格は #{price_data*11/10} 円です"

    # 入札件数の文字列の整形
    bid_data = bid_number.to_i
    #puts "現在の入札件数は #{bid_data} 件です"

    # 確認で各データを出す
    puts <<-EOS
商品名　：#{proname}
現在価格：#{price}
#{start}
#{finish}
入札件数：#{bid_number}件
残り時間：#{remain_time}
    EOS
else
    puts "即決価格のみなので対象外です。"
end