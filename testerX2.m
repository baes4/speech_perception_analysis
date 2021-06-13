%formatted for running multiple large data sets

clc;

% Fig5TopCIHAsentences = {'The bathtub is pink', 'Which is new', 'How much is four and five?', 'How many cars have you', 'Father has brown shoes', 'I ride the bus', 'The sun is shining', 'I want some grape juice', 'The farmer has a beehive', 'I will have hot tea with lemon', 'There is a verb in every sentence', 'Put the match in the ashtray', 'The matchbox is on the table', 'The windshield is dirty', 'Did you hear the bell?', 'The price of the house is too high.', 'The cowboy wore a large hat', 'Mother fell down the steps', 'Do you shop downtown?', 'This book is useful', 'Have you read the newspaper?', 'I heard a loud noise', 'I don''t know when I will get back', 'Did you hear the whistle', 'I am going to the store', 'I will leave the book for you to read', 'Please save the morning paper for me', 'I like to dance the jig', 'It''s fun to work on a jigsaw puzzle', 'Thanksgiving comes on Thursday'};
% Fig5TopCIHAguesses = {'The bathtub is pink', 'The is new', 'I love this ball and sky', 'How many cars have you', 'Father has brown shoes', 'I ride the bike', 'The sun is shining', 'I washed some grape seeds', 'The tamer has a beehive', 'I will have that with lemon', 'Every verb begins with a sentence', 'Put the match in the basket', 'The matchbox is on the table', 'The windshield is broken', 'The jew are home', 'The price of the house is too high.', 'The cowboy wore a large hat', 'Mother fell down the steps', 'The new shop''s downtown', 'Which book is little?', 'Have you read the newspaper', 'I heard a loud noise', 'I don''t know how we will get back', 'Did you hear the whistle', 'I am going to the store', 'I will leave the book in the', 'Please save the morning paper for me', 'I like to get the children', 'The sun direct is a jigsaw puzzle', 'The milkman comes on Thursday'};
% 
% Fig5MidCIsentences = {'The girl cried', 'Where is the car', 'How many tables have you', 'My watch is slow', 'Where is the stop sign', 'Did you play football at school?', 'Put some wood on the fire', 'When will the boat sail?', 'Leave everything as it is', 'What is a verb?', 'Do you see the searchlight?', 'Your black hat is very becoming', 'The dish is broken', 'The price of the house is too high', 'The mountain is very high', 'The house has a side porch', 'A cube has six sides', 'Father employs four men', 'Do you hear better through the loudspeaker or headphones?', 'I don''t know when I will get back', 'Breakfast is my favorite meal', 'Do you like oatmeal?', 'The mailman is late this morning', 'I am very well, thank you', 'I thought I heard a noise', 'Both of us will go', 'Were you at home last night', 'I live near you', 'We went to a nearby restaurant', 'She changed my mind about the show'};
% Fig5MidCIguesses = {'The door is gray', 'Where is the car', 'How many tables have you', 'My watch is slow', 'Where is the stop sign', 'Did you place the ball next door', 'Put some wood on the fire', 'When will the', 'Leave everything as it is', 'Wood is a herb', 'He eats at first light', 'Both hats very cunning', 'The beach is broken', 'The price of the house is too high', 'The mountains are very high', 'The house has a side porch', 'The books have been searched', 'Father is a tight foreman', 'Eat your dessert for the last people will have some', 'I don''t know how we will get back', 'is my favorite meal', 'Did you like your meal', 'The mailman is late this morning', 'I haven''t thanked you', 'I thought I heard a noise', 'Both of us will go', 'Were you at home last night', 'I will mail you', 'We went to the new restaurant', 'noise'};
% 
% Fig5BotHAsentences = {'I throw the ball', 'Where are the flowers?', 'My watch is slow', 'Father is in the car', 'I always use a cookbook', 'The moonlight is beautiful', 'The moonlight is bright', 'We have a sailboat', 'The farmer has a beehive', 'We live on the Earth', 'Where are your friends?', 'I value your friendship', 'The price of the house is too high', 'This cord is of no use', 'I heard the news on the radio', 'The boys are playing ball', 'Please buy a mousetrap', 'There is a radio in the schoolroom', 'There is a radio in the schoolroom', 'This row is reserved', 'There is no view from my window', 'I like the taste of ginger', 'Do you remember the story about the gingerbread boy?', 'I thought it was four o''clock', 'Were you at home last night?', 'The sun was shining', 'There is a beautiful sunset', 'It is hot this afternoon', 'Will you sew a button on my shirt?', 'Is she your teacher?'};
% Fig5BotHAguesses = {'I cursed the long ball', 'Where are the', 'I mowed the lawn', 'Everything in the car', 'I already knew', 'The view is beautiful', 'The meal is', 'He wrote a novel', 'The mother had a lamb', 'These are your books', 'Father is Irish', 'How long was your sun sick', 'The mouth of the hose is brown', 'It''s cold all week', 'I host the meals on days', 'The boys are coming home', 'Kim''s father is Tom', 'Please will you leave in the storeroom', '', 'I heard you name', 'What is your', 'How old are the children', '', 'How', 'longer', 'What time is the film', 'Now is the painting', 'It is good at the time', '', 'same'};
% 
% Fig6Topset4AMsentences = {'The airplane is yellow', 'There is a rose on the bush', 'Put some wood on the fire', 'The sailboat is white', 'Can you hear the bee buzzing?', 'The farmer has a beehive', 'Who is that man?', 'Go to the head of the line', 'I like whole wheat bread', 'The sign said stop', 'It is cold outside', 'That is a pretty tune', 'How many men does your father employ?', 'When will you plow the land?', 'Why did you call me?', 'Which play shall we see?', 'Can you run this machine?', 'I will be a few minutes late', 'The young man is very tall', 'I try to save some money every month', 'The jack knife has a sharp blade', 'The jig is an old-fashioned dance', 'June is a summer month', 'Jack up the car', 'I thought I heard a noise', 'It is wise to think first and then speak', 'The sun is hot today', 'The boys were busy as bees', 'The dish is broken', 'Good morning'};
% Fig6Topset4AMguesses = {'The airplane is yellow', 'There is a rose on the bush', 'Put some wood on the fire', 'The sailboat is white', 'Can you hear the bee buzzing?', 'The farmer has a beehive', 'Who is that man?', 'Go to the head of the line', 'I like whole wheat bread', 'The sign says stop', 'It is cold outside', 'That is a pretty tune', 'How many men does your father employ?', 'When will you plow the land?', 'Why did you call me?', 'Which play shall we see?', 'Can you run this machine?', 'I will be a few minutes late', 'The young man is very tall', 'I''m trying to save some money every month', 'The jack knife has a sharp blade', 'The jig is an old-fashioned dance', 'June is a summer month', 'Jack up the car', 'I thought I heard a noise', 'It is wise to think first and then speak', 'The sun is hot today', 'The boys were busy as bees', 'The dish is broken', 'Good morning'};
% 
% Fig6Botset5AMsentences = {'The rose bush needs to be sprayed', 'I woke up at daybreak', 'The milkman is late today', 'The dish pan is too small', 'Go to the head of the line', 'He has a big head', 'Do you shop downtown?', 'My home is in the South', 'I light the lamp', 'I ride in the airplane', 'The butter was cut in cubes', 'Make yourself useful', 'Goodbye', 'I didn''t get any mail today', 'What time does the mailman come?', 'This row is reserved', 'My sister is a redhead', 'I will go too', 'We picked enough grapes to make jelly', 'I like the taste of ginger', 'It is wise to think first and then speak', 'I think you are right', 'The cook is in the kitchen', 'The boy went up the stairs', 'When will you come?', 'Watch your step', 'My grandfather is very old', 'Father has brown shoes', 'Have you seen father?', 'When will the bus arrive?'};
% Fig6Botset5AMguesses = {'The rose bush needs to be', '', '', '', '', '', '', '', 'I like the lamp', 'I ride in the airplane', '', '', 'Goodbye', 'I didn''t sit any more today', '', '', 'My sister is', '', '', '', 'It is wise to think first and then speak', 'I think you are right', '', 'The boy went up the stairs', 'When will you come?', 'Watch your step', 'My grandfather is very old', 'Father has brown shoes', 'Have you seen father?', 'When will the bus arrive?'};
% 
% Fig7AzBio1sentences = {'I could hear another conversation through the cordless phone', 'She relied on him for transportation', 'He was an ordinary person who did extraordinary things', 'How long has this been going on', 'His class was on Saturday', 'She was entitled to a bit of luxury occasionally', 'The vacation was cancelled on account of weather', 'The salon is not open on Mondays', 'She had a way to justify any of her wrong doing', 'I feel sorry for my brother', 'On numerous occasions they left early', 'In private she let her hair down', 'A mother always has something better to do', 'You should be used to taking money from ladies', 'Who would lie about cancer for attention', 'Hang the air freshener from your rear view mirror', 'You can use your computer to make greeting cards', 'You must live in a gingerbread house', 'The cat was born with six toes'};
% Fig7AzBio1guesses = {'I could hear another conversation across the way', 'She relied on him for transportation', 'She was an ordinary person who started hearing things', 'How long has this been going on', 'Class was last Saturday', 'She was entitled to a bit of luxury occasionally', 'The magician was canceled on account of weather', 'The salon is not open on Mondays', 'She had a way to justify any of her wrong doing', 'I feel sorry for my brother', 'For the worst occasions I left early', 'She approved us with her hair down', 'Mother always has something better to do', 'You should be used to taking money from ladies', 'Who would lie about cancer for attention', 'Hang your air freshener from your rear view mirror', 'You can use your computer to make greeting cards', 'You must live in a gingerbread house', 'The cat was born with six toes'};
% 
% Fig7AzBio2sentences = {'She missed a week of work and nobody noticed', 'The monkey learned some sign language', 'The house was painted bright orange', 'One day giants will take over the world', 'The new Barbie doll is pregnant', 'It was better to run at night after sunset', 'He never acknowledged the Christmas gift', 'She had the stomach flu for four days', 'How dare you call me a spineless wimp!', 'Don''t get me started', 'She was more than ready to come home', 'The artist’s work had a childlike quality', 'He crushed a can on his head', 'She finally stood up for herself', 'Have a neighbor pick up your mail and paper', 'Only the acts coiled carcasses remained after the extermination', 'It is wrong to borrow someone''s car without permission', 'The candle smelled like sugar cookies', 'I doubt you were thinking too much'};
% Fig7AzBio2guesses = {'', 'Thank you so much', 'This house is bright orange', 'He enjoyed the dinner', 'His mother thought I was pregnant', 'He was so utterly under the sink', 'He never acknowledged her sister', 'She had a stomach sick for four days', 'How dare you call me a spineless wench!', 'Don''t get me started', 'She was more than ready to come home', 'The artist turned into combat mode', 'He went to jail ourselves', 'She finally stood up for herself', 'Have the neighbor pick up your mail and paper', 'He told her neighbor to ask for more information', 'It is not cool to go too far without permission', 'The barroom smelled like sugar cookies', 'I doubt she was drinking too much'};
% 
% Fig8SOsentences = {'I throw the ball', 'Where are the flowers?', 'My watch is slow', 'Father is in the car', 'I always use a cookbook', 'The moonlight is beautiful', 'The moonlight is bright', 'We have a sailboat', 'The farmer has a beehive', 'We live on the Earth', 'Where are your friends?', 'I value your friendship', 'The price of the house is too high', 'This cord is of no use', 'I heard the news on the radio', 'The boys are playing ball', 'Please buy a mousetrap', 'There is a radio in the schoolroom', 'There is a radio in the schoolroom', 'This row is reserved', 'There is no view from my window', 'I like the taste of ginger', 'Do you remember the story about the gingerbread boy?', 'I thought it was four o''clock', 'Were you at home last night?', 'The sun was shining', 'There is a beautiful sunset', 'It is hot this afternoon', 'Will you sew a button on my shirt?', 'Is she your teacher?'};
% Fig8SOguesses = {'', 'Where are the flowers?', 'My duck is slow', 'is in the curb', 'I always use a cookbook', 'The is beautiful', 'The moonlight is bright', 'We have a favorite', 'The farmer has a', 'We live on the earth', 'Where are your friends?', 'I', 'The post of the house is too high', 'This cord is of no use', 'I heard the news on the radio', 'The boys are playing', 'Please', 'Where is the video in the', 'is the radio in the school room', 'This row is reserved', 'There is no on my window', 'I like to push a', 'Did you remember the story about the day?', 'I thought it was four', 'Were you at home last night?', 'The song was funny', 'This, a beautiful sun', 'It is hot', 'Will you share your button on my foot', ''};
% 
% Fig9MTsentences = {'The airplane is yellow', 'Good morning', 'There is a rose on the bush', 'Put some wood on the fire', 'The sailboat is white', 'Can you hear the bee buzzing?', 'The farmer has a beehive', 'Who is that man?', 'Go to the head of the line', 'I like whole wheat bread', 'The sign said stop', 'It is cold outside', 'That is a pretty tune', 'How many men does your father employ?', 'When will you plow the land?', 'Why did you call me?', 'Which play shall we see?', 'Can you run this machine?', 'I will be a few minutes late', 'The young man is very tall', 'I try to save some money every month', 'The jack knife has a sharp blade', 'The jig is an old-fashioned dance', 'June is a summer month', 'Jack up the car', 'I thought I heard a noise', 'It is wise to think first and then speak', 'The sun is hot today', 'The boys were busy as bees', 'The dish is broken'};
% Fig9MTguesses = {'The airplane is yellow', 'Good morning', 'There is a rose on the bush', 'Put some wood on the fire', 'The sailboat is white', 'Can you hear the bee buzzing', 'The farmer has a beehive', 'Who is that man', 'Go to the head of the line', 'I like whole wheat bread', 'The sign said stop', 'It is cold outside', 'That is a pretty tune', 'How many men does your father employ', 'When will you plow the land', 'Why did you call me', 'Which play shall we see', 'Can you run this machine', 'I will be a few minutes late', 'The young man was very tall', 'I tried to save some money every month', 'The jack knife has a sharp blade', 'The jig was an old fashioned dance', 'June is a summer month', 'Jack up the car', 'I thought I heard a noise', 'It is wise to think first and then speak', 'The sun is hot today', 'The boys were busy as bees', 'The dish is broken'};
% 
% Fig10CVCsentences = {'goose', 'name', 'shore', 'bean', 'merge', 'ditch', 'some', 'tough', 'size', 'least', 'home', 'jar', 'pad', 'sale', 'fan', 'jump', 'earn', 'mate', 'gale', 'toot', 'patch', 'foil', 'gate', 'sick', 'nice', 'wretch', 'loud', 'bow', 'lie', 'feel', 'dead', 'sob', 'mess', 'witch', 'chore', 'wood', 'king', 'tow', 'check', 'loop', 'nag', 'sang', 'time', 'hull', 'fun', 'shirt', 'hose', 'sit', 'kite', 'kate'};
% Fig10CVCguesses = {'goose', 'name', 'shore', 'bean', 'merge', 'ditch', 'sun', 'tough', 'seize', 'lease', 'home', 'jar', 'pad', 'fall', 'van', 'jug', 'yearn', 'make', 'gale', 'tooth', 'patch', 'boil', 'hate', 'pick', 'knife', 'wreck', 'rout', 'boat', 'ripe', 'wheel', 'dead', 'sob', 'mess', 'wish', 'chore', 'wood', 'king', 'toad', 'check', 'loop', 'lag', 'salve', 'dime', 'hull', 'thin', 'shirt', 'rose', 'fit', 'kite', 'cape'};
% 
% Fig11PBK50True  = {'please', 'great', 'sled', 'pants', 'rat', 'bad', 'pinch','such', 'bus', 'need', 'ways', 'five', 'mouth', 'rag', 'put', 'fed', 'fold', 'hunt', 'no', 'box', 'are', 'teach', 'slice', 'is', 'tree'};
% Fig11PBK50Guess = {'praise', 'great', 'frog', 'chance', 'rack', 'dog', 'kints','', 'butts', 'need', 'rave', 'spies', 'mouth', 'rag', 'hook', 'bed', '', 'hunt', 'no', 'back', '', 'keeps', '', '', 'tree'};
% 
% Fig12ErberWords = {'Fan','both','cheek','jot','hive','moss','thud','wrap','vice','shown','bomb','will','vat','wreath','guess','comb','choose','sum','heel','shop','vet','weep','sack','fill','catch','thumb','heap','wise','rave','hutch','kill','thighs','wave','reap','foam','goose','reach','cheese'};
% Fig12ErberGuesses = {'sand','boat','chick','yacht','high','moth','mud','rat','bike','show','bob','wheel','bat','reef','guest','cone','shoes','fun','feel','chop','bet','wheat','tack','feel','cat','sum','heat','wine','rays','hut','till','fives','way','rip','phone','booth','rich','she''s'};
% 
% set1AMsentences = {'I always use a cookbook', 'The moonlight is beautiful', 'The moonlight is bright', 'We have a sailboat', 'The farmer has a beehive', 'We live on the Earth', 'Where are your friends?', 'I value your friendship', 'The price of the house is too high', 'I throw the ball', 'This cord is of no use', 'I heard the news on the radio', 'The boys are playing ball', 'Please buy a mousetrap', 'There is a radio in the schoolroom', 'There is a radio in the schoolroom', 'This row is reserved', 'There is no view from my window', 'I like the taste of ginger', 'Do you remember the story about the gingerbread boy?', 'I thought it was four o''clock', 'Were you at home last night?', 'The sun was shining', 'There is a beautiful sunset', 'It is hot this afternoon', 'Will you sew a button on my shirt?', 'Is she your teacher?', 'Where are the flowers?', 'My watch is slow', 'Father is in the car'};
% set1AMguesses = {'I always use a', 'The moonlight is beautiful', 'The moonlight is bright', 'You have a', 'The farmer has a beehive', 'We live on the Earth', '', 'I value your friendship', 'The price of the house is too high', 'I throw the ball', 'This toy is of no use', 'I heard the news on the radio', 'The boys are playing ball', 'Please buy a mousetrap', 'There is a baby out in the ', 'There is a baby out in the school yard', 'This row is reserved', 'There is no view from my window', 'I like to pick a flavor', 'Do you remember', 'I thought it was four o''clock', 'Were you up late last night?', 'The sun is shining', 'There is a beautiful sunset', 'It is hot this afternoon', 'Will you sew a button on my shirt?', 'Is he your teacher?', 'Where are the flowers?', 'My watch is slow', 'Father is in the car'};
% 
% correctSent = {'Patch the Latch','Scratch and pinch','Scratch and itch','My name is John','Latch the watch','It is hard to erase blue or red ink','he broke his ties with groups of former friends','an app','traditional way of learning human anatomy','we developed with a doctor brown in stanford','a day','ascending','butchering','centigrade','crude leaf','cyclones'};
% guessedSent = {'Catch the watch','Scratch and itch','Scratch and pinch','My name is','Watch the latch','red ink','he broke his pride not hell to grant house','a nap','traditional way of loaning human and that to me','we developed with doctor brahmin stamp or','today','and sending','maturing','cents a great','crudely','soy clones'};
% 
% KisorTrue = {'What''s that big loud noise'};
% KisorGuess = {'What''s that pig outdoors'};
% 
% Arnoult2020Words = {'knock','thought','gin','pike','shack','knock'};
% Arnoult2020Guess = {'knock','fought','jim','kite','shuck','map'};

