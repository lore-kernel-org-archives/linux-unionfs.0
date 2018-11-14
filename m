MIME-Version: 1.0
In-Reply-To: <20181114141732.GA29804@redhat.com>
References: <20181114140134.6996-1-amir73il@gmail.com>
	<20181114141732.GA29804@redhat.com>
Date: Wed, 14 Nov 2018 15:48:02 +0100
Message-ID: <CAJfpegt49vvArRcVSCynbRHo3XQygqNhVn5-nWgVwXFVKOSbiw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix missing override creds in link of a metacopy upper
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Theodore Y . Ts'o" <tytso@mit.edu>, =?UTF-8?Q?Maciej_Zi=C4=99ba?= <maciekz82@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Nov 14, 2018 at 3:17 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Nov 14, 2018 at 04:01:34PM +0200, Amir Goldstein wrote:
>> Theodore Ts'o reported a v4.19 regression with docker-dropbox:
>> https://marc.info/?l=linux-fsdevel&m=154070089431116&w=2
>>
>> "I was rebuilding my dropbox Docker container, and it failed in 4.19
>>  with the following error:
>>  ...
>>  dpkg: error: error creating new backup file \
>>               '/var/lib/dpkg/status-old': Invalid cross-device link"
>>
>> The problem did not reproduce with metacopy feature disabled.
>> The error was caused by insufficient credentials to set
>> "trusted.overlay.redirect" xattr on link of a metacopy file.
>>
>
> Thanks Amir for fixiing this. This fix looks good to me.
>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
>
> So this problem happened because looks like kernel enanbled metacopy
> by default (in Kconfig) and thence enabled redirect by default in Kconfig.

OVERLAY_FS_METACOPY is off by default.  So it seems people explicitly
enable it, because it sounds useful :)

Thanks,
Miklos
