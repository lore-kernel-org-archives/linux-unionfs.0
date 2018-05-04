Return-Path: <vgoyal@redhat.com>
Date: Fri, 4 May 2018 11:54:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Message-ID: <20180504155427.GA2713@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
 <20180426191013.13219-10-vgoyal@redhat.com>
 <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com>
 <20180430140243.GB7960@redhat.com>
 <CAOQ4uximhvDrOn6s-5X-BeGvfG0RtTBU-WA6fEjfyYEkn4jvNw@mail.gmail.com>
 <CAOQ4uxg5zDffN8VneWQCTd4N+trCCx0v7=paL9_hdMZj5CidYA@mail.gmail.com>
 <20180503151220.GB10792@redhat.com>
 <CAOQ4uxj5G33vzQabE7hVfyF9v5YT0XxjxK6u5_Vo-g2e_vgO_A@mail.gmail.com>
 <CAOQ4uxjgymQDswFOQkLOgRXtoZFw77V3ycWy4Uvjrrs5KAQ0rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjgymQDswFOQkLOgRXtoZFw77V3ycWy4Uvjrrs5KAQ0rw@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 04, 2018 at 10:04:22AM +0300, Amir Goldstein wrote:
> On Thu, May 3, 2018 at 11:07 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Thu, May 3, 2018 at 6:12 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> On Tue, May 01, 2018 at 05:37:09PM +0300, Amir Goldstein wrote:
> [...]
> 
> >>>
> >>> w.r.t METACOPY things will get complicated if we remove
> >>> METACOPY xattr and the upper does not have ORIGIN.
> >>
> >> I am not able to understand the problem you are referring to.
> >>
> >>> In that case we may have an inode that is already hashed by lower,
> >>> but for a new lookup that does not see METACOPY xattr it
> >>> looks up the inode in cache by upper and this is not good.
> >>
> >> Here is my understanding. Following happens without metacopy feature.
> >>
> >> - As of now, only time we do not create ORIGIN on upper is for the
> >>   case of broken hardlink. (for a non-dir file).
> >>
> >> - In case of broken hard link (index=off), if file is on lower only, we
> >>   do not put new inode in inode cache at all. Once file gets copied up,
> >>   we hash it by upper inode. And reported inode number changes over
> >>   copy up.
> >>
> >> Now above behavior should remain same even with metacopy=on. For the
> >> case of broken hard link.
> >>
> >> - If file is on lower only, we will not put inode in cache. And once
> >>   file gets copied up metadata only, we will hash it with upper inode.
> >>
> >>   The only difference here is that without metacopy non-dir file will
> >>   have lowerdentry=NULL while with metacopy on, lowerdentry will be
> >>   non-null. But bylower should still be false because of following
> >>   check in ovl_hash_bylower().
> >>
> >>   /* No, if lower hardlink is or will be broken on copy up */
> >>    if ((upper || !ovl_indexdir(sb)) &&
> >>             !d_is_dir(lower) && d_inode(lower)->i_nlink > 1)
> >>                 return false;
> >>
> >> And if bylower is false, we hash inode using upper inode as key.
> >>
> >>                 struct inode *key = d_inode(bylower ? lowerdentry :
> >>                                                       upperdentry);
> >>
> >> IOW, despite the fact lowerdentry is there (without ORIGIN on upper),
> >> we don't use that lowerdentry for inode hashing. And hence behavior
> >> should not change.
> >>
> >> What am I missing?
> >>
> >
> > Just maybe missing the case of nlink=1 and ORIGIN cannot be
> > followed because lower fs doesn't support file handles.
> > I just wanted to make sure this case is handled correctly.
> >
> 
> OK. re-read the code and ready to explain the situation.
> 
> The meaning of new OVL_CONST_INO flag is:
> "inode preserves st_ino across copy up".
> If lower fs support file handles it also means:
> "...and across eviction from inode cache".
> but if lower fs does not support file handles it means:
> "...while non-dir inode remains in cache"
> 
> How does METACOPY change the situation?
> very slightly - with METACOPY, instead of st_ino change
> after copy_up+cache_evict, st_ino will not change after
> meta_copy_up+cache_evict, but will change after
> data_copy_up+cache_evict, which is not a problem as
> far as I can tell.
> 
> Specifically, removing METACOPY xattr will not change
> st_ino nor hash_by_lower until after cache eviction and as
> long as we have one-to-one mapping of upper inode to
> lower inode that's good enough.

Hi Amir,

Thanks for detailed explanation. I now understand your concern.

How about I pass in the origin information in ovl_get_inode() and
to ovl_hash_bylower(). And we set bylower=1 for a metacopy dentry
only if an upper origin could be found and verified? 

That way behavior will be similar to a file with nlink=1 and ORIGIN
not there. And we will not have to worry about thinking another
special corner case and writing test cases for it.

Too many corner cases are bad for future code maintenance and easy
to break.

WDYT?

Thanks
Vivek
> 
> Things will only break with filesystem inconsistencies
> like in xfstest overlay/049, but AFAICT, METACOPY does
> not introduce any real regressions, the only thing it does
> is add another way of creating an inconsistency with
> redirect on non-dir, which probably calls for a new xfstest.
> 
> I hope I got it all right.
> 
> Thanks,
> Amir.
