# AirMeet WebAPI

## イベントの登録
親機はイベント名、会場名、説明文、子機に入力させる必須項目などを設定し、サーバに送る
### リクエストURL
http://airmeet.mybluemix.net/register_event

メソッド:GET

### リクエストクエリパラメータ
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
    "message": "なんかメッセージ",
    "code": 400
}
```

#### 失敗時(サーバエラー)
```
{
    "message": "なんかメッセージ",
    "code": 500
}
```

## イベントの削除
### リクエストURL
http://airmeet.mybluemix.net/remove_event

メソッド:GET

### リクエストクエリパラメータ
|キー|必須|説明|
|:--|:--:|:--|
|major|○|親機のmajorの値|

### レスポンスボディ(JSON形式)
#### 成功時
```
{
    "message": "なんか成功って感じのメッセージ",
    "code": 200
}
```

#### 失敗時(クライアントエラー)
```
{
    "message": "なんかメッセージ",
    "code": 400
}
```

#### 失敗時(サーバエラー)
```
{
    "message": "なんかメッセージ",
    "code": 500
}
```


## 会場の情報取得
### リクエストURL
http://airmeet.mybluemix.net/get_event_info

メソッド:GET

### リクエストクエリパラメータ
|キー|必須|説明|
|:--|:--:|:--|
|major|○|親機からiBeaconで取得したmajorの値|

### レスポンスボディ(JSON形式)
#### 成功時
```
{
    "event_name": "イベント名",
    "room_name": "ルーム名",
    "description": "説明文",
    "major": ユニークな数列,
    "items": [
        "親機側が設定した必須項目（配列形式）",
        "親機側が設定した必須項目（配列形式）"
    ],
    "code": 200
}
```

例
```
{
    "event_name": "JPHACKS",
    "room_name": "東京大学 本郷キャンパス 工学部2号館 213教室",
    "description": "JPHACKSの東京会場です。",
    "major": 12345,
    "items": [
        "belong",
        "hobby",
        "presentation"
    ],
    "code": 200
}
```
#### 失敗時(クライアントエラー)
```
{
    "message": "なんかメッセージ",
    "code": 400
}
```

#### 失敗時(サーバエラー)
```
{
    "message": "なんかメッセージ",
    "code": 500
}
```


## 会場へのユーザの登録&現在の参加者の取得

### リクエストURL
http://airmeet.mybluemix.net/register_user

メソッド:GET

### リクエストクエリパラメータ
|キー|必須|説明|
|:--|:--:|:--|
|major||親機からiBeaconで取得したmajorの値|
|name|○|名前|
|image|○|画像|
|image_header||ヘッダ画像|
|items|○|項目|


### レスポンスボディ(JSON形式)
#### 成功時
```
{
    "users": [  
        {
            "name": "参加している他のユーザ",
            "image": "画像のURL",
            "items": {
                "",
                ""
            }
        },
        {
            "name": "参加している他のユーザ",
            "image": "画像のURL",
            "items": {
                "",
                ""
            }
        }
    ],
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


## ユーザ登録の削除
