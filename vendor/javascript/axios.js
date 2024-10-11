// axios@0.21.4 downloaded from https://ga.jspm.io/npm:axios@0.21.4/index.js

import{_ as e,a as r}from"./_/17e7e1c3.js";import t from"./lib/helpers/buildURL.js";import n from"./lib/defaults.js";import o from"./lib/core/mergeConfig.js";import a from"./package.json.js";import"./_/b0f8a5eb.js";import"./lib/adapters/xhr.js";import"./lib/core/settle.js";import"./lib/helpers/cookies.js";import"./lib/core/buildFullPath.js";import"./lib/helpers/isAbsoluteURL.js";import"./lib/helpers/combineURLs.js";import"./lib/helpers/isURLSameOrigin.js";import"#lib/adapters/http.js";import"process";var s={};var i=e;function InterceptorManager$1(){this.handlers=[]}
/**
 * Add a new interceptor to the stack
 *
 * @param {Function} fulfilled The function to handle `then` for a `Promise`
 * @param {Function} rejected The function to handle `reject` for a `Promise`
 *
 * @return {Number} An ID used to remove interceptor later
 */InterceptorManager$1.prototype.use=function use(e,r,t){this.handlers.push({fulfilled:e,rejected:r,synchronous:!!t&&t.synchronous,runWhen:t?t.runWhen:null});return this.handlers.length-1};
/**
 * Remove an interceptor from the stack
 *
 * @param {Number} id The ID that was returned by `use`
 */InterceptorManager$1.prototype.eject=function eject(e){this.handlers[e]&&(this.handlers[e]=null)};
/**
 * Iterate over all the registered interceptors
 *
 * This method is particularly useful for skipping over any
 * interceptors that may have become `null` calling `eject`.
 *
 * @param {Function} fn The function to call for each interceptor
 */InterceptorManager$1.prototype.forEach=function forEach(e){i.forEach(this.handlers,(function forEachHandler(r){null!==r&&e(r)}))};s=InterceptorManager$1;var c=s;var l={};var u=e;var f=n;
/**
 * Transform the data for a request or a response
 *
 * @param {Object|String} data The data to be transformed
 * @param {Array} headers The headers for the request or response
 * @param {Array|Function} fns A single function or Array of functions
 * @returns {*} The resulting transformed data
 */l=function transformData(e,r,t){var n=this||f;u.forEach(t,(function transform(t){e=t.call(n,e,r)}));return e};var h=l;var p={};p=function isCancel(e){return!!(e&&e.__CANCEL__)};var d=p;var v={};var m=e;var b=h;var g=d;var w=n;function throwIfCancellationRequested(e){e.cancelToken&&e.cancelToken.throwIfRequested()}
/**
 * Dispatch a request to the server using the configured adapter.
 *
 * @param {object} config The config that is to be used for the request
 * @returns {Promise} The Promise to be fulfilled
 */v=function dispatchRequest(e){throwIfCancellationRequested(e);e.headers=e.headers||{};e.data=b.call(e,e.data,e.headers,e.transformRequest);e.headers=m.merge(e.headers.common||{},e.headers[e.method]||{},e.headers);m.forEach(["delete","get","head","post","put","patch","common"],(function cleanHeaderConfig(r){delete e.headers[r]}));var r=e.adapter||w.adapter;return r(e).then((function onAdapterResolution(r){throwIfCancellationRequested(e);r.data=b.call(e,r.data,r.headers,e.transformResponse);return r}),(function onAdapterRejection(r){if(!g(r)){throwIfCancellationRequested(e);r&&r.response&&(r.response.data=b.call(e,r.response.data,r.response.headers,e.transformResponse))}return Promise.reject(r)}))};var y=v;var j={};var C=a;var E={};["object","boolean","number","function","string","symbol"].forEach((function(e,r){E[e]=function validator(t){return typeof t===e||"a"+(r<1?"n ":" ")+e}}));var R={};var x=C.version.split(".");
/**
 * Compare package versions
 * @param {string} version
 * @param {string?} thanVersion
 * @returns {boolean}
 */function isOlderVersion(e,r){var t=r?r.split("."):x;var n=e.split(".");for(var o=0;o<3;o++){if(t[o]>n[o])return true;if(t[o]<n[o])return false}return false}
/**
 * Transitional option validator
 * @param {function|boolean?} validator
 * @param {string?} version
 * @param {string} message
 * @returns {function}
 */E.transitional=function transitional(e,r,t){var n=r&&isOlderVersion(r);function formatMessage(e,r){return"[Axios v"+C.version+"] Transitional option '"+e+"'"+r+(t?". "+t:"")}return function(t,o,a){if(false===e)throw new Error(formatMessage(o," has been removed in "+r));if(n&&!R[o]){R[o]=true;console.warn(formatMessage(o," has been deprecated since v"+r+" and will be removed in the near future"))}return!e||e(t,o,a)}};
/**
 * Assert object's properties type
 * @param {object} options
 * @param {object} schema
 * @param {boolean?} allowUnknown
 */function assertOptions(e,r,t){if("object"!==typeof e)throw new TypeError("options must be an object");var n=Object.keys(e);var o=n.length;while(o-- >0){var a=n[o];var s=r[a];if(s){var i=e[a];var c=void 0===i||s(i,a,e);if(true!==c)throw new TypeError("option "+a+" must be "+c)}else if(true!==t)throw Error("Unknown option "+a)}}j={isOlderVersion:isOlderVersion,assertOptions:assertOptions,validators:E};var q=j;var A={};var I=e;var $=t;var k=c;var T=y;var O=o;var _=q;var M=_.validators;
