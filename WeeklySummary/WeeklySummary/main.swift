/* 
 * Project: Weekly Summary
 * -----------------------
 * Author: Eliezer Abate
 * October 19 2017 
 */


import EventKit

let group = DispatchGroup();
let s = Summarizer();
s.requestCalendarAccess();
sleep(3);
