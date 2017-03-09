From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: New kvm-xfstests images uploaded
Date: Thu, 9 Mar 2017 10:49:16 -0500
Message-ID: <20170309154916.dtqvw6mk5rvlxgf5@thunk.org>
References: <20170306055827.omfoahfisn44l6bc@thunk.org>
 <CAOQ4uxiHM1UTAPRt6ambvbnL8eOqT3U2hbsrLJTTJ+wSVFOc-g@mail.gmail.com>
 <CAOQ4uxjvDR=qhQBd-QLcBpKZJZ5A=9PakbcK99T_Hs6STjMLGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjvDR=qhQBd-QLcBpKZJZ5A=9PakbcK99T_Hs6STjMLGg@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Mar 09, 2017 at 02:31:39PM +0200, Amir Goldstein wrote:
> [re-sending with correct address of fstests list]
> 
> On Thu, Mar 9, 2017 at 2:29 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Mon, Mar 6, 2017 at 7:58 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> >> I've uploaded a new kvm-xfstests image at:
> >>
> >> https://www.kernel.org/pub/linux/kernel/people/tytso/kvm-xfstests
> >>
> >> This has the latest xfstests, xfsprogs, and e2fsprogs update, as well
> >> as changes to help debug problems in the journal_lazy patches:
> >>
> >> e2fsprogs       v1.43.4-27-g686994eb (Fri, 3 Mar 2017 10:02:14 -0500)
> >> fio             fio-2.17-1-g54441e7 (Wed, 18 Jan 2017 08:18:28 -0700)
> >> quota           e0b6335 (Thu, 9 Feb 2017 11:55:45 +0100)
> >> stress-ng       4ad62e1 (Mon, 27 Feb 2017 14:28:36 -0500)
> >> xfsprogs        v4.10.0-rc1 (Wed, 15 Feb 2017 21:48:31 -0600)
> >> xfstests-bld    032c8c3 (Fri, 3 Mar 2017 21:03:05 -0500)
> >> xfstests        linux-v3.8-1414-g999e3f6 (Sun, 5 Mar 2017 19:11:35 -0500)
> >
> > That is not an xfstests commit (is it??)

Sorry, I didn't include the explanation from the REAME file.  I have a
number of private changes to xfstests that are available on github:

    https://github.com/tytso/xfstests release-2017-03-05-999e3f6f


A quick summary of the out-of-tree patches which I am carrying (there
are only four at the moment):

999e3f6f common: run "e2fsck -E journal_only -p" before checking the (ext4) file system

   This is needed to do some development work to try and integrate the
   "SMR-friendly" journalling patches described in the recent FAST 2017
   paper.

   In the long run I'll probably add code so that e2fsck will be able
   to do "true" read-only checks, without needing to replay a
   non-empty journal.  This would be done by reading in the journal,
   and then redirecting block reads to the latest version of that
   blocks in the journal.  Since that isn't ready yet, I needed to
   have a way force a journal replay before doing an fsck -n read-only
   check of the file system.  Since it's a short-term hack, I didn't
   bother to send it upstream.

aa1a75a0 check: try to fix the test device if it gets corrupted

   Sent upstream for review
 
4ed6a0e9 common: add support for the "local" file system type

   This is needed to test a userspace file system that can't be
   mounted or unmounted.  Dave Chinner didn't like the fact that it
   for was something proprietary and not yet disclosed, but I wlil
   point out that if someone was interested in using xfstests to test
   the POSIX support in the Windows 10 Linux emulation layer, it
   would be *perfect* for that sort of thing.


8cfe428f common: introduce XFS_IO_AVOID env var

    This allows me to restrict all punch, collapse, insert, or zero
    tests by specifying an environment variable that causes
    _require_punch, et. al, to report that the file system feature is
    not available.

    Sent upstream and rejected; Dave Chinner felt that this is better
    done by using -x collapse and defining new groups which contained
    all tests that uses collapse, punch, insert, etc.  This is a very
    simple patch, and I infinitely prefer this approach over Dave's
    approach, because people have a tendency to add tests and not
    necessarily add the tests to all of the right groups.  Since this
    information is already encoded in the test via _require_FOO, and
    it's simpler for me to carry this patch than to either (a) keep an
    eagle eye on all new tests to make sure they have the right groups
    added, or (b) arguing with Dave about it, I've kept this patch
    around.

    It means that someone using the kvm-xfstests or gce-xfstests with
    the upstream xfstests won't have --no-collapse, --no-punch,
    et. al. working correctly, but this seems to be mostly something I
    use when I'm trying to check whether a particular reported bug can
    be localized to one the fallocate extent tree operations, which
    historically have been a source of "interesting" bugs for ext4.


> > The reason I am asking is because I want to change kvm-xfstests
> > overlay cfg scripts to use the new xfstests overlay config. e.g.::
> >
> > SIZE=large
> > export TEST_DEV=$LG_TST_DEV
> > export TEST_DIR=$LG_TST_MNT
> > export SCRATCH_DEV=$LG_SCR_DEV
> > export SCRATCH_MNT=$LG_SCR_MNT
> >

It's been on my todo list try out your patches and to make the
appropriate adjustments to the overlay file system support code, but I
haven't had the time to do this yet.  If you'd like to send me
patches, please do feel free!

						- Ted
