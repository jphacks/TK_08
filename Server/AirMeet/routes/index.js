// MemoApp - routes\index.js

// 使用モジュールの読み込み
var express = require('express');
var uuid = require('node-uuid');
var moment = require('moment');
var fs = require('fs');
var dba = require('../api/dbaccess.js');
var package = require('../package.json');

var buf = fs.readFileSync('Authorized_Token');
var token_list = buf.toString().split("\n");

// ルーターの作成
var router = express.Router();

//認証
router.use(function(req, res, next) {
  var AccessToken = req.header("X-AccessToken");
  console.log(AccessToken);
  if(token_list.indexOf(AccessToken) >= 0){
    next();
  }else{
    var error ={
      message : "AccessToken is invalid",
      code : 400
    };
    res.send(error);
  }
})

// ルート
router.get('/', function(req, res) {
    res.send('Hello World');
});

//-----------------------------------------------------------//
// イベント登録
//-----------------------------------------------------------//
router.post('/register_event', function(req, res) {
//router.get('/register_event', function(req, res) {
  var success = {
    major : null,
    message : null,
    code : 200
  };
  var error = {};
  var id = uuid.v4();

  var en = req.body.event_name;
  var rn = req.body.room_name;
  var desc = req.body.description;
  var items = req.body.items;

  if(!en){
    error.message = "Error: event_name is missing";
    error.code = 400;

  }
  if(!items){
    error.message = "Error: items is missing";
    error.code = 400;
  }

  if(!Object.keys(error).length){
    dba.gen_major(function(major) {
      console.log("major:"+major);
      var doc = {
        type : "event",
        event_name : en,
        room_name : rn,
        description : desc,
        major : major,
        items : items.split(","),
        date : moment().zone('+0900').format('YYYY/MM/DD HH:mm:ss')
      };
      dba.save(id, doc, function(err) {
        if(err){
          error.message = "Error: Event registration failed";
          error.code = 500;
          res.send(error)
        }else{
          success.major = major;
          success.message = "Event registration success";
          res.send(success);
        }
      });
    });
  }else{
    res.send(error);
  }
});


//register_eventがGETならエラー
router.get('/register_event', function(req, res) {
  var error = {};
  error.message = "Error: Cannot 'GET' method";
  error.code = 400;
  res.send(error);
});


//-----------------------------------------------------------//
// イベント情報を取得
//-----------------------------------------------------------//
router.get('/event_info', function(req, res) {
  var sccess = {};
  var error = {};
  var major = Number(req.query.major);
  console.log(major);
  if(!major){
    error.message = "Error: major is missing";
    error.code = 400;
    res.send(error);
    return;
  }

  dba.event_info(major, function(err1, events) {
    if(events.length == 1){
      success = events[0].value;
      dba.get_participants(major, function(err2, users){
        var count = users.length;
        success.count = count;
        success.code = 200;
        res.send(success);
      });
    }else if(events.length > 1){
      error.message = "Error: Database is not valid";
      error.code = 500;
    }else{
      error.message = "Error: Event does not exist";
      error.code = 500;
    }

    if(Object.keys(error).length){
      res.send(error);
    }
  });
});


//-----------------------------------------------------------//
//イベントへのユーザ登録
//-----------------------------------------------------------//
router.post('/register_user', function(req, res) {
  var success = {
    id : null,
    message : null,
    code : 200
  };
  var error = {};
  var id = uuid.v4();

  var major = Number(req.body.major);
  var name = req.body.name;
  var image = req.body.image;
  var image_header = req.body.image_header;
  var items = req.body.items;

  if(!major){
    error.message = "Error: major is missing";
    error.code = 400;
  }
  if(!name){
    error.message = "Error: name is missing";
    error.code = 400;
  }

  if(!items){
    error.message = "Error: items is missing";
    error.code = 400;
  }else{
    try{
      items = (new Function("return " + items))();
    } catch(err){
      console.log('catch: ' + err.message);
      error.message = "Error: items is not JSON format";
      error.code = 400;
    }
  }

  if(!Object.keys(error).length){
    console.log(major);
    var doc = {
      type : "user",
      major : major,
      name : name,
      image : image,
      image_header : image_header,
      items : items,
      regist_date : moment().zone('+0900').format('YYYY/MM/DD HH:mm:ss')
    };
    dba.save(id, doc, function(err) {
      if(err){
        error.message = "Error: User registration failed";
        error.code = 500;
        res.send(error);
      }else{
        success.id = id;
        success.message = "User registration success";
        res.send(success);
      }
    });
  }else{
    res.send(error);
  }
});


