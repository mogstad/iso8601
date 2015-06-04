@import XCTest;
@import NJISO8601;

@interface NJISO8601FormatterTests : XCTestCase

@end

static NSString *gTestStrings[][2] =
{
    { @"2011-02-07T19:03:46,123456+09:00", @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+0900",  @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+09",    @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456",       @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+08:00", @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+0800",  @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+08",    @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456Z",      @"2011-02-07T19:03:46,123+0000" },

    { @"2011-02-07T19:03:46.123+09:00",    @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+0900",     @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+09",       @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123",          @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+08:00",    @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+0800",     @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+08",       @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123Z",         @"2011-02-07T19:03:46,123+0000" },

    { @"2011-02-07T190346,123+09:00",      @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T190346,123+0900",       @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T190346,123+09",         @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T190346,123",            @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T190346,123+08:00",      @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T190346,123+0800",       @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T190346,123+08",         @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T190346,123Z",           @"2011-02-07T19:03:46,123+0000" },

    { @"2011-02-07T19:03:46+09:00",        @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T19:03:46+0900",         @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T19:03:46+09",           @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T19:03:46",              @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T19:03:46+08:00",        @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T19:03:46+0800",         @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T19:03:46+08",           @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T19:03:46Z",             @"2011-02-07T19:03:46,000+0000" },

    { @"2011-02-07T190346+09:00",          @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T190346+0900",           @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T190346+09",             @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T190346",                @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T190346+08:00",          @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T190346+0800",           @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T190346+08",             @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T190346Z",               @"2011-02-07T19:03:46,000+0000" },

    { @"2011-02-07T19:03,123+09:00",       @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T19:03,123+0900",        @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T19:03,123+09",          @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T19:03,123",             @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T19:03,123+08:00",       @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T19:03,123+0800",        @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T19:03,123+08",          @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T19:03,123Z",            @"2011-02-07T19:03:07,380+0000" },

    { @"2011-02-07T1903,123+09:00",        @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T1903,123+0900",         @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T1903,123+09",           @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T1903,123",              @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T1903,123+08:00",        @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T1903,123+0800",         @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T1903,123+08",           @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T1903,123Z",             @"2011-02-07T19:03:07,380+0000" },

    { @"2011-02-07T19,123+09:00",          @"2011-02-07T10:07:22,800+0000" },
    { @"2011-02-07T19,123+0900",           @"2011-02-07T10:07:22,800+0000" },
    { @"2011-02-07T19,123+09",             @"2011-02-07T10:07:22,800+0000" },
    { @"2011-02-07T19,123",                @"2011-02-07T10:07:22,800+0000" },
    { @"2011-02-07T19,123+08:00",          @"2011-02-07T11:07:22,800+0000" },
    { @"2011-02-07T19,123+0800",           @"2011-02-07T11:07:22,800+0000" },
    { @"2011-02-07T19,123+08",             @"2011-02-07T11:07:22,800+0000" },
    { @"2011-02-07T19,123Z",               @"2011-02-07T19:07:22,800+0000" },

    { @"2011-02-07T19+09:00",              @"2011-02-07T10:00:00,000+0000" },
    { @"2011-02-07T19+0900",               @"2011-02-07T10:00:00,000+0000" },
    { @"2011-02-07T19+09",                 @"2011-02-07T10:00:00,000+0000" },
    { @"2011-02-07T19",                    @"2011-02-07T10:00:00,000+0000" },
    { @"2011-02-07T19+08:00",              @"2011-02-07T11:00:00,000+0000" },
    { @"2011-02-07T19+0800",               @"2011-02-07T11:00:00,000+0000" },
    { @"2011-02-07T19+08",                 @"2011-02-07T11:00:00,000+0000" },
    { @"2011-02-07T19Z",                   @"2011-02-07T19:00:00,000+0000" },

    { @"20110207T19:03:46,123456+09:00",   @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123456+0900",    @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123456+09",      @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123456",         @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123456+08:00",   @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123456+0800",    @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123456+08",      @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123456Z",        @"2011-02-07T19:03:46,123+0000" },

    { @"20110207T19:03:46,123+09:00",      @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123+0900",       @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123+09",         @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123",            @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123+08:00",      @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123+0800",       @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123+08",         @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123Z",           @"2011-02-07T19:03:46,123+0000" },

    { @"20110207T190346,123+09:00",        @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T190346,123+0900",         @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T190346,123+09",           @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T190346,123",              @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T190346,123+08:00",        @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T190346,123+0800",         @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T190346,123+08",           @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T190346,123Z",             @"2011-02-07T19:03:46,123+0000" },

    { @"20110207T19:03:46+09:00",          @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T19:03:46+0900",           @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T19:03:46+09",             @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T19:03:46",                @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T19:03:46+08:00",          @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T19:03:46+0800",           @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T19:03:46+08",             @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T19:03:46Z",               @"2011-02-07T19:03:46,000+0000" },

    { @"20110207T190346+09:00",            @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T190346+0900",             @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T190346+09",               @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T190346",                  @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T190346+08:00",            @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T190346+0800",             @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T190346+08",               @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T190346Z",                 @"2011-02-07T19:03:46,000+0000" },

    { @"20110207T19:03,123+09:00",         @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T19:03,123+0900",          @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T19:03,123+09",            @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T19:03,123",               @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T19:03,123+08:00",         @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T19:03,123+0800",          @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T19:03,123+08",            @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T19:03,123Z",              @"2011-02-07T19:03:07,380+0000" },

    { @"20110207T1903,123+09:00",          @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T1903,123+0900",           @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T1903,123+09",             @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T1903,123",                @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T1903,123+08:00",          @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T1903,123+0800",           @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T1903,123+08",             @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T1903,123Z",               @"2011-02-07T19:03:07,380+0000" },

    { @"20110207T19,123+09:00",            @"2011-02-07T10:07:22,800+0000" },
    { @"20110207T19,123+0900",             @"2011-02-07T10:07:22,800+0000" },
    { @"20110207T19,123+09",               @"2011-02-07T10:07:22,800+0000" },
    { @"20110207T19,123",                  @"2011-02-07T10:07:22,800+0000" },
    { @"20110207T19,123+08:00",            @"2011-02-07T11:07:22,800+0000" },
    { @"20110207T19,123+0800",             @"2011-02-07T11:07:22,800+0000" },
    { @"20110207T19,123+08",               @"2011-02-07T11:07:22,800+0000" },
    { @"20110207T19,123Z",                 @"2011-02-07T19:07:22,800+0000" },

    { @"20110207T19+09:00",                @"2011-02-07T10:00:00,000+0000" },
    { @"20110207T19+0900",                 @"2011-02-07T10:00:00,000+0000" },
    { @"20110207T19+09",                   @"2011-02-07T10:00:00,000+0000" },
    { @"20110207T19",                      @"2011-02-07T10:00:00,000+0000" },
    { @"20110207T19+08:00",                @"2011-02-07T11:00:00,000+0000" },
    { @"20110207T19+0800",                 @"2011-02-07T11:00:00,000+0000" },
    { @"20110207T19+08",                   @"2011-02-07T11:00:00,000+0000" },
    { @"20110207T19Z",                     @"2011-02-07T19:00:00,000+0000" },

    { @"2011-02T19:03:46,123456+09:00",    @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+0900",     @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+09",       @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123456",          @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+08:00",    @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+0800",     @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+08",       @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123456Z",         @"2011-02-01T19:03:46,123+0000" },

    { @"2011-02T19:03:46,123+09:00",       @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123+0900",        @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123+09",          @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123",             @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123+08:00",       @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123+0800",        @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123+08",          @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123Z",            @"2011-02-01T19:03:46,123+0000" },

    { @"2011-02T190346,123+09:00",         @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T190346,123+0900",          @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T190346,123+09",            @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T190346,123",               @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T190346,123+08:00",         @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T190346,123+0800",          @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T190346,123+08",            @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T190346,123Z",              @"2011-02-01T19:03:46,123+0000" },

    { @"2011-02T19:03:46+09:00",           @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T19:03:46+0900",            @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T19:03:46+09",              @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T19:03:46",                 @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T19:03:46+08:00",           @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T19:03:46+0800",            @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T19:03:46+08",              @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T19:03:46Z",                @"2011-02-01T19:03:46,000+0000" },

    { @"2011-02T190346+09:00",             @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T190346+0900",              @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T190346+09",                @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T190346",                   @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T190346+08:00",             @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T190346+0800",              @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T190346+08",                @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T190346Z",                  @"2011-02-01T19:03:46,000+0000" },

    { @"2011-02T19:03,123+09:00",          @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T19:03,123+0900",           @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T19:03,123+09",             @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T19:03,123",                @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T19:03,123+08:00",          @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T19:03,123+0800",           @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T19:03,123+08",             @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T19:03,123Z",               @"2011-02-01T19:03:07,380+0000" },

    { @"2011-02T1903,123+09:00",           @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T1903,123+0900",            @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T1903,123+09",              @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T1903,123",                 @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T1903,123+08:00",           @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T1903,123+0800",            @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T1903,123+08",              @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T1903,123Z",                @"2011-02-01T19:03:07,380+0000" },

    { @"2011-02T19,123+09:00",             @"2011-02-01T10:07:22,800+0000" },
    { @"2011-02T19,123+0900",              @"2011-02-01T10:07:22,800+0000" },
    { @"2011-02T19,123+09",                @"2011-02-01T10:07:22,800+0000" },
    { @"2011-02T19,123",                   @"2011-02-01T10:07:22,800+0000" },
    { @"2011-02T19,123+08:00",             @"2011-02-01T11:07:22,800+0000" },
    { @"2011-02T19,123+0800",              @"2011-02-01T11:07:22,800+0000" },
    { @"2011-02T19,123+08",                @"2011-02-01T11:07:22,800+0000" },
    { @"2011-02T19,123Z",                  @"2011-02-01T19:07:22,800+0000" },

    { @"2011-02T19+09:00",                 @"2011-02-01T10:00:00,000+0000" },
    { @"2011-02T19+0900",                  @"2011-02-01T10:00:00,000+0000" },
    { @"2011-02T19+09",                    @"2011-02-01T10:00:00,000+0000" },
    { @"2011-02T19",                       @"2011-02-01T10:00:00,000+0000" },
    { @"2011-02T19+08:00",                 @"2011-02-01T11:00:00,000+0000" },
    { @"2011-02T19+0800",                  @"2011-02-01T11:00:00,000+0000" },
    { @"2011-02T19+08",                    @"2011-02-01T11:00:00,000+0000" },
    { @"2011-02T19Z",                      @"2011-02-01T19:00:00,000+0000" },

    { @"2011T19:03:46,123456+09:00",       @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123456+0900",        @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123456+09",          @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123456",             @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123456+08:00",       @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123456+0800",        @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123456+08",          @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123456Z",            @"2011-01-01T19:03:46,123+0000" },

    { @"2011T19:03:46,123+09:00",          @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123+0900",           @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123+09",             @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123",                @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123+08:00",          @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123+0800",           @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123+08",             @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123Z",               @"2011-01-01T19:03:46,123+0000" },

    { @"2011T190346,123+09:00",            @"2011-01-01T10:03:46,123+0000" },
    { @"2011T190346,123+0900",             @"2011-01-01T10:03:46,123+0000" },
    { @"2011T190346,123+09",               @"2011-01-01T10:03:46,123+0000" },
    { @"2011T190346,123",                  @"2011-01-01T10:03:46,123+0000" },
    { @"2011T190346,123+08:00",            @"2011-01-01T11:03:46,123+0000" },
    { @"2011T190346,123+0800",             @"2011-01-01T11:03:46,123+0000" },
    { @"2011T190346,123+08",               @"2011-01-01T11:03:46,123+0000" },
    { @"2011T190346,123Z",                 @"2011-01-01T19:03:46,123+0000" },

    { @"2011T19:03:46+09:00",              @"2011-01-01T10:03:46,000+0000" },
    { @"2011T19:03:46+0900",               @"2011-01-01T10:03:46,000+0000" },
    { @"2011T19:03:46+09",                 @"2011-01-01T10:03:46,000+0000" },
    { @"2011T19:03:46",                    @"2011-01-01T10:03:46,000+0000" },
    { @"2011T19:03:46+08:00",              @"2011-01-01T11:03:46,000+0000" },
    { @"2011T19:03:46+0800",               @"2011-01-01T11:03:46,000+0000" },
    { @"2011T19:03:46+08",                 @"2011-01-01T11:03:46,000+0000" },
    { @"2011T19:03:46Z",                   @"2011-01-01T19:03:46,000+0000" },

    { @"2011T190346+09:00",                @"2011-01-01T10:03:46,000+0000" },
    { @"2011T190346+0900",                 @"2011-01-01T10:03:46,000+0000" },
    { @"2011T190346+09",                   @"2011-01-01T10:03:46,000+0000" },
    { @"2011T190346",                      @"2011-01-01T10:03:46,000+0000" },
    { @"2011T190346+08:00",                @"2011-01-01T11:03:46,000+0000" },
    { @"2011T190346+0800",                 @"2011-01-01T11:03:46,000+0000" },
    { @"2011T190346+08",                   @"2011-01-01T11:03:46,000+0000" },
    { @"2011T190346Z",                     @"2011-01-01T19:03:46,000+0000" },

    { @"2011T19:03,123+09:00",             @"2011-01-01T10:03:07,380+0000" },
    { @"2011T19:03,123+0900",              @"2011-01-01T10:03:07,380+0000" },
    { @"2011T19:03,123+09",                @"2011-01-01T10:03:07,380+0000" },
    { @"2011T19:03,123",                   @"2011-01-01T10:03:07,380+0000" },
    { @"2011T19:03,123+08:00",             @"2011-01-01T11:03:07,380+0000" },
    { @"2011T19:03,123+0800",              @"2011-01-01T11:03:07,380+0000" },
    { @"2011T19:03,123+08",                @"2011-01-01T11:03:07,380+0000" },
    { @"2011T19:03,123Z",                  @"2011-01-01T19:03:07,380+0000" },

    { @"2011T1903,123+09:00",              @"2011-01-01T10:03:07,380+0000" },
    { @"2011T1903,123+0900",               @"2011-01-01T10:03:07,380+0000" },
    { @"2011T1903,123+09",                 @"2011-01-01T10:03:07,380+0000" },
    { @"2011T1903,123",                    @"2011-01-01T10:03:07,380+0000" },
    { @"2011T1903,123+08:00",              @"2011-01-01T11:03:07,380+0000" },
    { @"2011T1903,123+0800",               @"2011-01-01T11:03:07,380+0000" },
    { @"2011T1903,123+08",                 @"2011-01-01T11:03:07,380+0000" },
    { @"2011T1903,123Z",                   @"2011-01-01T19:03:07,380+0000" },

    { @"2011T19,123+09:00",                @"2011-01-01T10:07:22,800+0000" },
    { @"2011T19,123+0900",                 @"2011-01-01T10:07:22,800+0000" },
    { @"2011T19,123+09",                   @"2011-01-01T10:07:22,800+0000" },
    { @"2011T19,123",                      @"2011-01-01T10:07:22,800+0000" },
    { @"2011T19,123+08:00",                @"2011-01-01T11:07:22,800+0000" },
    { @"2011T19,123+0800",                 @"2011-01-01T11:07:22,800+0000" },
    { @"2011T19,123+08",                   @"2011-01-01T11:07:22,800+0000" },
    { @"2011T19,123Z",                     @"2011-01-01T19:07:22,800+0000" },

    { @"2011T19+09:00",                    @"2011-01-01T10:00:00,000+0000" },
    { @"2011T19+0900",                     @"2011-01-01T10:00:00,000+0000" },
    { @"2011T19+09",                       @"2011-01-01T10:00:00,000+0000" },
    { @"2011T19",                          @"2011-01-01T10:00:00,000+0000" },
    { @"2011T19+08:00",                    @"2011-01-01T11:00:00,000+0000" },
    { @"2011T19+0800",                     @"2011-01-01T11:00:00,000+0000" },
    { @"2011T19+08",                       @"2011-01-01T11:00:00,000+0000" },
    { @"2011T19Z",                         @"2011-01-01T19:00:00,000+0000" },

    { @"2011-02-07",                       @"2011-02-06T15:00:00,000+0000" },
    { @"20110207",                         @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02",                          @"2011-01-31T15:00:00,000+0000" },
    { @"2011",                             @"2010-12-31T15:00:00,000+0000" },

    { @"2011-02-07T00:00:00+09:00",        @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02-07T00:00:00+0900",         @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02-07T00:00:00+09",           @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02-07T00:00:00",              @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02-07T00:00:00+08:00",        @"2011-02-06T16:00:00,000+0000" },
    { @"2011-02-07T00:00:00+0800",         @"2011-02-06T16:00:00,000+0000" },
    { @"2011-02-07T00:00:00+08",           @"2011-02-06T16:00:00,000+0000" },
    { @"2011-02-07T00:00:00Z",             @"2011-02-07T00:00:00,000+0000" },

    { @"2011-02-07T24:00:00+09:00",        @"2011-02-07T15:00:00,000+0000" },
    { @"2011-02-07T24:00:00+0900",         @"2011-02-07T15:00:00,000+0000" },
    { @"2011-02-07T24:00:00+09",           @"2011-02-07T15:00:00,000+0000" },
    { @"2011-02-07T24:00:00",              @"2011-02-07T15:00:00,000+0000" },
    { @"2011-02-07T24:00:00+08:00",        @"2011-02-07T16:00:00,000+0000" },
    { @"2011-02-07T24:00:00+0800",         @"2011-02-07T16:00:00,000+0000" },
    { @"2011-02-07T24:00:00+08",           @"2011-02-07T16:00:00,000+0000" },
    { @"2011-02-07T24:00:00Z",             @"2011-02-08T00:00:00,000+0000" },

    { @"2011-05-31T24:00:00-09:00",        @"2011-06-01T09:00:00,000+0000" },
    { @"2011-05-31T24:00:00-0900",         @"2011-06-01T09:00:00,000+0000" },
    { @"2011-05-31T24:00:00-09",           @"2011-06-01T09:00:00,000+0000" },
    { @"2011-05-31T24:00:00-08:00",        @"2011-06-01T08:00:00,000+0000" },
    { @"2011-05-31T24:00:00-0800",         @"2011-06-01T08:00:00,000+0000" },
    { @"2011-05-31T24:00:00-08",           @"2011-06-01T08:00:00,000+0000" },
    { @"2011-05-31T24:00:00Z",             @"2011-06-01T00:00:00,000+0000" },

    { nil,                                 nil                             }
};


static NSDateFormatter *gDefaultDateFormatter = nil;


@implementation NJISO8601FormatterTests


+ (void)initialize
{
    if (!gDefaultDateFormatter)
    {
        gDefaultDateFormatter = [[NSDateFormatter alloc] init];
        [gDefaultDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss,SSSZZZ"];
        [gDefaultDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [gDefaultDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    }

    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(9 * 60 * 60)]];
}


- (void)testDateFromString
{
    NJISO8601Formatter *formatter = [[NJISO8601Formatter alloc] init];
    NSDate *date;

    for (int i = 0; gTestStrings[i][0]; i++) {
      date = [formatter dateFromString:gTestStrings[i][0]];
        XCTAssertTrue([gTestStrings[i][1] isEqualToString:[gDefaultDateFormatter stringFromDate:date]], @"%@ == %@ => %@", gTestStrings[i][0], gTestStrings[i][1], [gDefaultDateFormatter stringFromDate:date]);
    }
}


- (void)testError
{
    NSString *sErrorStrings[] = {
        @"2011-02-07T24:01:01Z",
        @"2011-02-07T19:03:60Z",
        @"2011-02-07T19:60:46Z",
        @"2011-02-07T24:03:46Z",
        @"2011-02-00T19:03:46Z",
        @"2011-02-32T19:03:46Z",
        @"2011-13-07T19:03:46Z",
        @"2011-00-07T19:03:46Z",
        @"2011-02-07T19:03:46KST",
        @"2011-02-07T19:03:6Z",
        @"2011-02-07T19:03:6",
        @"2011-02-07T19:1",
        @"2011-02-07T1",
        @"2011-02-07T",
        @"2011-02-1T",
        @"2011-02-1",
        @"2011-0T",
        @"2011-0",
        @"201",
        @"MERONG",
        @"2011-00",
        @"2011-366T",
        @"2011-000",
        @"2011000T",
        @"2011366",
        @"+2011001T",
        nil
    };

    NSString *sUnsupportedStrings[] = {
        @"2011-12-30/",
        @"2011-12-30T12:34/",
        @"P",
        @"R",
        nil,
    };

    NJISO8601Formatter *sFormatter = [[NJISO8601Formatter alloc] init];

    for (int i = 0; sErrorStrings[i]; i++)
    {
        XCTAssertNil([sFormatter dateFromString:sErrorStrings[i]], @"%@ => nil", sErrorStrings[i]);
    }

    for (int i = 0; sUnsupportedStrings[i]; i++)
    {
        XCTAssertNil([sFormatter dateFromString:sUnsupportedStrings[i]], @"%@ => nil", sUnsupportedStrings[i]);
    }

    XCTAssertNil([sFormatter dateFromString:nil], @"");
}


- (void)testZSpeedNJISO8601Formatter
{
    NJISO8601Formatter *formatter = [[NJISO8601Formatter alloc] init];

    [self measureBlock:^{
      for (int i = 0; gTestStrings[i][0]; i++) {
          [formatter dateFromString:gTestStrings[i][0]];
      }
    }];
}


- (void)testZSpeedNSDateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

    [self measureBlock:^{
      for (int i = 0; gTestStrings[i][1]; i++) {
        [formatter dateFromString:gTestStrings[i][0]];
      }
    }];
}


@end
