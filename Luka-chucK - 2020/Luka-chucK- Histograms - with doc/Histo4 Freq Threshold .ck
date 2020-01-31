// Histogram 4 

//Hi vs low frequency testing 
// if too much activity in higher or lower freq range 
// !NB this uses floats not strings 

float threshold; // 

[220.,440.,660.,770.,1100.,2200.] @=> float set[];


function string thresh(float set[],float threshold)
{
    "scaleDown" => string dropFreqs; // mechanism to limit frequency 
    "keep" => string normalVals; // scale things back to normal 
    
    
    0 => int exceeds;
    
    for (0 => int q; q < set.cap(); q++)
    {
        if (set[q] > threshold)
            exceeds++;
    }
    
    if (set.cap() / exceeds > 0.6)
        return dropFreqs;
    else
        return normalVals;
}


thresh(set, 500.) => string result;

<<< result >>>;
    