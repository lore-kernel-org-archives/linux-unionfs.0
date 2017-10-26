From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 07/13] ovl: A new xattr OVL_XATTR_METACOPY for file on
 upper
Date: Thu, 26 Oct 2017 10:34:22 -0400
Message-ID: <20171026143422.GA6704@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <1508958575-14086-8-git-send-email-vgoyal@redhat.com>
 <CAOQ4uxjPvaUN_OK2dB0zZT1pru38vSTgPrZr3YihWgoUr4d=qw@mail.gmail.com>
 <20171026135323.GD28005@redhat.com>
 <CAOQ4uxhHeesWGGaQWTue+uEnOdM9U34dGvtbStwOHT5AiZbVWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932234AbdJZOeW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 10:34:22 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhHeesWGGaQWTue+uEnOdM9U34dGvtbStwOHT5AiZbVWg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 26, 2017 at 05:14:57PM +0300, Amir Goldstein wrote:
> On Thu, Oct 26, 2017 at 4:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Oct 26, 2017 at 09:04:17AM +0300, Amir Goldstein wrote:
> >> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > Now we will have the capability to have upper inodes which might be only
> >> > metadata copy up and data is still on lower inode. So add a new xattr
> >> > OVL_XATTR_METACOPY to distinguish between two cases.
> >> >
> >> > Presence of OVL_XATTR_METACOPY reflects that file has been copied up metadata
> >> > only and and data will be copied up later from lower origin.
> >> > So this xattr is set when a metadata copy takes place and cleared when
> >> > data copy takes place.
> >> >
> >> > We also use a bit in ovl_inode->flags to cache OVL_UPPERDATA which reflects
> >> > whether ovl inode has data or not (as opposed to metadata only copy up).
> >> >
> >> > Note, OVL_UPPERDATA is set only on those upper inodes which can possibly
> >> > be metacopy only inodes. For example, inode should be a regular file and
> >> > there needs to be a lower dentry.
> >>
> >> Why? is it not simpler and better for readability to set it in all
> >> cases except metacopy?
> >
> > I think it was re-introducing ordering requirement w.r.t oi->__upperdentry
> > and that's why I avoided it doing for all type of files.
> >
> > For example, in file/dir creation path when a new dentry is created, we
> > need to make sure OVL_UPPERDATA is visible on other cpus before
> > oi->__upperdentry is visible. Otherwise other cpus might try to copy up this
> > file for which there might not be any lower and all the bad things can happen.
> >
> > For example,
> >
> >           CPU1                                  CPU2
> >    ovl_instantiate() {                     ovl_d_real() {
> >      ovl_dentry_set_upper_alias()           ovl_open_maybe_copy_up()
> >      set OVL_UPPERDATA                       ovl_dentry_needs_data_copy_up
> >      smp_wmb();                               test OVL_UPPERDATA
> >      oi->__upperdentry = upperdentry
> >    }
> >
> > So if cpu1 is creating a new file and cpu2 does ovl_d_real() and it sees
> > upper dentry but not OVL_UPPERDATA, it will try to copy up file (which
> > might not be on lower at all).
> >
> > Similarly, in ovl_d_real() we check OVL_UPPERDATA one more time and if
> > its not set, we return lower dentry instead of upper. It can race there
> > as well and try to return a lower which does not exist (for a newly
> > created file).
> >
> > So, IIUC, this was bringing back ordering requirement and hence I limited
> > this flag.
> >
> 
> Fine. but use ovl_should_check_upperdata() in read path (CPU2) anyway
> so there is little point in checking whether or not you need to set the flag.
> Better just set it unconditionally on copy up (!metacopy) and on
> ovl_instantiate().

Ok. Why not keep it symmetric in WRITE and READ paths. That way it is
easier to read and understand code. Making it asymmetric will only
increase confusion. If we are never going to check a flag, why to 
set it to begin with.

Anyway, I don't have strong opinion about it. If you like this better,
I am fine.

> 
> > BTW, how did oi->has_upper handle this requirement. IIUC, that can run
> > into same issue. It is possible that CPU2 does not see ->has_upper for
> > newly created file while it has oi->__upperdentry. That means it can
> > try to copy up a non-existent file as well.
> 
> I think you are referring to the "false negative" case in Miklos's comment
> in ovl_copy_up_flags(). This is the simplest case because both __upperdentry
> and has_alias are checked again under oi->lock in ovl_copy_up_one().

But before we take lock, we start doing operations on lower and you might
get null pointer dereference. (there will not be any lower for an upper
only file).

ovl_copy_up_one() {
	ovl_path_lower(dentry, &ctx.lowerpath);
	err = vfs_getattr(&ctx.lowerpath, &ctx.stat,
                          STATX_BASIC_STATS, AT_STATX_SYNC_AS_STAT);
	ovl_do_check_copy_up(ctx.lowerpath.dentry);
	ovl_copy_up_start();    <--- Now we take lock. 
}

[..]
> >> > +bool ovl_dentry_check_upperdata(struct dentry *dentry) {
> >>
> >> Not a good helper name IMO. it reads to me "check if upperdata is set"
> >> and it should read "should I check upperdata flag"
> >
> > How about ovl_should_check_upperdata() instead.
> >
> 
> OK. and make sure to add if (ofs->config.metacopy)

Hmm... I am not sure about checking for ofs->config.metacopy. The way
this feature is designed right now, is that if metacopy=off, then any
new copyup will not happen metacopy only. But if there are existing
metacopy only files, then these will still be data copied up.

So say somebody mounts with metacopy=on and bunch of files are copied up
metadata only. Now overlay is remounted with metacopy=off, then this will
continue to work. No new copy ups will be metadata only but existing
metadata only copied up files will continue to work.

That means, even if metacopy=off, I need to check for UPPERDATA flag
properly and trigger a data copy up if need be.

Thanks
Vivek
