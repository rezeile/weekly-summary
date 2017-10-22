/* 
 *        Weekly Summary
 * ------------------------------
 * Mac agent that wakes up
 * every sunday to summarize
 * and log your weekly time 
 * expenditure and send it to
 * your email
 *
 * Author: Eliezer Abate
 * Last Updated: October 21, 2017
 *
 */

import AppKit
import Foundation

Summarizer(config: Config()).summarize()
sleep(10);
