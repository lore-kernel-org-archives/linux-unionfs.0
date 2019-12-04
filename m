Return-Path: <fvogt@suse.de>
From: Fabian Vogt <fvogt@suse.de>
Subject: Re: overlayfs does not pin underlying layers
Date: Wed, 04 Dec 2019 18:05:54 +0100
Message-ID: <9499302.rauRU9GSnF@linux-e202.suse.de>
In-Reply-To: <CAJfpeguBxP7QPSr9UO6yzPpWHJ+fAckozQ823u5hPY76kqYjSQ@mail.gmail.com>
References: <7817498.QaoxCVBQX0@linux-e202.suse.de> <CAJfpeguBxP7QPSr9UO6yzPpWHJ+fAckozQ823u5hPY76kqYjSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs <linux-unionfs@vger.kernel.org>, Ignaz Forster <iforster@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

Am Dienstag, 3. Dezember 2019, 15:19:28 CET schrieb Miklos Szeredi:
> On Tue, Dec 3, 2019 at 2:49 PM Fabian Vogt <fvogt@suse.de> wrote:
> >
> > Hi,
> >
> > I noticed that you can still unmount the lower/upper/work layers, even if
> > they're currently part of an active overlay mount. This is the case even when
> > files in the overlay mount are currently open. After unmounting, the usual
> > effects of a lazy umount can be observed, like still active loop devices.
> >
> > Is this intentional?
> 
> It's a known feature.  Not sure how much thought was given to this,
> but nobody took notice up till now.
> 
> Do you have a good reason for wanting the underlying mounts pinned, or
> you are just surprised by this behavior?  In the latter case we can
> just add a paragraph to the documentation and be done with it.

Both. It's obviously very inconsistent that it's possible to unmount something
which you still have unrestricted access to.

The specific issue we're facing here is system shutdown - if there's an active
overlayfs mount, it's not guaranteed that the unmounts happen in the right
order. Currently we work around that by adding the systemd specific
"x-systemd.requires-mounts-for=foo-lower.mount" option in /etc/fstab.
If for some reason the order is wrong, this behaviour of overlayfs might lead
to the system shutting down without the actual unmount happening properly,
as it's equivalent to "umount -l" on lower/upper FSs.
I'm not sure whether there's a scenario in which this could even lead to data
loss if something relies on umount succeeding to mean that the attached device
is unused.

Cheers,
Fabian

> Thanks,
> Miklos
