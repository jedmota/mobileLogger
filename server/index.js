var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var port = process.env.PORT || 3000;
var bonjour = require('bonjour')();

// advertise an HTTP server on port 3000
bonjour.publish({ name: 'My Socket io Server', type: 'socket_io', port: port, protocol: 'tcp' });

// // browse for all http services
// bonjour.find({ type: 'socket_io', protocol: 'tcp' }, function (service) {
//   console.log('Found an HTTP server:', service);
// });

app.get('/', function(req, res){
  res.sendFile(__dirname + '/html/logs.html');
});

io.on('connection', function(socket){
  console.log('New client');
  socket.on('register', function(deviceId) {
  	console.log('registering: ' + deviceId + ' running on http://localhost:' + port + '/?deviceId=' + deviceId)
	  socket.on(deviceId, function(msg) {
	  	// console.log('Sending to: ' + deviceId + " > " + msg);
	    io.emit(deviceId, msg);
	  });
    socket.on('disconnect', function () {
      console.log('Client disconnected ' + deviceId);
    });
  });
  socket.on('chat message', function(msg){
  	console.log('Sending message...');
    io.emit('chat message', msg);
  });
});

http.listen(port, function(){
  console.log('listening on *:' + port);
});
