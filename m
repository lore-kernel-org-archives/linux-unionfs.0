Return-Path: <vgoyal@redhat.com>
Date: Thu, 5 Apr 2018 16:45:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v13 27/28] ovl: Verify a data dentry has been found for
 metacopy inode
Message-ID: <20180405204543.GA19532@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
 <20180329193854.13814-28-vgoyal@redhat.com>
 <CAOQ4uxhU6U=PRXod37xNJPC0B081CrLtuVBmOECnTG7j6VWn+g@mail.gmail.com>
 <20180404122924.GB10495@redhat.com>
 <CAOQ4uxjQTtgXyohfz+_krgCX88jC8Bxt02RaYfN6FC=4TPcxJw@mail.gmail.com>
 <20180404132136.GA12921@redhat.com>
 <CAOQ4uxjB3vPtS+veYMSP1ZsBxbZs8O6QBQ6d81FQWgpjjP+Ntg@mail.gmail.com>
 <20180405143757.GA4017@redhat.com>
 <20180405182211.GB4017@redhat.com>
 <CAOQ4uxivYrzF-M0Csy6Kr=gsLHAkApZ1apjiET=ZkgW2f-X_Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxivYrzF-M0Csy6Kr=gsLHAkApZ1apjiET=ZkgW2f-X_Rw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 05, 2018 at 10:58:58PM +0300, Amir Goldstein wrote:
