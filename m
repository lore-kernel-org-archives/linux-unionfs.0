From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/5] fstests: implement require of multiple overlayfs features
Date: Mon, 29 Jan 2018 19:06:23 +0200
Message-ID: <CAOQ4uxje2W0_xR+DD257BjgR=JPQbyDK9AjLvBfdi-mzmy2ndw@mail.gmail.com>
References: <1517131356-8048-1-git-send-email-amir73il@gmail.com>
 <1517131356-8048-2-git-send-email-amir73il@gmail.com> <20180129143307.GV18267@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180129143307.GV18267@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jan 29, 2018 at 4:33 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Sun, Jan 28, 2018 at 11:22:32AM +0200, Amir Goldstein wrote:
>> Some overlayfs features must be checked together, because they cannot
>> be enabled without a dependent feature (e.g. nfs_export and index).
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  common/overlay | 23 ++++++++++++++++++++---
>>  common/rc      | 15 +++++++++------
>>  2 files changed, 29 insertions(+), 9 deletions(-)
>>
>> diff --git a/common/overlay b/common/overlay
>> index 1da4ab1..38fe994 100644
>> --- a/common/overlay
>> +++ b/common/overlay
>> @@ -138,9 +138,6 @@ _require_scratch_overlay_feature()
>>       [ "$default" = Y ] || [ "$default" = N ] || \
>>               _notrun "feature '${feature}' not supported by ${FSTYP}"
>>
>> -     _scratch_mkfs > /dev/null 2>&1
>> -     _scratch_mount -o ${feature}=on || \
>> -             _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
>
> So _require_scratch_overlay_feature can't be used by any test directly
> now and should only be called by _require_scratch_overlay_features.
>
> IMHO, the name _require_scratch_overlay_feature becomes misleading after
> this change, it implies it can be called by tests directly. I'd rename
> it to a more proper name (which I can't think of any..) with double
> underscores at the beginning to imply it's kind of "static", e.g. the
> internal helpers like "__populate_create_dir" in common/populate.

__check_one_scratch_overlay_feature

>
> Another way to go is just open-code this in
> _require_scratch_overlay_features().
>
>>       # Check options to be sure. For example, Overlayfs will fallback to
>>       # index=off if underlying fs does not support file handles.
>>       # Overlayfs only displays mount option if it differs from the default.
>> @@ -149,5 +146,25 @@ _require_scratch_overlay_feature()
>>         ( [ "$default" = Y ] && ! _fs_options $SCRATCH_DEV | grep -q "${feature}=off" )) && \
>>           touch $SCRATCH_MNT/foo 2>/dev/null ) || \
>>               _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
>> +}
>> +
>> +# Require a set of overlayfs features
>> +_require_scratch_overlay_features()
>> +{
>> +     local features=( $* )
>> +     local opts="rw"
>> +
>> +     for feature in ${features[*]}; do
>> +             opts+=",${feature}=on"
>> +     done
>> +
>> +     _scratch_mkfs > /dev/null 2>&1
>> +     _scratch_mount -o $opts || \
>> +             _notrun "overlay options '$opts' cannot be enabled on ${SCRATCH_DEV}"
>> +
>> +     for feature in ${features[*]}; do
>> +             _require_scratch_overlay_feature ${feature}
>> +     done
>> +
>>       _scratch_unmount
>>  }
>> diff --git a/common/rc b/common/rc
>> index 77a4eb4..3b81061 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -3658,22 +3658,25 @@ _get_fs_sysfs_attr()
>>       cat /sys/fs/${FSTYP}/${dname}/${attr}
>>  }
>>
>> -# Generic test for specific filesystem feature.
>> +# Generic test for specific filesystem features.
>>  # Currently only implemented to test overlayfs features.
>> -_require_scratch_feature()
>> +_require_scratch_features()
>>  {
>> -     local feature=$1
>> -
>>       case "$FSTYP" in
>>       overlay)
>> -             _require_scratch_overlay_feature ${feature}
>> +             _require_scratch_overlay_features $*
>>               ;;
>>       *)
>> -             _fail "Test for feature '${feature}' of ${FSTYP} is not implemented"
>> +             _fail "Test for features '$*' of ${FSTYP} is not implemented"
>>               ;;
>>       esac
>>  }
>>
>> +_require_scratch_feature()
>> +{
>> +     _require_scratch_features $1
>> +}
>> +
>
> Hmm, I don't think this is necessary. Just drop all the plural variants
> and teach _require_scratch_overlay_feature to accept & test multiple
> features, and add some good comments.
>

I see what you are saying, but I rather call a function called
_require_scratch_overlay_features from the tests that require plural features
I can leave _require_scratch_feature for the singular feature case though,
until another filesystem needs the plural variant.

Thanks,
Amir.
