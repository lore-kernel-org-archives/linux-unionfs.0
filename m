From: "J. R. Okajima" <hooanon05g@gmail.com>
Subject: Re: [PULL for 3.18] overlay filesystem v24
Date: Tue, 30 Sep 2014 22:23:42 +0900
Message-ID: <6637.1412083422@jrobl>
References: <20140929141457.GB5011@tucsk.piliscsaba.szeredi.hu> <26822.1412028003@warthog.procyon.org.uk> <27645.1412052879@jrobl> <CAJfpeguWkWOeWYS1o2gW4P1DJhXn=enBGukPcfscd-guas7h8w@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:33601 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaI3NXq (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 30 Sep 2014 09:23:46 -0400
In-Reply-To: <CAJfpeguWkWOeWYS1o2gW4P1DJhXn=enBGukPcfscd-guas7h8w@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-unionfs@vger.kernel.org


Miklos Szeredi:
> It would be good to have an inode based union as well.  I suggest (as
> I suggested many times) to try slimming aufs to a bare minimum and
> submit that.  It may be easier to just start from scratch instead
> trying to drop features from the existing codebase.   I'd be happy to
> review and generally help with such an effort.

??
In 2009, I have posted the "feature-reduced" version of aufs2 as
following your advice. Also a git-branch called "aufs2-tmp-ro" was
created whose size was a half of aufs2's. Have you ever posted your
review comments about them?

It was 2005 when I got an idea of aufs. Its history is almost a decade.
In my current local aufs3 develpment branch, I got about 350
commits. And 680 and 1120 commits for aufs2 and aufs1 individually.

aufs3-linux.git#aufs3.x-rcN/25lktr$ git log1 --no-merges fs/aufs/*.c | wc -l
348
aufs2-2.6.git#aufs2.2-stdalone-38-lktr$ git log1 --no-merges fs/aufs/*.c | wc -l
685
aufs1.git#master$ git log1 --no-merges aufs/fs/aufs/*.c | wc -l
1126

Of cource it won't be 2000 commits to create the patch series you
wrote. I don't know how large the number will be but I am sure this is
incredibly tough work both in commiting and reviewing. Is it still
helpful and really meaningful for you to review? Don't you think it will
be easier to review the resulted code?
For example, this branch was created for linux-3.9 when Al Viro wrote
about the dir mutex lock in copy-up. It has only 20 commits.

aufs3-linux.git#mainline-v3.9-rc8-20130428$ git log1 --no-merges fs/aufs/*.c | wc -l
20


J. R. Okajima
