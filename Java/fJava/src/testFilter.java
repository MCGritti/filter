import data_processing.filter.FIR;

public class testFilter {
	static public void main(String[] args) {
		FIR f1 = new FIR("etc", "first.fc");
		for(int i = 0; i < 50; i++) {
			f1.feed(i);
			System.out.printf("Input: %2d, Output: %.2f\n", i, f1.getOutput());
		}
	}
}