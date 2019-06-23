Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Sun, 23 Jun 2019 21:25:03 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] overlay/061: remove from auto and quick groups
Message-ID: <20190623132503.GM15846@desktop>
References: <20190618064355.29398-1-amir73il@gmail.com>
 <CAOQ4uxiDZjr2+EyjWtimjLxFHrMN13K4N5Aw+9BACPmx+2W6Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiDZjr2+EyjWtimjLxFHrMN13K4N5Aw+9BACPmx+2W6Kg@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jun 19, 2019 at 01:47:01PM +0300, Amir Goldstein wrote:
> >
> > I did not observe any regressing with check -overlay -g generic/quick
> > compared to check -g generic/quick on xfs with recent kernel.
> > I did not test all filesystems and -g generic/auto with recent kernel,
> > but I am not aware of any expected failures specific for -overlay run
> > on generic tests.
> >
> 
> Oh! I was lying. I *did* notice two regressions with
> check -overlay -g generic/quick (compared to xfs),
> so I posted fixes for them:
> 
> 1) generic/504 is failing with -overlay on master.
> 
> This kernel fix commit is on linux-next:
> 6ef048fd5955 locks: eliminate false positive conflicts for write lease
> 
> 2) generic/555 (was just merged this week) is failing with
> -overlay on master.
> 
> This kernel fix commit is on Miklos' overlayfs-next:
> 941d935ac763 ovl: fix wrong flags check in FS_IOC_FS[SG]ETXATTR ioctls

Thanks a lot for the detailed information!

Eryu
