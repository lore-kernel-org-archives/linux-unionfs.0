Return-Path: <vgoyal@redhat.com>
Date: Mon, 9 Apr 2018 08:18:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v13 27/28] ovl: Verify a data dentry has been found for
 metacopy inode
Message-ID: <20180409121815.GA21673@redhat.com>
References: <CAOQ4uxjB3vPtS+veYMSP1ZsBxbZs8O6QBQ6d81FQWgpjjP+Ntg@mail.gmail.com>
 <20180405143757.GA4017@redhat.com>
 <20180405182211.GB4017@redhat.com>
 <CAOQ4uxivYrzF-M0Csy6Kr=gsLHAkApZ1apjiET=ZkgW2f-X_Rw@mail.gmail.com>
 <20180405204543.GA19532@redhat.com>
 <CAOQ4uxjZpVurV=8LV7X1V-oS4wVUOHYJQo6_NBXBdZ=nmLT4Ag@mail.gmail.com>
 <20180406153716.GA18336@redhat.com>
 <CAOQ4uxj3bOJx4W5U=XMMP=iCTyYw8=2qL8wdR31zT0tTzxQ=9A@mail.gmail.com>
 <20180406173203.GB382@redhat.com>
 <CAOQ4uxiKe+UPbPtWGfqFtQSZjPqo7Zm94-+Nk1_cC5e8sFN8LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiKe+UPbPtWGfqFtQSZjPqo7Zm94-+Nk1_cC5e8sFN8LQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Apr 06, 2018 at 11:10:05PM +0300, Amir Goldstein wrote:
> On Fri, Apr 6, 2018 at 8:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> [...]
> >> >>
> >> >> Back to the original question: how should ovl_inode->redirect
> >> >> be protected if at all it needs protection?
> >> >
> >> > At this point I am thinking at max we need to just take ovl_inode->lock
> >> > to protect ovl_inode->redirect. It just makes it little safer and
> >> > relatively easier to understand.
> >> >
> >>
> >> I agree. I don't think ovl_inode->lock is needed, but I would
> >> add a comment explaining why (VFS inode lock).
> >>
> >> The problem is that we cannot get rid of d_lock for path traversal
> >> and I don't see how we can easily take both ovl dentry d_lock with
> >> ovl_inode->lock, because the latter is a sleeping lock, but layering
> >> wise it is logically below the overlay dentry lock.
> >
> > Actually, I think ovl_inode->lock is at same layer as inode->i_rwsem. So
> > VFS first takes i_rwsem and then d_lock. And we probably should do the
> > same thing. In fact we are already taking ovl_inode->lock in
> > ovl_nlink_start() first and then calling ovl_set_redirect() which takes
> > d_lock.
> >
> 
> It's not completely ok that we do that.
> 
> If we can always abide to the rules of locking order:
> VFS overlay layer locks -> internal overlay locks -> VFS underlying fs locks

Sure, and that's what will happen when we move ovl_set_redirect() above
lock_rename().

- When ovl_rename() is called, VFS is holding ovl layer locks.
- ovl_nlink_start() and ovl_set_redrect() with take internal
  overlay lock (ovl_inode->lock)
- And then lock_rename() will take VFS underlying fs lock.

So ordering of locks will be exactly as you like it.

Vivek
