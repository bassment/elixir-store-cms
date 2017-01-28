var CleanWebpackPlugin = require('clean-webpack-plugin');
var CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
    entry: './src/index.js',

    output: {
        path: './dist',
        filename: 'index.js'
    },

    resolve: {
        modulesDirectories: ['node_modules'],
        extensions: ['', '.js', '.elm']
    },

    module: {
        loaders: [
            {
                test: /\.html$/,
                exclude: [
                    /elm-stuff/, /node_modules/
                ],
                loader: 'file?name=[name].[ext]'
            }, {
                test: /\.elm$/,
                exclude: [
                    /elm-stuff/, /node_modules/
                ],
                loader: 'elm-hot!elm-webpack?verbose=true&warn=true'
            }, {
                test: /\.css$/,
                loaders: ['style?sourceMap', 'css?modules&importLoaders=1&localIdentName=[name]-[local]_[hash:base64:5]']
            },
            { test: /\.(png|jpg)$/, loader: 'url-loader?limit=8192' }
        ],

        noParse: /\.elm$/
    },

    plugins: [
        new CleanWebpackPlugin(['dist'], {
            root: __dirname,
            verbose: true,
            dry: false
        }),
        new CopyWebpackPlugin([
            {
                from: 'src/assets',
                to: 'assets'
            }
        ])
    ],

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