sheets_corpus = sheetnames('Original BEL Corpus (Text).xlsx');
for k=1:numel(sheets_corpus)
  disp(sheets_corpus{k})
  BELcorpus{k}=readtable('Original BEL Corpus (Text).xlsx','Sheet',sheets_corpus{k});
end

sheets_data = sheetnames('All Data.xlsx');
for k=1:numel(sheets_data)
  disp(sheets_data{k})
  data{k}=readtable('All Data.xlsx','Sheet',sheets_data{k});
end

UMcorpusTrue = {};
for i=1:numel(BELcorpus)
    UMcorpusTrue = [UMcorpusTrue, BELcorpus{i}];
end

stimuli = {};
excluded_lists = [1 4 12 18];
for c=1:20
    if ~ismember(c,excluded_lists)
        for r=1:25
            stimuli = [stimuli, UMcorpusTrue{r,c}];
        end
    end
end

sub1 = data{1};
sub1_responses = {};
for c=1:16
    for r=1:25
        sub1_responses = [sub1_responses, sub1{r,c}];
    end
end

sub2 = data{2};
sub2_responses = {};
for c=1:16
    for r=1:25
        sub2_responses = [sub2_responses, sub2{r,c}];
    end
end

sub3 = data{3};
sub3_responses = {};
for c=1:16
    for r=1:25
        sub3_responses = [sub3_responses, sub3{r,c}];
    end
