From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 4/4] fstests: add generic test for file handles
Date: Wed, 19 Apr 2017 18:41:42 +0800
Message-ID: <20170419104142.GW8951@eguan.usersys.redhat.com>
References: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
 <1492539444-25938-5-git-send-email-amir73il@gmail.com>
 <20170419095533.GQ8951@eguan.usersys.redhat.com>
 <CAOQ4uxhngqyVR20iT+0-4jyk_e9VXgP7zsSQp3tuN=c_A-MYaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761416AbdDSKlp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Apr 2017 06:41:45 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhngqyVR20iT+0-4jyk_e9VXgP7zsSQp3tuN=c_A-MYaA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Wed, Apr 19, 2017 at 01:07:47PM +0300, Amir Goldstein wrote:
...
> > So how about remove all the files and call "open_by_handle -c ..."
> > before each test? e.g. (I use testdir and don't remove lost+found dir
> > because extN needs it for fsck)
> >
> 
> Sure. Makes sense.
> Going forward, as you might have guessed, I am going to add
> _scratch_cycle_mount to the mix.
> 
> 
> > testdir=$SCRATCH_MNT/testdir
> 
> So I copied using SCRATCH_MNT from xfs/238, but I wonder if
> I should go with thsi instead:
> testdir=$TEST_DIR/$seq
> 
> Maybe some fs is vulnerable to exporting handles from an ages fs
> who knows... Any opinion?

Hmm, I have no strong preference on this, seems TEST_DIR should be
sufficient for the test and we can get rid of one test requirement.

Thanks,
Eryu
