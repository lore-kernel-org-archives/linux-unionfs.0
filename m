From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/5] overlay/017: silence test output
Date: Fri, 28 Apr 2017 08:45:22 +0300
Message-ID: <CAOQ4uxiQ__f4eoZT+qyszHPK7KwuW+NbDfFz3E=d6+nkSEKVRg@mail.gmail.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
 <1493305775-12559-2-git-send-email-amir73il@gmail.com> <20170428053633.GL26397@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35965 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932428AbdD1FpX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 01:45:23 -0400
In-Reply-To: <20170428053633.GL26397@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Fri, Apr 28, 2017 at 8:36 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Thu, Apr 27, 2017 at 06:09:31PM +0300, Amir Goldstein wrote:
>> Change test to output golden silence on success.
>
> Some words on why this change is needed would be good.
>
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  tests/overlay/017     | 4 +++-
>>  tests/overlay/017.out | 7 +------
>>  2 files changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/tests/overlay/017 b/tests/overlay/017
>> index 5ca3040..d6ba2ae 100755
>> --- a/tests/overlay/017
>> +++ b/tests/overlay/017
>> @@ -89,11 +89,13 @@ done
>>
>>  # find by inode number - expect to find file by inode number
>>  cat $tmp.before | while read ino f; do
>> -     find $f -inum $ino -maxdepth 0 | _filter_scratch
>> +     find $SCRATCH_MNT/ -inum $ino -maxdepth 1 | grep -q $f || \
>> +             echo "$f not found by ino $ino"
>
> Hmm, if I run this find command manually, I got warning about -maxdepth
> position.
>
> # find `pwd` -inum 3932421 -maxdepth 1
> find: warning: you have specified the -maxdepth option after a non-option argument -inum, but options are not positional (-maxdepth affects tests specified before it as well as those specified after it).  Please specify options before other arguments.
>
> /root/xfstests/check
>
> Move -maxdepth option just after find path works fine
>
> # find `pwd` -maxdepth 1 -inum 3932421
> /root/xfstests/check
>
> But I'm not sure why I didn't see this warning by running overlay/017..

man find...

"The default behavior corresponds to -warn if standard input is a tty,
and to -nowarn otherwise."

> Anyway, moving -maxdepth around seems better to me.
>

Sure.
