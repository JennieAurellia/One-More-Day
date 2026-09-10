extends ScrollContainer
class_name ChatLog
## Storing premade chat logs for phone, not an active script.

static var log_array : Array[Dictionary] = [
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"08:48",},

	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"We're still going today, right? Don't forget.",},

	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Of course! I'm getting ready right now.",},

	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Okay, see you later! ",},

	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"20:32",},

	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"You home?",},

	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Yeah, just got home.",},

	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Good. You sounded tired earlier. Make sure you get some rest, okay?",},

	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Haha, I will. You worry too much.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"I can't help worrying about you.",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"16 May 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"09:27",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Morning! Did you sleep well?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Yeah, I did. How about you?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Pretty well! What are you up to today?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Not much. Just staying home for a while.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Sounds nice. Make sure you take it easy, okay?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Haha, I will. You too!",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Did you eat yet?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Not yet. Adrian's making something.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Wow, look at him being useful, hahaha.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Hey! He's actually a good cook.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Okay, okay, I'll give him that.",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"22 May 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"12:02",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Are you going out with Adrian again tomorrow?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Yeah, why?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Nothing. Just thought I'd get to see you for once.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"We can hang out another day.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"You always say that.",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"3 June 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"10:16",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Hey, are you free today?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Hmm, why?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"I was thinking... wanna go out today? Just the two of us.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Today? Sure! Where do you wanna go?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"I don't know yet 😂 We'll figure it out when we meet.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Haha, okay. What time?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"How about 2 PM?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Sounds good! See you then!",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"21:05",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Hey, did you like the plushie I gave you today?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"I love it! It's so cute 🥹",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Really? I'm glad. I wasn't sure if you'd like it.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Of course I do! I'll keep it on my bed.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Good. I thought you'd like it. ❤️",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Thank you, Maya. I had a lot of fun today too!",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Anything for you, Elena. ❤️",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"11 June 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"09:47",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"You going out today?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Probably with Adrian.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Again?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"What do you mean, again? 😂",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Nothing. Forget it.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Okay, how about we go out the day after tomorrow?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Really? I'm in!",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"It's been a while since we hung out, just the two of us.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Yeah... I'd like that. ❤️",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"13 June 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"07:23",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Maya... sorry, I can't meet today. Adrian and I already made plans.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"You cancelled again?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"I'm so sorry 😭 Adrian wanted to spend the day together.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"You always choose him.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Maya...",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"I'm joking. Sorry. I just miss you, that's all.",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"25 June 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"15:42",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Adrian's working from home today, isn't he?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Yeah... how did you know?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"You two are usually together on days like this, aren't you?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Well... I guess so.",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"10 July 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"18:20",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"You haven't been going out much lately, right?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Not really. Why?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Just wondering. I worry about you sometimes.",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"19 July 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"19:49",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"I miss the old days. Just you and me.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"We still hang out all the time.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Not like we used to.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"What do you mean?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"We used to do everything together. Late-night talks, random trips, staying up way too late...",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Haha, yeah. Those were fun times.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"I just miss having you all to myself sometimes.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Aww, Maya. I'm still here, you know? 😂",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"I know. I just miss you, that's all.",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"23 July 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"14:26",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"I found some old picture of you today.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Oh my god, where did you get that?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"You don't remember?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"No... I don't think I've ever seen that one.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Will, I have. I keep all my favorite pictures of you.",},
	
	{"type":ChatLogDisplay.ChatType.DATE,
	"content":"24 July 2020",},
	
	{"type":ChatLogDisplay.ChatType.TIME,
	"content":"17:08",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"Can I see you tomorrow? Just the two of us.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Sure. What time?",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"other",
	"content":"I'll call you tomorrow morning.",},
	
	{"type":ChatLogDisplay.ChatType.MESSAGE,
	"name":"self",
	"content":"Okay, then.",},
]
