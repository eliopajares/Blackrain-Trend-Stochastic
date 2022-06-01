//+-------------------------------------------+
//|                      Blackrain Trend      |
//|                 Property of: Elio Pajares |
//|                   v0.0.1   31 - 05 - 2022 |
//+-------------------------------------------+
#property description "Blackrain Trend 0.0.1 Stochastic"
#property copyright   "Copyright © 2022, Elio Pajares"
//#property link        "http://www.blackrainalgo.com"

//+------------------------------------------------------------------+
//| DESCRIPTION                                                      |
//+------------------------------------------------------------------+

//##########################################
//## Walk Forward Pro Header Start (MQL4) ##
//##########################################
//#import "TSMWFP.ex4"
//void WFA_Initialise();
//void WFA_UpdateValues();
//void WFA_PerformCalculations(double &dCustomPerformanceCriterion);
//#import
//########################################
//## Walk Forward Pro Header End (MQL4) ##
//########################################

//+------------------------------------------------------------------+
//| INPUT PARAMETERS                                                 |
//+------------------------------------------------------------------+


input int    magic_number  = 12345 ; //change magic number when same EA used in the same account to avoid overlap issues with open orders
//input string pair          = "EURUSD"; //currency pair

extern string  data_1 = "==== SL, TP, TS ====";
input bool     AllowOrders   = true;
input int      orders        = 1;
input int      spread        = 20; // value in points
//input double   StopLoss      = 20; // SL is used Lotsize calculation via % balance at risk
//input double   TakeProfit    = 40; // TP is unlimited
input          ENUM_TIMEFRAMES LOW_TF = PERIOD_H1;
input          ENUM_TIMEFRAMES MED_TF = PERIOD_H4;
input          ENUM_TIMEFRAMES HIGH_TF = PERIOD_D1;
input int      time_between_trades = -1; //value in seconds of the time between a loss trade and a new one,  -1 for not using this

extern string  data_2 = "==== Management of trade setup ====";
input bool     pyramidying = false;
input bool     management_trade = false;
input bool     breakeven     = false;
input bool     close_trade     = true;
//input int      rsi_inv_upper    = 10;
//input int      rsi_inv_lower    = 90;
input int      stoch_inv_upper  = 80;
input int      stoch_inv_lower  = 20;
//input int      pips_invalidation= 5;
input bool     trailing      = true; //
input double   TrailingStop  = 20; //
input double   TS_RRratio_step = 2; //TS step in regards RR ratio
input double   TS_RRratio_sl = 1; //TS stoploss distance in regards RR ratio
input bool     CloseOnDuration = false;
input int      MaxDurationHours = 1000; //in hours
input int      MaxDurationMin   = 0; //in minutes
input bool     CloseFridays    = false;
// input bool     retrace         = false;
// input double   PipsStick     = 40;
// input double   PipsRetrace   = 20;

extern string  data_3 = "==== Money management ====";
input double   Lots         = 0.1;
input bool     MM           = true;
input double   Risk         = 0.25;
input double   RR           = 3;
input double   maxlots      = 1;

// extern string  data_4 = "==== EMA parameters ====";
//input int      EMA           = 200;
// input int      EMA_Fast      = 10;
// input int      EMA_Slow      = 20;
// input int      macd_signal   = 7;
//input          ENUM_TIMEFRAMES LOW_TF = PERIOD_M5;
//input int      MA_count      = 8;
//input int      MA_Period_H1  = 7;

extern string  data_5 = "==== ATR parameters ====";
input int      ATR_period     = 20;
input double   ATR_SL_factor  = 2;

//extern string  data_5 = "==== RSI parameters ====";
//input int      RSIperiod      = 7; //RSI period
////input int      RSIUpper       = 70; // RSI Upper limit
////input int      RSILower       = 30; // RSI Lower limit
//input int      RSI_range      = 30;

extern string  data_6 = "==== Stochastic parameters ====";
input int      KPeriod        = 100; // K Period
input int      DPeriod        = 7; // D Period
input int      Slowing        = 9;  // Slowing value
//input int      StochUpper     = 70; // Stochastic Upper limit
//input int      StochLower     = 30; // Stochastic Lower limit
input int      Stoch_range    = 30;

// extern string  data_7 = "==== SAR parameters ====";
// input double   SAR_step_low   = 0.04; // SAR Step parameter
// input double   SAR_step_med   = 0.04; // SAR Step parameter
// input double   SAR_step_high  = 0.005; // SAR Step parameter
// input double   SAR_max        = 0.2; // SAR max parameter

extern string  data_8 = "==== Days to Trade ====";
input bool     Sunday         = true;
input bool     Monday         = true;
input bool     Tuesday        = true;
input bool     Wednesday      = true;
input bool     Thursday       = true;
input bool     Friday         = true;

extern string  data_9 = "==== Hours to Trade ====";
input int      StartHourTrade = 0; // 0 for beginning of the day
input int      EndHourTrade   = 23; // 23 for end of the day

extern string  data_10 = "==== Days to Trade ====";
input bool     January        = true;
input bool     February       = true;
input bool     March          = true;
input bool     April          = true;
input bool     May            = true;
input bool     June           = true;
input bool     July           = true;
input bool     August         = true;
input bool     September      = true;
input bool     October        = true;
input bool     November       = true;
input bool     December       = true;

//extern string data_6 = "==== News ====";
//input bool   ActivateNews      = false;
//input int    MinsBeforeNews    = 60;
//input int    MinsAfterNews     = 60;
//input bool   IncludeHighNews   = true;
//input bool   IncludeMediumNews = false;
//input bool   IncludeLowNews    = false;
//input bool   IncludeSpeakNews  = true;
//input bool   IncludeHolidays   = false;
//input int    DSTOffsetHours    = 0;


//input int    spread          = 0;
//input bool   risk_balance_noSL = true;
//input bool   risk_balance_SL   = false;
//input bool   risk_equity_SL    = false;
//input bool   risk_freemargin   = false;

//int CurrentTime;
int Slippage = 3;
int vSlippage;
int ticket;
// int ticket_1,ticket_2,ticket_3;
int total_orders;
// int count_1,count_2;
int current_spread;
int i,ii;
// int RSIUpper,RSILower;
int StochUpper,StochLower;
   
//double init_lots;
double LotDigits = 2;
double trade_lots;
double vPoint; 
double ma_M5,ma_ema;
// double rsi;
// double stochastic;
// double ma_Slow,ma_Fast;
// double stochastic_0,stochastic_1;
//double ma_Fast_0,ma_Slow_0;
//double ma_Fast_1,ma_Slow_1;
//double macd_main_0,macd_main_1,macd_main_2,macd_signal_0,macd_signal_1,macd_signal_2;
// double macd_main_med_0,macd_main_med_1,macd_signal_med_0,macd_signal_med_1;
double stochastic_main_med_0,stochastic_main_med_1,stochastic_main_med_2;
double stochastic_signal_med_0,stochastic_signal_med_1,stochastic_signal_med_2;
// double ma_med_10_0,ma_med_10_1,ma_med_10_2,ma_med_20_0,ma_med_20_1,ma_med_20_2;
// double SAR_med_0,SAR_med_1;
// double turtle_0,turtle_1,turtle_2;
double ATR_med_0;
double stochastic_main_med_1_100,stochastic_main_med_2_100,stochastic_signal_med_1_100,stochastic_signal_med_2_100;
//double stochastic_H1_0,stochastic_H1_1;
//double ma_H1_10_1,ma_H1_10_2,ma_H1_20_1,ma_H1_20_2;
//double ma_100_1,ma_100_2,ma_200_1,ma_200_2;
// double ma_H1;
//double rsi_H1;
//double ma_10,ma_20;
double SL,TP,diff,SL_dist;
//string data_parameters;
//string data_news;
//
//bool NewsTime;
//bool OpenBar;

//+------------------------------------------------------------------+
//|  INIT FUNCTION                                                   |
//+------------------------------------------------------------------+

