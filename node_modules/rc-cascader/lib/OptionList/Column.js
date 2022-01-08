"use strict";

var _interopRequireWildcard = require("@babel/runtime/helpers/interopRequireWildcard");

var _interopRequireDefault = require("@babel/runtime/helpers/interopRequireDefault");

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = Column;

var _defineProperty2 = _interopRequireDefault(require("@babel/runtime/helpers/defineProperty"));

var _toConsumableArray2 = _interopRequireDefault(require("@babel/runtime/helpers/toConsumableArray"));

var React = _interopRequireWildcard(require("react"));

var _classnames = _interopRequireDefault(require("classnames"));

var _commonUtil = require("../utils/commonUtil");

var _context = _interopRequireDefault(require("../context"));

var _Checkbox = _interopRequireDefault(require("./Checkbox"));

var _useSearchOptions = require("../hooks/useSearchOptions");

function Column(_ref) {
  var prefixCls = _ref.prefixCls,
      multiple = _ref.multiple,
      options = _ref.options,
      activeValue = _ref.activeValue,
      prevValuePath = _ref.prevValuePath,
      onToggleOpen = _ref.onToggleOpen,
      onSelect = _ref.onSelect,
      onActive = _ref.onActive,
      checkedSet = _ref.checkedSet,
      halfCheckedSet = _ref.halfCheckedSet,
      loadingKeys = _ref.loadingKeys,
      isSelectable = _ref.isSelectable;
  var menuPrefixCls = "".concat(prefixCls, "-menu");
  var menuItemPrefixCls = "".concat(prefixCls, "-menu-item");

  var _React$useContext = React.useContext(_context.default),
      fieldNames = _React$useContext.fieldNames,
      changeOnSelect = _React$useContext.changeOnSelect,
      expandTrigger = _React$useContext.expandTrigger,
      expandIcon = _React$useContext.expandIcon,
      loadingIcon = _React$useContext.loadingIcon,
      dropdownMenuColumnStyle = _React$useContext.dropdownMenuColumnStyle;

  var hoverOpen = expandTrigger === 'hover'; // ============================ Render ============================

  return /*#__PURE__*/React.createElement("ul", {
    className: menuPrefixCls,
    role: "menu"
  }, options.map(function (option) {
    var _classNames;

    var disabled = option.disabled;
    var searchOptions = option[_useSearchOptions.SEARCH_MARK];
    var label = option[fieldNames.label];
    var value = option[fieldNames.value];
    var isMergedLeaf = (0, _commonUtil.isLeaf)(option, fieldNames); // Get real value of option. Search option is different way.

    var fullPath = searchOptions ? searchOptions.map(function (opt) {
      return opt[fieldNames.value];
    }) : [].concat((0, _toConsumableArray2.default)(prevValuePath), [value]);
    var fullPathKey = (0, _commonUtil.toPathKey)(fullPath);
    var isLoading = loadingKeys.includes(fullPathKey); // >>>>> checked

    var checked = checkedSet.has(fullPathKey); // >>>>> halfChecked

    var halfChecked = halfCheckedSet.has(fullPathKey); // >>>>> Open

    var triggerOpenPath = function triggerOpenPath() {
      if (!disabled && (!hoverOpen || !isMergedLeaf)) {
        onActive(fullPath);
      }
    }; // >>>>> Selection


    var triggerSelect = function triggerSelect() {
      if (isSelectable(option)) {
        onSelect(fullPath, isMergedLeaf);
      }
    }; // >>>>> Title


    var title;

    if (typeof option.title === 'string') {
      title = option.title;
    } else if (typeof label === 'string') {
      title = label;
    } // >>>>> Render


    return /*#__PURE__*/React.createElement("li", {
      key: fullPathKey,
      className: (0, _classnames.default)(menuItemPrefixCls, (_classNames = {}, (0, _defineProperty2.default)(_classNames, "".concat(menuItemPrefixCls, "-expand"), !isMergedLeaf), (0, _defineProperty2.default)(_classNames, "".concat(menuItemPrefixCls, "-active"), activeValue === value), (0, _defineProperty2.default)(_classNames, "".concat(menuItemPrefixCls, "-disabled"), disabled), (0, _defineProperty2.default)(_classNames, "".concat(menuItemPrefixCls, "-loading"), isLoading), _classNames)),
      style: dropdownMenuColumnStyle,
      role: "menuitemcheckbox",
      title: title,
      "aria-checked": checked,
      "data-path-key": fullPathKey,
      onClick: function onClick() {
        triggerOpenPath();

        if (!multiple || isMergedLeaf) {
          triggerSelect();
        }
      },
      onDoubleClick: function onDoubleClick() {
        if (changeOnSelect) {
          onToggleOpen(false);
        }
      },
      onMouseEnter: function onMouseEnter() {
        if (hoverOpen) {
          triggerOpenPath();
        }
      }
    }, multiple && /*#__PURE__*/React.createElement(_Checkbox.default, {
      prefixCls: "".concat(prefixCls, "-checkbox"),
      checked: checked,
      halfChecked: halfChecked,
      disabled: disabled,
      onClick: function onClick(e) {
        e.stopPropagation();
        triggerSelect();
      }
    }), /*#__PURE__*/React.createElement("div", {
      className: "".concat(menuItemPrefixCls, "-content")
    }, option[fieldNames.label]), !isLoading && expandIcon && !isMergedLeaf && /*#__PURE__*/React.createElement("div", {
      className: "".concat(menuItemPrefixCls, "-expand-icon")
    }, expandIcon), isLoading && loadingIcon && /*#__PURE__*/React.createElement("div", {
      className: "".concat(menuItemPrefixCls, "-loading-icon")
    }, loadingIcon));
  }));
}