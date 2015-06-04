@import Foundation;
#import "NJISO8601ParserDef.h"

id NJISO8601ParseString(NSString *aString);

static NSInteger NJIntFromString(const unsigned char *aString, NSInteger aDigits)
{
    NSInteger sValue = 0;

    for (NSInteger i = 0; i < aDigits; i++)
    {
        sValue  *= 10;
        sValue  += (*aString - '0');
        aString += 1;
    }

    return sValue;
}

static NSDate * toDate(NSDateComponents *components)
{
    if (components.hour == 24 && components.minute == 0 && components.second == 0 && (components.nanosecond == 0 || components.nanosecond == NSIntegerMax)) {

        components.hour = 0;
        if ([components isValidDate] == true) {
            NSDate *date = [components date];
            return [date dateByAddingTimeInterval:86400];
        } else {
            return nil;
        }
    }

    if ([components isValidDate] == true) {
        return [components date];
    } else {
        return nil;
    }
}

static double NJFractionFromString(const unsigned char *aString, NSInteger aDigits)
{
    double sValue = 0.0;
    double sBase  = 1.0;

    for (NSInteger i = 0; i < aDigits; i++)
    {
        sBase   *= 10;
        sValue  += (*aString - '0') / sBase;
        aString += 1;
    }

    return sValue;
}

#define NJISO8601ParseGetCondition()           sCondition
#define NJISO8601ParseSetCondition(aCondition) sCondition = aCondition

