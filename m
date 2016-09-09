From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs fix for 4.8-rc5
Date: Fri, 9 Sep 2016 14:47:26 -0700
Message-ID: <CA+55aFw1UouCB_MbnU4-3cT05B1nB7DVcYZZtuAdSH=3kxxZ2w@mail.gmail.com>
References: <20160909193709.GO25404@veci.piliscsaba.szeredi.hu>
 <CA+55aFxX-UbDjL8R1beqP_ZE6-eXJMgnuvPZmJQxA9n-3srEQQ@mail.gmail.com>
 <CAJfpegvMZrF70LgR4hU84GxvvGQ1JcTFMoG1yH78Rh+v2cFuqw@mail.gmail.com>
 <CA+55aFzS9y70SEiqFeuuJ=HEbd8SVmbfZnA0kFWFi-N5vaokCg@mail.gmail.com> <CAJfpegurRrrto06uUWt7B197bwuPoB0A8PqSv5YdksGCKkcLZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegurRrrto06uUWt7B197bwuPoB0A8PqSv5YdksGCKkcLZg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Sep 9, 2016 at 2:18 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Okay, so how do we do this correctly?  The desired end result is
> clear:  FOOBAR xattr doesn't exist on the directory.  This "doesn't
> exist" is a negative result, so the only way to check it is to check
> for errors.  Either with removexattr() or getxattr() this will get us
> into the same trap: that there are multiple errors that have this
> meaning.
>
> Same thing with ENOENT: checking for non-existence can be difficult,
> because ENAMETOOLONG is actually a special form of ENOENT.

Yeah, ENOENT, ENAMETOOLONG, ERANGE, EINVAL can all be different
versions of "this doesn't exist" - perhaps because such a name
*cannot* exist on the filesystem.

> I just don't see the "right" soltion here, and while I agree that the
> current one is ugly, it should actually work. We won't get ERANGE,
> because the posix acl xattrs have short names that'll fit in all
> filesystems and 9p isn't even a valid fs for the upper layer of an
> overlay.

So maybe the right thing to do is to just document it, and have a
comment that shows that the code at least knows about these things and
that it doesn't matter in practice.

The "just check for two errors without any comments about why those
particular two errors are different from all the *other* errors" is
what I really objected to.

            Linus
