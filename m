From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 07/11] ovl: set the COPYUP type flag for non-dirs
Date: Wed, 26 Apr 2017 16:53:10 +0200
Message-ID: <CAJfpegsF6W94qrEs_LjuCw+2vJ+Vvyvj2vwXWr5+6GNZGT59kg@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
 <1493025256-27188-8-git-send-email-amir73il@gmail.com> <CAJfpegt4kwmWmyUhY0RAzvSegbBHdKO6ZWuUXdQWtWdz2eSvOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegt4kwmWmyUhY0RAzvSegbBHdKO6ZWuUXdQWtWdz2eSvOA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2017 at 4:40 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

> The reason I think the COPYUP vs. MERGE distinction is needed is the
> ovl_check_empty_and_clear() thing.  It starts with a merged directory
> with some whiteouts in it and exchanges it with an empty and opaque
> directory.   Normally the empty directory will be deleted immediately,
> but if something fails during the deletion, then it will remain there.
>   The overlay is left in a consistent state, but the association with
> the original inode should still remain, so it will have COPYUP but not
> MERGE.

One more thought: we could introduce a separate "overlay.merge"
attribute that is the exact opposite of "overlay.opaque".
"overlay.merge" would imply "overlay.fh" but "overlay.fh" would not
imply "overlay.merge".

It would allow us to optionally get rid of "overlay.opaque" when back
compatibility is not needed.

It would also allow a new feature: on metadata only updates of regular
files we wouldn't need to copy up the data.

Thanks,
Miklos
