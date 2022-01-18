const ModuleScopePlugin = require('react-dev-utils/ModuleScopePlugin');
const NodePolyfillPlugin = require("node-polyfill-webpack-plugin")

module.exports = function override(config, env) {
    config.resolve.plugins = config.resolve.plugins.filter(plugin => !(plugin instanceof ModuleScopePlugin));
    config.plugins.push(new NodePolyfillPlugin({
        excludeAliases: ["console"]
      }))
    return config;
};