#import "CDSymbolsGeneratorVisitor.h"
#import "CDOCProtocol.h"
#import "CDOCClass.h"
#import "CDOCCategory.h"
#import "CDOCMethod.h"
#import "CDVisitorPropertyState.h"
#import "CDOCInstanceVariable.h"
#import "CDOCProperty.h"
#import "CDObjectiveCProcessor.h"
#import "CDMachOFile.h"
#import "CDType.h"

/*static const int maxLettersSet = 3;
static NSString *const lettersSet[maxLettersSet] = {
        @"abcdefghijklmnopqrstuvwxyz",
        @"0123456789",
        @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
};*/
#define confuseDataArray (@[@"ResignActive",@"Raise",@"Team",@"Subtract",@"Dear",@"Solve",@"Wire",@"Event",@"Enemy",@"Metal",@"Cost",@"Particular",@"Reply",@"Whether",@"Lost",@"Deal",@"Drink",@"Push",@"Brown",@"Swim",@"Occur",@"Seven",@"Wear",@"Term",@"Support",@"Paragraph",@"Garden",@"Opposite",@"Speech",@"Third",@"Equal",@"Wife",@"Nature",@"Shall",@"Sent",@"Shoe",@"Range",@"Held",@"Choose",@"Shoulder",@"Steam",@"Hair",@"Fell",@"Spread",@"Motion",@"Describe",@"Fit",@"Arrange",@"Path",@"Cook",@"Flow",@"Camp",@"Liquid",@"Floor",@"Fair",@"Invent",@"Log",@"Either",@"Bank",@"Cotton",@"Meant",@"Result",@"Collect",@"Born",@"Quotient",@"Burn",@"Save",@"Determine",@"Teeth",@"Hill",@"Control",@"Quart",@"Shell",@"Safe",@"Decimal",@"Nine",@"Neck",@"Grass",@"Office",@"Hurry",@"Parent",@"Cow",@"Receive",@"Chief",@"Shore",@"Job",@"Row",@"Colony",@"Division",@"Edge",@"Mouth",@"Clock",@"Sheet",@"Sign",@"Exact",@"Mine",@"Substance",@"Visit",@"Symbol",@"Tie",@"Favor",@"Past",@"Die",@"Enter",@"Connect",@"Soft",@"Least",@"Major",@"Post",@"Fun",@"Trouble",@"Fresh",@"Spend",@"Bright",@"Shout",@"Search",@"Chord",@"Gas",@"Except",@"Send",@"Fat",@"Weather",@"Wrote",@"Yellow",@"Glad",@"Month",@"Seed",@"Gun",@"Original",@"Million",@"Tone",@"Allow",@"Share",@"Bear",@"Join",@"Print",@"Station",@"Finish",@"Suggest",@"Dead",@"Dad",@"Happy",@"Clean",@"Spot",@"Bread",@"Hope",@"Break",@"Desert",@"Charge",@"Flower",@"Lady",@"Suit",@"Proper",@"Clothe",@"Yard",@"Current",@"Bar",@"Strange",@"Rise",@"Lift",@"Offer",@"Gone",@"Bad",@"Rose",@"Segment",@"Jump",@"Blow",@"Continue",@"Slave",@"Baby",@"Oil",@"Block",@"Duck",@"Eight",@"Blood",@"Chart",@"Instant",@"Village",@"Touch",@"Hat",@"Market",@"Meet",@"Grew",@"Sell",@"Degree",@"Root",@"Cent",@"Success",@"Populate",@"Buy",@"Mix",@"Company",@"Chick",@"Cell",@"Pay",@"Process",@"Guide",@"Believe",@"Age",@"Operate",@"Experience",@"Fraction",@"Section",@"Guess",@"Score",@"Forest",@"Dress",@"Necessary",@"Apple",@"Sit",@"Cloud",@"Sharp",@"Bought",@"Race",@"Surprise",@"Wing",@"Led",@"Window",@"Quiet",@"Create",@"Pitch",@"Store",@"Stone",@"Neighbor",@"Coat",@"Summer",@"Tiny",@"Wash",@"Mass",@"Train",@"Climb",@"Bat",@"Card",@"Sleep",@"Cool",@"Rather",@"Band",@"Prove",@"Design",@"Crowd",@"Rope",@"Lone",@"Poor",@"Corn",@"Slip",@"Leg",@"Lot",@"Compare",@"Win",@"Exercise",@"Experiment",@"Poem",@"Dream",@"Wall",@"Bottom",@"String",@"Evening",@"Catch",@"Key",@"Bell",@"Condition",@"Mount",@"Iron",@"Depend",@"Feed",@"Wish",@"Single",@"Meat",@"Tool",@"Sky",@"Stick",@"Rub",@"Total",@"Board",@"Flat",@"Tube",@"Basic",@"Joy",@"Twenty",@"Famous",@"Smell",@"Winter",@"Skin",@"Dollar",@"Valley",@"Sat",@"Smile",@"Stream",@"Nor",@"Written",@"Crease",@"Fear",@"Double",@"Wild",@"Hole",@"Sight",@"Seat",@"Instrument",@"Trade",@"Thin",@"Arrive",@"Kept",@"Melody",@"Triangle",@"Master",@"Glass",@"Trip",@"Planet",@"Track",@"Speak",@"Lie",@"Spoke",@"Salt",@"Weight",@"Beat",@"Atom",@"Nose",@"General",@"Excite",@"Human",@"Plural",@"Ice",@"Natural",@"History",@"Anger",@"Matter",@"View",@"Effect",@"Claim",@"Circle",@"Sense",@"Electric",@"Continent",@"Pair",@"Ear",@"Expect",@"Oxygen",@"Include",@"Else",@"Crop",@"Sugar",@"Divide",@"Quite",@"Modern",@"Death",@"Syllable",@"Broke",@"Element",@"Pretty",@"Felt",@"Case",@"Hit",@"Skill",@"Perhaps",@"Middle",@"Student",@"Women",@"Pick",@"Kill",@"Corner",@"Season",@"Sudden",@"Son",@"Party",@"Solution",@"Count",@"Lake",@"Supply",@"Magnet",@"Square",@"Moment",@"Bone",@"Silver",@"Reason",@"Scale",@"Rail",@"Thank",@"Length",@"Loud",@"Imagine",@"Branch",@"Represent",@"Spring",@"Provide",@"Match",@"Art",@"Observe",@"Agree",@"Suffix",@"Subject",@"Child",@"Thus",@"Especially",@"Region",@"Straight",@"Capital",@"Fig",@"Energy",@"Consonant",@"Afraid",@"Hunt",@"Nation",@"Chair",@"Huge",@"Probable",@"Dictionary",@"Danger",@"Sister",@"Bed",@"Milk",@"Fruit",@"Steel",@"Brother",@"Speed",@"Rich",@"Discuss",@"Egg",@"Method",@"Thick",@"Forward",@"Ride",@"Organ",@"Soldier",@"Similar",@"Year",@"Fast",@"Tire",@"Came",@"While",@"Verb",@"Bring",@"Show",@"Press",@"Sing",@"Yes",@"Every",@"Close",@"Listen",@"Distant",@"Good",@"Night",@"Six",@"Fill",@"Me",@"Real",@"Table",@"East",@"Give",@"Life",@"Travel",@"Paint",@"Our",@"Few",@"Less",@"Language",@"Under",@"North",@"Morning",@"Among",@"Grand",@"Cat",@"Gentle",@"Truck",@"Ball",@"Century",@"Woman",@"Noise",@"Yet",@"Consider",@"Captain",@"Level",@"Wave",@"Type",@"Practice",@"Chance",@"Drop",@"Law",@"Separate",@"Gather",@"Heart",@"Bit",@"Difficult",@"Shop",@"Am",@"Coast",@"Doctor",@"Stretch",@"Present",@"Copy",@"Please",@"Throw",@"Heavy",@"Phrase",@"Protect",@"Shine",@"Dance",@"Silent",@"Noon",@"Property",@"Engine",@"Tall",@"Whose",@"Column",@"Position",@"Sand",@"Locate",@"Molecule",@"Arm",@"Soil",@"Ring",@"Select",@"Wide",@"Roll",@"Character",@"Wrong",@"Sail",@"Temperature",@"Insect",@"Gray",@"Material",@"Finger",@"Caught",@"Repeat",@"Size",@"Industry",@"Period",@"Require",@"Vary",@"Value",@"Indicate",@"Broad",@"Settle",@"Fight",@"Radio",@"Prepare",@"Over",@"Learn",@"Order",@"Deep",@"Know",@"Plant",@"Fire",@"Moon",@"Water",@"Cover",@"South",@"Island",@"Than",@"Food",@"Problem",@"Foot",@"Call",@"Sun",@"Piece",@"System",@"First",@"Four",@"Told",@"Busy",@"Who",@"Between",@"Knew",@"Test",@"May",@"State",@"Pass",@"Record",@"Down",@"Keep",@"Since",@"Boat",@"Side",@"Eye",@"Top",@"Common",@"Been",@"Never",@"Whole",@"Gold",@"Now",@"Last",@"King",@"Possible",@"Find",@"Let",@"Space",@"Plane",@"Any",@"Thought",@"Heard",@"Stead",@"New",@"City",@"Best",@"Dry",@"Work",@"Tree",@"Hour",@"Wonder",@"Part",@"Cross",@"Better",@"Laugh",@"Take",@"Farm",@"True",@"Thousand",@"Get",@"Hard",@"During",@"Ago",@"Place",@"Start",@"Hundred",@"Ran",@"Made",@"Might",@"Five",@"Check",@"Live",@"Story",@"Remember",@"Game",@"Where",@"Saw",@"Step",@"Shape",@"After",@"Far",@"Early",@"Equate",@"Back",@"Sea",@"Hold",@"Hot",@"Little",@"Draw",@"West",@"Miss",@"Only",@"Left",@"Ground",@"Brought",@"Round",@"Late",@"Interest",@"Heat",@"Man",@"Run",@"Reach",@"Snow",@"Many",@"Kind",@"Red",@"Green",@"Then",@"Off",@"List",@"Oh",@"Them",@"Need",@"Though",@"Quick",@"Write",@"House",@"Feel",@"Develop",@"Would",@"Picture",@"Talk",@"Ocean",@"Like",@"Try",@"Bird",@"Warm",@"So",@"Us",@"Soon",@"Free",@"These",@"Again",@"Body",@"Minute",@"Her",@"Animal",@"Dog",@"Strong",@"Long",@"Point",@"Family",@"Special",@"Make",@"Mother",@"Direct",@"Mind",@"Thing",@"World",@"Pose",@"Behind",@"See",@"Near",@"Leave",@"Clear",@"Him",@"Build",@"Song",@"Tail",@"Two",@"Self",@"Measure",@"Produce",@"Has",@"Earth",@"Door",@"Fact",@"Look",@"Father",@"Product",@"Street",@"More",@"Head",@"Black",@"Inch",@"Day",@"Stand",@"Short",@"Multiply",@"Could",@"Own",@"Numeral",@"Nothing",@"Go",@"Page",@"Class",@"Course",@"Come",@"Should",@"Wind",@"Stay",@"Did",@"Country",@"Question",@"Wheel",@"Number",@"Found",@"Happen",@"Full",@"Sound",@"Answer",@"Complete",@"Force",@"No",@"School",@"Ship",@"Blue",@"Most",@"Grow",@"Area",@"Object",@"People",@"Study",@"Half",@"Decide",@"My",@"Still",@"Rock",@"Surface",@"Hot",@"Air",@"Took",@"Certain",@"Word",@"Well",@"Science",@"Fly",@"But",@"Also",@"Eat",@"Fall",@"What",@"Play",@"Room",@"Lead",@"Some",@"Small",@"Friend",@"Cry",@"We",@"End",@"Began",@"Dark",@"Can",@"Put",@"Idea",@"Machine",@"Out",@"Home",@"Fish",@"Note",@"Other",@"Read",@"Mountain",@"Wait",@"Were",@"Hand",@"Stop",@"Plan",@"All",@"Port",@"Once",@"Figure",@"There",@"Large",@"Base",@"Star",@"When",@"Spell",@"Hear",@"Box",@"Up",@"Add",@"Horse",@"Noun",@"Use",@"Even",@"Cut",@"Field",@"Your",@"Land",@"Sure",@"Rest",@"How",@"Here",@"Watch",@"Correct",@"Said",@"Must",@"Color",@"Able",@"An",@"Big",@"Face",@"Pound",@"Each",@"High",@"Wood",@"Done",@"She",@"Such",@"Main",@"Beauty",@"Which",@"Follow",@"Enough",@"Drive",@"Do",@"Act",@"Plain",@"Stood",@"Their",@"Why",@"Girl",@"Contain",@"Time",@"Ask",@"Usual",@"Front",@"If",@"Men",@"Young",@"Teach",@"Will",@"Change",@"Ready",@"Week",@"Way",@"Went",@"Above",@"Final",@"About",@"Light",@"Ever",@"Gave",@"The",@"Name",@"Open",@"Ten",@"Of",@"Very",@"Seem",@"Simple",@"To",@"Through",@"Together",@"Several",@"And",@"Just",@"Next",@"Vowel",@"A",@"Form",@"White",@"Toward",@"In",@"Sentence",@"Children",@"War",@"Is",@"Great",@"Begin",@"Lay",@"It",@"Think",@"Got",@"Against",@"You",@"Say",@"Walk",@"Pattern",@"That",@"Help",@"Example",@"Slow",@"He",@"Low",@"Ease",@"Center",@"Was",@"Line",@"Paper",@"Love",@"For",@"Differ",@"Group",@"Person",@"On",@"Turn",@"Always",@"Money",@"Are",@"Cause",@"Music",@"Serve",@"With",@"Much",@"Those",@"Appear",@"As",@"Mean",@"Both",@"Road",@"I",@"Before",@"Mark",@"Map",@"His",@"Move",@"Often",@"Rain",@"They",@"Right",@"Letter",@"Rule",@"Be",@"Boy",@"Until",@"Govern",@"At",@"Old",@"Mile",@"Pull",@"One",@"Too",@"River",@"Cold",@"Have",@"Same",@"Car",@"Notice",@"This",@"Tell",@"Feet",@"Voice",@"From",@"Does",@"Care",@"Unit",@"Or",@"Set",@"Second",@"Power",@"Had",@"Three",@"Book",@"Town",@"By",@"Want",@"Carry",@"Fine"])

