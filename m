From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/9] fstests: sanity check that test partitions are not
 mounted elsewhere
Date: Tue, 14 Feb 2017 08:02:27 +0200
Message-ID: <CAOQ4uxgQzWWQu+9yP12F4uaMD9L9qRQXU9HVrgcv8P2arP1kdQ@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-2-git-send-email-amir73il@gmail.com> <20170213111053.GF24562@eguan.usersys.redhat.com>
 <CAOQ4uxiWwVCN07yxwWQbp5Yi011TYV509RqWov9+szJnmP5NkA@mail.gmail.com>
 <CAOQ4uxg-DS7+j0DLLr20nZGrA6752D2ZUhfQeHPz5hGDb=DRfA@mail.gmail.com> <20170214055114.GK24562@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33286 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbdBNGC3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Feb 2017 01:02:29 -0500
In-Reply-To: <20170214055114.GK24562@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Feb 14, 2017 at 7:51 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Mon, Feb 13, 2017 at 03:33:23PM +0200, Amir Goldstein wrote:
>> On Mon, Feb 13, 2017 at 1:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > On Mon, Feb 13, 2017 at 1:10 PM, Eryu Guan <eguan@redhat.com> wrote:
>> >> On Sun, Feb 12, 2017 at 10:43:36PM +0200, Amir Goldstein wrote:
>> >>> When $TEST_DEV is mounted at a different location then $TEST_DIR,
>> >>> _require_test() aborts the test with an error:
>> >>>  TEST_DEV=/dev/sda5 is mounted but not on TEST_DIR=/mnt/test
>> >>>
>> >>> There are several problems with current sanity check:
>> >>> 1. the output of the error is mixed into out.bad and hard to see
>> >>> 2. the test partition is unmounted at the end of the test regardless
>> >>>    of the fact that it not pass the sanity that we have exclusivity
>> >>> 3. scratch partition has a similar sanity check in _require_scratch(),
>> >>>    but we may not get to it, because $SCRATCH_DEV is unmounted prior
>> >>>    to running the tests (which could unmount another mount point).
>> >>>
>> >>> To solve all these problems, introduce a helper _check_mounted_on().
>> >>> It checks if a device is mounted on a given mount point and optionally
>> >>> checks the mounted fs type.
>> >>>
>> >>> The sanity checks in _require_scratch() and _require_test() are
>> >>> converted to use the helper and gain the check for correct fs type.
>> >>>
>> >>> The helper is used in init_rc() to sanity check both test and scratch
>> >>> partitions, before tests are run and before $SCRATCH_DEV is unmounted.
>> >>>
>> >>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> >>> ---
>> >>>  common/rc | 83 +++++++++++++++++++++++++++++++++++++--------------------------
>> >>>  1 file changed, 49 insertions(+), 34 deletions(-)
>> >
>> > ...
>> >
>> >> My test configs look like:
>> >>
>> >> TEST_DEV=/dev/sda5
>> >> SCRATCH_DEV=/dev/sda6
>> >> TEST_DIR=/mnt/testarea/test
>> >> SCRATCH_MNT=/mnt/testarea/scratch
>> >>
>> >> and if I mount SCRATCH_DEV at /mnt/xfs (or some other mountpoints rather
>> >> than SCRATCH_MNT), ./check -overlay overlay/??? isn't able to detect
>> >> this mis-configuration.
>> >>
>> >> [root@dhcp-66-86-11 xfstests]# ./check  -overlay overlay/002
>> >> FSTYP         -- overlay
>> >> PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.10.0-rc7
>> >> MKFS_OPTIONS  -- /mnt/testarea/scratch
>> >> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 -o lowerdir=/mnt/testarea/scratch/ovl-lower,upperdir=/mnt/testarea/scratch/ovl-upper,workdir=/mnt/testarea/scratch/ovl-work
>> >>
>> >> [root@dhcp-66-86-11 xfstests]#
>> >>
>> >> And nothing useful was printed. This is because my rootfs has no
>> >> filetype support, but the _notrun message is redirected to a file in
>> >> check, as
>> >>
>> >> "if ! _scratch_mkfs >$tmp.err 2>&1"
>> >>
>> >> Adding _check_mounted_on against OVL_BASE_TEST/SCRATCH_DEV here could
>> >> fix it for me.
>> >>
>> >
>> > Actually, there that test already exists in:
>> >
>> > _scratch_mkfs
>> >   _scratch_cleanup_files
>> >     _overlay_base_scratch_mount
>> >       _check_mounted_on
>
> Hmm, I don't think this kind of basic config sanity check belongs here,
> this should be done in config and env setup time. (So I think
> _overlay_mount should be fixed too, that _supports_filetype check
> doesn't belong there either.)
>
> How about adding these checks in init_rc, along with other
> _check_mounted_on checks against TEST_DEV and SCRATCH_DEV?
>

Yes, that makes sense.

But I still wonder how "exit 1" from within helpers should be handled
from check when stdout/err are redirected to $tmp.err.
Trying to catch the config error earlier is a good practice, but
it won't ensure against the same type of problem in the future.

What did you think about my approach to store mkfs output in  $check_err
var instead of $tmp.err file and spew $check_err in _wrapup?
BTW I tries 'cat $tmp.err' in _wrapup, but output is still redirected to
$tmp.err while in trap, so cat says: "cat: input file is output file".
