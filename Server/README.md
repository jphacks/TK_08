# AirMeet WebAPI

API一覧
- [イベントの登録](#register_event)
- [イベントの削除](#remove_event)
- [イベントの情報取得](#event_info)
- [イベントへのユーザの登録](#register_user)
- [イベント参加者の取得](#participants)
- [ユーザ登録の削除](#remove_user)

## <a id ="register_event">イベントの登録</a>
親機はイベント名、会場名、説明文、子機に入力させる必須項目などを設定し、サーバに送る
### リクエストURL
http://airmeet.mybluemix.net/register_event

メソッド:POST

### リクエストボディ
|キー|必須|説明|
|:--|:--:|:--|
|event_name|○|イベント名|
|room_name||会場名|
|description||説明文|
|items|○|ユーザに入力させる必須項目<br>","区切り|


### レスポンスボディ(JSON形式)
#### 成功時
```json
{
    "major": 数字,
    "message": "なんかメッセージ",
    "code": 200
}
```

#### 失敗時(クライアントエラー)
```json
{
    "message": "なんかメッセージ",
    "code": 400
}
```

#### 失敗時(サーバエラー)
```json
{
    "message": "なんかメッセージ",
    "code": 500
}
```

## <a id ="remove_event">イベントの削除</a>
### リクエストURL
http://airmeet.mybluemix.net/remove_event

メソッド:POST

### リクエストボディ
|キー|必須|説明|
|:--|:--:|:--|
|major|○|親機のmajorの値|

### レスポンスボディ(JSON形式)
#### 成功時
```json
{
    "message": "なんか成功って感じのメッセージ",
    "code": 200
}
```

#### 失敗時(クライアントエラー)
```json
{
    "message": "なんかメッセージ",
    "code": 400
}
```

#### 失敗時(サーバエラー)
```json
{
    "message": "なんかメッセージ",
    "code": 500
}
```


## <a id ="event_info">イベントの情報取得
### リクエストURL
http://airmeet.mybluemix.net/event_info

メソッド:GET

### リクエストクエリパラメータ
|キー|必須|説明|
|:--|:--:|:--|
|major|○|親機からiBeaconで取得したmajorの値|

### レスポンスボディ(JSON形式)
#### 成功時
```json
{
    "event_name": "イベント名",
    "room_name": "ルーム名",
    "description": "説明文",
    "major": ユニークな数列,
    "items": [
        "親機側が設定した必須項目（配列形式）",
        "親機側が設定した必須項目（配列形式）"
    ],
    "count": 現在の参加者数,
    "code": 200
}
```

例  
```json
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
```json
{
    "message": "なんかメッセージ",
    "code": 400
}
```

#### 失敗時(サーバエラー)
```json
{
    "message": "なんかメッセージ",
    "code": 500
}
```


## <a id ="register_user">イベントへのユーザの登録</a>

### リクエストURL
http://airmeet.mybluemix.net/register_user

メソッド:POST

### リクエストボディ
|キー|必須|説明|
|:--|:--:|:--|
|major|○|親機からiBeaconで取得したmajorの値|
|name|○|名前|
|profile||プロフィール|
|items|○|項目|
|image||画像|
|image_header||ヘッダ画像|

### レスポンスボディ(JSON形式)
#### 成功時
```json
{
    "id": "自分のid",
    "message": "なんか成功って感じのメッセージ",
    "code": 200
}
```

#### 失敗時(クライアントエラー)
```json
{
    "message":"なんかメッセージ",
    "code":400
}
```

#### 失敗時(サーバエラー)
```json
{
    "message":"なんかメッセージ",
    "code":500
}
```

## <a id ="participants">イベント参加者の取得</a>
### リクエストURL
http://airmeet.mybluemix.net/participants

メソッド:GET

### リクエストクエリパラメータ
|キー|必須|説明|
|:--|:--:|:--|
|major|○|親機からiBeaconで取得したmajorの値|
|id|○|自分のID|


### レスポンスボディ(JSON形式)
#### 成功時
```json
{
    "major" : "イベントのmajor値",
    "id" : "自分のID",
    "count" : "イベントの参加者数（自分除く）",
    "users": [  
        {
            "id": "参加している他のユーザのid",
            "name": "参加している他のユーザの名前",
            "profile": "プロフィール",
            "image": "画像のURL",
            "items": {
                "": "",
                "": "",
            }
        },
        {
            "id": "参加している他のユーザのid",
            "name": "参加している他のユーザ",
            "profile": "プロフィール",
            "image": "画像のURL",
            "items": {
                "": "",
                "": "",
            }
        }
    ],
    "message": "成功メッセージ",
    "code": 200
}
```

#### 失敗時(クライアントエラー)
```json
{
    "message":"なんかメッセージ",
    "code":400
}
```

#### 失敗時(サーバエラー)
```json
{
    "message":"なんかメッセージ",
    "code":500
}
```


## <a id ="remove_user">ユーザ登録の削除</a>
### リクエストURL
http://airmeet.mybluemix.net/remove_user

メソッド:POST

### リクエストボディ
|キー|必須|説明|
|:--|:--:|:--|
|id|○|削除したいユーザのID|

### レスポンスボディ(JSON形式)
#### 成功時
```json
{
    "id": "削除したユーザのID",
    "message": "なんか成功って感じのメッセージ",
    "code": 200
}
```

#### 失敗時(クライアントエラー)
```json
{
    "message": "なんかメッセージ",
    "code": 400
}
```

#### 失敗時(サーバエラー)
```json
{
    "message": "なんかメッセージ",
    "code": 500
}
```
