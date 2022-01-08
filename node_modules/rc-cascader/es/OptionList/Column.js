import _defineProperty from "@babel/runtime/helpers/esm/defineProperty";
import _toConsumableArray from "@babel/runtime/helpers/esm/toConsumableArray";
import * as React from 'react';
import classNames from 'classnames';
import { isLeaf, toPathKey } from '../utils/commonUtil';
import CascaderContext from '../context';
import Checkbox from './Checkbox';
import { SEARCH_MARK } from '../hooks/useSearchOptions';
export default function Column(_ref) {
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

  var _React$useContext = React.useContext(CascaderContext),
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
    var searchOptions = option[SEARCH_MARK];
    var label = option[fieldNames.label];
    var value = option[fieldNames.value];
    var isMergedLeaf = isLeaf(option, fieldNames); // Get real value of option. Search option is different way.

    var fullPath = searchOptions ? searchOptions.map(function (opt) {
      return opt[fieldNames.value];
    }) : [].concat(_toConsumableArray(prevValuePath), [value]);
    var fullPathKey = toPathKey(fullPath);
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
      className: classNames(menuItemPrefixCls, (_classNames = {}, _defineProperty(_classNames, "".concat(menuItemPrefixCls, "-expand"), !isMergedLeaf), _defineProperty(_classNames, "".concat(menuItemPrefixCls, "-active"), activeValue === value), _defineProperty(_classNames, "".concat(menuItemPrefixCls, "-disabled"), disabled), _defineProperty(_classNames, "".concat(menuItemPrefixCls, "-loading"), isLoading), _classNames)),
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
    }, multiple && /*#__PURE__*/React.createElement(Checkbox, {
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