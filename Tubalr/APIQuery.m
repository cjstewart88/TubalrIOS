//
//  APIQuery.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/2/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "APIQuery.h"

#define STAGING

#define ECHONEST_YOUTUBE_TIMEOUT 5
#define REDDIT_TIMEOUT 6
#define API_TIMEOUT 10

#if defined (DEBUG) && defined (STAGING)
NSString *const kAPIQueryVersionKey			= @"v1";
NSString *const kAPIQueryURL				= @"http://www.tubalr.com";
NSString *const kAPITrackURL                = @"http://www.tubalr.com";
#else
NSString *const kAPIQueryVersionKey			= @"v1";
NSString *const kAPIQueryURL				= @"http://www.tubalr.com";
NSString *const kAPITrackURL                = @"http://www.tubalr.com";
#endif

NSString *const kEchonestVersionKey         = @"v4";
NSString *const kEchonestApiKey             = @"OYJRQNQMCGIOZLFIW";
NSString *const kEchonestStart              = @"0";
NSString *const kEchonestNumberOfSongs      = @"40";
NSString *const kEchonestQueryURL           = @"http://developer.echonest.com/api/%@/%@/%@?api_key=%@&%@=%@%@";

NSString *const kRedditQueryUrl             = @"http://www.reddit.com/r/%@/hot.json?jsonp=?&limit=100";

@interface APIQuery()
{
    NSMutableData *_responseData;	
	NSURLConnection *_connection;
	BOOL _loading;
}

@property (nonatomic, strong) NSURL *requestUrl;
@property (nonatomic) NSTimeInterval timeoutInterval;
@property (nonatomic, strong) NSString *baseRoRApiToken;

@end

@implementation APIQuery

