
typedef enum {
    INFO = 1, // 👀
    SUCCESS = 2, // ✅
    FAIL = 3, // ❌
} DEBUG_STATE;

void DEBUG(DEBUG_STATE state, NSString *format, ...);
