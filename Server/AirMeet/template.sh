#!/bin/sh

#イベント登録
regEve=`curl -s -H 'X-AccessToken: a' -X POST -d "event_name=test_en1" -d "items=belong,hobby,presentation" http://airmeet.mybluemix.net/api/register_event`
major=`echo $regEve | jq '.major'`
echo $regEve | jq '.'
echo $major

#ユーザ登録
regUser1=`curl -s -H 'X-AccessToken: a' -X POST -F "major=$major" -F "name=佐藤 豪" -F "profile=shokaibun" -F 'items={belong:"Tsukuba",hobby:"h",presentation:"p"}' -F 'image=@/Users/kimura/image/1.jpg' -F 'image_header=@/Users/kimura/image/1h.jpg' http://airmeet.mybluemix.net/api/register_user`

uid1=`echo $regUser1| jq -r '.id'`
#echo $regUser1 | jq '.'
echo $uid1

regUser2=`curl -s -H 'X-AccessToken: a' -X POST -F "major=$major" -F "name=塩原 百花" -F "profile=shokaibun" -F 'items={belong:"Tsukuba",hobby:"h",presentation:"p"}' -F 'image=@/Users/kimura/image/2.jpg' -F 'image_header=@/Users/kimura/image/2h.jpg' http://airmeet.mybluemix.net/api/register_user`
uid2=`echo $regUser2| jq -r '.id'`
echo $uid2

regUser3=`curl -s -H 'X-AccessToken: a' -X POST -F "major=$major" -F "name=神武 里奈" -F "profile=shokaibun" -F 'items={belong:"Tsukuba",hobby:"h",presentation:"p"}' -F 'image=@/Users/kimura/image/3.jpg' -F 'image_header=@/Users/kimura/image/3h.jpg' http://airmeet.mybluemix.net/api/register_user`
uid3=`echo $regUser3| jq -r '.id'`
echo $uid3

regUser4=`curl -s -H 'X-AccessToken: a' -X POST -F "major=$major" -F "name=川端 彬子" -F "profile=shokaibun" -F 'items={belong:"Tsukuba",hobby:"h",presentation:"p"}' -F 'image=@/Users/kimura/image/4.jpg' -F 'image_header=@/Users/kimura/image/4h.jpg' http://airmeet.mybluemix.net/api/register_user`
uid4=`echo $regUser4| jq -r '.id'`
echo $uid4

regUser5=`curl -s -H 'X-AccessToken: a' -X POST -F "major=$major" -F "name=木邑和馬" -F "profile=shokaibun" -F 'items={belong:"Tsukuba",hobby:"h",presentation:"p"}' -F 'image=@/Users/kimura/image/5.jpg' -F 'image_header=@/Users/kimura/image/5h.jpg' http://airmeet.mybluemix.net/api/register_user`
uid5=`echo $regUser5| jq -r '.id'`
echo $uid5




#参加者取得
participants=`curl -s -H 'X-AccessToken: a' -X GET http://airmeet.mybluemix.net/api/participants?major=$major\&id=${uid1}`
echo $participants | jq '.'