/**
 * Create a new instance of Axios
 *
 * @param {Object} instanceConfig The default config for the instance
 */function Axios$1(e){this.defaults=e;this.interceptors={request:new k,response:new k}}
/**
 * Dispatch a request
 *
 * @param {Object} config The config specific for this request (merged with this.defaults)
 */Axios$1.prototype.request=function request(e){if("string"===typeof e){e=arguments[1]||{};e.url=arguments[0]}else e=e||{};e=O(this.defaults,e);e.method?e.method=e.method.toLowerCase():this.defaults.method?e.method=this.defaults.method.toLowerCase():e.method="get";var r=e.transitional;void 0!==r&&_.assertOptions(r,{silentJSONParsing:M.transitional(M.boolean,"1.0.0"),forcedJSONParsing:M.transitional(M.boolean,"1.0.0"),clarifyTimeoutError:M.transitional(M.boolean,"1.0.0")},false);var t=[];var n=true;this.interceptors.request.forEach((function unshiftRequestInterceptors(r){if("function"!==typeof r.runWhen||false!==r.runWhen(e)){n=n&&r.synchronous;t.unshift(r.fulfilled,r.rejected)}}));var o=[];this.interceptors.response.forEach((function pushResponseInterceptors(e){o.push(e.fulfilled,e.rejected)}));var a;if(!n){var s=[T,void 0];Array.prototype.unshift.apply(s,t);s=s.concat(o);a=Promise.resolve(e);while(s.length)a=a.then(s.shift(),s.shift());return a}var i=e;while(t.length){var c=t.shift();var l=t.shift();try{i=c(i)}catch(e){l(e);break}}try{a=T(i)}catch(e){return Promise.reject(e)}while(o.length)a=a.then(o.shift(),o.shift());return a};Axios$1.prototype.getUri=function getUri(e){e=O(this.defaults,e);return $(e.url,e.params,e.paramsSerializer).replace(/^\?/,"")};I.forEach(["delete","get","head","options"],(function forEachMethodNoData(e){Axios$1.prototype[e]=function(r,t){return this.request(O(t||{},{method:e,url:r,data:(t||{}).data}))}}));I.forEach(["post","put","patch"],(function forEachMethodWithData(e){Axios$1.prototype[e]=function(r,t,n){return this.request(O(n||{},{method:e,url:r,data:t}))}}));A=Axios$1;var L=A;var P={};
/**
 * A `Cancel` is an object that is thrown when an operation is canceled.
 *
 * @class
 * @param {string=} message The message.
 */function Cancel$1(e){this.message=e}Cancel$1.prototype.toString=function toString(){return"Cancel"+(this.message?": "+this.message:"")};Cancel$1.prototype.__CANCEL__=true;P=Cancel$1;var U=P;var S={};var N=U;
/**
 * A `CancelToken` is an object that can be used to request cancellation of an operation.
 *
 * @class
 * @param {Function} executor The executor function.
 */function CancelToken(e){if("function"!==typeof e)throw new TypeError("executor must be a function.");var r;this.promise=new Promise((function promiseExecutor(e){r=e}));var t=this;e((function cancel(e){if(!t.reason){t.reason=new N(e);r(t.reason)}}))}CancelToken.prototype.throwIfRequested=function throwIfRequested(){if(this.reason)throw this.reason};CancelToken.source=function source(){var e;var r=new CancelToken((function executor(r){e=r}));return{token:r,cancel:e}};S=CancelToken;var W=S;var V={};
/**
 * Syntactic sugar for invoking a function and expanding an array for arguments.
 *
 * Common use case would be to use `Function.prototype.apply`.
 *
 *  ```js
 *  function f(x, y, z) {}
 *  var args = [1, 2, 3];
 *  f.apply(null, args);
 *  ```
 *
 * With `spread` this example can be re-written.
 *
 *  ```js
 *  spread(function(x, y, z) {})([1, 2, 3]);
 *  ```
 *
 * @param {Function} callback
 * @returns {Function}
 */V=function spread(e){return function wrap(r){return e.apply(null,r)}};var D=V;var H={};
/**
 * Determines whether the payload is an error thrown by Axios
 *
 * @param {*} payload The value to test
 * @returns {boolean} True if the payload is an error thrown by Axios, otherwise false
 */H=function isAxiosError(e){return"object"===typeof e&&true===e.isAxiosError};var J=H;var z={};var F=e;var B=r;var G=L;var K=o;var Q=n;
/**
 * Create an instance of Axios
 *
 * @param {Object} defaultConfig The default config for the instance
 * @return {Axios} A new instance of Axios
 */function createInstance(e){var r=new G(e);var t=B(G.prototype.request,r);F.extend(t,G.prototype,r);F.extend(t,r);return t}var X=createInstance(Q);X.Axios=G;X.create=function create(e){return createInstance(K(X.defaults,e))};X.Cancel=U;X.CancelToken=W;X.isCancel=d;X.all=function all(e){return Promise.all(e)};X.spread=D;X.isAxiosError=J;z=X;z.default=X;var Y=z;export{Y as default};