@implementation CDSymbolsGeneratorVisitor {
    NSMutableSet *_protocolNames;
    NSMutableSet *_classNames;
    NSMutableSet *_categoryNames;
    NSMutableSet *_propertyNames;
    NSMutableSet *_methodNames;
    NSMutableSet *_ivarNames;
    NSMutableSet *_forbiddenNames;

    NSMutableDictionary *_symbols;
    NSMutableSet *_uniqueSymbols;

    NSInteger _symbolLength;
    BOOL _external;
    BOOL _ignored;

    NSMutableString *_resultString;
}

- (void)addForbiddenSymbols {
    [_forbiddenNames addObjectsFromArray:@[@"auto",
            @"break",
            @"case",
            @"char",
            @"const",
            @"continue",
            @"default",
            @"do",
            @"double",
            @"else",
            @"enum",
            @"extern",
            @"float",
            @"for",
            @"goto",
            @"if",
            @"bool",
            @"int",
            @"long",
            @"register",
            @"return",
            @"short",
            @"signed",
            @"sizeof",
            @"static",
            @"struct",
            @"switch",
            @"typedef",
            @"union",
            @"unsigned",
            @"void",
            @"volatile",
            @"while",
            @"in",
            @"init",
            @"alloc",
            @"_inline",
            @"_Bool"
    ]];
}

