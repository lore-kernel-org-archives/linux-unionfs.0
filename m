From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs fix for 4.8-rc5
Date: Fri, 9 Sep 2016 13:36:16 -0700
Message-ID: <CA+55aFzS9y70SEiqFeuuJ=HEbd8SVmbfZnA0kFWFi-N5vaokCg@mail.gmail.com>
References: <20160909193709.GO25404@veci.piliscsaba.szeredi.hu>
 <CA+55aFxX-UbDjL8R1beqP_ZE6-eXJMgnuvPZmJQxA9n-3srEQQ@mail.gmail.com> <CAJfpegvMZrF70LgR4hU84GxvvGQ1JcTFMoG1yH78Rh+v2cFuqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34758 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754164AbcIIUgX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Sep 2016 16:36:23 -0400
In-Reply-To: <CAJfpegvMZrF70LgR4hU84GxvvGQ1JcTFMoG1yH78Rh+v2cFuqw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Sep 9, 2016 at 1:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> That code tries to remove ACL from a directory, and there are several cases:
>
> 1) success: that's good obviously
> 2) error: no ACL was found: that's also good
> 3) error: ACL's are not supported by the filesystem: this is also good
> 4) error: ACL was there but we failed to remove it for some other
> reason: this is not good
>
> The patch adds handling of case 3.

I'm not convinced your explanation is correct.

The thing is, you added a test for -EOPNOTSUPP, and that is in fact at
least partly case (2) (eg xattr_resolve_name())

And EOPNOTSUPP actually seems to be the _clear_ case. The ENODATA case
is the one that is hard to actually verify. I tried to see that "yes,
all filesystems return ENODATA", but it wasn't obvious at all (p9fs?)
If I read the cifs code right, it returns EOPNOTSUPP for the "not
found" case too.

And ext2/ext4 returns ERANGE for some "we don't support that" cases,
while gfs2 seems to return EINVAL for those cases. Those are obviously
also cases of (2), but the fuse code doesn't test for it.

So the error list seems to be rather random, and no, ENODATA and
EOPNOTSUPP do not seem to be the only errors that would match the
above at all.

I dunno. I guess this is a corner case that really doesn't matter in
practice, but the whole "let's test a few special cases" approach
fails the smell test to me, and doesn't actually seem to match your
cases above very well.

              Linus
