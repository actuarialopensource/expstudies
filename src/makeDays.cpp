#include <Rcpp.h>
using namespace Rcpp;
//' Create a DataFrame with all dates in the exposure period for each key
//'
//' @param record_key Vector of keys from the input record
//' @param record_start Vector of start dates from the input record
//' @param record_days Vector containing the number of days in the interval for a row in a record
//' @param final_size Sum of days in all intervals, used to initialize the DataFrame that is returned.
// [[Rcpp::export]]
DataFrame makeDays(CharacterVector record_key, DateVector record_start, IntegerVector record_days, int final_size){
  //Initialize vectors to write results into
  CharacterVector key (final_size);
  DateVector date (final_size);
  /* record_index tracks the index of the record we are currently formatting.
   * record_rows_written tracks how many dates have been written for the current record.
   * total_rows_written tracks the index we are currently writing values to.
   */
  int record_index = 0;
  int record_rows_written = 0;
  int total_rows_written = 0;
  /* We use a nested loop, iterating over records in the outer loop and writing results in the inner loop.
   * The inner loop is finished executing when it has written a date to the date vector for each date in the interval.
   */
  while(record_index < record_key.length()){
    while(record_rows_written < record_days[record_index]){
      key[total_rows_written] = record_key[record_index];
      date[total_rows_written] = record_start[record_index] + record_rows_written;
      record_rows_written += 1;
      total_rows_written += 1;
    }
    //Move to the next record. Set the counter of written dates back to zero.
    record_index += 1;
    record_rows_written = 0;
  }
  //Create a DataFrame with the key and dates
  DataFrame key_and_date = DataFrame::create(Named("key") = key, Named("date") = date);
  return key_and_date;
}