- (void)willBeginVisiting {
    _protocolNames = [NSMutableSet new];
    _classNames = [NSMutableSet new];
    _categoryNames = [NSMutableSet new];
    _propertyNames = [NSMutableSet new];
    _methodNames = [NSMutableSet new];
    _ivarNames = [NSMutableSet new];
    _symbols = [NSMutableDictionary new];
    _uniqueSymbols = [NSMutableSet new];
    _forbiddenNames = [NSMutableSet new];
    _symbolLength = 3;
    _external = NO;
    _ignored = NO;
    [self addForbiddenSymbols];
}

- (void)didEndVisiting {
    NSLog(@"Generating symbol table...");
    NSLog(@"Protocols = %zd", _protocolNames.count);
    NSLog(@"Classes = %zd", _classNames.count);
    NSLog(@"Categories = %zd", _categoryNames.count);
    NSLog(@"Methods = %zd", _methodNames.count);
    NSLog(@"I-vars = %zd", _ivarNames.count);
    NSLog(@"Forbidden keywords = %zd", _forbiddenNames.count);

    _resultString = [NSMutableString new];

    NSArray *propertyNames = [_propertyNames.allObjects sortedArrayUsingComparator:^NSComparisonResult(NSString *n1, NSString *n2) {
        if (n1.length > n2.length)
            return NSOrderedDescending;
        if (n1.length < n2.length)
            return NSOrderedAscending;
        return NSOrderedSame;
    }];

    [_resultString appendFormat:@"// Properties\r\n"];
    for (NSString *propertyName in propertyNames) {
        [self generatePropertySymbols:propertyName];
    }
    [_resultString appendFormat:@"\r\n"];

    [_resultString appendFormat:@"// Protocols\r\n"];
    for (NSString *protocolName in _protocolNames) {
        [self generateSimpleSymbols:protocolName];
    }
    [_resultString appendFormat:@"\r\n"];

    [_resultString appendFormat:@"// Classes\r\n"];
    for (NSString *className in _classNames) {
        [self generateSimpleSymbols:className];
    }
    [_resultString appendFormat:@"\r\n"];

    [_resultString appendFormat:@"// Categories\r\n"];
    for (NSString *categoryName in _categoryNames) {
        [self generateSimpleSymbols:categoryName];
    }
    [_resultString appendFormat:@"\r\n"];

    [_resultString appendFormat:@"// Methods\r\n"];
    for (NSString *methodName in _methodNames) {
        [self generateMethodSymbols:methodName];
    }
    [_resultString appendFormat:@"\r\n"];

    [_resultString appendFormat:@"// I-vars\r\n"];
    for (NSString *ivarName in _ivarNames) {
        [self generateSimpleSymbols:ivarName];
    }
    [_resultString appendFormat:@"\r\n"];

    NSData *data = [_resultString dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:self.symbolsFilePath atomically:YES];

    NSLog(@"Done generating symbol table.");
    NSLog(@"Generated unique symbols = %zd", _uniqueSymbols.count);
}