end

sub4 = data{4};
sub4_responses = {};
for c=1:16
    for r=1:25
        sub4_responses = [sub4_responses, sub4{r,c}];
    end
end

sub5 = data{5};
sub5_responses = {};
for c=1:16
    for r=1:25
        sub5_responses = [sub5_responses, sub5{r,c}];
    end
end

sub6 = data{6};
sub6_responses = {};
for c=1:16
    for r=1:25
        sub6_responses = [sub6_responses, sub6{r,c}];
    end
end

sub7 = data{7};
sub7_responses = {};
for c=1:16
    for r=1:25
        sub7_responses = [sub7_responses, sub7{r,c}];
    end
end

sub8 = data{8};
sub8_responses = {};
for c=1:16
    for r=1:25
        sub8_responses = [sub8_responses, sub8{r,c}];
    end
end

sub9 = data{9};
sub9_responses = {};
for c=1:16
    for r=1:25
        sub9_responses = [sub9_responses, sub9{r,c}];
    end
end

sub10 = data{10};
sub10_responses = {};
for c=1:16
    for r=1:25
        sub10_responses = [sub10_responses, sub10{r,c}];
    end
end

sub11 = data{11};
sub11_responses = {};
for c=1:16
    for r=1:25
        sub11_responses = [sub11_responses, sub11{r,c}];
    end
