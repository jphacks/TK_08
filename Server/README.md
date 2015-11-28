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
|mandatory_filed|○|ユーザに入力させる必須項目<br>JSON形式|

### レスポンスボディ(JSON形式)
#### 成功時
```
{
    "major": 数字,
    "message": "なんかメッセージ",
    "code": 200
}
```

#### 失敗時(クライアントエラー)
```
{
    "message":"なんかメッセージ",
    "code":400
}
```

#### 失敗時(サーバエラー)
```
{
    "message":"なんかメッセージ",
    "code":500
}
```

## 会場の削除

## 会場の確認
### リクエストURL
http://airmeet.mybluemix.net/get_event

メソッド:GET

### リクエストクエリパラメータ
|キー|必須|説明|
|:--|:--:|:--|
|major|○|major|

### レスポンスボディ(JSON形式)
#### 成功時
```
{
    "event_name": イベント名,
    "room_name": ルーム名,
    "description": 説明文,
    "major": 数字,
    "code": 200
}
```

#### 失敗時(クライアントエラー)
```
{
    "message":"なんかメッセージ",
    "code":400
}
```

#### 失敗時(サーバエラー)
```
{
    "message":"なんかメッセージ",
    "code":500
}
```


## 会場へのユーザの登録

## 現在の参加者の取得

## ユーザ登録の削除
