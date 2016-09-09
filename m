From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs fix for 4.8-rc5
Date: Fri, 9 Sep 2016 23:18:26 +0200
Message-ID: <CAJfpegurRrrto06uUWt7B197bwuPoB0A8PqSv5YdksGCKkcLZg@mail.gmail.com>
References: <20160909193709.GO25404@veci.piliscsaba.szeredi.hu>
 <CA+55aFxX-UbDjL8R1beqP_ZE6-eXJMgnuvPZmJQxA9n-3srEQQ@mail.gmail.com>
 <CAJfpegvMZrF70LgR4hU84GxvvGQ1JcTFMoG1yH78Rh+v2cFuqw@mail.gmail.com> <CA+55aFzS9y70SEiqFeuuJ=HEbd8SVmbfZnA0kFWFi-N5vaokCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzS9y70SEiqFeuuJ=HEbd8SVmbfZnA0kFWFi-N5vaokCg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 9, 2016 at 10:36 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Sep 9, 2016 at 1:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> That code tries to remove ACL from a directory, and there are several cases:
>>
>> 1) success: that's good obviously
>> 2) error: no ACL was found: that's also good
>> 3) error: ACL's are not supported by the filesystem: this is also good
>> 4) error: ACL was there but we failed to remove it for some other
>> reason: this is not good
>>
>> The patch adds handling of case 3.
>
> I'm not convinced your explanation is correct.
>
> The thing is, you added a test for -EOPNOTSUPP, and that is in fact at
> least partly case (2) (eg xattr_resolve_name())
>
> And EOPNOTSUPP actually seems to be the _clear_ case. The ENODATA case
> is the one that is hard to actually verify. I tried to see that "yes,
> all filesystems return ENODATA", but it wasn't obvious at all (p9fs?)
> If I read the cifs code right, it returns EOPNOTSUPP for the "not
> found" case too.
>
> And ext2/ext4 returns ERANGE for some "we don't support that" cases,
> while gfs2 seems to return EINVAL for those cases. Those are obviously
> also cases of (2), but the fuse code doesn't test for it.
>
> So the error list seems to be rather random, and no, ENODATA and
> EOPNOTSUPP do not seem to be the only errors that would match the
> above at all.
>
> I dunno. I guess this is a corner case that really doesn't matter in
> practice, but the whole "let's test a few special cases" approach
> fails the smell test to me, and doesn't actually seem to match your
> cases above very well.

Okay, so how do we do this correctly?  The desired end result is
clear:  FOOBAR xattr doesn't exist on the directory.  This "doesn't
exist" is a negative result, so the only way to check it is to check
for errors.  Either with removexattr() or getxattr() this will get us
into the same trap: that there are multiple errors that have this
meaning.

Same thing with ENOENT: checking for non-existence can be difficult,
because ENAMETOOLONG is actually a special form of ENOENT.

I just don't see the "right" soltion here, and while I agree that the
current one is ugly, it should actually work. We won't get ERANGE,
because the posix acl xattrs have short names that'll fit in all
filesystems and 9p isn't even a valid fs for the upper layer of an
overlay.

Thanks,
Miklos
