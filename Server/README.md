# AirMeet WebAPI

## 会場の登録
### リクエストURL
http://airmeet.mybluemix.net/event_regist

メソッド:POST

### リクエストボディ
|キー|必須|説明|
|:--|:--:|:--|
|event_name|○|イベント名|
|room_name|○|会場名|
|description||説明文|


### レスポンス(JSON形式)
#### 成功時
```
{"message":"なんかメッセージ","code":200}
```
#### 失敗時
```
{"message":"なんかメッセージ","code":500}
```
## 会場の削除

## 会場の確認

## 会場へのユーザの登録

## 現在の参加者の取得

## ユーザ登録の削除
