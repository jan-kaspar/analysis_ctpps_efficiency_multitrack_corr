import root;
import pad_layout;

string topDirOld = "../../efficiency_multitrack/";
string topDir = "../data/";

int timestamp0 = 1451602800;

string periods[];
real p_x_mins[], p_x_maxs[];
periods.push("2016_preTS2"); p_x_mins.push(0); p_x_maxs.push(0);
periods.push("2016_postTS2"); p_x_mins.push(0); p_x_maxs.push(0);
periods.push("2017_preTS2"); p_x_mins.push(0); p_x_maxs.push(0);
periods.push("2017_postTS2"); p_x_mins.push(0); p_x_maxs.push(0);

string rps[], rp_labels[];
rps.push("3"); rp_labels.push("45-210-fr-hr");
rps.push("2"); rp_labels.push("45-210-nr-hr");
rps.push("102"); rp_labels.push("56-210-nr-hr");
rps.push("103"); rp_labels.push("56-210-fr-hr");

string quantityOld = "p_eff_pat_suff_or_tooFull_vs_time";

string quantity = "h_suff_tr OVER h_suff";

//xTicksDef = LeftTicks(5., 1.);

xSizeDef = 50cm;

TGraph_errorBar = None;

//----------------------------------------------------------------------------------------------------

NewPad();

for (int rpi : rps.keys)
{
	NewPad(false);
	label("{\SetFontSizesXX " + rp_labels[rpi] + "}");
}

for (int pi : periods.keys)
{
	NewRow();

	NewPad(false);
	label("{\SetFontSizesXX " + replace(periods[pi], "_", "\_") + "}");

	for (int rpi : rps.keys)
	{
		NewPad("days from 1 Jan 2016", "efficiency");

		{
			string f = topDirOld + periods[pi] + "/ZeroBias/make_ratios.root";

			RootObject obj = RootGetObject(f, rps[rpi] + "/" + quantityOld, error=false);
			if (obj.valid)
				draw(scale(1./24/3600, 1.) * shift(-timestamp0), obj, "d0,vl,eb", blue);
		}

		{
			string f = topDir + periods[pi] + "/SingleMuon/ratios.root";

			RootObject obj = RootGetObject(f, "RP " + rps[rpi] + "/" + quantity, error=false);
			if (obj.valid)
				draw(scale(1./24/3600, 1.) * shift(-timestamp0), obj, "d0,vl", red);
		}
		
		//limits((x_mins[ri], 0.4), (x_maxs[ri], 1.), Crop);
	}
}

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("old", blue);
AddToLegend("new", red);
AttachLegend();

GShipout(hSkip=2mm, vSkip=0mm);
