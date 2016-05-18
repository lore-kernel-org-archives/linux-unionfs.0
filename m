From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/1] ovl: setxattr: avoid deadlock when setting IMA
 xattr.
Date: Wed, 18 May 2016 18:45:00 -0400
Message-ID: <1463611500.2465.22.camel@linux.vnet.ibm.com>
References: <1463338367.14611.40.camel@linux.vnet.ibm.com>
	 <1463342855-27091-1-git-send-email-kli@iki.fi>
	 <201605161420.u4GEKLHk009316@d03av05.boulder.ibm.com>
	 <CAH4bDXi+Cb9XsU9eF5pLOLG9EGZ2W9C6BGWQKQTMwuXd_YuyDA@mail.gmail.com>
	 <CAH4bDXi+WoTS3bKWct6y2Y0A23TP+hNvDCM9JJ=iPJ+=s1J7bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36312 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbcERWp5 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 18 May 2016 18:45:57 -0400
Received: from localhost
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-unionfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Thu, 19 May 2016 08:45:54 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 170D63578053
	for <linux-unionfs@vger.kernel.org>; Thu, 19 May 2016 08:45:51 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4IMjgUa60358748
	for <linux-unionfs@vger.kernel.org>; Thu, 19 May 2016 08:45:50 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4IMjI24012591
	for <linux-unionfs@vger.kernel.org>; Thu, 19 May 2016 08:45:18 +1000
In-Reply-To: <CAH4bDXi+WoTS3bKWct6y2Y0A23TP+hNvDCM9JJ=iPJ+=s1J7bw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Krisztian Litkey <kli@iki.fi>
Cc: Mimi Zohar <zohar@us.ibm.com>, linux-unionfs@vger.kernel.org

On Mon, 2016-05-16 at 23:22 +0300, Krisztian Litkey wrote:
> On Mon, May 16, 2016 at 6:13 PM, Krisztian Litkey <kli@iki.fi> wrote:
> > On Mon, May 16, 2016 at 5:20 PM, Mimi Zohar <zohar@us.ibm.com> wrote:
> >> Krisztian Litkey wrote on 05/15/2016 04:07:35 PM:
> >>
> >>> If we're writing the extended attribute used by IMA, don't
> >>> try to lock sb_writers (mnt_want_write) or i_mutex. We're
> >>> being called from ima_file_free and the necessary locks
> >>> are already being held. Trying to lock them again will
> >>> deadlock.
> >>
> >> Thinking about this some more, security.ima can be written here in
> >> ima_file_free, but it also can be written by userspace.  The former updates
> >> the file hash, while the latter is used to write the file signature.
> >>
> >>> In practice we test if the real inode has the S_IMA flag
> >>> set and if the xattr being set is the IMA attribute. If
> >>> both are true, we call __vfs_setxattr_noperm instead of
> >>> the usual vfs_setxattr we call for all other cases.
> >>>
> >>> Signed-off-by: Krisztian Litkey <kli@iki.fi>
> >>
> >> Writing the file signature from userspace should call the normal
> >> vfs_setxattr().
> >
> > Yes. If there was a reliable way to detect that we're being called
> > as an end result of ima_fix_attr we should check for that and branch
> > accordingly. Based on your original suggestion I was under the
> > impression that testing S_IMA would have been the right check.
> > Now based on your recent comment, and checking the code, I see
> > that it will be set for all inodes that are associated with an iint cache
> > entry...
> >
> > Unless we add a dedicated *vfs_setxattr* flag just for this and pass it
> > from ima_fix_xattr (so that it'd propagate back to ovl_setxattr where
> > we test and branch accordingly), I see no easy way to check for the
> > necessary precondition. And adding a dedicated flag would probably
> > be considered a horrible kludge... so I think I need to dig deeper and
> > see if I can come up with another way of fixing this.

Another option, as the i_mutex lock is only taken for security.ima when
called from ima_file_free (__fput), would be to check if i_mutex is
already locked (mutex_is_locked).  If all three - IS_IMA, security.ima
and i_mutex taken -  call __vfs_setxattr_noperm().  Not a great
solution, but it is a solution.

> > I have taken a small peek at other architecturally not quite unlike FS
> > implementations. Encryptfs seems to be one of the closest ones. I
> > will test if their approach works together with IMA and if it does I'll try
> > to roll a similar implementation for overlayfs. Does that sound
> > reasonable to you ?
> 
> Hmm... after having taken a closer look at ecryptfs, I think its setxattr
> is not comparable to overlayfs. The former is much simpler because
> it simply passes the call on to the underlying filesystem implementation
> calling vfs_setxattr, much like overlayfs was trying to do. But ecryptfs
> does not need to do anything else besides setting the attribute so it can
> call vfs_setxattr without taking any locks or mutexes itself.
> 
> However, there is a crucial difference in overlayfs: it might need to
> copy the dentry (and all directories leading up to it) on demand in
> setxattr. This happens if setxattr is being called for a file system entry
> which has never been modified in/through the overlay. I think this copy
> operation is what really should be protected by mnt_{want,drop}_write.
> 
> So the right thing to do would be to protect the copy and do the rest by
> unconditionally calling __vfs_setxattr_noperm. But wouldn't that just bring
> us back to the original problem: if i_mutex is already held, can't really
> mnt_want_write without triggering the lockdep problem, right ?

Yes, I think so.

Mimi
