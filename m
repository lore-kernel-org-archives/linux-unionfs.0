From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/4] overlay: fix _overlay_config_override of MOUNT_OPTIONS
Date: Wed, 11 Oct 2017 15:35:58 +0300
Message-ID: <CAOQ4uxiRFnyaG94i-P6y8-3rq9z_-7wRc2kaPw8OrJ2Evb_OSQ@mail.gmail.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
 <1506495852-7295-5-git-send-email-amir73il@gmail.com> <20171011115020.GW10593@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171011115020.GW10593@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Oct 11, 2017 at 2:50 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Wed, Sep 27, 2017 at 10:04:12AM +0300, Amir Goldstein wrote:
>> The config variable OVERLAY_MOUNT_OPTIONS is used to configure
>> the overlay mount options when running ./check -overlay.
>> The config variable MOUNT_OPTIONS is used to configure the
>> mount options for base fs.
>>
>> If config sets value of OVERLAY_MOUNT_OPTIONS and
>> does not set MOUNT_OPTIONS, the value of MOUNT_OPTIONS
>> may be leftover from previous _overlay_config_override, so
>> don't use that value for base fs mount.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  common/config | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/common/config b/common/config
>> index 71798f0..8844173 100644
>> --- a/common/config
>> +++ b/common/config
>> @@ -532,6 +532,10 @@ _overlay_config_override()
>>       # Store original base fs vars
>>       export OVL_BASE_TEST_DEV="$TEST_DEV"
>>       export OVL_BASE_TEST_DIR="$TEST_DIR"
>> +     # If config does not set MOUNT_OPTIONS, its value may be
>> +     # leftover from previous _overlay_config_override, so
>> +     # don't use that value for base fs mount
>> +     [ "$MOUNT_OPTIONS" != "$OVERLAY_MOUNT_OPTIONS" ] || unset MOUNT_OPTIONS
>>       export OVL_BASE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
>
> Hmm, I don't like the idea that specify mount options for base fs
> through MOUNT_OPTIONS. With this, we can only specify overlay mount
> options via OVERLAY_MOUNT_OPTIONS but not MOUNT_OPTIONS. Ideally, I'd
> like both of them work, and OVERLAY_MOUNT_OPTIONS is assigned to
> MOUNT_OPTIONS when the latter is empty.
>
> I think MOUNT_OPTIONS and TEST_FS_MOUNT_OPTS should always be the mount
> options for filesystem we're currently testing (overlay in this case)
> not something else.
>
> OTOH, We can always specify OVL_BASE_MOUNT_OPTIONS directly for base fs
> mount options if we want.
>

It's not exactly how the base fs options work.
Right now user is never expected to configure OVL_BASE options directly
They are always inherited from a config file of another fs, so you can
run check and check -overlay with the same fs config file.

You are right that OVERLAY MOUNT OPTIONS was meant to be used for
default mount options for overlay mount options and not specifically
for check -overlay, so maybe need a new name for config options of
overlay test and scratch mounts, but I am out of ideas for good names.
It does make sense to use it in the context of check -overlay run,
because there is no other value for mount options for the overlay
mount.

> But this problem has nothing to do with this patchset, it goes back to
> the time when overlay supports base test/scratch dev, so I'm fine with
> this patch going in right now.
>
> Thanks,
> Eryu
>
>>
>>       # Set TEST vars to overlay base and mount dirs inside base fs
>> --
>> 2.7.4
>>
