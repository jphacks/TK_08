// AirMeet - app.js

// (a)使用モジュールの読み込み
var express = require('express');
var path = require('path');
var logger = require('morgan');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var routes = require('./routes');

// (b)アプリケーションの作成
var app = express();

// (d)ミドルウェアの設定
app.use(logger('dev'));
app.use(bodyParser.urlencoded({ extended : true }));
app.use(methodOverride('_method'));
app.use('/image', express.static(__dirname + '/image'));

// (e)ルーティングの設定
app.use('/api/', routes);

// (f)リクエストの受け付け
var server = app.listen(process.env.PORT || 3000, function() {
  console.log('Listening on port %d', server.address().port);
});
