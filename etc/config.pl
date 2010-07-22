#!/usr/bin/perl
# -*-perl-*-

# LiveJournal configuration file.

{
    package LJ;

    ###
    ### Site Information
    ###

    $HTDOCS = "$HOME/htdocs";
    $BIN = "$HOME/bin";
    $TEMP = "$HOME/temp";
    $VAR = "$HOME/var";

    $DOMAIN_WEB = "www.$DOMAIN"; # necessary

    # this is what gets prepended to all URLs
    $SITEROOT = "http://$DOMAIN_WEB";

    # prefix for images
    $IMGPREFIX = "$SITEROOT/img";

    # set this if you're running an FTP server that mirrors your htdocs/files
    #$FTPPREFIX = "ftp://ftp.$DOMAIN";

    # where we set the cookies (note the period before the domain)
    # can be one value or an array ref (to accomodate certain old
    # broken browsers)
    $COOKIE_DOMAIN = ".$DOMAIN";

    # email addresses
    $ADMIN_EMAIL = "webmaster\@$DOMAIN";
    $SUPPORT_EMAIL = "support\@$DOMAIN";
    $COMMUNITY_EMAIL = "community_invitation\@$DOMAIN";
    $BOGUS_EMAIL = "dw_null\@$DOMAIN";
    $COPPA_EMAIL = "coppa\@$DOMAIN";
    $PRIVACY_EMAIL = "privacy\@$DOMAIN";
    $ACCOUNTS_EMAIL = "accounts\@$DOMAIN";

    # news site support. if set, that journal loads on the main page.
    #$FRONTPAGE_JOURNAL = "news";

    # css proxy
    $CSSPROXY = "http://cssproxy.$DOMAIN/";

    # setup subdomains that work
    %SUBDOMAIN_FUNCTION = (
            community => 'journal',
            users => 'journal',
            syndicated => 'journal',
            cssproxy => 'cssproxy',
            shop => 'shop',
            mobile => 'mobile', 
        );



    ###
    ### Policy Options
    ###

    # filter comments for spam using this list of regular expressions:
    #@TALKSPAM = (
    #             "morphese",
    #             );

    # require new free acounts to be referred by an existing user?
    $USE_ACCT_CODES = 1;

    #$EVERYONE_VALID = 1; # are all users validated by default?

    ###
    ### System Information
    ###

    # on a larger installation, it's useful to have multiple qbufferd.pl
    # processes, one for each command type.  this is unecessary on a
    # small installation.  you can also specify a delay between runs.
    #@QBUFFERD_ISOLATE = ('ljcom_newpost');
    #$QBUFFERD_DELAY   = 10;

    # path to sendmail and any necessary options
    $SENDMAIL = "/usr/sbin/sendmail -t";

    # command-line to spell checker, or undefined if you don't want spell checking
    #$SPELLER = "/usr/local/bin/ispell -a";
    #$SPELLER = "/usr/bin/aspell pipe --mode=html --sug-mode=fast --ignore-case";

    # to save bandwidth, should we compress pages before they go out?
    # require Compress::Zlib to be installed
    #$DO_GZIP = 1;

    # Support signed PGP email for email posting?
    # Requires GnuPG::Interface and Mail::GnuPG to be installed.
    #$USE_PGP = 1;

    # HINTS:
    #   how far you can scroll back on lastn and friends pages.
    #   big performance implications if you make these too high.
    #   also, once you lower them, increasing them won't change anything
    #   until there are new posts numbering the difference you increased
    #   it by.
    $MAX_HINTS_LASTN = 800;
    $MAX_SCROLLBACK_LASTN = 750;

    # do paid users get email addresses?  username@$USER_DOMAIN ?
    # (requires additional mail system configuration)
    $USER_EMAIL  = 1;

    # Support URLs of the form http://username.yoursite.com/ ?
    # If so, what's the part after "username." ?
    $USER_VHOSTS = 1;
    $USER_DOMAIN = $DOMAIN;

    # If you ONLY want USER_VHOSTS to work and not the typical /users/USER and /community/USER
    # then set this option:
    $ONLY_USER_VHOSTS = 1;

    # Support updating of journals via email?
    # Users can post to user@$EMAIL_POST_DOMAIN.
    $EMAIL_POST_DOMAIN = "post.$DOMAIN";

    # This should be a path to a Maildir, matching the delivery
    # location of your MTA.
    # If you are using sendmail, you should deliver with procmail
    # (versions 3.14 and above) for Maildir support.
    #$MAILSPOOL = '/home/livejournal/mail';

    # Allow users to point their own domains here?
    $OTHER_VHOSTS = 1;

    # turns these from 0 to 1 to disable parts of the site that are
    # CPU & database intensive or that you simply don't want to use
    %DISABLED = (
                 adult_content => 0,
                 blockwatch => 1,
                 'community-logins' => 0,
                 directory => 0,
                 eventlogrecord => 1,
                 feedster_search => 0,
                 free_create => 1,
                 googlecheckout => 1,
                 'interests-findsim' => 0,
                 memories => 0,
                 opt_findbyemail => 1,
                 payments => 0,
                 'show-talkleft' => 0,
                 'stats-recentupdates' => 0,
                 'stats-newjournals' => 0,
                 tellafriend => 0,
                 esn_archive => 1,
                 );

    # turn $SERVER_DOWN on while you do any maintenance
    $SERVER_TOTALLY_DOWN = 0;
    $SERVER_DOWN = 0;
    $SERVER_DOWN_SUBJECT = "Maintenance";
    $SERVER_DOWN_MESSAGE = "$SITENAME is down right now while we upgrade.  It should be up in a few minutes.";
    $MSG_READONLY_USER   = "This journal is in read-only mode right now while database maintenance is performed " .
                           "on the server where the journal is located.  Try again in several minutes.";
    $MSG_NO_POST    = "Due to hardware maintenance, you cannot post at this time.  Watch the news page for updates.";
    $MSG_NO_COMMENT = "Due to hardware maintenance, you cannot leave comments at this time.  Watch the news " .
                      "page for updates.";
    #$MSG_DB_UNAVAILABLE = "Sorry, database temporarily unavailable.  Please see <a href='...'>...</a> for status updates.";

    # can also disable media uploads/modifications, if for some reason you need to
    # turn off your MogileFS install, for example.
    $DISABLE_MEDIA_UPLOADS = 0;

    ###
    ### Language / Scheme support
    ###

    # schemes available to users.
    # schemes will be displayed according to their order in the array,
    # but the first item in the array is the default scheme
    # 'title' is the printed name, while 'scheme' is the scheme name.
    @SCHEMES = (
                { scheme => 'blueshift', title => 'Blueshift' },
               );

    # supported languages (defaults to qw(en) if none given)
    # First element is default language for user interface, untranslated text
    @LANGS = qw( en_DW );

    # support unicode (posts in multiple languages)?  leave enabled.
    $UNICODE = 1;


    ###
    ### Database Configuration
    ###

    # if database logging is enabled above, should we log images or just page requests?
    #$DONT_LOG_IMAGES = 1;

    # Turn on memory/cpu usage statistics generation for database logs (requires the
    # GTop module to be installed)
    #$LOG_GTOP = 1;

    # directory optimizations
    $DIR_DB_HOST = "master";  # DB role to use when connecting to directory DB
    $DIR_DB = "";             # by default, hit the main database (bad for big sites!)

    # list of all clusters - each one needs a 'cluster$i' role in %DBINFO
    @CLUSTERS = (1);    # eg: (1, 2, 3) (for scalability)

    # can users choose which cluster they're assigned to?  leave this off.
    $ALLOW_CLUSTER_SELECT = 0;

    # which cluster(s) get new users?
    # if it's an arrayref, choose one of the listed clusters at random.  you can weight
    # new users by repeating cluster numbers, e.g. [ 1, 1, 1, 2 ] puts 75% of people on
    # cluster 1, 25% of people on cluster 2.  clusters are checked for validity before
    # being used.
    $DEFAULT_CLUSTER = [ 1 ];

    # which cluster should syndication accounts live on?
    $SYND_CLUSTER = 1;

    ###
    ### Account Information
    ###

    # initial friends for new accounts.
    # leave undefined if you don't want to use it.
    @INITIAL_FRIENDS = qw(news);

    # initial optional friends
    #@LJ::INITIAL_OPTIONAL_FRIENDS = qw(news);

    # initial friends checked by default on create.bml
    #@LJ::INITIAL_OPTOUT_FRIENDS = qw(news);

    # some system accounts have so many friends it is harmful to display
    # them.  list these accounts here.
    #%FORCE_EMPTY_FRIENDS = (
    #                        '81752' => 'paidmembers'
    #                        );


    # test accounts are special
    @TESTACCTS = qw(test);

    # props users should have by default
    %USERPROP_DEF = ();

    ### User Capabilities Classes:

    # default capability limits, used only when no other
    # class-specific limit below matches.
    %CAP_DEF = (
            activeentries => 0,
            'getselfemail' => 0,
            'checkfriends' => 0,
            'checkfriends_interval' => 300,
            'friendsviewupdate' => 30,
            'interests' => 150,
            'makepoll' => 0,
            'maxfriends' => 500,
            'moodthemecreate' => 0,
            'directorysearch' => 0,
            'styles' => 0,
            's2styles' => 0,
            's2viewentry' => 1,
            's2viewreply' => 1,
            's2stylesmax' => 0,
            's2layersmax' => 0,
            'textmessage' => 0,
            'userdomain' => 1,
            'useremail' => 1,
            'userpics' => 5,
            'findsim' => 0,
            'friendspage_per_day' => 0,
            'full_rss' => 1,
            'can_post' => 1,
            'get_comments' => 1,
            'leave_comments' => 1,
            'mod_queue' => 50,
            'mod_queue_per_poster' => 5,
            'hide_email_after' => 60,
            'userlinks' => 10,
            'maxcomments' => 5000,
            'rateperiod-lostinfo' => 60*60*24, # 24 hours
            'rateallowed-lostinfo' => 3,
            'rateperiod-failed_login' => 60*5, # 5 minutes
            'rateallowed-failed_login' => 3,
            'rateperiod-commcreate' => 86400*7, # 7 days / 1 week
            'rateallowed-commcreate' => 3,
            'staff_headicon' => 0,
            thread_expander => 0,
            'xpost_accounts' => 0,
            );

    # capability class limits.
    # keys are bit numbers, from 0 .. 15.  values are hashrefs
    # with limit names and values (see doc/capabilities.txt)
    # NOTE: you don't even need to have different capability classes!
    #       all users can be the same if you want, just delete all
    #       this.  the important part then is %CAP_DEF, above.
    %CAP = (
        '0' => {  # 0x01
            '_name' => 'UNUSED',
            '_key' => 'UNUSED',
        },
        '1' => {  # 0x02
            '_name' => 'Free',
            '_visible_name' => 'Free Account',
            '_key' => 'free_user',
            '_account_type' => 'free',
            '_account_default' => 1,    # default account for payment system
            'activeentries' => 0,
            'bookmark_max' => 25,
            'checkfriends' => 0,
            'checkfriends_interval' => 0,
            'directory' => 1,
            'domainmap' => 0,
            'edit_comments' => 0,
            'emailpost' => 0,
            'findsim' => 0,
            'friendsfriendsview' => 0,
            'friendspage_per_day' => 0,
            'friendsviewupdate' => 0,
            'full_rss' => 1,
            'getselfemail' => 0,
            google_analytics => 0,
            'inbox_max' => 2000,
            'interests' => 150,
            'makepoll' => 0,
            'mass_privacy' => 0,
            'maxfriends' => 1000,
            'mod_queue' => 50,
            'mod_queue_per_poster' => 3,
            'moodthemecreate' => 0,
            popsubscriptions => 0,
            's2layersmax' => 0,
            's2props' => 0,
            's2styles' => 0,
            's2stylesmax' => 0,
            'security_filter' => 0,
            'subscriptions' => 25,
            'synd_create' => 1,
            'tags_max' => 1000,
            'textmessaging' => 0,
            thread_expander => 0,            
            'tools_recent_comments_display' => 10,            
            'track_defriended' => 0,
            'track_pollvotes' => 0,
            'track_thread' => 0,
            'track_user_newuserpic' => 0,
            'useremail' => 0,
            'userlinks' => 10,
            'usermessage_length' => 5000,
            'userpics' => 6,
            'userpicselect' => 0,
            'viewmailqueue' => 0,
            'xpost_accounts' => 1,
        },
        '2' => {  # 0x04
            '_name' => 'UNUSED2',
            '_key' => 'UNUSED2',
        },
        '3' => {  # 0x08
            '_name' => 'Paid',
            '_key' => 'paid_user', # Some things expect that key name
            '_visible_name' => 'Paid Account',
            '_account_type' => 'paid',
            'activeentries' => 1,
            'bookmark_max' => 500,
            'checkfriends' => 1,
            'checkfriends_interval' => 600,
            'directory' => 1,
            'domainmap' => 1,
            'edit_comments' => 1,
            'emailpost' => 1,
            'findsim' => 1,
            'friendsfriendsview' => 1,
            'friendspage_per_day' => 1,
            'friendsviewupdate' => 1,
            'full_rss' => 1,
            'getselfemail' => 1,
            google_analytics => 1,
            'inbox_max' => 4000,
            'interests' => 200,
            'makepoll' => 1,
            'mass_privacy' => 1,
            'maxfriends' => 1500,
            'mod_queue' => 100,
            'mod_queue_per_poster' => 5,
            'moodthemecreate' => 1,
            popsubscriptions => 1,
            's2layersmax' => 150,
            's2props' => 1,
            's2styles' => 1,
            's2stylesmax' => 50,
            'security_filter' => 1,
            'subscriptions' => 500,
            'synd_create' => 1,
            'tags_max' => 1500,
            'textmessaging' => 1,
            thread_expander => 1,            
            'tools_recent_comments_display' => 100,
            'track_defriended' => 1,
            'track_pollvotes' => 1,
            'track_thread' => 1,
            'track_user_newuserpic' => 1,
            'useremail' => 1,
            'userlinks' => 50,
            'usermessage_length' => 10000,
            'userpics' => 75,
            'userpicselect' => 1,
            'viewmailqueue' => 1,
            'xpost_accounts' => 3,
            'paid' => 1,
            'fastserver' => 1,
        },
        '4' => {  # 0x10
            '_name' => 'Premium Paid',
            '_key' => 'premium_user',
            '_visible_name' => 'Premium Paid Account',
            '_account_type' => 'premium',
            'activeentries' => 1,
            'bookmark_max' => 1000,
            'checkfriends' => 1,
            'checkfriends_interval' => 600,
            'directory' => 1,
            'domainmap' => 1,
            'edit_comments' => 1,
            'emailpost' => 1,
            'findsim' => 1,
            'friendsfriendsview' => 1,
            'friendspage_per_day' => 1,
            'friendsviewupdate' => 1,
            'full_rss' => 1,
            'getselfemail' => 1,
            google_analytics => 1,
            'inbox_max' => 6000,
            'interests' => 250,
            'makepoll' => 1,
            'mass_privacy' => 1,
            'maxfriends' => 2000,
            'mod_queue' => 100,
            'mod_queue_per_poster' => 5,
            'moodthemecreate' => 1,
            popsubscriptions => 1,
            's2layersmax' => 300,
            's2props' => 1,
            's2styles' => 1,
            's2stylesmax' => 100,
            'security_filter' => 1,
            'subscriptions' => 1000,
            'synd_create' => 1,
            'tags_max' => 2000,
            'textmessaging' => 1,
            thread_expander => 1,            
            'tools_recent_comments_display' => 150,
            'track_defriended' => 1,
            'track_pollvotes' => 1,
            'track_thread' => 1,
            'track_user_newuserpic' => 1,
            'useremail' => 1,
            'userlinks' => 50,
            'usermessage_length' => 10000,
            'userpics' => 150,
            'userpicselect' => 1,
            'viewmailqueue' => 1,
            'xpost_accounts' => 5,
            'paid' => 1,
            'fastserver' => 1,
        },
        # a capability class with a name of "_moveinprogress" is required
        # if you want to be able to move users between clusters with the
        # provided tool.  further, this class must define 'readonly' => 1
        '5' => {  # 0x20
            '_name' => '_moveinprogress',
            'readonly' => 1,
        },
        '6' => {  # 0x40
            '_name' => 'Permanent',
            '_key' => 'permanent_user',
            '_visible_name' => 'Seed Account',
            '_account_type' => 'seed',
            'activeentries' => 1,
            'bookmark_max' => 1000,
            'checkfriends' => 1,
            'checkfriends_interval' => 600,
            'directory' => 1,
            'domainmap' => 1,
            'edit_comments' => 1,
            'emailpost' => 1,
            'findsim' => 1,
            'friendsfriendsview' => 1,
            'friendspage_per_day' => 1,
            'friendsviewupdate' => 1,
            'full_rss' => 1,
            'getselfemail' => 1,
            google_analytics => 1,
            'inbox_max' => 6000,
            'interests' => 250,
            'makepoll' => 1,
            'mass_privacy' => 1,
            'maxfriends' => 2000,
            'mod_queue' => 100,
            'mod_queue_per_poster' => 5,
            'moodthemecreate' => 1,
            popsubscriptions => 1,
            's2layersmax' => 300,
            's2props' => 1,
            's2styles' => 1,
            's2stylesmax' => 100,
            'security_filter' => 1,
            'subscriptions' => 1000,
            'synd_create' => 1,
            'tags_max' => 2000,
            'textmessaging' => 1,
            thread_expander => 1,            
            'tools_recent_comments_display' => 150,
            'track_defriended' => 1,
            'track_pollvotes' => 1,
            'track_thread' => 1,
            'track_user_newuserpic' => 1,
            'useremail' => 1,
            'userlinks' => 50,
            'usermessage_length' => 10000,
            'userpics' => 150,
            'userpicselect' => 1,
            'viewmailqueue' => 1,
            'paid' => 1,
            'fastserver' => 1,
        },
        '7' => {  # 0x80
            '_name' => 'Staff',
            '_key' => 'staff',
            '_visible_name' => 'Staff Account',
            'activeentries' => 1,
            'bookmark_max' => 1000,
            'checkfriends' => 1,
            'checkfriends_interval' => 600,
            'directory' => 1,
            'domainmap' => 1,
            'edit_comments' => 1,
            'emailpost' => 1,
            'findsim' => 1,
            'friendsfriendsview' => 1,
            'friendspage_per_day' => 1,
            'friendsviewupdate' => 1,
            'full_rss' => 1,
            'getselfemail' => 1,
            google_analytics => 1,
            'inbox_max' => 6000,
            'interests' => 250,
            'makepoll' => 1,
            'mass_privacy' => 1,
            'maxfriends' => 2000,
            'mod_queue' => 100,
            'mod_queue_per_poster' => 5,
            'moodthemecreate' => 1,
            popsubscriptions => 1,
            's2layersmax' => 300,
            's2props' => 1,
            's2styles' => 1,
            's2stylesmax' => 100,
            'security_filter' => 1,
            'subscriptions' => 1000,
            'synd_create' => 1,
            'tags_max' => 2000,
            'textmessaging' => 1,
            thread_expander => 1,            
            'tools_recent_comments_display' => 150,
            'track_defriended' => 1,
            'track_pollvotes' => 1,
            'track_thread' => 1,
            'track_user_newuserpic' => 1,
            'useremail' => 1,
            'userlinks' => 50,
            'usermessage_length' => 10000,
            'userpics' => 150,
            'userpicselect' => 1,
            'viewmailqueue' => 1,
            'xpost_accounts' => 9,
            'paid' => 1,
            'fastserver' => 1,
            'staff_headicon' => 1,
        },
        8 => { _name => 'beta', _key => 'betafeatures' }, # 0x100
    );

    # default capability class mask for new users:
    # (16 bit unsigned int ... each bit is capability class flag)
    $NEWUSER_CAPS = 2;

    # by default, give users a style
    $DEFAULT_STYLE = {
        'core' => 'core2',
        'layout' => 'negatives/layout',
        'theme' => 'negatives/black',
    };

    ### /admin/fileedit setup
    # If you are using the files in htdocs/inc and are frequently editing
    # those, you may wish to put all of these files into the database.
    # You can instruct BML to treat all <?_include?> statements as being
    # pulled from memcached (failover to the database) by uncommenting:
    # $FILEEDIT_VIA_DB = 1;
    # Alternately, you can specify that only particular files should be
    # kept in memcache and the database by doing:
    # %FILEEDIT_VIA_DB = ( 'support_links' => 1, );

    ### S2 Style Options

    # which users' s2 layers should always run trusted un-cleaned?
    #%S2_TRUSTED = ( '2' => 'whitaker' ); # userid => username


    ###
    ### Portal Options
    ###

    @PORTAL_BOXES = (
                     'Birthdays',
                     'UpdateJournal',
                     'TextMessage',
                     'PopWithFriends',
                     'Friends',
                     'Manage',
                     'RecentComments',
                     'NewUser',
                     'FriendsPage',
                     'FAQ',
                     'Debug',
                     'Note',
                     'RandomUser',
                     );

    @PORTAL_BOXES_HIDDEN = (
                            'Debug',
                            );

    %PORTAL_DEFAULTBOXSTATES = (
                         'Birthdays' => {
                             'added' => 1,
                             'sort'  => 4,
                             'col'   => 'R',
                         },
                         'FriendsPage' => {
                             'added' => 1,
                             'sort'  => 6,
                             'col'   => 'L',
                         },
                         'FAQ' => {
                             'added' => 1,
                             'sort'  => 8,
                             'col'   => 'R',
                         },
                         'Friends' => {
                             'added' => 1,
                             'sort'  => 10,
                             'col'   => 'R',
                         },
                         'Manage' => {
                             'added' => 1,
                             'sort'  => 12,
                             'col'   => 'L',
                         },
                         'PopWithFriends' => {
                             'added' => 0,
                             'col'   => 'R',
                         },
                         'RecentComments' => {
                             'added' => 1,
                             'sort'  => 10,
                             'col'   => 'L',
                         },
                         'UpdateJournal' => {
                             'added' => 1,
                             'sort'  => 4,
                             'col'   => 'L',
                         },
                         'NewUser' => {
                             'added' => 1,
                             'sort'  => 2,
                             'col'   => 'L',
                         },
                         'TextMessage' => {
                             'added'  => 1,
                             'sort'   => 12,
                             'col'    => 'R',
                         },
                         );

    # Setup support email address to not accept new emails.  Basically if an
    # address is specified below, any user who emails it out of the blue will
    # be sent back a copy of the specified file along with their email.  Users
    # will still be allowed to respond to emails from the support system, but
    # they can't open a request by emailing the address.  The value part of
    # the hash is the name of an include file.  It will be loaded out of
    # LJHOME/htdocs/inc.  See %FILEEDIT_VIA_DB for how to make it read
    # from memcache/DB.
    #%DENY_REQUEST_FROM_EMAIL = (
    #    "abuse\@$DOMAIN" => "bounce-abuse",
    #);

    # Support diagnostics can be helpful if you are trying to track down a
    # bug that has been occurring.  You can turn on and off various tracking
    # features here.  Just uncomment any/all of the following lines.  The
    # gathered information will be appended to requests that the user opens
    # through the web interface.
    %SUPPORT_DIAGNOSTICS = (
    #    'track_useragent' => 1,
    );

    # If you want to change the limit on how many bans a user can make, uncomment
    # the following line.  Default is 5000.
    #$MAX_BANS = 5000;

    # If you are using MogileFS on your site for userpics or other purposes, you
    # will need to define the following hash and complete the information in it.
    #%MOGILEFS_CONFIG = (
    #    hosts => [ '10.0.0.1:6001' ],
    #    root => '/mnt/mogdata',
    #    classes => {
    #        'your_class' => 3,  # define any special MogileFS classes you need
    #    },
    #);

    # If you have multiple internal networks and would like the MogileFS libraries
    # to pick one network over the other, you can set the preferred IP list...
    #%MOGILEFS_PREF_IP = (
    #    10.0.0.1 => 10.10.0.1,
    #);
    #That says "if we try to connect to 10.0.0.1, instead try 10.10.0.1 first and
    #then fall back to 10.0.0.1".

    # In addition to setting up MogileFS above, you need to enable some options
    # if you want to use MogileFS.
    #$USERPIC_MOGILEFS = 1; # uncomment to put new userpics in MogileFS

    # if you are using Perlbal to balance your web site, by default it uses
    # reproxying to distribute the files itself.  however, in some situations
    # you may not want to do that.  use this option to disable that on an
    # item by item basis.
    #%REPROXY_DISABLE = (
    #    userpics => 1,
    #);

    # Some people on portable devices may have troubles viewing the nice site
    # scheme you've setup, so you can specify that some user-agent prefixes
    # should instead use fallback presentation information.
    %MINIMAL_USERAGENT = (
        #'Foo' => 1, # if the user-agent field starts with "Foo" ...
                     # note you can only put text here; no numbers, spaces, or symbols.
    );
    $MINIMAL_BML_SCHEME = 'lynx';
    %MINIMAL_STYLE = (
        'core' => 'core1', # default, but you can add more layers and styles... note
                           # that they must be public styles
    );

    # if you know that your installation is behind a proxy or other fence that inserts
    # X-Forwarded-For headers that you can trust (eg Perlbal), enable this.  otherwise, don't!
    # $TRUST_X_HEADERS = 1;

    # the following values allow you to control enabling your OpenID server and consumer
    # support.
    $OPENID_SERVER = 1;
    $OPENID_CONSUMER = 1;

    # how many days to store random users for; after this many days they fall out of the table.
    # high traffic sites probably want a reasonably low number, whereas lower traffic sites might
    # want to set this higher to give a larger sample of users to select from.
    $RANDOM_USER_PERIOD = 7;

    # turn on control/nav strip
    $USE_CONTROL_STRIP = 1;

    # Pagination for allpics.bml page.  -1 means unlimited.
    # $ALLPICS_PAGESIZE = 20;

    # initial settings for new users
    %USER_INIT = (
        opt_whocanreply => 'reg',
        opt_mangleemail => 'Y',
        moodthemeid => 7,
    );

    # initial userprop settings for new users
    %USERPROP_INIT = (
        opt_showmutualfriends => 1,
    );

    # remote's safe_search prop value must be greater than or equal to the defined
    # safe_search_level value in order for users with that level's content flag to be
    # filtered out of remote's search results
    #
    # e.g. remote must have a safe_search prop value of 11 or more in order to not
    # see any search results that contain adult concepts
    #
    # a safe_search value of 0 means that it shouldn't ever be filtered
    %CONTENT_FLAGS = (
        explicit => {
            safe_search_level => 1,
        },
        concepts => {
            safe_search_level => 11,
        },
    );

    # enable contextual hover
    $CTX_POPUP = 1;

    # page that 'noanon_ip' sysbanned users can access to get more information
    # on why they're banned
    # $BLOCKED_ANON_URI = '';

    %CAPTCHA_FOR = (
        create   => 0,
        lostinfo => 1,
        validate_openid => 1,
        support_submit_anon => 0,
        anonpost => 1,
        authpost => 0,
        comment_html_anon => 1,
        comment_html_auth => 0,
    );
}

1;