int OnInit()
   {
   
   //## Walk Forward Pro OnInit() code start (MQL4) ##
   //if(MQLInfoInteger(MQL_TESTER))
   //WFA_Initialise();
   //## Walk Forward Pro OnInit() code end (MQL4) ##
   
   //CurrentTime= Time[0];

//+------------------------------------------------------------------+
//|  Detect 3/5 digit brokers for Point and Slippage                 |
//+------------------------------------------------------------------+
   
   if(Point==0.00001)
      { vPoint=0.0001; vSlippage=Slippage *10;}
   else
      {
      if(Point==0.001)
        { vPoint=0.01; vSlippage=Slippage *10;}
      else vPoint=Point; vSlippage=Slippage;
      }
   
   //RSIUpper = 100 - RSI_range;
   //RSILower = RSI_range;
   
   StochUpper = 100 - Stoch_range;
   StochLower = Stoch_range;
   
   
   return(0);
   }

//+------------------------------------------------------------------+
//|  MAIN PROGRAM                                                    |
//+------------------------------------------------------------------+

void OnTick()
  {

   //## Walk Forward Pro OnTick() code start (MQL4) ##
   //if(MQLInfoInteger(MQL_TESTER))
   //WFA_UpdateValues();
   //## Walk Forward Pro OnTick() code end (MQL4) ##

//+------------------------------------------------------------------+
//| PARAMETERS IN SCREEN                                             |
//+------------------------------------------------------------------+  

//   if(IsTesting())
//      {
//      return;
//      }
//      else
//      {
//      if (ActivateNews)
//         {
//         if (NewsHandling() == 1)
//            {
//            NewsTime = TRUE;
//            }
//            else
//            {
//            NewsTime = FALSE;
//            }
//         }
//      
//      double nTickValue=MarketInfo(Symbol(),MODE_TICKVALUE);   
//      data_parameters = 
//           "\n                              Blackrain Scalper 0.0.1" 
//         + "\n                              magic number = " + magic_number 
//         + "\n                              stoploss = " + StopLoss 
//         + "\n                              takeprofit = " + TakeProfit
//         + "\n                              trailingstop = " + TrailingStop 
//         //+ "\n                              PipsStick = " + PipsStick 
//         //+ "\n                              PipsRetrace = " + PipsRetrace 
//         + "\n                              risk = " + Risk + "%" 
//         + "\n                              lots = " + GetLots() /*init_lots*/
//         //+ "\n                              Balance = " + AccountBalance()
//         //+ "\n                              nTik = " + nTickValue
//         ;
//      
//      //Assembly of parameters shown in screen
//      
//      if (ActivateNews)
//         {
//         if (NewsTime)
//            {
//             data_parameters = data_parameters + data_news
//             + "\n                              TRADING NOT ALLOWED, NEWS TIME!";
//            } 
//            else
//            {
//            if (!NewsTime)
//               {
//               data_parameters = data_parameters + data_news
//               + "\n                              TRADING ALLOWED, NO NEWS TIME";
//               }
//            }
//         }
//      }   
//      
//      Comment(data_parameters);         
                  
      
//+------------------------------------------------------------------+
//| INITIAL DATA CHECKS                                              |
//+------------------------------------------------------------------+

   //if(Bars<100)
   //  {
   //   Print("bars less than 100");
   //   return;
   //  }

      //if(AccountFreeMargin()<(1000*Lots))
      //  {
      //   Print("We have no money. Free Margin = ",AccountFreeMargin());
      //   return;
      //  }
//+------------------------------------------------------------------+
//| OPENING CRITERIAS                                                |
//+------------------------------------------------------------------+
   
// DONE BASELINE HAS TO BE 0.0.1   
// DONE ADD SPREAD CONTROL (Bid-Ask) for opening a trade
// DONE REDUCE SLIPPAGE FROM 2 TO 1(?)
// DONE RESEARCH BETTER WAYS OF LOOKING AT THE TREND (example: H1 MA7 count 8 times lower/higher than previous periods)
// ADD NEWS TRADING TIME
// CHECK OTHER TESTS/ROBUSTENESS CHECKS FROM STRATEGYQUANT CODE
// AVOID TRADING CONSECUTIVE TIMES IF THE FIRST ORDER TOUCH STOPLOSS UNDER THE OPENING CONDITIONS, THIS AVOIDS 2 OR MORE CONSECUTIVE LOSSES
// LET THE PROFITS CONTINUE
// USE LIMIT ORDERS INSTEAD OF MARKETS ORDERS
// PROBAR si con la nueva configuracion funciona mejor con RSI / Stoch saliendo de zona de sobrecompra/sobreventa
  
//+------------------------------------------------------------------+
//| BUY / SELL OPERATIONS                                            |
//+------------------------------------------------------------------+
   
   total_orders=CountOrder_symbol_magic();
   if(total_orders==0) //initialize and delete old pending orders
      {
      closeall_stop();
      bool pyramid_1 = false;
      bool pyramid_2 = false;
      }
   current_spread = MarketInfo(Symbol(),MODE_SPREAD);
   //Print("Hello WORLD");
   //if(total<orders && NewsTime == false)
   if(total_orders<orders && NewBar()==true && DayToTrade()==true && HourToTrade()==true && MonthToTrade()==true && NoFridayEvening()==true && AllowOrders==true && TimeBetweenOrders()==true && current_spread<=spread)
   //if(total<orders && DayToTrade()==true && HourToTrade()==true && MonthToTrade()==true && AllowOrders==true)
   //if(total<orders && NewBar()==true)
   //if(total<orders)
      {
      // conditions to determine if we are at the beginning of the bar or not depending on the volume. <----better to use time, it is safer
      
      //if(iVolume(Symbol(),PERIOD_M1,0)>1) return;
         
      
      // Opening criterias
      
      //ma_M5 = iMA(Symbol(), LOW_TF, EMA, 0, 1, PRICE_CLOSE, 0); //EMA 200
      
      //double ma_H1a = iMA(Symbol(), LOW_TF, 20, 0, 1, PRICE_CLOSE, 0);
      
//      ma_H1 = iMA(Symbol(), MA_TF, MA_Period_H1, 0, MODE_SMMA, PRICE_CLOSE, 0);
//
//      count_1 = 0;
//      for (i = 1; i <= MA_count; i++)
//         {
//         if (ma_H1 >= iMA(Symbol(), MA_TF, MA_Period_H1, 0, MODE_SMMA, PRICE_CLOSE, i))
//         //&& iMA(Symbol(), MA_TF, MA_Period_H1, 0, MODE_SMMA, PRICE_CLOSE, i)>iMA(Symbol(), PERIOD_H1, MA_Period_H1, 0, MODE_SMMA, PRICE_CLOSE, i+1))
//            {
//            if(ma_H1 > iMA(Symbol(), MA_TF, MA_Period_H1, 0, MODE_SMMA, PRICE_CLOSE, i))
//            count_1++;
//            }
//         }
//
//      count_2 = 0;
//      for (ii = 1; ii <= MA_count; ii++)
//         {
//         if (ma_H1 <= iMA(Symbol(), MA_TF, MA_Period_H1, 0, MODE_SMMA, PRICE_CLOSE, ii))
//         //&& iMA(Symbol(), MA_TF, MA_Period_H1, 0, MODE_SMMA, PRICE_CLOSE, ii)<iMA(Symbol(), PERIOD_H1, MA_Period_H1, 0, MODE_SMMA, PRICE_CLOSE, ii+1))
//            {
//            if (ma_H1 <= iMA(Symbol(), MA_TF, MA_Period_H1, 0, MODE_SMMA, PRICE_CLOSE, ii))
//            count_2++;
//            }
//         }
      
      //rsi = iRSI(Symbol(), LOW_TF, RSIperiod, PRICE_CLOSE, 0);
      //rsi_H1 = iRSI(Symbol(), MA_TF, RSIperiod, PRICE_CLOSE, 0);
      //rsi_H1 = iRSI(Symbol(), LOW_TF, 7, PRICE_CLOSE, 0);

      //stochastic_0 = iStochastic(Symbol(), LOW_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 0);
      //stochastic_1 = iStochastic(Symbol(), PERIOD_M5, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 1);
      //stochastic_H1_0 = iStochastic(Symbol(), MA_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 0);
      //double stochastic_H1_1 = iStochastic(Symbol(), LOW_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 1);
      //double stochastic_signal_low_1 = iStochastic(Symbol(), LOW_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 1);

      // stochastic_main_med_0 = iStochastic(Symbol(), MED_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 0);
      // stochastic_main_med_1 = iStochastic(Symbol(), MED_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 1);
      // stochastic_main_med_2 = iStochastic(Symbol(), MED_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 2);
      // stochastic_signal_med_0 = iStochastic(Symbol(), MED_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 0);
      // stochastic_signal_med_1 = iStochastic(Symbol(), MED_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 1);
      
      stochastic_main_med_1_100 = iStochastic(Symbol(), MED_TF, 100, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 1);
      stochastic_main_med_2_100 = iStochastic(Symbol(), MED_TF, 100, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 2);
      
//      double macd_main_low_0 = iMACD(Symbol(), LOW_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_MAIN,0);
//      double macd_main_low_1 = iMACD(Symbol(), LOW_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_MAIN,1);
//      double macd_signal_low_0 = iMACD(Symbol(), LOW_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_SIGNAL,0);
//      double macd_signal_low_1 = iMACD(Symbol(), LOW_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_SIGNAL,1);
//      
      //macd_main_med_0 = iMACD(Symbol(), MED_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_MAIN,0);
      //macd_main_med_1 = iMACD(Symbol(), MED_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_MAIN,1);
      //macd_signal_med_0 = iMACD(Symbol(), MED_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_SIGNAL,0);
      //macd_signal_med_1 = iMACD(Symbol(), MED_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_SIGNAL,1);
//      
      //double macd_main_high_0 = iMACD(Symbol(), HIGH_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_MAIN,0);
//      double macd_main_high_1 = iMACD(Symbol(), HIGH_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_MAIN,1);
//      double macd_signal_high_0 = iMACD(Symbol(), HIGH_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_SIGNAL,0);
//      double macd_signal_high_1 = iMACD(Symbol(), HIGH_TF, EMA_Fast, EMA_Slow, macd_signal,0,MODE_SIGNAL,1);
        
      //double ma_low_10_0 = iMA(Symbol(), LOW_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 0);
      //double ma_low_20_0 = iMA(Symbol(), LOW_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
      //double ma_low_10_1 = iMA(Symbol(), LOW_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 1);
      //double ma_low_20_1 = iMA(Symbol(), LOW_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 1);
      
      //ma_med_10_0 = iMA(Symbol(), MED_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 0);
      //ma_med_20_0 = iMA(Symbol(), MED_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
      //ma_med_10_1 = iMA(Symbol(), MED_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 1);
      //ma_med_20_1 = iMA(Symbol(), MED_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 1);
      //ma_med_10_2 = iMA(Symbol(), MED_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 2);
      //ma_med_20_2 = iMA(Symbol(), MED_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 2);
      
      //double ma_high_10_0 = iMA(Symbol(), HIGH_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 0);
      //double ma_high_20_0 = iMA(Symbol(), HIGH_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
      //double ma_high_10_1 = iMA(Symbol(), HIGH_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 1);
      //double ma_high_20_1 = iMA(Symbol(), HIGH_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 1);
      
      //double SAR_low_0 = iSAR(Symbol(),LOW_TF,SAR_step_low,SAR_max,0);
      //double SAR_low_1 = iSAR(Symbol(),LOW_TF,SAR_step_low,SAR_max,1);
      
      //SAR_med_0 = iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,0);
      //SAR_med_1 = iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,1);
      
      ATR_med_0 = iATR(Symbol(),MED_TF,ATR_period,0);
      
      //double SAR_high_0 = iSAR(Symbol(),HIGH_TF,SAR_step_high,SAR_max,0);
      //double SAR_high_1 = iSAR(Symbol(),HIGH_TF,SAR_step_high,SAR_max,1);
      
      //turtle_1 = iCustom(Symbol(),MED_TF,"TheTurtleTradingChannel",20,10,false,false,6,1);
      //turtle_2 = iCustom(Symbol(),MED_TF,"TheTurtleTradingChannel",20,10,false,false,6,2);
      //double turtle_low_1 = iCustom(Symbol(),MED_TF,"TheTurtleTradingChannel",20,10,false,false,2,1);
      //double turtle_high_1 = iCustom(Symbol(),MED_TF,"TheTurtleTradingChannel",20,10,false,false,3,1);
      
//      double open_low_20_1 = iOpen(Symbol(),LOW_TF,1);
//      double close_low_20_1 = iClose(Symbol(),LOW_TF,1);
//      
//      double open_med_1 = iOpen(Symbol(),MED_TF,1);
//      double close_med_1 = iClose(Symbol(),MED_TF,1);
//
//      double open_high_1 = iOpen(Symbol(),HIGH_TF,1);
//      double close_high_1 = iClose(Symbol(),HIGH_TF,1);
      
      //--- check for BUY position
      
      if(
      //open_low_20_1<ma_low_20_1 && close_low_20_1>ma_low_20_1
      //&& macd_main_low_0>macd_signal_low_0 && macd_main_low_1>=macd_signal_low_1
      //&& macd_main_low_0<0
      //&& stochastic_low_1<StochLower
      //&& SAR_low_1<open_low_20_1 && SAR_low_0<Bid
      
      //macd_main_low_0>0 && macd_main_low_1<0
      //&& macd_main_high_0>macd_signal_high_1
      //&& macd_main_med_0>macd_signal_med_0
      //&& stochastic_main_H4_0>stochastic_main_H4_1
      //&& stochastic_main_H4_0<StochLower
      //&& macd_main_W1_0>macd_main_W1_1
      //&& macd_main_W1_0>0
      
      //&&macd_main_H4_0>macd_signal_H4_0
      //&& macd_main_H4_1>=macd_signal_H4_1 //??
      //&& macd_main_H4_0<0
      //&& macd_signal_H4_0<0
      //&& SAR_H4_1<open_H4_1 && SAR_H4_0<Bid
      //&& ma_H4_10_0>ma_H4_10_1
      //&& stochastic_main_H4_0>stochastic_signal_H4_0
      //&& stochastic_main_H4_0<StochLower
            
      (
      //(ma_med_10_1>ma_med_20_1 && ma_med_10_2<ma_med_20_2)
      (stochastic_main_med_1_100>20 && stochastic_main_med_2_100<20) 
      || (stochastic_main_med_1_100>30 && stochastic_main_med_2_100<30) 
      || (stochastic_main_med_1_100>25 && stochastic_main_med_2_100<25)
      || (stochastic_main_med_1_100>15 && stochastic_main_med_2_100<15)
      )
      //&& macd_main_med_0>macd_main_med_1
      //&& macd_main_med_0<0
      //&& SAR_med_0<Bid
      //&& stochastic_main_med_1_100>stochastic_main_med_2_100
      //&& stochastic_main_med_1_100<20
      //(turtle_1==OP_BUY && turtle_2==OP_SELL)
      )
         {
         //SL = 10000;
         //for(i=0;i<10;i++)
         //   {
         //   SL = MathMin(SL,iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,i));
         //   }
         
         //SL = MathMin(SAR_med_0,SAR_med_1);
         
         SL_dist = ATR_SL_factor*ATR_med_0;
         SL = Ask - SL_dist;
         //SL = Ask + SL_dist; //FOR INVERT

         TP = RR * SL_dist + Ask;
         
         //SL = ATR_SL_factor*ATR_med_0;
         //SL = (((MathMin(SAR_med_0,SAR_med_1)) + ma_med_20_1) / 2);
         //SL = turtle_low_1;

         //diff = Ask - SL;
         //TP = RR * diff + Ask;
         
         trade_lots = GetLots(SL);
         
         if(pyramidying == false)
            {  
            //ticket=OrderSend(Symbol(),OP_BUY,GetLots(),Ask,vSlippage,Ask-StopLoss*vPoint,Ask+TakeProfit*vPoint,"Blackrain Trend 0.0.1a",magic_number,0,Green);
            ticket=OrderSend(Symbol(),OP_BUY,trade_lots,Ask,vSlippage,SL,TP,"Blackrain Trend 0.0.1 Stoch",magic_number,0,Green);
                     
            if(ticket>0)
               {
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
                  {
                  Print("BUY order opened at ",OrderOpenPrice());
                  }
               }
            else
               {
               Print("Error opening BUY order : ",GetLastError());
               }
            }   
         
         if(pyramidying == true)
            {
            // ticket_1=OrderSend(Symbol(),OP_BUY,trade_lots,Ask,vSlippage,SL,Ask+(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Green);
            // ticket_2=OrderSend(Symbol(),OP_BUYSTOP,trade_lots,NormalizeDouble(Ask+(2*SL_dist),5),vSlippage,Ask+(1*SL_dist),Ask+(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Green);
            // ticket_3=OrderSend(Symbol(),OP_BUYSTOP,trade_lots,NormalizeDouble(Ask+(4*SL_dist),5),vSlippage,Ask+(3*SL_dist),Ask+(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Green);
            
            //ticket_1=OrderSend(Symbol(),OP_BUY,trade_lots,Ask,vSlippage,0,0,"Blackrain Trend 0.0.1",magic_number,0,Green);
            //ticket_2=OrderSend(Symbol(),OP_BUYSTOP,trade_lots,NormalizeDouble(Ask+(2*SL_dist),5),vSlippage,0,0,"Blackrain Trend 0.0.1",magic_number,0,Green);
            //ticket_3=OrderSend(Symbol(),OP_BUYSTOP,trade_lots,NormalizeDouble(Ask+(4*SL_dist),5),vSlippage,0,0,"Blackrain Trend 0.0.1",magic_number,0,Green);
//            
            //ticket_1=OrderSend(Symbol(),OP_BUY,trade_lots,Ask,vSlippage,SL,Ask+(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Green);
            //ticket_2=OrderSend(Symbol(),OP_BUY,trade_lots,Ask,vSlippage,SL,Ask+(2*RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Green);
            //ticket_3=OrderSend(Symbol(),OP_BUY,trade_lots,Ask,vSlippage,SL,Ask+(3*RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Green);
            
            //INVERSE
            //ticket_1=OrderSend(Symbol(),OP_SELL,trade_lots,Bid,vSlippage,SL,Bid-(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Red);
            //ticket_2=OrderSend(Symbol(),OP_SELL,trade_lots,Bid,vSlippage,SL,Bid-(2*RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Red);
            //ticket_3=OrderSend(Symbol(),OP_SELL,trade_lots,Bid,vSlippage,SL,Bid-(3*RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Red);
            }
               
         }
      
      //--- check for SELL position
            
      if(
      //open_low_20_1>ma_low_20_1 && close_low_20_1<ma_low_20_1
      //&& macd_main_low_0<macd_signal_low_0 && macd_main_low_1<=macd_signal_low_1
      //&& macd_main_low_0>0
      //&& stochastic_low_1>StochUpper
      //&& SAR_low_1>close_low_20_1 && SAR_low_0>Ask
      
      //macd_main_low_0<0 && macd_main_low_1>0
      //&& macd_main_high_0<macd_signal_high_1
      //&& macd_main_med_0<macd_signal_med_0
      //&& stochastic_main_H4_0<stochastic_main_H4_1
      //&& stochastic_main_H4_0>StochUpper
      //&& macd_main_W1_0<macd_main_W1_1
      //&& macd_main_W1_0<0
      
      //&&macd_main_H4_0<macd_signal_H4_0
      //&& macd_main_H4_1<=macd_signal_H4_1 //??
      //&& macd_main_H4_0>0
      //&& macd_signal_H4_0>0
      //&& SAR_H4_1>close_H4_1&& SAR_H4_0>Bid
      //&& ma_H4_10_0<ma_H4_10_1
      //&& stochastic_main_H4_0<stochastic_signal_H4_0
      //&& stochastic_main_H4_0>StochUpper
      
      (
      //(ma_med_10_1<ma_med_20_1 && ma_med_10_2>ma_med_20_2)
      (stochastic_main_med_1_100<80 && stochastic_main_med_2_100>80) 
      || (stochastic_main_med_1_100<70 && stochastic_main_med_2_100>70) 
      || (stochastic_main_med_1_100<75 && stochastic_main_med_2_100>75)
      || (stochastic_main_med_1_100<85 && stochastic_main_med_2_100>85)
      )
      //&& macd_main_med_0<macd_main_med_1
      //&& macd_main_med_0>0
      //&& SAR_med_0>Bid
      //&& stochastic_main_med_1_200<stochastic_main_med_2_200
      //&& stochastic_main_med_1_100>80
      //(turtle_1==OP_SELL && turtle_2==OP_BUY)
      )
         {
         //SL = 0;
         //for(i=0;i<10;i++)
         //   {
         //   SL = MathMax(SL,iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,i));
         //   }
         
         //SL = MathMax(SAR_med_0,SAR_med_1);
         
         //SL = ATR_SL_factor*ATR_med_0;
         //SL = (((MathMin(SAR_med_0,SAR_med_1)) + ma_med_20_1) / 2);
         //SL = turtle_high_1;

         SL_dist = ATR_SL_factor*ATR_med_0;
         SL = Bid + SL_dist;
         //SL = Bid - SL_dist; // FOR INVERT

         TP = Bid - RR * SL_dist;

         //diff = SL - Bid;
         //TP = Bid - RR * diff;
         trade_lots = GetLots(SL);
         
         if(pyramidying == false)
            {  
            //ticket=OrderSend(Symbol(),OP_SELL,GetLots(),Bid,vSlippage,Bid+StopLoss*vPoint,Bid-TakeProfit*vPoint,"Blackrain Trend 0.0.1a",magic_number,0,Red);
            ticket=OrderSend(Symbol(),OP_SELL,GetLots(SL),Bid,vSlippage,SL,TP,"Blackrain Trend 0.0.1 Stoch",magic_number,0,Red);
                     
            if(ticket>0)
               {
               if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
                  {
                  Print("SELL order opened at ",OrderOpenPrice());
                  }
               }
            else
               {
               Print("Error opening SELL order : ",GetLastError());
               }
            }
         
         if(pyramidying == true)
            {
            // ticket_1=OrderSend(Symbol(),OP_SELL,trade_lots,Bid,vSlippage,SL,Bid-(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Red);
            // ticket_2=OrderSend(Symbol(),OP_SELLSTOP,trade_lots,NormalizeDouble(Bid-(2*SL_dist),5),vSlippage,Bid-(1*SL_dist),Bid-(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Red);
            // ticket_3=OrderSend(Symbol(),OP_SELLSTOP,trade_lots,NormalizeDouble(Bid-(4*SL_dist),5),vSlippage,Bid-(3*SL_dist),Bid-(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Red);
            
            //ticket_1=OrderSend(Symbol(),OP_SELL,trade_lots,Bid,vSlippage,0,0,"Blackrain Trend 0.0.1",magic_number,0,Red);
            //ticket_2=OrderSend(Symbol(),OP_SELLSTOP,trade_lots,NormalizeDouble(Bid-(2*SL_dist),5),vSlippage,0,0,"Blackrain Trend 0.0.1",magic_number,0,Red);
            //ticket_3=OrderSend(Symbol(),OP_SELLSTOP,trade_lots,NormalizeDouble(Bid-(4*SL_dist),5),vSlippage,0,0,"Blackrain Trend 0.0.1",magic_number,0,Red);
            
            //ticket_1=OrderSend(Symbol(),OP_SELL,trade_lots,Bid,vSlippage,SL,Bid-(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Red);
            //ticket_2=OrderSend(Symbol(),OP_SELL,trade_lots,Bid,vSlippage,SL,Bid-(2*RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Red);
            //ticket_3=OrderSend(Symbol(),OP_SELL,trade_lots,Bid,vSlippage,SL,Bid-(3*RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Red);
            
            //INVERSE
            //ticket_1=OrderSend(Symbol(),OP_BUY,trade_lots,Ask,vSlippage,SL,Ask+(RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Green);
            //ticket_2=OrderSend(Symbol(),OP_BUY,trade_lots,Ask,vSlippage,SL,Ask+(2*RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Green);
            //ticket_3=OrderSend(Symbol(),OP_BUY,trade_lots,Ask,vSlippage,SL,Ask+(3*RR*SL_dist),"Blackrain Trend 0.0.1",magic_number,0,Green);
            }
               
         }

      return;
      }


//+------------------------------------------------------------------+
//| PYRAMIDYING                                                      | IMPLEMENT THE STEP BY STEP PROCESS AND FOR BUY / SELL VARIANTS. USE SIMILAR APPROACH AS WITH TS TO IMPLEMENT IT
//+------------------------------------------------------------------+   
  
//   if(pyramidying == true && CountOrder_symbol_magic()>0) // Put conditions to detect trend, e.g. count if EMA20 (EMA50, EMA100 or other) is rising, or if price is higher than several previous periods (Turtle)
//      {
//      if(total_orders==2 && pyramid_1==false) //means that the second order is activated. What to do when 2nd order is activated->move SL to 1R (grab ticket_1 and change SL)
//         {
//         if(!OrderSelect(ticket_1,SELECT_BY_TICKET,MODE_TRADES)) return;
//            {
//            if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
//               {
//               double dist=OrderOpenPrice()-OrderStopLoss();
//               
//               if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+1*dist,OrderTakeProfit(),0,Green))
//                  {
//                  Print("OrderModify error is due to pyramidying, error ",GetLastError());
//                  }
//               else
//                  {
//                  pyramid_1 = true;
//                  Print("PYRAMIDYING done for 1st and 2nd order");
//                  }
//               }
//            }      
//         }
//      if(total_orders==3 && pyramid_2==false) //what to do when 2nd order is activated->move SL to 3R
//         {
//         if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
//            {
//            double dist=OrderOpenPrice()-OrderStopLoss();
//            
//            if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+1*dist,OrderTakeProfit(),0,Green))
//               {
//               Print("OrderModify error is due to pyramidying, error ",GetLastError());
//               }
//            else
//               {
//               pyramid_1 = true;
//               Print("PYRAMIDYING done for 1st and 2nd order");
//               }
//            }
//         }       
//      }

//+------------------------------------------------------------------+
//| MANAGE OPEN ORDERS: TRAILING                                     |
//+------------------------------------------------------------------+   
   
   // Trailing stop   PARTIAL CLOSE WHEN PRICE MOVE TrailingStop VALUE
   if(trailing == true && CountOrder_symbol_magic()>0)
      {
      //TS_pips();
      TS_RRratio();
      }

//+------------------------------------------------------------------+
//| MANAGE OPEN ORDERS: BREAKEVEN AND CLOSING OF TRADES              |
//+------------------------------------------------------------------+ 

   //if(total>0 && NewBar())
   if(total_orders>0)
   //if(CountOrder_symbol_magic()>0)
   //if(Orderstotal()total>0)
      {
      //for(int cnt=0;cnt<OrdersTotal()-1;cnt++)
      for(int cnt=OrdersTotal()-1;cnt>=0;cnt--)
      //for(int cnt=0;cnt<CountOrder_symbol_magic();cnt++)
         {
         if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
            //Print("ERROR on OrderSelect, ticket: ",OrderTicket(),", Error: ",GetLastError());
            //continue;
            {
            if(OrderType()<=OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number) //check for order types, symbol and magic number
               {
               if(management_trade==true)
                  {
                  //rsi = iRSI(Symbol(), PERIOD_M5, RSIperiod, PRICE_CLOSE, 0);
                  //stochastic_0 = iStochastic(Symbol(), PERIOD_M5, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 0);
                  //double stochastic_H1_0_signal = iStochastic(Symbol(), LOW_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 0);
                  //double stochastic_H1_0_main = iStochastic(Symbol(), LOW_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 0);
                  //double rsi_H1_0 = iRSI(Symbol(), LOW_TF, RSIperiod, PRICE_CLOSE, 0);
                  
                  
                  //ma_med_10_0 = iMA(Symbol(), MED_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 0);
                  //ma_med_20_0 = iMA(Symbol(), MED_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
                  //ma_med_10_1 = iMA(Symbol(), MED_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 1);
                  //ma_med_20_1 = iMA(Symbol(), MED_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 1);
                  //ma_med_10_2 = iMA(Symbol(), MED_TF, 10, 0, MODE_EMA, PRICE_CLOSE, 2);
                  //ma_med_20_2 = iMA(Symbol(), MED_TF, 20, 0, MODE_EMA, PRICE_CLOSE, 2);
                  
                  stochastic_main_med_0 = iStochastic(Symbol(), MED_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 0);
                  stochastic_main_med_1 = iStochastic(Symbol(), MED_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 1);
                  stochastic_signal_med_0 = iStochastic(Symbol(), MED_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 0);
                  stochastic_signal_med_1 = iStochastic(Symbol(), MED_TF, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 1);
                  
                  stochastic_main_med_1_100 = iStochastic(Symbol(), MED_TF, 100, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 1);
                  stochastic_main_med_2_100 = iStochastic(Symbol(), MED_TF, 100, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, 2);
                  stochastic_signal_med_1_100 = iStochastic(Symbol(), MED_TF, 100, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 1);
                  stochastic_signal_med_2_100 = iStochastic(Symbol(), MED_TF, 100, DPeriod, Slowing, MODE_SMA, 0, MODE_SIGNAL, 2);
      
                  
                  //SAR_med_0 = iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,0);
                  //SAR_med_1 = iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,1);
                  
                  //turtle_1 = iCustom(Symbol(),MED_TF,"TheTurtleTradingChannel",20,10,false,false,6,1);
                  //turtle_2 = iCustom(Symbol(),MED_TF,"TheTurtleTradingChannel",20,10,false,false,6,2);
                  
                  if(breakeven==true &&
                  ((stochastic_main_med_0<stochastic_signal_med_0 && stochastic_main_med_1>stochastic_signal_med_1 && stochastic_main_med_0>stoch_inv_upper && OrderType()==OP_BUY && Bid>OrderOpenPrice()) 
                  || (stochastic_main_med_0>stochastic_signal_med_0 && stochastic_main_med_1<stochastic_signal_med_1 && stochastic_main_med_0<stoch_inv_lower && OrderType()==OP_SELL && Bid<OrderOpenPrice())
                  ))
                     {
                     BE();
                     }
                  
//                  if(stochastic_H1_0_signal>stoch_inv_upper && OrderType()==OP_BUY)
//                     {
//                     BE();
//                     }
//                  
//                  if(stochastic_H1_0_signal<stoch_inv_lower && OrderType()==OP_SELL)
//                     {
//                     BE();
//                     }   
//
//                  if(stochastic_H1_0_main>stoch_inv_upper && rsi_H1_0>RSIUpper && OrderType()==OP_BUY)
//                     {
//                     BE();
//                     }
//                  
//                  if(stochastic_H1_0_main<stoch_inv_lower && rsi_H1_0<RSILower && OrderType()==OP_SELL)
//                     {
//                     BE();
//                     }
                     
                  // Close BUY trades if the setup is invalid
                  //if(rsi>=rsi_inv_upper && stochastic_0>=stoch_inv_upper && OrderType()==OP_BUY && (Bid-OrderOpenPrice())>pips_invalidation*vPoint)
                  //if(rsi>=rsi_inv_upper && stochastic>=stoch_inv_upper && OrderType()==OP_BUY && (Bid-OrderOpenPrice())>pips_invalidation*vPoint && ma_10<ma_20)
                  //if(ma_10_0<ma_20_0 && ma_10_1>ma_20_1 && OrderType()==OP_BUY && (Bid-OrderOpenPrice())>pips_invalidation*vPoint)
                  if(close_trade == true &&
                  //(turtle_1==OP_SELL && turtle_2==OP_BUY && OrderType()==OP_BUY
                  //(ma_med_10_1<ma_med_20_1 && ma_med_10_2>ma_med_20_2 && OrderType()==OP_BUY
                  //(ma_med_10_1<ma_med_20_1 && ma_med_10_2>ma_med_20_2 && OrderType()==OP_BUY && Bid<OrderOpenPrice()
                  //(SAR_med_0>Bid && OrderType()==OP_BUY && Bid<OrderOpenPrice()
                  (stochastic_main_med_1_100<stochastic_signal_med_1_100 && stochastic_main_med_2_100>stochastic_signal_med_2_100 && stochastic_main_med_1_100>stoch_inv_upper && OrderType()==OP_BUY
                  
                  //(stochastic_main_med_0<stochastic_signal_med_0 && stochastic_main_med_1>stochastic_signal_med_1 && stochastic_main_med_0>stoch_inv_upper && OrderType()==OP_BUY
                  
                  //(stochastic_main_med_0<stochastic_signal_med_0 && stochastic_main_med_1>stochastic_signal_med_1 && stochastic_main_med_0>stoch_inv_upper && OrderType()==OP_BUY && Bid<OrderOpenPrice()
                  ))
                     {
                     closeall();
                     closeall_stop();
                     //if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,clrMagenta))
                     //Print("BUY order ERROR close due to invalidation of current setup: ",OrderTicket(),", Error: ",GetLastError());
                     //else
                     //Print("BUY order closed due to invalidation of current setup");
                     }
                  
                  // Close SELL trades if the setup is invalid
                  //if(rsi<=rsi_inv_lower && stochastic_0<=stoch_inv_lower && OrderType()==OP_SELL && (OrderOpenPrice()-Ask)>pips_invalidation*vPoint)
                  //if(rsi<=rsi_inv_lower && stochastic<=stoch_inv_lower && OrderType()==OP_SELL && (OrderOpenPrice()-Ask)>pips_invalidation*vPoint && ma_10>ma_20)
                  //if(ma_10_0>ma_20_0 && ma_10_1<ma_20_1 && OrderType()==OP_SELL && (OrderOpenPrice()-Ask)>pips_invalidation*vPoint)
                  if(close_trade == true &&
                  //(turtle_1==OP_BUY && turtle_2==OP_SELL && OrderType()==OP_SELL
                  //(ma_med_10_1>ma_med_20_1 && ma_med_10_2<ma_med_20_2 && OrderType()==OP_SELL
                  //(ma_med_10_1>ma_med_20_1 && ma_med_10_2<ma_med_20_2 && OrderType()==OP_SELL && Bid>OrderOpenPrice()
                  //(SAR_med_0<Bid && OrderType()==OP_SELL && Bid>OrderOpenPrice()
                  (stochastic_main_med_1_100>stochastic_signal_med_1_100 && stochastic_main_med_2_100<stochastic_signal_med_2_100 && stochastic_main_med_1_100<stoch_inv_lower && OrderType()==OP_SELL
                  
                  //(stochastic_main_med_0>stochastic_signal_med_0 && stochastic_main_med_1<stochastic_signal_med_1 && stochastic_main_med_0<stoch_inv_lower && OrderType()==OP_SELL
                  //(stochastic_main_med_0>stochastic_signal_med_0 && stochastic_main_med_1<stochastic_signal_med_1 && stochastic_main_med_0<stoch_inv_lower && OrderType()==OP_SELL && Bid>OrderOpenPrice()
                  ))
                     {
                     closeall();
                     closeall_stop();
                     //if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,clrMagenta))
                     //Print("SELL order ERROR close due to invalidation of current setup: ",OrderTicket(),", Error: ",GetLastError());
                     //else
                     //Print("SELL order closed due to invalidation of current setup");
                     }
                  }   
                  
               // Close trades due to their duration
               if(CloseOnDuration==true)
                  {
                  int MaxDuration = (MaxDurationHours * 60 * 60) + (MaxDurationMin * 60); //transform hours to seconds
                  int Duration = TimeCurrent() - OrderOpenTime();

                  if(Duration>=MaxDuration) // add condition to be applied only is price is lower or higher than open price, check both situations!!
                     {
                     if(OrderType()==OP_BUY && Bid>OrderOpenPrice())
                        {
                        if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,clrMagenta))
                        Print("BUY order ERROR on close due to duration: ",OrderTicket(),", Error: ",GetLastError());
                        else
                        Print("BUY order closed due to duration of the trade");
                        }
                     if(OrderType()==OP_SELL && Ask<OrderOpenPrice())
                        {
                        if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,clrMagenta))
                        Print("SELL order ERROR on close due to duration: ",OrderTicket(),", Error: ",GetLastError());
                        else
                        Print("SELL order closed due to duration of the trade");
                        }   
                     }
                  }
               
               // Close trades on Fridays evening
               if(CloseFridays==true)
                  {
                  if(DayOfWeek()==5 && Hour()>=21 && Minute()>=59)
                     {
                     if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,clrMagenta))
                     Print("Order ERROR on close on Friday: ",OrderTicket(),", Error: ",GetLastError());
                     else
                     Print("Trade closed due to End Of The Week");
                     }
                  }
               
               //Use retrace function to give the price a bit more room to operate. If a limit is exceeded, TP is used as nearby SL. The hard-SL is set on SL parameter
               // if(retrace==true)
               //    {
               //    if(OrderType()==OP_BUY && (OrderOpenPrice()-Bid)>vPoint*PipsStick && Bid<OrderOpenPrice() && OrderTakeProfit()>OrderOpenPrice())
               //       {
               //       if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()-vPoint*PipsRetrace,0,Green))
               //          Print("OrderModify error is due to RETRACE, error ",GetLastError());
               //          else
               //          Print("RETRACE done");
               //       }
               //    if(OrderType()==OP_SELL && (Ask-OrderOpenPrice())>vPoint*PipsStick && Ask>OrderOpenPrice() && OrderTakeProfit()<OrderOpenPrice())
               //       {
               //       if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()+vPoint*PipsRetrace,0,Green))
               //          //Print("OrderModify error ",GetLastError());
               //          Print("OrderModify error is due to RETRACE, error ",GetLastError());
               //          else
               //          Print("RETRACE done");
               //       }
               //    }   
               }
            }
         }
      }
   }    


