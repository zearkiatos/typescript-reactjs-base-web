const path = require("path");
const { merge } = require("webpack-merge");
const webpackBaseConfig = require('./webpack.config.base');

module.exports = merge(webpackBaseConfig, {
  mode: "development",
  devServer: {
    static: [
      {
        directory: path.join(__dirname, "assets", "images"),
        publicPath: '/images',
      },
    ],
  },
});
