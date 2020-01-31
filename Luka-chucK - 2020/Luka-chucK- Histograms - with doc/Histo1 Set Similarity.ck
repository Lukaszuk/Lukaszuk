// Histogram 1 
// What this does: compares the contents of two data sets , gives degree of similarity from a range 0. - 1.0 , i.e. 0-100%


// arrays for now have to be the same size 
fun float histo2(string pches[], string pches2[], int sameorDiff)
{
    //   <<< "test", testFreq >>>;
    
    0 => int amount_numb; // needs to be converted to float for the division later on
    
    float similarity;
    float difference;
    
    for (0 => int f; f < pches.cap(); f++)
    {
        
        if (pches[f] == pches2[f])
        {    amount_numb++;}
        
        // amount tells us how many pitches they have in common
        // now, what % of the amount of the array is shared pitches
        
        // does this owrk?
        
        
    }
    <<< amount_numb, pches.cap() >>>;
    
    amount_numb => float amount_float;
    
    amount_float / pches.cap() =>  similarity;
    1.0 - similarity =>  difference;
    
    float setRelation;
    
    if (sameorDiff == 1)
        similarity => setRelation;
    else
        difference => setRelation;
    
    
    return setRelation;
    
    
    <<< setRelation >>>;
}

fun void pitchSets(string notes[], string notes2[], int testIt)
{
    
    histo2(notes, notes2, testIt) => float hi;
    
    <<< hi >>>;
    
}


fun void histAct(int scanTime)
{
while (true)
{

spork ~ pitchSets(["hi","bye","you","me"],["hi","bye","you","she"],1); 

// the returned int represents degree of similarity between the two sets, similar = 1 , difference = 0 for the 3rd argument
scanTime::second => now;
}
}


spork ~ histAct(60);
1::day => now;
// NB - a similarity degree of "1.0" = exactly the same sets 
// on a set with 4 classes, if 3 are same the returned val will be 0.75, 3/4 = 0.75, 2 the same = 50%, so 0.5