- (NSString *)generateRandomStringWithLength:(NSInteger)length andPrefix:(NSString *)prefix {
   /* while (true) {
        NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
        if (prefix) {
            [randomString appendString:prefix];
        }

        for (int i = 0; i < length; i++) {
            NSString *letters = lettersSet[MIN(i, maxLettersSet - 1)];
            NSInteger index = arc4random_uniform((u_int32_t) letters.length);
            [randomString appendString:[letters substringWithRange:NSMakeRange(index, 1)]];
        }

        if ([_uniqueSymbols containsObject:randomString]) {
            ++length;
            continue;
        }

        return randomString;
    }*/

    while (true) {
        NSMutableString * randomStr = [NSMutableString stringWithCapacity:length];
        if (prefix) {
            [randomStr appendString:prefix];
        }
        NSInteger appendIndex = 0;
        while (appendIndex<length) {
            NSInteger index = arc4random_uniform((uint32_t) [confuseDataArray count]);
            NSString * str = confuseDataArray[index];
            if(str.length + appendIndex <= length){
                [randomStr appendString:str];
                appendIndex += str.length;
            }else{
                [randomStr appendString:[str substringToIndex:length - appendIndex]];
                appendIndex += length - appendIndex;
            }
        }
        
        if([_uniqueSymbols containsObject:randomStr]){
            ++length;
            continue;
        }else{
            return randomStr;
        }
    }
}

