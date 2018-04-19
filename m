From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 31/35] Revert "vfs: add d_real_inode() helper"
Date: Thu, 19 Apr 2018 15:54:49 -0400
Message-ID: <20180419195449.GC9451@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
 <20180412150826.20988-32-mszeredi@redhat.com>
 <CAOQ4uxgdWCWvwWgjUu06H=BeMxh-BVAjxVE5Ckj-poKRGgwvMQ@mail.gmail.com>
 <CAJfpegtLdmnxieDx7+FBUoc-fKsTEwA+oHinhAfa4E9SDFfSNw@mail.gmail.com>
 <20180418093845.19ca33f3@gandalf.local.home>
 <CAJfpeguJN0+m9Vhtv0fo79xq-P1UzWki9GqQq9WyJRMEwiJBqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpeguJN0+m9Vhtv0fo79xq-P1UzWki9GqQq9WyJRMEwiJBqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Howard McLauchlan <hmclauchlan@fb.com>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 18, 2018 at 03:49:02PM +0200, Miklos Szeredi wrote:
> On Wed, Apr 18, 2018 at 3:38 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Wed, 18 Apr 2018 13:42:03 +0200
> > Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> >> On Wed, Apr 18, 2018 at 10:19 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> >> > On Thu, Apr 12, 2018 at 6:08 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> >> >> This reverts commit a118084432d642eeccb961c7c8cc61525a941fcb.
> >> >>
> >> >> No user of d_real_inode() remains, so it can be removed.
> >> >>
> >> >
> >> > FYI, there is a new user in v4.17-rc1 added by commit
> >> > f0a2aa5a2a40 tracing/uprobe: Add support for overlayfs
> >> >
> >> > Seems like this patch got merged without any CC to overlayfs
> >> > mailing list nor maintainer?
> >
> > It appeared to be a small change with lots of reviewers. I didn't think
> > it was something to notify the overlayfs folks with. But perhaps I was
> > wrong.
> 
> The patch is correct.  The code surrounding it isn't, though.
> 
> >
> >> >
> >> > Not sure yet if overlayfs-rorw patches would allow reverting this
> >> > change.
> >>
> >> Not trivial, because uprobe is looking at i_mapping to get a list of
> >> current memory maps.   We could set i_mapping at overlay inode
> >> initialization time, but we definitely can't *change* i_mapping at
> >> copy up.  Which is bound to result in some weird inconsistencies.  So
> >> likely we'll need to keep d_real_inode() for the time being.
> >
> > I just received this patch:
> >
> >  http://lkml.kernel.org/r/20180418062907.3210386-1-songliubraving@fb.com
> >
> > Which removes this code. Can you review it and I'll take it.
> 
> It shouldn't remove d_real_inode(), because that part is correct and
> fixes a real bug in handling overlayfs files.

I am wondering what does it practically mean for metdata only copy up
patches. Given this is uprobe code, I am assuming its modifying some
executable code dynamically. And for the the case of metadata only
copy up, it will return inode of lower. That probably means, as long
as all running instances of that exeutable are using that inode, things
will work fine.

But if for some reason somebody opens that file for WRITE and triggers
copy up and new instances of same binary will not see the probe taking
affect?

Which is probably very similar to what will happen if a lower executable
is copied up. Having said that, in normal cases there should not be a
need to copy up a binary in normal circumstances.

Am I missing the point completely.

Thanks
Vivek
