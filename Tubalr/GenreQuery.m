//
//  GenreQuery.m
//  Tubalr
//
//  Created by Chad Zeluff on 1/9/13.
//  Copyright (c) 2013 Chad Zeluff. All rights reserved.
//

#import "GenreQuery.h"

@implementation GenreQuery

#pragma mark Public

+ (NSArray *)genres
{
    static NSArray *arrayOfGenres;
    if (nil == arrayOfGenres)
    {
        arrayOfGenres = @[@"acappella",@"acidhouse",@"acidjazz",@"acousticblues",@"afrobeat",@"albumrock",@"alternativecountry",@"alternativedance",@"alternativehiphop",@"alternativemetal",@"alternativerock",@"ambient",@"anti-folk",@"artrock",@"atmosphericblackmetal",@"australianhiphop",@"avant-garde",@"avant-gardejazz",@"avantgardemetal",@"bachata",@"bailefunk",@"banda",@"bassmusic",@"bebop",@"bhangra",@"bigband",@"bigbeat",@"blackmetal",@"blue-eyedsoul",@"bluegrass",@"blues",@"blues-rock",@"bolero",@"boogaloo",@"boogie-woogie",@"bossanova",@"brassband",@"brazilianpopmusic",@"breakbeat",@"breakcore",@"brillbuildingpop",@"britishblues",@"britishfolk",@"britishinvasion",@"britishpop",@"brokenbeat",@"brutaldeathmetal",@"bubblegumdance",@"bubblegumpop",@"cabaret",@"calypso",@"canterburyscene",@"ccm",@"celtic",@"celticrock",@"chamberpop",@"chanson",@"chicagoblues",@"chicagohouse",@"chicagosoul",@"children'smusic",@"chill-out",@"chillwave",@"chiptune",@"choro",@"chorus",@"christianalternativerock",@"christianhardcore",@"christianhiphop",@"christianmetal",@"christianmusic",@"christianpunk",@"christianrock",@"classicrock",@"classical",@"comedy",@"contemporarycountry",@"cooljazz",@"country",@"countryblues",@"countrygospel",@"countryrock",@"cowpunk",@"crossoverthrash",@"crunk",@"crustpunk",@"cumbia",@"dancepop",@"dancerock",@"dance-punk",@"dancehall",@"darkambient",@"darkwave",@"deathcore",@"deathmetal",@"deathgrind",@"deephouse",@"deltablues",@"desi",@"detroittechno",@"digitalhardcore",@"dirtysouthrap",@"disco",@"discohouse",@"djent",@"doo-wop",@"doommetal",@"downtempo",@"dreampop",@"drone",@"drumandbass",@"dub",@"dubstep",@"earlymusic",@"eastcoasthiphop",@"easylistening",@"ebm",@"electricblues",@"electro",@"electro-industrial",@"electroclash",@"electronic",@"emo",@"eurobeat",@"eurodance",@"europop",@"exotica",@"experimental",@"experimentalrock",@"fado",@"filmi",@"flamenco",@"folk",@"folkmetal",@"folkpunk",@"folkrock",@"folk-pop",@"freakfolk",@"freakbeat",@"freeimprovisation",@"freejazz",@"freestyle",@"funeraldoom",@"funk",@"funkmetal",@"funkrock",@"futurepop",@"gfunk",@"gabba",@"game",@"gangsterrap",@"garagerock",@"germanpop",@"glammetal",@"glamrock",@"glitch",@"goregrind",@"gospel",@"gothicmetal",@"gothicrock",@"gothicsymphonicmetal",@"grime",@"grindcore",@"groovemetal",@"grunge",@"gypsyjazz",@"happyhardcore",@"hardbop",@"hardhouse",@"hardrock",@"hardtrance",@"hardcore",@"hardcorehiphop",@"hardcoretechno",@"hardstyle",@"harmonicablues",@"hinrg",@"highlife",@"hiphop",@"hiphouse",@"horrorpunk",@"house",@"hyphy",@"icelandicpop",@"illbient",@"indianclassical",@"indiefolk",@"indiepop",@"indierock",@"indietronica",@"industrial",@"industrialmetal",@"industrialrock",@"intelligentdancemusic",@"irishfolk",@"italiandisco",@"jpop",@"jrock",@"jamband",@"janglepop",@"japanoise",@"jazz",@"jazzblues",@"jazzfunk",@"jazzfusion",@"judaica",@"jugband",@"juggalo",@"jumpblues",@"junglemusic",@"kpop",@"kiwirock",@"klezmer",@"kompa",@"krautrock",@"kwaito",@"laiko",@"latin",@"latinalternative",@"latinjazz",@"latinpop",@"lo-fi",@"louisianablues",@"lounge",@"loversrock",@"madchester",@"mambo",@"mariachi",@"martialindustrial",@"mathrock",@"mathcore",@"medieval",@"mellowgold",@"melodicdeathmetal",@"melodichardcore",@"melodicmetalcore",@"memphisblues",@"memphissoul",@"merengue",@"merseybeat",@"metal",@"metalcore",@"minimal",@"modernblues",@"modernclassical",@"motown",@"mpb",@"musiqueconcrete",@"nashvillesound",@"nativeamerican",@"neoclassicalmetal",@"neosoul",@"neo-progressive",@"neoclassical",@"neofolk",@"neuedeutscheharte",@"newage",@"newbeat",@"newjackswing",@"neworleansblues",@"neworleansjazz",@"newrave",@"newromantic",@"newwave",@"newweirdamerica",@"ninja",@"nowave",@"noisepop",@"noiserock",@"northernsoul",@"nujazz",@"numetal",@"nuskoolbreaks",@"nwobhm",@"oi",@"oldschoolhiphop",@"opera",@"oratory",@"outlawcountry",@"paganblackmetal",@"pianoblues",@"pianorock",@"piedmontblues",@"polka",@"pop",@"poppunk",@"poprap",@"poprock",@"portugueserock",@"postrock",@"post-grunge",@"post-hardcore",@"post-metal",@"post-punk",@"powerelectronics",@"powermetal",@"powernoise",@"powerpop",@"powerviolence",@"progressivebluegrass",@"progressivehouse",@"progressivemetal",@"progressiverock",@"progressivetrance",@"protopunk",@"psychedelicrock",@"psychedelictrance",@"psychobilly",@"punk",@"punkblues",@"quietstorm",@"r&b",@"ragtime",@"rai",@"ranchera",@"rap",@"rapmetal",@"raprock",@"reggae",@"reggaeton",@"renaissance",@"rock",@"rock'nroll",@"rockenespanol",@"rocksteady",@"rockabilly",@"rootsreggae",@"rootsrock",@"rumba",@"salsa",@"samba",@"screamo",@"sexy",@"shibuya-kei",@"shoegaze",@"showtunes",@"singer-songwriter",@"ska",@"skapunk",@"skatepunk",@"skiffle",@"slovenianrock",@"slowcore",@"sludgemetal",@"smoothjazz",@"soca",@"softrock",@"soukous",@"soul",@"soulblues",@"souljazz",@"soundtrack",@"southerngospel",@"southernhiphop",@"southernrock",@"southernsoul",@"spacerock",@"speedgarage",@"speedmetal",@"speedcore",@"stonermetal",@"stonerrock",@"straightedge",@"stride",@"suomirock",@"surfmusic",@"swampblues",@"swing",@"symphonicblackmetal",@"symphonicmetal",@"symphonicrock",@"synthpop",@"tango",@"techhouse",@"technicaldeathmetal",@"techno",@"teenpop",@"tejano",@"texasblues",@"texascountry",@"thaipop",@"thrashcore",@"thrashmetal",@"traditionalblues",@"traditionalcountry",@"traditionalfolk",@"trance",@"tribalhouse",@"triphop",@"turbofolk",@"turntablism",@"tweepop",@"ukgarage",@"undergroundhiphop",@"upliftingtrance",@"urbancontemporary",@"vallenato",@"videogamemusic",@"vikingmetal",@"visualkei",@"vocalhouse",@"vocaljazz",@"westcoastrap",@"westernswing",@"world",@"worship",@"zouk",@"zydeco"];
    }
    return arrayOfGenres;
}

+ (BOOL)checkWithString:(NSString **)string
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ +]" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:*string options:0 range:NSMakeRange(0, [*string length]) withTemplate:@""];
    if([[self.class genres] indexOfObject:modifiedString] == NSNotFound)
        return NO;
    
    *string = [*string stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    return YES;
}

+ (void)searchWithString:(NSString *)string
{
//    NSString *afterCallback = [NSString stringWithFormat:@"&type=genre-radio&results=%@", kEchonestNumberOfSongs];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: kEchonestQueryURL, kEchonestVersionKey, @"playlist", @"basic", kEchonestApiKey, @"genre", string, afterCallback]];
}

@end