end

sub12 = data{12};
sub12_responses = {};
for c=1:16
    for r=1:25
        sub12_responses = [sub12_responses, sub12{r,c}];
    end
end

sub13 = data{13};
sub13_responses = {};
for c=1:16
    for r=1:25
        sub13_responses = [sub13_responses, sub13{r,c}];
    end
end

sub14 = data{14};
sub14_responses = {};
for c=1:16
    for r=1:25
        sub14_responses = [sub14_responses, sub14{r,c}];
    end
end

sub15 = data{15};
sub15_responses = {};
for c=1:16
    for r=1:25
        sub15_responses = [sub15_responses, sub15{r,c}];
    end
end

sub16 = data{16};
sub16_responses = {};
for c=1:16
    for r=1:25
        sub16_responses = [sub16_responses, sub16{r,c}];
    end
end

sub17 = data{17};
sub17_responses = {};
for c=1:16
    for r=1:25
        sub17_responses = [sub17_responses, sub17{r,c}];
    end
end

sub18 = data{18};
sub18_responses = {};
for c=1:16
    for r=1:25
        sub18_responses = [sub18_responses, sub18{r,c}];
    end
end

sub19 = data{19};
sub19_responses = {};
for c=1:16
    for r=1:25
        sub19_responses = [sub19_responses, sub19{r,c}];
    end
