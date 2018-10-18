Return-Path: <yizhang089@gmail.com>
Return-Path: <yizhang089@gmail.com>
Subject: Re: [PATCH v2 1/4] overlay: correct fsck.overlay exit code
References: <20181016074559.24728-1-yi.zhang@huawei.com>
 <20181016074559.24728-2-yi.zhang@huawei.com>
 <CAOQ4uxh8YWXprDPp1H6Si+L1QXBwcTp1+P78MqYZD5wMzuJopg@mail.gmail.com>
 <25d4f255-7dd0-cfe6-3c33-556365de2c68@huawei.com>
 <CAOQ4uxjrf8mcUtcxwmhpg4Y4m3u0PXC2QNc+s3tkUiPN3anzvw@mail.gmail.com>
From: zhangyi <yizhang089@gmail.com>
Message-ID: <66460ae9-3552-5730-9970-70f229475a5e@gmail.com>
Date: Fri, 19 Oct 2018 00:22:53 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjrf8mcUtcxwmhpg4Y4m3u0PXC2QNc+s3tkUiPN3anzvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Amir Goldstein <amir73il@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>
Cc: fstests <fstests@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/10/18 12:37, Amir Goldstein Wrote:

> On Thu, Oct 18, 2018 at 5:37 AM zhangyi (F) <yi.zhang@huawei.com> wrote:
>> On 2018/10/16 17:45, Amir Goldstein Wrote:
>>> On Tue, Oct 16, 2018 at 10:32 AM zhangyi (F) <yi.zhang@huawei.com> wrote:
> [...]
>>> Please consider the name _overlay_repair_dirs() with reference to
>>> _repair_scratch_fs(), which is used for roughly the same purpose.
>>>
>> _run_check_fsck() is helper used to test fsck and may expect to return
>> "error" exit code when we do exception tests(see patch 4), but
>> _repair_scratch_fs() always want to return "correct" exit code.
>>
> Right. so perhaps we need _overlay_repair_dirs() as a convenience
> helper for things like the stress test and also related to another
> comment about expecting return 0 is too fragile.
>
>>> BTW, the tests generic/330 generic/332 when run with -overlay
>>> over xfs with reflink support seem to call _repair_scratch_fs() which does:
>>>          # Let's hope fsck -y suffices...
>>>          fsck -t $FSTYP -y $SCRATCH_DEV 2>&1
>>>          local res=$?
>>>          case $res in
>>>          0|1|2)
>>>                  res=0
>>>                  ;;
>>>          *)
>>>                  _dump_err2 "fsck.$FSTYP failed, err=$res"
>>>
>>> How come fsck.overlay is not complaining about missing arguments??
>>>
>>> The rest of the generic tests that call _repair_scratch_fs() have
>>> _require_dm_target() which _require_block_device(), so don't run with overlay.
>>>
>>> If you do sort this out and add overlay support to
>>> _repair_scratch_fs() its probably
>>> worth replacing 0|1|2) with FSCK_ constants.
>>>
>> Thanks for pointing this out, I think we do something like below can fix
>> this problem, what do you think?
> I am puzzled about why those tests do NOT fail when fsck.overlay is given
> incorrect args??
>
Oh, it's _dump_err2() helper's fault, it should be

--- a/common/rc
+++ b/common/rc
@@ -98,7 +98,7 @@ _dump_err_cont()
  _dump_err2()
  {
      _err_msg="$*"
-    >2& echo "$_err_msg"
+    >&2 echo "$_err_msg"
  }

Thanks,
Yi.