- (NSString *)generateRandomStringWithLength:(NSUInteger)length {
    return [self generateRandomStringWithLength:length andPrefix:nil];
}

- (NSString *)generateRandomStringWithPrefix:(NSString *)prefix length:(NSUInteger)length {
    return [self generateRandomStringWithLength:length andPrefix:prefix];
}

- (BOOL)doesContainGeneratedSymbol:(NSString *)symbol {
    return _symbols[symbol] != nil;
}

- (void)generateSimpleSymbols:(NSString *)symbolName {
    if ([self doesContainGeneratedSymbol:symbolName]) {
        return;
    }
    if ([self shouldSymbolsBeIgnored:symbolName]) {
        return;
    }
    NSString *newSymbolName = [self generateRandomStringWithLength:symbolName.length];
    [self addGenerated:newSymbolName forSymbol:symbolName];
}

- (bool)isInitMethod:(NSString *)symbolName {
    if (![symbolName hasPrefix:@"init"]) {
        return NO;
    }

    // just "init"
    if (symbolName.length == 4) {
        return YES;
    }

    // we expect that next character after init is in UPPER CASE
    return isupper([symbolName characterAtIndex:4]) != 0;

}

- (NSString *)getterNameForMethodName:(NSString *)methodName {
    NSString *setterPrefix = @"set";
    BOOL hasSetterPrefix = [methodName hasPrefix:setterPrefix];
    BOOL isEqualToSetter = [methodName isEqualToString:setterPrefix];

    if (hasSetterPrefix && !isEqualToSetter) {
        BOOL isFirstLetterAfterPrefixUppercase = [[methodName substringFromIndex:setterPrefix.length] isFirstLetterUppercase];

        NSString *methodNameToObfuscate = methodName;

        // exclude method names like setupSomething
        if (isFirstLetterAfterPrefixUppercase) {
            methodNameToObfuscate = [methodName stringByReplacingCharactersInRange:NSMakeRange(0, setterPrefix.length) withString:@""];
        }

        if (![self shouldSymbolStartWithLowercase:methodNameToObfuscate]) {
            return methodNameToObfuscate;
        } else {
            return [methodNameToObfuscate lowercaseFirstCharacter];
        }
    } else {
        return methodName;
    }
}

