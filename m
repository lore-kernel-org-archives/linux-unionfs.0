From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v2 3/3] generic/470: add syncfs test
Date: Mon, 11 Dec 2017 21:20:23 +0800
Message-ID: <A12DE421-2BE7-40A1-BDEB-15BA87ED3143@icloud.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
 <1512613327-218016-3-git-send-email-cgxu519@icloud.com>
 <20171207054418.GC2749@eguan.usersys.redhat.com>
 <423B3F2E-73F1-4B29-93D7-BC6F1AA6CCC6@icloud.com>
 <20171207071317.GE2749@eguan.usersys.redhat.com>
 <EB49C2D0-6500-4588-803F-40F4B9FA6DE3@icloud.com>
 <CAOQ4uxgiqZBKUksWv-0gomKP4Ov7NB6zUw2TdnzUz7x6VUcpUw@mail.gmail.com>
 <E541A51A-D9B3-4596-8222-453132512449@icloud.com>
 <CAOQ4uxjxtGd1+empZGX3OMXnYQoZ1YvL-HmKBUh3CBgFs2F1Aw@mail.gmail.com>
 <A23C2505-1097-4331-8290-F333FB57D464@icloud.com>
 <CAOQ4uxgjJzbFq92jfkRguU-JQftb57SfTqt-f5NPaLip2LVjNg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:48635 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752841AbdLKNUh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Dec 2017 08:20:37 -0500
In-reply-to: <CAOQ4uxgjJzbFq92jfkRguU-JQftb57SfTqt-f5NPaLip2LVjNg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2017=C4=EA12=D4=C211=C8=D5=A3=AC=CF=C2=CE=E78:44=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Mon, Dec 11, 2017 at 2:33 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>=20
>>> =D4=DA 2017=C4=EA12=D4=C211=C8=D5=A3=AC=CF=C2=CE=E76:46=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Mon, Dec 11, 2017 at 12:03 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>>>=20
>>>>> =D4=DA 2017=C4=EA12=D4=C27=C8=D5=A3=AC=CF=C2=CE=E74:17=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>> [...]
>>>>=20
>>>> I did more detail tests for three different data modes of ext4 and =
found
>>>> the overlayfs syncfs bug is reproducible on data=3Dordered and =
data=3Dwriteback,
>>>> but on data=3Djournal mode, data is flushed and correct.
>>>=20
>>> That is expected, because overlayfs does call upper's sync_fs() =
method and
>>> for journal=3Ddata that will flush all dirty pages as well.
>>>=20
>>>> I only wrote only a few words
>>>> to a single file and the bug is always reproducible on my test =
environment.
>>>>=20
>>>> For writeback interferences, AFAIK, from dirty ratio and period.
>>>> If we drop all dirty caches & sync before the test, I think we can
>>>> avoid interference from it.
>>>>=20
>>>=20
>>> Why? does either drop_caches or sync() reset the flusher thread
>>> periodic flush dirty pages?
>>=20
>> Sorry=A3=ACWe have to finish test in 30 seconds after we write test =
file,
>> otherwise may be affected by background flusher.
>>=20
>>=20
>>>=20
>>>> So if we don=A1=AFt have anything else to interference test result,
>>>> I just want to modify to write a small single file as test target.
>>>>=20
>>>> Am I missing anything?
>>>=20
>>> I think the chance of flusher thread interfering the test and
>>> flushing the dirty page you wrote before _scratch_shutdown exists,
>>> but is small enough so we can neglect it and keep the test as simple
>>> as possible.
>>=20
>> As I know, in normal case flusher thread check dirty inode expiring =
every 5 seconds(default) and flush dirty
>> inode when expires 30 seconds(default). If we can finish test in 30s =
after running test, it would be OK.
>> What do you think?
>>=20
>=20
> 5 seconds is ext4 default journal commit interval. this is when dirty
> metadata will be flushed.
> 30 is generic flusher thread interval.
> What if test started 29 seconds after last flush?

Maybe we have misunderstanding about the flushing intervals.
I=A1=AFm saying the intervals which are under /proc/sys/vm to control=20
writeback behaviors, it seems not related to any specific filesystem=20
like ext4 or others.

dirty_expire_interval
default:3000(millisecond)

dirty_writeback_interval
default:500(millisecond)

Anyway, let me modify test case base on our discussion.


>=20
> I am saying that the chances of interference from flusher thread are =
quite
> if the test is very quick.
>=20
> If you create files and sync at the start of the test, overlayfs
> syncfs will call
> ext4 sync_fs and that will have nothing to do, because no metadata is =
dirty,
> so test will be quick and we can neglect that change of interference.
>=20
> *If* you wish to reduce that chance for interference loop the test =
twice, but
> I don't think that's a must.
>=20
> Amir.
