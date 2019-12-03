MIME-Version: 1.0
Date: Tue, 3 Dec 2019 15:19:28 +0100
References: <7817498.QaoxCVBQX0@linux-e202.suse.de>
In-Reply-To: <7817498.QaoxCVBQX0@linux-e202.suse.de>
Message-ID: <CAJfpeguBxP7QPSr9UO6yzPpWHJ+fAckozQ823u5hPY76kqYjSQ@mail.gmail.com>
Subject: Re: overlayfs does not pin underlying layers
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Fabian Vogt <fvogt@suse.de>
Cc: linux-unionfs <linux-unionfs@vger.kernel.org>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Dec 3, 2019 at 2:49 PM Fabian Vogt <fvogt@suse.de> wrote:
>
> Hi,
>
> I noticed that you can still unmount the lower/upper/work layers, even if
> they're currently part of an active overlay mount. This is the case even when
> files in the overlay mount are currently open. After unmounting, the usual
> effects of a lazy umount can be observed, like still active loop devices.
>
> Is this intentional?

It's a known feature.  Not sure how much thought was given to this,
but nobody took notice up till now.

Do you have a good reason for wanting the underlying mounts pinned, or
you are just surprised by this behavior?  In the latter case we can
just add a paragraph to the documentation and be done with it.

Thanks,
Miklos