- (BOOL)shouldSymbolStartWithLowercase:(NSString *)symbol {
    // if two first characters in symbol are uppercase name should not be changed to lowercase
    if (symbol.length > 1) {
        NSString *prefix = [symbol substringToIndex:2];
        if ([prefix isEqualToString:[prefix uppercaseString]]) {
            return NO;
        }
    } else if ([symbol isEqualToString:[symbol uppercaseString]]) {
        return NO;
    }
    return YES;
}

- (NSString *)setterNameForMethodName:(NSString *)methodName {
    NSString *setterPrefix = @"set";
    BOOL hasSetterPrefix = [methodName hasPrefix:setterPrefix];
    BOOL isEqualToSetter = [methodName isEqualToString:setterPrefix];

    if (hasSetterPrefix && !isEqualToSetter) {
        BOOL isFirstLetterAfterPrefixUppercase = [[methodName substringFromIndex:setterPrefix.length] isFirstLetterUppercase];
        // Excludes methods like setupSomething
        if (isFirstLetterAfterPrefixUppercase) {
            return methodName;
        } else {
            return [setterPrefix stringByAppendingString:[methodName capitalizeFirstCharacter]];
        }
    } else {
        return [setterPrefix stringByAppendingString:[methodName capitalizeFirstCharacter]];
    }
}

- (void)generateMethodSymbols:(NSString *)symbolName {
    NSString *getterName = [self getterNameForMethodName:symbolName];
    NSString *setterName = [self setterNameForMethodName:symbolName];

    if ([self doesContainGeneratedSymbol:getterName] && [self doesContainGeneratedSymbol:setterName]) {
        return;
    }
    if ([self shouldSymbolsBeIgnored:getterName] || [self shouldSymbolsBeIgnored:setterName]) {
        return;
    }
    if ([self isInitMethod:symbolName]) {
        NSString *initPrefix = @"initL";
        NSString *newSymbolName = [self generateRandomStringWithPrefix:initPrefix length:symbolName.length - initPrefix.length];
        [self addGenerated:newSymbolName forSymbol:symbolName];
    } else {
        NSString *newSymbolName = [self generateRandomStringWithLength:symbolName.length];
        [self addGenerated:newSymbolName forSymbol:getterName];
        [self addGenerated:[@"set" stringByAppendingString:[newSymbolName capitalizeFirstCharacter]] forSymbol:setterName];
    }
}

- (NSString *)plainIvarPropertyName:(NSString *)propertyName {
    return [@"_" stringByAppendingString:[self plainGetterName:propertyName]];
}

- (NSString *)isIvarPropertyName:(NSString *)propertyName {
    return [@"_" stringByAppendingString:[self isGetterName:propertyName]];
}