end

sub20 = data{20};
sub20_responses = {};
for c=1:16
    for r=1:25
        sub20_responses = [sub20_responses, sub20{r,c}];
    end
end

sub21 = data{21};
sub21_responses = {};
for c=1:16
    for r=1:25
        sub21_responses = [sub21_responses, sub21{r,c}];
    end
end

sub22 = data{22};
sub22_responses = {};
for c=1:16
    for r=1:25
        sub22_responses = [sub22_responses, sub22{r,c}];
    end
end

sub23 = data{23};
sub23_responses = {};
for c=1:16
    for r=1:25
        sub23_responses = [sub23_responses, sub23{r,c}];
    end
end

sub24 = data{24};
sub24_responses = {};
for c=1:16
    for r=1:25
        sub24_responses = [sub24_responses, sub24{r,c}];
    end
end

sub25 = data{25};
sub25_responses = {};
for c=1:16
    for r=1:25
        sub25_responses = [sub25_responses, sub25{r,c}];
    end
end

sub26 = data{26};
sub26_responses = {};
for c=1:16
    for r=1:25
        sub26_responses = [sub26_responses, sub26{r,c}];
    end
end

sub27 = data{27};
sub27_responses = {};
for c=1:16
    for r=1:25
        sub27_responses = [sub27_responses, sub27{r,c}];
    end