+ (NSArray *)genres
{
    static NSArray *arrayOfGenres;
    if (nil == arrayOfGenres)
    {
        arrayOfGenres = @[@"acappella",@"acidhouse",@"acidjazz",@"acousticblues",@"afrobeat",@"albumrock",@"alternativecountry",@"alternativedance",@"alternativehiphop",@"alternativemetal",@"alternativerock",@"ambient",@"anti-folk",@"artrock",@"atmosphericblackmetal",@"australianhiphop",@"avant-garde",@"avant-gardejazz",@"avantgardemetal",@"bachata",@"bailefunk",@"banda",@"bassmusic",@"bebop",@"bhangra",@"bigband",@"bigbeat",@"blackmetal",@"blue-eyedsoul",@"bluegrass",@"blues",@"blues-rock",@"bolero",@"boogaloo",@"boogie-woogie",@"bossanova",@"brassband",@"brazilianpopmusic",@"breakbeat",@"breakcore",@"brillbuildingpop",@"britishblues",@"britishfolk",@"britishinvasion",@"britishpop",@"brokenbeat",@"brutaldeathmetal",@"bubblegumdance",@"bubblegumpop",@"cabaret",@"calypso",@"canterburyscene",@"ccm",@"celtic",@"celticrock",@"chamberpop",@"chanson",@"chicagoblues",@"chicagohouse",@"chicagosoul",@"children'smusic",@"chill-out",@"chillwave",@"chiptune",@"choro",@"chorus",@"christianalternativerock",@"christianhardcore",@"christianhiphop",@"christianmetal",@"christianmusic",@"christianpunk",@"christianrock",@"classicrock",@"classical",@"comedy",@"contemporarycountry",@"cooljazz",@"country",@"countryblues",@"countrygospel",@"countryrock",@"cowpunk",@"crossoverthrash",@"crunk",@"crustpunk",@"cumbia",@"dancepop",@"dancerock",@"dance-punk",@"dancehall",@"darkambient",@"darkwave",@"deathcore",@"deathmetal",@"deathgrind",@"deephouse",@"deltablues",@"desi",@"detroittechno",@"digitalhardcore",@"dirtysouthrap",@"disco",@"discohouse",@"djent",@"doo-wop",@"doommetal",@"downtempo",@"dreampop",@"drone",@"drumandbass",@"dub",@"dubstep",@"earlymusic",@"eastcoasthiphop",@"easylistening",@"ebm",@"electricblues",@"electro",@"electro-industrial",@"electroclash",@"electronic",@"emo",@"eurobeat",@"eurodance",@"europop",@"exotica",@"experimental",@"experimentalrock",@"fado",@"filmi",@"flamenco",@"folk",@"folkmetal",@"folkpunk",@"folkrock",@"folk-pop",@"freakfolk",@"freakbeat",@"freeimprovisation",@"freejazz",@"freestyle",@"funeraldoom",@"funk",@"funkmetal",@"funkrock",@"futurepop",@"gfunk",@"gabba",@"game",@"gangsterrap",@"garagerock",@"germanpop",@"glammetal",@"glamrock",@"glitch",@"goregrind",@"gospel",@"gothicmetal",@"gothicrock",@"gothicsymphonicmetal",@"grime",@"grindcore",@"groovemetal",@"grunge",@"gypsyjazz",@"happyhardcore",@"hardbop",@"hardhouse",@"hardrock",@"hardtrance",@"hardcore",@"hardcorehiphop",@"hardcoretechno",@"hardstyle",@"harmonicablues",@"hinrg",@"highlife",@"hiphop",@"hiphouse",@"horrorpunk",@"house",@"hyphy",@"icelandicpop",@"illbient",@"indianclassical",@"indiefolk",@"indiepop",@"indierock",@"indietronica",@"industrial",@"industrialmetal",@"industrialrock",@"intelligentdancemusic",@"irishfolk",@"italiandisco",@"jpop",@"jrock",@"jamband",@"janglepop",@"japanoise",@"jazz",@"jazzblues",@"jazzfunk",@"jazzfusion",@"judaica",@"jugband",@"juggalo",@"jumpblues",@"junglemusic",@"kpop",@"kiwirock",@"klezmer",@"kompa",@"krautrock",@"kwaito",@"laiko",@"latin",@"latinalternative",@"latinjazz",@"latinpop",@"lo-fi",@"louisianablues",@"lounge",@"loversrock",@"madchester",@"mambo",@"mariachi",@"martialindustrial",@"mathrock",@"mathcore",@"medieval",@"mellowgold",@"melodicdeathmetal",@"melodichardcore",@"melodicmetalcore",@"memphisblues",@"memphissoul",@"merengue",@"merseybeat",@"metal",@"metalcore",@"minimal",@"modernblues",@"modernclassical",@"motown",@"mpb",@"musiqueconcrete",@"nashvillesound",@"nativeamerican",@"neoclassicalmetal",@"neosoul",@"neo-progressive",@"neoclassical",@"neofolk",@"neuedeutscheharte",@"newage",@"newbeat",@"newjackswing",@"neworleansblues",@"neworleansjazz",@"newrave",@"newromantic",@"newwave",@"newweirdamerica",@"ninja",@"nowave",@"noisepop",@"noiserock",@"northernsoul",@"nujazz",@"numetal",@"nuskoolbreaks",@"nwobhm",@"oi",@"oldschoolhiphop",@"opera",@"oratory",@"outlawcountry",@"paganblackmetal",@"pianoblues",@"pianorock",@"piedmontblues",@"polka",@"pop",@"poppunk",@"poprap",@"poprock",@"portugueserock",@"postrock",@"post-grunge",@"post-hardcore",@"post-metal",@"post-punk",@"powerelectronics",@"powermetal",@"powernoise",@"powerpop",@"powerviolence",@"progressivebluegrass",@"progressivehouse",@"progressivemetal",@"progressiverock",@"progressivetrance",@"protopunk",@"psychedelicrock",@"psychedelictrance",@"psychobilly",@"punk",@"punkblues",@"quietstorm",@"r&b",@"ragtime",@"rai",@"ranchera",@"rap",@"rapmetal",@"raprock",@"reggae",@"reggaeton",@"renaissance",@"rock",@"rock'nroll",@"rockenespanol",@"rocksteady",@"rockabilly",@"rootsreggae",@"rootsrock",@"rumba",@"salsa",@"samba",@"screamo",@"sexy",@"shibuya-kei",@"shoegaze",@"showtunes",@"singer-songwriter",@"ska",@"skapunk",@"skatepunk",@"skiffle",@"slovenianrock",@"slowcore",@"sludgemetal",@"smoothjazz",@"soca",@"softrock",@"soukous",@"soul",@"soulblues",@"souljazz",@"soundtrack",@"southerngospel",@"southernhiphop",@"southernrock",@"southernsoul",@"spacerock",@"speedgarage",@"speedmetal",@"speedcore",@"stonermetal",@"stonerrock",@"straightedge",@"stride",@"suomirock",@"surfmusic",@"swampblues",@"swing",@"symphonicblackmetal",@"symphonicmetal",@"symphonicrock",@"synthpop",@"tango",@"techhouse",@"technicaldeathmetal",@"techno",@"teenpop",@"tejano",@"texasblues",@"texascountry",@"thaipop",@"thrashcore",@"thrashmetal",@"traditionalblues",@"traditionalcountry",@"traditionalfolk",@"trance",@"tribalhouse",@"triphop",@"turbofolk",@"turntablism",@"tweepop",@"ukgarage",@"undergroundhiphop",@"upliftingtrance",@"urbancontemporary",@"vallenato",@"videogamemusic",@"vikingmetal",@"visualkei",@"vocalhouse",@"vocaljazz",@"westcoastrap",@"westernswing",@"world",@"worship",@"zouk",@"zydeco"];
    }
    return arrayOfGenres;
}

