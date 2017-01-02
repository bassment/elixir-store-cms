var path = require("path");
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    entry: {
        app: ['./src/index.js']
    },

    output: {
        path: path.resolve(__dirname + '/dist'),
        filename: '[name].js'
    },

    resolve: {
        extensions: ['', '.js', '.elm']
    },

    module: {
        noParse: /\.elm$/,

        loaders: [
            {
                test: /\.elm$/,
                exclude: [
                    /elm-stuff/, /node_modules/
                ],
                loader: 'elm-hot!elm-webpack?verbose=true&warn=true&debug=true'
            }, {
                test: /\.(css|scss)$/,
                loaders: ['style-loader', 'css-loader']
            }, {
                test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: 'url-loader?limit=10000&mimetype=application/font-woff'
            }, {
                test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: 'file-loader'
            }
        ]
    },

    plugins: [new HtmlWebpackPlugin({template: 'src/index.html', inject: 'body', filename: 'index.html'})],

    devServer: {
        inline: true,
        stats: {
            colors: true,
            hash: false,
            timings: true,
            chunks: false,
            chunkModules: false,
            modules: false
        }
    }

};
