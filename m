From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/4] overlay/017: require and enable redirect_dir
Date: Mon, 29 Jan 2018 11:25:33 +0200
Message-ID: <CAOQ4uxiBE08RwJfMNmG9XzN6Eg8uq3-3p-0mSMzPoLyauY8qAw@mail.gmail.com>
References: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
 <1516953548-15679-5-git-send-email-amir73il@gmail.com> <20180129081041.GR18267@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180129081041.GR18267@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jan 29, 2018 at 10:10 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Fri, Jan 26, 2018 at 09:59:08AM +0200, Amir Goldstein wrote:
>> This test renames a merge directory so it needs to enable redirect_dir
>> feature, which is not enabled by default.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>
> As you mentioned, I thought the failure was expected.. Thanks for the
> updates! I just made some cosmetic changes on commit.
>
>> ---
>>  tests/overlay/017   | 6 ++++--
>>  tests/overlay/group | 2 +-
>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/tests/overlay/017 b/tests/overlay/017
>> index 03955d0..e7e8925 100755
>> --- a/tests/overlay/017
>> +++ b/tests/overlay/017
>> @@ -57,6 +57,7 @@ _supported_os Linux
>>  _require_scratch
>>  _require_test_program "af_unix"
>>  _require_test_program "t_dir_type"
>> +_require_scratch_feature redirect_dir
>
> Added comments on why we require redirect_dir feature here.
>
>>
>>  rm -f $seqres.full
>>
>> @@ -111,7 +112,8 @@ function check_inode_numbers()
>>       done
>>  }
>>
>> -_scratch_mount
>> +# Enable redirect_dir for renaming a merge directory
>> +_scratch_mount -o "redirect_dir=on"
>
> Quoted the whole extra mount options here, "-o redirect_dir=on"
>

Sure. I see there are plenty cases of quoted as well as unquoted
options passed to _scratch_mount.
I must say I lean towards the unquoted flavor, but doesn't really matter.

The worst yet is that _scratch_cycle_mount are passed without -o.
Another time..

Thanks,
Amir.
