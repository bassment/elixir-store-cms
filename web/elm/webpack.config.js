var path = require("path");
var HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    devtool: 'eval-source-map',

    entry: {
        app: ['./src/index.js']
    },

    output: {
        path: path.resolve(__dirname + '/dist/'),
        filename: '[name].js',
        publicPath: '/'
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
                loader: 'elm-hot!elm-webpack?verbose=true&warn=true'
            }, {
                test: /\.css$/,
                loaders: ['style?sourceMap', 'css?modules&importLoaders=1&localIdentName=[name]-[local]_[hash:base64:5]']
            }, {
                test: /\.(png|jpg)$/,
                loader: 'url-loader?limit=8192'
            }, {
                test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: "url-loader?limit=10000&minetype=application/font-woff"
            }, {
                test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
                loader: "file-loader"
            }
        ]
    },

    plugins: [new HtmlWebpackPlugin({template: 'src/index.html', inject: 'body', filename: 'index.html'})],

    devServer: {
        inline: true,
        stats: {
            // Add asset Information
            assets: false,
            // Add information about cached (not built) modules
            cached: false,
            // Add children information
            children: false,
            // Add chunk information (setting this to `false` allows for a less verbose output)
            chunks: false,
            // Add errors
            errors: true,
            // Add details to errors (like resolving log)
            errorDetails: true,
            // Add the hash of the compilation
            hash: false,
            // Add built modules information
            modules: false,
            // Add public path information
            publicPath: false,
            // Add information about the reasons why modules are included
            reasons: false,
            // Add the source code of modules
            source: false,
            // Add timing information
            timings: true,
            // Add webpack version information
            version: true,
            // Add warnings
            warnings: true
        }
    }

};