//double OnTester()
//   {
//   //## Walk Forward Pro OnTester() code start (MQL4)- When NOT calculating your own Custom Performance Criterion ##
//   double dCustomPerformanceCriterion = NULL;  //This means the default Walk Forward Pro Custom Perf Criterion will be used
//   WFA_PerformCalculations(dCustomPerformanceCriterion);
//
//   return(dCustomPerformanceCriterion);
//   //## Walk Forward Pro OnTester() code end (MQL5) - When NOT calculating your own Custom Performance Criterion ##
//   }

//+------------------------------------------------------------------+
//| MONEY MANAGEMENT                                                 |
//+------------------------------------------------------------------+

double GetLots(double SAR) // Calculate the lots using the right currency conversion
   {
   double minlot = MarketInfo(Symbol(), MODE_MINLOT);
   double maxlot = MarketInfo(Symbol(), MODE_MAXLOT);
   double lots;
   double MaxLots = maxlots;
   int correction;
   
   if(MM)
      {

      double LotSize = 1;
      double dist_SL;
      double point = Point;
      if((Digits==3) || (Digits==5))
        {
         point*=10;
        }
      //string DepositCurrency=AccountInfoString(ACCOUNT_CURRENCY);  
      double PipValue=(((MarketInfo(Symbol(),MODE_TICKVALUE)*point)/MarketInfo(Symbol(),MODE_TICKSIZE))*LotSize);
       
      //MessageBox("DEPOSIT CURRENCY"+ DepositCurrency ,"ToolBox");
      //MessageBox("VALUE OF ONE PIP (1 LOT)="+ PipValue ,"ToolBox");
      
      //Print("VALUE OF ONE PIP is ",PipValue);
      
      if(Digits==3) {correction = 100;}
      if(Digits==5) {correction = 10000;}
      
      dist_SL = MathAbs((Bid-SAR)*correction);

      lots = NormalizeDouble((AccountBalance() * Risk/100) / (dist_SL*PipValue) , LotDigits);
      Print("Calculated lots: ",lots);

      // correction for the limits
      if(lots<minlot) lots = minlot;
      if(lots>MaxLots) lots = MaxLots;
      if(MaxLots>maxlot) lots = maxlot;

      }
   else
      {
      if(lots<minlot) lots = minlot;
      if(lots>MaxLots) lots = MaxLots;
      if(MaxLots>maxlot) lots = maxlot;
      lots = NormalizeDouble(Lots,2);
      }   
   return(lots);   
   }


