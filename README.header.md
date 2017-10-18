# aPocket Library

The *official* client library for [apocket-api] (https://github.com/arisebank/apocket-api).

## Description

This package communicates with APWS [aPocket API](https://github.com/arisebank/apocket-api) using the REST API. All REST endpoints are wrapped as simple async methods. All relevant responses from APWS are checked independently by the peers, thus the importance of using this library when talking to a third party APWS instance.

See [aPocket-CLI] (https://github.com/arisebank/apocket-cli) for a simple CLI wallet implementation that relays on APWS and uses apocket-lib.

## Get Started

You can start using apocket-lib in any of these two ways:

* via [Bower](http://bower.io/): by running `bower install apocket-lib` from your console
* or via [NPM](https://www.npmjs.com/package/apocket-lib): by running `npm install apocket-lib` from your console.

## Example

Start your own local [aPocket API](https://github.com/arisebank/apocket-api) instance. In this example we assume you have `apocket-api` running on your `localhost:3232`.

Then create two files `irene.js` and `tomas.js` with the content below:

**irene.js**

``` javascript
var Client = require('apocket-lib');


var fs = require('fs');
var APWS_INSTANCE_URL = 'https://apocket.network/apws/api'

var client = new Client({
  baseUrl: APWS_INSTANCE_URL,
  verbose: false,
});

client.createWallet("My Wallet", "Irene", 2, 2, {network: 'testnet'}, function(err, secret) {
  if (err) {
    console.log('error: ',err);
    return
  };
  // Handle err
  console.log('Wallet Created. Share this secret with your pocketeers: ' + secret);
  fs.writeFileSync('irene.dat', client.export());
});
```

**tomas.js**

``` javascript

var Client = require('apocket-lib');


var fs = require('fs');
var APWS_INSTANCE_URL = 'https://apocket.network/apws/api'

var secret = process.argv[2];
if (!secret) {
  console.log('./tomas.js <Secret>')

  process.exit(0);
}

var client = new Client({
  baseUrl: APWS_INSTANCE_URL,
  verbose: false,
});

client.joinWallet(secret, "Tomas", {}, function(err, wallet) {
  if (err) {
    console.log('error: ', err);
    return
  };

  console.log('Joined ' + wallet.name + '!');
  fs.writeFileSync('tomas.dat', client.export());


  client.openWallet(function(err, ret) {
    if (err) {
      console.log('error: ', err);
      return
    };
    console.log('\n\n** Wallet Info', ret); //TODO

    console.log('\n\nCreating first address:', ret); //TODO
    if (ret.wallet.status == 'complete') {
      client.createAddress({}, function(err,addr){
        if (err) {
          console.log('error: ', err);
          return;
        };

        console.log('\nReturn:', addr)
      });
    }
  });
});
```

Install `apocket-lib` before start:

```
npm i apocket-lib
```

Create a new wallet with the first script:

```
$ node irene.js
info Generating new keys
 Wallet Created. Share this secret with your pocketeers: JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
```

Join to this wallet with generated secret:

```
$ node tomas.js JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
Joined My Wallet!

Wallet Info: [...]

Creating first address:

Return: [...]

```

Note that the scripts created two files named `irene.dat` and `tomas.dat`. With these files you can get status, generate addresses, create proposals, sign transactions, etc.
