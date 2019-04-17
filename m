MIME-Version: 1.0
Date: Wed, 17 Apr 2019 14:14:58 +0200
References: <CAOQ4uxgn=YNj8cJuccx2KqxEVGZy1z3DBVYXrD=Mc7Dc=Je+-w@mail.gmail.com>
	<20190416154513.GB13422@quack2.suse.cz>
	<CAOQ4uxh66kAozqseiEokqM3wDJws7=cnY-aFXH_0515nvsi2-A@mail.gmail.com>
	<20190417113012.GC26435@quack2.suse.cz>
In-Reply-To: <20190417113012.GC26435@quack2.suse.cz>
Message-ID: <CAJfpegsyzYTkUw7rgpQfB0BKqK-LBZh6fBMUO5iq2JHv1youzw@mail.gmail.com>
Subject: Re: fanotify and LSM path hooks
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Matthew Bobrowski <mbobrowski@mbobrowski.org>, LSM List <linux-security-module@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 17, 2019 at 1:30 PM Jan Kara <jack@suse.cz> wrote:
>
> On Tue 16-04-19 21:24:44, Amir Goldstein wrote:
> > > I'm not so sure about directory pre-modification hooks. Given the amount of
> > > problems we face with applications using fanotify permission events and
> > > deadlocking the system, I'm not very fond of expanding that API... AFAIU
> > > you want to use such hooks for recording (and persisting) that some change
> > > is going to happen and provide crash-consistency guarantees for such
> > > journal?
> > >
> >
> > That's the general idea.
> > I have two use cases for pre-modification hooks:
> > 1. VFS level snapshots
> > 2. persistent change tracking
> >
> > TBH, I did not consider implementing any of the above in userspace,
> > so I do not have a specific interest in extending the fanotify API.
> > I am actually interested in pre-modify fsnotify hooks (not fanotify),
> > that a snapshot or change tracking subsystem can register with.
> > An in-kernel fsnotify event handler can set a flag in current task
> > struct to circumvent system deadlocks on nested filesystem access.
>
> OK, I'm not opposed to fsnotify pre-modify hooks as such. As long as
> handlers stay within the kernel, I'm fine with that. After all this is what
> LSMs are already doing. Just exposing this to userspace for arbitration is
> what I have a problem with.

There's one more usecase that I'd like to explore: providing coherent
view of host filesystem in virtualized environments.  This requires
that guest is synchronously notified when the host filesystem changes.
  I do agree, however, that adding sync hooks to userspace is
problematic.

One idea would be to use shared memory instead of a procedural
notification.  I.e. application (hypervisor) registers a pointer to a
version number that the kernel associates with the given inode.  When
the inode is changed, then the version number is incremented.  The
guest kernel can then look at the version number when verifying cache
validity.   That way perfect coherency is guaranteed between host and
guest filesystems without allowing a broken guest or even a broken
hypervisor to DoS the host.

Thanks,
Miklos