end

sub28 = data{28};
sub28_responses = {};
for c=1:16
    for r=1:25
        sub28_responses = [sub28_responses, sub28{r,c}];
    end
end

sub29 = data{29};
sub29_responses = {};
for c=1:16
    for r=1:25
        sub29_responses = [sub29_responses, sub29{r,c}];
    end
end

sub30 = data{30};
sub30_responses = {};
for c=1:16
    for r=1:25
        sub30_responses = [sub30_responses, sub30{r,c}];
    end
end

sub31 = data{31};
sub31_responses = {};
for c=1:16
    for r=1:25
        sub31_responses = [sub31_responses, sub31{r,c}];
    end
end

combined_responses = [sub1_responses, sub2_responses, sub3_responses, sub4_responses, sub5_responses, sub6_responses, sub7_responses, sub8_responses, sub9_responses, sub10_responses, sub11_responses, sub12_responses, sub13_responses, sub14_responses, sub15_responses, sub16_responses, sub17_responses, sub18_responses, sub19_responses, sub20_responses, sub21_responses, sub22_responses, sub23_responses, sub24_responses, sub25_responses, sub26_responses, sub27_responses, sub28_responses, sub29_responses, sub30_responses, sub31_responses];
combined_stimuli = [stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli, stimuli];


%comment out whichever lines you don't want to run
composite = {...
%       {stimuli, sub1_responses, 'Subject 1'}
%       {stimuli, sub2_responses, 'Subject 2'}
%       {stimuli, sub3_responses, 'Subject 3'}
%       {stimuli, sub4_responses, 'Subject 4'}
%        {stimuli, sub5_responses, 'Subject 5'}
% {stimuli, sub6_responses, 'Subject 6'}
% {stimuli, sub7_responses, 'Subject 7'}
% {stimuli, sub8_responses, 'Subject 8'}
% {stimuli, sub9_responses, 'Subject 9'}
% {stimuli, sub10_responses, 'Subject 10'}
% {stimuli, sub11_responses, 'Subject 11'}
% {stimuli, sub12_responses, 'Subject 12'}
% {stimuli, sub13_responses, 'Subject 13'}
%  {stimuli, sub14_responses, 'Subject 14'}
% {stimuli, sub15_responses, 'Subject 15'}
% {stimuli, sub16_responses, 'Subject 16'}
% {stimuli, sub17_responses, 'Subject 17'}
% {stimuli, sub18_responses, 'Subject 18'}
% {stimuli, sub19_responses, 'Subject 19'}
%   {stimuli, sub20_responses, 'Subject 20'}
% {stimuli, sub21_responses, 'Subject 21'}
%  {stimuli, sub22_responses, 'Subject 22'}
% {stimuli, sub23_responses, 'Subject 23'}
% {stimuli, sub24_responses, 'Subject 24'}
% {stimuli, sub25_responses, 'Subject 25'}
%  {stimuli, sub26_responses, 'Subject 26'}
%  {stimuli, sub27_responses, 'Subject 27'}
% {stimuli, sub28_responses, 'Subject 28'}
% {stimuli, sub29_responses, 'Subject 29'}
% {stimuli, sub30_responses, 'Subject 30'}
 {stimuli, sub31_responses, 'Subject 31'}
% {combined_stimuli, combined_responses, 'Combined Subjects'}
%     {Fig5TopCIHAsentences, Fig5TopCIHAguesses, 'CI and HA'},...
%     {Fig5MidCIsentences, Fig5MidCIguesses, 'CI Only'},...
%     {Fig5BotHAsentences, Fig5BotHAguesses, 'HA Only'},...
%     {Fig6Topset4AMsentences, Fig6Topset4AMguesses, 'INT HA'},...
%     {Fig6Botset5AMsentences, Fig6Botset5AMguesses, 'INT No HA'},...
%     {Fig7AzBio1sentences, Fig7AzBio1guesses, 'AzBio1'},...
%     {Fig7AzBio2sentences, Fig7AzBio2guesses, 'AzBio2'}...
%     {Fig8SOsentences, Fig8SOguesses, 'STUD1'},...
%     {Fig9MTsentences, Fig9MTguesses, 'STUD2'},...
%     {Fig10CVCsentences, Fig10CVCguesses, 'CVC Word Example'}, ...
%     {Fig11PBK50True, Fig11PBK50Guess, 'PBK50 Example'}, ...
%     {Fig12ErberWords, Fig12ErberGuesses, 'Erber Example'}, ...
%%% other examples not needed for paper
%    {set1AMsentences, set1AMguesses, 'AM No HA2'},...
%    {correctSent, guessedSent, 'Erber Book'}...
%    {KisorTrue, KisorGuess, 'Henry'}, ...
%    {Arnoult2020Words,Arnoult2020Guess, 'ArnoultThesis'}, ...

    };

wpo=false;
phoneme_analysis_fscore_v3(composite,wpo);
