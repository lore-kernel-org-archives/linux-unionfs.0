From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 3/3] generic/470: add syncfs test
Date: Mon, 11 Dec 2017 16:47:46 +0200
Message-ID: <CAOQ4uxjSiCpECrBTkbx3mXJFfAe_Fc00a4GgSA4v_higJGpGKw@mail.gmail.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
 <1512613327-218016-3-git-send-email-cgxu519@icloud.com> <20171207054418.GC2749@eguan.usersys.redhat.com>
 <423B3F2E-73F1-4B29-93D7-BC6F1AA6CCC6@icloud.com> <20171207071317.GE2749@eguan.usersys.redhat.com>
 <EB49C2D0-6500-4588-803F-40F4B9FA6DE3@icloud.com> <CAOQ4uxgiqZBKUksWv-0gomKP4Ov7NB6zUw2TdnzUz7x6VUcpUw@mail.gmail.com>
 <E541A51A-D9B3-4596-8222-453132512449@icloud.com> <CAOQ4uxjxtGd1+empZGX3OMXnYQoZ1YvL-HmKBUh3CBgFs2F1Aw@mail.gmail.com>
 <A23C2505-1097-4331-8290-F333FB57D464@icloud.com> <CAOQ4uxgjJzbFq92jfkRguU-JQftb57SfTqt-f5NPaLip2LVjNg@mail.gmail.com>
 <A12DE421-2BE7-40A1-BDEB-15BA87ED3143@icloud.com> <84CB13E7-34AD-4782-A6A5-1A82A826D352@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:35510 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdLKOrs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Dec 2017 09:47:48 -0500
In-Reply-To: <84CB13E7-34AD-4782-A6A5-1A82A826D352@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Dec 11, 2017 at 4:31 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>
>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=8811=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=88=
9:20=EF=BC=8CChengguang Xu <cgxu519@icloud.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>>>
>>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=8811=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=
=888:44=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=
=BC=9A
>>>
>>> On Mon, Dec 11, 2017 at 2:33 PM, Chengguang Xu <cgxu519@icloud.com> wro=
te:
>>>>>
>>>>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=8811=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=
=886:46=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=
=BC=9A
>>>>>
>>>>> On Mon, Dec 11, 2017 at 12:03 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>>>>>
>>>>>>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=887=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=
=8D=884:17=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=
=EF=BC=9A
>>>>> [...]
>>>>>>
>>>>>> I did more detail tests for three different data modes of ext4 and f=
ound
>>>>>> the overlayfs syncfs bug is reproducible on data=3Dordered and data=
=3Dwriteback,
>>>>>> but on data=3Djournal mode, data is flushed and correct.
>>>>>
>>>>> That is expected, because overlayfs does call upper's sync_fs() metho=
d and
>>>>> for journal=3Ddata that will flush all dirty pages as well.
>>>>>
>>>>>> I only wrote only a few words
>>>>>> to a single file and the bug is always reproducible on my test envir=
onment.
>>>>>>
>>>>>> For writeback interferences, AFAIK, from dirty ratio and period.
>>>>>> If we drop all dirty caches & sync before the test, I think we can
>>>>>> avoid interference from it.
>>>>>>
>>>>>
>>>>> Why? does either drop_caches or sync() reset the flusher thread
>>>>> periodic flush dirty pages?
>>>>
>>>> Sorry=EF=BC=8CWe have to finish test in 30 seconds after we write test=
 file,
>>>> otherwise may be affected by background flusher.
>>>>
>>>>
>>>>>
>>>>>> So if we don=E2=80=99t have anything else to interference test resul=
t,
>>>>>> I just want to modify to write a small single file as test target.
>>>>>>
>>>>>> Am I missing anything?
>>>>>
>>>>> I think the chance of flusher thread interfering the test and
>>>>> flushing the dirty page you wrote before _scratch_shutdown exists,
>>>>> but is small enough so we can neglect it and keep the test as simple
>>>>> as possible.
>>>>
>>>> As I know, in normal case flusher thread check dirty inode expiring ev=
ery 5 seconds(default) and flush dirty
>>>> inode when expires 30 seconds(default). If we can finish test in 30s a=
fter running test, it would be OK.
>>>> What do you think?
>>>>
>>>
>>> 5 seconds is ext4 default journal commit interval. this is when dirty
>>> metadata will be flushed.
>>> 30 is generic flusher thread interval.
>>> What if test started 29 seconds after last flush?
>>
>> Maybe we have misunderstanding about the flushing intervals.
>> I=E2=80=99m saying the intervals which are under /proc/sys/vm to control
>> writeback behaviors, it seems not related to any specific filesystem
>> like ext4 or others.
>>
>> dirty_expire_interval
>> default:3000(millisecond)
>>
>> dirty_writeback_interval
>> default:500(millisecond)
>
> Correction:
>
> dirty_expire_interval
> default:3000(centiseconds)
>
> dirty_writeback_interval
> default:500(centiseconds)
>
>

Right. I was confusing the 2 different tunables.
I agree your test should be fine with simple small write after sync
in an isolated test environment.

Amir.
