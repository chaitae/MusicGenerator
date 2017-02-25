public class Convert {
  int toFreqIndex(String note)
  {
    for (int i = 0; i<noteNames.length; i++)
    {
      if (noteNames[i].contains(note))
      {
        return i;
      }
    }
    return -1;
  }
  ArrayList<Float> toChordFreq(ArrayList<Integer> noteOffset, int freqIndex)
  {
    ArrayList<Float> chords = new ArrayList<Float>();
    for (int i = 0; i<noteOffset.size(); i++)
    {
      float freqNote = Float.parseFloat(freqList[noteOffset.get(i)]);
      chords.add(freqNote);
    }
    chords.add(Float.parseFloat(freqList[freqIndex]));
    Collections.sort(chords);
    return chords;
  }
   ArrayList<Integer> toNumberList(String intervals)
  {
    ArrayList<Integer> noteList = new ArrayList<Integer>();
    intervals = intervals.replace("(", "");
    intervals = intervals.replace(")", "");
    String[] notes = intervals.split(" ");
    for (int i = 0; i<notes.length; i++)
    {
      noteList.add(Integer.parseInt(notes[i]));
    }
    return noteList;
  }
}