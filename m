From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/9] fstests: sanity check that test partitions are not
 mounted elsewhere
Date: Tue, 14 Feb 2017 10:05:12 +0200
Message-ID: <CAOQ4uxhLSAPApRy-SJpJGiP2xdjmpO0NLBYjzX_gCzfKqg7k_g@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-2-git-send-email-amir73il@gmail.com> <20170213111053.GF24562@eguan.usersys.redhat.com>
 <CAOQ4uxiWwVCN07yxwWQbp5Yi011TYV509RqWov9+szJnmP5NkA@mail.gmail.com>
 <CAOQ4uxg-DS7+j0DLLr20nZGrA6752D2ZUhfQeHPz5hGDb=DRfA@mail.gmail.com>
 <20170214055114.GK24562@eguan.usersys.redhat.com> <CAOQ4uxgQzWWQu+9yP12F4uaMD9L9qRQXU9HVrgcv8P2arP1kdQ@mail.gmail.com>
 <20170214072351.GL24562@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32997 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdBNIFO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Feb 2017 03:05:14 -0500
In-Reply-To: <20170214072351.GL24562@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Feb 14, 2017 at 9:23 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Feb 14, 2017 at 08:02:27AM +0200, Amir Goldstein wrote:
> [snip]
>> >> >> My test configs look like:
>> >> >>
>> >> >> TEST_DEV=/dev/sda5
>> >> >> SCRATCH_DEV=/dev/sda6
>> >> >> TEST_DIR=/mnt/testarea/test
>> >> >> SCRATCH_MNT=/mnt/testarea/scratch
>> >> >>
>> >> >> and if I mount SCRATCH_DEV at /mnt/xfs (or some other mountpoints rather
>> >> >> than SCRATCH_MNT), ./check -overlay overlay/??? isn't able to detect
>> >> >> this mis-configuration.
>> >> >>
>> >> >> [root@dhcp-66-86-11 xfstests]# ./check  -overlay overlay/002
>> >> >> FSTYP         -- overlay
>> >> >> PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.10.0-rc7
>> >> >> MKFS_OPTIONS  -- /mnt/testarea/scratch
>> >> >> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 -o lowerdir=/mnt/testarea/scratch/ovl-lower,upperdir=/mnt/testarea/scratch/ovl-upper,workdir=/mnt/testarea/scratch/ovl-work
>> >> >>
>> >> >> [root@dhcp-66-86-11 xfstests]#
>> >> >>
>> >> >> And nothing useful was printed. This is because my rootfs has no
>> >> >> filetype support, but the _notrun message is redirected to a file in
>> >> >> check, as
>> >> >>
>> >> >> "if ! _scratch_mkfs >$tmp.err 2>&1"
>> >> >>
>> >> >> Adding _check_mounted_on against OVL_BASE_TEST/SCRATCH_DEV here could
>> >> >> fix it for me.
>> >> >>
>> >> >
>> >> > Actually, there that test already exists in:
>> >> >
>> >> > _scratch_mkfs
>> >> >   _scratch_cleanup_files
>> >> >     _overlay_base_scratch_mount
>> >> >       _check_mounted_on
>> >
>> > Hmm, I don't think this kind of basic config sanity check belongs here,
>> > this should be done in config and env setup time. (So I think
>> > _overlay_mount should be fixed too, that _supports_filetype check
>> > doesn't belong there either.)
>> >
>> > How about adding these checks in init_rc, along with other
>> > _check_mounted_on checks against TEST_DEV and SCRATCH_DEV?
>> >
>>
>> Yes, that makes sense.
>>
>> But I still wonder how "exit 1" from within helpers should be handled
>> from check when stdout/err are redirected to $tmp.err.
>> Trying to catch the config error earlier is a good practice, but
>> it won't ensure against the same type of problem in the future.
>>
>> What did you think about my approach to store mkfs output in  $check_err
>> var instead of $tmp.err file and spew $check_err in _wrapup?
>> BTW I tries 'cat $tmp.err' in _wrapup, but output is still redirected to
>> $tmp.err while in trap, so cat says: "cat: input file is output file".
>
> I don't think we need to worry about that or handle it. IMO, if we
> redirect a helper that does "exit", we're doing something wrong, so
> either fix the redirection or fix the helper (just return not exit).
>
> I went through helpers in common/rc roughly, except the _overlay_mount
> issue, seems we don't have other such problems right now :)
>

OK. less work for me :)
I'll just fix the helper then.
