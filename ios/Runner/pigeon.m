// Autogenerated from Pigeon (v1.0.8), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "pigeon.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ? error.code : [NSNull null]),
        @"message": (error.message ? error.message : [NSNull null]),
        @"details": (error.details ? error.details : [NSNull null]),
        };
  }
  return @{
      @"result": (result ? result : [NSNull null]),
      @"error": errorDict,
      };
}

@interface Book ()
+ (Book *)fromMap:(NSDictionary *)dict;
- (NSDictionary *)toMap;
@end

@implementation Book
+ (Book *)fromMap:(NSDictionary *)dict {
  Book *result = [[Book alloc] init];
  result.title = dict[@"title"];
  if ((NSNull *)result.title == [NSNull null]) {
    result.title = nil;
  }
  result.author = dict[@"author"];
  if ((NSNull *)result.author == [NSNull null]) {
    result.author = nil;
  }
  return result;
}
- (NSDictionary *)toMap {
  return [NSDictionary dictionaryWithObjectsAndKeys:(self.title ? self.title : [NSNull null]), @"title", (self.author ? self.author : [NSNull null]), @"author", nil];
}
@end

@interface BookApiCodecReader : FlutterStandardReader
@end
@implementation BookApiCodecReader
- (nullable id)readValueOfType:(UInt8)type 
{
  switch (type) {
    case 128:     
      return [Book fromMap:[self readValue]];
    
    default:    
      return [super readValueOfType:type];
    
  }
}
@end

@interface BookApiCodecWriter : FlutterStandardWriter
@end
@implementation BookApiCodecWriter
- (void)writeValue:(id)value 
{
  if ([value isKindOfClass:[Book class]]) {
    [self writeByte:128];
    [self writeValue:[value toMap]];
  } else 
{
    [super writeValue:value];
  }
}
@end

@interface BookApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation BookApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[BookApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[BookApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *BookApiGetCodec() {
  static dispatch_once_t s_pred = 0;
  static FlutterStandardMessageCodec *s_sharedObject = nil;
  dispatch_once(&s_pred, ^{
    BookApiCodecReaderWriter *readerWriter = [[BookApiCodecReaderWriter alloc] init];
    s_sharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return s_sharedObject;
}


@interface BookApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger> *binaryMessenger;
@end

@implementation BookApi
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
  self = [super init];
  if (self) {
    _binaryMessenger = binaryMessenger;
  }
  return self;
}

- (void)searchKeyword:(NSString *)arg_keyword completion:(void(^)(NSArray<Book *> *, NSError *_Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.BookApi.search"
      binaryMessenger:self.binaryMessenger
      codec:BookApiGetCodec()];
  [channel sendMessage:@[arg_keyword] reply:^(id reply) {
    NSArray<Book *> *output = reply;
    completion(output, nil);
  }];
}
@end
