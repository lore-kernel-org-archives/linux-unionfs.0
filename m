From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/7] Overlayfs exportfs tests
Date: Fri, 12 Jan 2018 19:52:27 +0800
Message-ID: <20180112115227.GR5123@eguan.usersys.redhat.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
 <20180111114335.GK5123@eguan.usersys.redhat.com>
 <CAOQ4uxhZ5LvJ375GF9XknTBBe9OcgYh8umiDt43Hk65QgFeUQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754483AbeALLwb (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 06:52:31 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhZ5LvJ375GF9XknTBBe9OcgYh8umiDt43Hk65QgFeUQQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 11, 2018 at 01:52:02PM +0200, Amir Goldstein wrote:
> On Thu, Jan 11, 2018 at 1:43 PM, Eryu Guan <eguan@redhat.com> wrote:
> > On Sun, Jan 07, 2018 at 08:07:18PM +0200, Amir Goldstein wrote:
> >> Eryu,
> >>
> >> Following patches were used to test overlayfs NFS export.
> >>
> >> Patches 1-5 improve generic/exportfs tests, by adding test coverage
> >> of some directory file handle use cases.
> >
> > open_by_handle test is covering more and more cases, thanks! OTOH, it's
> > getting more and more complicated :)
> 
> Yeh, sorry about that ;-)
> 
> >
> > But from a quick scan, I think it's time to stop adding new sub-tests to
> > existing tests (maybe we should have done this since last time we added
> > new sub-tests to generic/467), because generic/467 is getting more
> > complex too and makes review harder.
> 
> Probably a good idea, but please note that patch 4/7 is fixing a test that was
> not implemented correctly and test 5/7 adds a very minor variant.

I've gone through the first 5 patches now. All look fine except the
comments to patch 1/7.

I think we can add a new test that contains the last part of patch 4/7
("Check non-stale file handles of renamed dirs") and patch 5/7. And
leave the "fix test" part in patch 4/7.

> An option is to split the directory related tests (those that are fixed by 4/7)
> out of generic/467 and then fix them and add the new variant.

This should be fine too, but I slightly tend to not move existing tests,
just add new cases to new tests.

BTW, thanks for the explaining in another reply, that did help.

Thanks,
Eryu

> 
> > Perhaps we can factor out some
> > helper functions from generic/467 to common helpers and use them in new
> > tests.
> >
> 
> I don't think there is much to factor out, but we can add new tests
> and clone the helpers. Let me know if you think differently after review.
> 
> Thanks,
> Amir.
