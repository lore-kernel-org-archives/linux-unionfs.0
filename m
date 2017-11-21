From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [fsck.overlay RFC PATCH] overlay: add fsck utility
Date: Mon, 20 Nov 2017 21:30:50 -0500
Message-ID: <20171121023049.5yb2hsm5l5xegy4h@thunk.org>
References: <20171117054919.712-1-yi.zhang@huawei.com>
 <CAOQ4uxgCN-ZdLsZQmYYW-PyJLB4WWsr9A8gqOtcSC6S9Uj8qZA@mail.gmail.com>
 <0932944e-bbb7-22c6-9b75-19c42f8c7e41@huawei.com>
 <20171120074252.GG2749@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171120074252.GG2749@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, Amir Goldstein <amir73il@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Nov 20, 2017 at 03:42:52PM +0800, Eryu Guan wrote:
> > I found that e2fsprogs put tests in the e2fsprogs repository, so I write it
> > and put in the same place. Now I notice that all xfs test cases put together
> > in xfstests, so It's also a good choice, not sure which one is better. How
> > about Eryu's opinion ?
> 
> IMHO, xfstests is a good place for fsck.overlay tests, but I don't think
> that's something conflicting with in-repo unit tests, some tests are
> just not suitable for xfstests. How about writing tests in xfstests by
> default and only keeping them in repository, if there's any, if the
> tests are not fitting in xfstests well?

Zhangyi,

Here's my opinion, for whatever it's worth.  Things which don't
require root and which run fairly quickly (ideally less than 10
seconds; preferably under 5), are better to do in the fsck git
repository.  That's because it's much faster to run "make ; make
check".

Tests are most effective when they are frequently run and used.  You
may be more willing to live an exciting life, but I'm not particularly
fond of running "make install" of a development branch of e2fsprogs
just to run tests.  So that means I have to build e2fsprogs packages,
rebuild the test appliance VM, and then run tests --- which takes
*easily* 10x more time.

The place where it makes a lot of sense to put fsck and resize tests
into xfstests is where it requires root, or if the tests have a long
run-time.  For similar reasons of not wanting to live an exciting life
when it comes to my development environment, I don't like running
"make check" as repository which can be updated by others as root.  So
if a file system needs to be mounted (for example, to set up a test),
or if you want to test on-line resize, then that's an argument for
doing it in xfstests.

For overlayfs, it might be that you need to do a lot of mount and
unmount operations as root in order to run your tests.  So maybe
that's a good argument to run it under xfstests.  Unless you can make
small, pre-prepared file system images that you can untar and then
point at your overlayfsck to check.

As the Perl developers would say, "there's more than one way to do things".  :-)

							- Ted
