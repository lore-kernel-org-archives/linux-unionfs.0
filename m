Return-Path: <vgoyal@redhat.com>
Date: Thu, 3 May 2018 11:12:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Message-ID: <20180503151220.GB10792@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
 <20180426191013.13219-10-vgoyal@redhat.com>
 <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com>
 <20180430140243.GB7960@redhat.com>
 <CAOQ4uximhvDrOn6s-5X-BeGvfG0RtTBU-WA6fEjfyYEkn4jvNw@mail.gmail.com>
 <CAOQ4uxg5zDffN8VneWQCTd4N+trCCx0v7=paL9_hdMZj5CidYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg5zDffN8VneWQCTd4N+trCCx0v7=paL9_hdMZj5CidYA@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 01, 2018 at 05:37:09PM +0300, Amir Goldstein wrote:
> On Mon, Apr 30, 2018 at 9:08 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Mon, Apr 30, 2018 at 5:02 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> [...]
> >>
> >> I think we need to check metacopy here otherwise it becomes racy. For
> >> example, what if there is a hard link (say, l1 and l2) with metacopy xattr.
> >> ovl_lookup(l1) will think metacopy is on while another thread on another
> >> cpu might have trigged copy up, remove metacopy xattr. And it is possible
> >> that inode got flushed out of cache. So by the time ovl_lookup(l1), calls
> >> iget5_locked(), it will get a new inode and it will initialize inode
> >> with wrong information.
> >>
> >> I had done similar thing for REDIRECT, but once we removed logic to
> >> remove REDIRECT on copy up, I felt I did not have to check redirect
> >> again here.
> >>
> >> In general, I feel that once we have the inode lock, we should check
> >> metacopy and redirect both and then initialize inode. And not rely
> >> on information which was checked outside the lock and might have
> >> been stale by now.
> >>
> >
> > Hmmm... so as you once already said, we have a race with INDEX as well.
> > In general, I feel it would be better to do a minimal sanity check inside
> > inode lock for INDEX and METACOPY (maybe REDIRECT) and make
> > sure they are consistent with the info in ovl_inode_info.
> > If they are not, return -ESTALE and that may result in re-calling
> > lookup.
> >
> 
> After thinking about it some more, I believe the way we should do it
> is implement ovl_iget_locked() and call it from ovl_lookup() *before*
> we lookup index.
> 
> Then, *after* looking up index,
> If this turns out to be a broken hardlink, we throw away the
> inode that we got by lower and get a new inode hashed by upper.
> 
> Then we can initialize the inode with another helper
> or directly in ovl_lookup() and unlock_new_inode().
> 
> w.r.t METACOPY things will get complicated if we remove
> METACOPY xattr and the upper does not have ORIGIN.

I am not able to understand the problem you are referring to.

> In that case we may have an inode that is already hashed by lower,
> but for a new lookup that does not see METACOPY xattr it
> looks up the inode in cache by upper and this is not good.

Here is my understanding. Following happens without metacopy feature.

- As of now, only time we do not create ORIGIN on upper is for the
  case of broken hardlink. (for a non-dir file).

- In case of broken hard link (index=off), if file is on lower only, we
  do not put new inode in inode cache at all. Once file gets copied up,
  we hash it by upper inode. And reported inode number changes over
  copy up.

Now above behavior should remain same even with metacopy=on. For the
case of broken hard link.

- If file is on lower only, we will not put inode in cache. And once
  file gets copied up metadata only, we will hash it with upper inode.
  
  The only difference here is that without metacopy non-dir file will
  have lowerdentry=NULL while with metacopy on, lowerdentry will be
  non-null. But bylower should still be false because of following
  check in ovl_hash_bylower().

  /* No, if lower hardlink is or will be broken on copy up */
   if ((upper || !ovl_indexdir(sb)) &&
            !d_is_dir(lower) && d_inode(lower)->i_nlink > 1)
                return false;

And if bylower is false, we hash inode using upper inode as key.

                struct inode *key = d_inode(bylower ? lowerdentry :
                                                      upperdentry);

IOW, despite the fact lowerdentry is there (without ORIGIN on upper),
we don't use that lowerdentry for inode hashing. And hence behavior
should not change.

What am I missing?

Thanks
Vivek

> 
> There is one solution that you will surely not like -
> instead of removing METACOPY xattr set METACOPY=n.
> That means we still need to lookup lower layers for origin inode,
> but we do set UPPERDATA flag.
> 
> There may be other solutions to the problem, but I cannot think
> of any right now.
> 
> Thanks,
> Amir.
