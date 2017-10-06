package data_processing.models;
import data_processing.filter.FIR;

public class PI003 {
	private FIR f1;
	private FIR f2;
	private double output;
	private double ct;
	private double k1;
	private double k2;
	private double k3;
	private double e0;
	
	public PI003() {
		f1 = new FIR("etc", "pi003_01.fc");
		f2 = new FIR("etc", "pi003_02.fc");
		output = 0;
	}
	
	public double feed(double val) {
		double f1Out = f1.feed(val);
		output = f2.feed(f1Out);
		return output;
	}
	
	public double getOutput() {
		return output;
	}
}