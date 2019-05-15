#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
DateVector findStart(CharacterVector exp_key, DateVector start_int,
                       DateVector end_int, CharacterVector trans_key, DateVector trans_date){
  /* We use exp_length to track if exposures are formatted incorrectly.
   * We should never have trans not in our exposures because of the call to filter_trans. */
  int exp_length = exp_key.length();
  //Used to iterate over trans and create vector length.
  int trans_length = trans_key.length();
  //Initialize DateVector to store start dates in.
  DateVector out(trans_length);

  /*Note that the sorting of the vectors in filter_trans allows us to not double check exposures that we have already
   * iterated over in the following loop.*/
  int i = 0, j = 0;
  while(i < trans_length) {
    /* If the transaction has a matching key and the transaction date is between the interval start and the interval end,
     * then we have found the correct interval. We can then move to the next transaction.*/
    if (trans_key[i] == exp_key[j] &&
        trans_date[i] >= start_int[j] && trans_date[i] <= end_int[j]){
      out[i] = start_int[j];
      i += 1;
    } else { // If we aren't in the right interval move to the next interval.
      j += 1;
      if (j >= exp_length) {
        throw "Transaction has no matching exposure"; //This shouldn't happen.
      }
    }
  }
//Return start dates.
  return out;
}