//-----------------------------------------------------------//
// 参加者を取得
//-----------------------------------------------------------//
router.get('/participants', function(req, res) {
  var success = {
    major : null,
    id : null,
    count : null,
    users : [],
    code : 200
  };
  var error = {};

  var major = Number(req.query.major);
  var id = req.query.id;

  if(!major){
    error.message = "Error: major is missing";
    error.code = 400;
  }
  if(!id){
    error.message = "Error: id is missing";
    error.code = 400;
  }

  if(!Object.keys(error).length){
    dba.confirm_userid(id, major, function(err, users) {
      if(users.length == 1){
        dba.get_participants(major, function(err, users) {
          if(users.length){
            users.forEach(function(row) {
              if(row.id != id){
                success.users.push(row);
              }
            });
            success.major = major;
            success.id = id;
            success.count = users.length-1;
          }else{
            error.message = "Error: Participant does not exist";
            error.code = 200;
          }
          if(Object.keys(error).length){
            res.send(error);
          }else {
            res.send(success)
          }
        });
      }else if(users.length > 1){
        error.message = "Error: Database is not valid"
        error.code = 500;
        res.send(error);
      }else{
        error.message = "Error: id does not exists"
        error.code = 400;
        res.send(error);
      }
    });
  }else{
    res.send(error);
  }
});


//-----------------------------------------------------------//
//イベントの削除
//-----------------------------------------------------------//
router.delete('/remove_event', function(req, res) {
  var success = {
    id : null,
    message : null,
    code : 200
  };
  var error = {};

  var major = Number(req.body.major);

  if(!major){
    error.message = "Error: major is missing";
    error.code = 400;
    res.send(error);
    return;
  }

  dba.event_info(major, function(err1, events) {
    if(events.length == 1){
      var id = events[0].id
      dba.remove(id, function(err2) { //イベントを削除
        if(!err2){ //エラーが出なければ
          dba.get_participants(major, function(err3, users) { //削除したいイベントの参加者を取得
            if(users.length){ //参加者がいれば
              users.forEach(function(row) { //全ての参加者を
                dba.remove(row.id, function(err4) { //DBから削除
                  if(err4){ //エラーが出れば失敗
                    error.message = "Error: Participants remove failed";
                    error.code = 500;
                  }
                });
              });
              if(!Object.keys(error).length){ //エラーが出ていなければ成功
                success.id = id;
                success.message = "Event & participants remove success";
                res.send(success);
              }else{
                res.send(error);
              }
            }else{ //参加者がいなければ
              success.message = "Event remove success";
              res.send(success);
            }
          });
        }else{ //エラーが出れば
          error.message = "Error: Event remove failed";
          error.code = 500;
          res.send(error);
        }
      });
    }else if(events.length > 1){
      error.message = "Error: Database is not valid";
      error.code = 500;
    }else{
      error.message = "Error: Event does not exist";
      error.code = 500;
    }
  });
});

//-----------------------------------------------------------//
//ユーザの削除
//-----------------------------------------------------------//
router.delete('/remove_user', function(req, res) {
  var success = {
    id : null,
    message : null,
    code : 200
  };
  var error = {};

  var id = req.body.id;

  if(!id){
    error.message = "Error: id is missing";
    error.code = 400;
    res.send(error);
    return;
  }

  dba.remove(id, function(err) { //イベントを削除
    if(!err){ //エラーが出なければ
      success.id = id;
      success.message = "Event & participants remove success";
      res.send(success);
    }else{ //エラーが出れば
      error.message = "Error: Event remove failed";
      error.code = 500;
      res.send(error);
    }
  });
});


module.exports = router;
