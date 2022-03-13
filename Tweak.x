#include "Snapchat/Include/jb-bypass.h"
#include "Snapchat/Include/showSettings.h"
#include "Snapchat/Include/SaveMedia.h"
#include "Snapchat/Include/welcome.h"
#include "Snapchat/Include/Extra.h"

#include <SMHookMemory.h>




%ctor{	

	DEBUG(INFO, @"SVC 80 scanner running slide: 0x%llx", image_slide("Snapchat"));
	load_welcome_check(" This is causing ban 😁 ");
	
	bypass_jailbreak_detection(); // Not 100% ready
	
	show_settings_button();
	
	enable_media_save();
	enable_media_loop();
	enable_no_screenshot();
	enable_no_read_receipt();
	enable_stop_typing_status();
}
