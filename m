From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 4/4] fstests: add generic test for file handles
Date: Thu, 20 Apr 2017 15:21:50 +0800
Message-ID: <20170420072150.GY8951@eguan.usersys.redhat.com>
References: <1492619359-24763-1-git-send-email-amir73il@gmail.com>
 <1492619359-24763-5-git-send-email-amir73il@gmail.com>
 <20170420060054.GX8951@eguan.usersys.redhat.com>
 <CAOQ4uxjbQqOQecFkJQg9hzMAx2XxZiEHzuyaZRZAGs6_VEN8XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942481AbdDTHVy (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2017 03:21:54 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjbQqOQecFkJQg9hzMAx2XxZiEHzuyaZRZAGs6_VEN8XQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Thu, Apr 20, 2017 at 09:34:48AM +0300, Amir Goldstein wrote:
..
> >> +# Check non-stale handles to linked files
> >> +rm -f $testdir/*
> >> +src/open_by_handle -c $testdir $numfiles
> >> +src/open_by_handle    $testdir $numfiles
> >> +
> >> +# Check non-stale handles to files that were hardlinked and original deleted
> >> +src/open_by_handle -l $testdir $numfiles
> >> +src/open_by_handle -u $testdir $numfiles
> >
> > This last test still depends on test files created in the second test
> > implicitly. Forgot to update this part?
> 
> Intentional.
> It's the intended usage to create a test set with -c
> (imagine this is going to done on lower layer)
> then link the test set with -l (imagine this on either lower or overlay)
> then unlink the test set with -u (imagine this on overlay).

Yeah, that makes more sense in an overlay-specific test & operating on
multiple layers. But I don't see the point in this generic test by doing
so, as all these operations are clearly done on the same layer. So I
think adding "rm -f" and "-c" run in this test won't change test
behavior, but could avoid the implicit dependency.

Anyway, at least this is worth some comments on the implicit dependency.

> 
> So as a rule of thumb, rm -f is only added as extra safety
> before a src/open_by_handle -c line
> 
> >
> > # Check non-stale handles to files that were hardlinked and original deleted
> > rm -f $testdir/*
> > src/open_by_handle -c $testdir $numfiles
> > src/open_by_handle -l $testdir $numfiles
> > src/open_by_handle -u $testdir $numfiles
> >
> >> +
> >> +echo "Silence is golden"
> >> +status=$?
> >
> > $? is always 0 after echo. And any test failure could break golden
> > image, I think status can be set to 0 unconditionally.
> >
> 
> Indeed. a combination of copy&paste from xfs/238 and me moving
> Silence is golden to end. Let me know if you want me to re-post for this

I can fix this status issue, but seems you need to re-post anyway to add
more comments or empty $testdir before each test :)

Thanks,
Eryu
