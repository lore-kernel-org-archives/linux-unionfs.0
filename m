From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 06/23] ovl: add support for "verify" feature
Date: Fri, 5 Jan 2018 11:39:51 -0500
Message-ID: <20180105163951.GF29480@redhat.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
 <1515084018-25134-7-git-send-email-amir73il@gmail.com>
 <20180105154323.GC29480@redhat.com>
 <CAOQ4uxg35sutZZUCKQxoiuNVfLXxe44wavX95bC_GMntbLn-QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751499AbeAEQjw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Jan 2018 11:39:52 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg35sutZZUCKQxoiuNVfLXxe44wavX95bC_GMntbLn-QQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 05, 2018 at 05:47:36PM +0200, Amir Goldstein wrote:
> On Fri, Jan 5, 2018 at 5:43 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Jan 04, 2018 at 06:40:01PM +0200, Amir Goldstein wrote:
> >> Introduce the "verify" config, module and mount options.
> >>
> >> If the "verify" feature is enabled then overlay filesystems will use
> >> the inodes index dir to verify layers consistency.
> >>
> >> It is possible to enable consistency verification by default during
> >> build time with the OVERLAY_FS_VERIFY config option, during runtime
> >> with the "verify=on" module option or on a filesystem instance basis
> >> with the "verify=on" mount option.
> >>
> >> The "verify" feature will prevent multiple redirects to the same lower
> >> dir and will prevent broken hardlinks from using the same inode number.
> >
> > So how does one end up with multiple redirects to same lower dir.
> >
> > Also what's the issue with broken hardlinks using same inode number. You
> > mean lower and upper are on different fs and upper can use same inode
> > number? With index=on, broken hardlink issue is taken care of so. So
> > why would somebody use verify=on, which looks like will create index
> > for all kind of files/dir.
> >
> > I have not followed this development and there is not much background
> > in patch descrition or header patch, so asking all these basic questions.
> >
> 
> I have a ready answer for you :)
> This is how it can happen and this is what can go wrong:
> https://github.com/amir73il/xfstests/commit/f3c18125539660329195f142973ea620d6899418
> 
> The test duplicates a redirect dir offline with cp -a, but the
> same thing can be done with a dir with origin.
> In both cases, 'diff' will wrongly report that the files/dir are the same
> even though they may differ (after being copied).

So there are so many things a user can do with overlayfs offline. Should
we need to put runtime checks for all these cases. I mean will
fsck.overlay be a better place to catch these kind of anomalies.

Secondly, verify=foo feels like a very generic option. Its not clear
what all will it verify and will we continue to pile up more checks
down the line under it.

As a user, when should one use verify=on? Its not clear to me.

Vivek

> 
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
