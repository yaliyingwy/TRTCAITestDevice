
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
    CodeDetectCamera = 3001,
    CodeDetectCameraSuccess = 3002,
    CodeDetectCameraNoPermission = 3003,
    CodeDetectMicrophone = 4001,
    CodeDetectMicrophoneSuccess = 4011,
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
