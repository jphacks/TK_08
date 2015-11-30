// MemoApp - routes\index.js

// 使用モジュールの読み込み
var express = require('express');
var uuid = require('node-uuid');
var moment = require('moment');
var dba = require('../api/dbaccess.js');
var package = require('../package.json');



// ルーターの作成
var router = express.Router();
// ルート
router.get('/', function(req, res) {
    res.send('Hello World');
});


// イベント登録
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
  if(!rn){
    error.message = "Error: room_name is missing";
    error.code = 400;
  }
  if(!items){
    error.message = "Error: items is missing";
    error.code = 400;
  }

  if(!Object.keys(error).length){
    var major = dba.gen_rand();
    console.log(major);
    var doc = {
      type : "event",
      event_name : en,
      room_name : rn,
      description : desc,
      major : major,
      items : items,
      regist_date : moment().zone('+0900').format('YYYY/MM/DD HH:mm:ss')
    };
    dba.save(id, doc, function(err) {
      if(err){
        error.message = "Error: Event registration failed";
        error.code = 500;
        var str = JSON.stringify(error);
      }else{
        success.major = major;
        success.message = "Event registration success";
        var str = JSON.stringify(success);
      }
      res.send(str);
    });
  }else{
    var str = JSON.stringify(error);
    res.send(str);
  }
});


//register_eventがGETならエラー
router.get('/register_event', function(req, res) {
  var error = {};
  error.message = "Error: Cannot GET";
  error.code = 400;
  var str = JSON.stringify(error);
  res.send(str);
});


/////
// イベント情報を取得
router.get('/event_info', function(req, res) {
  var success = {
    message : null,
    code : 200
  };
  var error = {};
  var major = String(req.param('major'));
  if(!major){
    error.message = "Error: major is missing";
    error.code = 400;
  }

  dba.get_event(function(err, events) {
    if(events.length){
      var flag = 0;
      events.forEach(function(row) {
        if(row.major == major){
          row.code = 200;
          row.items = row.items.split(',');
          res.send(row);
          flag = 1;
        }
      });
      if(flag == 0){
        error.message = "Error: Major does not match";
        error.code = 400;
      }
    }else{
      error.message = "Error: Event does not exist";
      error.code = 500;
    }
    if(Object.keys(error).length){
      var str = JSON.stringify(error);
      res.send(str);
    }
  });
});

//イベントへのユーザ登録
router.post('/register_user', function(req, res) {
  var success = {
    id : null,
    message : null,
    code : 200
  };
  var error = {};
  var id = uuid.v4();

  var major = req.body.major;
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
        var str = JSON.stringify(error);
      }else{
        success.id = id;
        success.message = "User registration success";
        var str = JSON.stringify(success);
      }
      res.send(str);
    });
  }else{
    var str = JSON.stringify(error);
    res.send(str);
  }
});


// 参加者を取得
router.get('/participants', function(req, res) {
  var success = {
    major : null,
    message : null,
    code : 200
  };
  var error = {};

  var major = req.param("major");
  var id = req.param("id");

  if(!major){
    error.message = "Error: major is missing";
    error.code = 400;
  }
  if(!id){
    error.message = "Error: id is missing";
    error.code = 400;
  }

  if(!Object.keys(error).length){
    console.log(major);
    dba.get_participants(function(err,users) {
      if(users.length){
        var flag = 0;
        var obj = {
          users : [],
          code : 200
        };
        users.forEach(function(row) {
          console.log("1"+row.major);
          if(row.major == major){
            console.log("2");
            row.code
            //row.items = row.items.split(',');
            //row.items = (new Function("return " + row.items))();
            obj.users.push(row);
            flag = 1;
          }
        });
        if(flag == 0){
          error.message = "Participant does not match";
          error.code = 200;
        }else{
          res.send(obj);
        }
      }else{
        error.message = "Participant does not exist";
        error.code = 200;
      }
      if(Object.keys(error).length){
        var str = JSON.stringify(error);
        res.send(str);
      }
    });
  }else{
    var str = JSON.stringify(error);
    res.send(str);
  }
});


module.exports = router;
