Return-Path: <jack@suse.cz>
Date: Thu, 18 Apr 2019 12:53:35 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: fanotify and LSM path hooks
Message-ID: <20190418105335.GB28541@quack2.suse.cz>
References: <CAOQ4uxgn=YNj8cJuccx2KqxEVGZy1z3DBVYXrD=Mc7Dc=Je+-w@mail.gmail.com>
 <20190416154513.GB13422@quack2.suse.cz>
 <CAOQ4uxh66kAozqseiEokqM3wDJws7=cnY-aFXH_0515nvsi2-A@mail.gmail.com>
 <20190417113012.GC26435@quack2.suse.cz>
 <CAJfpegsyzYTkUw7rgpQfB0BKqK-LBZh6fBMUO5iq2JHv1youzw@mail.gmail.com>
 <20190417140558.GB15563@quack2.suse.cz>
 <CAJfpegvYnnjv7uoQjL1avx5tO-0H0ZecmVK9Sgk-F1NoW0HAuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvYnnjv7uoQjL1avx5tO-0H0ZecmVK9Sgk-F1NoW0HAuw@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Matthew Bobrowski <mbobrowski@mbobrowski.org>, LSM List <linux-security-module@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed 17-04-19 16:14:32, Miklos Szeredi wrote:
> On Wed, Apr 17, 2019 at 4:06 PM Jan Kara <jack@suse.cz> wrote:
> >
> > On Wed 17-04-19 14:14:58, Miklos Szeredi wrote:
> > > On Wed, Apr 17, 2019 at 1:30 PM Jan Kara <jack@suse.cz> wrote:
> > > >
> > > > On Tue 16-04-19 21:24:44, Amir Goldstein wrote:
> > > > > > I'm not so sure about directory pre-modification hooks. Given the amount of
> > > > > > problems we face with applications using fanotify permission events and
> > > > > > deadlocking the system, I'm not very fond of expanding that API... AFAIU
> > > > > > you want to use such hooks for recording (and persisting) that some change
> > > > > > is going to happen and provide crash-consistency guarantees for such
> > > > > > journal?
> > > > > >
> > > > >
> > > > > That's the general idea.
> > > > > I have two use cases for pre-modification hooks:
> > > > > 1. VFS level snapshots
> > > > > 2. persistent change tracking
> > > > >
> > > > > TBH, I did not consider implementing any of the above in userspace,
> > > > > so I do not have a specific interest in extending the fanotify API.
> > > > > I am actually interested in pre-modify fsnotify hooks (not fanotify),
> > > > > that a snapshot or change tracking subsystem can register with.
> > > > > An in-kernel fsnotify event handler can set a flag in current task
> > > > > struct to circumvent system deadlocks on nested filesystem access.
> > > >
> > > > OK, I'm not opposed to fsnotify pre-modify hooks as such. As long as
> > > > handlers stay within the kernel, I'm fine with that. After all this is what
> > > > LSMs are already doing. Just exposing this to userspace for arbitration is
> > > > what I have a problem with.
> > >
> > > There's one more usecase that I'd like to explore: providing coherent
> > > view of host filesystem in virtualized environments.  This requires
> > > that guest is synchronously notified when the host filesystem changes.
> > >   I do agree, however, that adding sync hooks to userspace is
> > > problematic.
> > >
> > > One idea would be to use shared memory instead of a procedural
> > > notification.  I.e. application (hypervisor) registers a pointer to a
> > > version number that the kernel associates with the given inode.  When
> > > the inode is changed, then the version number is incremented.  The
> > > guest kernel can then look at the version number when verifying cache
> > > validity.   That way perfect coherency is guaranteed between host and
> > > guest filesystems without allowing a broken guest or even a broken
> > > hypervisor to DoS the host.
> >
> > Well, statx() and looking at i_version can do this for you. So I guess
> > that's too slow for your purposes?
> 
> Okay, missing piece of information: we want to make use of the dcache
> and icache in the guest kernel, otherwise lookup/stat will be
> painfully slow.  That would preclude doing statx() or anything else
> that requires a synchronous round trip to the host for the likely case
> of a valid cache.

Ok, understood.
 
> > Also how many inodes do you want to
> > monitor like this?
> 
> Everything that's in the guest caches.  Which means: a lot.

Yeah, but that would mean also non-trivial amount of memory pinned for this
communication channel... And AFAIU the cost of invalidation going to the
guest isn't so critical as that isn't expected to be that frequent. It is
only the cost of 'is_valid' check that needs to be low to make the caching
in the guest useful. So won't it be better if we just had some kind of ring
buffer for invalidation events going from host to guest, host could just
queue event there (i.e., event processing from the host would have well
bounded time like processing normal fsnotify events has), guest would be
consuming events and updating its validity information. If the buffer
overflows, it means "invalidate all" which is expensive for the guest but
if buffers are reasonably sized, it should not happen frequently...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