//+------------------------------------------------------------------+
//| CHECK NEW BAR BY OPEN TIME                                       |
//+------------------------------------------------------------------+
bool NewBar()
{
static datetime lastbar;
datetime curbar = Time[0];
if(lastbar!=curbar)
   {
   lastbar=curbar;
   return (true);
   }
   else
   {
   return(false);
   }
}


//+------------------------------------------------------------------+
//| BREAKEVEN                                                        |
//+------------------------------------------------------------------+
void BE()
   {
   int cnt;
   int ordertotal;
   
   ordertotal=OrdersTotal();
   
   for(cnt=ordertotal-1; cnt>=0; cnt--)
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         //if(Bid>OrderOpenPrice()+BreakevenStop*vPoint)
         if(Bid>OrderOpenPrice())
            {
            //if(OrderStopLoss()<=OrderOpenPrice())
            if(OrderStopLoss()<OrderOpenPrice())
               {
               //if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+BreakevenDelta*vPoint,OrderTakeProfit(),0,Green))
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Green))
                  Print("OrderModify error ",GetLastError());
               return;
               }
            }
         }
      if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         //if(Ask<OrderOpenPrice()-BreakevenStop*vPoint)
         if(Ask<OrderOpenPrice())
            {
            //if(OrderStopLoss()>=OrderOpenPrice())
            if(OrderStopLoss()>OrderOpenPrice())
               {
               //if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-BreakevenDelta*vPoint,OrderTakeProfit(),0,Green))
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Green))
                  Print("OrderModify error ",GetLastError());
               return;
               }
            }
         }   
      }
   }