- (NSString *)plainGetterName:(NSString *)propertyName {
    if ([propertyName hasPrefix:@"is"] && ![propertyName isEqualToString:@"is"]) {
        NSString *string = [propertyName stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
        // If property name is all upper case then don't change first letter to lower case e.g. URL should remain URL, not uRL
        if (![self shouldSymbolStartWithLowercase:string]) {
            return string;
        } else {
            return [string lowercaseFirstCharacter];
        }
    } else if (![self shouldSymbolStartWithLowercase:propertyName]){
        return propertyName;
    } else {
        return [propertyName lowercaseFirstCharacter];
    }
}

- (NSString *)isGetterName:(NSString *)propertyName {
    if ([propertyName hasPrefix:@"is"] && ![propertyName isEqualToString:@"is"]) {
        return propertyName;
    } else {
        return [@"is" stringByAppendingString:[propertyName capitalizeFirstCharacter]];
    }
}

- (NSString *)plainSetterPropertyName:(NSString *)propertyName {
    return [@"set" stringByAppendingString:[[self plainGetterName:propertyName] capitalizeFirstCharacter]];
}

- (NSString *)isSetterPropertyName:(NSString *)propertyName {
    return [@"set" stringByAppendingString:[[self isGetterName:propertyName] capitalizeFirstCharacter]];
}

- (void)addGenerated:(NSString *)generatedSymbol forSymbol:(NSString *)symbol {
    [_uniqueSymbols addObject:generatedSymbol];
    _symbols[symbol] = generatedSymbol;

    [_resultString appendFormat:@"#ifndef %@\r\n", symbol];
    [_resultString appendFormat:@"#define %@ %@\r\n", symbol, generatedSymbol];
    [_resultString appendFormat:@"#endif // %@\r\n", symbol];
}

- (void)generatePropertySymbols:(NSString *)propertyName {
    NSArray *symbols = [self symbolsForProperty:propertyName];
    BOOL shouldSymbolBeIgnored = NO;
    for (NSString *symbolName in symbols) {
        if ([self shouldSymbolsBeIgnored:symbolName]) {
            shouldSymbolBeIgnored = YES;
            break;
        }
    }

    // don't generate symbol if any of the name is forbidden
    if (shouldSymbolBeIgnored) {
        [_forbiddenNames addObjectsFromArray:symbols];
        return;
    }

    NSString *newPropertyName = _symbols[propertyName];

    // reuse previously generated symbol
    if (newPropertyName) {
        NSDictionary *symbolMapping = [self symbolMappingForOriginalPropertyName:propertyName generatedPropertyName:newPropertyName];
        for (NSString *key in symbolMapping.allKeys) {
            [self addGenerated:symbolMapping[key] forSymbol:key];
        }
        return;
    }

    [self createNewSymbolsForProperty:propertyName];

}

- (void)createNewSymbolsForProperty:(NSString *)propertyName {
    NSInteger symbolLength = propertyName.length;

    while (true) {
        NSString *newPropertyName = [self generateRandomStringWithLength:symbolLength andPrefix:nil];
        NSArray *symbols = [self symbolsForProperty:newPropertyName];

        BOOL isAlreadyGenerated = NO;
        for (NSString *symbolName in symbols) {
            if ([_uniqueSymbols containsObject:symbolName]) {
                isAlreadyGenerated = YES;
                break;
            }
        }
        // check if symbol is already generated
        if (!isAlreadyGenerated) {
            NSDictionary *symbolMapping = [self symbolMappingForOriginalPropertyName:propertyName generatedPropertyName:newPropertyName];
            for (NSString *key in symbolMapping.allKeys) {
                [self addGenerated:symbolMapping[key] forSymbol:key];
            }
            return;
        }

        ++symbolLength;
    }
}

- (NSDictionary *)symbolMappingForOriginalPropertyName:(NSString *)originalPropertyName generatedPropertyName:(NSString *)generatedName {
    NSString *ivarName = [self plainIvarPropertyName:originalPropertyName];
    NSString *isIvarName = [self isIvarPropertyName:originalPropertyName];
    NSString *getterName = [self plainGetterName:originalPropertyName];
    NSString *isGetterName = [self isGetterName:originalPropertyName];
    NSString *setterName = [self plainSetterPropertyName:originalPropertyName];
    NSString *isSetterName = [self isSetterPropertyName:originalPropertyName];

    NSString *newIvarName = [self plainIvarPropertyName:generatedName];
    NSString *newIsIvarName = [self isIvarPropertyName:generatedName];
    NSString *newGetterName = [self plainGetterName:generatedName];
    NSString *newIsGetterName = [self isGetterName:generatedName];
    NSString *newSetterName = [self plainSetterPropertyName:generatedName];
    NSString *newIsSetterName = [self isSetterPropertyName:generatedName];

    return @{ivarName : newIvarName,
            isIvarName : newIsIvarName,
            getterName : newGetterName,
            isGetterName : newIsGetterName,
            setterName : newSetterName,
            isSetterName : newIsSetterName};
}

- (NSArray *)symbolsForProperty:(NSString *)propertyName {
    NSString *ivarName = [self plainIvarPropertyName:propertyName];
    NSString *isIvarName = [self isIvarPropertyName:propertyName];
    NSString *getterName = [self plainGetterName:propertyName];
    NSString *isGetterName = [self isGetterName:propertyName];
    NSString *setterName = [self plainSetterPropertyName:propertyName];
    NSString *isSetterName = [self isSetterPropertyName:propertyName];

    NSMutableArray *symbols = [NSMutableArray arrayWithObject:ivarName];
    [symbols addObject:isIvarName];
    [symbols addObject:getterName];
    [symbols addObject:isGetterName];
    [symbols addObject:setterName];
    [symbols addObject:isSetterName];
    return symbols;
}

- (BOOL)shouldClassBeObfuscated:(NSString *)className {
    for (NSString *filter in self.classFilter) {
        if ([filter hasPrefix:@"!"]) {
            // negative filter - prefixed with !
            if ([className isLike:[filter substringFromIndex:1]]) {
                return NO;
            }
        } else {
            // positive filter
            if ([className isLike:filter]) {
                return YES;
            }
        }
    }

    return ![self shouldSymbolsBeIgnored:className];
}

- (BOOL)shouldSymbolsBeIgnored:(NSString *)symbolName {
    if ([symbolName hasPrefix:@"."]) { // .cxx_destruct
        return YES;
    }

    if ([_forbiddenNames containsObject:symbolName]) {
        return YES;
    }

    for (NSString *filter in self.ignoreSymbols) {
        if ([symbolName isLike:filter]) {
            return YES;
        }
    }

    return NO;
}

#pragma mark - CDVisitor

- (void)willVisitObjectiveCProcessor:(CDObjectiveCProcessor *)processor {
    NSString *importBaseName = processor.machOFile.importBaseName;

    if (importBaseName) {
        NSLog(@"Processing external symbols from %@...", importBaseName);
        _external = YES;
    } else {
        NSLog(@"Processing internal symbols...");
        _external = NO;
    }
}

- (void)willVisitProtocol:(CDOCProtocol *)protocol {
    if (_external) {
        [_forbiddenNames addObject:protocol.name];
        _ignored = YES;
    } else if (![self shouldClassBeObfuscated:protocol.name]) {
        NSLog(@"Ignoring @protocol %@", protocol.name);
        [_forbiddenNames addObject:protocol.name];
        _ignored = YES;
    } else {
        NSLog(@"Obfuscating @protocol %@", protocol.name);
        [_protocolNames addObject:protocol.name];
        _ignored = NO;
    }
}

- (void)willVisitClass:(CDOCClass *)aClass {
    if (_external) {
        [_forbiddenNames addObject:aClass.name];

        if (![aClass.name hasSuffix:@"Delegate"] && ![aClass.name hasSuffix:@"Protocol"]) {
            [_forbiddenNames addObject:[aClass.name stringByAppendingString:@"Delegate"]];
            [_forbiddenNames addObject:[aClass.name stringByAppendingString:@"Protocol"]];
        }

        _ignored = YES;
    } else if (![self shouldClassBeObfuscated:aClass.name]) {
        NSLog(@"Ignoring @class %@", aClass.name);
        [_forbiddenNames addObject:aClass.name];
        _ignored = YES;
    } else {
        NSLog(@"Obfuscating @class %@", aClass.name);
        [_classNames addObject:aClass.name];
        _ignored = NO;
    }
}

- (void)willVisitCategory:(CDOCCategory *)category {
    if (_external) {
        _ignored = YES;
    } else {
        NSLog(@"Obfuscating @category %@+%@", category.className, category.name);
        [_categoryNames addObject:category.name];
        _ignored = NO;
    }
}

- (void)visitClassMethod:(CDOCMethod *)method {
    [self visitAndExplodeMethod:method.name];
}

- (void)visitAndExplodeMethod:(NSString *)method {
    for (NSString *component in [method componentsSeparatedByString:@":"]) {
        if ([component length]) {
            if (_ignored) {
                [_forbiddenNames addObject:component];
            } else {
                [_methodNames addObject:component];
            }
        }
    }
}

- (void)visitInstanceMethod:(CDOCMethod *)method propertyState:(CDVisitorPropertyState *)propertyState {
    [self visitAndExplodeMethod:method.name];

//    if (!_ignored && [method.name rangeOfString:@":"].location == NSNotFound) {
//        [_propertyNames addObject:method.name];
//    }
}

- (void)visitIvar:(CDOCInstanceVariable *)ivar {
    if (_ignored) {
        [self visitType:ivar.type];
    } else {
        [_ivarNames addObject:ivar.name];
    }
}

- (void)visitProperty:(CDOCProperty *)property {
    if (_ignored) {
        [_forbiddenNames addObject:property.name];
        [_forbiddenNames addObject:property.defaultGetter];
        [_forbiddenNames addObject:[@"_" stringByAppendingString:property.name]];
        [_forbiddenNames addObject:property.defaultSetter];
        [self visitType:property.type];
    } else {
        [_propertyNames addObject:property.name];
    }
}

- (void)visitRemainingProperties:(CDVisitorPropertyState *)propertyState {
    for (CDOCProperty *property in propertyState.remainingProperties) {
        [self visitProperty:property];
    }
}

- (void)visitType:(CDType *)type {
    if (_ignored) {
        for (NSString *protocol in type.protocols) {
            [_forbiddenNames addObject:protocol];
        }

        if (type.typeName) {
            [_forbiddenNames addObject:[NSString stringWithFormat:@"%@", type.typeName]];
        }
    }
}

- (void)addSymbolsPadding {
    [_symbols.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *obfuscated = _symbols[key];
        if (key.length > obfuscated.length) {
            _symbols[key] = [self generateRandomStringWithLength:key.length - obfuscated.length andPrefix:obfuscated];
        }
    }];
}

@end
