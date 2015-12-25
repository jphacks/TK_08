// AirMeet – model/db.js

// 使用モジュールの読み込み
var cradle = require('cradle');

// Cloudant接続情報の取得
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

// データベースとの接続
var db = new (cradle.Connection)(host, port, options).database('airmeet_test');

// ドキュメントの登録
exports.save = function(id, doc, callback) {
  db.save(id, doc, callback);
};

// ドキュメントの削除
exports.remove = function(id, callback) {
  db.remove(id, callback);
};

// Majorの値と一致するイベントを取得
exports.event_info = function(major, callback) {
  db.view('events/event_info', {key: major}, callback);
};


// 現在登録されているイベントのMajorとは異なる乱数を生成
exports.gen_major = function(callback){
  db.view('events/major', function(err, res){
    var flag = 1;
    while(flag != 0){
      flag = 0;
      var rand = Math.floor( Math.random() * 65535 );
      res.forEach(function(row) {
        if(rand == row.key){
          flag = 1;
        }
      });
    }
    callback(rand);
  });
};


// Majorの値と一致するイベントの参加者を取得
exports.get_participants = function(major, callback) {
  db.view('users/participants', {key: major}, callback);
};

// Majorの値と一致するイベントの参加者数を取得
exports.participants_count = function(major, callback) {
  db.view('users/participants_count', {group: true, key: major}, callback);
};

exports.confirm_userid = function(id, major, callback) {
  db.view('users/id', {key: id, value: major}, callback);
};
