var casper = require('casper').create({
  verbose: true,
  logLevel: 'debug'
});
var fs = require('fs');
var list = fs.read('queue-pending.txt');
var names = list.split("\n");
var name = names.shift();
var download;
if(typeof(name) !== 'undefined'){
  download = 'http://earthexplorer.usgs.gov/download/4923/'+name+'/STANDARD/EE';
  casper.start(download, function() {
    this.echo(this.getTitle());
    this.fill('form[name=loginForm]', {
      'username': 'twlandsat',
      'password': 'NwdBdCMF333p',
    }, true);
  });

  casper.run();
}
