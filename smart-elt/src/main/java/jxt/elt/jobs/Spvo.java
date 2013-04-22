package jxt.elt.jobs;

public class Spvo {

	public Spvo() {

	}

	public Spvo(int spId, int kcsl, int wcdsl) {
		super();
		this.spId = spId;
		this.kcsl = kcsl;
		this.wcdsl = wcdsl;
	}

	int spId;

	int kcsl;

	int wcdsl;

	public int getSpId() {
		return spId;
	}

	public void setSpId(int spId) {
		this.spId = spId;
	}

	public int getKcsl() {
		return kcsl;
	}

	public void setKcsl(int kcsl) {
		this.kcsl = kcsl;
	}

	public int getWcdsl() {
		return wcdsl;
	}

	public void setWcdsl(int wcdsl) {
		this.wcdsl = wcdsl;
	}
}
