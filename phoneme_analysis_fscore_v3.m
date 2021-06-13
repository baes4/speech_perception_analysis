%patched BEST! Time/case/phoneme stats, fast, advanced cost
function [pScores] = phoneme_analysis_fscore_v3(allData,wpo)

%phoxyz.mat contains a map from phoneme to coordinate for phonemic error
%visualization
load phoxyz
load splitCMUdict.mat
load variables.mat

%nontarget = {146/'a', 'the', 'of', 'A', 'The', 'Of'}; % will remove non-target words
% march 29, 2017, testing without "the"
% nontarget = {'a', 'of', 'A', 'Of'};
% MAKE SURE ALL NONTARGETS ARE IN ALL UPPERCASE LETTERS
nontarget = {};

stats = cell(length(allData) + 1, 5);

stats{1,1} = 'Name';
stats{1,2} = 'Cases';
stats{1,3} = 'Response phonemes';
stats{1,4} = 'Stimulus phonemes';
stats{1,5} = 'Time (sec)';
stats{1,6} = 'Correct # of words';
stats{1,7} = 'Total # of words';
stats{1,8} = 'Correct # of sentences';

for casenum = 1 : length(allData)
	tic;
	totalnum = 0; %total number of true phonemes
	totalguess = 0; %total number of guessed phonemes
	Real = allData{casenum}{1}; %extract true sentences
	Guess = allData{casenum}{2}; %extract guessed sentences
	Name = allData{casenum}{3}; %extract name
	totalUniqPh = {}; %all unique phonemes ever guessed/said
	% phoneme, TP, FP, FN
	totalData = cell(1,length(Real)); %to hold all data
	stats{casenum+1,1} = Name; %for timing stats
	stats{casenum+1,2} = length(Real); %for timing stats
	
	fprintf('%s\t\t%d Case(s)\n\n', Name, length(Real));
	
	% Take out all characters that are not letters, apostrophes or spaces
	for i = 1:length(Real)
		curr_guess = Guess{i}(regexp(Guess{i}, '[a-zA-Z\s'']'));
		curr_sent = Real{i}(regexp(Real{i}, '[a-zA-Z\s'']'));
		Guess{i} = strtrim(curr_guess);
		Real{i} = strtrim(curr_sent);
	end
	
	% initialize features array (see return_features below)
	features = zeros(10,2);
    % initialize confusion matrices
    vowel_matrix=zeros(15,16);
    consonant_matrix=zeros(24,25);

	
    %{
	% go through each guess
	h = length(Guess);
	% BLANK records which guesses are empty by changing them to 0 at the
	%appropriate index
	BLANK=ones(1,h(1));
	for i=1:h(1)
		Z=char(Guess(i));
		length(Z);
		if isempty(Z)
			% any empty guesses will also be changed to 'z'
			Guess(i)=cellstr('z');
			BLANK(i)=0;
		end
	end
	%}
    
	% reals and guesss are empty cell arrays of length of real
	num = length(Real);
	reals = cell(1,num);
	guesss = cell(1,num);
    num_wordscorrect = 0;
    num_sentcorrect = 0;
    num_totalwords = 0;
    
	for z = 1:num
		
		% get a list of words in your guess
		guessWords = upper(char(Guess(z)));
		guessWords = strsplit(guessWords, ' ');
		% get a list of words in the real sentence
		realWords = upper(char(Real(z)));
		realWords = strsplit(realWords, ' ');
		% now loop through real words, and remove nontargets (of, the, etc)
		k = 1;
		while k <= length(realWords)
			if sum(strcmp(realWords{k}, nontarget))
				realWords(k) = [];
				k = k - 1;
			end
			k = k + 1;
		end
		k = 1;
		%do the same for guess words
		while k <= length(guessWords)
			if sum(strcmp(guessWords{k}, nontarget))
				guessWords(k) = [];
				k = k - 1;
			end
			k = k + 1;
		end
		reals{z} = realWords;
		guesss{z} = guessWords;
    end
    
    for z = 1:num
        %compare response and stimulus words to get # of words correct
        if isequal(guesss{z},reals{z})
            num_sentcorrect = num_sentcorrect+1;
            if wpo == true
                continue
            end
        end
        num_wordscorrect = num_wordscorrect + numel(intersect(guesss{z},reals{z}));
        num_totalwords = num_totalwords + length(reals{z});
    end
	
	% Go to CMU dictionary, and get appropriate phonemes for each word
	guessphonemes = cell(num,1);
	realphonemes = cell(num,1);
	for z = 1:num
		
        if wpo == true
            if isequal(Guess{z},Real{z})
                continue
            end
        end
        
		fprintf('\nGuess:\n%s\n', Guess{z});
		fprintf('Sentence:\n%s\n\n', Real{z});
		%fprintf('Processing: %f percent finished \n\n', 100*m/num)
		real2 = {};
		for k = 1:length(reals{z})
			if isKey(splitCMUdict, reals{z}{k})
				%real2{end+1} = splitCMUdict(reals{z}{k});
                real2{end+1} = splitCMUdict(reals{z}{k});
            else
                fprintf('The true word %s was not found. What is its phoneme representation?\n', guesss{z}{k});
                
                isWord = 0;
                while not(isWord)
                    
                    %% How do I break this in two lines
                    manual = input('(Separate phonemes with spaces. To look up a word in the CMUdict, type ONLY "#word".\n For example, if the problem word is KINTS then look up a similar word like HINTS\n in the CMU Dictionary website and enter the modified phoneme wih H replaced by K.)\n', 's');
                    if(isempty(strfind(manual, '#')))
                        real2{end+1} = upper(manual);
                        isWord = 1;
                    else
                        manual = upper(strtrim(manual(regexp(manual, '[a-zA-Z\s'']'))));
                        if isKey(splitCMUdict, manual)
                            fprintf('%s: %s\n', manual, splitCMUdict(manual))
                        else
                            fprintf('%s is not a word in the CMUdict.\n', manual)
                        end
                    end
                end
                continue;
            end
            
		end
		realphonemes{z} = strjoin(real2);
		uniqr = strsplit(realphonemes{z});
		totalnum = totalnum + length(uniqr);
		
		%uniqr2 holds all of the unique real phonemes.
		uniqr2 = unique(uniqr); % at this point we lose the order
		
		% now we split up the phonemes into cells
		% and check for blanks
		% if there's a blank we stick in a bunch of 'qq's
        
        guess2 = {};
        for k = 1:length(guesss{z})
            if isKey(splitCMUdict, guesss{z}{k})
                %guess2{end+1} = splitCMUdict(guesss{z}{k});
                guess2{end+1} = splitCMUdict(guesss{z}{k});
            elseif not(isempty(guesss{z}{k}))
                fprintf('The guessed word %s was not found. What is its phoneme representation?\n', guesss{z}{k});
                
                isWord = 0;
                while not(isWord)
                    %% How do I break this in two lines
                    manual = input('(Separate phonemes with spaces. To look up a word in the CMUdict, type ONLY "#word".\n For example, if the problem word is KINTS then look up a similar word like HINTS\n in the CMU Dictionary website and enter the modified phoneme wih H replaced by K.)\n', 's');
                    if(isempty(strfind(manual, '#')))
                        guess2{end+1} = upper(manual);
                        isWord = 1;
                    else
                        manual = upper(strtrim(manual(regexp(manual, '[a-zA-Z\s'']'))));
                        if isKey(splitCMUdict, manual)
                            fprintf('%s: %s\n', manual, splitCMUdict(manual))
                        else
                            fprintf('%s is not a word in the CMUdict.\n', manual)
                        end
                    end
                end
                continue;
            end
        end
        if(isempty(guess2))
            guessphonemes{z} = strjoin(horzcat(repmat({'qq'},1,length(uniqr))));
			uniqg = strsplit(guessphonemes{z});
			allUniqPh = unique(uniqr2);
			aligned = vertcat(uniqg, uniqr);
        else
            guessphonemes{z} = strjoin(guess2);
            uniqg = strsplit(guessphonemes{z});
            uniqg2 = unique(uniqg);
            allUniqPh = unique(horzcat(uniqr2,uniqg2));
            totalguess = totalguess + length(uniqg);
            
            %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            [aligned] = align_vtest6(uniqr,uniqg,consdict,vowdict,mannerdict);
            %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        end
        
		
		guessph = aligned(1,:);
		realph = aligned(2,:);
		disp(aligned)
		
		%totalCounts = zeros(3, length(uniqr2));
		%user heard phon when there was a phon (match)
		truePos = zeros(1,length(allUniqPh));
		%user heard phon when there was no phon (ins or sub: guessed phon)
		falsePos = zeros(1,length(allUniqPh));
		%user did not hear phon when there was a phon (del or sub: true phon)
		falseNeg = zeros(1,length(allUniqPh));

		for i = 1 : length(realph)
			%if the real and guess match
			%add one to truePos for the corresponding phoneme
			%else
			%add one falsePos for the guess
			%add one falseNeg for the true
			if strcmp(realph{i},guessph{i})
				truePos(1,find(strcmp(allUniqPh,realph{i}))) = truePos(1,find(strcmp(allUniqPh,realph{i})))+1;
            else
				falsePos(1,find(strcmp(allUniqPh,guessph{i}))) = falsePos(1,find(strcmp(allUniqPh,guessph{i})))+1;
				falseNeg(1,find(strcmp(allUniqPh,realph{i}))) = falseNeg(1,find(strcmp(allUniqPh,realph{i})))+1;
			end
		end
		%find the F1 score
		singleF1 = zeros(1,length(allUniqPh));
		for i = 1 : length(allUniqPh)
			%fprintf('%s\t%d\t%d\t%d\n',allUniqPh{1,i},truePos(1,i),falsePos(1,i),falseNeg(1,i));
			singleF1(1,i) = 200*truePos(1,i)/(2*truePos(1,i)+falsePos(1,i)+falseNeg(1,i));
		end
		%singleF1 = ((2*truePos(1,:))./(2*truePos(1,:)+falsePos(1,:)+falseNeg(1,:)))*100;
		
		% all = vertcat(allUniqPh, num2cell(singleF1));
		% disp(all)
		
		realF1 = zeros(1,length(uniqr2));
		for i = 1 : length(uniqr2)
			realF1(1,i) = singleF1(1,find(strcmp(allUniqPh,uniqr2{i})));
		end
		
		totalUniqPh = unique([totalUniqPh allUniqPh]);
		totalData{z} = vertcat(allUniqPh, num2cell(truePos), num2cell(falsePos), num2cell(falseNeg));
		
		%percent = (uniqcount(1,:)./uniqcount(2,:))*100;
		disp('Unique Phonemes and their F-Scores')
		pScores=vertcat(uniqr2,num2cell(realF1));
		%pScores = vertcat(allUniqPh,num2cell(singleF1));
		%PP{z}=uniqr2;
		%PS{z}=uniqcount;
		%features = return_features(realph, guessph, attributemaps, features, vowels, consonants);
        [vowel_matrix, consonant_matrix] = matrix_constructor(realph,guessph,vowels,consonants,vowel_matrix,consonant_matrix);
    end
	
    
	totalTP = zeros(1,length(totalUniqPh));
	totalFP = zeros(1,length(totalUniqPh));
	totalFN = zeros(1,length(totalUniqPh));
	
	for i = 1 : length(totalData)
        len = size(totalData{1,i});
		for j = 1 : len(2)
