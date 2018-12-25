/*
 *  Copyright 2015 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "RTCLogging.h"


RTCLoggingSeverity RTCGetNativeLoggingSeverity(RTCLoggingSeverity severity) {
    return RTCLoggingSeverityVerbose;
}

void RTCLogEx(RTCLoggingSeverity severity, NSString* log_string) {
  if (log_string.length) {

  }
}

void RTCSetMinDebugLogLevel(RTCLoggingSeverity severity) {
  
}

NSString* RTCFileName(const char* file_path) {
  NSString* ns_file_path =
      [[NSString alloc] initWithBytesNoCopy:const_cast<char*>(file_path)
                                     length:strlen(file_path)
                                   encoding:NSUTF8StringEncoding
                               freeWhenDone:NO];
  return ns_file_path.lastPathComponent;
}
