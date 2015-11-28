// MemoApp – api/api.js

// (a)使用モジュールの読み込み
var cradle = require('cradle');

// (b)Cloudant接続情報の取得
if (typeof process.env.VCAP_SERVICES === 'undefined') {
    var services = require('../config/VCAP_SERVICES.json');
} else {
    services = JSON.parse(process.env.VCAP_SERVICES)
};
var credentials = services['cloudantNoSQLDB'][0].credentials;
var host = credentials.host;
var port = credentials.port;
var options = {
  cache : true,
  raw : false,
  secure : true,
  auth : {
    username : credentials.username,
    password : credentials.password
  }
};

// (c)データを保持するデータベース
var db = new (cradle.Connection)(host, port, options).database('airmeet_test');

// (1)メモ一覧の取得
exports.list = function(callback) {
  db.view('memos/list', { descending : true }, callback);
};

// (2)メモの取得
exports.get = function(id, callback) {
  db.get(id, callback);
};

// ドキュメントの登録
exports.save = function(id, doc, callback) {
  db.save(id, doc, callback);
};

// (4)メモの削除
exports.remove = function(id, callback) {
  db.remove(id, callback);
};

// (2)メモの取得
exports.get = function(id, callback) {
  db.get(id, callback);
};

// Majorの値と一致するイベントを取得
exports.get_event = function(callback) {
  db.view('events/major', callback);
};

/*
exports.get_event = function(major, callback) {
  console.log(major);
  db.view('events/major',major, function (err, res) {
    console.log(res);
    res.forEach(function (row) {
      console.log("en: %s  desc: %s", row.event_name, row.description);
    });
  });
};*/
