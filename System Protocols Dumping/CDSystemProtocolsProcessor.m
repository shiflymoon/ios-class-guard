#import "CDSystemProtocolsProcessor.h"


@implementation CDSystemProtocolsProcessor {
    NSString *_sdkPath;
}

- (id)initWithSdkPath:(NSString *)sdkPath {
    self = [super init];
    if (self) {
        _sdkPath = sdkPath;
    }

    return self;
}

- (NSArray *)systemProtocolsSymbolsToExclude {
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/find";
    //兼容xcode9，xcode9的库路径变更了： /Users/shiguiling063/Downloads/Xcode9.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/Frameworks/
    if([_sdkPath containsString:@"Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot"]){
        NSArray * seperateArray = [_sdkPath componentsSeparatedByString:@"iPhoneOS.platform/Developer/Library/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot"];
        if(seperateArray.count == 2){
            NSString * path = [NSString stringWithFormat:@"%@%@%@",seperateArray[0],@"iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk",@"/System/Library/Frameworks/"];
            task.currentDirectoryPath = path;
        }
    }else{
        task.currentDirectoryPath = [_sdkPath stringByAppendingString:@"/System/Library/Frameworks"];
    }
  
    task.arguments = @[@".", @"-name", @"*.h", @"-exec",
                       @"sed", @"-n", @"-e", @"s/.*@protocol[ \\t]*\\([a-zA-Z_][a-zA-Z0-9_]*\\).*/\\1/p", @"{}", @"+"];
    task.environment = @{@"LANG": @"C",
                         @"LC_CTYPE": @"C",
                         @"LC_ALL": @"C"};
    task.standardOutput = pipe;
    [task launch];
    [task waitUntilExit];

    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    if (data.length) {
        NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return [output componentsSeparatedByString:@"\n"];
    }

    return nil;
}

@end
