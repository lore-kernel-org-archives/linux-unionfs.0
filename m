From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 01/18] overlay: implement fsck utility
Date: Thu, 14 Dec 2017 10:21:28 -0500
Message-ID: <20171214152128.GA5245@redhat.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
 <20171214064747.20999-2-yi.zhang@huawei.com>
 <CAJfpegvCDyD3Zmc-h5hzkYRGC-cAn4myub3fwvqEVhRNse=yaw@mail.gmail.com>
 <CAOQ4uxh-4kKPLHDXHJux2_tM35frxxNWmPEZcDu2EQ2n+yYkKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh-4kKPLHDXHJux2_tM35frxxNWmPEZcDu2EQ2n+yYkKA@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "zhangyi (F)" <yi.zhang@huawei.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Miao Xie <miaoxie@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Dec 14, 2017 at 04:33:21PM +0200, Amir Goldstein wrote:
> On Thu, Dec 14, 2017 at 4:13 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Thu, Dec 14, 2017 at 7:47 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> >> fsck.overlay
> >> ============
> >>
> >> fsck.overlay is used to check and optionally repair underlying
> >> directories of overlay-filesystem.
> >
> > Thanks for working on this.
> >
> >
> >>
> >> Check the following points:
> >>
> >> Whiteouts
> >> ---------
> >>
> >> A whiteout is a character device with 0/0 device number. It is used to
> >> record the removed files or directories, When a whiteout is found in a
> >> directory, there should be at least one directory or file with the same
> >> name in any of the corresponding lower layers. If not exist, the whiteout
> >> will be treated as orphan whiteout and remove.
> >
> > Okay.
> >
> >>
> >> Opaque directories
> >> ------------------
> >>
> >> An opaque directory is a directory with "trusted.overlay.opaque" xattr
> >> valued "y". There are two legal situations of making opaque directory: 1)
> >> create directory over whiteout 2) creat directory in merged directory. If an
> >> opaque directory is found, corresponding matching name in lower layers might
> >> exist or parent directory might merged, If not, the opaque xattr will be
> >> treated as invalid and remove.
> >
> > Current version of overlay fs doesn't bother with removing opaque
> > attribute.  So not sure fsck.overlay should care.  Or at least is
> > should be an optional thing and not worth warning about, since it's
> > perfectly normal.
> >
> >
> >>
> >> Redirect directories
> >> --------------------
> >>
> >> An redirect directory is a directory with "trusted.overlay.redirect"
> >> xattr valued to the path of the original location from the root of the
> >> overlay. It is only used when renaming a directory and "redirect dir"
> >> feature is enabled. If an redirect directory is found, the following
> >> must be met:
> >>
> >> 1) The directory store in redirect xattr should exist in one of lower
> >> layers.
> >
> > Okay.
> >
> >> 2) The origin directory should be redirected only once in one layer,
> >> which mean there is only one redirect xattr point to this origin directory in
> >> the specified layer.
> >> 3) A whiteout or an opaque directory with the same name to origin should
> >> exist in the same directory as the redirect directory.
> >>
> >> If not, 1) The redirect xattr is invalid and need to remove 2) One of
> >> the redirect xattr is redundant but not sure which one is, ask user 3)
> >> Create a whiteout device or set opaque xattr to an existing directory if the
> >> parent directory was meregd or remove xattr if not.
> >
> > Hmm, in this case also should ask the user, as it's not clear that the
> > "new" copy resulting from removal of whiteout on upper is the wanted
> > one or the "old" renamed copy.
> >
> >
> >>
> >> Usage
> >> =====
> >>
> >> 1. Ensure overlay filesystem is not mounted based on directories which
> >> need to check.
> >>
> >> 2. Run fsck.overlay program:
> >>    Usage:
> >>    fsck.overlay [-l lowerdir] [-u upperdir] [-w workdir] [-avhV]
> >>
> >>    Options:
> >>    -l, --lowerdir=LOWERDIR   specify lower directories of overlayfs,
> >>                              multiple lower use ':' as separator.
> >>    -u, --upperdir=UPPERDIR   specify upper directory of overlayfs
> >>    -w, --workdir=WORKDIR     specify work directory of overlayfs
> >
> > Not sure what other fsck do, but I'd feel more logical to have the
> > same -olowerdir=..., etc. notation as for mount.
> >
> 
> Other fsck do not have this problem.
> They only need blockdev as input.
> Which leads me to an idea I have been wondering about for the overlayfs
> utilities - a specification file, e.g.:
> 
> # create dirs and write their path to a spec file:
> mkfs.overlay -ometacopy=on,lowerdir=... myovl.spec
> # mount overlay using mount.overlay helper:
> mount -t overlay myovl.spec /ovl
> # fsck with just one configuration that is consistent with mkfs and mount:
> fsck.overlay -n myovl.spec
> 
> The specification file can also determine the backward incompatible
> features of the overlay, for example, if user sets -metacopy=on during mkfs
> mount.overlay helper will refuse to mount with kernel that does not
> support metacopy. The reason we CAN do that with spec file is because spec
> file determines that overlay was born with metacopy feature enabled.
> It is not the same an overlay that was once mounted with metacopy=on and
> then we don't allow it to mount with an old kernel.

So why not store this information in an xattr on upper/ (instead of spec
file) and then overlay specific helpers could parse it do same thing. I
mean otherwise user space has to worry about storing and finding out
right foo.ovl.spec file for any mount/unmount or other operations. From
a user's perspective, I would be glad if I don't have to worry about
managing another spec file per overlay mount.

This will only work if kernel is old but tools are still new. Not sure
how many a times people run with this configuraiotion.

Thanks
Vivek

> 
> This method could delegate the entire feature compatibility to userspace
> mount helper.
> 
> Another nice thing about mount.overlay helper is that it could abstarct
> away the move from mount() to mount2() when the time comes and then
> users can keep using existing tools but won't have the existing limit on
> number of lowerdirs.
> 
> Thoughts?
> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