%             fprintf('%d\t%d\n', i, j);
%             disp(totalData{1,i}{1,j});
			index = find(strcmp(totalUniqPh, totalData{1,i}{1,j}));
			totalTP(1,index) = totalTP(1,index) + totalData{1,i}{2,j};
			totalFP(1,index) = totalFP(1,index) + totalData{1,i}{3,j};
			totalFN(1,index) = totalFN(1,index) + totalData{1,i}{4,j};
		end
	end
	
	totalF1 = zeros(1,length(totalUniqPh));
	for i = 1 : length(totalUniqPh)
		%fprintf('%s\t%d\t%d\t%d\n',allUniqPh{1,i},truePos(1,i),falsePos(1,i),falseNeg(1,i));
		totalF1(1,i) = 200*totalTP(1,i)/(2*totalTP(1,i)+totalFP(1,i)+totalFN(1,i));
	end
	totalScores = vertcat(totalUniqPh, num2cell(totalF1));
	
	figure('Name', Name, 'NumberTitle', 'off');
	set(gcf, 'Position', [0, 0, 710, 570]);
	if ~strcmp(totalUniqPh{1}, '')
		for k = 1:length(totalUniqPh)
			if ~isempty(strfind('AEIOU',totalUniqPh{k}(1))) % if the phoneme is a vowel
				try
					coord = phoxyz(totalUniqPh{k});
				catch
					disp('You might have misspelled something')
					return
				end
				subplot(2,2,2);
				hold on
				scatter(coord(1), coord(2), 350, totalF1(k), 'filled')
				text(coord(1), coord(2), totalUniqPh{k}, 'Color', [219/256,147/256,112/256], 'HorizontalAlignment','center', 'VerticalAlignment','middle')
				%set(gca,'clim',[0,100]);
				%colorbar;
			elseif ~strcmp(totalUniqPh{k}, '') % phoneme is a consonant
				try
					coord = phoxyz(totalUniqPh{k});
				catch
					disp('You might have misspelled something')
					return
				end
				if coord(3) == 1
					subplot(2,2,3);
					hold on
					scatter(coord(1), coord(2), 350, totalF1(k), 'filled')
					text(coord(1), coord(2), totalUniqPh{k}, 'Color', [219/256,147/256,112/256], 'HorizontalAlignment','center', 'VerticalAlignment','middle')
					%set(gca,'clim',[0,100]);
					%colorbar;
				else
					subplot(2,2,4);
					hold on
					scatter(coord(1), coord(2), 350, totalF1(k), 'filled')
					text(coord(1), coord(2), totalUniqPh{k}, 'Color', [219/256,147/256,112/256], 'HorizontalAlignment','center', 'VerticalAlignment','middle')
					%set(gca,'clim',[0,100]);
					%colorbar;
				end
			end
		end
    end
    
    %disp(stats)
    % for count = 1 : length(allData)
    %	 fprintf('\n%s\t\t%d Cases\t\t%.3f seconds\n', allData{count}{3}, length(allData{count}{1}), stats{count});
    % end
    % disp("FINAL MATRICES")
