# Animated Chat Action Button

Add a cool animated whatsapp like audio recording button to your app 

## Installation

First add `animated_chat_action_button` to your pubsbec.yaml file:

```yml
dependencies:
  animated_chat_action_button: <latest-version>
```

## How to Use

All you need to do is importing the package and use widget normaly:

```dart
AnimatedChatActionButton(
  onHold: (){
    //Start recording audio
  },
  onHoldEnd: (){
    ///Stop recording the audio
  },
)
```

## TODO

-   Support widget as icon
-   Make size adjustable