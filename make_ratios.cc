#include "TFile.h"
#include "TH1I.h"
#include "TH1D.h"

#include <string>
#include <vector>

using namespace std;

//----------------------------------------------------------------------------------------------------

TH1D* MakeRatio(TH1I *h_num, TH1I *h_den, string name)
{
	const auto a = h_den->GetXaxis();

	TH1D *h_rat = new TH1D(name.c_str(), ";timestamp", a->GetNbins(), a->GetXmin(), a->GetXmax());

	for (int i = 1; i <= h_num->GetNbinsX(); ++i)
	{
		unsigned int n = h_num->GetBinContent(i);
		unsigned int d = h_den->GetBinContent(i);

		double r = (d > 500) ? double(n) / d : 0.;

		h_rat->SetBinContent(i, r);
	}

	h_rat->Write();

	return h_rat;
}

//----------------------------------------------------------------------------------------------------

void MakeD(TH1D *h11, TH1D *h10, TH1D *h01)
{
	const auto a = h11->GetXaxis();
	TH1D *h_D = new TH1D("h_D", ";timestamp", a->GetNbins(), a->GetXmin(), a->GetXmax());

	for (int i = 1; i <= h11->GetNbinsX(); ++i)
	{
		double m11 = h11->GetBinContent(i);
		double m10 = h10->GetBinContent(i);
		double m01 = h01->GetBinContent(i);

		double D = (m11 > 0.) ? (m11 - (m11 + m10)*(m11 + m01)) / (m11 - m11*m11) : 0.;

		h_D->SetBinContent(i, D);
	}

	h_D->Write();
}

//----------------------------------------------------------------------------------------------------

int main(int argc, const char **argv)
{
	if (argc < 3)
		return 1;

	string inputFile = argv[1];
	string outputFile = argv[2];

	struct Ratio
	{
		string numerator;
		string denominator;
		string role;
	};

	struct Element
	{
		string name;
		vector<Ratio> ratios;
	};

	vector<Ratio> armRatios = {
		{ "h_suff_tr_no", "h_suff", "eff00" },
		{ "h_suff_tr_N", "h_suff", "eff10" },
		{ "h_suff_tr_F", "h_suff", "eff01" },
		{ "h_suff_tr_NF", "h_suff", "eff11" },
	};

	vector<Ratio> globalRatios = {
		{ "h_suff_tr_no", "h_suff", "eff00" },
		{ "h_suff_tr_L", "h_suff", "eff10" },
		{ "h_suff_tr_R", "h_suff", "eff01" },
		{ "h_suff_tr_LR", "h_suff", "eff11" },
	};

	vector<Element> elements = {
		{ "RP 2", { { "h_suff_tr", "h_suff", "eff" } } },
		{ "RP 3", { { "h_suff_tr", "h_suff", "eff" } } },
		{ "RP 23", { { "h_suff_tr", "h_suff", "eff" } } },
		{ "RP 102", { { "h_suff_tr", "h_suff", "eff" } } },
		{ "RP 103", { { "h_suff_tr", "h_suff", "eff" } } },
		{ "RP 123", { { "h_suff_tr", "h_suff", "eff" } } },

		{ "arm 0", armRatios },
		{ "arm 1", armRatios },

		{ "global 0", globalRatios },
		{ "global 1", globalRatios }
	};

	TFile *f_in = TFile::Open(inputFile.c_str());
	TFile *f_out = TFile::Open(outputFile.c_str(), "recreate");

	for (const auto &e : elements)
	{
		gDirectory = f_out->mkdir(e.name.c_str());

		TDirectory *g_el = (TDirectory *) f_in->Get(e.name.c_str());

		if (!g_el)
		{
			printf("WARNING: cannot find element `%s`\n", e.name.c_str());
			continue;
		}

		TH1D *h11=NULL, *h10=NULL, *h01=NULL;

		for (const auto &r : e.ratios)
		{
			TH1I *h_num = (TH1I *) f_in->Get((e.name + "/" + r.numerator).c_str());
			TH1I *h_den = (TH1I *) f_in->Get((e.name + "/" + r.denominator).c_str());

			auto h = MakeRatio(h_num, h_den, r.numerator + " OVER " + r.denominator);

			if (r.role == "eff11") h11 = h;
			if (r.role == "eff10") h10 = h;
			if (r.role == "eff01") h01 = h;
		}

		if (h11 && h10 && h01)
			MakeD(h11, h10, h01);
	}

	delete f_in;
	delete f_out;

	return 0;
}
