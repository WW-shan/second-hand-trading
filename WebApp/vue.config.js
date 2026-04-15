module.exports = {
    publicPath: './',
    assetsDir: 'static',
    productionSourceMap: false,
    chainWebpack(config) {
        ['prefetch', 'preload'].forEach(pluginName => {
            if (config.plugins.has(pluginName)) {
                config.plugins.delete(pluginName);
            }
        });
    },
    devServer: {
        port: 8081,
    },
    // devServer: {
    //     proxy: {
    //         '/api':{
    //             target:'http://jsonplaceholder.typicode.com',
    //             changeOrigin:true,
    //             pathRewrite:{
    //                 '/api':''
    //             }
    //         }
    //     }
    // }
};
