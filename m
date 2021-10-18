Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45188C433F5
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Oct 2021 14:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A69460FC2
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Oct 2021 14:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhJROSr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Oct 2021 10:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbhJROSm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Oct 2021 10:18:42 -0400
X-Greylist: delayed 62204 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Oct 2021 07:02:51 PDT
Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [IPv6:2001:19f0:5:727:1e84:17da:7c52:5ab4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C910C08EE10
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Oct 2021 07:02:51 -0700 (PDT)
Received: from kevinolos.kevinlocke.name (2600-6c67-5000-3d1b-5eae-a16a-9807-0991.res6.spectrum.com [IPv6:2600:6c67:5000:3d1b:5eae:a16a:9807:991])
        (Authenticated sender: kevin@kevinlocke.name)
        by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 27E1B2766AE5;
        Mon, 18 Oct 2021 14:02:50 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
        id AF0D71300651; Mon, 18 Oct 2021 08:02:48 -0600 (MDT)
Date:   Mon, 18 Oct 2021 08:02:48 -0600
From:   Kevin Locke <kevin@kevinlocke.name>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [Regression] ovl: rename(2) EINVAL if lower doesn't support
 fileattrs
Message-ID: <YW1+iBBsX+Wlfx8O@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>
References: <20210910001820.174272-1-sashal@kernel.org>
 <20210910001820.174272-40-sashal@kernel.org>
 <YWyLigrybF6yzf6Y@kevinlocke.name>
 <CAJfpegsRo3e-9B64W37YrmvDcjo0QB9t+coAW3mO6TSqdROz2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsRo3e-9B64W37YrmvDcjo0QB9t+coAW3mO6TSqdROz2w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 2021-10-18 at 10:47 +0200, Miklos Szeredi wrote:
> On Sun, 17 Oct 2021 at 22:53, Kevin Locke <kevin@kevinlocke.name> wrote:
>> With 5.15-rc5 or torvalds master (d999ade1cc86), attempting to rename
>> a file fails with -EINVAL on an overlayfs mount with a lower
>> filesystem that returns -EINVAL for ioctl(FS_IOC_GETFLAGS).
>>
>> [...]
>>
>> This issue does not occur on 5.14.  I've bisected the regression to
>> 72db82115d2b.
> 
> This is clearly a regression.  Not trivial how far the fix should go, though.
> 
> One option is to just ignore all errors from ovl_copy_fileattr(),
> which would solve this and similar issues.  However that would result
> in missing the cases when the attributes were really meant to be
> copied up, but failed to do so for some reason.
> 
> If vfs_fileattr_get() fails with ENOIOCTLCMD or ENOTTY on lower, that
> obviously means we need to return success (lower fs does not support
> fileattr).   As ntfs-3g seems to return EINVAL that needs to be added
> too.

I agree.  I like your approach.  Especially for ENOIOCTLCMD/ENOTTY.
Since ntfs-3g returns EINVAL, that seems necessary to avoid logspam
for now.  Do you think it would make sense for me to suggest returning
ENOIOCTLCMD to the ntfs-3g project?  It seems more appropriate and
consistent with other filesystems to me, but I'm certainly not an
expert:
https://github.com/tuxera/ntfs-3g/blob/2021.8.22/libntfs-3g/ioctl.c#L415
I didn't see any other errors from in-tree filesystems, but who knows
errors other FUSE projects may return.

> More interesting question is what to do with get/set failures on
> upper.   My feeling is that for now we should try to return errors
> (even ENOTTY), but should print a warning in the kernel log.  If that
> turns out to regress some use cases, then that needs to fixed as well.

Does that mean all copy-up operations would fail for an upper which
does not support file attributes, or only ones where the file being
copied has attributes set?  I'm a little concerned about debugability,
since the failure modes may not be obvious to users.  Although the log
warnings would help with that.

Would it be possible to refuse to mount an upper which doesn't support
file attrs over a lower which does?  At least the failure would be
immediate and obvious.  If a use case is found, perhaps a mount option
to control file attr behavior cold be added at that point?  Just
thinking out loud.

> Untested patch attached.

Works great for me.

Tested-by: Kevin Locke <kevin@kevinlocke.name>

Thanks for the fast investigation and fix!
Kevin