id NJISO8601ParseString(NSString *aString)
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.calendar = [NSCalendar currentCalendar];

    CFTimeInterval sTimeZoneOffset = 0.0;
    const unsigned char *sMatch;
    const unsigned char *sCursor;
    const unsigned char *sMarker;
    int sCondition;

    sCursor    = (const unsigned char *)[aString UTF8String];
    sCondition = kNJISO8601ConditionStart;

    while (1)
    {
        sMatch = sCursor;

        /*!re2c

        re2c:define:YYCTYPE        = "unsigned char";
        re2c:define:YYCURSOR       = sCursor;
        re2c:define:YYMARKER       = sMarker;
        re2c:define:YYCONDTYPE     = NJISO8601Condition;
        re2c:define:YYGETCONDITION = NJISO8601ParseGetCondition;
        re2c:define:YYSETCONDITION = NJISO8601ParseSetCondition;
        re2c:condprefix            = NJISO8601Condition;
        re2c:condenumprefix        = kNJISO8601Condition;
        re2c:yych:conversion       = 0;
        re2c:yyfill:enable         = 0;
        re2c:indent:top            = 2;
        re2c:indent:string         = "    ";


        ANY     = [^];
        NULL    = "\000";

        SIGN    = ("+"|"-");
        DIGIT   = [0-9];

        HYPHEN  = "-";
        COLON   = ":";
        COMMA   = (","|".");
        SOLIDUS = "/";

        D       = "D";
        H       = "H";
        M       = "M";
        P       = "P";
        R       = "R";
        S       = "S";
        T       = "T";
        W       = "W";
        Y       = "Y";
        Z       = "Z";


        <Start> P => DurationBegin
            {
                continue;
            }

        <Start> R => RecurringIntervalBegin
            {
                continue;
            }

        <Start> ANY => DateBegin
            {
                sCursor--;
                continue;
            }


        <DateBegin> DIGIT{4} HYPHEN DIGIT{2} HYPHEN DIGIT{2} => DateEnd
            {
                dateComponents.year = NJIntFromString(sMatch, 4);
                dateComponents.month = NJIntFromString(sMatch + 5, 2);
                dateComponents.day = NJIntFromString(sMatch + 8, 2);
                continue;
            }

        <DateBegin> DIGIT{4} HYPHEN DIGIT{2} => DateEnd
            {
                dateComponents.year = NJIntFromString(sMatch, 4);
                dateComponents.month = NJIntFromString(sMatch + 5, 2);
                dateComponents.day = 1;
                continue;
            }

        <DateBegin> DIGIT{4} DIGIT{2} DIGIT{2} => DateEnd
            {
                dateComponents.year = NJIntFromString(sMatch, 4);
                dateComponents.month = NJIntFromString(sMatch + 4, 2);
                dateComponents.day = NJIntFromString(sMatch + 6, 2);
                continue;
            }

        <DateBegin> DIGIT{4} => DateEnd
            {
                dateComponents.year = NJIntFromString(sMatch, 4);
                dateComponents.month = 1;
                dateComponents.day = 1;
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} HYPHEN DIGIT{2} HYPHEN DIGIT{2} => DateEnd
            {
                NSInteger sYearDigits      = sCursor - sMatch - 7;

                dateComponents.year = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                dateComponents.month = NJIntFromString(sMatch + sYearDigits + 2, 2);
                dateComponents.day = NJIntFromString(sMatch + sYearDigits + 5, 2);
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} HYPHEN DIGIT{2} => DateEnd
            {
                NSInteger sYearDigits = sCursor - sMatch - 4;

                dateComponents.year = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                dateComponents.month = NJIntFromString(sMatch + sYearDigits + 2, 2);
                dateComponents.day = 1;
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} DIGIT{2} DIGIT{2} => DateEnd
            {
                NSInteger sYearDigits      = sCursor - sMatch - 5;

                dateComponents.year  = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                dateComponents.month = NJIntFromString(sMatch + sYearDigits + 1, 2);
                dateComponents.day   = NJIntFromString(sMatch + sYearDigits + 3, 2);
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} => DateEnd
            {
                NSInteger sYearDigits      = sCursor - sMatch - 1;

                dateComponents.year  = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                dateComponents.month = 1;
                dateComponents.day = 1;
                continue;
            }

        <DateEnd> T => TimeBegin
            {
                continue;
            }

        <DateEnd> SOLIDUS
            {
                break;
            }

        <DateEnd> NULL
            {
                dateComponents.hour = 0;
                dateComponents.minute = 0;
                dateComponents.second = 0;
                return toDate(dateComponents);
            }


        <TimeBegin> DIGIT{2} COLON DIGIT{2} COLON DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                NSInteger sFractionDigits = sCursor - sMatch - 9;

                dateComponents.hour    = NJIntFromString(sMatch, 2);
                dateComponents.minute  = NJIntFromString(sMatch + 3, 2);
                dateComponents.second  = NJIntFromString(sMatch + 6, 2);
                dateComponents.nanosecond = NJFractionFromString(sMatch + 9, sFractionDigits) * 1000000000;
                continue;
            }

        <TimeBegin> DIGIT{2} COLON DIGIT{2} COLON DIGIT{2} => TimeEnd
            {
                dateComponents.hour    = NJIntFromString(sMatch, 2);
                dateComponents.minute  = NJIntFromString(sMatch + 3, 2);
                dateComponents.second  = NJIntFromString(sMatch + 6, 2);
                continue;
            }

        <TimeBegin> DIGIT{2} COLON DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                NSInteger sFractionDigits = sCursor - sMatch - 6;

                dateComponents.hour = NJIntFromString(sMatch, 2);
                dateComponents.minute = NJIntFromString(sMatch + 3, 2);
                double second = NJFractionFromString(sMatch + 6, sFractionDigits) * 60;
                dateComponents.second = (int)second;
                dateComponents.nanosecond = (second - dateComponents.second) * 1000000000;
                continue;
            }

        <TimeBegin> DIGIT{2} COLON DIGIT{2} => TimeEnd
            {
                dateComponents.hour    = NJIntFromString(sMatch, 2);
                dateComponents.minute  = NJIntFromString(sMatch + 3, 2);
                dateComponents.second  = 0;
                continue;
            }

        <TimeBegin> DIGIT{2} DIGIT{2} DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                NSInteger sFractionDigits    = sCursor - sMatch - 7;
                dateComponents.hour    = NJIntFromString(sMatch, 2);
                dateComponents.minute  = NJIntFromString(sMatch + 2, 2);
                dateComponents.second  = NJIntFromString(sMatch + 4, 2);
                dateComponents.nanosecond = NJFractionFromString(sMatch + 7, sFractionDigits) * 1000000000;
                continue;
            }

        <TimeBegin> DIGIT{2} DIGIT{2} DIGIT{2} => TimeEnd
            {
                dateComponents.hour    = NJIntFromString(sMatch, 2);
                dateComponents.minute  = NJIntFromString(sMatch + 2, 2);
                dateComponents.second  = NJIntFromString(sMatch + 4, 2);
                continue;
            }

        <TimeBegin> DIGIT{2} DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                NSInteger sFractionDigits    = sCursor - sMatch - 5;

                dateComponents.hour    = NJIntFromString(sMatch, 2);
                dateComponents.minute  = NJIntFromString(sMatch + 2, 2);
                double second = NJFractionFromString(sMatch + 5, sFractionDigits) * 60;
                dateComponents.second = (int)second;
                dateComponents.nanosecond = (second - dateComponents.second) * 1000000000;

                continue;
            }

        <TimeBegin> DIGIT{2} DIGIT{2} => TimeEnd
            {
                dateComponents.hour    = NJIntFromString(sMatch, 2);
                dateComponents.minute  = NJIntFromString(sMatch + 2, 2);
                dateComponents.second  = 0;
                continue;
            }

        <TimeBegin> DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                NSInteger sFractionDigits = sCursor - sMatch - 3;
                double sFraction       = NJFractionFromString(sMatch + 3, sFractionDigits);

                dateComponents.hour    = NJIntFromString(sMatch, 2);

                double minute = sFraction * 60.0;
                dateComponents.minute = (int)minute;
                double second = (minute - dateComponents.minute) * 60;
                dateComponents.second = (int)second;
                dateComponents.nanosecond = (second - dateComponents.second) * 1000000000;


                continue;
            }

        <TimeBegin> DIGIT{2} => TimeEnd
            {
                dateComponents.hour    = NJIntFromString(sMatch, 2);
                dateComponents.minute  = 0;
                dateComponents.second  = 0;
                continue;
            }


        <TimeEnd> Z => TimeZoneBegin
            {
                sCursor--;
                continue;
            }

        <TimeEnd> SIGN => TimeZoneBegin
            {
                sCursor--;
                continue;
            }

        <TimeEnd> SOLIDUS
            {
                break;
            }

        <TimeEnd> NULL
            {
                return toDate(dateComponents);
            }


        <TimeZoneBegin> Z => TimeZoneEnd
            {
                sTimeZoneOffset = 0;
                continue;
            }

        <TimeZoneBegin> SIGN DIGIT{2} COLON DIGIT{2} => TimeZoneEnd
            {
                sTimeZoneOffset  = NJIntFromString(sMatch + 1, 2) * 60 * 60 + NJIntFromString(sMatch + 4, 2) * 60;
                sTimeZoneOffset *= (*sMatch == '+') ? 1.0 : -1.0;
                continue;
            }

        <TimeZoneBegin> SIGN DIGIT{2} DIGIT{2} => TimeZoneEnd
            {
                sTimeZoneOffset  = NJIntFromString(sMatch + 1, 2) * 60 * 60 + NJIntFromString(sMatch + 3, 2) * 60;
                sTimeZoneOffset *= (*sMatch == '+') ? 1.0 : -1.0;
                continue;
            }

        <TimeZoneBegin> SIGN DIGIT{2} => TimeZoneEnd
            {
                sTimeZoneOffset  = NJIntFromString(sMatch + 1, 2) * 60 * 60;
                sTimeZoneOffset *= (*sMatch == '+') ? 1.0 : -1.0;
                continue;
            }


        <TimeZoneEnd> SOLIDUS
            {
                break;
            }

        <TimeZoneEnd> NULL
            {
                dateComponents.timeZone = [NSTimeZone timeZoneForSecondsFromGMT: sTimeZoneOffset];
                return toDate(dateComponents);
            }


        <DurationBegin> ANY
            {
                break;
            }


        <RecurringIntervalBegin> ANY
            {
                break;
            }


        <*> NULL
            {
                break;
            }

        <*> ANY
            {
                break;
            }

        */
    }
    return nil;
}
