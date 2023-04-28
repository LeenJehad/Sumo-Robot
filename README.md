# Sumo-Robot

Abstract

The	 objective	 of	 this	 project	 is	 to	 design	 and	 build	 a	 robot	 that	 will	 compete	 in	 a	 sumo	 robot	
competition.	 This	 robot	 project	focuses	 on	 three	 subsystems:	 mechanical,	 electrical	 and	 software.	
This	report	deals	with	the	design	approach	and	the	problems	faced.

1. INTRODUCTION

The	goal	of	this	project	is	to	build	and	program	a	robot	that	will	compete	with	other	robots	in	a	
black	circular	playground.	The	robot	should	try	to	knock	out	its	opponent	out	of	the	playground	
while	 trying	 to	 avoid	leaving	it.	Our	 project	 focuses	 on	 the	mechanical,	 electrical	 and	 software	
part.		
The	way	our	robot	 functions	is	 that	it	 tries	 to	avoid	 the	other	opponent	and	 tries	 to	stay	inside	
the	black	playground.	While	we	had	the	option	to	build	the	robot	using	Lidar,	we	decided	to	use	
an	 infrared	 sensor	 and	 an	 ultrasonic	 sensor.	 The	 embedded	 software	 part	 of	 this	 robot	 uses	
Timers	and	 the	PWM	modulation	 technique	and	was	implemented	using	C	language.	As	 for	 the	
mechanical	 part,	 we	 ran	 our	 embedded	 software	 code	 on	 two	 different	 sumo	 robot	 bodies.	
Moreover,	we	ordered	the	parts	from	a	website	and	assembled	them	together.	
The	most	challenging	part	of	this	project	was	that	we	were	not	allowed	to	use	any	ready-to-use	
functions	from	libraries.	
2. DESIGN	APPROACH

2.1. COMPONENTS	USED

For	our	project,	we	had	to	use	the	following	components:	
- Two	Infrared	(IR)	Sensors	
- One	Ultrasonic	Sensor	
- Four	DC	Motors	
- Wires	
- One	Power-Bank	
- Two	6	volt	Batteries	
- One	Push	Button	
- One	16F877A	PIC	

2.2. DESIGN

As	 in	 any	 complex	 engineering	 project,	 the	 ^irst	 step	 was	 to	 research	 the	 kind	 of	 hardware	
components	and	software	tools	to	be	used,	how	they	can	be	acquired	and	their	costs.	
Our	 robot	 is	 autonomous	 and	 its	 dimensions	 don’t	 exceed	 20*20	 cm.	 Furthermore,	 for	 the	
mechanical	part	we	looked	at	different	kinds	of	sumo	robot	bodies.	We	used	two	different	bodies,	
the	^irst	one	had	two	wheels	/	2	DC	motors	while	the	other	one	had	four	wheels	/	4	DC	motors.	
We	ended	up	using	the	4WD	robot	body	and	glued	the	breadboard,	and	power	bank	on	top	of	it.	
However,	the	h-bridge	was	glued	inside.	Also,	we	placed	one	of	the	infrared	sensors	at	the	front	
along	with	the	ultrasonic	sensor	and	the	other	infrared	sensor	was	placed	at	the	back.	
2
Next,	for	the	electrical	part	we	had	to	connect	the	two	batteries	in	series	to	give	the	appropriate	
amount	of	voltage	in	order	 for	the	DC	Motors	to	move	at	the	desired	speed.	The	16F877A	PIC’s	
data	sheet	was	also	used	to	place	the	wires	in	the	correct	pins.	
Both	the	electrical	and	mechanical	parts	are	connected	with	the	PIC	microcontroller.	
Additionally,	in	the	embedded	software	code	we	used	PWM,	Timer0,	Timer1,	Timer2,	Interrupts,	
and	Delay.	Three	ports	were	used,	Port	B,	Port	C,	and	Port	D.	Port	B	was	used	for	the	motors	and	
IR	sensors,	Port	C	 for	PWM	and	Port	D	 for	 the	ultrasonic	sensor.	 In	addition,	delay	was	used	 to	
make	 the	 robot	 wait	 5	 seconds	 after	 pressing	 the	 push	 button.	 The	 defensive	 strategy	 we	
implemented	in	this	robot’s	code	is	that	it	will	move	inside	the	black	playground	while	avoiding	
and	running	away	from	the	opponent’s	robot.


3. PROBLEMS AND	DISCUSSIONS

We	 faced	a	lot	of	problems	while	trying	to	program	and	build	the	robot	but	we	were	able	to	 ^ix	
some	of	them.	
First	problem	we	faced	was	that	the	ultrasonic	sensor	was	stuck	in	an	in^inite	loop.	This	problem	
was	solved	after	further	studies	and	a	lot	of	testing	stages.		
Second	 problem	 was	 that	 the	 infrared	 (IR)	 sensors	 did	 not	 work	 ef^iciently	 so	 we	 had	 to	 use	
delays	to	make	them	work	better.	However,	we	would	recommend	using	better	sensors.		
The	third	problem	we	faced	happened	while	using	the	^irst	sumo	robot	body	we	bought,	the	2WD	
sumo	robot	body,	as	the	robot	kept	rotating	around	itself	because	there	was	no	balance	and	the	
components	did	not	^it	on	the	body.	We	solved	this	problem	by	buying	the	4WD	sumo	robot	body;	
we	were	able	to	^it	all	components	on	it.	
On	the	other	hand,	one	of	the	^irst	problems	we	were	not	able	to	solve	was	the	limited	body	area	
we	worked	with.	A	recommendation	would	be	to	use	thinner	wheels	to	increase	the	area	of	the	
robot.	Second	 problem	was	 having	a	 hard	 time	 ^inding	a	good	 voltage	 source	 for	 the	MCU	and	
motor,	 so	 we	 suggest	 implementing	 a	 voltage	 regulator	 to	 utilize	 the	 usage	 of	 higher	 voltage	
sources.	

4. CONCLUSION

Designing	and	building	a	sumo	robot	to	compete	with	other	sumo	robots	inside	a	playground	was	
a	 challenging	 thing	 to	 do,	 but	 we	 were	 able	 to	 build	 it	 at	 the	 end.	 Overall	 the	 project	 was	
successful;	however,	 there	are	still	many	improvements	 that	can	be	made	,	such	as	using	better	
sensors.	We	tried	to	make	use	of	all	of	the	available	resources	and	the	^inal	result	was	satisfying	
given	the	time	limit	and	our	knowledge	of	the	MCU	at	the	time.	In	the	end,	designing	and	putting	
together	the	parts	for	the	robot	was	so	fun	that	we	all	enjoyed	working	together	on	the	robot.	

