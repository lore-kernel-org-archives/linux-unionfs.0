From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay: add a test for multiple redirects to the same
 lower dir
Date: Fri, 24 Nov 2017 13:05:41 +0800
Message-ID: <20171124050541.GY2749@eguan.usersys.redhat.com>
References: <1511447224-2301-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511447224-2301-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 23, 2017 at 04:27:04PM +0200, Amir Goldstein wrote:
> Multiple redirects to the same lower dir will falsely return the
> same st_ino/st_dev for two different upper dirs and will cause 'diff'
> to falsely report that content of directories is the same when it is not.
> 
> This is a test for a regression introduced in kernel v4.12 by
> commit 72b608f08528 ("ovl: constant st_ino/st_dev across copy up"),
> but also the first xfstest to require the redirect_dir feature that
> was introduced as an opt-in feature in kernel v4.10.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Eryu,
> 
> This test is for a "bug" that has not been acknoledges by Miklos
> as a kernel bug yet. It may well fall within the jurisdiction of
> fsck.overlayfs.
> 
> IMO, cp -a of upper files and dirs qualifies to the statement in
> Documentation/filesystems/overlayfs.txt:
> "Offline changes, when the overlay is not mounted, are allowed to either
> the upper or the lower trees."
> 
> So unless Miklos objects to ever fixing this "bug"?
> I suggest that we include the failing test until kernel is fixed.

Thanks for the info! Then I'll wait until it's been acked as a bug.

Thanks,
Eryu
