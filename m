From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 6/9] overlay: configure TEST/SCRATCH vars to base fs
Date: Wed, 15 Feb 2017 16:59:29 +0200
Message-ID: <CAOQ4uxh7oxym6FfV_8f0Z6xwbEFgXkLqXVeMB_yPcRSq+-1zQA@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-7-git-send-email-amir73il@gmail.com> <20170213112824.GH24562@eguan.usersys.redhat.com>
 <CAOQ4uxjgGN5zxv-AG4qnz+46M9+JK8AaU+-1m4DTfx=YDTPc=w@mail.gmail.com> <20170214110315.GN24562@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170214110315.GN24562@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Feb 14, 2017 at 1:03 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Mon, Feb 13, 2017 at 10:31:30PM +0200, Amir Goldstein wrote:
>> On Mon, Feb 13, 2017 at 1:28 PM, Eryu Guan <eguan@redhat.com> wrote:
>> > On Sun, Feb 12, 2017 at 10:43:41PM +0200, Amir Goldstein wrote:
>> >> Instead of setting the vars TEST/SCRATCH_DEV to overlay base dirs,
>> >> allow setting them to block devices to configure the base fs partition,
>> >> where overlay dirs will be created.
>> >>
>> >> For example, the following config file can be used to run tests on
>> >> xfs test/scratch partitions:
>> >>
>> >>  TEST_DEV=/dev/sda5
>> >>  TEST_DIR=/mnt/test
>> >>  SCRATCH_DEV=/dev/sda6
>> >>  SCRATCH_MNT=/mnt/scratch
>> >>  FSTYP=xfs
>> >>
>> >> Using the same config file, but executing './check -overlay' will
>> >> use the same partitions as base fs for overlayfs directories
>> >> and set TEST_DIR/SCRATCH_MNT values to overlay mount points, i.e.:
>> >> /mnt/test/ovl-mnt and /mnt/scratch/ovl-mnt.
>> >>
>> >> The base fs should be pre-formatted and mounted when starting the test.
>> >> An upcoming change is going to support mount/umount of base fs.
>> >>
>> >> The new OVL_BASE_SCRATCH/TEST_* vars are set to point at the
>> >> overlayfs base dirs in either legacy or new config method.
>> >> Tests should always use these vars and not the legacy SCRATCH/TEST_DEV
>> >> vars when referring to overlay base dir.
>> >>
>> >> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> >> ---
>> ...
>> >>
>> >>  # Parse config section options. This function will parse all the configuration
>> >> @@ -516,6 +574,15 @@ get_next_config() {
>> >>               unset SCRATCH_DEV
>> >>       fi
>> >>
>> >> +     # We might have overriden TEST/SCRATCH vars with overlay base dir in the
>> >> +     # previous run, so restore them to original values stored in OVL_BASE_*
>> >> +     if [ "$FSTYP" == "overlay" ]; then
>> >> +             [ -z "$OVL_BASE_TEST_DEV" ] || export TEST_DEV=$OVL_BASE_TEST_DEV
>> >> +             [ -z "$OVL_BASE_TEST_DIR" ] || export TEST_DIR=$OVL_BASE_TEST_DIR
>> >> +             [ -z "$OVL_BASE_SCRATCH_DEV" ] || export SCRATCH_DEV=$OVL_BASE_SCRATCH_DEV
>> >> +             [ -z "$OVL_BASE_SCRATCH_MNT" ] || export SCRATCH_MNT=$OVL_BASE_SCRATCH_MNT
>> >> +     fi
>> >> +
>> >>       parse_config_section $1
>> >>
>> >>       if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
>> >> @@ -544,6 +611,12 @@ get_next_config() {
>> >>               export RESULT_BASE="$here/results/"
>> >>       fi
>> >>
>> >> +     # Override FSTYP from config when running ./check -overlay
>> >> +     # and maybe derive overlay TEST/SCRATCH from base fs values
>> >> +     if [ "$OVERLAY" == "true" -o "$FSTYP" == "overlay" ]; then
>> >> +             _config_overlay
>> >> +     fi
>> >> +
>> >
>> > If I have SCRATCH_DEV_POOL defined, e.g.
>> >
>> > TEST_DEV=/dev/sda5
>> > TEST_DIR=/mnt/testarea/test
>> > SCRATCH_DEV_POOL="/dev/sda6 /dev/sda7"
>> > SCRATCH_MNT=/mnt/testarea/scratch
>> >
>> > I got error like:
>> >
>> > [root@dhcp-66-86-11 xfstests]# ./check -overlay overlay/002
>> > common/config: SCRATCH_DEV (/dev/sda6) is not a directory for overlay
>> >
>> > Because we obtain SCRATCH_DEV from SCRATCH_DEV_POOL after we call
>> > _config_overlay, and SCRATCH_DEV is not set when configing overlay, so
>> > SCRATCH_DEV stays as a block device and fails _check_device.
>> >
>> > Moving the SCRATCH_DEV_POOL handling just after "unset SCRATCH_DEV"
>> > fixes this problem for me.
>
> Seems this only works for multi-section config, not standalone
> local.config file..
>
>> >
>>
>> Right, I didn't test this setup. It appears to me that SCRATCH_DEV_POOL handling
>> should be *after* parse_config_section for multi section config, where
>> SCRATCH_DEV_POOL is assigned a new value in current section??
>
> I set SCRATCH_DEV_POOL as a default var, so it's inherited by all
> sections.
>
>>
>> Can you check if SCRATCH_DEV_POOL handling could be moved right before
>> _config_overlay?
>
> No, test results show that it should be before restoring TEST_DEV/DIR
> etc. from previous run, this hunk:
>
>         # We might have overriden TEST/SCRATCH vars with overlay base dir in the
>         # previous run, so restore them to original values stored in OVL_BASE_*
>         if [ "$FSTYP" == "overlay" ]; then
>         ...
>
>>
>> I'm not really sure how that configuration should be working with
>> overlay anyway.
>
> In general, I think SCRATCH_DEV_POOL should be handled just after
> reading in configs, as what you said. But multi-section config (maybe
> and the new overlayfs config) makes things more complex, and my brain
> stops working today..
>

OK, I think I managed to wrap my head around this.
Next version is going to look simpler:
- _overlay_config_override() at the very end of get_next_config()
- _overlay_config_restore() at the very beginning of get_next_config()
