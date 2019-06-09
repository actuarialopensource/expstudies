#include <Rcpp.h>
using namespace Rcpp;
//' Find the correct interval/key combination for start intervals.
//'
//' @param exp_key sorted key column.
//' @param start_int start_intervals that are are sorted within their keys
//' @param end_int end_intervals that are are sorted because start_int is sorted.
//' @param trans_key that must have a matching interval. This is guaranteed by the R code before calling findStart.
//' @param trans_date sorted date column.
// [[Rcpp::export]]
DateVector findStart(CharacterVector exp_key, DateVector start_int,
                     DateVector end_int, CharacterVector trans_key, DateVector trans_date){
  //Bounds for the loop
  int exp_length = exp_key.length();
  int trans_length = trans_key.length();
  //To store the result
  DateVector out(trans_length);
  //i is used to index the transactions, j for the exposures
  int i = 0, j = 0;
  while((i < trans_length) & (j < exp_length)) {
    /* Use the fact that we have already sorted the exposures and transactions.
    * If the transaction is greater than the exposure move to the next exposure.
    * If the exposure is greater than the transaction move to the next transaction.
    * Othewise the exposure matches the transaction.
    */
    if (trans_key[i] > exp_key[j] || (trans_key[i] == exp_key[j] && trans_date[i] > end_int[j])){
      j += 1;
    } else if (trans_key[i] < exp_key[j] || (trans_key[i] == exp_key[j] && trans_date[i] < start_int[j])){
      out[i] = NA_REAL;
      i += 1;
    } else {
      out[i] = start_int[j];
      i += 1;
    }
  }
  // If we terminate after exhausing exposures the remaining transactions have no matches.
  while(i < trans_length){
    out[i] = NA_REAL;
    i += 1;
  }
  // Return the start dates
  return out;
}


