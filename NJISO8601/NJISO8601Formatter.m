#import "NJISO8601Formatter.h"

id NJISO8601ParseString(NSString *string);

@implementation NJISO8601Formatter

- (NSDate *)dateFromString:(NSString *)string
{
    if (string) {
        NSDate *date = NJISO8601ParseString(string);
        return [date isKindOfClass:[NSDate class]] ? date : nil;
    }
    return nil;
}

@end
