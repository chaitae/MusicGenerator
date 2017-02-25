
public class GetNotes {
  String chooseOctave(int octave, char note)
  {
    return note+Integer.toString(octave);
  }
  ArrayList<Float> getMeasure(int measureLength)
  {
    float currentBeat = 0;
    ArrayList<Float> measure = new ArrayList<Float>();
    while (currentBeat < measureLength)
    {
      int random  = (int) random(0, 5-currentBeat);
      float beat = beatList[random];
      if(currentBeat + beat <=measureLength)
      {
        currentBeat += beat;
        measure.add(beat);
      }
    }
    return measure;
  }
  ArrayList<String> makeScale(String rules, String rootNote)
  {
    Convert conv = new Convert();
    int freqIndex = conv.toFreqIndex(rootNote);
    ArrayList<String> scale = new ArrayList<String>();
    for (int i = 0; i<rules.length(); i++)
    {
      scale.add(noteNames[freqIndex]);
      int hop;
      if (rules.charAt(i) == 'W')
      {
        hop = 2;
      } else
      {
        hop = 1;
      }
      freqIndex = freqIndex + hop;
    }
    scale.add(noteNames[freqIndex]);
    return scale;
  }
  String getNextBaseNote(int numRotations, String baseNote)
  {
    numRotations = numRotations-1;
    char initChara = baseNote.charAt(0);
    ArrayList<Character> scale  = new ArrayList<Character>();
    for (char i = 'A'; i<'H'; i++)
    {
      scale.add(i);
    }
    Collections.reverse(scale);
    while (scale.get(0) != initChara)
    {
      Collections.rotate(scale, 1);
    }
    Collections.rotate(scale, numRotations);
    //print(scale);
    return scale.get(0)+"";
  }

  // chord progressions http://www.guitarhabits.com/building-chords-and-progressions-of-the-major-scale/
  //gets list of chords associated with chord progression
  ArrayList<Integer> getProgression(String progression)
  {
    Convert conv = new Convert();
    ArrayList<Integer> progList = conv.toNumberList("1 4 5");
    for (int i = 0; i<progList.size(); i++)
    {
      int temp = progList.get(i);
      progList.set(i, temp-1);
    }
    return progList;
  }
  //Just generate N random numbers, compute their sum, divide each one by the sum. AND multiply by the wanted number
  ArrayList<Float> getPatterns(int numNotes)
  {
    int measureLength = 4;
    float sum = 0;
    ArrayList<Float> rhythmList = new ArrayList<Float>();
    for (int i = 0; i<numNotes; i++)
    {
      float rand = random(0, measureLength);
      sum = (float)sum + rand;
      rhythmList.add(rand);
    }
    for (int i = 0; i<rhythmList.size(); i++)
    {
      float temp = rhythmList.get(i);
      rhythmList.set(i, temp/sum*measureLength);
    }
    return rhythmList;
  }
  boolean isValid(int num)
  {
    if (num > 87) return false;
    if (num < 0) return false;
    return true;
  }      


  //Reads in string intervals gets the key for each note
  ArrayList<String> getChord(String intervals, String noteName, int range)
  {
    Convert conv = new Convert();
    int freqIndex = conv.toFreqIndex(noteName);
    ArrayList<String> noteList = new ArrayList<String>();
    intervals = intervals.replace("(", "");
    intervals = intervals.replace(")", "");
    String[] notes = intervals.split(" ");
    int octaveSize = 12; // this is in semitones
    for (int i = 1; i<notes.length; i++)
    {
      int noteNumber = Integer.parseInt(notes[i]);
      if (noteNumber != 0)
      {
        for (int k = 1; k<range; k++)
        {
          int offsetNumberBelow = noteNumber+(-octaveSize*k) + freqIndex;
          int offsetNumberAbove = noteNumber+(octaveSize*k) + freqIndex;
          if (isValid(offsetNumberBelow) && offsetNumberBelow != 0)
          {
            String note = noteNames[noteNumber+(-octaveSize*k)+ freqIndex];
            noteList.add(note);
          }
          if (isValid(offsetNumberAbove) && offsetNumberAbove != 0)
          {
            String note = noteNames[noteNumber+(octaveSize*k)+ freqIndex];
            noteList.add(note);
          }
        }
        if (isValid(noteNumber+freqIndex) && noteNumber+freqIndex != 0)
        {
          String note = noteNames[noteNumber+ freqIndex];
          noteList.add(note);
        }
      }
    }
    String note = noteNames[freqIndex];
    noteList.add(note);

    return noteList;
  }
}