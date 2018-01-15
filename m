From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: [PATCH v3 0/7] overlay: add fsck.overlay basic tests
Date: Mon, 15 Jan 2018 12:11:00 +0800
Message-ID: <8df72a7a-14a0-55ba-b7e8-3e9e11c63429@huawei.com>
References: <20180112120533.6099-1-yi.zhang@huawei.com>
 <CAOQ4uxij64P9zOmkDR+XfEY2BC3GrMm3mihkoaM_bq41cFEqHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxij64P9zOmkDR+XfEY2BC3GrMm3mihkoaM_bq41cFEqHw@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Miao Xie <miaoxie@huawei.com>, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

On 2018/1/13 3:19, Amir Goldstein Wrote:
> On Fri, Jan 12, 2018 at 2:05 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Hi all:
>>
>> Here is the third version of test cases for the upcoming fsck.overlay,
>> corresponding to fsck.overlay v4 (will post to github repository soon).
>> Test fsck.overlay check and fix inconsistency of whiteout and redirect/impure
>> xattr.
>>
>> Changes since v2:
>> - Modify some minor suggestions from Amir and Vivek, and simplify code
>>   in all three test cases.
>> - Fix duplicate redirect xattr test in 202.
>> - Add impure xattr test case of general merge directory in 'no impure'
>>   parent directory.
>> - Fix fs check failure in other overlay fs test cases. PS: The
>>   multi-lowers problem in overlay/010 also appears in many other tests,
>>   _require_scratch() will mis-check the pre-defined underlying dirs
>>   (not the real test dirs). I think they also need to be modified as this
>>   patch(06/07) does to check the correct dirs, and I can fix them if you
>>   think necessary.
> 
> Yes, please do.
> Thinking out loud, we could use a helper _require_overlay_scratch_dirs
> for tests that use _overlay_scratch_mount_dirs and not _scratch_mount.
> That helper will actually be a wrapper to _require_scratch_nocheck, but
> with a comment that explains why, because usually,
> _require_scratch_nocheck means that test leaves filesystem corrupt
> and that is not the case here.
> 
This makes sense, will do.

Thanks,
Yi.