//+------------------------------------------------------------------+
//| CHECK IF TIME OF PREVIOUS ORDER                                  |
//+------------------------------------------------------------------+
bool TimeBetweenOrders()
   {
   bool OpenOrder=true;

   if(ticket>0)
      {
      if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_HISTORY))
         {
         //if(((TimeCurrent()-OrderCloseTime())<=time_between_trades) && OrderSymbol()==Symbol()) //time in seconds
         if(((TimeCurrent()-OrderOpenTime())<=time_between_trades) && OrderSymbol()==Symbol()) //time in seconds
            {
            datetime a=TimeCurrent();
            datetime b=OrderCloseTime();
            Print("Can't open a new trade, too early");
            //Print(a);
            //Print(b);
            Print("Time between old order and new one ",a-b," seconds");
            OpenOrder=false;
            }
         }  
      }
   return(OpenOrder);
   }


//+------------------------------------------------------------------+
//| CLOSE ALL ORDERS                                                 |
//+------------------------------------------------------------------+
void closeall()
   {
   int cnt;
   int ordertotal;
   
   ordertotal = OrdersTotal();
   
   for(cnt=ordertotal-1; cnt>=0; cnt--)
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if((OrderType()==OP_BUY || OrderType()==OP_SELL) && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE))
         Print("Order Close failed at 'closeall': ",OrderTicket(), " Error: ",GetLastError());
         }
      }
   }

