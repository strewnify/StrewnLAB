function [clean_s] = removediacritics(s)
%REMOVEDIACRITICS Removes diacritics from text.
%   This function removes many common diacritics from strings, such as
%     � - the acute accent
%     � - the grave accent
%     � - the circumflex accent
%     � - the diaeresis, or trema, or umlaut
%     � - the tilde
%     � - the cedilla
%     � - the ring, or bolle
%     � - the slash, or solidus, or virgule

% uppercase
s = regexprep(s,'(?:�|�|�|�|�|�)','A');
s = regexprep(s,'(?:�)','AE');
s = regexprep(s,'(?:�)','ss');
s = regexprep(s,'(?:�)','C');
s = regexprep(s,'(?:�)','D');
s = regexprep(s,'(?:�|�|�|�)','E');
s = regexprep(s,'(?:�|�|�|�)','I');
s = regexprep(s,'(?:�)','N');
s = regexprep(s,'(?:�|�|�|�|�|�)','O');
s = regexprep(s,'(?:�)','OE');
s = regexprep(s,'(?:�|�|�|�)','U');
s = regexprep(s,'(?:�|�)','Y');

% lowercase
s = regexprep(s,'(?:�|�|�|�|�|�)','a');
s = regexprep(s,'(?:�)','ae');
s = regexprep(s,'(?:�|?)','c');
s = regexprep(s,'(?:�)','d');
s = regexprep(s,'(?:�|�|�|�)','e');
s = regexprep(s,'(?:?)','g');
s = regexprep(s,'(?:�|�|�|�)','i');
s = regexprep(s,'(?:?)','k');
s = regexprep(s,'(?:?)','l');
s = regexprep(s,'(?:�|?)','n');
s = regexprep(s,'(?:�|�|�|�|�|�)','o');
s = regexprep(s,'(?:�)','oe');
s = regexprep(s,'(?:�)','s');
s = regexprep(s,'(?:�|�|�|�)','u');
s = regexprep(s,'(?:�|�)','y');
s = regexprep(s,'(?:�)','z');

% return cleaned string
clean_s = s;
end

