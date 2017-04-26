From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 07/11] ovl: set the COPYUP type flag for non-dirs
Date: Wed, 26 Apr 2017 21:51:41 +0300
Message-ID: <CAOQ4uxidPfYCgC-nERLFE+Rp83ts9XC06jDJtwqyZiUPHM5hrQ@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-8-git-send-email-amir73il@gmail.com> <CAJfpegt4kwmWmyUhY0RAzvSegbBHdKO6ZWuUXdQWtWdz2eSvOA@mail.gmail.com>
 <CAJfpegsF6W94qrEs_LjuCw+2vJ+Vvyvj2vwXWr5+6GNZGT59kg@mail.gmail.com> <CAOQ4uxiGjBRygytHvG-dozG5OZbQ-YQe=4oSYd4F9oKwtEBbZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxiGjBRygytHvG-dozG5OZbQ-YQe=4oSYd4F9oKwtEBbZQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2017 at 6:02 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Apr 26, 2017 at 5:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Apr 26, 2017 at 4:40 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>>> The reason I think the COPYUP vs. MERGE distinction is needed is the
>>> ovl_check_empty_and_clear() thing.  It starts with a merged directory
>>> with some whiteouts in it and exchanges it with an empty and opaque
>>> directory.   Normally the empty directory will be deleted immediately,
>>> but if something fails during the deletion, then it will remain there.
>>>   The overlay is left in a consistent state, but the association with
>>> the original inode should still remain, so it will have COPYUP but not
>>> MERGE.
>>
>> One more thought: we could introduce a separate "overlay.merge"
>> attribute that is the exact opposite of "overlay.opaque".
>> "overlay.merge" would imply "overlay.fh" but "overlay.fh" would not
>> imply "overlay.merge".
>>
>> It would allow us to optionally get rid of "overlay.opaque" when back
>> compatibility is not needed.
>>
>> It would also allow a new feature: on metadata only updates of regular
>> files we wouldn't need to copy up the data.
>>
>
> So you intend to set overlay.merge for non-dir?
> How is it different from overlay.fh then?
> With it's new name, overlay.origin.fh indicates that there is a copy
> up origin below us. Either directly below us, or at overlay.redirect.
> We can also try to follow to origin by fh, but that is only an optimization -

I miss-spoke - redirect_fh to origin is not only as optimization.
Although renames do not depend on redirect_fh, hardlinks do.

As I learned from improved unionmount-testsuite:

./run --ov=1 hard-link
...
 ./run --link /mnt/a/no_foo110 /mnt/a/foo110
mount -t overlay overlay /mnt
-olowerdir=/upper/0:/lower,upperdir=/upper/1,workdir=/upper/work
sh (8035): drop_caches: 3
/mnt/a/foo110: inode number wrong (got 68908, want 68898)

This error happens in non-samefs case when there is more than 1 lower layer
and redirect_fh is disabled.

It happens after link and mount cycle because the linked upper file, does not
know how to lookup the lower origin.

The error does not happen with samefs and with single lower fs, i.e.:
./run --ov=0 hard-link
./run --ov=1 --samefs hard-link

Because in those cases, all the upper hardlinks follow to origin by fh
and report the same inode number.

I think this calls for setting overlay.redirect also on the target of
ovl_link()??

Amir.
