public class Cup {
    private Double volume;  // Corrected spelling from 'volumn' to 'volume'
    private final Double maxVolume;

    // Constructor to initialize the cup with an optional max volume
    public Cup(Double maxVolume) {
        this.volume = 0.0;
        this.maxVolume = maxVolume;  // Use 250 if maxVolume is null
    }

    public Cup() {
        this.volume = 0.0;
        this.maxVolume = 250.0;  // Use 250 if maxVolume is null
    }

    // Method to add liquid to the cup
    public void add(Double volume) {
        if (this.volume + volume <= this.maxVolume) {
            this.volume += volume;
            System.out.println("Added " + volume + " units of liquid. Current volume: " + this.volume);
        } else {
            System.out.println("Cannot add that much liquid. Cup will overflow.");
        }
    }

    public void pour(Double volume) {
        if (volume > this.volume) {
            System.out.println("Out of liquid, short" + (volume - this.volume));
            this.volume = 0.0;
        }
        if (this.volume == 0) {
            System.out.println("cup is empty");
        }

        this.volume -= volume;
    }

    public Double getVolume() {
        return volume;
    }
}
