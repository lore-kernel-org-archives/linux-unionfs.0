Return-Path: <vgoyal@redhat.com>
Date: Thu, 3 May 2018 10:33:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Message-ID: <20180503143359.GA10792@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
 <20180426191013.13219-10-vgoyal@redhat.com>
 <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com>
 <20180430140243.GB7960@redhat.com>
 <CAOQ4uximhvDrOn6s-5X-BeGvfG0RtTBU-WA6fEjfyYEkn4jvNw@mail.gmail.com>
 <20180502190957.GB2800@redhat.com>
 <20180502194042.GC2800@redhat.com>
 <CAOQ4uxhOBS_7QWy6Spz0gd3B+bCm7vAh7tfiRBC9hqOaWBENmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhOBS_7QWy6Spz0gd3B+bCm7vAh7tfiRBC9hqOaWBENmQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 02, 2018 at 10:57:16PM +0300, Amir Goldstein wrote:
> On Wed, May 2, 2018 at 10:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, May 02, 2018 at 03:09:57PM -0400, Vivek Goyal wrote:
> >> On Mon, Apr 30, 2018 at 09:08:01PM +0300, Amir Goldstein wrote:
> >> [..]
> >> > >> > @@ -836,6 +836,15 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
> >> > >> >         if (index)
> >> > >> >                 ovl_set_flag(OVL_INDEX, inode);
> >> > >> >
> >> > >> > +       if (upperdentry) {
> >> > >> > +               err = ovl_check_metacopy_xattr(upperdentry);
> >> > >> > +               if (err < 0)
> >> > >> > +                       goto out_err;
> >> > >> > +               metacopy = err;
> >> > >> > +               if (!metacopy)
> >> > >> > +                       ovl_set_flag(OVL_UPPERDATA, inode);
> >> > >> > +       }
> >> > >> > +
> >> > >>
> >> > >> There is no reason to ovl_check_metacopy_xattr again here, right?
> >> > >
> >> > > I think we need to check metacopy here otherwise it becomes racy. For
> >> > > example, what if there is a hard link (say, l1 and l2) with metacopy xattr.
> >> > > ovl_lookup(l1) will think metacopy is on while another thread on another
> >> > > cpu might have trigged copy up, remove metacopy xattr. And it is possible
> >> > > that inode got flushed out of cache. So by the time ovl_lookup(l1), calls
> >> > > iget5_locked(), it will get a new inode and it will initialize inode
> >> > > with wrong information.
> >> > >
> >> > > I had done similar thing for REDIRECT, but once we removed logic to
> >> > > remove REDIRECT on copy up, I felt I did not have to check redirect
> >> > > again here.
> >> > >
> >> > > In general, I feel that once we have the inode lock, we should check
> >> > > metacopy and redirect both and then initialize inode. And not rely
> >> > > on information which was checked outside the lock and might have
> >> > > been stale by now.
> >> > >
> >> >
> >> > Hmmm... so as you once already said, we have a race with INDEX as well.
> >>
> >> I am not sure about INDEX race. I remember talking about INDEX flag race
> >> in ovl_inode but w.r.t ovl_get_inode(), what's the race you are seeing
> >> with index. Once ovl_lookup() has found index, can that index go away by
> >> the time ovl_get_inode() is called? If not, then there should not be
> >> any race.
> >
> > May be you are referring to race when ovl_lookup() looks for index
> > its not there (all lower), and then thread gets blocked, other cpu
> > triggers a copy up and creates index, flushs ovl_inode and now first
> > thread continues and does ovl_get_inode() and does not set OVL_INDEX
> > flag (Despite the fact there is index)?
> >
> 
> Yes, that's what I figured when you described the potential METACOPY race.

Ok. I think these races have been around for quite some time. I would 
like to address it separately and not as part of this patch series.

> 
> Besides that I am still worried about corners we missed in setup of
> metacopy=on,index=off.
> 
> I may be confused about whether lower with nlink=1 with index=off
> after metacopy up uses upper st_ino and hashed by upper inode?
> Need to understand whether the "hashed by" state is consistent with
> metacopy=on,index=off in all cases.

metacopy=on, index=off should not change inode number reporting. For
the case of nlink=1 and index=off, st_ino of lower is reported and
metacopy=on/off does not matter at all. Similarly, ovl_hash_bylower()
remains untouched due to metacopy. So for the case of nlink=1, index=off,
inode should still be hashed using lower inode number.

Only thing metacopy feature changes in stat() is st_blocks. It should
not impact st_ino or st_dev reporting at all.

Thanks
Vivek
