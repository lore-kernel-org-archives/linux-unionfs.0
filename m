From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/2] xfstests-bld: improve overlayfs testing
Date: Mon, 7 Nov 2016 12:29:07 -0500
Message-ID: <20161107172907.4ybnqk32jkb32uio@thunk.org>
References: <1478427797-8969-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478427797-8969-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Nov 06, 2016 at 12:23:15PM +0200, Amir Goldstein wrote:
> Hi Ted,
> 
> Following are the changes to xfstests-bld I have been using to test overlayfs.
> 
> xfstests master branch just got updated with several fixes to overlay/* tests.
> One overlayfs bug that was caught by generic/375 was fixed for 4.9-rc4 and one
> that was caught by generic/157 is queued on overlayfs-next branch.
> 
> With these changes to test-appliance, one can test drive overlayfs clone-up
> over xfs with reflink support. Xfs with reflink support was merged to 4.9-rc1
> and relevant xfsprogs changes are queued on xfsprogs for-next branch.
> Overlayfs clone-up is queued on overlayfs-next branch.
> 
> Decided to have a little fun and send this one out to you also via github PR.

Thanks, merged.

> Thanks for setting up xfstests-bld.
> It has been a great help in bringing up my test env.

Great, I'm glad it's been useful for you!

						- Ted