- (void)justSearchWithString:(NSString *)string
{
    if([self genreCheckWithString:&string])
    {
        [self genreSearchWithString:string];
    }
    
    else if([self subredditCheckWithString:string])
    {
        [self subredditSearchWithString:string];
    }
    
    else
    {
        self.timeoutInterval = ECHONEST_YOUTUBE_TIMEOUT;
        NSString *afterCallback = [NSString stringWithFormat:@"&start=%@&results=%@", kEchonestStart, kEchonestNumberOfSongs];
        NSString *queryUrl = [NSString stringWithFormat: kEchonestQueryURL, kEchonestVersionKey, @"artist", @"songs", kEchonestApiKey, @"name", [string stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding], afterCallback];
        
        [self searchWithURLString:queryUrl];
    }
}

- (void)similarSearchWithString:(NSString *)string
{
    if([self genreCheckWithString:&string])
    {
        [self genreSearchWithString:string];
    }
    
    else if([self subredditCheckWithString:string])
    {
        [self subredditSearchWithString:string];
    }
    
    else
    {
        self.timeoutInterval = ECHONEST_YOUTUBE_TIMEOUT;
        NSString *afterCallback = [NSString stringWithFormat:@"&start=%@&results=%@", kEchonestStart, kEchonestNumberOfSongs];
        NSString *queryUrl = [NSString stringWithFormat: kEchonestQueryURL, kEchonestVersionKey, @"artist", @"similar", kEchonestApiKey, @"name", [string stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding], afterCallback];
        
        [self searchWithURLString:queryUrl];

    }
}

- (BOOL)genreCheckWithString:(NSString **)string
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ +]" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:*string options:0 range:NSMakeRange(0, [*string length]) withTemplate:@""];
    if([[self.class genres] indexOfObject:modifiedString] == NSNotFound)
        return NO;
    
    *string = [*string stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    return YES;
}

- (void)genreSearchWithString:(NSString *)string
{
    self.timeoutInterval = ECHONEST_YOUTUBE_TIMEOUT;
    NSString *afterCallback = [NSString stringWithFormat:@"&type=genre-radio&results=%@", kEchonestNumberOfSongs];
    NSString *queryUrl = [NSString stringWithFormat: kEchonestQueryURL, kEchonestVersionKey, @"playlist", @"basic", kEchonestApiKey, @"genre", string, afterCallback];
    
    [self searchWithURLString:queryUrl];

}

- (BOOL)subredditCheckWithString:(NSString *)string
{
    NSRange redditSchemeRange = [string rangeOfString:@"/r/"];
    if(redditSchemeRange.location == NSNotFound)
        return NO;
    
    return YES;
}

- (void)subredditSearchWithString:(NSString *)string
{
    self.timeoutInterval = REDDIT_TIMEOUT;
    NSString *redditString = [string stringByReplacingOccurrencesOfString:@"/r/"
                                                               withString:@""];
    NSString *queryUrl = [NSString stringWithFormat: kRedditQueryUrl, redditString];
    
    [self searchWithURLString:queryUrl];
}

