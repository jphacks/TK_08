// AirMeet – api/dbacess.js

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


// Majorの値と一致するイベントを取得
exports.get_event = function(major,callback) {
  //db.view('events/get_info', callback);
  console.log("1 "+major);
  db.get('あいう', callback);
};

// 現在登録されているイベントのMajorとは異なる乱数を生成
exports.gen_rand = function(){
  var flag = 1;
  while(flag == 1){
    flag = 0;
    var rand = Math.floor( Math.random() * 65535 );
    db.view('events/major',function(err, res) {
      res.forEach(function(row) {
        if(row.major == rand){
          flag = 1;
        }
      });
    });
  }
  return rand;
};

// Majorの値と一致するイベントの参加者を取得
exports.get_participants = function(callback) {
  db.view('users/get_participants', callback);
};
