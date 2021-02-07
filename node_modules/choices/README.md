# Choices

Choices is an API for prompting the user with multiple-choices.

Choices are displayed in a numbered list, user is prompted with a message and
options repeatedly until they make a choice or cancel (q, esc, ctrl+c).

If the user cancels, your callback will receive null as the option index.

## Install
npm install choices

## Example
```javascript
var choices = require('choices');
var options = ['First Option', 'Second option', 'Third option'];
choices('Pick an option', options, function(idx) {
  console.log('You picked ' + options[idx]);
});
```

```text
  [1]: First option
  [2]: Second option
  [3]: Third option
Pick an option>> 2
You picked Second option
```