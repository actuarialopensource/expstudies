#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
DateVector findStart(CharacterVector exp_key, DateVector start_int,
                       DateVector end_int, CharacterVector trans_key, DateVector trans_date){
  int exp_length = exp_key.length();
  int trans_length = trans_key.length();
  DateVector out(trans_length);

  int i = 0, j = 0;
  while(i < trans_length) {
    if (trans_key[i] == exp_key[j] &&
        trans_date[i] >= start_int[j] && trans_date[i] <= end_int[j]){
      out[i] = start_int[j];
      i += 1;
    } else {
      j += 1;
      if (j >= exp_length) {
        throw "Transaction has no matching exposure";
      }
    }
  }

  return out;
}

