Return-Path: <yi.zhang@huawei.com>
Subject: Re: [xfstests PATCH v5 2/5] overlay: hook filesystem check helper
References: <20180301121347.5824-1-yi.zhang@huawei.com>
 <20180301121347.5824-3-yi.zhang@huawei.com>
 <CAOQ4uxhAsV6-ENGrSrHNE+Ho8_N8+msGbWy8vBCkZXmeEabTYQ@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <f3d16204-701d-6aad-4f07-0f3824ae0bcc@huawei.com>
Date: Thu, 1 Mar 2018 21:11:26 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhAsV6-ENGrSrHNE+Ho8_N8+msGbWy8vBCkZXmeEabTYQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/3/1 21:03, Amir Goldstein Wrote:
> On Thu, Mar 1, 2018 at 2:13 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Hook filesystem check helper to _check_test_fs and _check_scratch_fs
>> for checking consistency of underlying dirs of overlay filesystem.
>> These helpers works only if fsck.overlay exists.
>>
>> This patch introduce OVERLAY_FSCK_OPTIONS use for check overlayfs like
>> OVERLAY_MOUNT_OPTIONS, and also introduce a mount point check helper in
>> common/rc to detect a dir is a mount point or not.
>>
>> [ _check_test_fs/_check_scratch_fs part picked from Amir's patch, thanks ]
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  README.overlay | 10 ++++--
>>  common/config  |  4 +++
>>  common/overlay | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  common/rc      | 18 +++++++++--
>>  4 files changed, 127 insertions(+), 4 deletions(-)
>>
>> diff --git a/README.overlay b/README.overlay
>> index dfb8234..3cbefab 100644
>> --- a/README.overlay
>> +++ b/README.overlay
>> @@ -22,6 +22,10 @@ the base fs should be pre-formatted before starting the -overlay run.
>>  An easy way to accomplish this is by running './check <some test>' once,
>>  before running './check -overlay'.
>>
>> +'./check -overlay' support check overlay test and scratch dirs,
>> +OVERLAY_FSCK_OPTIONS should be set instead of FSCK_OPTIONS if fsck
>> +options need to given directly.
>> +
>>  Because of the lack of mkfs support, multi-section config files are only
>>  partly supported with './check -overlay'. Only multi-section files that
>>  do not change FSTYP and MKFS_OPTIONS can be safely used with -overlay.
>> @@ -40,7 +44,9 @@ run overlay tests on the same base fs, but with different mount options:
>>   MOUNT_OPTIONS="-o pquota"
>>   TEST_FS_MOUNT_OPTS="-o noatime"
>>   OVERLAY_MOUNT_OPTIONS="-o redirect_dir=off"
>> + OVERLAY_FSCK_OPTIONS="-n redirect_dir=off"
> 
> typo for the phony options. I believe it is going to be:  "-n -o
> redirect_dir=off"

Oh, sorry for the mistake, it is "-n -o redirect_dir=off"

Thanks,
Yi.