> On Thu, Apr 5, 2018 at 9:22 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Apr 05, 2018 at 10:37:57AM -0400, Vivek Goyal wrote:
> >> On Wed, Apr 04, 2018 at 06:51:57PM +0300, Amir Goldstein wrote:
> >> > On Wed, Apr 4, 2018 at 4:21 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > > On Wed, Apr 04, 2018 at 03:51:37PM +0300, Amir Goldstein wrote:
> >> > >> On Wed, Apr 4, 2018 at 3:29 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > >> > On Fri, Mar 30, 2018 at 01:53:24PM +0300, Amir Goldstein wrote:
> >> > >> >> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > >> >> > If we find a upper metacopy inode, make sure we also found associated data
> >> > >> >> > dentry in lower. Otherwise copy up operation later will fail.
> >> > >> >> >
> >> > >> >> > There are two cases where this can happen. First case is that somehow
> >> > >> >> > data file was removed from lower layer. Other case is that REDIRECT
> >> > >> >> > xattr was removed due to copy up of file on another cpu (when inode is
> >> > >> >> > shared between two dentries) and hence ovl_lookup() could not find the
> >> > >> >> > correct dentry.
> >> > >> >> >
> >> > >> >>
> >> > >> >> Remind me again why we remove REDIRECT xattr?
> >> > >> >> Is it a must for functionality or just for being boy scouts?
> >> > >> >> I would prefer to avoid having to deal with races of this sort.
> >> > >> >> You can cleanup REDIRECT for non-dir that is not metacopy
> >> > >> >> on lookup when finding a I_NEW inode.
> >> > >> >
> >> > >> > Ok, thinking more about it. If we were to clean REDIRECT on lookup when
> >> > >> > finding I_NEW inode, that means we will have to always do
> >> > >> > vfs_removexattr(OVL_XATTR_REDIRECT) on all non-metacopy non-dir files.
> >> > >> > That does not sound like a very good idea. Its unnecessary overhead in
> >> > >> > lookup path.
> >> > >> >
> >> > >> > IOW, I think removing REDIRECT and doing appropriate locking around
> >> > >> > ovl_inode->redirect is probably better.
> >> > >> >
> >> > >>
> >> > >> Here is what I propose.
> >> > >> During lookup, you anyway check REDIRECT and check METACOPY
> >> > >> on upper and then call ovl_get_inode() with upper redirect and upper
> >> > >> metacopy information.
> >> > >
> >> > > We check for upperredirect only if metacopy xattr is found. Otherwise
> >> > > we skip checking for redirect.
> >> > >
> >> > > https://github.com/rhvgoyal/linux/blob/metacopy-v13/fs/overlayfs/namei.c#L270
> >> > >
> >> > >>
> >> > >> IF this is a new inode AND both REDIRECT and METACOPY were
> >> > >> found on upper THEN it is safe to remove REDIRECT xattr.
> >> > >
> >> > > If both METACOPY and REDIRECT were found, then we should not remove
> >> > > REDIRECT. That REDIRECT is still useful. REDIRECT should be removed
> >> > > only if METACOPY is not found and REDIRECT is found (on a non-dir file).
> >> > >
> >> > >>
> >> > >> Maybe I am missing something, but I don't see where the extra overhead
> >> > >> is, beyond the overhead already there for metacopy enabled lookup.
> >> > >
> >> > > Given we don't check for REDIRECT if upper is not METACOPY, that means
> >> > > we will have to always check for REDIRECT in ovl_get_inode() and add
> >> > > the unnecessary overhead (To all non-dir files).
> >> > >
> >> >
> >> > I see.
> >> >
> >> > >>
> >> > >> OTOH, I don't see what cleaning REDIRECT gets us in the first place.
> >> > >> During lookup, REDIRECT does not affect non metacopy non-dir,
> >> > >> because we skip ovl_check_redirect().
> >> > >> REDIRECT could actually be useful for reconstructing ORIGIN xattr
> >> > >> and index after copying layers, so not sure its a good thing to remove it
> >> > >> at all. After all, redirects are pretty rare as it is.
> >> > >
> >> > > I see it as unnecessary xattr present and feel that cleaning it is a
> >> > > good idea. Given we are thinking of packing REDIRECT xattr in tar file
> >> > > for layer backup and restore case, it makes even more sense to clean
> >> > > it up otherwise it shows up every where unnecessarily. I personally
> >> > > think it is always a good idea to cleanup information you don't need
> >> > > anymore, instead of letting it sit around.
> >> > >
> >> >
> >> > Look. I have no objection to cleaning REDIRECT, but I am saying it
> >> > is tricky, so I think it is going to cost you a few more patches and maybe
> >> > a few more review cycles, so I advised against it.
> >>
> >> Hi Amir,
> >>
> >> Anyway, I doubt these patches are going to be merged for 4.17. So
> >> I am fine if it takes few more revisions to properly review it. Doing
> >> it properly is more important. (Despite the fact that I am little
> >> exhausted now. :-))
> >>
> >> >
> >> > But here is another idea: store the redirect string in the METACOPY
> >> > xattr, this way, removal of METACOPY xattr atomically cleans up
> >> > REDIRECT and in lookup, only need to check METACOPY xattr
> >> > (exists but empty means no redirect).
> >>
> >> I don't like this much. I had thought about it but did not pursue it.
> >>
> >> - First of all, I don't like that REDIRECT for dir and non-dir will be
> >>   stored differently.
> >>
> >> - Secondly, xattr is just one pience. We also need to protet
> >>   ov_inode->redirect field and this will not solve that issue. That issue
> >>   can be solved only if we provide proper locking so that readers and
> >>   writers of ovl_inode->redirect don't race and run into unexpected
> >>   surprises.
> >>
> >> Given VFS locking does not protect against copy up path races with
> >> rename(), I think that right solution for this problem is to protect
> >> against this race by taking ovl_inode->lock. I think this is something
> >> future readers can understand and build more functionality on top.
> >>
> >> If we are primarily worried about races against copy up for redirect, then
> >> we probably don't have to double lock both ovl_inodes. As you suggested,
> >> I should be able to move out set_redirect() earlier in rename
> >> path and take one lock at a time. That should simplify the locking
> >> logic a bit. How about this instead?
> >
> > If you don't like this locking ovl_inode->lock model, I guess for now
> > I could live with not removing REDIRECT after copy up. Once that gets
> > merged, I could do one patch series just to clean up REDIRECT after copy
> > up and do proper locking.
> >
> 
> I think we are confusing two different things in this discussion.
> Locking ovl_inode->lock for changing redirect is something that should
> stay in the patch set IMO and should be simplified by moving
> set redirect before taking rename locks on two inodes.
> 
> I was asking about removal of REDIRECT because this patch
> (ovl_verify_metacopy_data) is a bit tricky for me to review and
> I still don't feel confident about it.
> 
> My intuition says we could go other ways as well:
> - unite METACOPY/REDIRECT xattr (we can call the unite
> xattr REDIRECT and not METACOPY)
> - memory barriers between setting/clearing/checking
> METACOPY/REDIRECT (there is already a barrier for setting
> upperdata flag, so that's half the work already.
> 
> We can either have this discussion now or, as you suggested
> leave it to a following patch set. Rule of thumb - if this is v13
> with 28 patches, might not be a bad idea to deffer 2 patches
> and reduce complexity...
> 

Hi Amir,

Ok, let me drop removing REDIRECT from the patchset to reduce
complexity. Lets first try to get in a basic version in.

Now coming to the question of locking ovl_inode->lock. If REDIRECTS
are never removed and only upgraded (from relative to absolute), my
understanding is that current VFS locking is sufficient to prevent
races. Only rename and link path set redirects and both the paths take
inode locks and that means two set redirects can't make progress in
parallel on an inode.

When it comes to ovl_lookup(), we will set ovl_inode->redirect only for
the case of I_NEW. So no races should be there as well.

So far we had to add locking due to copy up path and now copy up path
will not touch redirect xattr. I probably will not even clear
ovl_inode->inode redirect as we are not removing REDIRECT.

Do you see any other path racing and still needed ovl_inode->lock?

Thanks
Vivek
