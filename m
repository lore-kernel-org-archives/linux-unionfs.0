Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Sun, 3 Mar 2019 00:30:17 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 2/2] generic: Test that SEEK_HOLE can find a punched hole
Message-ID: <20190302163017.GG2824@desktop>
References: <20190226140902.32219-1-amir73il@gmail.com>
 <20190226140902.32219-2-amir73il@gmail.com>
 <20190302152518.GD2824@desktop>
 <CAOQ4uxgqRzna=DOWAToCB9AqQj_BRUQStd2PyfeE_+ZDK7XsgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgqRzna=DOWAToCB9AqQj_BRUQStd2PyfeE_+ZDK7XsgQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eddie Horng <eddiehorng.tw@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Mar 02, 2019 at 06:09:47PM +0200, Amir Goldstein wrote:
> On Sat, Mar 2, 2019 at 5:25 PM Eryu Guan <guaneryu@gmail.com> wrote:
> >
> > On Tue, Feb 26, 2019 at 04:09:02PM +0200, Amir Goldstein wrote:
> > > Added a test case to seek_sanity_test and a test to run it.
> > >
> > > When checking for SEEK_HOLE support, abort if filesystem
> > > supports punching holes that SEEK_HOLE will not find, because
> > > this configuration doesn't make any sense.
> >
> > Hmm, I don't think it's a good idea to call it a bug if the filesystem
> > decides to support punch hole but not SEEK_HOLE (non-default behavior).
> > It's not a ideal to support only punch hole but not SEEK_HOLE, as you
> > mentioned that only hugetlbfs supports this strange combination, but
> > there's no standard to forbid such combination. IMHO, punch hole and
> > SEEK_HOLE are totally two independent features, filesystems are free to
> > support any or both of them.
> >
> > >
> > > This kind of senless behavior was introduced to overlayfs
> > > in v4.19 with stacked file operations, because overlay fallocate
> > > op is stacked and llseek op is not stacked.
> >
> > And I think this is an overlay-specific bug. I'd suggest comparing
> > SEEK_DATA/SEEK_HOLE results from underlying filesystem and from
> > overlayfs, to make sure the two results are the same, which means if
> > underlying fs supports SEEK_HOLE overlayfs calls llseek op from
> > underlying fs too. (Perhaps using xfs_io's seek command.)
> >
> 
> I understand where your arguments are coming from, but from my
> perspective, what happened in overlayfs could happen in any filesystem.
> A regression that causes filesystem to revert to "default" behavior would
> go unnoticed with current set of xfstest seek sanity tests.
> 
> So while the bug was overlayfs specific, the lack of test coverage is
> generic. So I thought to myself, well how can the test suite know if
> a filesystem is supposed to SEEK_HOLE? and I found a property
> that could be used as a very strong indication that filesystem is expected
> to support SEEK_HOLE.
> 
> IMO, the question whether or not this is a standard is way less
> interesting than the question - what are the odds that a filesystem
> wants to be tested in xfstests does not follow this rule?
> I do not know the answer to this question, but if you think the odds
> are low, then I believe it is worth using this heuristic to improve
> test coverage.
> 
> Another option is to whitelist/blacklist xfstests supported filesystems
> that support "proper" SEEK_HOLE, so the sanity tests will actually
> verify a single expected behavior, instead of verifying one of two
> possible expected behaviors.
> Let me know what you think.

I'd rather go with the whitelist/blacklist option. Perhaps a wrapper
function around seek_sanity_test and automatically add the proposed "-f"
argument if $FSTYP is in that list.

> 
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Eryu,
> > >
> > > After this change, the generic/seek group tests will start
> > > failing with overlayfs on upstream kernel.
> > >
> > > We had missing coverage of SEEK_HOLE, so we missed a regression
> > > in kernel v4.19 when overlayfs SEEK_HOLE stopped finding punched
> > > holes (or any holes for that matter).
> >
> > So I suggest two new tests, one overlay-specific test to cover the
> > regression, and one generic test to cover seek holes after punch hole
> > (as this one, but don't fail if punch_hole == true && SEEK_HOLE ==
> > false).
> >
> 
> OK, this is what I'll do, but as I write above, this will result in suboptimal
> generic test coverage.
> 
> - Add flag seek_sanity_test -f that fails if default_behavior is detected.
> - Use this flag for requirements of new generic PUNCH+SEEK test:
> _require_seek_data_hole -f
> _require_xfs_io_command "fpunch"
> - For overlayfs specific test, the test will not _require_seek_data_hole -f
> but it will instead check real SEEK_HOLE support of base fs and then will
> test seek of punched hole with -f flag.

Yeah, this looks sane to me. Thanks!

Eryu