%     disp(consonant_matrix)
%     disp(vowel_matrix)
%     disp("Sums")
%     disp(sum(consonant_matrix,'all'))
%     disp(sum(vowel_matrix,'all'))
    pm_values = zeros(1,10);

    nasality = [1;1;1;1;1;1;1;1;1;1;2;2;2;1;1;1;1;1;1;1;1;1;1;1];
    manner = [1;5;1;3;3;1;3;5;1;4;2;2;2;1;4;3;3;1;3;3;4;4;3;3];
    voicing = [2;1;2;1;1;2;1;2;1;2;2;2;2;1;2;1;1;1;2;2;2;2;2;2];
    affrication = [1;2;1;2;2;1;2;2;1;1;1;1;1;1;1;2;2;1;2;2;1;1;2;2];
    sibilance =  [1;2;1;1;1;1;1;2;1;1;1;1;1;1;1;2;2;1;1;1;1;1;2;2];
    consonant_place = [1;2;2;1;1;3;3;2;3;2;1;2;3;1;2;2;2;2;1;1;1;2;2;2];

    nasality_fm = featU(consonant_matrix, nasality);
    nasality_it = info2(nasality_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(nasality_fm);
    fm_size = fm_matrix_size(1);
    nasality_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(nasality_fm(i,:));
        num_total = sum(nasality_fm,'all');
        if num_phonemes ~= 0
            nasality_stiminfo = nasality_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %nasality_stiminfo = -1*(230/281)*log(230/281)-(51/281)*log(51/281);
    nasality_score = 100*(nasality_it/nasality_stiminfo);
    pm_values(1) = nasality_score;

    manner_fm = featU(consonant_matrix, manner);
    manner_it = info2(manner_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(manner_fm);
    fm_size = fm_matrix_size(1);
    manner_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(manner_fm(i,:));
        num_total = sum(manner_fm,'all');
        if num_phonemes ~= 0
            manner_stiminfo = manner_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %manner_stiminfo = -1*(6/24)*log(6/24)-(3/24)*log(3/24)-(9/24)*log(9/24)-(4/24)*log(4/24)-(2/24)*log(2/24);
    manner_score = 100*(manner_it/manner_stiminfo);
    pm_values(3) = manner_score;

    voicing_fm = featU(consonant_matrix, voicing);
    voicing_it = info2(voicing_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(voicing_fm);
    fm_size = fm_matrix_size(1);
    voicing_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(voicing_fm(i,:));
        num_total = sum(voicing_fm,'all');
        if num_phonemes ~= 0
            voicing_stiminfo = voicing_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %voicing_stiminfo = -1*(9/24)*log(9/24)-(15/24)*log(15/24);
    %voicing_stiminfo = -1*(107/281)*log(107/281)-(174/281)*log(174/281);
    voicing_score = 100*(voicing_it/voicing_stiminfo);
    pm_values(4) = voicing_score;

    affrication_fm = featU(consonant_matrix, affrication);
    affrication_it = info2(affrication_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(affrication_fm);
    fm_size = fm_matrix_size(1);
    affrication_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(affrication_fm(i,:));
        num_total = sum(affrication_fm,'all');
        if num_phonemes ~= 0
            affrication_stiminfo = affrication_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %affrication_stiminfo = -1*(13/24)*log(13/24)-(11/24)*log(11/24);
    affrication_score = 100*(affrication_it/affrication_stiminfo);
    pm_values(8) = affrication_score;

    sibilance_fm = featU(consonant_matrix, sibilance);
    sibilance_it = info2(sibilance_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(sibilance_fm);
    fm_size = fm_matrix_size(1);
    sibilance_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(sibilance_fm(i,:));
        num_total = sum(sibilance_fm,'all');
        if num_phonemes ~= 0
            sibilance_stiminfo = sibilance_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %sibilance_stiminfo = -1*(18/24)*log(18/24)-(6/24)*log(6/24);
    sibilance_score = 100*(sibilance_it/sibilance_stiminfo);
    pm_values(9) = sibilance_score;

    consonant_place_fm = featU(consonant_matrix, consonant_place);
    consonant_place_it = info2(consonant_place_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(consonant_place_fm);
    fm_size = fm_matrix_size(1);
    consonant_place_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(consonant_place_fm(i,:));
        num_total = sum(consonant_place_fm,'all');
        if num_phonemes ~= 0
            consonant_place_stiminfo = consonant_place_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %consonant_place_stiminfo = -1*(8/24)*log(8/24)-(12/24)*log(12/24)-(4/24)*log(4/24);
    consonant_place_score = 100*(consonant_place_it/consonant_place_stiminfo);
    pm_values(10) = consonant_place_score;

    vowel_height = [1;1;2;2;1;1;2;2;2;3;3;2;2;3;3];
    contour = [2;2;2;2;3;1;2;2;1;2;2;1;3;2;2];
    vowel_place = [3;2;2;3;2;2;1;2;1;1;1;3;3;3;3];
    vowel_length = [1;1;1;1;2;2;1;1;2;1;2;2;2;1;2];

    %vowel_matrix_cut = vowel_matrix(:,1:15);
    vowelheight_fm = featU(vowel_matrix,vowel_height);
    vowelheight_it = info2(vowelheight_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(vowelheight_fm);
    fm_size = fm_matrix_size(1);
    vowelheight_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(vowelheight_fm(i,:));
        num_total = sum(vowelheight_fm,'all');
        if num_phonemes ~= 0
            vowelheight_stiminfo = vowelheight_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %vowelheight_stiminfo = -1*(4/15)*log(4/15)-(7/15)*log(7/15)-(4/15)*log(4/15);
    vowelheight_score = 100*(vowelheight_it/vowelheight_stiminfo);
    pm_values(2) = vowelheight_score;

    contour_fm = featU(vowel_matrix, contour);
    contour_it = info2(contour_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(contour_fm);
    fm_size = fm_matrix_size(1);
    contour_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(contour_fm(i,:));
        num_total = sum(contour_fm,'all');
        if num_phonemes ~= 0
            contour_stiminfo = contour_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %contour_stiminfo = -1*(3/15)*log(3/15)-(10/15)*log(10/15)-(2/15)*log(2/15);
    contour_score = 100*(contour_it/contour_stiminfo);
    pm_values(5) = contour_score;

    vowelplace_fm = featU(vowel_matrix,vowel_place);
    vowelplace_it = info2(vowelplace_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(vowelplace_fm);
    fm_size = fm_matrix_size(1);
    vowelplace_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(vowelplace_fm(i,:));
        num_total = sum(vowelplace_fm,'all');
        if num_phonemes ~= 0
            vowelplace_stiminfo = vowelplace_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %vowelplace_stiminfo = -1*(4/15)*log(4/15)-(5/15)*log(5/15)-(6/15)*log(6/15);
    vowelplace_score = 100*(vowelplace_it/vowelplace_stiminfo);
    pm_values(6) = vowelplace_score;

    vowellength_fm = featU(vowel_matrix,vowel_length);
    vowellength_it = info2(vowellength_fm);
    %calculate the stiminfo from the counts found in the feature matrix
    fm_matrix_size = size(vowellength_fm);
    fm_size = fm_matrix_size(1);
    vowellength_stiminfo = 0;
    for i = 1:fm_size
        num_phonemes = sum(vowellength_fm(i,:));
        num_total = sum(vowellength_fm,'all');
        if num_phonemes ~= 0 
            vowellength_stiminfo = vowellength_stiminfo - (num_phonemes/num_total)*log(num_phonemes/num_total);
        end
    end
    %vowellength_stiminfo = -1*(8/15)*log(8/15)-(7/15)*log(7/15);
    vowellength_score = 100*(vowellength_it/vowellength_stiminfo);
    pm_values(7) = vowellength_score;

    subplot(2,2,1);
    histvals = zeros(1,10);
    hold on
    for i = 1:10
        histvals(i) = pm_values(i);
        %trying to see what the specific percentages are for each
        %feature
        single = bar(i,histvals(i));
        set(single, 'LineWidth', 2);
        if i <= 4
            set(single, 'FaceColor', 'k');
        elseif i <= 7
            set(single, 'FaceColor', 'b');
        elseif i == 8
            set(single, 'FaceColor', 'c');
        else
            set(single, 'FaceColor', 'w');
        end

    end
    hold off
    lab = {' ', 'Nasality', 'Vowel height', 'Manner', 'Voicing', 'Contour',...
        'Vowel place', 'Vowel length', 'Affrication', 'Sibilance', 'Consonant Place', ' '};
    title('Phonemegram');
    set(gca, 'XLim', [0 11]);
    set(gca, 'XTickLabel', lab);
    axis = gca;
    axis.XTick = [0 1 2 3 4 5 6 7 8 9 10 11];
    axis.XTickLabelRotation = 30;
    set(gca, 'YLim', [0 100]);
    ylabel('Percent Correct');
    pos = get(gca, 'Position');
    pos(1) = pos(1) - 0.055;
    pos(3) = pos(3) + 0.05;
    set(gca, 'Position', pos);
	
	subplot(2,2,2);
	title('Vowels')
	xlabel('Place')
	set(gca,'XLim',[0 8])
	ax = gca;
	ax.XTick = [0 1 2 3 4 5 6 7 8];
	ax.XTickLabelRotation = 20;
	set(gca,'XTickLabel',{' ', 'Front', ' ', ' ', 'Center', ' ', ' ', 'Back', ' '});
	ylabel('Height')
	set(gca,'YLim',[0 6])
	set(gca,'YTickLabel',{' ', 'Low', ' ', 'Mid', ' ', 'High', ' '})
	set(gca,'clim',[0,100]);
	colorbar('Ticks',linspace(0,100,11),...
		'TickLabels',{'0%', '10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'})
	pos = get(gca, 'Position');
	%pos(1) = pos(1) - 0.02;
	pos(3) = pos(3) + 0.01;
	set(gca, 'Position', pos);
	
	subplot(2,2,3)
	title('Consonants (Voiced)')
	xlabel('Place')
	set(gca,'Xlim',[0 7])
	ax = gca;
	ax.XTickLabelRotation = 20;
	set(gca,'Xticklabel',{' ', 'Bilabial', 'Labiodental', 'Lingadental', 'Alveolar', 'Palatal', 'Velar', '  '});
	label_h = ylabel('Manner');
    label_h.Position(1)=-0.75;
    label_h.Position(2)=4;
	set(gca,'ylim',[0 6])
	ax = gca;
	ax.YTickLabelRotation = 60;
	set(gca,'Yticklabel',{' ', 'Sonorant', 'Fricative', 'Affricate', 'Stop', 'Nasal', '  '});
	set(gca,'clim',[0,100]);
	colorbar('Ticks',linspace(0,100,11),...
		'TickLabels',{'0%', '10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'})
	pos = get(gca, 'Position');
	pos(1) = pos(1) - 0.055;
	pos(3) = pos(3) + 0.01;
	set(gca, 'Position', pos);
	
	subplot(2,2,4);
	title('Consonants (Unvoiced)')
	xlabel('Place')
	set(gca,'Xlim',[0 7])
	ax = gca;
	ax.XTickLabelRotation = 20;
	set(gca,'Xticklabel',{' ', 'Bilabial', 'Labiodental', 'Lingadental', 'Alveolar', 'Palatal', 'Velar', '  '});
	ylabel('Manner')
	set(gca,'ylim',[0 6])
	ax = gca;
	ax.YTickLabelRotation = 60;
	set(gca,'Yticklabel',{' ', 'Sonorant', 'Fricative', 'Affricate', 'Stop', 'Nasal', '  '});
	set(gca,'clim',[0,100]);
	colorbar('Ticks',linspace(0,100,11),...
		'TickLabels',{'0%', '10%', '20%', '30%', '40%', '50%', '60%', '70%', '80%', '90%', '100%'});
	pos = get(gca, 'Position');
%	 pos(1) = pos(1) - 0.05;
	pos(3) = pos(3) + 0.01;
	set(gca, 'Position', pos);
	print(Name, '-dpng');
	
	
	%pmatrix=vertcat(uniqr2,num2cell(TotalCount));
	stats{casenum+1,3} = totalguess;
	stats{casenum+1,4} = totalnum;
	stats{casenum+1,5} = toc;
    stats{casenum+1,6} = num_wordscorrect;
    stats{casenum+1,7} = num_totalwords;
    stats{casenum+1,8} = num_sentcorrect;
	format short g;
	%fprintf('\n%s\t\t%d Cases\t\t%.3f seconds\n\n', Name, length(Real), t);
	%fprintf('~~~~~~~~~~\t~~~~~~~~~~\t~~~~~~~~~~\t~~~~~~~~~~\t~~~~~~~~~~\t~~~~~~~~~~\t');
	fprintf('~~~~~~~~~~\t~~~~~~~~~~\t~~~~~~~~~~\t~~~~~~~~~~\t~~~~~~~~~~\t~~~~~~~~~~\t');
	fprintf('~~~~~~~~~~\t~~~~~~~~~~\t\n\n');
end

disp(stats)

end

%%%%Phonemegram
function[features] = return_features(realph,guessph, attributemaps, features, vowels, consonants)
attributemaps_view = attributemaps;
count=0;
for i = 1 : length(realph)
	currTrue = realph{i};
	currGuess = guessph{i};
	memberInfoTrue = [sum(strcmp(currTrue, vowels)), ...
		sum(strcmp(currTrue, consonants))];
	memberInfoGuess = [sum(strcmp(currGuess, vowels)), ...
		sum(strcmp(currGuess, consonants))];
	if memberInfoTrue(1)   %if the current true phoneme is a vowel
        % features([2,5,6,7],2) = features([2,5,6,7],2) + 1;
        
        vfeature_indices=[2 5 6 7];
        %want to add to running count for nasality only if the true value
        %has a non zero vowel feature
        for vfi=1:length(vfeature_indices)
            if attributemaps{vfeature_indices(vfi)}(currTrue) ~= 0
                features(vfeature_indices(vfi),2) = features(vfeature_indices(vfi),2)+1;
            end
        end

		if ~memberInfoGuess(1);
			continue
		else
			%Height
			if attributemaps{2}(currTrue) == attributemaps{2}(currGuess) && attributemaps{2}(currTrue) ~= 0
				features(2,1) = features(2,1) + 1;
			end
			%Place
			if attributemaps{6}(currTrue) == attributemaps{6}(currGuess) && attributemaps{6}(currTrue) ~= 0
				features(6,1) = features(6,1) + 1;
			end
			%Length
			if attributemaps{7}(currTrue) == attributemaps{7}(currGuess) && attributemaps{7}(currTrue) ~= 0
				features(7,1) = features(7,1) + 1;
			end
			%Contour
			if attributemaps{5}(currTrue) == attributemaps{5}(currGuess) && attributemaps{5}(currTrue) ~= 0
				features(5,1) = features(5,1) + 1;
			end
		end
		
	elseif memberInfoTrue(2) %if the current true phoneme is a consonant
		%features([1,3,4,8,9,10],2) = features([1,3,4,8,9,10],2) + 1;
        
        cfeature_indices = [1 3 4 8 9 10];
        %want to add to running count for nasality only if the true value
        %is a nasal consonant
        for cfi=1:length(cfeature_indices)
            if attributemaps{cfeature_indices(cfi)}(currTrue) ~= 0
                features(cfeature_indices(cfi),2) = features(cfeature_indices(cfi),2)+1;
            end
        end
        
		if ~memberInfoGuess(2)
			continue
		else
			%Nasality
			if attributemaps{1}(currTrue) == attributemaps{1}(currGuess) && attributemaps{1}(currTrue) ~= 0 %addition to only add to accuracy if currTrue is a nasal consonant
                features(1,1) = features(1,1) + 1;
			end
			%Manner
			if attributemaps{3}(currTrue) == attributemaps{3}(currGuess) && attributemaps{3}(currTrue) ~= 0
				features(3,1) = features(3,1) + 1;
			end
			%Voicing
			if attributemaps{4}(currTrue) == attributemaps{4}(currGuess) && attributemaps{4}(currTrue) ~= 0
				features(4,1) = features(4,1) + 1;
			end
			%Affrication
			if attributemaps{8}(currTrue) == attributemaps{8}(currGuess) && attributemaps{8}(currTrue) ~= 0
				features(8,1) = features(8,1) + 1;
			end
			%Sibilance
			if attributemaps{9}(currTrue) == attributemaps{9}(currGuess) && attributemaps{9}(currTrue) ~= 0
				features(9,1) = features(9,1) + 1;
			end
			%Place
			if attributemaps{10}(currTrue) == attributemaps{10}(currGuess) && attributemaps{10}(currTrue) ~= 0
                %disp("consonant place was guessed correctly")
                %disp(currTrue)
                %disp(currGuess)
				features(10,1) = features(10,1) + 1;
			end
		end
	else  %if the current true phoneme is a space
		continue
	end
	
end

end

function[vowel_matrix, consonant_matrix] = matrix_constructor(realph,guessph,vowels,consonants,vowel_matrix,consonant_matrix)
vowelph = {'AA','AE','AH','AO','AW','AY','EH','ER','EY','IH','IY','OW','OY','UH','UW'};
vowel_indices = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
vowel_dict = containers.Map(vowelph, vowel_indices);

consonantph = {'B','CH','D','DH','F','G','HH','JH','K','L','M','N','NG','P','R','S','SH','T','TH','V','W','Y','Z','ZH'};
consonant_indices = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24};
consonant_dict = containers.Map(consonantph, consonant_indices);

% vowel_matrix=zeros(16,16);
% consonant_matrix=zeros(25,25);

for i = 1 : length(realph)
    currTrue = realph{i};
	currGuess = guessph{i};
    memberInfoTrue = [sum(strcmp(currTrue, vowels)), ...
		sum(strcmp(currTrue, consonants))];
	memberInfoGuess = [sum(strcmp(currGuess, vowels)), ...
		sum(strcmp(currGuess, consonants))];
    if memberInfoTrue(1)   %if the current true phoneme is a vowel
        row = vowel_dict(currTrue);
        if currGuess == "qq" 
            %col = vowel_dict(currGuess);
            vowel_matrix(row,16) = vowel_matrix(row,16)+1;
        elseif currGuess == " "
            vowel_matrix(row,16) = vowel_matrix(row,16)+1;
        else
            if isKey(vowel_dict, currGuess)
                col = vowel_dict(currGuess);
            else
                col = 16;
            end
            vowel_matrix(row,col) = vowel_matrix(row,col)+1;
        end
    elseif memberInfoTrue(2) %if the current true phoneme is a consonant
        row = consonant_dict(currTrue);
        if currGuess == "qq"        
            %col = consonant_dict(currGuess);
            consonant_matrix(row,25) = consonant_matrix(row,25)+1;
        elseif currGuess == " "
            consonant_matrix(row,25) = consonant_matrix(row,25)+1;
        else
            if isKey(consonant_dict, currGuess)
                col = consonant_dict(currGuess);
            else
                col = 25;
            end
            consonant_matrix(row,col) = consonant_matrix(row,col)+1;
        end
    else  %if the current true phoneme is a space
		continue
	end
    
end


end
