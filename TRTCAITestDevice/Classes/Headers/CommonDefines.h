
typedef NS_ENUM(NSInteger, NetworkDetectStatus) {
    Detecting,
    Poor,
    Good,
    Bad,
};

typedef NS_ENUM(NSInteger, ControlAICode) {
    CodeNone = 0,
    CodeSelectLang = 1001,
    CodeSelectLang10s = 1002,
    CodeSelectLang20s = 1003,
    CodeDetectNetwork = 2002,
    CodeDetectNetworkGood = 2003,
    CodeDetectNetworkPoor = 2004,
    CodeDetectNetworkBad = 2005,
    CodeDetectNetworkRetryFail = 2008,
    CodeDetectCamera = 3101,
    CodeDetectCameraSuccess = 3102,
    CodeDetectCameraNoPermission = 3003,
    CodeDetectMicrophone = 4101,
    CodeDetectMicrophoneSuccess = 4101,
    CodeDetectMicrophone10s = 4102,
    CodeDetectMicrophone20s = 4103,
    CodeDetectMicrophoneNoPermission = 4004,
};


typedef NS_ENUM(NSInteger, AITaskType) {
    StartAIConversation,
    UpdateAIConversation,
    ControlAIConversation,
    StopAIConversation,
};

typedef NS_ENUM(NSInteger, AIDeviceDetectType) {
    DetectLanguage,
    DetectNetwork,
    DetectMicrophone,
    DetectSpeaker,
    DetectCamera,
};


typedef NS_ENUM(NSInteger, AIDeviceDetectResult) {
    DetectResultSucc,
    DetectResultNoPermission,
};

typedef NS_ENUM(NSInteger, AIDetectPage) {
    DectectLanguagePage = 0,
    DectectNetworkPage = 1,
    DectectCameraAndMicrophonePage = 2,
    DectectSpeakerPage = 3
};

typedef NS_ENUM(NSInteger, AIStatus) {
    AIUnknown = 0,
    AIListening = 1,
    AIThinking = 2,
    AISpeaking = 3,
    AIInterrupt = 4
};


typedef NS_ENUM(NSInteger, AIMessageType) {
    AIMessageTypeText = 10000,
    AIMessageTypeStatus = 10001
};

typedef NS_ENUM(NSInteger, AICommandType) {
    AICommandTypeText = 20000,
    AICommandTypeInterrupt = 20001
};

