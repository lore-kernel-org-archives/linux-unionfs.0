From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 07/11] ovl: set the COPYUP type flag for non-dirs
Date: Wed, 26 Apr 2017 18:02:18 +0300
Message-ID: <CAOQ4uxiGjBRygytHvG-dozG5OZbQ-YQe=4oSYd4F9oKwtEBbZQ@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-8-git-send-email-amir73il@gmail.com> <CAJfpegt4kwmWmyUhY0RAzvSegbBHdKO6ZWuUXdQWtWdz2eSvOA@mail.gmail.com>
 <CAJfpegsF6W94qrEs_LjuCw+2vJ+Vvyvj2vwXWr5+6GNZGT59kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsF6W94qrEs_LjuCw+2vJ+Vvyvj2vwXWr5+6GNZGT59kg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2017 at 5:53 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Apr 26, 2017 at 4:40 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> The reason I think the COPYUP vs. MERGE distinction is needed is the
>> ovl_check_empty_and_clear() thing.  It starts with a merged directory
>> with some whiteouts in it and exchanges it with an empty and opaque
>> directory.   Normally the empty directory will be deleted immediately,
>> but if something fails during the deletion, then it will remain there.
>>   The overlay is left in a consistent state, but the association with
>> the original inode should still remain, so it will have COPYUP but not
>> MERGE.
>
> One more thought: we could introduce a separate "overlay.merge"
> attribute that is the exact opposite of "overlay.opaque".
> "overlay.merge" would imply "overlay.fh" but "overlay.fh" would not
> imply "overlay.merge".
>
> It would allow us to optionally get rid of "overlay.opaque" when back
> compatibility is not needed.
>
> It would also allow a new feature: on metadata only updates of regular
> files we wouldn't need to copy up the data.
>

So you intend to set overlay.merge for non-dir?
How is it different from overlay.fh then?
With it's new name, overlay.origin.fh indicates that there is a copy
up origin below us. Either directly below us, or at overlay.redirect.
We can also try to follow to origin by fh, but that is only an optimization -
an important optimization IMO, because file rename are more common
than dir renames and lookup stable inode by fh in a deep directory
with many layers will be much more efficient by fh.

Are we understanding each other w.r.t. overlay.merge vs overlay.fh?
