From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: overlayfs access checks on underlying layers
Date: Thu, 29 Nov 2018 08:49:43 -0500
Message-ID: <20181129134943.GA16762@redhat.com>
References: <CAJfpegs9JjkXguemL4qSiBvRP6Dnut-D+nJo-oLFXkfCL1Egvw@mail.gmail.com>
 <CAJfpegvfqx+0D32n1h2X7oj5d1mZWiLTcSSGpBnD+ba7AKzPyA@mail.gmail.com>
 <20181127210542.GA2599@redhat.com>
 <CAJfpegtQGM2z9TOt3DWwd39fC60cQknsC4vNnj7YimVEubRzUg@mail.gmail.com>
 <20181128170302.GA12405@redhat.com>
 <377b7d4f-eb1d-c281-5c67-8ab6de77c881@tycho.nsa.gov>
 <CAJfpegtNhcWD0VWy6LPtoDtQBfPu4x5iFsB053UMCidj6oMsuw@mail.gmail.com>
 <26bce3be-49c2-cdd8-af03-1a78d0f268ae@tycho.nsa.gov>
 <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpeguL9xOh9Eq8LOP=ddJ4YD6nbp2UY6e2AYDVoHeCLuVhZA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Ondrej Mosnacek <omosnace@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Mark Salyzyn <salyzyn@android.com>, Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org, Daniel J Walsh <dwalsh@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 29, 2018 at 12:04:20PM +0100, Miklos Szeredi wrote:
> On Wed, Nov 28, 2018 at 10:43 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> >
> > On 11/28/18 3:24 PM, Miklos Szeredi wrote:
> > > On Wed, Nov 28, 2018 at 8:32 PM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> [...]
> 
> > >> Does the breaking commit (007ea44892e6) fix a real bug affecting users?
> > >>    If not, I'd recommend just reverting it.
> > >
> > > That is certainly an option, but...  this is all about context=
> > > mounts, right?  Which allows mounter to override MAC checks under the
> > > new mount?  On any mount, not just overlay, right?  So why is overlay
> > > special?
> >
> > With other filesystems, the files are only accessible under the context
> > specified by the mounter (and you can't mount it twice with differing
> > context mount options). With overlay, the file is simultaneously
> > accessible under both the context specified by the mounter via the
> > overlay and under its lower/upper context via the lower/upper dir.
> >
> > Generally we only use context mounts on other filesystems when they have
> > no label information at all (no security.selinux xattrs) or when they
> > are completely untrusted to provide that information; the context
> > specified by the mounter is the only basis for access control.  With
> > overlay, we are frequently dealing with labeled lower and upper
> > directories in a filesystem we trust.
> >
> > It seems like overlay has a goal of preventing the mounter from
> > escalating its access through an overlay mount.
> 
> Overlayfs main purpose is to bypass limited access to a read-only
> filesystem by copying up on a write access.  So bypassing access is
> built into the system, but it's done in a way that in the end it
> doesn't permit mounter to do more than it could otherwise do.  Or at
> least that's the intent, as you say.
> 
> To generalize that, we could say:  trigger a copy-up if access to
> lower layer object is denied.  That would extend the scope of the
> trigger from write access on file/dir to read/write on special files
> and execute on regular files, all of which could theoretically be
> denied on the lower object, yet allowed on the upper object without
> violating the above rule.

Apart from copy-up, one intent of mounter checks was also to make sure
mounter did not allow access to objects in lower/upper which mounter
itself did not have access to.

So a mounter which can not open upper/foo.txt should not be able to create
a context overlay mount and allow opening upper/foo.txt to a user. IIUC,
that's one of the purposes of second level of check in mounter context and
if it makes sense, then it should extend to special file and exectuable
too?

> 
> > > I'd just like to see proper justification for why we should be doing
> > > those checks on underlying layer that simply don't belong there, IMO.
> > >   I'm sure you know better than I that it's not just about real bugs
> > > affecting users, it's about having a clear, well defined model to base
> > > the design on.   And by reverting the breaking commit, I don't see us
> > > getting closer to that.
> >
> > It seems like the NFS folks raised a number of concerns with the overlay
> > approach beyond just these two checks,
> 
> The concerns that NFS folks had was that overlayfs does not enforce
> permission checks (with creds of task) on underlying objects,
> resulting in possibly elevated access compared to directly accessing
> the NFS mount.    But I think there's no way to reconcile server
> permission checks with overlayfs, so we are left with the current
> model of only verifying the permission on the server against the
> mounter's creds.
> 
> > and Android has their
> > override_creds=off use case.  Maybe the overlay model needs a more
> > significant rethinking than just these two cases.
> 
> Yes, it would be good if that override_creds=off use case was
> discussed.  AFAICS it trades less privilege in the mounter for more
> privilege in the task accessing the overlay.  If, or how, that is a
> good model for anything other than Android is not clear to me.

So will override_creds=off solve the NFS issue also where all access will
happen with the creds of task now? Though it will stil require more
priviliges in task for other operations in overlay to succeed.

Thanks
Vivek
