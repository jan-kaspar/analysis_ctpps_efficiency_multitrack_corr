import root;
import pad_layout;

string topDir = "../data/";

int timestamp0 = 1451602800;

string periods[];
real p_x_mins[], p_x_maxs[];
periods.push("2016_preTS2"); p_x_mins.push(0); p_x_maxs.push(0);
periods.push("2016_postTS2"); p_x_mins.push(0); p_x_maxs.push(0);
periods.push("2017_preTS2"); p_x_mins.push(0); p_x_maxs.push(0);
periods.push("2017_postTS2"); p_x_mins.push(0); p_x_maxs.push(0);

string elements[], e_labels[];
elements.push("global 0"); e_labels.push("near RPs");
elements.push("global 1"); e_labels.push("far RPs");

string quantities[], q_labels[];
pen q_pens[];
quantities.push("h_D"); q_labels.push("D"); q_pens.push(magenta);

xSizeDef = 50cm;

TGraph_errorBar = None;

//----------------------------------------------------------------------------------------------------

NewPad();

for (int ei : elements.keys)
	NewPadLabel(e_labels[ei]);

for (int pi : periods.keys)
{
	NewRow();

	NewPad(false);
	label("{\SetFontSizesXX " + replace(periods[pi], "_", "\_") + "}");

	for (int ei : elements.keys)
	{
		NewPad("days from 1 Jan 2016", "efficiency");

		string f = topDir + periods[pi] + "/SingleMuon/ratios.root";

		for (int qi : quantities.keys)
		{
			RootObject obj = RootGetObject(f, elements[ei] + "/" + quantities[qi], error=false);
			if (obj.valid)
				draw(scale(1./24/3600, 1.) * shift(-timestamp0), obj, "d0,vl", q_pens[qi]);
		}
		
		//limits((x_mins[ri], 0.4), (x_maxs[ri], 1.), Crop);
	}
}

//----------------------------------------------------------------------------------------------------

NewPad(false);
for (int qi : quantities.keys)
	AddToLegend(q_labels[qi], q_pens[qi]);
AttachLegend();

GShipout(hSkip=2mm, vSkip=0mm);
