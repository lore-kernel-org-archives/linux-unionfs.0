From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Overlayfs backport for kernel v4.9.y
Date: Thu, 7 Dec 2017 13:20:50 -0500
Message-ID: <20171207182050.GA4067@redhat.com>
References: <CAOQ4uxiYg11XGjzNhD-2gOd-s-FgnzScgzDwwuWpp+518EHv6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754155AbdLGSUw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 13:20:52 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiYg11XGjzNhD-2gOd-s-FgnzScgzDwwuWpp+518EHv6A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Dec 07, 2017 at 07:14:49PM +0200, Amir Goldstein wrote:
> Hi All,
> 
> For whom it may concern, I have backported latest overlayfs
> features to stable kernel v4.9.y. The patches are available on

Hi Amir,

So what's the plan. Who is going to consume these patches. Will
these be merged somewhere?

Vivek

> overlayfs-4.9.y branch on my github [1]. I intend to update and
> test this branch with patches applied to upstream.
> 
> This work was verified with with xfstests master branch and
> with unionmount-testsuite master branch on my github [2].
> 
> DO NOT mistake this for code that can be compiled and loaded
> as a kernel module to kernel v4.9.y!
> The branch pulls in some minor infrastructure changes that
> were required for ease of backporting (mostly uuid_t helpers).
> Most of the remaining diff from v4.15-rc1 in overlayfs code
> is due to STATX vfs API change.
> 
> All backported patches have my S-O-B, but most of them
> don't have the upstream commit id in the commit message
> expect a few tree wide patches which I selectively picked
> their changes only to overlayfs (e.g. add include <cred.h>).
> 
> Please feel free to use this code, review my work and test it.
> 
> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/linux/commits/overlayfs-4.9.y
> [2] https://github.com/amir73il/unionmount-testsuite
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