//+------------------------------------------------------------------+
//| CLOSE ALL STOP ORDERS                                            |
//+------------------------------------------------------------------+
void closeall_stop()
   {
   int cnt;
   int ordertotal;
   
   ordertotal = OrdersTotal();
   
   for(cnt=ordertotal-1; cnt>=0; cnt--)
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if((OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP) && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         if(!OrderDelete(OrderTicket(),CLR_NONE))
         Print("Order Close failed at 'closeall_stop': ",OrderTicket(), " Error: ",GetLastError());
         }
      }
   }

//+------------------------------------------------------------------+
//| CLOSE ALL BUY ORDERS                                             |
//+------------------------------------------------------------------+
void closeall_buy()
   {
   int cnt;
   int ordertotal;
   
   ordertotal = OrdersTotal();
   
   for(cnt=ordertotal-1; cnt>=0; cnt--)
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE))
         Print("Order Close failed at 'closeall_buy': ",OrderTicket(), " Error: ",GetLastError());
         }
      }
   }

//+------------------------------------------------------------------+
//| CLOSE ALL SELL ORDERS                                            |
//+------------------------------------------------------------------+
void closeall_sell()
   {
   int cnt;
   int ordertotal;
   
   ordertotal = OrdersTotal();
   
   for(cnt=ordertotal-1; cnt>=0; cnt--)
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         if(!OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,CLR_NONE))
         Print("Order Close failed at 'closeall_sell': ",OrderTicket(), " Error: ",GetLastError());
         }
      }
   }
  
 