-(void)searchWithURLString:(NSString *)urlString;
{
    NSLog(@"%@", urlString);
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError *error;
        NSArray *beats;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *response = [json objectForKey:@"response"];
        if(![[[response objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"Success"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            return;
        }
        
        NSDictionary *song = [[response objectForKey:@"songs"] objectAtIndex:0];
        if(song == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
        
        NSDictionary *audioSummary = [song objectForKey:@"audio_summary"];
        if(audioSummary == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            return;
        }
        
        // finally get the audio summary data
        NSData *audioSummaryData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[audioSummary objectForKey:@"analysis_url"]]];
        // extract the beats array
        json = [NSJSONSerialization JSONObjectWithData:audioSummaryData options:0 error:&error];
        if(error != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            return;
        }
        
        beats = [json objectForKey:@"segments"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
//    if (!_loading)
//	{
//        NSURL *url = [NSURL URLWithString:urlString];
//		self.requestUrl = url;
//		NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:self.timeoutInterval];
//		_loading = YES;
//		_connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//		if (_connection)
//			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//	}
}

//-(NSURL *)trackUrl
//{
//    return [NSURL URLWithString:[NSString stringWithFormat:kAPITrackURL, kAPIQueryVersionKey]];
//}
//
//-(void)specialistSearch
//{
//    self.timeoutInterval = DEFAULT_TIMEOUT;
//	NSString *urlString = [NSString stringWithFormat:kAPIQueryURL, kAPIQueryVersionKey, @""];
//    [self searchWithURL:[NSURL URLWithString:urlString]];
//}
//
//-(void)searchWithDictionary:(NSDictionary *)dictionary
//{
//    self.timeoutInterval = DEFAULT_TIMEOUT;
//	NSString *urlString = [NSString stringWithFormat:kAPIQueryURL, kAPIQueryVersionKey, kAPIQuerySearchActionName];
//    [self createConnectionWithUrlString:urlString dictionary:dictionary];
//}
//
//-(void)retryWithAdditionalTimeoutInterval:(NSTimeInterval)additionalTimeoutInterval
//{
//	self.timeoutInterval += additionalTimeoutInterval;
//	[self searchWithURL:self.requestUrl];
//}
//
//-(void)loadUrl:(NSURL *)url timeoutInterval:(NSTimeInterval)timeout
//{
//    NSLog(@"loadURL: %@, timeout=%f\n", [url absoluteString], timeout);
//	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:timeout];
//
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//}
//
//-(void)loadUrl:(NSURL *)url postData:(NSData *)postData timeoutInterval:(NSTimeInterval)timeout
//{
//    NSLog(@"loadURL: %@, timeout=%f\n", [url absoluteString], timeout);
//	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:timeout];
//	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
//	[postRequest setHTTPMethod:@"POST"];
//	[postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
//	[postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
//	[postRequest setHTTPBody:postData];
//
//	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    _connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
//}

//- (void)createConnectionWithUrlString:(NSString *)string dictionary:(NSDictionary *)dictionary
//{
//    NSString *urlString = string;
//    for(NSString *key in dictionary)
//    {
//        NSString *action = [NSString stringWithString:key];
//        NSString *value = [dictionary objectForKey:action];
//        NSString *apiName = [actionDictionary objectForKey:action];
//		action = (apiName) ? apiName : action;
//        urlString = [NSString stringWithFormat:@"%@%@=%@&", urlString, action, value];
//    }
//    [self searchWithURL:[NSURL URLWithString:urlString]];
//}
//
//
//-(NSString *)apiVersion
//{
//    return kAPIQueryVersionKey;
//}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	int statusCode;
    if ([response isKindOfClass: [NSHTTPURLResponse class]])
        statusCode = [(NSHTTPURLResponse*) response statusCode];
    
    if(statusCode != 200 && statusCode != 304)
    {
		_loading = FALSE;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:NSURLErrorResourceUnavailable userInfo:nil];
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailWithError:)])
			[self.delegate didFailWithError:error];
    }
    
	_responseData = [NSMutableData data];
    [_responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _loading = FALSE;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didFailWithError:)])
		[self.delegate didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    _loading = FALSE;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSError *error;
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:_responseData
                                             options:NSJSONReadingAllowFragments
                                               error:&error];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didReceiveDataDictionary:)])
        [self.delegate didReceiveDataDictionary:jsonDictionary];
}

//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//    return YES;
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    NSString *userName = self.baseRoRApiToken;
//    NSString *userPassword = @"";
//    NSURLCredential *credential = [NSURLCredential credentialWithUser:userName password:userPassword persistence:NSURLCredentialPersistenceNone];
//
//	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//}
//
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    NSString *userName = self.baseRoRApiToken;
//    NSString *userPassword = @"";
//    NSURLCredential *credential = [NSURLCredential credentialWithUser:userName password:userPassword persistence:NSURLCredentialPersistenceNone];
//
//	[[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//}

@end
