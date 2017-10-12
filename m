From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/9] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Thu, 12 Oct 2017 09:23:46 -0400
Message-ID: <20171012132346.GC3132@redhat.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-4-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxiU6BNrwKnfx1ToY4ZARV8X4S6HRNmfhCmaON=+46B7bg@mail.gmail.com>
 <20171011135715.GB8086@redhat.com>
 <CAOQ4uxg1OwbFuytiHLn3fwXzu3mZ8cwW6Vadj3YgTihbiL0BdA@mail.gmail.com>
 <20171011165348.GC8086@redhat.com>
 <CAOQ4uxiano2-_YBOgND9O+D3B8bbHK1fUvUwQWev9HGmCkFmjQ@mail.gmail.com>
 <20171011183416.GD8086@redhat.com>
 <CAOQ4uxgrzTpgu09ZdpHkVHbKA=aqHDk+yu9Qq6xXpxMbN4v0wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41338 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757388AbdJLNXs (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2017 09:23:48 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgrzTpgu09ZdpHkVHbKA=aqHDk+yu9Qq6xXpxMbN4v0wg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Wed, Oct 11, 2017 at 11:29:02PM +0300, Amir Goldstein wrote:
> On Wed, Oct 11, 2017 at 9:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Oct 11, 2017 at 08:36:03PM +0300, Amir Goldstein wrote:
> >> On Wed, Oct 11, 2017 at 7:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Wed, Oct 11, 2017 at 07:29:38PM +0300, Amir Goldstein wrote:
> >> >
> >> > [..]
> >> >> >
> >> >> > Anyway, I did not understand what's the problem with borken upper
> >> >> > hardlinks when index=off. If two upper hardlinks (broken), can
> >> >> > point to same ORIGIN on lower, they will just copy up same data.
> >> >> >
> >> >> > IOW, it does not seem to be more broken then what it is now just
> >> >> > becase of metadata copy up or because of both upper pointing to
> >> >> > same ORIGIN? What am I missing.
> >> >> >
> >> >> It is not broken now because we intentionally do NOT set origin when
> >> >> copying up lower hardlinks and index is disabled.
> >> >> You must not break this rule, so instead you can avoid metacopy for
> >> >> lower hardlinks when index is disabled.
> >> >
> >> > Hi Amir,
> >> >
> >> > Ok, I am open to change it so that if index=off, lower hardlinks are not
> >> > copied up metadata only.
> >> >
> >> > But please help me understand that what *additional* thing breaks if origin
> >> > is set when index=off.
> >> >
> >> > Say lower has a file foo.txt and another hard link foo-link.txt.
> >> > (say index=off, metacopy=off).
> >> >
> >> > Say, I open foo-link.txt for WRITE, and it gets copied up. Now there is
> >> > no link between foo-link.txt and foo.txt and if a user opens foo.txt for
> >> > READ, it does not see updates to foo-link.txt. So this is the broken
> >> > behavior of hardlinks with index=off, as of today.
> >> >
> >> > Now I go back to original state and this time do same operation with
> >> > (indxex=off, metacopy=on). Then "chown foo-link.txt" will only copy
> >> > metadata and set origin to lower file. Say I also chown "foo.txt", that
> >> > will do the same thing. Now both foo.txt and foo-link.txt will have
> >> > ORIGIN pointing to same lower inode. If any of the file is opened for
> >> > WRITE, data will be copied up from same origin.
> >> >
> >> > So setting same ORIGIN on two upper files, does not seem to break anything
> >> > additional, AFAICS. What am I missing.
> >> >
> >>
> >> Sorry for brevity of my response earlier. I was hopping on a plane.
> >> The problem is a bit convoluted to explain, but here goes.
> >>
> >> ORIGIN was introduced to implement constant st_ino across copy up.
> >> stat(2) of an overlay file with ORIGIN (both layer in same fs) returns
> >> st_ino of origin inode.
> >>
> >> When copy up breaks lower hardlink to *different* upper inodes,
> >> then those broken aliases MUST NOT return the same st_ino,
> >> because they are different files with different data.
> >
> > Hi Amir,
> >
> > I thought current code already takes care of this situation.
> >
> > ovl_getattr() {
> >           /*
> >             * Lower hardlinks may be broken on copy up to different
> >             * upper files, so we cannot use the lower origin st_ino
> >             * for those different files, even for the same fs case.
> >             * With inodes index enabled, it is safe to use st_ino
> >             * of an indexed hardlinked origin. The index validates
> >             * that the upper hardlink is not broken.
> >             */
> >            if (is_dir || lowerstat.nlink == 1 ||
> >                ovl_test_flag(OVL_INDEX, d_inode(dentry)))
> >                    stat->ino = lowerstat.ino;
> > }
> >
> > So if lower had nlink > 1, then its inode number will not be used if
> > indexing was not enabled. If that's the case, two upper pointing to
> > same origin should not be a problem?
> >
> > I even tested it. Wrote a patch to force setting origin even on hard
> > links with index=off.
> >
> > Before copy up, both the files (testfile.txt and link-file.txt) had
> > same inode numbers. The moment file is copied up it uses its real
> > inode number on upper (and not the one retrieved from lower). IOW,
> > origin inode number is discarded if index=off. If that's the case
> > then setting ORIGIN with broken hard link should be just fine. It
> > can still be used for metadata copyup while it can't be used with
> > index=off.
> >
> > In fact this sounds better to me. Make use of ORIGIN information only if
> > it is safe. With broken hardlinks it is not safe to make use of this
> > information so ignore ORIGIN. But it is still ok to make use of this
> > information from metadata copyup point of view.
> >
> 
> Yes, all this is true. I was trying to avoid the full explanation regrading
> index inconsistency, but I ended up giving an incomplete story.
> 
> >>
> >> Only when index is enabled and copy up does not break lower
> >> hardlink, it is legal to set ORIGIN for every upper alias, because
> >> all upper aliases can and should return same st_ino (the origin st_ino)
> >> from stat(2).
> >>
> >> So that is the simplest way to explain why you MUST NOT set ORIGIN
> >> on copy up of lower hardlink when index is disabled and therefore, you
> >> cannot use ORIGIN for metacopy.
> >>
> >> As I wrote in some email, you could set METAORIGIN xattr in this case
> >> just for the use of metacopy, but I rather not have this special case.
> >>
> >> Beyond the problem stated above with st_ino of broken hardlinks,
> >> if broken hardlinks have the same ORIGIN, this also breaks indexing
> >> assumptions and can lead to EIO on lookup, but no need to get into that.
> >
> > I guess you are referring to ovl_lookup_index().
> >
> >  () {
> >         index = lookup_one_len_unlocked(name.name, ofs->indexdir, name.len);
> >         if (d_is_negative(index)) {
> >                 if (upper && d_inode(origin)->i_nlink > 1) {
> >                         pr_warn_ratelimited("overlayfs: hard link with origin but no index (ino=%lu).\n",
> >                                             d_inode(origin)->i_ino);
> >                         goto fail;
> >                 }
> >
> >         }
> > }
> >
> > So this is failing if we find a dentry which has origin but no index. And
> > this will hit if a overlay was mounted with index=off, hard link copied up
> > and then remounted with index=on. In that case it will return -EIO.
> >
> > My question is, that does this have to be an error. If we are supporting
> > this use case, where index can be turned on later, then can we just warn
> > and continue? Or set OVL_XATTR_INDEX on upper to indicate that this
> > upper should have an index.
> >
> > I mean ORIGIN started with the exclusive purpose of inode number stability.
> > But this is sort of infrastructure which keeps track of ORIGIN of copy
> > up source and can be used for metadata copy up as well. So indexing should
> > not put restrictions on what files ORIGIN can be set on. Instead both
> > metacopy and index should not make use of ORIGIN where they this things
> > are broken for them.
> >
> > Thoughts?
> >
> 
> It is interesting to note that the commit that introduced this limitation
> fbaf94ee3cd5 ("ovl: don't set origin on broken lower hardlink")
> was merged as a "last minute" (rc7) fix patch before final v4.12
> and had this text in commit message:
> "We can relax this in the future when we are able to index upper object by
>     origin."
> 
> I am not sure it is easy to relax this limitation, but I may be wrong.
> I'll take another swing at writing the full story. Hope I will get it
> right this time...
> 
> Index is a 1-to-1 mapping from origin *inode* to upper *inode*.
> Highlighting *inode* because there may be many lower or upper
> aliases of that inode.
> 
> The index key (its name) is the file handle of origin inode.
> The index itself is an upper alias (link) of upper inode.
> 
> If more than 1 upper inode point to the same origin inode,
> then index cannot be consistent for both upper aliases.
> This would actually be a common scenario if hardlinks are broken
> due to index=off (or kernel v4.12 without the rc7 fix)
> and then index is turned on and more lower aliases are copied up.
> 
> On lookup, we can detected that index found by origin
> file handle is not a hardlink of upper inode and ignore it instead of
> returning EIO on:
>         if (upper && d_inode(upper) != inode) {
>                 pr_warn_ratelimited("overlayfs: wrong index found
> (index=%pd2, ino=%lu, upper ino=%lu).\n",
>                                     index, inode->i_ino, d_inode(upper)->i_ino);
>                 goto fail;
>         }
> 
> And we could have allowed for "hard link with origin but no index"
> instead of returning EIO.
> 
> In those cases, we would need to get a hashed overlay inode by address
> of upper inode, instead of by address of origin inode and we would have to
> not set the OVL_INDEX flag on lookup.
> 
> I guess one of the reasons we did not do it on first version of index feature
> is that we wanted to keep things simple and we did not have a good enough
> reason to set ORIGIN for broken hardlinks.
> 
> So I am now open to the possibility that we may be able to set ORIGIN
> for broken hardlinks without breaking anything, but will need to see patches
> before I can say if we missed something. Maybe Miklos can see something
> that I have missed.
> 
> In any case, for the sake of simplicity, I wouldn't bother doing metacopy up
> of lower hardlinks in first version of metacopy feature.

Ok, I can see that current code will return -EIO if index is enabled after
some copy up have taken place with index=off. So for now, I will disable
metadata copyup on hardlinks if index=off. 

But it would be nice if we can move away from this restriction.

> 
> Thanks for insisting on a good answer (not sure I have provided one yet)

I think I understand it now. Thank you.

Vivek