//+------------------------------------------------------------------+
//| COUNT OPEN ORDERS BY SYMBOL AND MAGIC NUMBER                     |
//+------------------------------------------------------------------+
int CountOrder_symbol_magic()
   {
   int cnt;
   int order_total;
   int ordertotal;
   
   order_total = 0;
   ordertotal = OrdersTotal();
   
   for(cnt=ordertotal-1; cnt>=0; cnt--)
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if((OrderType()==OP_BUY || OrderType()==OP_SELL) && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         order_total++;
         }
      }
   return (order_total);
   }

//+------------------------------------------------------------------+
//| COUNT BUY ORDERS BY SYMBOL AND MAGIC NUMBER                      |
//+------------------------------------------------------------------+
int CountBuyOrder_symbol_magic()
   {
   int cnt;
   int order_total;
   int ordertotal;
   
   order_total = 0;
   ordertotal = OrdersTotal();
   
   for(cnt=ordertotal-1; cnt>=0; cnt--)
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         order_total++;
         }
      }
   return (order_total);
   }

//+------------------------------------------------------------------+
//| COUNT SELL ORDERS BY SYMBOL AND MAGIC NUMBER                     |
//+------------------------------------------------------------------+
int CountSellOrder_symbol_magic()
   {
   int cnt;
   int order_total;
   int ordertotal;
   
   order_total = 0;
   ordertotal = OrdersTotal();
   
   for(cnt=ordertotal-1; cnt>=0; cnt--)
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         order_total++;
         }
      }
   return (order_total);
   }   

//+------------------------------------------------------------------+
//| TRAILING STOP BY PIPS                                            |
//+------------------------------------------------------------------+
void TS_pips()
   {
   int cnt;
   int ordertotal;
   //double TS;
   
   ordertotal=OrdersTotal();
   
   //if((TrailingStop)>=TakeProfit-5)
   //   {
   //   TS=TakeProfit-5;
   //   }
   //   else
   //   {
   //   TS=TrailingStop;
   //   }
   
   
   //Print("TS IS: ",TS);
   
   for(cnt=ordertotal-1; cnt>=0; cnt--)
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         if((Bid-OrderOpenPrice())>TrailingStop*vPoint)
         //if((Bid-OrderOpenPrice())>TS*vPoint)
            {
            if(OrderStopLoss()<(Bid-TrailingStop*vPoint))
            //if(OrderStopLoss()<(Bid-TS*vPoint))
               {
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStop*vPoint,OrderTakeProfit(),0,Green))
               //if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TS*vPoint,OrderTakeProfit(),0,Green))
                  Print("OrderModify error is because TS, error ",GetLastError());
               return;
               }
            }
         }
      if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         if((OrderOpenPrice()-Ask)>TrailingStop*vPoint)
         //if((OrderOpenPrice()-Ask)>TS*vPoint)
            {
            if(OrderStopLoss()>(Ask+TrailingStop*vPoint))
            //if(OrderStopLoss()>(Ask+TS*vPoint))
               {
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TrailingStop*vPoint,OrderTakeProfit(),0,Green))
               //if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TS*vPoint,OrderTakeProfit(),0,Green))
                  Print("OrderModify error is because TS, error ",GetLastError());
               return;
               }
            }
         }   
      }
   }

