From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 06/23] ovl: add support for "verify" feature
Date: Fri, 5 Jan 2018 14:07:29 -0500
Message-ID: <20180105190729.GH29480@redhat.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-7-git-send-email-amir73il@gmail.com>
 <20180105154323.GC29480@redhat.com>
 <CAOQ4uxg35sutZZUCKQxoiuNVfLXxe44wavX95bC_GMntbLn-QQ@mail.gmail.com>
 <20180105163951.GF29480@redhat.com>
 <CAOQ4uxi_F5Zpd_NZuJU2MCKP73jCVfKJWb9GQ6TNkSWxbcEBWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752117AbeAETHa (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 14:07:30 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi_F5Zpd_NZuJU2MCKP73jCVfKJWb9GQ6TNkSWxbcEBWg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 05, 2018 at 07:07:47PM +0200, Amir Goldstein wrote:
> On Fri, Jan 5, 2018 at 6:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Jan 05, 2018 at 05:47:36PM +0200, Amir Goldstein wrote:
> >> On Fri, Jan 5, 2018 at 5:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> > On Thu, Jan 04, 2018 at 06:40:01PM +0200, Amir Goldstein wrote:
> >> >> Introduce the "verify" config, module and mount options.
> >> >>
> >> >> If the "verify" feature is enabled then overlay filesystems will use
> >> >> the inodes index dir to verify layers consistency.
> >> >>
> >> >> It is possible to enable consistency verification by default during
> >> >> build time with the OVERLAY_FS_VERIFY config option, during runtime
> >> >> with the "verify=on" module option or on a filesystem instance basis
> >> >> with the "verify=on" mount option.
> >> >>
> >> >> The "verify" feature will prevent multiple redirects to the same lower
> >> >> dir and will prevent broken hardlinks from using the same inode number.
> >> >
> >> > So how does one end up with multiple redirects to same lower dir.
> >> >
> >> > Also what's the issue with broken hardlinks using same inode number. You
> >> > mean lower and upper are on different fs and upper can use same inode
> >> > number? With index=on, broken hardlink issue is taken care of so. So
> >> > why would somebody use verify=on, which looks like will create index
> >> > for all kind of files/dir.
> >> >
> >> > I have not followed this development and there is not much background
> >> > in patch descrition or header patch, so asking all these basic questions.
> >> >
> >>
> >> I have a ready answer for you :)
> >> This is how it can happen and this is what can go wrong:
> >> https://github.com/amir73il/xfstests/commit/f3c18125539660329195f142973ea620d6899418
> >>
> >> The test duplicates a redirect dir offline with cp -a, but the
> >> same thing can be done with a dir with origin.
> >> In both cases, 'diff' will wrongly report that the files/dir are the same
> >> even though they may differ (after being copied).
> >
> > So there are so many things a user can do with overlayfs offline. Should
> 
> Like what things for example?

I am referring to all the offline modifications user can do to lower
and upper. Remove some overlay xattrs we maintain, or add some or play
with link counts on lower. It could be anything.

> I admit the test case is a gray area, which is why I asked Eryu to hold
> back on merging the test until Miklos weights in his opinion.
> But I argued before that the offline changes done by the test could in fact
> be made by an innocent user.
> For example, by unpacking an upper image tarball over an existing
> upper layer offline.

What is "upper image tarabll"? You mean a tarball of a directory which
is being used as upper somewhere else. If somebody does that and adds
contents to upper dir, then we will have unpredictable consequences.
My understanding is that we are not supposed to write to lower or upper
dir once overlay has been created.

> Before redirect_dir, this might have worked fine.
> After redirect_dir, this could result in multiple redirect if any of the upper
> dirs were renamed.
> 
> 
> > we need to put runtime checks for all these cases. I mean will
> > fsck.overlay be a better place to catch these kind of anomalies.
> >
> 
> I will answer the same thing I answered to Zhangyi.
> My opinion is that like ext4/xfs/etc, the jurisdiction of the file
> system is to detect
> inconsistencies at runtime as much as possible and return an error to user and
> suggest the user to run fsck to fix the problem.

Sounds reasonable. So with every inconsistency check, did they introduce
new mount option to let user opt-in. Looks like that's what we will have
to do if we decide to not break backward comatibility.

> And short of naming fsck.overlay, this is exactly what verify=on does.
> If it detects a multiple redirect or redirect without whiteout covering
> origin, it errors on lookup and prints a message to log.
> 
> > Secondly, verify=foo feels like a very generic option. Its not clear
> > what all will it verify and will we continue to pile up more checks
> > down the line under it.
> >
> > As a user, when should one use verify=on? Its not clear to me.
> >
> 
> Those are good questions to address to Miklos.
> In V1, the mount option was called 'index=all' for indexing every file/dir
> on copy up and the verify origin functionality was implemented with
> a different option (verify_dir).
> Then I realized that full indexing could actually be a feature on its own,
> so I named this feature and documented what it does in Kconfig.

index=all was much more intuitive to me. I could understand that it will
create index for all kind of objects (and not just hardlinks).

> 
> Another option name I was contemplating is 'redirect_dir=verify'
> this name makes a lot more sense for the part of detecting multiple
> redirects.

Or verify_redirect_dir=on/off. Advantage of fine grained options is
that user can opt-in. But at the same time too many options will be
confusing. 

> The reason I went for the more generic name 'verify=on' is because the
> feature also detects multiple files with same origin (which are not hardlinks).

So one problem with verify=on is that say it checks for 3 inconsistencies
today. What will happen when we check for 4th inconsistency tomorrow. Say
we want to enforce ORIGIN validity on non-dir objects. If we combine it
with verify=on, then it becomes a backward copatibility issue. If we
come up with a separate option, then we kind of split it badly. That is
non-dir origin verification has separate mount option while dir origin
verification is part of verify=on.

Atleast a normal user will find it very hard to figure it out.

> I have no strong feelings about the verify=on feature name.

I don't have strong feelings either. I am just trying to think from a
user's point of view and also thinking what will happen when more
inconsistency checks are added in future. Will these be part of verify=on
or we will create new options due to backward compatibility concerns.

Vivek

> BTW, I also have a follow up work, related to snapshots that uses the
> mount option 'redirect_dir=origin', which means, if lower does not match
> origin, try to decode origin from file handle and fix redirect.
> So personally, I am quite fond of replacing 'verify=on' with
> 'redirect_dir=verify' even though it also affects non-dir.
> 
> Thanks for your inputs!
> 
> Amir.
