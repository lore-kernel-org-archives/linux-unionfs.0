From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 5/7] overlay: test concurrent copy up of lower hardlinks
Date: Wed, 12 Jul 2017 09:11:10 +0300
Message-ID: <CAOQ4uxgLfR5Zzwvdii5FJv9awK6WjVOYXdATTy1TcS-juBbBrw@mail.gmail.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
 <1499168434-23859-6-git-send-email-amir73il@gmail.com> <20170705095902.GR23360@eguan.usersys.redhat.com>
 <CAOQ4uxjLCGZ3hHfkZzgZiHctC1x6s_EF7J1g0-zjXYCOzqoHwQ@mail.gmail.com>
 <CAOQ4uxjYVevw=bTsONHT=FHMkoapqOcmwL+nj4R6Y3T6Dhmneg@mail.gmail.com> <20170712031747.GQ29475@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170712031747.GQ29475@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jul 12, 2017 at 6:17 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Jul 11, 2017 at 11:23:50PM +0300, Amir Goldstein wrote:
>> On Wed, Jul 5, 2017 at 1:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> > On Wed, Jul 5, 2017 at 12:59 PM, Eryu Guan <eguan@redhat.com> wrote:
>> >> On Tue, Jul 04, 2017 at 02:40:32PM +0300, Amir Goldstein wrote:
>> >>> Two tasks make a modification concurrently on two hardlinks of a large
>> >>> lower inode.  The copy up should be triggered by one of the tasks and the
>> >>> other should be waiting for copy up to complete.  Both copy up targets
>> >>> should end up being upper hardlinks and both metadata changes should be
>> >>> visible in both hardlinks.
>> >>>
>> >>> With kernel <= v4.12, hardlinks are broken on copy up, meaning that copy up
>> >>
>> >> So this will be fixed in 4.13-rc1 kernel?
>> >
>> > It is fixed on current overlayfs-next branch. Yes.
>> >
>>
>> Eryu,
>>
>> I realize that my answer was not accurate.
>> These tests do pass with current overlayfs-next branch, but
>> only with non default kernel config CONFIG_OVERLAY_FS_INDEX=y.
>
> Thanks for the heads-up!
>
>>
>> This may be the right way to test, meaning that default kernel
>> config reports failed tests related to hardlinks which are really broken
>> on copy up with default kernel config.
>
> So these hardlink tests are still valid tests and the failures should be
> fixed eventually, even for OVERLAY_FS_INDEX=n kernels? If so, I think we

The tests are valid anyway. hardlinks should not be broken when opened
for write.
This is why it might be best to leave the tests as is.
But no, it will not be fixed for OVERLAY_FS_INDEX=n kernels and
unlikely for kernel
default to become OVERLAY_FS_INDEX=y.

The way forward is for distros to change the their config to OVERLAY_FS_INDEX=y,
but there is a downside for OVERLAY_FS_INDEX=y related to copying upper layers
between file systems as described in [1].
So before distros can change the config to OVERLAY_FS_INDEX=y they need to make
sure that no tool is migrating upper layers between file systems or
copying within
a file system. If such tools exist, then they should "export/import"
the index while
migrating layers (to fix the broken file handles) and said
export/import tool does not exist yet.

[1] https://github.com/amir73il/linux/commit/9412812ef54861081904f24ddaf176b957b98d40

> can just keep the tests unchanged, just like all other tests that are
> targeting un-fixed bugs. Then the only issue is the commit log is not so
> accurate.
>
> Otherwise, I prefer your opt-in way, making these tests _notrun
> (assmuing they're not valid tests for this kernel config).

So as I explained, they are valid, but not expected to be fixed by any
change in upstream
kernel, only a change in distro kernel config.

I will post a patch to make them opt-in, because it will provide for
much better test coverage
of the new feature as long as the feature exists in tested kernel.

Thanks.