//+------------------------------------------------------------------+
//| TRAILING STOP BY RISK-REWARD RATIO                               |
//+------------------------------------------------------------------+
void TS_RRratio()
   {
   int cnt;
   int ordertotal;
   int shift_bar;
   
   double dist_open_to_initSL;
   
   ordertotal=OrdersTotal();
   
   for(cnt=ordertotal-1; cnt>=0; cnt--) //deberia funcionar en combinación con piramidar: no funciona pq una vez cumplidas las condiciones no las aplica a cada order abierta
      {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderType()==OP_BUY && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         shift_bar = iBarShift(Symbol(),MED_TF,OrderOpenTime(),false);
         // dist_open_to_initSL = OrderOpenPrice()-MathMin(iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,shift_bar),iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,shift_bar+1)); //change this to ATR distance
         dist_open_to_initSL = ATR_SL_factor*iATR(Symbol(),MED_TF,ATR_period,shift_bar);
         // Print("Distance is ",dist_open_to_initSL);
                  
         if((Bid-OrderOpenPrice())>TS_RRratio_step*dist_open_to_initSL)
            {
            if(OrderStopLoss()<(Bid-(TS_RRratio_step+TS_RRratio_sl)*dist_open_to_initSL)) // creo que esta condicion es correcta, procede si el SL està a 3R de distancia del precio
               {
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TS_RRratio_sl*dist_open_to_initSL,OrderTakeProfit(),0,Green)) //esto tambien parece correcto, mueve el SL a 1R de distancia del precio actual
                  Print("OrderModify error is because TS, error ",GetLastError());
               return;
               }
            }
         }
      if(OrderType()==OP_SELL && OrderSymbol()==Symbol() && OrderMagicNumber()==magic_number)
         {
         shift_bar = iBarShift(Symbol(),MED_TF,OrderOpenTime(),false);
         // dist_open_to_initSL = MathMax(iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,shift_bar),iSAR(Symbol(),MED_TF,SAR_step_med,SAR_max,shift_bar+1))-OrderOpenPrice();
         dist_open_to_initSL = ATR_SL_factor*iATR(Symbol(),MED_TF,ATR_period,shift_bar);
         
         if((OrderOpenPrice()-Ask)>TS_RRratio_step*dist_open_to_initSL)
            {
            if(OrderStopLoss()>(Ask+(TS_RRratio_step+TS_RRratio_sl)*dist_open_to_initSL))
               {
               if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+TS_RRratio_sl*dist_open_to_initSL,OrderTakeProfit(),0,Green))
                  Print("OrderModify error is because TS, error ",GetLastError());
               return;
               }
            }
         }   
      }
   }

////+------------------------------------------------------------------+
////| NEWS TIME FUNCTION                                               |
////+------------------------------------------------------------------+
// bool NewsHandling()
//   {
//    //static int PrevMinute = -1;
//    //   if (Minute() != PrevMinute)
//    //     {
//    //     PrevMinute = Minute();
//         //int minutesSincePrevEvent = iCustom(NULL, 0, "FFCal", true, true, false, true, true, 1, 0);
//         //int minutesUntilNextEvent = iCustom(NULL, 0, "FFCal", true, true, false, true, true, 1, 1);
//        
//         //int minutesSincePrevEvent = iCustom(NULL, 0, "FFCal", IncludeHighNews, IncludeMediumNews, IncludeLowNews, IncludeSpeakNews, 1, DSTOffsetHours, 1, 0);
//         //int minutesUntilNextEvent = iCustom(NULL, 0, "FFCal", IncludeHighNews, IncludeMediumNews, IncludeLowNews, IncludeSpeakNews, 1, DSTOffsetHours, 1, 1);
//        
//   int minutesAfterPrevEvent = iCustom(NULL, 0, "FFC", true, IncludeHighNews, IncludeMediumNews, IncludeLowNews, IncludeSpeakNews, IncludeHolidays,"","", true, 4, 0, 1);
//   int minutesBeforeNextEvent = iCustom(NULL, 0, "FFC", true, IncludeHighNews, IncludeMediumNews, IncludeLowNews, IncludeSpeakNews, IncludeHolidays,"","", true, 4, 0, 0);
//      
//   data_news =
//   "\n                              Minutes Before next News Event = " + minutesBeforeNextEvent
//   +"\n                              Minutes After previous News Event = " + minutesAfterPrevEvent;
//      
//   if (minutesBeforeNextEvent <= MinsBeforeNews || minutesAfterPrevEvent <= MinsAfterNews)
//      {
//      NewsTime = true;
//      }
//      else
//      {
//      NewsTime = false;
//      }
//    return(NewsTime);
//    }

/*
FFC Advanced call:
-------------
iCustom(
        string       NULL,            // symbol 
        int          0,               // timeframe 
        string       "FFC",           // path/name of the custom indicator compiled program 
        bool         true,            // true/false: Active chart only 
        bool         true,            // true/false: Include High impact
        bool         true,            // true/false: Include Medium impact
        bool         true,            // true/false: Include Low impact
        bool         true,            // true/false: Include Speaks
        bool         false,           // true/false: Include Holidays
        string       "",              // Find keyword
        string       "",              // Ignore keyword
        bool         true,            // true/false: Allow Updates
        int          4,               // Update every (in hours)
        int          0,               // Buffers: (0) Minutes, (1) Impact
        int          0                // shift 
*/   
//   minutesSincePrevEvent = iCustom(NULL, 0, "FFC", true, IncludeHighNews, IncludeMediumNews, IncludeLowNews, IncludeSpeakNews, IncludeHolidays,"","", true, 4, 0, 0);
//
//   minutesUntilNextEvent = iCustom(NULL, 0, "FFC", true, IncludeHighNews, IncludeMediumNews, IncludeLowNews, IncludeSpeakNews, IncludeHolidays,"","", true, 4, 0, 1);
//
//   impactOfPrevEvent = iCustom(NULL, 0, "FFC", true, IncludeHighNews, IncludeMediumNews, IncludeLowNews, IncludeSpeakNews, IncludeHolidays,"","", true, 4, 1, 0);
//
//   impactOfNextEvent = iCustom(NULL, 0, "FFC", true, IncludeHighNews, IncludeMediumNews, IncludeLowNews, IncludeSpeakNews, IncludeHolidays,"","", true, 4, 1, 1);

// FFCAL call

//   minutesSincePrevEvent = iCustom(NULL, 0, "FFCal", true, true, false, true, true, 1, 0);
//
//   minutesUntilNextEvent = iCustom(NULL, 0, "FFCalendar", true, true, false, true, true, 1, 1);
//
//   impactOfPrevEvent = iCustom(NULL, 0, "FFCalendar", true, true, false, true, true, 2, 0);
//
//   impactOfNextEvent = iCustom(NULL, 0, "FFCalendar", true, true, false, true, true, 2, 1);

//+------------------------------------------------------------------+
//| DAYS TO AVOID TRADING                                            |
//+------------------------------------------------------------------+

bool DayToTrade()
   {
   bool daytotrade = false;
   
   //add here the conditions for days to avoid trading, choose FALSE or TRUE
   if(DayOfWeek() == 0) daytotrade = Sunday;
   if(DayOfWeek() == 1) daytotrade = Monday;
   if(DayOfWeek() == 2) daytotrade = Tuesday;
   if(DayOfWeek() == 3) daytotrade = Wednesday;
   if(DayOfWeek() == 4) daytotrade = Thursday;
   if(DayOfWeek() == 5) daytotrade = Friday;
   
   for(int jan=1;jan<=15;jan++)
      {
      if(DayOfYear()==jan) daytotrade = false;
      }
   
   for(int dec=350;dec<=365;dec++)
      {
      if(DayOfYear()==dec) daytotrade = false;
      }
   
   return(daytotrade);
   }

//+------------------------------------------------------------------+
//| HOURS TO AVOID TRADING                                           |
//+------------------------------------------------------------------+

bool HourToTrade()
   {
   bool hourtotrade = false;
   
   //add here the conditions for hours to avoid trading, choose FALSE or TRUE

   if(Hour()>=StartHourTrade && Hour()<=EndHourTrade) hourtotrade = true; 
   
   return(hourtotrade);
   }
   
//+------------------------------------------------------------------+
//| MONTH TO AVOID TRADING                                           |
//+------------------------------------------------------------------+

bool MonthToTrade()
   {
   bool monthtotrade = false;
   
   //add here the conditions for month to avoid trading, choose FALSE or TRUE

   if(Month() == 1) monthtotrade = January;
   if(Month() == 2) monthtotrade = February;
   if(Month() == 3) monthtotrade = March;
   if(Month() == 4) monthtotrade = April;
   if(Month() == 5) monthtotrade = May;
   if(Month() == 6) monthtotrade = June;
   if(Month() == 7) monthtotrade = July;
   if(Month() == 8) monthtotrade = August;
   if(Month() == 9) monthtotrade = September;
   if(Month() == 10) monthtotrade = October;
   if(Month() == 11) monthtotrade = November;
   if(Month() == 12) monthtotrade = December;                       
   
   return(monthtotrade);
   }

//+------------------------------------------------------------------+
//| TRADE ON FRIDAY EVENING                                          |
//+------------------------------------------------------------------+
   
bool NoFridayEvening()
   {
   bool fridayevening = true;
   
   if(DayOfWeek() == 5 && Hour()>=22) fridayevening = false;
   
   return(fridayevening);
   }
   
//+------------------------------------------------------------------+
