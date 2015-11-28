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
//router.post('/register_event', function(req, res) {
router.get('/register_event', function(req, res) {
  var success = {
    major : null,
    message : null,
    code : 200
  };
  var error = {};
  var id = uuid.v4();
  /*
  var en = req.body.event_name;
  var rn = req.body.room_name;
  var desc = req.body.description;
  var mand = req.body.mandatory_filed;
  */
  var en = req.param('event_name');
  var rn = req.param('room_name');
  var desc = req.param('description');
  var items = req.param('items');

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

/*
// register_eventがGETならエラー
router.get('/register_event', function(req, res) {
  var error = {};
  error.message = "Error: Cannot GET";
  error.code = 400;
  var str = JSON.stringify(error);
  res.send(str);
});
*/


// eventを得る
router.get('/get_event', function(req, res) {
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
          delete row.major;
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


module.exports = router;
