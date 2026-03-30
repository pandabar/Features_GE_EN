dir$= "/home/fernanda/Desktop/audio_projekt"
first=Create Strings as file list: "list1", dir$ + "/first/*.wav"
n1=Get number of strings
second=Create Strings as file list: "list2", dir$ + "/second/*.wav"
n2= Get number of strings


selectObject: first
for i to n1
sound1string$= Get string: i
s1$ =replace$ (sound1string$, ".wav", "", 0)
beg1$=left$(s1$, 2)
s11$= replace_regex$(s1$, beg1$, "", 0)
firstsound= Read from file: dir$ + "/first/"  + sound1string$
selectObject: second
sound2string$= Get string: i
s2$ =replace$ (sound2string$, ".wav", "", 0)
beg2$=left$(s2$, 2)
s22$= replace_regex$(s2$, beg2$, "", 0)
isi1500= Create Sound from formula: "isi1500", 1, 0, 1.5, 44100, "0"
secsound= Read from file: dir$ + "/second/"  + sound2string$
selectObject: firstsound, isi1500, secsound
Concatenate
Rename: s11$  + "1500" + s22$
selectObject: isi1500
isiagain= Copy: "1500"
selectObject: firstsound
firstagain=Copy: s11$
selectObject: secsound
secondagain=Copy: s22$
selectObject: secsound, isiagain, firstagain
Concatenate
Rename: s22$ + "1500" + s11$
selectObject: firstsound, isi1500, firstagain
Concatenate
Rename: s11$ + "1500" + s11$
selectObject: secsound, isiagain, secondagain
Concatenate
Rename: s22$ + "1500" + s22$
selectObject:first
endfor


