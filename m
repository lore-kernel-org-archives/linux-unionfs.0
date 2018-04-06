Return-Path: <vgoyal@redhat.com>
Date: Fri, 6 Apr 2018 11:37:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v13 27/28] ovl: Verify a data dentry has been found for
 metacopy inode
Message-ID: <20180406153716.GA18336@redhat.com>
References: <CAOQ4uxhU6U=PRXod37xNJPC0B081CrLtuVBmOECnTG7j6VWn+g@mail.gmail.com>
 <20180404122924.GB10495@redhat.com>
 <CAOQ4uxjQTtgXyohfz+_krgCX88jC8Bxt02RaYfN6FC=4TPcxJw@mail.gmail.com>
 <20180404132136.GA12921@redhat.com>
 <CAOQ4uxjB3vPtS+veYMSP1ZsBxbZs8O6QBQ6d81FQWgpjjP+Ntg@mail.gmail.com>
 <20180405143757.GA4017@redhat.com>
 <20180405182211.GB4017@redhat.com>
 <CAOQ4uxivYrzF-M0Csy6Kr=gsLHAkApZ1apjiET=ZkgW2f-X_Rw@mail.gmail.com>
 <20180405204543.GA19532@redhat.com>
 <CAOQ4uxjZpVurV=8LV7X1V-oS4wVUOHYJQo6_NBXBdZ=nmLT4Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjZpVurV=8LV7X1V-oS4wVUOHYJQo6_NBXBdZ=nmLT4Ag@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Apr 06, 2018 at 12:46:31PM +0300, Amir Goldstein wrote:
> On Thu, Apr 5, 2018 at 11:45 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> [...]
> >> >
> >> > If you don't like this locking ovl_inode->lock model, I guess for now
> >> > I could live with not removing REDIRECT after copy up. Once that gets
> >> > merged, I could do one patch series just to clean up REDIRECT after copy
> >> > up and do proper locking.
> >> >
> >>
> >> I think we are confusing two different things in this discussion.
> >> Locking ovl_inode->lock for changing redirect is something that should
> >> stay in the patch set IMO and should be simplified by moving
> >> set redirect before taking rename locks on two inodes.
> >>
> >> I was asking about removal of REDIRECT because this patch
> >> (ovl_verify_metacopy_data) is a bit tricky for me to review and
> >> I still don't feel confident about it.
> >>
> >> My intuition says we could go other ways as well:
> >> - unite METACOPY/REDIRECT xattr (we can call the unite
> >> xattr REDIRECT and not METACOPY)
> >> - memory barriers between setting/clearing/checking
> >> METACOPY/REDIRECT (there is already a barrier for setting
> >> upperdata flag, so that's half the work already.
> >>
> >> We can either have this discussion now or, as you suggested
> >> leave it to a following patch set. Rule of thumb - if this is v13
> >> with 28 patches, might not be a bad idea to deffer 2 patches
> >> and reduce complexity...
> >>
> >
> > Hi Amir,
> >
> > Ok, let me drop removing REDIRECT from the patchset to reduce
> > complexity. Lets first try to get in a basic version in.
> >
> > Now coming to the question of locking ovl_inode->lock. If REDIRECTS
> > are never removed and only upgraded (from relative to absolute), my
> > understanding is that current VFS locking is sufficient to prevent
> > races. Only rename and link path set redirects and both the paths take
> > inode locks and that means two set redirects can't make progress in
> > parallel on an inode.
> >
> > When it comes to ovl_lookup(), we will set ovl_inode->redirect only for
> > the case of I_NEW. So no races should be there as well.
> >
> > So far we had to add locking due to copy up path and now copy up path
> > will not touch redirect xattr. I probably will not even clear
> > ovl_inode->inode redirect as we are not removing REDIRECT.
> >
> > Do you see any other path racing and still needed ovl_inode->lock?
> >
> 
> Let's see.
> 
> Current code is taking A->d_lock in ovl_set_redirect(A) to protect
> against racing with redirect path traversal in ovl_get_redirect(A/B/c).
> 
> For the purpose of protecting ancestors redirect path, d_lock is
> sufficient and is needed anyway to access d_name.
> 
> Also any rename in the filesystem is *also* serialized with
> ovl_sb->s_vfs_rename_mutex. That would make the change I suggested
> to move ovl_set_redirect() before lock_rename() a bit tricky.
> You may say that taking d_lock in ovl_set_redirect() is not strictly
> needed, but I guess it is better coding (or maybe something I am
> missing).
> 
> Now when adding ovl_set_redirect() for non-dir and in ovl_link() the
> plot thickens, because:
> 1. link is not serialized with ovl_sb->s_vfs_rename_mutex lock,
> so path traversal in ovl_get_redirect() in unstable
> 2. 'old' dentry in ovl_link() can be disconnected, so there is
> no path for ovl_get_redirect() at all.
> 
> The only way to get a disconnected dentry is with nfs export, so for
> now, it is enough to WARN_ON and return error in ovl_set_redirect()
> for (dentry->d_flags & DCACHE_DISCONNECTED)
> with a comment referring to nfs_export+metacopy support.

Hi Amir,

I can put this warning for DCACHE_DISCONNECTED dentries.

Now, most interesting part for me here is that why do we need to
stop/synchronize other renames in the system while some set_redirect/get
_redirect operation is taking place. That's the part I don't understand.
When I am looking at current code, I feel d_lock, seems to be good enough
to make sure that ovl_get_redirect() works fine when parallel renames
progressing on other cpu.

So a simple example, is say I am creating a link bar/foo-link.txt to a file
foo/foo.txt and that triggers setting absolute redirect on foo.txt
and we will call ovl_get_direct() and  traverse the tree up till root. 
Now say a part of the tree is also being renamed. Say foo/ is being
renamed to alpha/. I am wondering is d_lock is not enough to make sure
this is not a problem.

We always set redirect first and then do rename. That means d_parent
should be changed only after redirect has been set on a dentry. And
that should guarantee that if ovl_get_redirect() sees new parent, 
then parent_dentry->redirect has been already set. If it sees dentry
before rename, then redirect might be there if not, dentry name would
be used and it will also see the old parent and continue traversal
up.

Is there anything I am missing? 

> 
> Maybe the simplest solution w.r.t stabilizing path traversal
> is to move ovl_set_redirect() above lock_rename()
> as I suggested and use a new lock ofs->ovl_rename_mutex
> inside ovl_get_redirect() to protect the !samedir traversal
> and also take that lock before lock_rename() in ovl_rename().

I already made changes to move ovl_set_redirect() above lock_rename()
in my copy. I still can't see the need of ofs->ovl_rename_mutex. Please
help me understand the need with an example.

> 
> Back to the original question: how should ovl_inode->redirect
> be protected if at all it needs protection?

At this point I am thinking at max we need to just take ovl_inode->lock
to protect ovl_inode->redirect. It just makes it little safer and
relatively easier to understand.

Thanks
Vivek

> I think setting redirect need the protection of ofs->ovl_rename_mutex.
> Can either take it just around ovl_dentry_set_redirect(), probably
> instead of d_lock, or take the ovl_rename_mutex inside
> ovl_set_redirect() and around ovl_get_redirect() instead of inside
> ovl_get_redirect().
> 
> Hmm, I hope I got this right. I advise to get feedback from Miklos
> to this design before you proceed.
> 
> Thanks,
> Amir.
