From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/2] overlay: fix INDEX=y regressions
Date: Wed, 20 Sep 2017 11:53:39 +0800
Message-ID: <20170920035339.GR8034@eguan.usersys.redhat.com>
References: <1505821184-3913-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53381 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751284AbdITDxl (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 19 Sep 2017 23:53:41 -0400
Content-Disposition: inline
In-Reply-To: <1505821184-3913-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Sep 19, 2017 at 02:39:42PM +0300, Amir Goldstein wrote:
> Eryu,
> 
> When you added the comment to overlay/014, I said Looks good to me,
> but I wasn't looking well.
> Second patch is the same treatment to overlay/031 (with the correct
> comment).
> 
> Test overlay/031 does not pass on master, but with INDEX=y, it fails
> on the wrong errors.
> The test passes on my development branch:
> https://github.com/amir73il/linux/commits/overlayfs-devel

Thanks for all the fixes and clarifications! Queued for next update.

Eryu

> 
> Amir.
> 
> Amir Goldstein (2):
>   overlay/014: correct comment relating to workdir reuse
>   overlay/031: fix test with inodes index enabled
> 
>  tests/overlay/014 |  7 +++----
>  tests/overlay/031 | 23 ++++++++++++++++-------
>  2 files changed, 19 insertions(+), 11 deletions(-)
> 
> -- 
> 2.7.4
> 
