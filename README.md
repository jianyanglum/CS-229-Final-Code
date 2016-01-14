# CS-229-Final-Code
This was the code used for the Stanford University CS 229 (Machine Learning) final project, in which we used features extracted from a Bach corpus (features in the repo itself, sources: music21 and http://scores.ccarh.org/bach/chorale/).
A list of features were extracted, which includes:

Features from chorales as a whole:
-	Dissonance (Formed from diminishedSeventhSimultaneityPrevalence + diminishedTriadSimultaneityPrevalence features. Percentage of all simultaneities that are either diminished seventh diminished triad chords.)

-	Prevalence of major vs. minor chords (majorTriadSimultaneityPrevalence - minorTriadSimultaneityPrevalence. Percentage of all simultaneities that are major triads - minor triads.)

Features used in both:
-	Note range (PCA of rangeFeature and pitchVariety. Difference between the highest and lowest pitches and the number of pitches used at least once.)

-	Average melodic interval

-	Chromaticism vs diatonicism (chromaticMotion - stepwiseMotion. Fraction of melodic intervals corresponding to a semitone - fraction of intervals corresponding to a minor or major second.)

-	Melodic contour (durationOfMelodicArcs. Average number of notes that separate peaks and troughs.)

-	Melodic tempi (PCA of averageNoteDuration and noteDensity. Average duration of notes in seconds and the average number of notes per second, using tempo markings.)

-	Phrase structure (proxied by repeatedNotes. Fraction of notes that are repeated melodically.)

-	Amount of arpeggiation(Fraction of horizontal intervals that are repeated notes, minor thirds, major thirds, perfect fifths, minor sevenths, major sevenths, octaves, minor tenths or major tenths.)

Four ML tools were applied to this: 
On the chorales as a whole we used Expectation-Maximization and k-means, and on individual voices we used softmax/multinomial logistic regression and k-means. 
Results are attached in the pdf, but the code here will produce graphs as well as csvs that highlight the answers. I ran this in RStudio.
