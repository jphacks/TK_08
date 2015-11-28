// MemoApp - routes\index.js

// (a)使用モジュールの読み込み
var express = require('express');
var uuid = require('node-uuid');
var moment = require('moment');
var api = require('../api/api.js');
var package = require('../package.json');

var success = {
  message : null,
  code : 200
};
var error = {};

// (b)ルーターの作成
var router = express.Router();

// (1)メモ一覧の表示(ページ表示)
router.get('/', function(req, res) {
    res.send('Hello World');
});

// (2)イベント登録(ダイアログ表示)
router.post('/event_regist', function(req, res) {
  var id = uuid.v4();
  var en = req.body.event_name;
  var rn = req.body.room_name;
  var desc = req.body.description;
  var mand = req.body.mandatory_filed;
  var major = req.body.major;
  if(!en){
    error.message = "Error: event_name is missing";
    error.code = 400;
  }
  if(!rn){
    error.message = "Error: room_name is missing";
    error.code = 400;
  }
  /*if(!mand){
    error.message = "Error: mandatory_filed is missing";
    error.code = 400;
  }*/

  if(!Object.keys(error).length){
    var doc = {
      type : "event",
      event_name : en,
      room_name : rn,
      description : desc,
      major : major,
      regist_date : moment().zone('+0900').format('YYYY/MM/DD HH:mm:ss')
    };
    api.save(id, doc, function(err) {
      if(err){
        error.message = "Error: Event registration failed";
        error.code = 500;
        var str = JSON.stringify(error);
      }else{
        success.message = "Event registration success"
        var str = JSON.stringify(success);
      }
      res.send(str);
    });
  }else{
    var str = JSON.stringify(error);
    res.send(str);
  }
});

// event_registがGETならエラー
router.get('/event_regist', function(req, res) {
  error.message = "Error: Cannot GET";
  error.code = 400;
  var str = JSON.stringify(error);
  res.send(str);
});


// eventを得る
router.get('/get_event', function(req, res) {
  var major = String(req.param('major'));
  if(!major){
    error.message = "Error: major is missing";
    error.code = 400;
  }

  api.get_event(function(err, events) {
    events.forEach(function(row) {
      if(row.major == major){
        console.log(row);
        res.send(row);
      }
    });
  });
});

// (6)既存メモの削除
router.delete('/memos/:id([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})', function(req, res) {
  var id = req.param('id');

  memo.remove(id, function(err) {
    res.redirect('/');
  });
});

module.exports = router;
