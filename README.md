# maji.moe Web

Web client of [maji.moe].

## Setup

Before you start, please install [Node.js] first.

``` bash
# Install Gulp & Bower
$ npm install gulp bower -g

# Install dependencies
$ npm install
$ bower install

# Build files
$ gulp
```

## Structure

We use [React] and [Flux]. See [this post][Flux Architecture] to learn about the structure of app.

```
.
├── build // Minified files
├── coffee // CoffeeScript files
|   ├── actions
|   ├── components
|   ├── constants
|   ├── dispatchers
|   ├── stores
|   ├── utils
|   ├── app.coffee // Entry point of app
|   └── home.coffee // Entry point of home
├── public // Static files
├── styl // Stylus files
└── views // Views
```

## Gulp Tasks

- **stylus** - Compile Stylus files
- **browserify** - Browserify
- **server** - Run test server
- **watch** - Watch for changes and compile files automatically and run test server
- **minify** - Minify all files
- **build** - Compress minified files

[maji.moe]: https://maji.moe/
[Node.js]: http://nodejs.org/
[React]: http://facebook.github.io/react/
[Flux]: http://facebook.github.io/flux/
[Flux Architecture]: http://facebook.github.io/flux/docs/overview.html#content