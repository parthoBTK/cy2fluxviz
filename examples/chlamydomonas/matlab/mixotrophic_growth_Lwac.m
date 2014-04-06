%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% light, aerobic, w/ acetate, biomass objective
model=readCbModel('C:\Users\mjkijsc4\Dropbox\PHD\MatlabWork\Models\ICR50changcorrectedPSII')
% Measures and constants.

DW = 48*10^(-12); % avg. dry weight of log phase chlamy cell = 48 pg (Mitchell 1992)
CPerStarch300 = 1800; % derived from starch300 chemical formula
ChlPerCell = (13.9+4)/(10^7); % 13.9 +- 4 micrograms Chl/10^7 cells (Gfeller 1984)
starchDegAnLight = (4.95+1.35)*(1/1000)*(1/CPerStarch300)*(ChlPerCell/1000)*(1/DW); % approx. SS rate of anaerobic starch degradation in light = 4.95 +- 1.35 micromol C/mg Chl/hr (Gfeller 1984)
starchDegAerLight = (2/3)*starchDegAnLight; % approx. SS rate of aerobic starch degradation in light = 2/3 of anaerobic rate (Gfeller 1984)
starchDegAnDark = (13.1+3.5)*(1/1000)*(1/CPerStarch300)*(ChlPerCell/1000)*(1/DW); % approx. SS rate of anaerobic starch degradation in dark = 13.1 +- 3.5 micromol C/mg Chl/hr (Gfeller 1984)
starchDegAerDark = (2/3)*starchDegAnDark; % approx. SS rate of aerobic starch degradation in dark = 2/3 of anaerobic rate (Gfeller 1984)
dimensionalConversion = 3.836473679; % from emitted microE/m^2/s to incident mmol/gDW/hr
effectiveConversion = 0.037532398; % from incident mmol/gDw/hr to effective mmol/gDw/hr

modelLwac = model;
% The single PRISM reaction being used has to be commented-out below.
modelLwac = changeRxnBounds(modelLwac,'PRISM_solar_litho',0,'b');
modelLwac = changeRxnBounds(modelLwac,'PRISM_solar_exo',0,'b');    
modelLwac = changeRxnBounds(modelLwac,'PRISM_incandescent_60W',0,'b');    
modelLwac = changeRxnBounds(modelLwac,'PRISM_fluorescent_warm_18W',0,'b'); 
modelLwac = changeRxnBounds(modelLwac,'PRISM_fluorescent_cool_215W',0,'b'); 
modelLwac = changeRxnBounds(modelLwac,'PRISM_metal_halide',0,'b');   
modelLwac = changeRxnBounds(modelLwac,'PRISM_high_pressure_sodium',0,'b');    
modelLwac = changeRxnBounds(modelLwac,'PRISM_growth_room',0,'b');
modelLwac = changeRxnBounds(modelLwac,'PRISM_white_LED',0,'b');   
%modelLwac = changeRxnBounds(modelLwac,'PRISM_red_LED_array_653nm',0,'b');     
modelLwac = changeRxnBounds(modelLwac,'PRISM_red_LED_674nm',0,'b');
modelLwac = changeRxnBounds(modelLwac,'PRISM_design_growth',0,'b');    

modelLwac = changeRxnBounds(modelLwac,'CEF',100,'u');  %turn on CEF



modelLwac = changeRxnBounds(modelLwac,'EX_O2(e)',-10,'l');
modelLwac = changeRxnBounds(modelLwac,'EX_ac(e)',-100,'l');%presence of acetate
modelLwac = changeRxnBounds(modelLwac,{'EX_starch(h)'},0,'b');
modelLwac = changeRxnBounds(modelLwac,'STARCH300DEGRA',starchDegAerLight/2,'u');
modelLwac = changeRxnBounds(modelLwac,'STARCH300DEGR2A',0,'u');
modelLwac = changeRxnBounds(modelLwac,'STARCH300DEGRB',starchDegAerLight/2,'u');
modelLwac = changeRxnBounds(modelLwac,'STARCH300DEGR2B',0,'u');
modelLwac = changeRxnBounds(modelLwac,{'PCHLDR'},0,'b'); % the light-independent protochlorophyllide reductase is not expressed in light due to translational inhibition caused by chloroplast redox state [Cahoon 2000]
modelLwac = changeRxnBounds(modelLwac,{'PFKh'},0,'b'); % plastidic PFKh inactivated by light (Plaxton 1996)
modelLwac = changeRxnBounds(modelLwac,{'G6PADHh','G6PBDHh'},0,'b'); % light inhibits G6PDHh of oxidative pentose phosphate pathway (Plaxton 1996)
modelLwac = changeRxnBounds(modelLwac,{'FBAh'},0,'b'); % light inactivates FBAh (Lemaire 2004; Matsumoto 2008)
modelLwac = changeRxnBounds(modelLwac,{'H2Oth'},0,'u'); % there is a high h2o requirement in [h]; however, experiments show that h2o in general goes from [h] to [c] in light and from [c] to [h] in dark (Packer 1970)
modelLwac = changeRxnBounds(modelLwac,{'Biomass_Chlamy_auto','Biomass_Chlamy_hetero'},0,'b');



modelLwac = changeObjective(modelLwac,'Biomass_Chlamy_mixo');



% Base growth
solutionLwac = optimizeCbModel(modelLwac,'max','one')
